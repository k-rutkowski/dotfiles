local primary_monitor = "DP-1"
local secondary_monitor = "DP-2"

local terminal = "kitty"
local file_manager = "nemo"
local menu = "tofi-drun -c ~/.config/tofi/configA --drun-launch=true"
local firefox = "firefox"
local notes = "obsidian"
local editor = "kate"
local color_picker = "hyprpicker"

hl.monitor({
    output = primary_monitor,
    mode = "preferred",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = secondary_monitor,
    position = "-1920x0",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.bin/play-startup-sound.sh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/usr/bin/dunst")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww img ~/.config/assets/backgrounds/cat_leaves.png --transition-fps 255 --transition-type outer --transition-duration 0.8")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd('rm "$HOME/.cache/cliphist/db"')
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/bin/pypr")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS")
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    hl.exec_cmd(terminal)
    hl.exec_cmd("filen-desktop")
    hl.exec_cmd("dropbox start -i")
    hl.exec_cmd("diodon")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },

    general = {
        gaps_in = 1,
        gaps_out = 1,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgb(8aadf4)", "rgb(24273A)", "rgb(24273A)", "rgb(8aadf4)" },
                angle = 45,
            },
            inactive_border = {
                colors = { "rgb(24273A)", "rgb(24273A)", "rgb(24273A)", "rgb(27273A)" },
                angle = 45,
            },
        },
        resize_on_border = true,
        allow_tearing = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 4,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
            new_optimizations = true,
            vibrancy = 0.1696,
            ignore_opacity = true,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true,
        force_split = 2,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
    },

    input = {
        kb_layout = "pl",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 2,
        sensitivity = 0,
        special_fallthrough = true,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

local main_mod = "SUPER"

hl.bind(main_mod .. " + ALT + M", hl.dsp.exec_cmd("~/.bin/hyprland-toggle-second-monitor.sh"))
hl.bind(main_mod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(firefox))
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd(notes))
hl.bind(main_mod .. " + C", hl.dsp.exec_cmd(editor))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SPACE", hl.dsp.window.float())

hl.bind(main_mod .. " + F1", hl.dsp.focus({ workspace = 1 }))
hl.bind(main_mod .. " + F2", hl.dsp.focus({ workspace = 2 }))
hl.bind(main_mod .. " + F3", hl.dsp.focus({ workspace = 3 }))
hl.bind(main_mod .. " + F4", hl.dsp.focus({ workspace = 4 }))
hl.bind(main_mod .. " + F5", hl.dsp.focus({ workspace = 5 }))
hl.bind(main_mod .. " + F6", hl.dsp.focus({ workspace = 6 }))
hl.bind(main_mod .. " + F7", hl.dsp.focus({ workspace = 7 }))
hl.bind(main_mod .. " + F8", hl.dsp.focus({ workspace = 8 }))
hl.bind(main_mod .. " + F9", hl.dsp.focus({ workspace = 9 }))
hl.bind(main_mod .. " + F10", hl.dsp.focus({ workspace = 10 }))
hl.bind(main_mod .. " + F11", hl.dsp.focus({ workspace = 11 }))
hl.bind(main_mod .. " + F12", hl.dsp.focus({ workspace = 12 }))

hl.bind(main_mod .. " + SHIFT + F1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(main_mod .. " + SHIFT + F2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(main_mod .. " + SHIFT + F3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(main_mod .. " + SHIFT + F4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(main_mod .. " + SHIFT + F5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(main_mod .. " + SHIFT + F6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(main_mod .. " + SHIFT + F7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(main_mod .. " + SHIFT + F8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(main_mod .. " + SHIFT + F9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(main_mod .. " + SHIFT + F10", hl.dsp.window.move({ workspace = 10 }))
hl.bind(main_mod .. " + SHIFT + F11", hl.dsp.window.move({ workspace = 11 }))
hl.bind(main_mod .. " + SHIFT + F12", hl.dsp.window.move({ workspace = 12 }))

hl.bind(main_mod .. " + 1", hl.dsp.workspace.toggle_special("scratch"))
hl.bind(main_mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "special:scratch" }))
hl.bind(main_mod .. " + 2", hl.dsp.workspace.toggle_special("term"))
hl.bind(main_mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "special:term" }))
hl.bind(main_mod .. " + 3", hl.dsp.workspace.toggle_special("music"))
hl.bind(main_mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "special:music" }))

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(main_mod .. " + Tab", hl.dsp.focus({ last = true }))

hl.bind(main_mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(main_mod .. " + ALT + H", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(main_mod .. " + ALT + L", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(main_mod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(main_mod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(main_mod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + X", hl.dsp.window.resize(), { mouse = true })

hl.bind("CTRL + Escape", hl.dsp.exec_cmd("killall waybar || waybar"))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd("cliphist list | tofi -c ~/.config/tofi/configV | cliphist decode | wl-copy"))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd(color_picker .. " | wl-copy"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind("Print", hl.dsp.exec_cmd("GRIMBLAST_EDITOR=gradia grimblast --notify --freeze edit area"))
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd("grimblast --notify copysave active"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast --notify copysave screen"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -m"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"))

for workspace = 1, 10 do
    hl.workspace_rule({ workspace = tostring(workspace), monitor = primary_monitor })
end
hl.workspace_rule({ workspace = "11", monitor = secondary_monitor })
hl.workspace_rule({ workspace = "12", monitor = secondary_monitor })
hl.workspace_rule({
    workspace = "special:music",
    on_created_empty = "flatpak run com.mastermindzh.tidal-hifi",
    persistent = false,
})
hl.workspace_rule({ workspace = "special:music", gaps_out = 120, gaps_in = 4 })
hl.workspace_rule({ workspace = "special:term", gaps_out = 120, gaps_in = 4 })
hl.workspace_rule({
    workspace = "special:term",
    on_created_empty = "kitty tmux new-session \\; split-window -h",
    persistent = false,
})
hl.workspace_rule({ workspace = "special:scratch", gaps_out = 120, gaps_in = 4 })

hl.window_rule({ match = { class = "^(jome)$" }, float = true })
hl.window_rule({ match = { class = "^(Thorium-browser)$" }, opacity = "0.90 0.90" })
hl.window_rule({ match = { class = "^(nemo)$" }, opacity = "0.90 0.90" })
hl.window_rule({ match = { class = "^(jetbrains-rider)$" }, opacity = "0.98 0.98" })
hl.window_rule({ match = { class = "^(Code)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(Arduino IDE)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(dev.warp.Warp)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(obsidian)$" }, opacity = "0.95 0.95" })
hl.window_rule({ match = { class = "^(code-url-handler)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(code-insiders-url-handler)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(org.gnome.Nautilus)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(org.kde.ark)$" }, opacity = "0.80 0.80", float = true })
hl.window_rule({ match = { class = "^(nwg-look)$" }, opacity = "0.80 0.80", float = true })
hl.window_rule({ match = { class = "^(qt5ct)$" }, opacity = "0.80 0.80", float = true })
hl.window_rule({ match = { class = "^(qt6ct)$" }, opacity = "0.80 0.80", float = true })
hl.window_rule({ match = { class = "^(kvantummanager)$" }, opacity = "0.80 0.80", float = true })
hl.window_rule({
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    opacity = "0.90 0.70",
    float = true,
    center = true,
    size = { 800, 600 },
})
hl.window_rule({
    match = { class = "^(blueman-manager)$" },
    opacity = "0.80 0.70",
    float = true,
    center = true,
    size = { 800, 600 },
})
hl.window_rule({ match = { class = "^(nm-applet)$" }, opacity = "0.80 0.70", float = true })
hl.window_rule({ match = { class = "^(Spotify)$" }, opacity = "0.80 0.70" })
hl.window_rule({ match = { initial_title = "^(Spotify Free)$" }, opacity = "0.80 0.70" })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, opacity = "0.80 0.70", float = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, opacity = "0.80 0.70", float = true })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, opacity = "0.80 0.70" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" }, opacity = "0.80 0.70" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" }, opacity = "0.80 0.70" })
hl.window_rule({ match = { class = "^(Dunst)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { title = "^(Calculator)$" }, float = true, center = true, size = { 360, 480 } })
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = "^(firefox)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(jetbrains-rider)$" }, workspace = "4", no_initial_focus = true, immediate = true })
hl.window_rule({ match = { class = "^UnrealEditor(.*)$" }, workspace = "5" })
hl.window_rule({ match = { class = "^(epic_asset_manager)$" }, workspace = "6" })
hl.window_rule({ match = { class = "^(org.mozilla.Thunderbird)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(Slack)$" }, workspace = "10" })
hl.window_rule({
    match = { title = "^(Password Required - Mozilla Thunderbird)$" },
    float = true,
    center = true,
    size = { 240, 140 },
})
hl.window_rule({ match = { class = "^Unreal(.*)$" }, no_initial_focus = true, immediate = true })

hl.layer_rule({ match = { namespace = "tofi" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "dunst" }, ignore_alpha = 0, blur = true })
