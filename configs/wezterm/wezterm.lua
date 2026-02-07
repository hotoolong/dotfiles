local wezterm = require("wezterm")
local config = wezterm.config_builder()
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local prefixes = {
  '/opt/homebrew',
  '/home/linuxbrew/.linuxbrew',
  '/usr/local',
}

for _, prefix in ipairs(prefixes) do
  local fish = prefix .. '/bin/fish'
  local f = io.open(fish, 'r')
  if f then
    f:close()
    config.default_prog = { fish }
    break
  end
end

config.automatically_reload_config = true
config.font = wezterm.font_with_fallback({
  "Moralerspace Neon",
  "Menlo",
  "Hiragino Kaku Gothic Pro",
})
config.font_size = 13.0
config.use_ime = true
config.macos_window_background_blur = 20

config.initial_cols = 200
config.initial_rows = 80

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
  }
}
----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる (Kanagawa Dragon)
config.window_background_gradient = {
  colors = { "#181616" },
}

-- タブの追加ボタンを非表示
-- config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
-- Kanagawa Dragon カラースキーム
config.colors = {
  foreground = "#c5c9c5",
  background = "#181616",
  cursor_bg = "#c5c9c5",
  cursor_fg = "#181616",
  cursor_border = "#c5c9c5",
  selection_bg = "#2d4f67",
  selection_fg = "#c5c9c5",
  scrollbar_thumb = "#282727",
  split = "#c4b28a",
  ansi = {
    "#0d0c0c", -- black
    "#c4746e", -- red
    "#8a9a7b", -- green
    "#c4b28a", -- yellow
    "#8ba4b0", -- blue
    "#a292a3", -- magenta
    "#8ea4a2", -- cyan
    "#c5c9c5", -- white
  },
  brights = {
    "#625e5a", -- bright black
    "#e46876", -- bright red
    "#87a987", -- bright green
    "#e6c384", -- bright yellow
    "#7fb4ca", -- bright blue
    "#938aa9", -- bright magenta
    "#7aa89f", -- bright cyan
    "#dcd7ba", -- bright white
  },
  tab_bar = {
    inactive_tab_edge = "none",
    background = "#181616",
  },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

return config

