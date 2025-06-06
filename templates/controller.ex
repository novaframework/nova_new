defmodule <%= assigns.app %>.Controllers.Main do


  def index(req) do
    {:json, %{
      "message" => "Hello, World!",
      "method" => req.method,
      "path" => req.path,
      "query" => req.query,
      "headers" => req.headers
     }}
  end
end
