defmodule SwarmsimulatorbotTest do
  use ExUnit.Case
  use Hound.Helpers
  doctest Swarmsimulatorbot

  test "Initial number of units should be three" do
    Swarmsimulatorbot.start
    assert length(Swarmsimulatorbot.units) == 3
    Swarmsimulatorbot.stop
  end

  test "having 0 drones at the beginning" do
    Swarmsimulatorbot.start
    text = Swarmsimulatorbot.units
    |> Enum.at(2)
    |> inner_text

    assert text =~ ~r/Drone.*0/
    Swarmsimulatorbot.stop
  end
end
