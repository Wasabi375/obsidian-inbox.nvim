local obsidian = require("obsidian")
local obs_util = require("obsidian.util")
local rename   = require("obsidian.commands.rename")

local M        = {}

function M.install_in_buffer()
    vim.api.nvim_buf_create_user_command(0, "ObsidianInboxMove", M.move_to_tag,
        { desc = "Move the current note into the folder specified by it's first tag" })
end

function M.move_to_tag()
    local client = assert(obsidian.get_client(), "obsidian client not found")

    assert(obs_util.parse_cursor_link() == nil,
        "This command cannot be run if the cursor is over a link")

    local cur_note_bufnr = assert(vim.fn.bufnr())
    local cur_note_path = Path.buffer(cur_note_bufnr)
    local note = assert(Note.from_file(cur_note_path),
        "could not find note")

    util._log("id: " .. tostring(note.id))
    util._log("title: " .. note.title)
    util._log("tags: " .. table.concat(note.tags, ", "))
    util._log("main-tag: " .. note.tags[1])

    -- rename will add the file extension for us so no need to handle this here
    local target_path = M.note_dir .. note.tags[1] .. "/" .. tostring(note.id)

    util._log("new path: " .. target_path)
    util._log("TODO: ensure parent dir exists")

    rename(client, { args = target_path })
end

return M
