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
    units_size = length(units) - 1
    Enum.each(0..(units_size), fn(index) ->
      units
      |> Enum.at(index)
      |> find_within_element(:tag, "a")
      |> click

      active_buttons
      |> List.last
      |> click
    end)
  end

  def active_buttons do
    find_all_elements(:css, "a:not(.disabled).btn")
  end

  def screenshot(path) do
    GenServer.cast(__MODULE__, {:screenshot, path})
  end

  def units do
    GenServer.call(__MODULE__, :units)
  end

  defp show_all_units do
    click_on_text("More...")
    click_on_text("Show all units")
  end

  defp click_on_text(text) do
    find_element(:link_text, text) |> click
  end

  def handle_call(:units, _from, state) do
    show_all_units
    all_units = find_all_elements(:css, ".unit-table tr")
    |> Enum.map(&inner_text/1)
    { :reply, all_units, state }
  end
  def handle_cast({:screenshot, path}, state) do
    show_all_units
    take_screenshot("screenshots/#{path}")
    { :noreply, state }
  end

end
