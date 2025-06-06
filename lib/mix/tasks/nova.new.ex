defmodule Mix.Tasks.Nova.New do
  use Mix.Task

  alias Mix.Generator

  @version "0.9.0"
  @erlang_version "26.0.0"
  @elixir_version "1.15.0"

  @flags [
    app: :string
  ]

  @shortdoc "Generates a Nova router file"

  @moduledoc """
  Generates a Nova router file with the specified name.
  Usage: `mix nova <name>`
  """


  def run([]) do
    Mix.raise("Please provide a name for the project. Usage: `mix nova.new <name>`")
  end
  def run(argv) do
    version_check!()

    {opts, argv} = OptionParser.parse!(argv, strict: @flags)
    template_root = Path.expand("../../../templates", __DIR__)

    case {opts, argv} do
      {_opts, []} ->
        Mix.Tasks.Help.run(["nova.new"])
      {_opts, [base_path|_]} ->
        project_path = Path.expand(base_path)
        appname = Path.basename(project_path)
        ## Start create the structure
        Generator.create_directory(project_path)
        Generator.create_directory(Path.join(project_path, "lib"))
        Generator.create_directory(Path.join(Path.join(project_path, "lib"), "controllers"))
        Generator.create_directory(Path.join(project_path, "test"))
        Generator.create_directory(Path.join(project_path, "config"))

        gen_opts = %{
          app: Macro.camelize(appname),
          app_mod: appname
        }
        ## Copy the templates
        add_templates(template_root, [
              "mix.exs",
              "config/config.exs",
              "config/dev.exs",
              "config/prod.exs",
              {"app.ex", "lib/#{appname}.ex"},
              {"router.ex", "lib/router.ex"},
              {"controller.ex", "lib/controllers/main.ex"},
            ], gen_opts, project_path)

        Mix.shell().info(
          "Nova project '#{appname}' created at '#{project_path}'.\n" <>
            "You can now run `mix deps.get` to install dependencies and `iex -S mix` to start the server."
        )
    end
  end

  defp add_templates(_template_dir, [], _opts, _target), do: :ok
  defp add_templates(template_dir, [{template, dest_file}|tl], opts, target) do
    Generator.copy_template(
      Path.join(template_dir, template),
      Path.join(target, dest_file),
      opts
    )
    add_templates(template_dir, tl, opts, target)
  end
  defp add_templates(template_dir, [template|tl], opts, target) do
    Generator.copy_template(
      Path.join(template_dir, template),
      Path.join(target, template),
      opts
    )
    add_templates(template_dir, tl, opts, target)
  end

  ## Checks the Elixir and Erlang versions
  defp version_check! do
    unless Version.match?(System.version(), "~> #{@elixir_version}") and
    Version.match?("#{:erlang.system_info(:otp_release)}.0.0", "~> #{@erlang_version}") do
      Mix.raise(
        "Nova v#{@version} requires at least Elixir v#{@elixir_version} and\n " <>
          "Erlang OTP #{@erlang_version} or later.\n" <>
          "You have Elixir #{System.version()} and Erlang OTP #{:erlang.system_info(:otp_release)}.x.x. Please update accordingly"
      )
    end
  end
end
