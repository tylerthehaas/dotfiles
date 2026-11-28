-- Vim-style panes. Prefix is ctrl+space, same as tmux.

-- ctrl+h/j/k/l: move between Rex panes, but hand the key to (n)vim when it is
-- the foreground program so vim-tmux-navigator / <C-w> nav still works there.
local vim_names = { nvim = true, vim = true, vi = true, view = true }

local function in_vim()
  -- No block given = the block the key fired in (the focused pane).
  local ok, p = pcall(rex.block.call, "com.superlogical.terminal", "process", {})
  return ok and p and p.foreground and vim_names[p.foreground.name] or false
end

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function(ctx)
    if in_vim() then return false end -- false = key goes to the terminal
    rex.session.focus_direction{ session_id = ctx.session_id, direction = dir }
    return true
  end)
end

-- Splits, vim letters: s = horizontal (new pane below), v = vertical (new pane right).
rex.bind("ctrl+space>s", "pane.split.down")
rex.bind("ctrl+space>v", "pane.split.right")
-- tmux muscle memory
rex.bind("ctrl+space>shift+'", "pane.split.down")
rex.bind("ctrl+space>shift+5", "pane.split.right")

-- Prefix + h/j/k/l always moves Rex panes, even from inside nvim.
rex.bind("ctrl+space>h", "pane.focus.left")
rex.bind("ctrl+space>j", "pane.focus.down")
rex.bind("ctrl+space>k", "pane.focus.up")
rex.bind("ctrl+space>l", "pane.focus.right")

-- ctrl+space twice sends it through (nvim-cmp completion uses it).
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
