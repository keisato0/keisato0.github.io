x <- 1:100
# y <- seq(1, 200, 2)

df <- tibble(x = x, y = x)

df %>% 
  ggplot(mapping = aes(x = x, y = y)) +
  theme(
    axis.ticks = element_line(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.title = element_text(colour = "white"),
    panel.background = element_rect(fill = "white")
    ) +
  annotate(geom = "rect", xmin = 10, xmax = 20, ymin = 10, ymax =15,
           fill = "red")