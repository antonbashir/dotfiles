local terminal    = "kitty"
local fileManager = "nemo"
local launcher    = "~/.config/hypr/scripts/launcher"
local powermenu   = "~/.config/hypr/scripts/powermenu"
local volume      = "~/.config/hypr/scripts/volume"
local superKey    = "SUPER"

hl.monitor({ output = "DP-1", mode = "5120x2880", position = "0x0", scale = "2" })
hl.monitor({ output = "DP-2", mode = "5120x2880", position = "2560x0", scale = "2" })
hl.monitor({ output = "DP-3", mode = "5120x2880", position = "5120x0", scale = "2" })

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
  hl.exec_cmd("hyprlock --grace 0 --immediate-render --no-fade-in")
  hl.exec_cmd("~/.config/hypr/scripts/xdg-portal")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("waybar")
  hl.exec_cmd("mako")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("awww img ~/.config/backgrounds/background.jpg")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("pactl load-module module-switch-on-connect")
  hl.exec_cmd("hypridle")
end)

hl.env("GTK_THEME", "Colloid-Dark")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 4,
    border_size = 0,
    layout = "dwindle",
  },

  cursor = {
    no_hardware_cursors = true,
    no_warps = true,
  },

  decoration = {
    rounding = 24,
    blur = {
      enabled = true,
      size = 5,
      passes = 1,
      new_optimizations = true,
    },
    shadow = {
      enabled = true,
      range = 32,
      render_power = 16,
      color = "rgba(7734ebff)",
      color_inactive = "rgba(0892d0ff)",
    }
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    vrr = 1,
    allow_session_lock_restore = true,
  },

  xwayland = {
    force_zero_scaling = true
  },

  input = {
    kb_layout = "us,ru",
    kb_options = "grp:lctrl_lwin_toggle",
    follow_mouse = 1,
    touchpad = { natural_scroll = false },
    sensitivity = 0,
  }
})

hl.curve("bezier-curve", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "bezier-curve", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "bezier-curve", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volume .. " --toggle"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))


hl.bind(superKey .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(superKey .. " + W", hl.dsp.window.close())
hl.bind(superKey .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(superKey .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(superKey .. " + M", hl.dsp.exec_cmd(powermenu))
hl.bind(superKey .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(superKey .. " + B", hl.dsp.exec_cmd("killall waybar || waybar"))
hl.bind(superKey .. " + L", hl.dsp.exec_cmd("loginctl lock-sessions"))
hl.bind(superKey .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(superKey .. " + N", hl.dsp.window.fullscreen(2))
hl.bind(superKey .. " + S", hl.dsp.exec_cmd('grim -t jpeg -g "$(slurp)" - | swappy -f -'))
hl.bind(superKey .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(superKey .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(superKey .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(superKey .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
  local key = i % 10
  hl.bind(superKey .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(superKey .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(superKey .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(superKey .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
  match = { float = true },
  size = "1000 600"
})

local float_applications = {
  { class = "kitty",                      size = "700 500" },
  { class = "org\\.telegram\\.desktop",   size = "1000 700" },
  { class = "org.pulseaudio.pavucontrol", size = "700 500" },
  { class = "blueman-manager",            size = "700 500" },
  { class = "nm-connection-editor",       size = "700 500" },
  { class = "galculator",                 size = "500 700" },
  { class = "Todoist",                    size = "700 500" }
}

for _, application in ipairs(float_applications) do
  hl.window_rule({
    match = { class = application.class },
    float = true,
    size = application.size,
    animation = "popin"
  })
end

hl.window_rule({
  match = { class = "google-chrome|chrome|Chromium|firefox" },
  float = true,
  size = "1200 900"
})