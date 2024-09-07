defmodule Avifixir.ImageInfo do
  defstruct file: nil, search_dir: nil, dist_dir: nil, dist_file: nil

  @type t :: %Avifixir.ImageInfo{
          file: binary(),
          search_dir: binary(),
          dist_dir: binary(),
          dist_file: binary()
        }
end
