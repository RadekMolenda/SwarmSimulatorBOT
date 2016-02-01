defmodule Swarmsimulatorbot.Mixfile do
  use Mix.Project

  def project do
    [app: :swarmsimulatorbot,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :hound]]
  end

  defp deps do
    [
      {:hound, "~> 0.8"}
    ]
  end
end
