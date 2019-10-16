
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

Create a random `4 x 4` boggle board:

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

(act_board <- new_board(m = 4, n = 4, dices = en_boggle_dices))
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,] "T"  "H"  "N"  "N" 
    ## [2,] "O"  "E"  "T"  "E" 
    ## [3,] "T"  "A"  "O"  "D" 
    ## [4,] "V"  "V"  "S"  "O"

And get all possible
solutions:

``` r
boggle_sol <- solve(act_board, dict = spark_intro_dict, word_min_len = 2)
```

    ##       Word Path              
    ##  [1,] "to" "(1, 1) ~> (2, 1)"
    ##  [2,] "to" "(2, 3) ~> (3, 3)"
    ##  [3,] "to" "(3, 1) ~> (2, 1)"
    ##  [4,] "at" "(3, 2) ~> (2, 3)"
    ##  [5,] "at" "(3, 2) ~> (3, 1)"
    ##  [6,] "as" "(3, 2) ~> (4, 3)"
    ##  [7,] "vs" "(4, 2) ~> (4, 3)"
    ##  [8,] "so" "(4, 3) ~> (3, 3)"
    ##  [9,] "so" "(4, 3) ~> (4, 4)"
    ##      Word  Path                        
    ## [1,] "the" "(1, 1) ~> (1, 2) ~> (2, 2)"
    ## [2,] "the" "(2, 3) ~> (1, 2) ~> (2, 2)"
    ## [3,] "too" "(2, 3) ~> (3, 3) ~> (4, 4)"
    ##      Word   Path                                  
    ## [1,] "then" "(1, 1) ~> (1, 2) ~> (2, 2) ~> (1, 3)"
    ## [2,] "then" "(2, 3) ~> (1, 2) ~> (2, 2) ~> (1, 3)"

And calculate obtained points:

``` r
get_points(boggle_sol[, 1])
```

    ## [1] "You got a total score of 8"

    ##   Word Points
    ## 1   as      1
    ## 2   at      1
    ## 3   so      1
    ## 4  the      1
    ## 5 then      1
    ## 6   to      1
    ## 7  too      1
    ## 8   vs      1
