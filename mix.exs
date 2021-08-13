defmodule Shipment.MixProject do
  use Mix.Project

  def project do
    [
      app: :shipment,
      escript: escript_config(),
      default_task: "escript.build",
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"}
    ]
  end

  defp escript_config do
    [main_module: Shipment.Cli]
  end
end
