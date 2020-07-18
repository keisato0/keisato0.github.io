---
author: 俺
---

# 備忘録：このサイトのつくり方

## GitHubでリポジトリを作る

その際，レポジトリ名は 〇〇.github.io としておく(〇〇はユーザ名，私の場合はkeisato0)。

## ファイルを用意する

Gitの作業ディレクトリとなるディレクトリを適当な場所につくり，index.htmlなど適当なファイルを用意する。htmlファイルはちゃんと表示されてるか確かめられればいいので， `<body> ~ </body>` になにか一言書いておくくらいでよい。

## GitHub上にファイルの変更を反映させる

GitHubで新しくリポジトリを作ると，何もファイルがない限り，リポジトリのトップ画面にローカルリポジトリの変更をGitHub上のリモートリポジトリに反映させるためのUNIXコマンドの書き方が表示される。それにしたがってMacのターミナルで以下のようにコマンドを入力する。

`cd`などでお目当てのローカルディレクトリまで移動する。その後，

```{}
$ git init
$ git add --all
$ git commit -m "何らかのメッセージ"
$ git remote add origin https://github.com/〇〇/〇〇.github.io.git
$ git push origin master
```

と一行ずつ打ち，完了したらGitHubのリポジトリページを覗いてみる。index.htmlなど用意したファイルが表示されてればOK。

## GitHub Pagesの設定を確認

GitHubのリポジトリページからSettingsを開くと下の方にGitHub Pagesという項目がある。うまくいってれば，自動的に"https:〇〇.github.io"のアドレスでページが公開されている旨が案内されているのでそれを確かめる。

## ページを開いてみる

ちゃんと表示されたらOK。

### 2回目以降

ローカルフォルダに加えた変更(ファイルの追加，削除，編集)は以下のコマンドでリモートリポジトリに反映できる。

```{}
$ git add --all
$ git commit -m "何らかのメッセージ"
$ git push origin master
```

## コマンドの意味

初回のときと比べると，

```{}
$ git init
$ git remote add origin https://github.com/〇〇/〇〇.github.io.git
```

の2行がないが，前者は現在のディレクトリにGitのローカルリポジトリをつくるというコマンド，後者はリモートリポジトリとして`https://github.com/〇〇/〇〇.github.io.git`を指定するコマンドなので，一度きりでよいということのようだ。

ということで，`add`，`commit`，`push`の3つが基本的なコマンドとなる。これらがどういう意味かは，[「Git 仕組み 図解」](https://www.google.com/search?q=git+%E4%BB%95%E7%B5%84%E3%81%BF+%E5%9B%B3%E8%A7%A3&tbm=isch&ved=2ahUKEwisrY3w6dbqAhUQB5QKHViZD8wQ2-cCegQIABAA&oq=git+%E4%BB%95%E7%B5%84%E3%81%BF&gs_lcp=CgNpbWcQARgBMgIIADICCAAyBAgAEBgyBAgAEBgyBAgAEBg6BAgAEAQ6BggAEAQQGFDwD1iQFmCwIWgAcAB4AIABkwKIAcwJkgEFMS4zLjOYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=Y-4SX-zvFJCO0ATYsr7gDA&bih=797&biw=1440)などのワードでググったらなんとなくわかった。

## テーマの設定

前述のGitHub Pagesの設定から，Jekyllというサイトジェネレータをもとに，ページのテーマを変えられる。私はMinimalというのを選んだ。

Jekyllのテーマは，リモートリポジトリ内の.htmlファイルではなく.mdファイルに自動的に反映される(.htmlファイルに反映させることも可能)。なので，index.htmlを削除して，index.mdというファイルを用意して適当に一言二言書き，`push`までやりきってみる。すると，トップページにindex.mdの内容が表示され，しかもなんかいい感じのMinimalテーマにしたがっていることがわかる。

もちろんテーマもカスタマイズできる。各テーマが解説サイトをもっているので，そこの指示を読めばよい。私はデフォルトで表示されるようになっていたGitHubページへのリンクなどを消した。

## 更新

あとは作業ディレクトリを好きなように操作したのち，ターミナルで

```{}
$ git add --all
$ git commit -m "何らかのメッセージ"
$ git push origin master
```

と打てば自動的にサイト内容も更新される。なんと便利なんでしょう。

## pull

GitHubのほうでファイル構成を変更した場合は

```{}
$ git pull
```

でリモートリポジトリの変更をローカルリポジトリに反映させる。