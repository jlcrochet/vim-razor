local insert = table.insert

local v = vim.v
local g = vim.g
local bo = vim.bo

local fn = vim.fn
local prevnonblank = fn.prevnonblank
local shiftwidth = fn.shiftwidth
local indent = fn.indent
local synID = fn.synID
local synIDattr = fn.synIDattr
local cindent = fn.cindent

local api = vim.api
local nvim_get_current_line = api.nvim_get_current_line
local nvim_command = api.nvim_command
local nvim_eval = api.nvim_eval
local nvim_buf_get_lines = api.nvim_buf_get_lines

-- Load the settings for each filetype:
nvim_command "runtime! indent/javascript.vim | unlet b:did_indent"
local js_indentexpr = bo.indentexpr

nvim_command "runtime! indent/css.vim"
local css_indentexpr = bo.indentexpr

local cs_sw = g.razor_cs_shiftwidth or bo.shiftwidth
local js_sw = g.razor_js_shiftwidth or bo.shiftwidth
local css_sw = g.razor_css_shiftwidth or bo.shiftwidth

local void_elements = {
  area = true,
  base = true,
  br = true,
  col = true,
  command = true,
  embed = true,
  hr = true,
  img = true,
  input = true,
  keygen = true,
  link = true,
  meta = true,
  param = true,
  source = true,
  track = true,
  wbr = true
}

local syngroups = {}

local function syngroup_at(lnum, idx)
  local synid = synID(lnum, idx + 1, false)

  if synid == 0 then
    return
  end

  local syngroup = syngroups[synid]

  if not syngroup then
    local name = synIDattr(synid, "name")

    syngroups[synid] = name
    syngroup = name
  end

  return syngroup
end

local function get_line(lnum)
  return nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
end

local function is_tag_bracket(lnum, idx)
  local syngroup = syngroup_at(lnum, idx)
  return syngroup == "razorhtmlTag" or syngroup == "razorhtmlEndTag"
end

local function is_word(b)
  -- [%w_.:-]
  return b == 45 or  -- -
    b == 46 or  -- .
    b == 58 or  -- :
    b == 95 or  -- _
    b >= 48 and b <= 57 or  -- %d
    b >= 65 and b <= 90 or  -- %u
    b >= 97 and b <= 122  -- %l
end

local function tag_name_at(line, col)
  local finish

  for i = col, #line do
    if not is_word(line:byte(i)) then
      finish = i - 1
      break
    end
  end

  return line:sub(col, finish)
end

-- Retrieve the last non-comment byte of the given line; used for C#
-- indentation.
--
-- First, try to find a comment delimiter: if one is found, the
-- non-whitespace byte immediately before it is the last byte; else,
-- simply find the last non-whitespace byte in the line.
local function get_last_byte(lnum)
  local line = get_line(lnum)
  local col = -1
  local syngroup, target_syngroup

  repeat
    local found = false

    for i = col + 2, #line do
      local b = line:byte(i)

      if b == 47 then  -- /
        local b2 = line:byte(i + 1)

        if b2 == 42 or b2 == 47 then  -- * /
          found = true
          col = i
          target_syngroup = "razorcsCommentDelimiter"

          break
        end
      elseif b == 64 then  -- @
        if line:byte(i + 1) == 42 then  -- *
          found = true
          col = i
          target_syngroup = "razorCommentDelimiter"

          break
        end
      end
    end

    if not found then
      for i = #line, 1, -1 do
        local b = line:byte(i)

        if b > 32 then
          return b, i, line
        end
      end
    end

    syngroup = syngroup_at(lnum, col)
  until syngroup == target_syngroup

  for i = col - 1, 1, -1 do
    local b = line:byte(i)

    if b > 32 then
      return b, i, line
    end
  end

  return nil, col, line
end

local function get_indent_info(lnum, line)
  local lnums = { lnum }
  local lines = { line }

  local i = 1

  while true do
    local b

    for i = 1, #line do
      b = line:byte(i)

      if b > 32 then
        break
      end
    end

    if b == 60 then  -- <
      break
    else
      local syngroup = syngroup_at(lnum, 0)

      if syngroup == "razorBlock" or syngroup == "razorcsBlock" or syngroup == "razorDelimiter" then
        break
      end
    end

    lnum = prevnonblank(lnum - 1)

    if lnum == 0 then
      break
    end

    line = get_line(lnum)

    insert(lnums, lnum)
    insert(lines, line)

    i = i + 1
  end

  local pairs = 0

  while i > 0 do
    local lnum = lnums[i]
    local line = lines[i]

    local j = 1
    local upper = #line

    while j <= upper do
      local b = line:byte(j)

      if b == 60 then  -- <
        local syngroup = syngroup_at(lnum, j - 1)

        if syngroup == "razorhtmlTag" then
          local tag_name = tag_name_at(line, j + 1)

          j = j + #tag_name

          if void_elements[tag_name] then
            repeat
              j = line:find(">", j + 1)
            until not j or syngroup_at(lnum, j - 1) == "razorhtmlTag"

            if not j then
              -- Adjust the position to the next closing bracket.
              for k = i - 1, 1, -1 do
                lnum = lnums[k]
                line = lines[k]

                j = 0

                repeat
                  j = line:find(">", j + 1)
                until not j or syngroup_at(lnum, j - 1) == "razorhtmlTag"

                if j then
                  i = k
                  break
                end
              end
            end
          else
            pairs = pairs + 1
          end
        elseif syngroup == "razorhtmlEndTag" then
          pairs = pairs - 1
        end
      elseif b == 62 then  -- >
        if line:byte(j - 1) == 47 and syngroup_at(lnum, j - 1) == "razorhtmlTag" then  -- /
          pairs = pairs - 1
        end
      end

      j = j + 1
    end

    i = i - 1
  end

  return lnums[#lnums], pairs > 0 and 1 or 0
end

return function()
  local lnum = v.lnum
  local prev_lnum = prevnonblank(lnum - 1)

  if prev_lnum == 0 then
    return 0
  end

  local syngroup = syngroup_at(lnum, 0)

  -- Is this line inside of a multiline region?
  if syngroup == "razorComment" or syngroup == "razorhtmlComment" or syngroup == "razorcsComment" or syngroup == "razorcsString" then
    return -1
  end

  local line = nvim_get_current_line()
  local col, b

  for i = 1, #line do
    b = line:byte(i)

    if b > 32 then  -- %S
      col = i
      break
    end
  end

  if syngroup then
    -- Does this line begin with the closing tag for a style or script
    -- element?
    if b == 60 and line:byte(col + 1) == 47 and line:byte(col + 2) == 115 then  -- < / s
      local b2 = line:byte(col + 3)

      if b2 == 99 then  -- c
        if line:byte(col + 4) == 114 and  -- r
          line:byte(col + 5) == 105 and  -- i
          line:byte(col + 6) == 112 and  -- p
          line:byte(col + 7) == 116 and  -- t
          line:byte(col + 8) == 62 then  -- >
          return indent(prev_lnum) - shiftwidth()
        end
      elseif b2 == 116 then  -- t
        if line:byte(col + 4) == 121 and  -- y
          line:byte(col + 5) == 108 and  -- l
          line:byte(col + 6) == 101 and  -- e
          line:byte(col + 7) == 62 then  -- >
          return indent(prev_lnum) - shiftwidth()
        end
      end
    end

    -- Is this line inside of a script element?
    if syngroup == "razorhtmlScript" or
      syngroup:byte(1) == 106 and  -- j
      syngroup:byte(2) == 97 and  -- a
      syngroup:byte(3) == 118 and  -- v
      syngroup:byte(4) == 97 and  -- a
      syngroup:byte(5) == 115 and  -- s
      syngroup:byte(6) == 99 and  -- c
      syngroup:byte(7) == 114 and  -- r
      syngroup:byte(8) == 105 and  -- i
      syngroup:byte(9) == 112 and  -- p
      syngroup:byte(10) == 116 then  -- t
      -- Is the previous line the beginning tag of the element?
      local prev_line = get_line(prev_lnum)
      local col = 0

      repeat
        col = prev_line:find("<script", col + 1)
      until not col or not is_word(prev_line:byte(col + 7)) and syngroup_at(prev_lnum, col) == "razorhtmlTag"

      if col then
        return col - 1 + shiftwidth()
      end

      -- Otherwise, use JS indentation.
      local old_sw = bo.shiftwidth
      bo.shiftwidth = js_sw

      local ind = nvim_eval(js_indentexpr)
      bo.shiftwidth = old_sw

      return ind
    end

    -- Is this line inside of a style tag?
    if syngroup == "razorhtmlStyle" or
      syngroup:byte(1) == 99 and  -- c
      syngroup:byte(2) == 115 and  -- s
      syngroup:byte(3) == 115 then  -- s
      -- Is the previous line the beginning tag of the element?
      local prev_line = get_line(prev_lnum)
      local col = 0

      repeat
        col = prev_line:find("<style", col + 1)
      until not col or not is_word(prev_line:byte(col + 6)) and syngroup_at(prev_lnum, col) == "razorhtmlTag"

      if col then
        return col - 1 + shiftwidth()
      end

      -- Otherwise, use CSS indentation.
      local old_sw = bo.shiftwidth
      bo.shiftwidth = css_sw

      local ind = nvim_eval(css_indentexpr)
      bo.shiftwidth = old_sw

      return ind
    end

    -- Is this line inside of a multiline tag?
    if b ~= 60 and syngroup == "razorhtmlTag" or syngroup == "razorhtmlAttribute" then  -- <
      local prev_line = get_line(prev_lnum)
      local col

      for i = 1, #prev_line do
        local b = prev_line:byte(i)

        if b > 32 then  -- %S
          if b == 60 then  -- <
            col = prev_line:find(" ", i + 1)

            for j = col + 1, #prev_line do
              if prev_line:byte(j) > 32 then  -- %S
                col = j
                break
              end
            end

            break
          else
            col = i
            break
          end
        end
      end

      return col - 1
    end

    -- Is this line inside of a Razor block?
    if syngroup == "razorDelimiter" or syngroup == "razorBlock" or syngroup == "razorcsBlock" or
      syngroup:byte(1) == 114 and  -- r
      syngroup:byte(2) == 97 and  -- a
      syngroup:byte(3) == 122 and  -- z
      syngroup:byte(4) == 111 and  -- o
      syngroup:byte(5) == 114 and  -- r
      syngroup:byte(6) == 99 and  -- c
      syngroup:byte(7) == 115 then  -- s
      -- First, we need to check for some cases that `cindent` can't
      -- handle.

      if b == 125 then  -- }
        -- Use `cindent`.
        local old_sw = bo.shiftwidth
        bo.shiftwidth = cs_sw

        local ind = cindent(lnum)
        bo.shiftwidth = old_sw

        return ind
      elseif b == 64 then  -- @
        local last_byte, _, prev_line = get_last_byte(prev_lnum)

        if last_byte == 123 then  -- {
          -- Add a shift.
          return indent(prev_lnum) + cs_sw
        elseif last_byte == 62 then  -- >
          -- Use HTML indentation.
          local shift = 0

          if b == 60 and line:byte(col + 1) == 47 then  -- < /
            shift = shift - 1
          end

          local start_lnum, prev_shift = get_indent_info(prev_lnum, prev_line)

          shift = shift + prev_shift

          return indent(start_lnum) + shift * shiftwidth()
        else
          -- Otherwise, simply align with the previous line.
          return indent(prev_lnum)
        end
      end

      -- Find the last byte of the previous line.
      local last_byte, last_col, prev_line = get_last_byte(prev_lnum)

      if not last_byte then
        -- The previous line is a line comment.
        return indent(prev_lnum)
      end

      if last_byte == 62 and is_tag_bracket(prev_lnum, last_col - 1) then -- >
        return indent(prev_lnum)
      end

      -- Find the first byte of the previous line.
      for i = 1, #prev_line do
        local b = prev_line:byte(i)

        if b > 32 then
          if b == 64 and prev_line:byte(i + 1) == 58 then  -- @ :
            return i - 1
          elseif b == 91 then  -- [
            return i - 1
          end

          break
        end
      end

      -- Now we can fall back to `cindent`.
      local old_sw = bo.shiftwidth
      bo.shiftwidth = cs_sw

      local ind = cindent(lnum)
      bo.shiftwidth = old_sw

      return ind
    end
  end

  -- Special case: if we aren't inside of a syngroup, make sure that the
  -- previous character isn't a Razor delimiter.
  local last_byte, last_col, prev_line = get_last_byte(prev_lnum)

  if last_byte == 123 and syngroup_at(prev_lnum, last_col - 1) == "razorDelimiter" then  -- {
    return indent(prev_lnum) + cs_sw
  end

  -- Otherwise, proceed with normal HTML indentation.
  local shift = 0

  if b == 60 and line:byte(col + 1) == 47 then  -- < /
    shift = shift - 1
  end

  local start_lnum, prev_shift = get_indent_info(prev_lnum, prev_line)

  shift = shift + prev_shift

  return indent(start_lnum) + shift * shiftwidth()
end
