-- Move & Resize window to left 50% of screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Move & Resize window to Right 50% of screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Maximize Screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- Center Window @ 75% Width --
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.w * .125)
  f.y = max.y
  f.w = max.w * .75
  f.h = max.h
  win:setFrame(f)
end)

-- ANY COMPLETE BEGIN --
local urlencode = require("urlencode")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local GOOGLE_ENDPOINT = 'https://www.google.com/complete/search?client=hp&hl=en&xhr=t&q=%s'
    local current = hs.application.frontmostApplication()

    local chooser = hs.chooser.new(function(choosen)
        current:activate()
        hs.eventtap.keyStrokes(choosen.text)
    end)

    chooser:queryChangedCallback(function(string)
        local query = urlencode.string(string)

        hs.http.asyncGet(string.format(GOOGLE_ENDPOINT, query), nil, function(status, data)
            if not data then return end

            local results = hs.json.decode(data)

            if not results then return end

            choices = hs.fnutils.imap(results[2], function(result)
                return {
                    ["text"] = string.gsub(result[1], '</?b>', ''),
                }
            end)

            chooser:choices(choices)
        end)
    end)

    chooser:searchSubText(false)

    chooser:show()
end)
-- ANY COMPLETE END --
