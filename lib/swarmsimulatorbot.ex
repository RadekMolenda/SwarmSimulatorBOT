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
