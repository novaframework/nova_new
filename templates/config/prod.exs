import Config

config :nova,
  environment: :prod,
  cowboy_configuration: %{
    port: 8000
  },
  dev_mode: false,
  bootstrap_application: <%= assigns.app %>,
  plugins: [
    {:pre_request, :nova_request_plugin, %{parse_bindings: true, parse_qs: true}}
  ]
