defmodule <%= assigns.app %>.MixProject do
  use Mix.Project

  def project do
    [
      app: :<%= assigns.app_mod %>,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
    [<%= if assigns.ecto do %>
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},<%= if assigns.ecto_adapter_mod do %>
      {:<%= assigns.ecto_adapter_mod %>, ">= 0.0.0"},<% end %><% end %>
      {:nova, "~> 0.11.0"}
    ]
  end

  defp aliases do
    [
    <%= if assigns.ecto do %>
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      <% end %>
    ]
  end
end
