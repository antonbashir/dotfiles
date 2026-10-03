local launcher   = "~/.config/scripts/launcher"
local powermenu  = "~/.config/scripts/powermenu"
local volume     = "~/.config/scripts/volume"
local xdg        = "~/.config/scripts/xdg-portal"
local compositor = hl;

compositor.config({
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
    on_focus_under_fullscreen = 1,
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
    float_switch_override_focus = 2,
    touchpad = { natural_scroll = false },
    sensitivity = 0,
  },
})

compositor.monitor({ output = "DP-1", mode = "5120x2880@60", position = "0x0", scale = "2" })
compositor.monitor({ output = "DP-2", mode = "5120x2880@60", position = "2560x0", scale = "2" })
compositor.monitor({ output = "DP-3", mode = "3840x2160@60", position = "5120x0", scale = "1.25" })

compositor.env("GTK_THEME", "Colloid-Dark")
compositor.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
compositor.env("HYPRCURSOR_SIZE", "24")
compositor.env("XCURSOR_SIZE", "24")

compositor.on("hyprland.start", function()
  compositor.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
  compositor.exec_cmd("hyprlock --grace 0 --immediate-render --no-fade-in")
  compositor.exec_cmd(xdg)
  compositor.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  compositor.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  compositor.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  compositor.exec_cmd("mako")
  compositor.exec_cmd("blueman-applet")
  compositor.exec_cmd("nm-applet --indicator")
  compositor.exec_cmd("wl-paste --type text --watch cliphist store")
  compositor.exec_cmd("wl-paste --type image --watch cliphist store")
  compositor.exec_cmd("pactl load-module module-switch-on-connect")
  compositor.exec_cmd("lianwall start")
  compositor.exec_cmd("hypridle")
  compositor.exec_cmd("hyprshade on vibrance")
end)

compositor.exec_cmd("hyprshade on vibrance")

compositor.curve("bezier", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })

compositor.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "bezier", style = "slide" })
compositor.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "bezier", style = "slide" })
compositor.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
compositor.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
compositor.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

compositor.bind("XF86AudioRaiseVolume", compositor.dsp.exec_cmd(volume .. " --inc"))
compositor.bind("XF86AudioLowerVolume", compositor.dsp.exec_cmd(volume .. " --dec"))
compositor.bind("XF86AudioMute", compositor.dsp.exec_cmd(volume .. " --toggle"))
compositor.bind("XF86AudioMicMute", compositor.dsp.exec_cmd(volume .. " --toggle-mic"))
compositor.bind("XF86AudioNext", compositor.dsp.exec_cmd("playerctl next"))
compositor.bind("XF86AudioPrev", compositor.dsp.exec_cmd("playerctl previous"))
compositor.bind("XF86AudioPlay", compositor.dsp.exec_cmd("playerctl play-pause"))

compositor.bind("code:156", compositor.dsp.exec_cmd("rog-control-center"))
compositor.bind("code:211", compositor.dsp.exec_cmd("asusctl profile -n"))
compositor.bind("code:210", compositor.dsp.exec_cmd("asusctl led-mode -n"))

compositor.bind("f4", compositor.dsp.exec_cmd(launcher))
compositor.bind("print", compositor.dsp.exec_cmd("grim -t jpeg -g \"$(slurp)\" - | swappy -f -"))

compositor.bind("CTRL + SHIFT + V", compositor.dsp.exec_cmd("cliphist list | rofi -dmenu -theme ~/.config/rofi/dmenu.rasi | cliphist decode | wl-copy"))

compositor.bind("SUPER + B", compositor.dsp.exec_cmd("killall waybar || waybar"))
compositor.bind("SUPER + SPACE", compositor.dsp.exec_cmd(launcher))
compositor.bind("SUPER + E", compositor.dsp.exec_cmd("nemo"))
compositor.bind("SUPER + J", compositor.dsp.layout("togglesplit"))
compositor.bind("SUPER + V", compositor.dsp.window.fullscreen({ mode = "fullscreen", action = "unset" }))
compositor.bind("SUPER + V", compositor.dsp.window.float({ action = "toggle" }))
compositor.bind("SUPER + Q", compositor.dsp.exec_cmd("kitty"))
compositor.bind("SUPER + W", compositor.dsp.window.close())
compositor.bind("SUPER + L", compositor.dsp.exec_cmd("loginctl lock-sessions"))
compositor.bind("SUPER + M", compositor.dsp.exec_cmd(powermenu))
compositor.bind("SUPER + P", compositor.dsp.window.pseudo())
compositor.bind("SUPER + S", compositor.dsp.exec_cmd("pkill grim; grim -t jpeg -g \"$(slurp)\" - | swappy -f -"))
compositor.bind("SUPER + F", compositor.dsp.window.fullscreen(0))
compositor.bind("SUPER + N", compositor.dsp.window.fullscreen(2))

compositor.bind("SUPER + left", compositor.dsp.focus({ direction = "left" }))
compositor.bind("SUPER + right", compositor.dsp.focus({ direction = "right" }))
compositor.bind("SUPER + up", compositor.dsp.focus({ direction = "up" }))
compositor.bind("SUPER + down", compositor.dsp.focus({ direction = "down" }))

compositor.bind("SUPER + mouse_down", compositor.dsp.focus({ workspace = "e+1" }))
compositor.bind("SUPER + mouse_up", compositor.dsp.focus({ workspace = "e-1" }))

compositor.bind("SUPER + mouse:272", compositor.dsp.window.drag(), { mouse = true })
compositor.bind("SUPER + mouse:273", compositor.dsp.window.resize(), { mouse = true })

for index = 1, 10 do
  local key = index % 10
  compositor.bind("SUPER + " .. key, compositor.dsp.focus({ workspace = index }))
  compositor.bind("SUPER + SHIFT + " .. key, compositor.dsp.window.move({ workspace = index }))
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
  compositor.window_rule({
    match = { class = application.class },
    float = true,
    size = application.size,
    animation = "popin",
  })
end

compositor.window_rule({
  match = { class = "^(nemo)$" },
  float = true,
  animation = "popin",
})

compositor.window_rule({
  match = { class = "^(code|Code|vscode)$" },
  float = true,
})

compositor.window_rule({
  match = { class = "^(google-chrome|chrome|Chromium|firefox)$" },
  float = true,
  size = "1200 900",
})


compositor.window_rule({
  match = { class = "^(scrcpy)$" },
  float = true,
  center = true,
})

compositor.window_rule({
  match = { title = "^(Wine Desktop)$" },
  float = true,
  center = true,
  size = "1000 700",
})
