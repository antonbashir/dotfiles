local terminal    = "kitty"
local fileManager = "nemo"
local launcher    = "~/.config/hypr/scripts/launcher"
local powermenu   = "~/.config/hypr/scripts/powermenu"
local volume      = "~/.config/hypr/scripts/volume"
local xdg         = "~/.config/hypr/scripts/xdg-portal"
local superKey    = "SUPER"

hl.monitor({ output = "DP-1", mode = "5120x2880", position = "0x0", scale = "2" })
hl.monitor({ output = "DP-2", mode = "5120x2880", position = "2560x0", scale = "2" })
hl.monitor({ output = "DP-3", mode = "3840x2160", position = "5120x0", scale = "1.25" })

hl.env("GTK_THEME", "Colloid-Dark")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
  hl.exec_cmd("hyprlock --grace 0 --immediate-render --no-fade-in")
  hl.exec_cmd(xdg)
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("mako")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("pactl load-module module-switch-on-connect")
  hl.exec_cmd("lianwall start")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprshade on vibrance")
end)

hl.exec_cmd("hyprshade on vibrance")

hl.config({
  debug = {
    disable_scale_checks = true,
    enable_stdout_logs = false,
  },

  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 0,
    layout = "dwindle",
  },

  cursor = {
    no_hardware_cursors = true,
    no_warps = true,
  },

  decoration = {
    rounding = 32,
    rounding_power = 8.0,
    blur = {
      enabled = false,
    },
    shadow = {
      enabled = true,
      range = 24,
      render_power = 16,
      color = "rgba(7734ebff)",
      color_inactive = "rgba(0892d0ff)",
    },
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_watchdog_warning = true,
    vrr = 0,
    allow_session_lock_restore = true,
    enable_anr_dialog = false,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {},

  input = {
    kb_layout = "us,ru",
    kb_variant = "",
    kb_model = "",
    kb_options = "grp:lctrl_lwin_toggle",
    kb_rules = "",
    follow_mouse = 1,
    touchpad = { natural_scroll = false },
    sensitivity = 0,
  },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volume .. " --toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(volume .. " --toggle-mic"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))

hl.bind("code:156", hl.dsp.exec_cmd("rog-control-center"))
hl.bind("code:211", hl.dsp.exec_cmd("asusctl profile -n"))
hl.bind("code:210", hl.dsp.exec_cmd("asusctl led-mode -n"))

hl.bind("f4", hl.dsp.exec_cmd(launcher))
hl.bind("print", hl.dsp.exec_cmd("grim -t jpeg -g \"$(slurp)\" - | swappy -f -"))
hl.bind("CTRL + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme ~/.config/rofi/dmenu.rasi | cliphist decode | wl-copy"))
hl.bind(superKey .. " + B", hl.dsp.exec_cmd("killall waybar || waybar"))
hl.bind(superKey .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(superKey .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(superKey .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(superKey .. " + V", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "unset" }))
hl.bind(superKey .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(superKey .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(superKey .. " + W", hl.dsp.window.close())
hl.bind(superKey .. " + L", hl.dsp.exec_cmd("loginctl lock-sessions"))
hl.bind(superKey .. " + M", hl.dsp.exec_cmd(powermenu))
hl.bind(superKey .. " + P", hl.dsp.window.pseudo())
hl.bind(superKey .. " + S", hl.dsp.exec_cmd("pkill grim; grim -t jpeg -g \"$(slurp)\" - | swappy -f -"))
hl.bind(superKey .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(superKey .. " + N", hl.dsp.window.fullscreen(2))

hl.bind(superKey .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(superKey .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(superKey .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(superKey .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(superKey .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(superKey .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(superKey .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(superKey .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for index = 1, 10 do
  local key = index % 10
  hl.bind(superKey .. " + " .. key, hl.dsp.focus({ workspace = index }))
  hl.bind(superKey .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = index }))
end

local float_applications = {
  { class = "^(kitty)$",                      size = "1000 700" },
  { class = "^(org\\.telegram\\.desktop)$",   size = "1000 700" },
  { class = "^(org.pulseaudio.pavucontrol)$", size = "700 500" },
  { class = "^(blueman-manager)$",            size = "700 500" },
  { class = "^(nm-connection-editor)$",       size = "700 500" },
  { class = "^(org\\.gnome\\.FileRoller)$",   size = "700 500" },
  { class = "^(org\\.gnome\\.DiskUtility)$",  size = "700 500" },
  { class = "^(galculator)$",                 size = "500 700" },
  { class = "^(Todoist)$",                    size = "700 500" },
}

for _, application in ipairs(float_applications) do
  hl.window_rule({
    match = { class = application.class },
    float = true,
    size = application.size,
    animation = "popin",
  })
end

hl.window_rule({
  match = { class = "^(nemo)$" },
  float = true,
  animation = "popin",
})

hl.window_rule({
  match = { class = "^(code|Code|vscode)$" },
  float = true,
})

hl.window_rule({
  match = { class = "^(google-chrome|chrome|Chromium|firefox)$" },
  float = true,
  size = "1200 900",
})


hl.window_rule({
  match = { class = "^(scrcpy)$" },
  float = true,
  center = true,
})

hl.window_rule({
  match = { title = "^(Wine Desktop)$" },
  float = true,
  center = true,
  size = "1000 700",
})
