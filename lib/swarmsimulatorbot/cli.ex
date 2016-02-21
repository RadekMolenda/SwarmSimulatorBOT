defmodule Swarmsimulatorbot.Cli do
  @tick Application.get_env(:swarmsimulatorbot, :tick)

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Swarmsimulatorbot.load_game
    Process.send_after(self(), :tick, @tick)
    {:ok, nil}
  end

  def handle_info(:tick, state) do
    Swarmsimulatorbot.save
    Swarmsimulatorbot.dummy_grow
    Swarmsimulatorbot.screenshot("growing.png")
    Process.send_after(self(), :tick, @tick)
    { :noreply, state }
  end
end
