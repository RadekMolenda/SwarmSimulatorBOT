defmodule Swarmsimulatorbot do
  use Hound.Helpers

  @swarm_url "https://swarmsim.github.io/"

  def start do
    Hound.start_session
    navigate_to(@swarm_url)
    execute_script("localStorage.clear()");
    :ok
  end

  def stop do
    Hound.end_session
    :ok
  end

  def dummy_grow do
    units_size = length(units) - 1
    Enum.each(0..(units_size), fn(_) ->
      units
      |> List.last
      |> find_within_element(:tag, "a")
      |> click

      find_all_elements(:css, ".btn")
      |> List.last
      |> click
    end)
  end

  def screenshot(path) do
    take_screenshot("screenshots/#{path}")
  end

  def units do
    show_all_units
    find_all_elements(:css, ".unit-table tr")
  end

  defp show_all_units do
    click_on_text("More...")
    click_on_text("Show all units")
  end

  defp click_on_text(text) do
    find_element(:link_text, text) |> click
  end
end
