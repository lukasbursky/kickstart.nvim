local M = {}

local term_buf = nil
local term_win = nil

local function create_floating_window()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  return vim.api.nvim_open_win(term_buf, true, opts)
end

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
  else
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(term_buf, 'bufhidden', 'hide')
    end

    term_win = create_floating_window()

    if vim.bo[term_buf].buftype ~= 'terminal' then vim.fn.termopen 'pwsh' end

    vim.cmd 'startinsert'
  end
end

function M.setup() vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {}) end

return M
