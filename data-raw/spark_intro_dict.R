library("magrittr")
library("tokenizers")

spark_intro_dict <- readLines(
  "https://raw.githubusercontent.com/r-spark/the-r-in-spark/master/intro.Rmd") %>%
  tokenize_words(strip_numeric = TRUE) %>%
  unlist() %>%
  unique() %>%
  sort()

usethis::use_data(spark_intro_dict)
