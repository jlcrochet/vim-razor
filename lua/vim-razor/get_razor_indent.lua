local v = vim.v
local b = vim.b
local bo = vim.bo

local fn = vim.fn
local prevnonblank = fn.prevnonblank
local shiftwidth = fn.shiftwidth
local indent = fn.indent
local searchpos = fn.searchpos
local cindent = fn.cindent
local getline = fn.getline
local synID = fn.synID
local synIDattr = fn.synIDattr
local synstack = fn.synstack

local api = vim.api
local nvim_get_current_line = api.nvim_get_current_line
local nvim_eval = api.nvim_eval
local nvim_buf_line_count = api.nvim_buf_line_count
local nvim_win_get_cursor = api.nvim_win_get_cursor
local nvim_win_set_cursor = api.nvim_win_set_cursor
local nvim_command = api.nvim_command

nvim_command "runtime! indent/javascript.lua indent/javascript.vim"
b.did_indent = false
local js_indentexpr = bo.indentexpr

nvim_command "runtime! indent/css.lua indent/css.vim"
local css_indentexpr = bo.indentexpr

local function syngroup_at(lnum, col)
  return synIDattr(synID(lnum, col, false), "name")
end

local function get_pos()
  local pos = nvim_win_get_cursor(0)
  return pos[1], pos[2] + 1
end

local function set_pos(lnum, col)
  nvim_win_set_cursor(0, { lnum, col - 1 })
end

local function search(re, skip_func, move_cursor, include_current, stop_line)
  stop_line = stop_line or nvim_buf_line_count(0)

  local lnum, col = get_pos()

  if include_current == true then
    local pos = searchpos(re, "cz", stop_line)
    local found_lnum, found_col = pos[1], pos[2]

    if found_lnum == 0 then
      return
    end

    if not skip_func(found_lnum, found_col) then
      if move_cursor == false then
        set_pos(lnum, col)
      end

      return found_lnum, found_col
    end
  end

  local pos, found_lnum, found_col

  repeat
    pos = searchpos(re, "z", stop_line)
    found_lnum, found_col = pos[1], pos[2]

    if found_lnum == 0 then
      return set_pos(lnum, col)
    end
  until not skip_func(found_lnum, found_col)

  if move_cursor == false then
    set_pos(lnum, col)
  end

  return found_lnum, found_col
end

local function search_back(re, skip_func, move_cursor, include_current, stop_line)
  stop_line = stop_line or 1

  local lnum, col = get_pos()

  if include_current == true then
    local pos = searchpos(re, "bc", stop_line)
    local found_lnum, found_col = pos[1], pos[2]

    if found_lnum == 0 then
      return
    end

    if not skip_func(found_lnum, found_col) then
      if move_cursor == false then
        set_pos(lnum, col)
      end

      return found_lnum, found_col
    end
  end

  local pos, found_lnum, found_col

  repeat
    pos = searchpos(re, "b", stop_line)
    found_lnum, found_col = pos[1], pos[2]

    if found_lnum == 0 then
      return set_pos(lnum, col)
    end
  until not skip_func(found_lnum, found_col)

  if move_cursor == false then
    set_pos(lnum, col)
  end

  return found_lnum, found_col
end

local function searchpair_back(start_re, middle_re, end_re, skip_func, move_cursor, include_current, stop_line)
  stop_line = stop_line or 1

  -- First, we need to make two patterns: one for top-level pairs,
  -- another for nested pairs. The first will consist of the start and
  -- end patterns; the second will consist of the start, end, and middle
  -- patterns, assuming a middle pattern has been provided.
  local top_re = "\\m\\("..start_re.."\\m\\)\\|\\("..end_re.."\\m\\)"
  local nested_re

  if middle_re then
    nested_re = "\\m\\("..start_re.."\\m\\)\\|\\("..end_re.."\\m\\)\\|\\("..middle_re.."\\m\\)"
  else
    nested_re = top_re
  end

  local lnum, col = get_pos()
  local pattern = nested_re
  local nest = 1

  if include_current == true then
    local pos = searchpos(pattern, "cbp", stop_line)
    local found_lnum, found_col, found_sub = pos[1], pos[2], pos[3]

    if found_lnum == 0 then
      return
    end

    if skip_func(found_lnum, found_col, found_sub) then
      goto skip
    end

    if found_sub == 3 then  -- End pattern was found
      nest = nest + 1
      pattern = top_re
    else
      nest = nest - 1

      if nest == 1 then
        pattern = nested_re
      elseif nest == 0 then
        if move_cursor == false then
          set_pos(lnum, col)
        end

        return found_lnum, found_col
      end
    end

    ::skip::
  end

  local pos, found_lnum, found_col, found_sub

  ::loop::

  repeat
    pos = searchpos(pattern, "bp", stop_line)
    found_lnum, found_col, found_sub = pos[1], pos[2], pos[3]

    if found_lnum == 0 then
      return set_pos(lnum, col)
    end
  until not skip_func(found_lnum, found_col, found_sub)

  if found_sub == 3 then  -- End pattern was found
    nest = nest + 1
    pattern = top_re
  else
    nest = nest - 1

    if nest == 1 then
      pattern = nested_re
    elseif nest == 0 then
      if move_cursor == false then
        set_pos(lnum, col)
      end

      return found_lnum, found_col
    end
  end

  goto loop
end

local function get_line_with_first_byte(lnum)
  local line

  if lnum then
    line = getline(lnum)
  else
    line = nvim_get_current_line()
  end

  local b, col

  for i = 1, #line do
    b = line:byte(i)

    if b > 32 then
      col = i
      break
    end
  end

  return line, b, col
end

local function get_line_with_first_and_last_bytes(lnum)
  local line, first_byte, first_col = get_line_with_first_byte(lnum)
  local offset = first_col
  local found, target_syngroup

  repeat
    found = line:find("[/<@]", offset)

    if not found then
      for i = #line, first_col, -1 do
        local b = line:byte(i)

        if b > 32 then
          return line, first_byte, first_col, b, i
        end
      end
    end

    local b = line:byte(found)

    if b == 47 then  -- /
      offset = offset + 2
      target_syngroup = "razorcsCommentStart"
    elseif b == 60 then  -- <
      offset = offset + 4
      target_syngroup = "razorhtmlCommentStart"
    elseif b == 64 then  -- @
      offset = offset + 2
      target_syngroup = "razorCommentStart"
    end
  until syngroup_at(lnum, found) == target_syngroup

  if found == first_col then
    return line, first_byte, first_col
  end

  for i = found - 1, first_col, -1 do
    local b = line:byte(i)

    if b > 32 then
      return line, first_byte, first_col, b, i
    end
  end
end

local function get_start_line(lnum, skip_func)
  while skip_func(lnum) do
    local prev_lnum = prevnonblank(lnum - 1)

    if prev_lnum == 0 then
      return lnum
    end

    lnum = prev_lnum
  end

  return lnum
end

local function skip_bracket(lnum, col)
  local syngroup = syngroup_at(lnum, col)
  return syngroup ~= "razorhtmlTag" and syngroup ~= "razorInnerHTMLEndBracket"
end

local function skip_tag(lnum, col, p)
  if p == 2 then
    if syngroup_at(lnum, col) ~= "razorhtmlTag" then
      return true
    end

    local l, c = search(">", skip_bracket, false)
    local line = getline(l)

    if line:byte(c - 1) == 47 then  -- /
      return true
    end

    return false
  elseif p == 3 then
    return syngroup_at(lnum, col) ~= "razorhtmlEndTag"
  end
end

local function skip_line(lnum)
  local syngroup = syngroup_at(lnum, 1)

  return syngroup == "razorhtmlComment" or syngroup == "razorhtmlCommendEnd" or
    syngroup == "razorhtmlTag" and getline(lnum):byte(1) ~= 60 or
    syngroup == "razorInvocation" or syngroup == "razorcsInvocation" or syngroup == "razorcsRHSInvocation" or
    syngroup == "razorIndex" or syngroup == "razorcsIndex" or syngroup == "razorcsRHSIndex"
end

function get_razor_indent()
  local lnum = v.lnum
  local prev_lnum = prevnonblank(lnum - 1)

  if prev_lnum == 0 then
    return 0
  end

  local line, b, col
  local syngroup = syngroup_at(lnum, 1)

  if syngroup == "razorComment" or syngroup == "razorCommentEnd" or
    syngroup == "razorhtmlComment" or syngroup == "razorhtmlCommentEnd" or
    syngroup == "razorcsComment" or syngroup == "razorcsCommentEnd" then
    -- Comment:
    -- Do nothing.
    return -1
  elseif syngroup == "razorhtmlScript" or syngroup:sub(1, 10) == "javascript" then
    -- `script` tag:
    -- Use JS indentation.
    line, b, col = get_line_with_first_byte()

    if b == 60 and line:sub(col + 1, col + 8) == "/script>" then  -- <
      return indent(prev_lnum) - shiftwidth()
    end

    if search_back("<script[[:space:]>]\\@=", skip_bracket, false, false, prev_lnum) then
      return indent(prev_lnum) + shiftwidth()
    end

    return nvim_eval(js_indentexpr)
  elseif syngroup == "razorhtmlStyle" or syngroup:sub(1, 3) == "css" then
    -- `style` tag:
    -- Use CSS indentation.
    line, b, col = get_line_with_first_byte()

    if b == 60 and line:sub(col + 1, col + 7) == "/style>" then  -- <
      return indent(prev_lnum) - shiftwidth()
    end

    if search_back("<style[[:space:]>]\\@=", skip_bracket, false, false, prev_lnum) then
      return indent(prev_lnum) + shiftwidth()
    end

    return nvim_eval(css_indentexpr)
  elseif syngroup == "razorhtmlAttribute" then
    -- Tag attribute:
    goto html_attribute
  elseif syngroup == "razorhtmlTag" then
    -- Multiline tag:
    line, b, col = get_line_with_first_byte()

    if b == 60 then  -- <
      goto default
    elseif b == 47 then  -- /
      local lnum = search_back("<", skip_bracket)
      return indent(lnum)
    else
      goto html_attribute
    end
  elseif syngroup == "razorDelimiter" then
    line = nvim_get_current_line()
    b = line:byte(1)
    col = 1

    if b == 64 then  -- @
      local synstack = synstack(lnum, 1)
      local outer_synid = synstack[#synstack - 1]

      if outer_synid then
        local outer_syngroup = synIDattr(outer_synid, "name")

        if outer_syngroup == "razorhtmlTag" or outer_syngroup == "razorInnerHTMLTag" then
          goto html_attribute
        end
      end
    elseif b == 123 then  -- {
      return indent(prev_lnum)
    elseif b == 125 then  -- }
      return cindent(lnum)
    end
  elseif syngroup == "razorcsDelimiter" then
    return cindent(lnum)
  elseif syngroup == "razorInnerHTMLBlock" then
    line, b, col = get_line_with_first_byte()
    goto html
  end

  line, b, col = get_line_with_first_byte()

  ::default:: do
    if b == 123 then  -- {
      local syngroup = syngroup_at(lnum, col)

      if syngroup == "razorDelimiter" then
        return indent(prev_lnum)
      elseif syngroup == "razorcsDelimiter" then
        return cindent(lnum)
      end
    elseif b == 125 then  -- }
      return cindent(lnum)
    elseif b == 60 and line:byte(col + 1) == 47 then  -- < /
      goto html
    end

    local prev_line, prev_first_byte, prev_first_col, prev_last_byte, prev_last_col = get_line_with_first_and_last_bytes(prev_lnum)

    if not prev_last_byte then
      -- Previous line was a comment line.
      return indent(prev_lnum)
    end

    if prev_last_byte == 123 then  -- {
      local syngroup = syngroup_at(prev_lnum, prev_last_col)

      if syngroup == "razorDelimiter" or syngroup == "razorcsDelimiter" then
        return cindent(lnum)
      end
    elseif prev_last_byte == 125 then  -- }
      local syngroup = syngroup_at(prev_lnum, prev_last_col)

      if syngroup == "razorDelimiter" then
        goto html
      elseif syngroup == "razorcsDelimiter" then
        return cindent(lnum)
      end
    elseif prev_last_byte == 62 then  -- >
      local syngroup = syngroup_at(prev_lnum, prev_last_col)

      if syngroup == "razorhtmlTag" or syngroup == "razorhtmlEndTag" or syngroup == "razorInnerHTMLEndBracket" then
        goto html
      else
        return cindent(lnum)
      end
    elseif prev_last_byte == 93 then  -- ]
      if syngroup_at(prev_lnum, prev_last_col) == "razorcsAttributeDelimiter" then
        return indent(prev_lnum)
      end
    elseif prev_first_byte == 64 then  -- @
      return indent(get_start_line(prev_lnum, skip_line))
    else
      return cindent(lnum)
    end
  end

  ::html:: do
    -- Default HTML indentation:
    local shift = 0

    if b == 60 and line:byte(col + 1) == 47 then  -- < /
      shift = shift - 1
    end

    local start_lnum = get_start_line(prev_lnum, skip_line)

    set_pos(lnum, 1)

    local lnum, col = searchpair_back("</\\@!", nil, "</", skip_tag, true, false, start_lnum)

    if lnum then
      local line = nvim_get_current_line()
      local name = line:match("^[^/>%s]+", col + 1)

      if name ~= "area" and name ~= "base" and name ~= "br" and name ~= "col" and name ~= "embed" and name ~= "hr" and name ~= "img" and
        name ~= "input" and name ~= "keygen" and name ~= "link" and name ~= "meta" and name ~= "param" and name ~= "source" and
        name ~= "track" and name ~= "wbr" then
        shift = shift + 1
      end
    end

    return indent(start_lnum) + shift * shiftwidth()
  end

  ::html_attribute:: do
    -- If the previous line began with an attribute, align with that
    -- attribute; else, if it began with a tag, align with the first
    -- attribute after that tag, unless there is no attribute after the
    -- tag, in which case add a shift.
    local prev_line, b, col = get_line_with_first_byte(prev_lnum)

    if b == 60 then  -- <
      local col2

      for i = col + 1, #prev_line do
        if prev_line:byte(i) <= 32 then
          col2 = i
          break
        end
      end

      if col2 then
        for i = col2 + 1, #prev_line do
          if prev_line:byte(i) > 32 then
            return i - 1
          end
        end
      end

      return col - 1 + shiftwidth()
    else
      return col - 1
    end
  end
end
