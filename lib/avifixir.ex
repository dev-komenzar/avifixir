defmodule Avifixir do
  @moduledoc """
  Documentation for `Avifixir`.
  """
  @avifixir_version Mix.Project.config()[:version]

  def version, do: @avifixir_version

  # TODO: If arg (path) is a file, go to process()
  @doc """
  args must be Absolute paths
  """
  @spec convert_images(binary(), binary()) :: :ok
  def convert_images(path, dist_path) do
    cond do
      Avifixir.Path.is_dir(path) ->
        # Find AVIF files recursively under given `path`
        find_avif_images_under(path)
        |> has_at_least_one_element()
        |> prepare_image_info(path, dist_path)
        |> process_images()

      Avifixir.Path.is_a_avif_image(path) ->
        IO.puts("arg is a AVIF image.")

        path
        |> prepare_image_info(dist_path)
        |> convert_avif_to_jpg()

      true ->
        IO.puts("Arg is not a AVIF image.")
    end
  end

  @spec find_avif_images_under(binary()) :: [binary()]
  defp find_avif_images_under(path)
       when is_binary(path) do
    case Avifixir.Path.is_abs_path?(path) do
      false ->
        # TODO: 無限ループの可能性
        path
        |> Avifixir.Path.get_abs_path()
        |> find_avif_images_under()

      true ->
        Path.wildcard("#{path}/**/*.avif")
    end
  end

  defp has_at_least_one_element(list) when is_list(list) do
    logger = fn n -> IO.puts("#{n} images found.") end

    case list do
      [] ->
        raise "No image found."

      [_] ->
        IO.puts("1 image found.")

      [_ | _] ->
        length(list)
        |> logger.()
    end

    list
  end

  @spec prepare_image_info(nonempty_list(binary()), binary(), binary()) ::
          list(Avifixir.ImageInfo.t())
  defp prepare_image_info(list, search_path, dist_path)
       when is_list(list) and
              is_binary(search_path) and
              is_binary(dist_path) do
    list
    |> Enum.map(fn p ->
      # /sa/mple/image.avif
      dist_file = Avifixir.Path.get_new_file_path(p, search_path, dist_path)

      %Avifixir.ImageInfo{
        file: p,
        search_dir: search_path,
        dist_dir: dist_path,
        dist_file: dist_file
      }
    end)
  end

  @spec prepare_image_info(binary(), binary()) :: Avifixir.ImageInfo.t()
  defp prepare_image_info(path, dist_path)
       when is_binary(path) do
    dist_file =
      path
      |> Path.basename()
      |> Avifixir.Path.join_file_and_dir(dist_path)
      |> Avifixir.Path.replace_ext()

    %Avifixir.ImageInfo{
      file: path,
      search_dir: Path.dirname(path),
      dist_dir: Path.dirname(dist_file),
      dist_file: dist_file
    }
  end

  @spec convert_avif_to_jpg(Avifixir.ImageInfo.t()) :: Mogrify.Image.t()
  defp convert_avif_to_jpg(image) do
    import Mogrify

    %{file: file, dist_file: dist_file} = image

    dist_file |> Path.dirname() |> File.mkdir_p!()

    open(file) |> format("jpg") |> save(path: dist_file)
  end

  defp process_images(list)
       when is_list(list) do
    total = length(list)

    # 進捗状況を追跡する Agent を開始
    {:ok, progress} = Agent.start_link(fn -> 0 end)

    # 進捗バーを更新する関数
    update_progress = fn ->
      completed = Agent.get(progress, & &1)
      ProgressBar.render(completed, total)
    end

    # 進捗バーを定期的に更新するタスクを開始
    Task.start(fn ->
      Stream.interval(200)
      |> Stream.each(fn _ -> update_progress.() end)
      |> Stream.run()
    end)

    list
    |> Flow.from_enumerable()
    |> Flow.map(fn item ->
      processed_item = convert_avif_to_jpg(item)
      # 進捗を更新
      Agent.update(progress, &(&1 + 1))
      processed_item
    end)
    |> Enum.to_list()

    # 最終的な進捗状況を表示
    update_progress.()

    # Agent を停止
    Agent.stop(progress)
  end
end
