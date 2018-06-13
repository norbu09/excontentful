defmodule Excontentful.MixProject do
  use Mix.Project

  def project do
    [
      app: :excontentful,
      version: "0.3.0",
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
      included_applications: [:mime],
      mod: {Excontentful.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla,  ">= 1.0.0"},
      {:poison, ">= 1.0.0"},
      {:con_cache, ">= 0.12.1"},
      # dev related
      {:credo, ">= 0.7.3", only: :dev, warn_missing: false},
      {:distillery, ">= 1.0.0", only: :dev, warn_missing: false}
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
