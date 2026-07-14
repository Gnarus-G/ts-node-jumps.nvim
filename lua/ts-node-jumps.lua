---@return TSNode?
---@return boolean
local function getCurrentRootLevelNode()
  local ok, curr_node = pcall(vim.treesitter.get_node, { ignore_injections = false })

  if not ok or curr_node == nil then
    return nil, false; --[[  "No Treesitter parser found." ]]
  end

  local root_node = curr_node
  while root_node:parent() ~= nil do
    root_node = root_node:parent()
  end

  local parent = curr_node:parent()

  while (parent ~= nil and parent ~= root_node) do
    curr_node = parent
    parent = curr_node:parent()
  end

  local isRootNode = curr_node == root_node
  return curr_node, isRootNode
end

--- @param node TSNode
--- @param jump_count number
--- @param next_node fun(n: TSNode): TSNode?
--- @return TSNode
local function jump_from(node, jump_count, next_node)
  for _ = 1, jump_count ~= 0 and jump_count or 1 do
    local n = next_node(node);

    if n == nil then
      return node
    end
    return n
  end
end

---@param node TSNode?
local function go_to_node(node)
  if node ~= nil then
    local window = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_win_get_buf(window)
    local cursor = vim.api.nvim_win_get_cursor(window)
    vim.api.nvim_buf_set_mark(buffer, "'", cursor[1], cursor[2], {})

    local row, column = node:start()
    vim.api.nvim_win_set_cursor(window, { row + 1, column })
  end
end

--- @param inc number
local function move_cursor_vertically(inc)
  local curr_win = vim.api.nvim_get_current_win();
  local cursor = vim.api.nvim_win_get_cursor(curr_win);
  cursor[1] = cursor[1] + inc;
  vim.api.nvim_win_set_cursor(curr_win, cursor)
end

--- @param jump_count number
local function getNextRootLevelNode(jump_count)
  local rl_node, isRoot = getCurrentRootLevelNode()

  if isRoot or not rl_node then
    pcall(move_cursor_vertically, 1)
    return
  end

  local next = jump_from(rl_node, jump_count, function(node)
    return node:next_sibling()
  end)
  go_to_node(next)
end

--- @param jump_count number
local function getPreviousRootLvlNode(jump_count)
  local rl_node, isRoot = getCurrentRootLevelNode()

  if isRoot or not rl_node then
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
