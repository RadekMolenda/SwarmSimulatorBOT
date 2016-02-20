defmodule Swarmsimulatorbot do
  use Hound.Helpers
  use GenServer

  @swarm_url "https://swarmsim.github.io"
  @all_units "#{@swarm_url}/#/tab/all"
  @options "#{@swarm_url}/#/options"
  @save_file "save/save.dat"

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_args) do
    Hound.start_session()
    navigate_to(@swarm_url)
    { :ok, __MODULE__ }
  end

  def stop do
    Hound.end_session
  end

  def dummy_grow do
    GenServer.cast(__MODULE__, :dummy_grow)
  end

  def screenshot(path) do
    GenServer.cast(__MODULE__, {:screenshot, path})
  end

  def save do
    GenServer.cast(__MODULE__, :save)
  end

  def handle_cast(:save, state) do
    navigate_to(@options)
    export_saved_data
    {:noreply, state}
  end

  def handle_cast(:dummy_grow, state) do
    navigate_to(@all_units)
    all_units = find_all_elements(:css, ".unit-table tr")
    units_size = length(all_units) - 1
    Enum.each(0..(units_size), fn(index) ->
      navigate_to(@all_units)
      find_all_elements(:css, ".unit-table tr")
      |> Enum.at(index)
      |> find_within_element(:tag, "a")
      |> click

      active_buttons
      |> List.last
      |> click
    end)
    { :noreply, state }
  end

  def handle_cast({:screenshot, path}, state) do
    navigate_to(@all_units)
    take_screenshot("screenshots/#{path}")
    { :noreply, state }
  end

  defp active_buttons do
    find_all_elements(:css, "a:not(.disabled).btn")
  end

  defp export_saved_data do
    export_field_value
    |> save_to_file
  end

  defp export_field_value do
    find_element(:id, "export")
    |> attribute_value("value")
  end

  defp save_to_file(value) do
    {:ok, file} = File.open @save_file, [:write]
    IO.binwrite file, value
    File.close(file)
    :ok
  end
end
