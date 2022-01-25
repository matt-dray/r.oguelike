# Prepare a 'r.oguelike' badge for the README

# remotes::install_github("matt-dray/badgr")

badgr::get_badge(
  label = "@",
  message = "...$..a....E...",
  color = "black",
  style = "flat",
  label_color = "white",
  md_link = "https://en.wikipedia.org/wiki/Roguelike",
  browser_preview = FALSE,
  include_md = TRUE,
  to_clipboard = TRUE
)
