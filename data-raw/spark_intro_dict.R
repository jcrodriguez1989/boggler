library("magrittr")
library("tokenizers")
library("usethis")

# read Introduction chapter from "Mastering Apache Spark with R" book, to use
# it as dictionary
spark_intro_dict <- readLines(
  "https://raw.githubusercontent.com/r-spark/the-r-in-spark/master/intro.Rmd"
) %>%
  tokenize_words(strip_numeric = TRUE) %>%
  unlist() %>%
  unique() %>%
  sort()

use_data(spark_intro_dict)
