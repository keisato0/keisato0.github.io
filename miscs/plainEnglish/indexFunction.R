result <- rep(NA, length(301:346))

for (i in 1:length(result)) {
  result[i] <- str_c("- [", i+300, "](lesson/", i+300, ".md)") 
}

result %>% str_c(collapse = "\n") %>% cat()
