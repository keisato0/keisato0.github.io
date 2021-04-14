googlesheets4::gs4_auth(email = "sato.kei.mail@gmail.com")

raw1 <- googlesheets4::read_sheet(
    ss = "1OAs2rP2Pk8HAayDsIGd3OBTvTMM6ILm5pwIDwoN7vNE")
raw2 <- googlesheets4::read_sheet(
  ss = "11COq7xUknJvjA7Hh3LI7Mcko34UyNxFNY3hjreHdSAs")
df <- bind_rows(raw1, raw2) %>% 
  dplyr::filter(status == "played") %>% 
  select(-status, -album) %>% 
  mutate(date = lubridate::date(date))

march <- df %>% 
  dplyr::filter("2021-03-01" <= date & date <= "2021-03-31")

min(march$date)
max(march$date)

march %>% 
  ggplot(mapping = aes(x = date)) +
  geom_histogram(col = "white", binwidth = 1) +
  scale_x_date(
    date_labels = "%d",
    date_breaks = "3 days",
    date_minor_breaks = "1 day"
    ) +
  labs(x = "Date", 
       y = "Number of Tracks Played",
       title = "Kei's Spotify Listening History in March 2021")

march_result_track <- march %>% 
  group_by(artist, track) %>% 
  summarise(times_played = n()) %>% 
  arrange(desc(times_played))

march_result_track$ratio <- 
  march_result_track$times_played / sum(march_result_track$times_played)

output_track <- march_result_track %>% 
  dplyr::filter(10 <= times_played) %>% 
  knitr::kable(., format = "markdown", digits = 2)


march_result_artist <- march_result_track %>% 
  group_by(artist) %>% 
  summarise(times_played = sum(times_played),
            ratio = sum(ratio)) %>% 
  arrange(desc(times_played))
  
output_artist <- march_result_artist %>% 
  dplyr::filter(10 <= times_played) %>% 
  knitr::kable(., format = "markdown", digits = 2)


cat(output_artist, output_track, fill = T)

march$lamp <- ifelse(march$artist == "Lamp", 1, 0)

march_lamp_table <- march %>%
  group_by(date) %>%
  summarise(n = n(),
    lamp = sum(lamp))

march_lamp_table_tidy <- march_lamp_table %>%
  pivot_longer(cols = 2:3, names_to = "type")

march_lamp_table_tidy %>% 
  ggplot(mapping = aes(x = date, y = value, fill = type)) +
  geom_col(position = "nudge")

cor(march_lamp_table$n, march_lamp_table$lamp)

march_lamp <- march %>% dplyr::filter(artist == "Lamp")

march_lamp %>% select(date, track) %>% 
  group_by(track) %>% summarise(n = n()) %>% 
  arrange(desc(n))

hoge <- table(march_lamp$track) %>% 
  sort(decreasing = T) %>% 
  data.frame() %>% 
  rename(track = 1)
str <- hoge$track[1:5]

funk <- function(df) {
  df2 <- df %>% group_by(track) %>% summarise(n = n())
  df2$date <- unique(df$date)
  df2 <- select(df2, date, track, n)
}

lamp_plot <- march_lamp %>% dplyr::filter(track %in% str) %>% 
  select(date, track) %>% 
  group_split(date) %>% 
  map(funk) %>% 
  bind_rows()

lamp_plot %>% 
  ggplot(mapping = aes(x = date, y = n, col = track)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme(
    text = element_text(family = "HiraKakuProN-W3")
  )

lamp_plot %>% 
  pivot_wider(names_from = track, values_from = n) %>% 
  replace(is.na(.), 0) %>% 
  select(-1) %>% 
  cor() %>% 
  data.frame() %>% 
  corrplot::corrplot(method = "shade")


func <- function(df) {
  result <- table(df$track) %>% 
    sort(decreasing = T) %>% 
    data.frame()
  
  result$date <- unique(df$date)
  
  colnames(result) <- c("track", "freq", "date")
  
  result <- slice(result, 1:3)
  result$rank <- 1:3
  result
}

march_lamp %>% 
  select(date, track) %>% 
  group_split(date) %>% 
  map(func) %>% 
  bind_rows() %>% 
  select(3, 4, 1) %>% 
  pivot_wider(names_from = rank, values_from = track)
