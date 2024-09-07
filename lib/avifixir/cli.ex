defmodule Avifixir.CLI do
  @moduledoc """
  This is my cli tool to convert `.avif` images to `.jpg`.

  ## Usage

  `avi2jpg {dir_name} -d {dist_dir_name}`
  """

  @spec main([binary()]) :: :ok
  def main(args) do
    IO.puts("This is my cli tool to convert `.avif` images to `.jpg`.")

    {opts, args} =
      OptionParser.parse!(args,
        aliases: [
          d: :dist,
          v: :version
        ],
        strict: [
          dist: :string,
          version: :boolean
        ]
      )

    if List.keymember?(opts, :version, 0) do
      IO.puts("Avifixir version #{Avifixir.version()}")
    else
      generate(args, opts)
    end
  end

  defp generate(args, opts) do
    [dir] = parse_args(args)

    abs_dir =
      dir
      |> Avifixir.Path.get_abs_path()

    abs_dist_dir =
      opts
      |> Keyword.get(:dist, "~/dist")
      |> Avifixir.Path.get_abs_path()

    IO.puts("Searching dir: #{abs_dir}")
    IO.puts("Distribution dir: #{abs_dist_dir}")
    Avifixir.convert_images(abs_dir, abs_dist_dir)
  end

  @spec parse_args([binary()]) :: [binary()]
  defp parse_args([_dir] = args), do: args

  @spec parse_args([binary()]) :: none()
  defp parse_args([_ | _]) do
    IO.puts("Too many arguments.\n")
    print_usage()
    exit({:shutdown, 1})
  end

  @spec parse_args(any()) :: none()
  defp parse_args(_) do
    IO.puts("Too few arguments.\n")
    print_usage()
    exit({:shutdown, 1})
  end

  @spec print_usage() :: :ok
  defp print_usage do
    IO.puts(~S"""
    Usage:
      avifixir DIR -d NEW_DIR_NAME

    Options:
      DIR             Path to dir where `.aivf` images are
      -d, --dist      Path to distribution dir
    """)
  end
end
