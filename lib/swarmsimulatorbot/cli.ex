defmodule Swarmsimulatorbot.Cli do
  @tick 1000
  @screenshot_tick 10000

  def start do
    spawn_link __MODULE__, :main, []
  end

  def main do
    bot_pid = Swarmsimulatorbot.start
    :timer.send_interval(@tick, bot_pid, {:grow})
    :timer.send_interval(@screenshot_tick, bot_pid, {:screenshot, "growing.png"})
    bot_pid
  end

end
