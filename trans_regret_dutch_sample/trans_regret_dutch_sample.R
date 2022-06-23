rqeuire("ggplot2")
rqeuire("data.table")

d = data.table(first_year = c(1973, 1980, 1985, 1990, 1995, 2000, 2005, 2010))
d[, time_since_treatment := 2015 - first_year]
d[, year_of_treatment := as.character(first_year)]

ggplot(d, aes(xmin = first_year, xmax = 2015, y = year_of_treatment)) +
  geom_linerange(size = 4) +
  theme_minimal() +
  labs(x = "years since treatment (calendar time)",
       y = "year of treatment")

ggplot(d, aes(xmin = 0, xmax = time_since_treatment, y = year_of_treatment)) +
  geom_linerange(size = 4) +
  theme_minimal() +
  labs(x = "years since treatment (serial time)",
       y = "year of treatment")

ggplot(d) +
  geom_linerange(size = 4, mapping = aes(xmin = time_since_treatment, xmax = 20, y = year_of_treatment), color = "red") +
  geom_linerange(size = 4, mapping = aes(xmin = 0, xmax = time_since_treatment, y = year_of_treatment)) +
  theme_minimal() +
  labs(x = "years since treatment (serial time)",
       y = "year of treatment")
