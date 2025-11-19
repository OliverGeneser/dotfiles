-- Pull in the wezterm API
local wezterm = require("wezterm")
local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")
local history = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer-history")

local schema = {
	options = {
		callback = history.Wrapper(sessionizer.DefaultCallback),
	},
	{ label = "dotfiles", id = "~/dotfiles" },
	sessionizer.DefaultWorkspace({}),
	history.MostRecentWorkspace({}),
	sessionizer.AllActiveWorkspaces({}),
	sessionizer.FdSearch("~/dev"),
}

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.enable_wayland = true
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.default_prog = { "zsh" }
config.font = wezterm.font_with_fallback({
	"FiraMono Nerd Font",
	"Fira Mono",
	"Noto Color Emoji",
})
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.unix_domains = {
	{
		name = "unix",
	},
	{
		name = "thor",
		proxy_command = { "ssh", "-T", "-A", "thor", "wezterm", "cli", "proxy" },
	},
	{
		name = "enterprise",
		proxy_command = { "ssh", "-T", "-A", "enterprise", "wezterm", "cli", "proxy" },
	},
}
config.default_gui_startup_args = { "connect", "unix" }
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
	{ key = "f", mods = "LEADER", action = sessionizer.show(schema) },
	{
		key = "m",
		mods = "LEADER",
		action = history.switch_to_most_recent_workspace,
	},
	{ key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "e", mods = "LEADER", action = wezterm.action.ShowLauncher },
	{ key = "w", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
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
						wezterm.action.SwitchToWorkspace({
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
	{ key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
}

return config
