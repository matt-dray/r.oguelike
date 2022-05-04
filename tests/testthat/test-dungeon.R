test_that("dungeon works as expected", {

  expect_snapshot({generate_dungeon(seed = 23456)})

  expect_snapshot({generate_dungeon(n_row=42, n_col=42, is_snake=TRUE, seed = 42)})
})
