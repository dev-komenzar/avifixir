defmodule Avifixir.ImageInfo do
  defstruct file: nil, search_dir: nil, dist_dir: nil, dist_file: nil

  @type t :: %Avifixir.ImageInfo{
          file: String.t(),
          search_dir: String.t(),
          dist_dir: String.t(),
          dist_file: String.t()
        }
end
