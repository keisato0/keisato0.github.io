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
    all_caption <- read_tsv(str_c("caption/", year, ".txt"))
    seasonal_caption <-
      all_caption %>% dplyr::filter(when == season) %>% pull(caption)

    # 写真をキャプション付きで吐き出す
    pics_vector <- rep(NA, times = num_pics)
    for (i in 1:num_pics) {
      pics_vector[i] <- str_c(
        "![", year, "_", season, "_", i, "](../pics/",
        year, "/", season, "_", i, ".jpg)"
        )
      cat(
        pics_vector[i], "\n",
        seasonal_caption[i], "\n\n",
        sep = ""
      )
    }
  }
}

# seasonal()をもとに特定年の写真とキャプションを見出しつきで吐き出す

seasons_numeric <- c("1-3", "4-6", "7-9", "10-12")
seasons_character <- c("winter", "spring", "summer", "fall")
annual <- function(what_year) {
  for (i in 1:4) {
    cat(
      cat(str_c("##", seasons_numeric[i], sep = " "), "\n\n", sep = ""),
      seasonal(what_year, seasons_character[i]),
      sep = ""
    )
  }
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
    cat(
      str_c("#", year, sep = " "), "\n\n",
      str_c(sum_of_pics, "枚あります。",
        "[写真トップページ](https://keisato0.github.io/pics/)へ"), "\n\n",
      "- [1-3](#1-3)", "\n",
      "- [4-6](#4-6)", "\n",
      "- [7-9](#7-9)", "\n",
      "- [10-12](#10-12)", "\n\n",
      sep = ""
    )

    # annualを実行し本文部分を生成
    annual(year)

    # 後段
    cat(
      "---", "\n",
      str_c("[このページのトップ](#", year, ")へ"), "\n\n",
      "[写真トップ](https://keisato0.github.io/pics/)へ", "\n",
      sep = ""
    )

  sink()
}

# md_generate()を複数年でやる
multiple_md_generate <- function(years) {
  for (i in years) {
    md_generate(i)
  }
}

md_generate(2018)

multiple_md_generate(2018:2021)