colMeans(swiss)

first_and_last <- function(x) {
    first <- x[1]
    last  <- x[length(x)]
    return(c("first" = first, "last" = last))
}

first_and_last(c(4, 3, 1, 8))

first_and_last(7)

first_and_last(numeric(0))

smarter_first_and_last <- function(x) {
    if(length(x) == 0L) { # specify integers with L
        stop("The input has no length!") #<<
    } else {
        first <- x[1]
        last  <- x[length(x)]
        return(c("first" = first, "last" = last))        
    }
}

smarter_first_and_last(numeric(0))
smarter_first_and_last(c(4, 3, 1, 8))

smarter_first_and_last

## NAME <- function(ARGUMENT1, ARGUMENT2=DEFAULT){
##   BODY
##   return(OUTPUT)
## }

quantile_report <- function(x, na.rm = FALSE) {
    quants <- quantile(x, na.rm = na.rm, 
       probs = c(0.01, 0.05, 0.10, 0.25, 0.5, 0.75, 0.90, 0.95, 0.99))
    names(quants) <- c("Bottom 1%", "Bottom 5%", "Bottom 10%", "Bottom 25%",
                       "Median", "Top 25%", "Top 10%", "Top 5%", "Top 1%")
    return(quants)
}
quantile_report(rnorm(10000))

## lapply(swiss, FUN = quantile_report)

lapply(swiss, FUN = quantile_report)[1:3]

sapply(swiss, FUN = quantile_report)

apply(swiss, MARGIN = 2, FUN = quantile_report)

library(dplyr); library(readr)
file_list  <- list.files("./example_data/")
file_paths <- paste0("./example_data/", file_list)
data_names <- stringr::str_remove(file_list, ".csv")
data_list  <- vector("list", length(file_list))
names(data_list) <- data_names
for (i in seq_along(file_list)){
  data_list[[ data_names[i] ]] <- read_csv(file_paths[i])
} 
complete_data <- bind_rows(data_list)
head(complete_data, 3)

complete_data <- lapply(file_paths, read_csv) %>%
  bind_rows()
head(complete_data, 3)

bucket <- function(x, quants = c(0.333, 0.667)) {
    # set low extreme, quantile points, high extreme
    new_breaks <- c(min(x)-1, quantile(x, probs = quants), max(x)+1)
    # labels = FALSE will return integer codes instead of ranges
    return(cut(x, breaks = new_breaks, labels = FALSE))
}

random_data <- rnorm(100)
bucketed_random_data <- bucket(random_data, 
                          quants = c(0.05, 0.25, 0.5, 0.75, 0.95))
plot(x = bucketed_random_data, y = random_data, main = "Buckets and values")

(school_data <- 
  data.frame(school = letters[1:10],
  pr_passing_exam=c(0.78, 0.55, 0.91,   -1, 0.88, 0.81, 0.90, 0.76,   99, 99),
  pr_free_lunch = c(0.33,   99, 0.25, 0.05, 0.12, 0.09, 0.22,  -13, 0.21, 99)))

remove_extremes <- function(x, low, high) {
    x_no_low <- ifelse(x < low, NA, x)
    x_no_low_no_high <- ifelse(x_no_low > high, NA, x)
    return(x_no_low_no_high)
}
remove_extremes(school_data$pr_passing_exam, low = 0, high = 1)

library(dplyr)
school_data %>%
   mutate_at(vars(-school), ~ remove_extremes(x = ., low = 0, high = 1))

swiss %>%
  select("Fertility", "Catholic") %>%
  head(2)

swiss %>%
    summarize_all( ~ mean(., na.rm = TRUE) / sd(., na.rm = TRUE))

## lapply(swiss, function(x) mean(x, na.rm = TRUE) / sd(x, na.rm = TRUE))

lapply(swiss, function(x) mean(x, na.rm = TRUE) / sd(x, na.rm = TRUE))[1:5]

## library(gapminder); library(ggplot2)
## ggplot(gapminder %>% filter(country == "Afghanistan"),
##        aes(x = year, y = pop / 1000000)) +
##        geom_line(color = "firebrick") +
##        xlab(NULL) + ylab("Population (millions)") +
##        ggtitle("Population of Afghanistan since 1952") +
##        theme_minimal() +
##        theme(plot.title = element_text(hjust = 0, size = 20))

library(gapminder); library(ggplot2)
ggplot(gapminder %>% filter(country == "Afghanistan"),
       aes(x = year, y = pop / 1000000)) +
    geom_line(color = "firebrick") +
    xlab(NULL) + ylab("Population (millions)") +
    ggtitle("Population of Afghanistan since 1952") +
    theme_minimal() + theme(plot.title = element_text(hjust = 0, size = 20))

ggplot(gapminder %>% filter(country == "Peru"),
       aes(x = year, y = lifeExp)) +
    geom_line(color = "firebrick") +
    xlab(NULL) + ylab("Life expectancy") +
    ggtitle("Life expectancy in Peru since 1952") +
    theme_minimal() + theme(plot.title = element_text(hjust = 0, size = 20))

gapminder_lifeplot <- function(cntry) {
    ggplot(gapminder %>% filter(country == cntry), #<<
       aes(x = year, y = lifeExp)) +
    geom_line(color = "firebrick") +
    xlab(NULL) + ylab("Life expectancy") + theme_minimal() + 
    ggtitle(paste0("Life expectancy in ", cntry, " since 1952")) + #<<
    theme(plot.title = element_text(hjust = 0, size = 20))
}

gapminder_lifeplot(cntry = "Turkey")

y_axis_label <- c("lifeExp" = "Life expectancy",
                  "pop" = "Population (millions)",
                  "gdpPercap" = "GDP per capita, USD")
title_text <- c("lifeExp" = "Life expectancy in ",
                "pop" = "Population of ",
                "gdpPercap" = "GDP per capita in ")
# example use:
y_axis_label["pop"]
title_text["pop"]

gapminder_plot <- function(cntry, yvar) {
    y_axis_label <- c("lifeExp" = "Life expectancy",
                      "pop" = "Population (millions)",
                      "gdpPercap" = "GDP per capita, USD")[yvar] #<<
    title_text   <- c("lifeExp" = "Life expectancy in ",
                      "pop" = "Population of ",
                      "gdpPercap" = "GDP per capita in ")[yvar] #<<
    ggplot(gapminder %>% filter(country == cntry) %>% #<<
             mutate(pop = pop / 1000000),
           aes_string(x = "year", y = yvar)) + #<<
      geom_line(color = "firebrick") + 
      ggtitle(paste0(title_text, cntry, " since 1952")) +  #<<
      xlab(NULL) + ylab(y_axis_label) + theme_minimal() +
      theme(plot.title = element_text(hjust = 0, size = 20))
}

gapminder_plot(cntry = "Turkey", yvar = "pop")

## debug(gapminder_plot)

## undebug(gapminder_plot)
