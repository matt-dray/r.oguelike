
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {r.oguelike}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/matt-dray/r.oguelike/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/r.oguelike/actions)
[![Launch Rstudio
Binder](http://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/matt-dray/play-r.oguelike/main?urlpath=rstudio)
[![](https://img.shields.io/badge/@-...$..a....E...-black?style=flat&labelColor=white)](https://en.wikipedia.org/wiki/Roguelike)
[![Blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?labelColor=000000&logo=data%3Aimage%2Fgif%3Bbase64%2CR0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh%2BQQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2022/04/25/r.oguelike-dev/)
<!-- badges: end -->

A (work-in-progress) text-based [roguelike
game](https://en.wikipedia.org/wiki/Roguelike) for R. A learning process
to build a gameplay ‘engine’ from the ground up. Read more [in the
accompanying
blogpost](https://www.rostrum.blog/2022/04/25/r.oguelike-dev/).

You can install the in-development {r.oguelike} package from GitHub:

``` r
remotes::install_github("matt-dray/r.oguelike")
```

Or [you can launch an instance of RStudio in the
browser](https://mybinder.org/v2/gh/matt-dray/play-r.oguelike/main?urlpath=rstudio),
thanks to [Binder](https://mybinder.org/), with {r.oguelike}
preinstalled.

To begin:

``` r
r.oguelike::start_game()
```

The screen will clear and you’ll see this:

    # # # # # # # # # 
    # . . . . E . . # 
    # . . . . . . . # 
    # . . . @ . . . # 
    # . $ . . . a . # 
    # . . . . . . . # 
    # # # # # # # # # 
    T: 25 | HP: 10 | G: 0 | A: 0
    Press key to start

If you’re using a terminal that supports [the {keypress}
package](https://github.com/gaborcsardi/keypress), then you can move the
player character (`@`) with your arrow keys (or [WASD
keys](https://en.wikipedia.org/wiki/Arrow_keys#WASD_keys)) around the
room tiles (`.`) of the randomly-generated room, staying within the
walls (`#`).

If playing in a {keypress}-unsupported terminal, like RStudio, then
you’ll be prompted to type the direction ([WASD
keys](https://en.wikipedia.org/wiki/Arrow_keys#WASD_keys)) then hit the
enter key. Use `keypress::has_keypress_support()` to see if your
terminal supports {keypress}.

So, going left moves you one tile to the left:

    # # # # # # # # # 
    # . . . . E . . # 
    # . . . . . . . # 
    # . . @ . . . . # 
    # . $ . . . a . # 
    # . . . . . . . # 
    # # # # # # # # # 
    T: 24 | HP: 10 | G: 0 | A: 0
    Moved left

Collect the gold (`$`). Stomp an enemy (`E`). Collect an apple (`a`) for
your inventory, then eat it with a keypress input of `1`. You’ll die if
you run out of `HP` or if you reach the maximum number of allowed turns
(`T`).

Future developments include an inventory system, randomised dungeons and
interactive turn-based battles.

## Code of Conduct

Please note that the {r.oguelike} project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
