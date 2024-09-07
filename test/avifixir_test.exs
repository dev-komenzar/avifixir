defmodule AvifixirTest do
  use ExUnit.Case
  doctest Avifixir

  test "gets Absolute path" do
    path = "~/test/sample"
    abs_path? = Avifixir.Path.get_abs_path(path)
    assert Path.type(abs_path?) === :absolute
  end

  test "is dir" do
    path = "lib"
    assert Avifixir.Path.is_dir(path)
  end

  test "is not dir" do
    path = "sample/test/text.txt"
    refute Avifixir.Path.is_dir(path)
  end

  test "get expanded path" do
    expected_home_path = Path.expand("~") <> "/dist"
    assert Avifixir.Path.get_abs_path("~/dist") == expected_home_path
  end

  test "replace extension" do
    assert Avifixir.Path.replace_ext("test/image.avif") == "test/image.jpg"
    refute Avifixir.Path.replace_ext("sample/abc.png") == "sample/abc.jpg"
  end

  test "new file dir" do
    path = "test/image.avif"
    search_dir = "/search/dir"
    dist_dir = "/foo/bar/dist"
    dist_path = "/foo/bar/dist/test/image.jpg"

    assert Avifixir.Path.get_new_file_path(path, search_dir, dist_dir) == dist_path
  end
end
