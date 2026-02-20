require("pack")

local parsers = require("treesitter.parsers")

require("nvim-treesitter").install(parsers):wait(300000)
