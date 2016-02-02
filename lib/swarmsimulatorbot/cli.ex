defmodule Swarmsimulatorbot.Cli do
  @tick 1_000
  @screenshot_tick 60_000

  def start do
    spawn __MODULE__, :main, []
  end

  def main do
    bot_pid = spawn(Swarmsimulatorbot, :start, [])
    :timer.send_interval(@tick, bot_pid, {:grow})
    :timer.send_interval(@screenshot_tick, bot_pid, {:screenshot, "growing.png"})
  end

end
