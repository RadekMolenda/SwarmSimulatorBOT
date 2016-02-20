defmodule SwarmsimulatorbotTest do
  use ExUnit.Case

  test "screenshot" do
    f = "screenshots/test.png"
    Swarmsimulatorbot.screenshot("test.png")
    assert File.exists?(f)
    File.rm(f)
    Swarmsimulatorbot.stop
  end
end
