local ts_utils = require "nvim-treesitter.ts_utils"

local function getCurrentRootLevelNode()
  local curr_node = ts_utils.get_node_at_cursor()

  if curr_node == nil then
    error("No Treesitter parser found.")
  end

  local root_node = ts_utils.get_root_for_node(curr_node)
  local parent = curr_node:parent()

  while (parent ~= nil and parent ~= root_node) do
    curr_node = parent
    parent = curr_node:parent()
  end

  local isRootNode = curr_node == root_node
  return curr_node, isRootNode
end

local function jump_from(node, jump_count, next_node)
  local to_node = node;
  for _ = 1, jump_count ~= 0 and jump_count or 1 do
    if next_node(to_node) == nil then
      break
    end
    to_node = next_node(to_node)
  end
  return to_node;
end

local function go_to_node(node)
  if node ~= nil then
    ts_utils.goto_node(node)
  end
end

local function move_cursor_vertically(inc)
  local curr_win = vim.api.nvim_get_current_win();
  local cursor = vim.api.nvim_win_get_cursor(curr_win);
  cursor[1] = cursor[1] + inc;
  vim.api.nvim_win_set_cursor(curr_win, cursor)
end

local function getNextRootLevelNode(jump_count)
  local rl_node, isRoot = getCurrentRootLevelNode()

  if isRoot then
    pcall(move_cursor_vertically, 1)
    return
  end

  local next = jump_from(rl_node, jump_count, function(node)
    return node:next_sibling()
  end)
  go_to_node(next)
end

local function getPreviousRootLvlNode(jump_count)
  local rl_node, isRoot = getCurrentRootLevelNode()

  if isRoot then
    pcall(move_cursor_vertically, -1)
    return
  end

  local prev = jump_from(rl_node, jump_count, function(node)
    return node:prev_sibling()
  end)
  go_to_node(prev)
end

return {
  go_to_prev = function() getPreviousRootLvlNode(vim.v.count) end,
  go_to_next = function() getNextRootLevelNode(vim.v.count) end
}
