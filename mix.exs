defmodule Excontentful.MixProject do
  use Mix.Project

  def project do
    [
      app: :excontentful,
      version: "0.1.0",
      elixir: ">= 1.5.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "An interface for the Contentful API",
      name: "Excontentful",
      source_url: "https://github.com/norbu09/excontentful"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tesla, :poison, :con_cache],
      mod: {Excontentful.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla,  ">= 0.10.0"},
      {:poison, ">= 1.0.0"},
      {:con_cache, ">= 0.12.1"},
    ]
  end

  defp package() do
    [
      maintainers: ["Lenz Gschwendtner"],
      licenses: ["BSD"],
      links: %{"GitHub" => "https://github.com/norbu09/excontentful"}
    ]
  end
end
