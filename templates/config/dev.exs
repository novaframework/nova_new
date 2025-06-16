import Config

<%= if assigns.ecto do %>
config :<%= assigns.app_mod %>, ecto_repos: [<%= assigns.app %>.Repo]

config :<%= assigns.app_mod %>, <%= assigns.app %>.Repo,
  hostname: "localhost",
  username: "",
  password: "",
  port: 5432,
  database: "<%= assigns.app_mod %>_dev"
<% end %>
config :nova,
  environment: :dev,
  cowboy_configuration: %{
    port: 8000
  },
  dev_mode: true,
  bootstrap_application: <%= assigns.app %>,
  plugins: [
    {:pre_request, :nova_request_plugin, %{parse_bindings: true, parse_qs: true}}
  ]
