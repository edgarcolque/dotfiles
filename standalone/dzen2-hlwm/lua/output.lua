local gmc = require('.gmc')
local common = require('.common')
local helper = require('.helper')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

-- assuming $ herbstclient tag_status
-- 	#1	:2	:3	:4	.5	.6	.7	.8	.9

-- custom tag names
_M.tag_shows = {'一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū'}

-- initialize variable segment
_M.segment_windowtitle = '' -- empty string
_M.tags_status         = {} -- empty table
_M.segment_datetime    = '' -- empty string

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- decoration

_M.separator = '^bg()^fg(' .. gmc.color['black'] .. ')|^bg()^fg()'

-- http://fontawesome.io/
_M.font_awesome = '^fn(FontAwesome-9)'

-- Powerline Symbol
_M.right_hard_arrow = '^fn(powerlinesymbols-14)^fn()'
_M.right_soft_arrow = '^fn(powerlinesymbols-14)^fn()'
_M.left_hard_arrow  = '^fn(powerlinesymbols-14)^fn()'
_M.left_soft_arrow  = '^fn(powerlinesymbols-14)^fn()'

-- theme
_M.pre_icon    = '^fg(' .. gmc.color['yellow500'] .. ')' 
              .. _M.font_awesome
_M.post_icon   = '^fn()^fg()'

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

function _M.get_statusbar_text(monitor)
    local text = ''
    
    -- draw tags, non zero based
    for index = 1, #(_M.tags_status) do
        text = text .. _M.output_by_tag(monitor, _M.tags_status[index])
    end

    -- draw date and time
    text = text .. _M.output_by_datetime()

    -- draw window title    
    text = text .. _M.output_by_title()
  
    return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- each segments

function _M.output_by_tag(monitor, tag_status)
    local tag_index  = string.sub(tag_status, 2, 2)
    local tag_mark   = string.sub(tag_status, 1, 1)
    local index      = tonumber(tag_index)-- not a zero based array
    local tag_name   = _M.tag_shows[index]

    -- ----- pre tag

    local text_pre = ''
    if tag_mark == '#' then
        text_pre = '^bg(' .. gmc.color['blue500'] .. ')'
                .. '^fg(' .. gmc.color['black'] .. ')'
                .. _M.right_hard_arrow
                .. '^bg(' .. gmc.color['blue500'] .. ')'
                .. '^fg(' .. gmc.color['white'] .. ')'
    elseif tag_mark == '+' then
        text_pre = '^bg(' .. gmc.color['yellow500'] .. ')'
                .. '^fg(' .. gmc.color['grey400'] .. ')'
    elseif tag_mark == ':' then
        text_pre = '^bg()'
                 .. '^fg(' .. gmc.color['white'] .. ')'
    elseif tag_mark == '!' then
        text_pre = '^bg(' .. gmc.color['red500'] .. ')'
                .. '^fg(' .. gmc.color['white'] .. ')'
    else
        text_pre = '^bg()'
                .. '^fg(' .. gmc.color['grey600'] .. ')'
    end

    -- ----- tag by number
    
    -- assuming using dzen2_svn
    -- clickable tags if using SVN dzen
    local text_name = '^ca(1,herbstclient focus_monitor '
                   .. '"' .. monitor .. '" && '
                   .. 'herbstclient use "' .. tag_index .. '")'
                   .. ' ' .. tag_name ..' ^ca()'

    -- ----- post tag

    local text_post = ""
    if (tag_mark == '#') then
        text_post = '^bg(' .. gmc.color['black'] .. ')'
                       .. '^fg(' .. gmc.color['blue500'] .. ')'
                       .. _M.right_hard_arrow
    end

     
    return text_pre .. text_name .. text_post
end

function _M.output_by_title()
    local text = ' ^r(5x0) ' .. _M.separator .. ' ^r(5x0) '
               .. _M.segment_windowtitle

    return text
end

function _M.output_by_datetime()
    local text = ' ^r(5x0) ' .. _M.separator .. ' ^r(5x0) '
               .. _M.segment_datetime

    return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- setting variables, response to event handler

function _M.set_tag_value(monitor)
    local command = 'herbstclient tag_status ' .. monitor
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close() 
        
    local raw = common.trim1(result)  
    _M.tags_status = common.split(raw, "\t")
end

function _M.set_windowtitle(windowtitle)
    local icon = _M.pre_icon .. '' .. _M.post_icon
    if (windowtitle == nil) then windowtitle = '' end
      
    _M.segment_windowtitle = ' ' .. icon ..
        ' ^bg()^fg(' .. gmc.color['grey700'] .. ') ' .. windowtitle
end

function _M.set_datetime()
    local date_icon = _M.pre_icon .. '' .. _M.post_icon
    local date_str  = os.date('%a %b %d')     
    local date_text = date_icon .. ' ^bg()'
        .. '^fg(' .. gmc.color['grey700'] .. ') ' .. date_str

    local time_icon = _M.pre_icon .. '' .. _M.post_icon
    local time_str  = os.date('%H:%M:%S')
    local time_text = time_icon .. ' ^bg()'
        .. '^fg(' .. gmc.color['blue500'] .. ') ' .. time_str

    _M.segment_datetime = date_text .. '  ' .. time_text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
