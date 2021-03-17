# preface -----------------------------------------------------------------

library(rvest)
raw <- read_html("https://plainenglish.com/lessons/tab-diet-soda-retired/")
scriptRaw <- "/html/body/div[1]/div/div/div/div/main/div/div/section[5]/div/div/div/div/div/section/div/div/div[1]/div/div/div[2]/div/div/div/div[2]/div[1]/p"


# content -----------------------------------------------------------------

script <- html_nodes(
  raw,
  xpath = scriptRaw
) %>% 
  html_text()
script[1] <- script[1] %>% str_c(., ".")
allInOne <- script %>% str_c(collapse = " ")
sentences <- tokenizers::tokenize_sentences(allInOne)

### 以下をリロードすればよろし
sentences <- sentences[[1]][1:60]

words <- str_split(sentences, pattern = "[\x20\t]+")
firstWords <- rep(NA, length(words))
for (i in 1:length(firstWords)) {
  firstWords[i] <- str_c(words[[i]][1:2], collapse = " ")
}

table <- data.frame(firstWords, sentences)

library(knitr)
kable(table, format = "markdown")