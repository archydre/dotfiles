-- #######################################################################################
-- CONFIGURAÇÃO DO HYPRLAND (LUA NATIVO)
-- Monitor: Philips 221V8LB 1920x1080 @ 100Hz (HDMI-A-1)
-- Estilo: Catppuccin Mocha & JetBrains Mono Nerd Font
-- #######################################################################################

-- ---------------------------------------------------------------------------------------
-- MONITORES
-- ---------------------------------------------------------------------------------------
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@100",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- ---------------------------------------------------------------------------------------
-- VARIÁVEIS DE AMBIENTE (WAYLAND / AMD)
-- ---------------------------------------------------------------------------------------
local home = os.getenv("HOME") or ("/home/" .. (os.getenv("USER") or "user"))
local binDir = home .. "/.local/bin"

hl.env("PATH", binDir .. ":" .. (os.getenv("PATH") or "/usr/local/bin:/usr/bin:/bin"))
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GTK_IM_MODULE", "simple")
hl.env("QT_IM_MODULE", "simple")
hl.env("XMODIFIERS", "@im=none")
hl.env("LANG", "en_US.UTF-8")
hl.env("LC_CTYPE", "en_US.UTF-8")
hl.env("LC_ALL", "en_US.UTF-8")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

-- ---------------------------------------------------------------------------------------
-- AUTOSTART
-- ---------------------------------------------------------------------------------------
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service || /usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
end)

-- ---------------------------------------------------------------------------------------
-- CONFIGURAÇÕES GERAIS
-- ---------------------------------------------------------------------------------------
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        kb_model = "pc105",
        follow_mouse = 1,
        sensitivity = 0,
        emulate_discrete_scroll = 2,
        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = {"rgba(cba6f7ff)", "rgba(89b4faff)", "rgba(31324422)", "rgba(31324422)"}, angle = 45 },
            inactive_border = "rgba(31324466)",
        },
        layout = "dwindle",
        resize_on_border = true,
        allow_tearing = false,
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.95,
        blur = {
            enabled = true,
            size = 7,
            passes = 3,
            new_optimizations = true,
            xray = false,
            noise = 0.02,
            contrast = 0.95,
            brightness = 0.95,
        },
        shadow = {
            enabled = true,
            range = 16,
            render_power = 3,
            color = 0xee11111b,
        },
    },

    animations = {
        enabled = true,
        workspace_wraparound = true,
    },

    binds = {
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
        scroll_event_delay = 0,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true,
    },
})

-- ---------------------------------------------------------------------------------------
-- CURVAS E ANIMAÇÕES
-- ---------------------------------------------------------------------------------------
hl.curve("fluent_decel", { type = "bezier", points = { {0.1, 1.0}, {0.1, 1.0} } })
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1.0}, {0.3, 1.0} } })
hl.curve("smoothLinear", { type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0} } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fluent_decel", style = "popin 85%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "fluent_decel", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "easeOutExpo", style = "popin 85%" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "fluent_decel" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 90, bezier = "smoothLinear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "fluent_decel" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.5, bezier = "fluent_decel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "fluent_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "fluent_decel", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "fluent_decel", style = "slidevert" })

-- ---------------------------------------------------------------------------------------
-- REGRAS DE JANELAS E CAMADAS
-- ---------------------------------------------------------------------------------------
hl.window_rule({
    match = { class = "pavucontrol" },
    float = true,
    center = true,
})
hl.window_rule({
    match = { class = "wofi" },
    stay_focused = true,
})
hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.35,
})
hl.layer_rule({
    match = { namespace = "wofi" },
    blur = true,
    ignore_alpha = 0.2,
})

-- ---------------------------------------------------------------------------------------
-- ATALHOS DE TECLADO E MOUSE
-- ---------------------------------------------------------------------------------------
local mainMod = "SUPER"

-- Aplicativos essenciais
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("gtk-launch $(xdg-settings get default-web-browser 2>/dev/null || echo firefox.desktop)"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(binDir .. "/hypr-powermenu"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --prompt 'Clipboard History' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(binDir .. "/hypr-wallpaper-picker"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind("SUPER_L", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"), { release = true })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Navegação de foco (Setas e Vim Keys)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces (1 a 10)
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Navegação dinâmica / mouse estilo GNOME
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll next"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll prev"))
hl.bind(mainMod .. " + mouse:275", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll prev"))
hl.bind(mainMod .. " + mouse:276", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll next"))
hl.bind(mainMod .. " + mouse_right", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll next"))
hl.bind(mainMod .. " + mouse_left", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll prev"))

hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll move_next"))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd(binDir .. "/hypr-workspace-scroll move_prev"))
hl.bind(mainMod .. " + SHIFT + mouse:275", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-left"))
hl.bind(mainMod .. " + SHIFT + mouse:276", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-right"))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-left"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-right"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-left"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(binDir .. "/hypr-gnome-workspaces move-right"))

hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(binDir .. "/hypr-move-window-menu"))
hl.bind(mainMod .. " + SHIFT + C", function() _G.compact_workspaces() end)

-- Mover e redimensionar arrastando
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Áudio e Multimídia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(binDir .. "/hypr-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(binDir .. "/hypr-volume lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(binDir .. "/hypr-volume mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind("CTRL + SHIFT + Z", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot area"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot area"))
hl.bind("Print", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot area"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot full"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot window"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(binDir .. "/hypr-screenshot edit"))

-- =======================================================================================
-- COMPACTAÇÃO DINÂMICA DE WORKSPACES ESTILO GNOME
-- Mantém as áreas de trabalho contíguas (1, 2, 3...) eliminando áreas vazias intermediárias
-- =======================================================================================
local is_compacting = false

function _G.compact_workspaces()
    if is_compacting then return end
    is_compacting = true

    local ok, err = pcall(function()
        local windows = hl.get_windows()
        local active_ws = hl.get_active_workspace()
        local active_id = active_ws and active_ws.id or 1

        local ws_addrs = {}
        local occupied = {}

        for _, w in ipairs(hl.get_windows()) do
            local ws = w.workspace
            local ws_id = ws and ws.id or 0
            local addr = w.address
            if ws_id > 0 and addr then
                if not ws_addrs[ws_id] then
                    ws_addrs[ws_id] = {}
                    table.insert(occupied, ws_id)
                end
                table.insert(ws_addrs[ws_id], addr)
            end
        end

        table.sort(occupied)

        if #occupied > 0 then
            local mapping = {}
            local target_id = 1
            for _, ws_id in ipairs(occupied) do
                if ws_id ~= target_id then
                    mapping[ws_id] = target_id
                end
                target_id = target_id + 1
            end

            local has_changes = false
            for _, old_ws in ipairs(occupied) do
                if mapping[old_ws] then
                    has_changes = true
                    break
                end
            end

            if has_changes then
                hl.config({ animations = { enabled = false } })

                for _, old_ws in ipairs(occupied) do
                    local new_ws = mapping[old_ws]
                    if new_ws then
                        for _, addr in ipairs(ws_addrs[old_ws]) do
                            for _, w in ipairs(hl.get_windows()) do
                                if w.address == addr then
                                    hl.dispatch(hl.dsp.window.move({ workspace = new_ws, window = w, silent = true }))
                                    break
                                end
                            end
                        end
                    end
                end

                if mapping[active_id] then
                    hl.dispatch(hl.dsp.focus({ workspace = mapping[active_id] }))
                end

                hl.config({ animations = { enabled = true } })
            end
        end
    end)

    is_compacting = false
end

local function schedule_compact()
    hl.timer(_G.compact_workspaces, { type = "oneshot", timeout = 200 })
end

hl.on("workspace.active", schedule_compact)
hl.on("window.close", schedule_compact)
hl.on("window.destroy", schedule_compact)
hl.on("window.move_to_workspace", schedule_compact)
