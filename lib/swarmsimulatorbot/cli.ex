defmodule Swarmsimulatorbot.Cli do
  @tick 1000
  @screenshot_tick 10000

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :grow, 1)
    Process.send_after(self(), :screenshot, 1)
    {:ok, nil}
  end

  def handle_info(:grow, state) do
    Swarmsimulatorbot.dummy_grow
    Process.send_after(self(), :grow, @tick)
    {:noreply, state}
  end

  def handle_info(:screenshot, state) do
    Swarmsimulatorbot.screenshot("growing.png")
    Process.send_after(self(), :screenshot, @screenshot_tick)
    {:noreply, state}
  end
end
