# r.oguelike 0.0.0.9008

* Made the enemy use breadth-first pathfinding to move towards the player (#8).

# r.oguelike 0.0.0.9007

* Made the enemy move randomly, avoiding non-floor tiles (towards #8).

# r.oguelike 0.0.0.9006

* Integrated sub-functions of `generate_dungeon()` into `start_game()` (#7), replacing simple rectangular rooms.
* Added 'quit' keypress (`0`) to exit game.
* Updated function documentation/comments and some variable names for clarity.
* Updated README given dungeon map changes.
* Added hex sticker design, favicons.

# r.oguelike 0.0.0.9005

* Added `generate_dungeon()` for randomised/procedural dungeon creation (#7).

# r.oguelike 0.0.0.9004

* Added enemy HP and attack.
* Added autobattle state.
* Used `is_alive` status to determine game state; use turn count and HP to end game.
* Prevented apple consumption if max HP or if apple inventory is empty.

# r.oguelike 0.0.0.9003

* Added simple inventory system for collecting apples and using them in the overworld by pressing `1`.
* Added better defense of user inputs.
* Added {pkgdown} site and GitHub Action.

# r.oguelike 0.0.0.9002

* Split out internal functions into `utils.R`.
* Split out keypress-input function.
* Added output line with narrative message.
* Supported WASD for movement.
* Added R CMD check as a GitHub Action, including README badge.
* Added {r.oguelike} badge to README, code in `data.raw/badge.R`.

# r.oguelike 0.0.0.9001

* Added enemy object (`E`) and interaction effects.
* Added food ('apple') object (`a`) and interaction effects.
* Adjusted stats interface for HP and gold.

# r.oguelike 0.0.0.9000

* Created package.
* Added basic functions for room creation, player (`@`) movement and starting a new game with `start_game()`.
* Added interface for turns and gold counters.
* Added gold object (`$`) and interaction effects.
