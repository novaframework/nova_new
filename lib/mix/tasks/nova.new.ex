defmodule Mix.Tasks.Nova.New do
  use Mix.Task

  alias Mix.Generator

  @version "0.9.0"
  @erlang_version "26.0.0"
  @elixir_version "1.15.0"

  @flags [
    app: :string,
    ecto: :boolean,
    ecto_adapter: :string
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
      {opts, [base_path|_]} ->
        IO.puts("Creating Nova project at '#{base_path}'...")
        IO.puts("Using options: #{inspect(opts)}")
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
          app_mod: appname,
          ecto: Keyword.get(opts, :ecto, false)
        }
        |> maybe_add_ecto_adapter()

        template_files = [
              "mix.exs",
              "config/config.exs",
              "config/dev.exs",
              "config/prod.exs",
              {"app.ex", "lib/#{appname}.ex"},
              {"router.ex", "lib/#{appname}_router.ex"}, ## We need to call it with suffix '_router' for now. Limitation in nova
              {"controller.ex", "lib/controllers/main.ex"},
        ]
        |> maybe_add_ecto(opts)

        ## Copy the templates
        add_templates(template_root, template_files, gen_opts, project_path)

        Mix.shell().info(
          "------------------------------------------------------------------------\n" <>
          "Nova project '#{appname}' created at '#{project_path}'.\n" <>
            "To start the server just run the following commands:\n" <>
            IO.ANSI.light_green() <> IO.ANSI.black_background() <> "cd #{appname}/\n" <>
            "mix deps.get\n" <>
            "iex -S mix\n" <> IO.ANSI.reset() <>
            "------------------------------------------------------------------------"
        )
    end
  end

  defp maybe_add_ecto_adapter(opts) do
    case Map.get(opts, :ecto_adapter, "postgres") do
      "postgres" ->
        opts
        |> Map.put(:ecto_adapter_mod, "postgrex")
        |> Map.put(:ecto_adapter, "Postgres")
      _ ->
        opts
    end
  end

  defp maybe_add_ecto(template_files, opts) do
    if(Keyword.get(opts, :ecto, false)) do
      template_files ++ [
        {"repo.ex", "lib/repo.ex"}
      ]
    else
      template_files
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
