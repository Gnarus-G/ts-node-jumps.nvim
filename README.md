# ts-node-jumps.nvim
Easily jump between root level nodes in code.
## Install
With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'gnarus-g/ts-node-jumps.nvim',
  requires = {
    "nvim-treesitter/nvim-treesitter"
  }
}
```

## Usage
```lua
local node_jumps = require "ts-node-jumps"

vim.keymap.set("n", "<up>", node_jumps.go_to_prev)
vim.keymap.set("n", "<down>", node_jumps.go_to_next)
```
### Keymaps
<kbd>Up</kbd> or <kbd>Down</kbd> to jump one node.  
Add a count before the keystroke to modify how much to jump; e.g <kbd>3</kbd><kbd>Up</kbd>  
![simplescreenrecorder-2022-08-26_20 35 39](https://user-images.githubusercontent.com/37311893/187007961-d1118b9b-fd52-4df2-acd9-3b676a02491c.gif)
