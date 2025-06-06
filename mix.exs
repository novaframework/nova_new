defmodule NovaNew.MixProject do
  use Mix.Project

  def project do
    [
      app: :nova_new,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: [
          "Niclas Axelsson"
          ],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/novaframework/nova"},
      ],
      description: """
      Nova framework project generator.

      Provides a `mix nova.new` task to create a new Nova project with the necessary structure and files.
      """
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
    ]
  end
end
