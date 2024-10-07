local Workspace = require("obsidian.workspace")
local obsidian  = require("obsidian")

local M         = {}

function M.in_inbox(note)
    local client = obsidian.get_client()
    if client == nil then
        M._log("no obsidian client found")
        return
    end

    local note_dir = Path.new(note.path):parent()

    -- Check if we're in a workspace.
    local workspace = Workspace.get_workspace_for_dir(note_dir, client.opts.workspaces)
    if not workspace then
        M._log("not a workspace!")
        return
    end

    M._log("workspace dir: " .. tostring(workspace.path))
    M._log("note path: " .. tostring(note.path))

    local workspace_path = tostring(workspace.path)
    local note_path = tostring(note.path)

    if not vim.startswith(note_path, workspace_path) then
        return false
    end

    local relative_path = string.sub(note_path, #workspace_path + 1, #note_path)

    if string.match(relative_path, M.inbox_name .. "/") then
        return true
    else
        return false
    end
end

function M._log(msg)
    if M.verbose then
        print(msg)
    end
end

return M
