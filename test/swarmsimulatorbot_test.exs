defmodule SwarmsimulatorbotTest do
  use ExUnit.Case

  test "Initial number of units should be three" do
    assert length(Swarmsimulatorbot.units) == 3
    Swarmsimulatorbot.stop
  end

  test "screenshot" do
    f = "screenshots/test.png"
    Swarmsimulatorbot.screenshot("test.png")
    assert File.exists?(f)
    File.rm(f)
    Swarmsimulatorbot.stop
  end
end
