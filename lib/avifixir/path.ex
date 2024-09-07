defmodule Avifixir.Path do
  @moduledoc """
  Utilities for manupulating file system paths.
  パス操作のユーティリティをまとめるモジュール。
  """

  @spec get_abs_path(binary()) :: binary()
  def get_abs_path(str) when is_binary(str) do
    str |> Path.expand() |> Path.absname()
  end

  @spec is_dir(binary()) :: boolean()
  def is_dir(path) when is_binary(path) do
    # Path.dirname(path) == path
    File.dir?(path)
  end

  @spec is_a_avif_image(binary()) :: boolean()
  def is_a_avif_image(path) when is_binary(path) do
    if Path.extname(path) == ".avif" do
      true
    else
      false
    end
  end

  # 絶対パスの条件をチェック
  @spec is_abs_path?(binary()) :: boolean()
  def is_abs_path?(path) when is_binary(path) do
    Path.type(path) == :absolute
  end

  @spec replace_ext(Path.t()) :: binary()
  def replace_ext(file_path) do
    Path.join([
      Path.dirname(file_path),
      Path.basename(file_path, ".avif") <> ".jpg"
    ])
  end

  @spec join_file_and_dir(Path.t(), Path.t()) :: binary()
  def join_file_and_dir(file, dir) do
    Path.join(dir, file)
  end

  @spec get_new_file_path(binary(), binary(), binary()) :: binary()
  def get_new_file_path(path, search_dir, dist_dir) do
    # Original: /sa/mple/image.avif
    path
    # mple/image.avif (in case search_path: /sa)
    |> Path.relative_to(search_dir)
    # ~/dist/mpl/image.avif
    |> join_file_and_dir(dist_dir)
    # ~/dist/mpl/image.jpg
    |> replace_ext()
  end
end
