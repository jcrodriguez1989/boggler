
# boggler - Solve the Boggle Game

If there is one thing that programming tournaments taught me, it is that
the first solution to try is brute force, so here is my solution. From
the Boggle board, it gets all the possible words, and then keeps only
those that are contained in the dictionary.

Note that by running the code in parallel, I noticed a longer execution
time. This is because parallelism can be done only at paths level, which
are too many tasks and of too short execution.

## Installation

`boggler` is currently only available as a GitHub package.

To install it run the following from an R console:

``` r
if (!require("remotes")) {
  install.packages("remotes")
}
remotes::install_github("jcrodriguez1989/boggler", dependencies = TRUE)
```

## Usage

Create a random `3 x 3` boggle board:

``` r
library("boggler")
```

    ## 
    ## Attaching package: 'boggler'

    ## The following object is masked from 'package:base':
    ## 
    ##     solve

``` r
set.seed(881918)

(act_board <- new_board(m = 3, n = 3, dices = en_boggle_dices))
```

    ##      [,1] [,2] [,3]
    ## [1,] "C"  "Y"  "B" 
    ## [2,] "C"  "N"  "T" 
    ## [3,] "Y"  "G"  "I"

And get all possible
solutions:

``` r
boggle_sol <- solve(act_board, dict = spark_intro_dict, word_min_len = 2)
```

    ##      Word Path              
    ## [1,] "by" "(1, 3) ~> (1, 2)"
    ## [2,] "tb" "(2, 3) ~> (1, 3)"
    ## [3,] "in" "(3, 3) ~> (2, 2)"
    ## [4,] "it" "(3, 3) ~> (2, 3)"

And calculate obtained points:

``` r
get_points(boggle_sol[, 1])
```

    ## [1] "You got a total score of 4"

    ##   Word Points
    ## 1   by      1
    ## 2   in      1
    ## 3   it      1
    ## 4   tb      1
