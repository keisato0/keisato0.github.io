# Plain Englishのスクリプトを読みやすくする

- [Plain Englishのスクリプトを読みやすくしたい](#plain-englishのスクリプトを読みやすくしたい)
- [目標](#目標)
- [ワークフロー](#ワークフロー)
- [Rコード](#rコード)
  - [指定した単一レッスンのスクリプトを吐き出す関数](#指定した単一レッスンのスクリプトを吐き出す関数)
  - [指定した複数レッスンのスクリプトを吐き出す関数](#指定した複数レッスンのスクリプトを吐き出す関数)
- [出来上がり](#出来上がり)

## Plain Englishのスクリプトを読みやすくしたい

[Plain English](https://plainenglish.com)という英語の語学勉強用ポッドキャストを聞いている。

各レッスンごとのスクリプトがWeb上で読めるのだが、あまり役立たない。というのはまず、PEのサイト上でのリンク・被リンク関係の都合上、かなりアクセスしにくくなっているからだ。さらに文章が何段落かに分かれて記載されている。まあ当たり前なのだが、語学勉強目的でいうと一文一文分かれて記載されていたほうがあとから振り返りやすい。

せっかくなのでスクレイピングで読みやすいスクリプトをつくってみようと思った。

## 目標

今回の目標を明確にしておこう。

> レッスン番号を入力すると読みやすいフォーマットのスクリプト.md形式で吐き出される

.mdファイルでの書き出しが必要なのは、最終的にこのサイトにスクリプトを載せるため。このサイトは.mdファイルでwebサイトを構成できるjekyllというサービスを使っているため、コンテンツは.mdファイルで書いておく。

## ワークフロー

ワークフローとしてはこんな感じか。

1. レッスン番号の入力
2. レッスンの紹介ページ（ここにスクリプトは出てない）をスクレイプ
3. スクリプトページへのリンクを得る
4. スクリプトページをスクレイプ
5. スクレイプして得られたスクリプトを整形（一文一文分ける）
6. .mdファイルで書き出す

## Rコード

ではさっそくですが書いてみたコードを紹介いたしますですよ。

### 指定した単一レッスンのスクリプトを吐き出す関数

```R
PETable <- function(lessonNum) {

  # レッスンの紹介ページをスクレイプ -----------------------------------------------------------------
  library(rvest)
  frontPageURL <- str_c("https://plainenglish.com/number/", lessonNum, "/")
  frontPageHTML <- read_html(frontPageURL)
  

  # スクリプトページへのリンクを得る -----------------------------------------------------------------
  link <- "/html/body/div[1]/div/div/div/div/div/section[2]/div/div/div/div/div/div[2]/div/div/article/div/a/@href" # XPathはあらかじめ調べておいた
  scriptPageURL <- html_nodes(frontPageHTML, xpath = link) %>% html_text()
  

  # スクリプトページをスクレイプ -----------------------------------------------------------------
  scriptPageHTML <- read_html(scriptPageURL)
  scriptRaw <- "/html/body/div[1]/div/div/div/div/main/div/div/section[5]/div/div/div/div/div/section/div/div/div[1]/div/div/div[2]/div/div/div/div[2]/div[1]/p" # 同上
  script <- html_nodes(scriptPageHTML, xpath = scriptRaw) %>% html_text()
  
  
  # スクレイプして得られたスクリプトを整形 -----------------------------------------------------------------
  
    # 1文を1要素とする文字列ベクトルの作成 ---------------------------------------------
    script[1] <- script[1] %>% str_c(., ".") # 最初の1文は見出しで、カンマがないのでつける。この時点では1段落を1要素とする文字列ベクトル
    allInOne <- script %>% str_c(collapse = " ") # 次行の関数を使うため、全要素を1要素に詰め込んだ文字列ベクトルを作る
    sentences <- tokenizers::tokenize_sentences(allInOne) # 文章ごとに分ける。これ、正規表現でやろうとすると案外むずい。関数があってよかった
    sentences <- sentences[[1]] # 返り値がリストなので、必要な情報だけ取って文字列ベクトルにする
  

    # 各文の最初の2語だけを取得して文字列ベクトルに ---------------------------------------------
    # すでに目的は達成されているのだが、各文の最初の2語だけを各文の隣に表示させてみたい。最初の2語だけ見て全文がいえるくらいになっていたら、他のスピーキングの場面にも応用が利きそうだ。
  
    words <- str_split(sentences, pattern = "[\x20\t]+") # 空白で分ける。返り値はリスト
    firstWords <- rep(NA, length(words)) # 各文の最初の2語の文字列を入れておく文字列ベクトルを用意
    for (i in 1:length(firstWords)) { # 各文の最初の2語の文字列を取得してベクトルに入れる
        firstWords[i] <- str_c(words[[i]][1:2], collapse = " ")
    }
  

  # .mdでの書き出し ------------------------------------------------------------------
  table <- data.frame(firstWords, sentences) # df化しておく
  body <- knitr::kable(table, format = "markdown", col.names = c("First Two Words", "Sentence"))
  title <- str_c("## Plain English Lesson [", lessonNum, "](https://PlainEnglish.com/number/",
                 lessonNum, "/)") # 題名もつけてみる
  cat(title, "\n", body, file = str_c("lesson/", lessonNum, ".md"), fill = TRUE) # cat()で書き出す
}
```

### 指定した複数レッスンのスクリプトを吐き出す関数

上の関数`PETable()`を繰り返し適用することで、複数レッスンのスクリプトを取得できるようにしたのが次の`multiPETable()`だ。

```R
multiPETable <- function(lessonNums){
  for (i in lessonNums) {
    PETable(lessonNum = i)
  }
}
```

## 出来上がり

```R
multiPETable(lessonNums = 301:346)
```

を実行して、とりあえずレッスン301から346までつくってみた。

仕上がりのページでどういう感じになっているかは[ここ](https://keisato0.github.io/miscs/plainEnglish)をチェックだ。

ちなみに上のページの、各レッスンのスクリプトへのリンクは次のようなループでつくって.mdファイルにコピペした。

```R
result <- rep(NA, length(301:346))

for (i in 1:length(result)) {
  result[i] <- str_c("- [", i+300, "](lesson/", i+300, ".md)") 
}

result %>% str_c(collapse = "\n") %>% cat()

```
