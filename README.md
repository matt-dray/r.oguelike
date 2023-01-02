
# {r.oguelike} <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/r.oguelike/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/r.oguelike/actions)
[![Codecov test coverage](https://codecov.io/gh/matt-dray/r.oguelike/branch/main/graph/badge.svg)](https://app.codecov.io/gh/matt-dray/r.oguelike?branch=main)
[![Launch Rstudio
Binder](http://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/matt-dray/play-r.oguelike/main?urlpath=rstudio)
[![Blog posts](https://img.shields.io/badge/rostrum.blog-posts-008900?labelColor=000000&logo=data%3Aimage%2Fgif%3Bbase64%2CR0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh%2BQQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/tags/r.oguelike/)

<!-- badges: end -->

A toy demo of a tile-based [roguelike game](https://en.wikipedia.org/wiki/Roguelike) for R.

Visit [the documentation website](https://matt-dray.github.io/r.oguelike/reference/start_game.html) or read more [in the inaugural blogpost](https://www.rostrum.blog/2022/04/25/r.oguelike-dev/). See [the issues](https://github.com/matt-dray/r.oguelike/issues) for future plans or to suggest improvements.

You can install {r.oguelike} from GitHub via {remotes} (packages [{crayon}](https://github.com/r-lib/crayon) and [{keypress}](https://github.com/gaborcsardi/keypress) are also installed):

``` r
if (!require(remotes)) install.packages("remotes")
install_github("matt-dray/r.oguelike")
```

You could also [launch an instance of RStudio in the browser](https://mybinder.org/v2/gh/matt-dray/play-r.oguelike/main?urlpath=rstudio), thanks to [Binder](https://mybinder.org/), with {r.oguelike} preinstalled.

Use `start_game()` to begin. You can adjust the default parameters; see `?start_game` or [visit the documentation website](https://matt-dray.github.io/r.oguelike/reference/start_game.html) for details.

``` r
r.oguelike::start_game(
  iterations = 3,
  n_row = 15,
  n_col = 20,
  n_rooms = 4,
  max_turns = 25
)
```

The console will clear and you’ll see a map, with an inventory bar, status message and prompt for input. Output will appear in colour with the argument `colour = TRUE` (the default).

```
# # # # # # # # # # # # # # # # # # # # 
# # # # # # # . . . . . . . . # # # # # 
# # # # # # # # . . . . $ . . # # # # # 
# # # # # # # # . # # . . . . # # # # # 
# . # # # # # # # # # . . . # # # # # # 
# . . # # # # # # # # . . . # # # # # # 
# . . . # # # # # # # . . . . . # . # # 
# . . # # # # # # # . . . . . . . . # # 
# . . # # # # # # # # . . . . . . # # # 
# . @ . . . # # . # # # # . . . . . # # 
# . . . . . . . . . . . . . . . . # # # 
# . . . . . . . . . E . . . . . . # # # 
# . . a . . . . . . . . . . . . # # # # 
# # . . . . # # . # # # # . # # # # # # 
# # # # # # # # # # # # # # # # # # # # 
T: 25 | HP: 10 | $: 0 | a: 0
Press W, A, S or D then Enter to move, 1 to eat apple, 0 to exit
Input:
```

The dungeon map (`#` for walls and `.` for floor tiles) and placement of objects (`@` is the player, `E` is an enemy, `$` is gold and `a` is an apple) are randomised. [See the accompanying blogpost](https://www.rostrum.blog/2022/05/01/dungeon/) for more about how these dungeons are generated.

You can move the player character (`@`) with your arrow keys instead of the <kbd>W</kbd>, <kbd>A</kbd>, <kbd>S</kbd> or <kbd>D</kbd> keys if you’re using a terminal that supports [the {keypress} package](https://github.com/gaborcsardi/keypress) (RStudio doesn't).

After pressing <kbd>s</kbd> then <kbd>Enter</kbd> (or the down arrow key, if supported), the player character moves one space down and the status message updates. Note the enemy (`E`) is also heading in your direction...

```
# # # # # # # # # # # # # # # # # # # # 
# # # # # # # . . . . . . . . # # # # # 
# # # # # # # # . . . . $ . . # # # # # 
# # # # # # # # . # # . . . . # # # # # 
# . # # # # # # # # # . . . # # # # # # 
# . . # # # # # # # # . . . # # # # # # 
# . . . # # # # # # # . . . . . # . # # 
# . . # # # # # # # . . . . . . . . # # 
# . . # # # # # # # # . . . . . . # # # 
# . . . . . # # . # # # # . . . . . # # 
# . @ . . . . . . . . . . . . . . # # # 
# . . . . . . . . E . . . . . . . # # # 
# . . a . . . . . . . . . . . . # # # # 
# # . . . . # # . # # # # . # # # # # # 
# # # # # # # # # # # # # # # # # # # # 
T: 24 | HP: 10 | $: 0 | a: 0
Moved down
Input:
```

Collect the gold (`$`). Auto-battle the randomly-moving enemy (`E`). Collect an apple (`a`) for your inventory, then eat it with a keypress input of `1`. You’ll die if you run out of `HP` or if you reach the maximum number of turns allowed (`T`). You can quit the game with `0`.

## Code of Conduct

Please note that the {r.oguelike} project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
