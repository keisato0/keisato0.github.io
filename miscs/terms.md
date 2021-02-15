---
title: "社会学の単語"
# author: "佐藤"
# date: "2/15/2021"
output: html_document
    # theme: lumen
    # toc: true
    # toc_float: true
---

```{r echo=FALSE, message=FALSE}
googlesheets4::gs4_auth(email = "mr.310k@gmail.com")
df <- googlesheets4::read_sheet(
  ss = "https://docs.google.com/spreadsheets/d/1qBMSxTyp6XYvhlteHlkeAHRnbZy_di7opFe2tnFyZuk/edit#gid=1387767260", 
  sheet = "完全版（あいうえお順）"
    )
df <- df %>% select(1, 2)

df %>% sample_n(5) %>% 
  knitr::kable(format = "html") %>%
  kableExtra::kable_paper() %>% 
  kableExtra::column_spec(column = 1, width_min = "120px")
```

---

社会学の学術用語とその定義がランダムに5つ表示されます。記述の的確さについては保証できません（笑）