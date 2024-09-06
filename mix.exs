defmodule Avifixir.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :avifixir,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
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
      {:mogrify, "~> 0.9.3"},
      {:progress_bar, ">0.0.0"}
    ]
  end

  defp escript do
    [
      main_module: Avifixir.CLI
    ]
  end
end
