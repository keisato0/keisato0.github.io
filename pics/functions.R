options(readr.num_columns = 0)
setwd("/Users/kei/Documents/miscs/homePage/pics")

# season: winter, spring, summer, fall

months <- c("1-3", "4-6", "7-9", "10-12")
names(months) <- c("winter", "spring", "summer", "fall")
season_marker <- str_c("##", months, sep = " ")
names(season_marker) <- c("winter", "spring", "summer", "fall")

seasonalHTML <- function(year, season) {
  numPics <- length(list.files(str_c("pics/", year), pattern = season))

  if (numPics == 0) {
    cat("これから追加されます", "\n\n", sep = "")
  } else {
    # キャプション
    caption <- read_tsv(str_c("caption/", year, ".txt"))
    caption_by_season <- caption %>% dplyr::filter(when == season)
    caption_by_season <- caption_by_season$caption

    picsVector <- rep(NA, times = numPics)
    for (i in 1:numPics) {
      picsVector[i] <- str_c(
          "![", year, "_", season, "_", i, "](../pics/",
          year, "/", season, "_", i, ".jpg)"
        )
      cat(
        picsVector[i],
        "\n",
        caption_by_season[i],
        "\n\n",
        sep = ""
      )
    }
  }
}

# cat(seasonalHTML(2020, "summer"), seasonalHTML(2020, "fall"))

annualHTMl <- function(whatYear) {
  cat(
    cat("## 1-3", "\n\n", sep = ""),
    seasonalHTML(whatYear, "winter"),
    cat("## 4-6", "\n\n", sep = ""),
    seasonalHTML(whatYear, "spring"),
    cat("## 7-9", "\n\n", sep = ""),
    seasonalHTML(whatYear, "summer"),
    cat("## 10-12", "\n\n", sep = ""),
    seasonalHTML(whatYear, "fall")
    )
}

# annualHTMl(whatYear = 2020)

md_generate <- function(year) {
  sum_of_pics <- length(list.files(str_c("pics/", year)))

  sink(
    file = str_c("pages/", year, ".md"),
    append = F
    )
  cat(str_c("#", year, sep = " "))
  cat("\n\n")
  cat(str_c(sum_of_pics, "枚あります。",
    "[写真トップページ](https://keisato0.github.io/pics/)へ"))
  cat("\n\n")
  cat(
    # str_c("- [", year, "](#", year, ")"),
    "- [1-3](#1-3)",
    "- [4-6](#4-6)",
    "- [7-9](#7-9)",
    "- [10-12](#10-12)",
    sep = "\n"
  )
  cat("\n")
  annualHTMl(year)
  cat("---", "\n", str_c("[このページのトップ](#", year, ")へ"), "\n\n",
  "[写真トップ](https://keisato0.github.io/pics/)へ", sep = "")
  cat("\n")
  sink()
}

md_generate(2019)
md_generate(2020)
md_generate(2021)