# Avifixir

CLI tool to convert `.avif` images to `.jpg`.

## Feature

- Developed with `elixir`
  - This is my first `elixir` project
- Recursively fetch `.avif` images from the specified directory
- Copy the directory structure to the specified output directory

## Installation

1. Install Avifixir as an escript:

    ```bash
    mix escript.install hex avifixir
    ```

## Usage

```bash
avifixir PATH_TO_DIR
```

`.avif` images under `PATH_TO_DIR` are converted to `.jpg`. You can choose distribution dir with `-d` option. Default dist dir is `~/dist`.

```bash
avifixir PATH_TO_DIR -d "/where/you/want`
# ex. ~/project/src/**/*.avif -> /where/you/want/**/*.avif
```

Arg can be a `.avif` file like:

```bash
avifixir /sample/exapmle/image.avif
```

## License

MIT License

---

`.avif` 画像を一括で `.jpg` に変換する CLI ツールです。

## 特徴

- `elixir` で開発
  - はじめての `elixir` プロジェクトです
- 指定したディレクトリ以下の `.avif` 画像を再帰的に取得
- 指定した出力ディレクトリにディレクトリ構造もコピーします

## インストール

1. Avifixirをエスクリプトとしてインストールします：

    ```bash
    mix escript.install github dev-komenzar/avifixir
    ```

## 使い方

```bash
avifixir PATH_TO_DIR
```

`PATH_TO_DIR` 以下の `.avif` 画像は `.jpg` に変換されます。`-d` オプションを使うことで出力ディレクトリを指定できます。デフォルトの出力ディレクトリは `~/dist` です。

```bash
avifixir PATH_TO_DIR -d "/where/you/want"
# 例: ~/project/src/**/*.avif -> /where/you/want/**/*.avif
```

引数には `.avif` ファイルも指定できます：

```bash
avifixir /sample/example/image.avif
```

## ライセンス

MIT License
