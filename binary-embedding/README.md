# What is this?

バイナリをC/C++のコードに埋め込むためのコードです。
バイナリからC/C++で使う `const unsigneed char` の配列と、そのサイズを出力します。

目的や作った理由、使い方などは以下の記事に書いています。

[C/C++の実行コードにバイナリを埋め込む - Zenn](https://zenn.dev/articles/19290c7bee35f6)

# How to use

```
binary-embedding [-i input.bin]　var_name
```

`-i input.bin` は入力するバイナリファイルを指定します。省略すると標準入力から読み込みます。

`var_name` は埋め込む変数名です。 出力するC/C++のコードにはこの変数名でアクセスできるようになります。

結果は、標準出力に出力されます。必要に応じてリダイレクトしてファイルに保存してください。

# Example

```
$ echo -n "Hello, World!" | ./binary-embedding hoge > hoge_data.h
```

上のコマンドで、`hoge_data.h` に以下のようなコードが出力されます。

```C
const unsigned char hoge_array[] = {
  0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72,
  0x6c, 0x64, 0x21
};
const unsigned int hoge_size = 13;
```

あとは、メインのC/C++のコードでこのファイルを `include` して使ってください。
