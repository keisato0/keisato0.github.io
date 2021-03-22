x <- 1:100
y <- 1:100
df <- tibble(x = x, y = y)

df %>% ggplot(mapping = aes(x = x, y = y)) +
  # theme(
  #   axis.ticks = element_line(colour = "white"),
  #   axis.text = element_text(colour = "white"),
  #   axis.title = element_text(colour = "white")
  #   ) +
  annotate(geom = "rect", xmin = 10, xmax = 20, ymin = 10, ymax = 15,
           fill = "red")
