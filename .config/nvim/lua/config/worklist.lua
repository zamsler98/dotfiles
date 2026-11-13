-- Worklist: a VS Code-style "open editors" list.
--
-- A buffer joins the list the first time you modify it, or when you keep it
-- by hand. Buffers you only look at stay open but are not listed. Pinned
-- buffers always come first, in the order they were pinned. The list starts
-- empty each session.

local M = {}

M.config = {
  -- How to order unpinned buffers:
  --   "joined" - the order they joined the list
  --   "recent" - most recently used first
  sort = "joined",
  pin_icon = "󰐃 ",
}

local joined = {} -- bufnrs in join order
local pinned = {} -- bufnrs in pin order

local function index_of(list, buf)
  for i, b in ipairs(list) do
    if b == buf then
      return i
    end
  end
end

local function remove(list, buf)
  local i = index_of(list, buf)
  if i then
    table.remove(list, i)
  end
end

-- Only real files: no help, terminals, pickers or other plugin buffers.
local function eligible(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

function M.keep(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  if not eligible(buf) then
    return false
  end
  if not index_of(joined, buf) then
    table.insert(joined, buf)
  end
  return true
end

function M.remove(buf)
  remove(joined, buf)
  remove(pinned, buf)
end

function M.is_pinned(buf)
  return index_of(pinned, buf) ~= nil
end

function M.toggle_pin(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  if M.is_pinned(buf) then
    remove(pinned, buf)
    return false
  end
  if not M.keep(buf) then
    vim.notify("Worklist: only file buffers can be pinned", vim.log.levels.WARN)
    return nil
  end
  table.insert(pinned, buf)
  return true
end

-- Pinned buffers first, then the rest in the configured order.
function M.list()
  local rest = {}
  for _, buf in ipairs(joined) do
    if not M.is_pinned(buf) then
      table.insert(rest, buf)
    end
  end
  if M.config.sort == "recent" then
    local lastused = {}
    for _, buf in ipairs(rest) do
      lastused[buf] = vim.fn.getbufinfo(buf)[1].lastused
    end
    table.sort(rest, function(a, b)
      return lastused[a] > lastused[b]
    end)
  end
  return vim.list_extend(vim.list_slice(pinned), rest)
end

function M.pick()
  -- Number keys jump straight to the nth entry, like arrow.nvim.
  local actions, input_keys, list_keys = {}, {}, {}
  for n = 1, 9 do
    local name = "worklist_goto_" .. n
    actions[name] = function(picker)
      for _, item in ipairs(picker:items()) do
        if item.n == n then
          picker:close()
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(item.buf) then
              vim.api.nvim_set_current_buf(item.buf)
            end
          end)
          return
        end
      end
    end
    input_keys[tostring(n)] = { name, mode = { "n", "i" }, desc = "Open entry " .. n }
    list_keys[tostring(n)] = name
  end

  Snacks.picker({
    title = "Worklist",
    finder = function()
      local items = {}
      for n, buf in ipairs(M.list()) do
        local name = vim.api.nvim_buf_get_name(buf)
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        table.insert(items, {
          n = n,
          buf = buf,
          file = name,
          text = name,
          pinned = M.is_pinned(buf),
          pos = mark[1] ~= 0 and mark or nil,
        })
      end
      return items
    end,
    format = function(item, picker)
      local icon = M.config.pin_icon
      local ret = {
        { item.n <= 9 and tostring(item.n) or " ", "SnacksPickerIdx" },
        { " " },
        { item.pinned and icon or string.rep(" ", vim.api.nvim_strwidth(icon)), "SnacksPickerSpecial" },
      }
      vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
      if vim.bo[item.buf].modified then
        table.insert(ret, { " [+]", "SnacksPickerBufFlags" })
      end
      return ret
    end,
    actions = vim.tbl_extend("force", actions, {
      worklist_remove = function(picker)
        for _, item in ipairs(picker:selected({ fallback = true })) do
          M.remove(item.buf)
        end
        picker:refresh()
      end,
      worklist_pin = function(picker)
        for _, item in ipairs(picker:selected({ fallback = true })) do
          M.toggle_pin(item.buf)
        end
        picker:refresh()
      end,
    }),
    win = {
      input = {
        keys = vim.tbl_extend("force", input_keys, {
          ["<c-x>"] = { "worklist_remove", mode = { "n", "i" }, desc = "Remove from worklist" },
          ["<c-o>"] = { "worklist_pin", mode = { "n", "i" }, desc = "Toggle pin" },
        }),
      },
      list = {
        keys = vim.tbl_extend("force", list_keys, {
          ["dd"] = "worklist_remove",
          ["p"] = "worklist_pin",
        }),
      },
    },
  })
end

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})

  local group = vim.api.nvim_create_augroup("Worklist", { clear = true })

  -- Join the list on the first modification.
  vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].modified then
        M.keep(args.buf)
      end
    end,
  })

  -- Drop buffers that are really closed.
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
      M.remove(args.buf)
    end,
  })
end

return M
