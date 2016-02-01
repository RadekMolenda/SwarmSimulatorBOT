defmodule SwarmsimulatorbotTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Swarmsimulatorbot

  setup_all do
    HTTPoison.start
  end


  test "Initial number of units" do
    use_cassette "start" do
      assert length(Swarmsimulatorbot.units) == 3
    end
  end
end
