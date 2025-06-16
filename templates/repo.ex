defmodule <%= assigns.app %>.Repo do
  use Ecto.Repo,
  otp_app: :<%= assigns.app_mod %>,
  adapter: Ecto.Adapters.<%= assigns.ecto_adapter %>

end
