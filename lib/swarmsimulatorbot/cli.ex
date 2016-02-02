defmodule Swarmsimulatorbot.Cli do
  @tick 1_000
  @screenshot_tick 60_000

  def main do
    bot_pid = spawn(Swarmsimulatorbot, :start, [])
  end

end
