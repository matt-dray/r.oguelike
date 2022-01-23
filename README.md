
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {r.oguelike}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

A (work-in-progress) text-based [roguelike
game](https://en.wikipedia.org/wiki/Roguelike) for R.

You can install the {r.oguelike} package from GitHub:

``` r
remotes::install_github("r.oguelike")
```

To begin:

``` r
r.oguelike::start_game()
```

    # # # # # # # # # 
    # . . . . . . . # 
    # . . . . . . . # 
    # . . . @ . . . # 
    # . . . . . . . # 
    # . . . . . . . # 
    # # # # # # # # # 
    Use arrow keys

If you’re using a terminal that supports [the {keypress}
package](https://github.com/gaborcsardi/keypress), then you can move the
player character (`@`) with your arrow keys around the room tiles (`.`),
within the walls (`#`).

So, you can press the left-arrow key and this will happen:

    # # # # # # # # # 
    # . . . . . . . # 
    # . . . . . . . # 
    # . . @ . . . . # 
    # . . . . . . . # 
    # . . . . . . . # 
    # # # # # # # # # 
    Use arrow keys

If playing in an unsupported terminal, like RStudio, then you’ll be
prompted to type the direction (e.g. `left`). Use
`keypress::has_keypress_support()` to see if your terminal supports
{keypress}.

## Code of Conduct

Please note that the {r.oguelike} project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.