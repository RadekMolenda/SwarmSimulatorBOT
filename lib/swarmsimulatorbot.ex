defmodule Swarmsimulatorbot do
  use Hound.Helpers
  use GenServer

  @swarm_url "https://swarmsim.github.io/"

  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Hound.start_session
    navigate_to(@swarm_url)
    execute_script("localStorage.clear()");
    { :ok, __MODULE__ }
  end

  def stop do
    Hound.end_session
  end

  defp loop do
    receive do
      {:screenshot, path} ->
        screenshot(path)
        loop
      {:grow} ->
        dummy_grow
        loop
      {:stop} ->
        stop
    end
  end

  def dummy_grow do
    GenServer.call(__MODULE__, :dummy_grow)
  end

  def screenshot(path) do
    GenServer.call(__MODULE__, {:screenshot, path})
  end

  def units do
    GenServer.call(__MODULE__, :units)
  end

  def handle_call(:dummy_grow, _from, state) do
    show_all_units
    all_units = find_all_elements(:css, ".unit-table tr")
    units_size = length(all_units) - 1
    Enum.each(0..(units_size), fn(index) ->
      show_all_units
      find_all_elements(:css, ".unit-table tr")
      |> Enum.at(index)
      |> find_within_element(:tag, "a")
      |> click

      active_buttons
      |> List.last
      |> click
    end)
    { :reply, all_units, state }
  end
  def handle_call(:units, _from, state) do
    show_all_units
    all_units = find_all_elements(:css, ".unit-table tr")
    |> Enum.map(&inner_text/1)
    { :reply, all_units, state }
  end
  def handle_call({:screenshot, path}, _from, state) do
    show_all_units
    { :reply, take_screenshot("screenshots/#{path}"), state }
  end

  defp show_all_units do
    click_on_text("More...")
    click_on_text("Show all units")
  end

  defp click_on_text(text) do
    find_element(:link_text, text) |> click
  end

  defp active_buttons do
    find_all_elements(:css, "a:not(.disabled).btn")
  end
end
