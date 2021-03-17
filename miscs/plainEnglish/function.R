PETable <- function(lessonNum) {
  # preface -----------------------------------------------------------------
  library(rvest)
  num <- lessonNum
  frontPageURL <- str_c("https://plainenglish.com/number/", num, "/")
  frontPageHTML <- read_html(frontPageURL)
  
  link <- "/html/body/div[1]/div/div/div/div/div/section[2]/div/div/div/div/div/div[2]/div/div/article/div/a/@href"
  scriptPageURL <- html_nodes(frontPageHTML, xpath = link) %>% html_text()
  scriptPageHTML <- read_html(scriptPageURL)
  
  scriptRaw <- "/html/body/div[1]/div/div/div/div/main/div/div/section[5]/div/div/div/div/div/section/div/div/div[1]/div/div/div[2]/div/div/div/div[2]/div[1]/p"
  
  # content -----------------------------------------------------------------
  script <- html_nodes(scriptPageHTML, xpath = scriptRaw) %>% html_text()
  script[1] <- script[1] %>% str_c(., ".")
  
  allInOne <- script %>% str_c(collapse = " ")
  sentences <- tokenizers::tokenize_sentences(allInOne)
  sentences <- sentences[[1]]

  # split each sentence by word
  words <- str_split(sentences, pattern = "[\x20\t]+")
  firstWords <- rep(NA, length(words))
  for (i in 1:length(firstWords)) {
    firstWords[i] <- str_c(words[[i]][1:2], collapse = " ")
  }
  
  table <- data.frame(firstWords, sentences)
  
  output <- knitr::kable(table, format = "markdown", col.names = c("First Two Words", "Sentence"))
  cat(output, file = str_c("lesson/", lessonNum, ".md"), fill = TRUE)
}

multiPETable <- function(lessonNums){
  for (i in lessonNums) {
    PETable(lessonNum = i)
  }
}

multiPETable(lessonNums = 301:346)