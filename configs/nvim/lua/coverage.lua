vim.cmd [[
  sign define UncoveredLine text=⚠ texthl=Error
]]

local coverage_data = nil
local coverage_file_path = "coverage/.resultset.json"
local coverage_file_mtime = nil

local function get_file_mtime(file_path)
  local file_stat = vim.loop.fs_stat(file_path)
  if file_stat then
    return file_stat.mtime.sec
  else
    return nil
  end
end

local function read_coverage_data(file_path)
  local current_mtime = get_file_mtime(file_path)
  if current_mtime ~= coverage_file_mtime then
    local file = io.open(file_path, "r")
    if file then
      local content = file:read("*a")
      file:close()
      local data = vim.json.decode(content)
      coverage_data = data["RSpec"]["coverage"]
      coverage_file_mtime = current_mtime
    else
      coverage_data = nil
      coverage_file_mtime = nil
    end
  end
  return coverage_data
end

local function get_uncovered_lines(file_path)
  local uncovered_lines = {}
  local file_data = coverage_data[file_path]
  if file_data then
    for _, line_data in ipairs(file_data.lines) do
      if line_data == 0 then
        table.insert(uncovered_lines, _)
      end
    end
  end
  return uncovered_lines
end

local function mark_uncovered_lines()
  local current_file = vim.fn.expand("%:p")

  local uncovered_lines = get_uncovered_lines(current_file)

  for _, line_number in ipairs(uncovered_lines) do
    vim.fn.sign_place(0, "uncovered", "UncoveredLine", vim.fn.bufname(), { lnum = line_number })
  end
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.bo.filetype == "ruby" or vim.bo.filetype == "eruby" then
      read_coverage_data(coverage_file_path)
      mark_uncovered_lines()
    end
  end
})
