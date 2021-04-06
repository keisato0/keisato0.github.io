# Plain Englishのスクリプトを読みやすくする

- [Plain Englishのスクリプトを読みやすくする](#plain-englishのスクリプトを読みやすくする)
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
library(magrittr)
library(tidyverse)
library(rvest)

pe_table <- function(lesson_num) {
  # preface --------------------------------
  front_page_url <- str_c("https://plainenglish.com/number/", lesson_num, "/")
  front_page_html <- read_html(front_page_url)

  link <- "/html/body/div[1]/div/div/div/
    div/div/section[2]/div/div/div/div/
    div/div[2]/div/div/article/div/a/@href"
  script_page_url <-
    html_nodes(front_page_html, xpath = link) %>% html_text()
  script_page_html <- read_html(script_page_url)

  script_raw <- "/html/body/div[1]/div/
    div/div/div/main/div/div/section[5]/
    div/div/div/div/div/section/div/
    div/div[1]/div/div/div[2]/div/div/
    div/div[2]/div[1]/p"


  # content ------------------------------
  script <- html_nodes(script_page_html, xpath = script_raw) %>% html_text()
  script[1] <- script[1] %>% str_c(., ".")

  all_in_one <- script %>% str_c(collapse = " ")
  sentences <- tokenizers::tokenize_sentences(all_in_one)
  sentences <- sentences[[1]]


  # split each sentence by word -------
  words <- str_split(sentences, pattern = "[\x20\t]+")
  first_words <- rep(NA, length(words))
  for (i in 1:length(first_words)) {
    first_words[i] <- str_c(words[[i]][1:2], collapse = " ")
  }


  # output ----------------------------
  table <- data.frame(first_words, sentences)
  body <- knitr::kable(
    table, format = "markdown",
    col.names = c("First Two Words", "Sentence"))
  title <- str_c(
    "# Plain English Lesson [",
    lesson_num, "](https://PlainEnglish.com/number/",
    lesson_num, "/)")
  cat(title, "\n", body,
    file = str_c("lesson/", lesson_num, ".md"),
    fill = TRUE)
}
```

### 指定した複数レッスンのスクリプトを吐き出す関数

上の関数`PETable()`を繰り返し適用することで、複数レッスンのスクリプトを取得できるようにしたのが次の`multiPETable()`だ。

```R
multi_pe_table <- function(lesson_nums) {
  for (i in lesson_nums) {
    pe_table(lesson_num = i)
  }
}
```

## 出来上がり

```R
multiPETable(lessonNums = 301:346)
```

を実行して、とりあえずレッスン301から346までつくってみた。

仕上がりのページでどういう感じになっているかは[**ここ**](https://keisato0.github.io/miscs/plainEnglish/index.md)をチェックだ。

ちなみに上のページの、各レッスンのスクリプトへのリンクは次のようなループでつくって.mdファイルにコピペした。

```R
result <- rep(NA, length(301:346))

for (i in 1:length(result)) {
  result[i] <- str_c("- [", i+300, "](lesson/", i+300, ".md)") 
}

result %>% str_c(collapse = "\n") %>% cat()

```
