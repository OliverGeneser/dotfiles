local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/home/olivergeneser/.local/state/nix/profile/bin/fd"

local function remove_up_to_third_slash(input)
    -- Convert input to a string if it is not already
    if type(input) ~= "string" then
        input = tostring(input)
    end

    local count = 0
    local result = ""

    -- Iterate through the string character by character
    for i = 1, #input do
        local char = input:sub(i, i)
        if char == "/" then
            count = count + 1
        end
        if count == 3 then
            result = input:sub(i + 1)
            break
        end
    end

    if result ~= "" and result:sub(1, 1) ~= "/" then
        result = "/" .. result
    end

    return result .. "/"
end

M.toggle = function(window, pane)
    local projects = {}

    wezterm.log_info("$HOME")
    wezterm.log_info(remove_up_to_third_slash(pane:get_current_working_dir()))
    local success, stdout, stderr = wezterm.run_child_process({
        fd,
        "-HI",
        "-td",
        "--exact-depth=1",
        "--exclude='*.*'",
        ".",
        os.getenv("HOME") .. "/personal",
        os.getenv("HOME") .. "/work",
        os.getenv("HOME") .. "/",

        --remove_up_to_third_slash(pane:get_current_working_dir()),
        -- add more paths here
    })

    if not success then
        wezterm.log_error("Failed to run fd: " .. stderr)
        return
    end

    for line in stdout:gmatch("([^\n]*)\n?") do
        local project = line:gsub("/.git/$", "")
        local label = project
        local id = project:gsub(".*/", "")
        table.insert(projects, { label = tostring(label), id = tostring(id) })
    end

    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(win, _, id, label)
                if not id and not label then
                    wezterm.log_info("Cancelled")
                else
                    wezterm.log_info("Selected " .. label)
                    win:perform_action(act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }), pane)
                end
            end),
            fuzzy = true,
            title = "Select project",
            choices = projects,
        }),
        pane
    )
end

return M
