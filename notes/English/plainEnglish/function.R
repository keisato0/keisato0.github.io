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

pe_table(lesson_num = 298)

multi_pe_table <- function(lesson_nums) {
  for (i in lesson_nums) {
    pe_table(lesson_num = i)
  }
}

multi_pe_table(lesson_nums = 301)