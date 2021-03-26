options(readr.num_columns = 0)
setwd("/Users/kei/Documents/miscs/homePage/pics")

# season: winter, spring, summer, fall

# 特定の年、特定の季節の写真とキャプションのmdコードを吐き出す
seasonal <- function(year, season) {
  num_pics <- length(list.files(str_c("pics/", year), pattern = season))

  if (num_pics == 0) {
    cat("これから追加されます", "\n\n", sep = "")
  } else {
    # キャプション
    caption <- read_tsv(str_c("caption/", year, ".txt"))
    caption_by_season <- caption %>% dplyr::filter(when == season)
    caption_by_season <- caption_by_season$caption

    pics_vector <- rep(NA, times = num_pics)
    for (i in 1:num_pics) {
      pics_vector[i] <- str_c(
          "![", year, "_", season, "_", i, "](../pics/",
          year, "/", season, "_", i, ".jpg)"
        )
      cat(
        pics_vector[i],
        "\n",
        caption_by_season[i],
        "\n\n",
        sep = ""
      )
    }
  }
}

# seasonal()をもとに特定年の写真とキャプションを見出しつきで吐き出す
annual <- function(what_year) {
  cat(
    cat("## 1-3", "\n\n", sep = ""),
    seasonal(what_year, "winter"),
    cat("## 4-6", "\n\n", sep = ""),
    seasonal(what_year, "spring"),
    cat("## 7-9", "\n\n", sep = ""),
    seasonal(what_year, "summer"),
    cat("## 10-12", "\n\n", sep = ""),
    seasonal(what_year, "fall")
    )
}

# リンクなどもつけたフルmdコードを吐き出し、ファイルに保存する
md_generate <- function(year) {
  sum_of_pics <- length(list.files(str_c("pics/", year)))

  # sink() - sink() 内のコードを書き出し
  sink(
    file = str_c("pages/", year, ".md"),
    append = F
    )

    # 見出しなど前段
    cat(str_c("#", year, sep = " "))
    cat("\n\n")
    cat(str_c(sum_of_pics, "枚あります。",
      "[写真トップページ](https://keisato0.github.io/pics/)へ"))
    cat("\n\n")
    cat(
      "- [1-3](#1-3)",
      "- [4-6](#4-6)",
      "- [7-9](#7-9)",
      "- [10-12](#10-12)",
      sep = "\n"
    )
    cat("\n")

    # annualを実行し本文部分を生成
    annual(year)

    # 後段
    cat("---", "\n", str_c("[このページのトップ](#", year, ")へ"), "\n\n",
    "[写真トップ](https://keisato0.github.io/pics/)へ", sep = "")
    cat("\n")

  sink()
}

# md_generate()を複数年でやる
multiple_md_generate <- function(years) {
  for (i in years) {
    md_generate(i)
  }
}

multiple_md_generate(2018:2021)