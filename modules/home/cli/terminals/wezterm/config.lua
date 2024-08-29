local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local sessionizer = require("sessionizer")

-- Decide whether cmd represents a default startup invocation
function is_default_startup(cmd)
    if not cmd then
        -- we were started with `wezterm` or `wezterm start` with
        -- no other arguments
        return true
    end
    if cmd.domain == "DefaultDomain" and not cmd.args then
        -- Launched via `wezterm start --cwd something`
        return true
    end
    -- we were launched some other way
    return false
end

--wezterm.on('gui-startup', function(cmd)
--    if is_default_startup(cmd) then
--        -- for the default startup case, we want to switch to the unix domain instead
--        local unix = mux.get_domain("unix")
--        mux.set_default_domain(unix)
--        -- ensure that it is attached
--        unix:attach()
--    end
--end)

wezterm.on("user-var-changed", function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while number_value > 0 do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = false
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return {
    color_scheme = "Catppuccin Mocha",
    default_prog = { "fish" },
    window_decorations = "NONE",
    font = wezterm.font_with_fallback({
        "MonoLisa Nerd Font",
        "Fira Code",
        "Noto Color Emoji",
    }),
    font_size = 14.0,
    enable_tab_bar = true,
    hyperlink_rules = wezterm.default_hyperlink_rules(),
    window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 20,
    },
    --unix_domains = {
    --    {
    --        name = "unix",
    --        no_serve_automatically = false,
    --    }
    --},
    disable_default_key_bindings = true,
    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 },
    keys = {
        { key = "f", mods = "LEADER",       action = wezterm.action_callback(sessionizer.toggle) },
        { key = "p", mods = "LEADER",       action = act.ActivateCommandPalette },
        { key = "e", mods = "LEADER",       action = act.ShowLauncher },
        { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
        { key = "q", mods = "LEADER",       action = act.CloseCurrentTab({ confirm = true }) },
        { key = "l", mods = "LEADER",       action = act.ShowDebugOverlay },
        { key = "n", mods = "LEADER",       action = act.ShowTabNavigator },

        { key = "1", mods = "LEADER",       action = act.ActivateTab(1) },
        { key = "2", mods = "LEADER",       action = act.ActivateTab(2) },
        { key = "3", mods = "LEADER",       action = act.ActivateTab(3) },
        { key = "4", mods = "LEADER",       action = act.ActivateTab(4) },
        { key = "5", mods = "LEADER",       action = act.ActivateTab(5) },
        { key = "6", mods = "LEADER",       action = act.ActivateTab(6) },
        { key = "7", mods = "LEADER",       action = act.ActivateTab(7) },
        { key = "8", mods = "LEADER",       action = act.ActivateTab(8) },
        { key = "9", mods = "LEADER",       action = act.ActivateTab(9) },

        { key = '"', mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "%", mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

        --- Font Size
        { key = "+", mods = "CTRL",         action = act.IncreaseFontSize },
        { key = "+", mods = "SHIFT|CTRL",   action = act.IncreaseFontSize },
        { key = "-", mods = "CTRL",         action = act.DecreaseFontSize },
        { key = "-", mods = "SHIFT|CTRL",   action = act.DecreaseFontSize },
        { key = "0", mods = "CTRL",         action = act.ResetFontSize },
        { key = "0", mods = "SHIFT|CTRL",   action = act.ResetFontSize },

        { key = "t", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },

        {
            key = "c",
            mods = "LEADER",
            action = act.PromptInputLine({
                description = wezterm.format({
                    { Attribute = { Intensity = "Bold" } },
                    { Foreground = { AnsiColor = "Fuchsia" } },
                    { Text = "Enter name for new workspace" },
                }),
                action = wezterm.action_callback(function(window, pane, line)
                    -- line will be `nil` if they hit escape without entering anything
                    -- An empty string if they just hit enter
                    -- Or the actual line of text they wrote
                    if line then
                        window:perform_action(
                            act.SwitchToWorkspace({
                                name = line,
                            }),
                            pane
                        )
                    end
                end),
            }),
        },

        -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
        {
            key = "a",
            mods = "LEADER|CTRL",
            action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
        },

        { key = "Tab",   mods = "CTRL",           action = act.ActivateTabRelative(1) },
        { key = "Tab",   mods = "SHIFT|CTRL",     action = act.ActivateTabRelative(-1) },
        { key = "Enter", mods = "ALT",            action = act.ToggleFullScreen },

        { key = "(",     mods = "CTRL",           action = act.ActivateTab(-1) },
        { key = "(",     mods = "SHIFT|CTRL",     action = act.ActivateTab(-1) },


        { key = "5",     mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "9",     mods = "SHIFT|CTRL",     action = act.ActivateTab(-1) },
        { key = "9",     mods = "SUPER",          action = act.ActivateTab(-1) },
        { key = "C",     mods = "CTRL",           action = act.CopyTo("Clipboard") },
        { key = "C",     mods = "SHIFT|CTRL",     action = act.CopyTo("Clipboard") },
        { key = "F",     mods = "CTRL",           action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "F",     mods = "SHIFT|CTRL",     action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "K",     mods = "CTRL",           action = act.ClearScrollback("ScrollbackOnly") },
        { key = "K",     mods = "SHIFT|CTRL",     action = act.ClearScrollback("ScrollbackOnly") },
        { key = "M",     mods = "CTRL",           action = act.Hide },
        { key = "M",     mods = "SHIFT|CTRL",     action = act.Hide },
        { key = "P",     mods = "CTRL",           action = act.ActivateCommandPalette },
        { key = "P",     mods = "SHIFT|CTRL",     action = act.ActivateCommandPalette },
        { key = "R",     mods = "CTRL",           action = act.ReloadConfiguration },
        { key = "R",     mods = "SHIFT|CTRL",     action = act.ReloadConfiguration },
        {
            key = "U",
            mods = "CTRL",
            action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
        },
        {
            key = "U",
            mods = "SHIFT|CTRL",
            action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
        },
        { key = "V", mods = "CTRL",        action = act.PasteFrom("Clipboard") },
        { key = "V", mods = "SHIFT|CTRL",  action = act.PasteFrom("Clipboard") },
        { key = "X", mods = "CTRL",        action = act.ActivateCopyMode },
        { key = "X", mods = "SHIFT|CTRL",  action = act.ActivateCopyMode },
        { key = "Z", mods = "CTRL",        action = act.TogglePaneZoomState },
        { key = "Z", mods = "SHIFT|CTRL",  action = act.TogglePaneZoomState },
        { key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
        { key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
        { key = "_", mods = "CTRL",        action = act.DecreaseFontSize },
        { key = "_", mods = "SHIFT|CTRL",  action = act.DecreaseFontSize },
        { key = "c", mods = "SHIFT|CTRL",  action = act.CopyTo("Clipboard") },
        { key = "c", mods = "SUPER",       action = act.CopyTo("Clipboard") },
        { key = "f", mods = "SHIFT|CTRL",  action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "f", mods = "SUPER",       action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "k", mods = "SHIFT|CTRL",  action = act.ClearScrollback("ScrollbackOnly") },
        { key = "k", mods = "SUPER",       action = act.ClearScrollback("ScrollbackOnly") },
        { key = "l", mods = "SHIFT|CTRL",  action = act.ShowDebugOverlay },
        { key = "m", mods = "SHIFT|CTRL",  action = act.Hide },
        { key = "m", mods = "SUPER",       action = act.Hide },
        { key = "r", mods = "SHIFT|CTRL",  action = act.ReloadConfiguration },
        { key = "r", mods = "SUPER",       action = act.ReloadConfiguration },
        { key = "t", mods = "SHIFT|CTRL",  action = act.SpawnTab("CurrentPaneDomain") },
        {
            key = "u",
            mods = "SHIFT|CTRL",
            action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
        },
        { key = "v",          mods = "SHIFT|CTRL",     action = act.PasteFrom("Clipboard") },
        { key = "v",          mods = "SUPER",          action = act.PasteFrom("Clipboard") },
        { key = "w",          mods = "SHIFT|CTRL",     action = act.CloseCurrentTab({ confirm = true }) },
        { key = "w",          mods = "SUPER",          action = act.CloseCurrentTab({ confirm = true }) },
        { key = "x",          mods = "SHIFT|CTRL",     action = act.ActivateCopyMode },
        { key = "z",          mods = "SHIFT|CTRL",     action = act.TogglePaneZoomState },
        { key = "{",          mods = "SUPER",          action = act.ActivateTabRelative(-1) },
        { key = "{",          mods = "SHIFT|SUPER",    action = act.ActivateTabRelative(-1) },
        { key = "}",          mods = "SUPER",          action = act.ActivateTabRelative(1) },
        { key = "}",          mods = "SHIFT|SUPER",    action = act.ActivateTabRelative(1) },
        { key = "phys:Space", mods = "SHIFT|CTRL",     action = act.QuickSelect },
        { key = "PageUp",     mods = "SHIFT",          action = act.ScrollByPage(-1) },
        { key = "PageUp",     mods = "CTRL",           action = act.ActivateTabRelative(-1) },
        { key = "PageUp",     mods = "SHIFT|CTRL",     action = act.MoveTabRelative(-1) },
        { key = "PageDown",   mods = "SHIFT",          action = act.ScrollByPage(1) },
        { key = "PageDown",   mods = "CTRL",           action = act.ActivateTabRelative(1) },
        { key = "PageDown",   mods = "SHIFT|CTRL",     action = act.MoveTabRelative(1) },
        { key = "LeftArrow",  mods = "SHIFT|CTRL",     action = act.ActivatePaneDirection("Left") },
        { key = "LeftArrow",  mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", mods = "SHIFT|CTRL",     action = act.ActivatePaneDirection("Right") },
        { key = "RightArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow",    mods = "SHIFT|CTRL",     action = act.ActivatePaneDirection("Up") },
        { key = "UpArrow",    mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow",  mods = "SHIFT|CTRL",     action = act.ActivatePaneDirection("Down") },
        { key = "DownArrow",  mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
        { key = "Insert",     mods = "SHIFT",          action = act.PasteFrom("PrimarySelection") },
        { key = "Insert",     mods = "CTRL",           action = act.CopyTo("PrimarySelection") },
        { key = "Copy",       mods = "NONE",           action = act.CopyTo("Clipboard") },
        { key = "Paste",      mods = "NONE",           action = act.PasteFrom("Clipboard") },
    },

    key_tables = {
        copy_mode = {
            { key = "Tab",    mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
            { key = "Tab",    mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
            { key = "Enter",  mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
            { key = "Escape", mods = "NONE",  action = act.CopyMode("Close") },
            { key = "Space",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
            { key = "$",      mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "$",      mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = ",",      mods = "NONE",  action = act.CopyMode("JumpReverse") },
            { key = "0",      mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
            { key = ";",      mods = "NONE",  action = act.CopyMode("JumpAgain") },
            { key = "F",      mods = "NONE",  action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
            { key = "F",      mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
            { key = "G",      mods = "NONE",  action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "G",      mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "H",      mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
            { key = "H",      mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
            { key = "L",      mods = "NONE",  action = act.CopyMode("MoveToViewportBottom") },
            { key = "L",      mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
            { key = "M",      mods = "NONE",  action = act.CopyMode("MoveToViewportMiddle") },
            { key = "M",      mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
            { key = "O",      mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "O",      mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "T",      mods = "NONE",  action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
            { key = "T",      mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
            { key = "V",      mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Line" }) },
            { key = "V",      mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
            { key = "^",      mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "^",      mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "b",      mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
            { key = "b",      mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
            { key = "b",      mods = "CTRL",  action = act.CopyMode("PageUp") },
            { key = "c",      mods = "CTRL",  action = act.CopyMode("Close") },
            { key = "d",      mods = "CTRL",  action = act.CopyMode({ MoveByPage = 0.5 }) },
            { key = "e",      mods = "NONE",  action = act.CopyMode("MoveForwardWordEnd") },
            { key = "f",      mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = false } }) },
            { key = "f",      mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
            { key = "f",      mods = "CTRL",  action = act.CopyMode("PageDown") },
            { key = "g",      mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
            { key = "g",      mods = "CTRL",  action = act.CopyMode("Close") },
            { key = "h",      mods = "NONE",  action = act.CopyMode("MoveLeft") },
            { key = "j",      mods = "NONE",  action = act.CopyMode("MoveDown") },
            { key = "k",      mods = "NONE",  action = act.CopyMode("MoveUp") },
            { key = "l",      mods = "NONE",  action = act.CopyMode("MoveRight") },
            { key = "m",      mods = "ALT",   action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "o",      mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },
            { key = "q",      mods = "NONE",  action = act.CopyMode("Close") },
            { key = "t",      mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = true } }) },
            { key = "u",      mods = "CTRL",  action = act.CopyMode({ MoveByPage = -0.5 }) },
            { key = "v",      mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
            { key = "v",      mods = "CTRL",  action = act.CopyMode({ SetSelectionMode = "Block" }) },
            { key = "w",      mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
            {
                key = "y",
                mods = "NONE",
                action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
            },
            { key = "PageUp",     mods = "NONE", action = act.CopyMode("PageUp") },
            { key = "PageDown",   mods = "NONE", action = act.CopyMode("PageDown") },
            { key = "End",        mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "Home",       mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
            { key = "LeftArrow",  mods = "NONE", action = act.CopyMode("MoveLeft") },
            { key = "LeftArrow",  mods = "ALT",  action = act.CopyMode("MoveBackwardWord") },
            { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
            { key = "RightArrow", mods = "ALT",  action = act.CopyMode("MoveForwardWord") },
            { key = "UpArrow",    mods = "NONE", action = act.CopyMode("MoveUp") },
            { key = "DownArrow",  mods = "NONE", action = act.CopyMode("MoveDown") },
        },

        search_mode = {
            { key = "Enter",     mods = "NONE", action = act.CopyMode("PriorMatch") },
            { key = "Escape",    mods = "NONE", action = act.CopyMode("Close") },
            { key = "n",         mods = "CTRL", action = act.CopyMode("NextMatch") },
            { key = "p",         mods = "CTRL", action = act.CopyMode("PriorMatch") },
            { key = "r",         mods = "CTRL", action = act.CopyMode("CycleMatchType") },
            { key = "u",         mods = "CTRL", action = act.CopyMode("ClearPattern") },
            { key = "PageUp",    mods = "NONE", action = act.CopyMode("PriorMatchPage") },
            { key = "PageDown",  mods = "NONE", action = act.CopyMode("NextMatchPage") },
            { key = "UpArrow",   mods = "NONE", action = act.CopyMode("PriorMatch") },
            { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
        },
    },
    enable_wayland = true,
}
