defmodule SwarmsimulatorbotTest do
  use ExUnit.Case
  use Hound.Helpers

  test "Initial number of units should be three" do
    Swarmsimulatorbot.start_link
    assert length(Swarmsimulatorbot.units) == 3
    Swarmsimulatorbot.stop
  end

  test "having 0 drones at the beginning" do
    Swarmsimulatorbot.start_link
    drone_text = Swarmsimulatorbot.units
    |> Enum.at(2)

    assert drone_text =~ ~r/Drone.*0/
    Swarmsimulatorbot.stop
  end

  test "screenshot" do
    Swarmsimulatorbot.start_link
    f = "screenshots/test.png"
    Swarmsimulatorbot.screenshot("test.png")
    assert File.exists?(f)
    File.rm(f)
    Swarmsimulatorbot.stop
  end

  test "#dummy_grow grows the swarm" do
    Swarmsimulatorbot.start_link
    Swarmsimulatorbot.dummy_grow
    drone_text = Swarmsimulatorbot.units
    |> Enum.at(2)

    assert drone_text =~ ~r/Drone.*3/
    Swarmsimulatorbot.stop
  end
end
