defmodule <%= assigns.app %>_router do

  def routes(:dev) do
    [%{
        prefix: "",
        security: false,
        plugins: [{:pre_request, :nova_request_plugin, %{parse_bindings: true, parse_qs: true}}],
        routes: [
          {"/", &<%=assigns.app %>.Controllers.Main.index/1, %{methods: [:get]}}
        ]
     }
    ]
  end
  def routes(:prod) do
    ## Just return the same routes as dev for now
    routes(:dev)
  end
end
