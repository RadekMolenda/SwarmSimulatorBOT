defmodule Swarmsimulatorbot do
  use Hound.Helpers
  use GenServer

  @swarm_url "https://swarmsim.github.io"
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
    GenServer.call(__MODULE__, :dummy_grow, :infinity)
  end

  def screenshot(path) do
    GenServer.call(__MODULE__, {:screenshot, path}, :infinity)
  end

  def save do
    GenServer.call(__MODULE__, :save, :infinity)
  end

  def load_game do
    GenServer.call(__MODULE__, :load_game, :infinity)
  end

  def handle_call(:load_game, _from, state) do
    if File.exists?(@save_file) do
      go_to(:options)
      load_saved_data
    end
    { :reply, nil, state }
  end

  def handle_call(:save, _from, state) do
    go_to(:options)
    export_saved_data
    {:reply, nil, state}
  end

  def handle_call(:dummy_grow, _from, state) do
    go_to(:all_units)
    all_units = find_all_elements(:css, ".unit-table tr")
    units_size = length(all_units) - 1
    Enum.each(0..(units_size), fn(index) ->
      go_to(:all_units)
      find_all_elements(:css, ".unit-table tr")
      |> Enum.at(index)
      |> find_within_element(:tag, "a")
      |> click

      active_buttons
      |> List.last
      |> click
    end)
    { :reply, nil, state }
  end

  def handle_call({:screenshot, path}, _from, state) do
    go_to(:all_units)
    take_screenshot("screenshots/#{path}")
    { :reply, nil, state }
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

  defp load_saved_data do
    import_data
    |> import_to_game
  end

  defp import_data do
    File.read! @save_file
  end

  defp import_to_game(data) do
    execute_script("$('#export').val('#{data}')")

    find_element(:id, "export")
    |> input_into_field(" ")
  end

  defp go_to(:options) do
    click_on_text("More...")
    click_on_text("Options")
  end
  defp go_to(:all_units) do
    click_on_text("More...")
    click_on_text("Show all units")
  end

  defp click_on_text(text) do
    find_element(:link_text, text) |> click
  end
end
