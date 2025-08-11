local M = {}

-- Global variable to store selected directory
M.search_dir = vim.loop.cwd()

-- Command to set search directory
function M.set_dir()
  local input = vim.fn.input("Set search directory: ", M.search_dir or "", "dir")
  if input ~= "" then
    M.search_dir = input
    print("Search directory set to: " .. input)
  end
end

-- Grep in the selected directory
function M.grep_in_dir()
  require("telescope.builtin").live_grep({
    cwd = M.search_dir,
    prompt_title = "Live Grep in " .. M.search_dir,
  })
end

return M
