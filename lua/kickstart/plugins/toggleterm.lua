-- my_config.lua

-- Toggle floating terminal and hide line numbers
local terminal_open = false
local terminal_bufnr = nil
local previous_win = nil

vim.keymap.set('n', '<leader>t', function()
  if terminal_open then
    -- Close the terminal if it's open
    if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
      vim.cmd('bdelete! ' .. terminal_bufnr)
    end
    terminal_open = false
    -- Switch focus back to the previous window
    if previous_win and vim.api.nvim_win_is_valid(previous_win) then
      vim.api.nvim_set_current_win(previous_win)
    end
  else
    -- Store the current window ID
    previous_win = vim.api.nvim_get_current_win()

    -- Calculate dimensions for the floating window
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a floating terminal window with a border
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',  -- Use 'minimal' style for no borders
      border = 'single',  -- Add a border
    })

    -- Open terminal in the floating window
    vim.cmd('terminal')
    -- Hide line numbers in the terminal buffer
    vim.cmd('setlocal nonumber norelativenumber')
    -- Get the buffer number of the terminal
    terminal_bufnr = vim.api.nvim_get_current_buf()
    terminal_open = true
  end
end, { noremap = true, silent = true, desc = 'Toggle floating terminal' })

-- Map <Esc> to exit terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

return {
  -- Optionally, export any other configuration here
}
