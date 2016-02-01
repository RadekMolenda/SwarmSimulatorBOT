defmodule SwarmsimulatorbotTest do
  use ExUnit.Case
  doctest Swarmsimulatorbot

  test "Initial number of units" do
    Swarmsimulatorbot.start
    assert length(Swarmsimulatorbot.units) == 3
    Swarmsimulatorbot.stop
  end
end
