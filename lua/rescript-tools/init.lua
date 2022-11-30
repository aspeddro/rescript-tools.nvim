local M = {}

---@brief [[
---*rescript-tools.nvim* A plugin to improve your ReScript experience in Neovim.
---
---Author: Pedro Castro
---Homepage: <https://github.com/aspeddro/rescript-tools.nvim>
---License: MIT
---@brief ]]

---@mod rescript-tools
---@brief [[
---This plugin provides features some features that are available in vscode
---plugin, such as:
---
---1. Create Interface file `.resi`
---2. Open Compiled JavaScript file
---3. Switch between implementation and interface file
---@brief ]]

---@divider =

local METHODS = {
  createInterface = "textDocument/createInterface",
  openCompiled = "textDocument/openCompiled",
}

---Get extension file
---@param name string
---@return string
local get_extension = function(name)
  return string.match(name, ".[^.]+$")
end

---Get active rescript lsp client
---@return table|nil
local get_client = function()
  local active_client = vim.lsp.get_active_clients({ name = "rescriptls" })
  return #active_client > 0 and active_client[1] or nil
end

---Open file
---@param path string Path of file
---@return nil
local open_file = function(path)
  if vim.api.nvim_buf_get_name(0) == path then
    return
  end

  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  if #buffers > 1 then
    for _, buf in ipairs(buffers) do
      if buf.name == path then
        if buf.hidden == 0 then
          vim.api.nvim_set_current_win(buf.windows[1])
        else
          vim.api.nvim_set_current_buf(buf.bufnr)
        end
      end
    end
  end

  vim.cmd.edit(path)
end

---Create Interface file
---@param open? boolean Open interface file after create. Default is `false`
---@usage [[
--- require('rescript-tools').create_interface()
--- -- Open file after create
--- require('rescript-tools').create_interface(true)
---@usage ]]
M.create_interface = function(open)
  local client = get_client()

  local bufnr = 0
  local name = vim.api.nvim_buf_get_name(0)

  if vim.loop.fs_stat(name .. "i") ~= nil then
    vim.notify("rescript: Interface file already exists", vim.log.levels.INFO)
    return
  end

  if client then
    client.request(
      METHODS.createInterface,
      vim.lsp.util.make_text_document_params(bufnr),
      function(_, result, _)
        if result then
          if open then
            open_file(vim.uri_to_fname(result.uri))
          end
        end
      end,
      bufnr
    )
  end
end

---Open Compiled JavaScript
---@usage [[
--- require('rescript-tools').open_compiled()
---@usage ]]
M.open_compiled = function()
  local bufnr = 0
  local client = get_client()

  if client then
    client.request(
      METHODS.openCompiled,
      vim.lsp.util.make_text_document_params(bufnr),
      function(_, result, _)
        if result then
          open_file(vim.uri_to_fname(result.uri))
        end
      end,
      bufnr
    )
  end
end

---Switch between implementation and interface file
---@param ask? boolean Ask to create interface file if not exists. Default is `false`
---@usage [[
--- require('rescript-tools').switch_impl_intf()
--- -- Ask to create interface file if not exists
--- require('rescript-tools').switch_impl_intf(true)
---@usage ]]
M.switch_impl_intf = function(ask)
  local bufnr = 0

  if vim.filetype.match({ buf = bufnr }) ~= "rescript" then
    vim.notify(
      "rescript: This command only can run on *.res or *.resi files.",
      vim.log.levels.INFO
    )
    return
  end

  local name = vim.api.nvim_buf_get_name(bufnr)

  local current_file_extension = get_extension(name)

  if current_file_extension == ".resi" then
    -- Go to implementation .res
    open_file(string.sub(name, 0, string.len(name) - 1))
    return
  elseif current_file_extension == ".res" then
    -- Go to Interface .resi
    -- if interface doesn't exist, ask the user before creating.
    local path = name .. "i"
    local interface_exists = vim.loop.fs_stat(path) ~= nil
    if not interface_exists and ask then
      vim.ui.select({ "No", "Yes" }, {
        prompt = "Do you want to create an interface *.resi:",
      }, function(choice)
        if choice == "Yes" then
          M.create_interface()
        end
      end)
    end

    if interface_exists then
      open_file(path)
      return
    end
  else
    vim.notify(
      "rescript: Faield to detect extension for " .. name,
      vim.log.levels.ERROR
    )
  end
end

---This function can be used to create command when LSP is attached to buffer.
---@param client table LSP client
---@param bufnr number buffer number
---@param opts? { enable: boolean, names: table<string, function> }
---@usage [[
--- -- Default options
--- require('rescript-tools').on_attach(client, bufnr, {
---   commands = {
---     enable = true,
---     names = {
---       ResOpenCompiled = rescript('rescript-tools').open_compiled
---       ResCreateInterface = rescript('rescript-tools').create_interface
---       ResSwitchImplInt = rescript('rescript-tools').switch_impl_intf
---     }
---   }
--- })
--- -- Overriding the command name
--- require('rescript-tools').on_attach(client, bufnr, {
---   commands = {
---     names = {
---       ResOpenJS = rescript('rescript-tools').open_compiled
---       ResCreateInt = rescript('rescript-tools').create_interface
---       ResSwitch = rescript('rescript-tools').switch_impl_intf
---     }
---   }
--- })
---@usage ]]
M.on_attach = function(client, bufnr, opts)
  opts = vim.tbl_deep_extend("force", {
    commands = {
      enable = true,
      names = {
        ResOpenCompiled = M.open_compiled,
        ResCreateInterface = M.create_interface,
        ResSwitchImplInt = M.switch_impl_intf,
      },
    },
  }, opts or {})
  if client.name == "rescriptls" then
    if opts.commands.enable then
      for name, fn in pairs(opts.commands.names) do
        vim.api.nvim_buf_create_user_command(bufnr, name, fn, {
          nargs = 0,
          desc = "ReScript: " .. name,
        })
      end
    end
  end
end

return M
