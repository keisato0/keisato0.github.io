# season: winter, spring, summer, fall

months <- c("1-3", "4-6", "7-9", "10-12")
names(months) <- c("winter", "spring", "summer", "fall")

seasonalHTML <- function(year, season){
  numPics <- length(list.files(str_c("pics/", year), pattern = season))
  
  if (numPics == 0) {
    print("該当する写真がありません")
  } else {
    picsVector <- rep(NA, times = numPics)
    for (i in 1:numPics) {
      picsVector[i] <- 
        str_c("![](pics/", year, "/", season, "_", i, ".jpg)")
    }
    output <- str_c(picsVector, collapse = "<br><br>")
    output <- str_c("<h2>", months[season], "</h2>", 
                    output, "<br><br>")
    output
  }
}


annualHTMl <- function(whatYear){
  codes <- rep(NA, times = 4)
  for (i in 1:4) {
    codes[i] <- seasonalHTML(year = whatYear, season = names(months)[i])  
  }
  output <- str_c(codes, collapse = "")
  output <- str_remove_all(output, "該当する写真がありません")
  output <- str_c("<h1>", year, "</h1>", output)
  output <- str_remove(output, "<br><br>$")
  output
}