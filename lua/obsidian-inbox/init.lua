local Note     = require("obsidian.note")
local Path     = require("obsidian.path")

local commands = require("obsidian-inbox.commands")
local util     = require("obsidian-inbox.util")

local M        = {}

function M.setup(opts)
    opts = opts or {}

    M.verbose = opts.verbose

    M.note_dir = opts.note_dir or ""
    if M.note_dir ~= "" and M.note_dir[#M.note_dir] ~= "/" then
        M.note_dir = M.note_dir .. "/"
    end
    M.inbox_name = opts.inbox or "inbox"
    if vim.endswith(M.inbox_name, "/") then
        M.inbox_name = string.sub(M.inbox_name, 1, -1)
    end

    local group = vim.api.nvim_create_augroup("obsidian_inbox_setup", { clear = true })

    if opts.command_scope == "inbox" then
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = group,
            pattern = "*.md",
            callback = function(event)
                local note_bufnr = event.bufnr
                local note_path = Path.buffer(note_bufnr)
                local note = Note.from_file(note_path)

                if note == nil then
                    return
                end

                if not util.in_inbox(note) then
                    return
                end

                commands.install_in_buffer()
            end
        })
    elseif opts.command_scope == "vault" or opts.command_scope == nil then
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = group,
            pattern = "*.md",
            callback = function(_)
                commands.install_in_buffer()
            end
        })
    else
        vim.notify_once("[Obsidian-inbox] command_scope must be of value \"inbox\", \"valut\" or nil",
            vim.log.levels.ERROR)
        return
    end

    util._log("obsidian-inbox loaded")
end

return M
