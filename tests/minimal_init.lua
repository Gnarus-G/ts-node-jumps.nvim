vim.opt.runtimepath:prepend(vim.fn.getcwd())

local node_jumps = require("ts-node-jumps")

local buffer = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buffer)
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {
  "local function first()",
  "  return 1",
  "end",
  "",
  "local function second()",
  "  return 2",
  "end",
})
vim.bo[buffer].filetype = "lua"
vim.treesitter.start(buffer, "lua")
vim.treesitter.get_parser(buffer, "lua"):parse()

vim.api.nvim_win_set_cursor(0, { 1, 0 })
node_jumps.go_to_next()
local next_position = vim.api.nvim_win_get_cursor(0)
assert(
  vim.deep_equal(next_position, { 5, 0 }),
  "did not jump to the next root node: " .. vim.inspect(next_position)
)
assert(vim.deep_equal(vim.api.nvim_buf_get_mark(buffer, "'"), { 1, 0 }), "did not preserve the previous position")

node_jumps.go_to_prev()
assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 1, 0 }), "did not jump to the previous root node")
