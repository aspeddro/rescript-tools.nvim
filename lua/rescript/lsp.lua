local cache = require("rescript.cache")

local METHODS = {
  createInterface = "rescript-vscode.create_interface",
  openCompiled = "rescript-vscode.open_compiled",
}

local M = {}

local get_extension = function(name)
  return string.match(name, ".[^.]+$")
end

local open = function(target, fallback)
  if vim.api.nvim_buf_get_name(0) == target then
    return
  end

  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  if #buffers > 1 then
    for _, buf in ipairs(buffers) do
      if buf.name == target then
        if buf.hidden == 0 then
          vim.api.nvim_set_current_win(buf.windows[1])
        else
          vim.api.nvim_set_current_buf(buf.bufnr)
        end
      end
    end
  end

  fallback(target)
end

M.create_interface = function(opts)
  local client = cache.client

  opts = vim.tbl_deep_extend(
    "force",
    { bufnr = 0, open = true, callback = vim.cmd.edit },
    opts or {}
  )

  local name = vim.api.nvim_buf_get_name(opts.bufnr)

  if vim.loop.fs_stat(name .. "i") ~= nil then
    vim.notify("rescript: Interface file already exists", vim.log.levels.INFO)
    return
  end

  client.request(
    METHODS.createInterface,
    vim.lsp.util.make_text_document_params(opts.bufnr),
    function(_, result, ctx)
      if result then
        local interface_file = vim.uri_to_fname(ctx.params.uri) .. "i"
        if opts.open then
          opts.callback(interface_file)
        end
      end
    end,
    opts.bufnr
  )
end

M.open_compiled = function(opts)
  opts = vim.tbl_deep_extend(
    "force",
    { bufnr = 0, callback = vim.cmd.edit },
    opts or {}
  )
  local client = cache.client

  client.request(
    METHODS.openCompiled,
    vim.lsp.util.make_text_document_params(opts.bufnr),
    function(_, result, _)
      if result then
        open(result.uri, opts.callback)
      end
    end,
    opts.bufnr
  )
end

M.switch_impl_intf = function(opts)
  opts = vim.tbl_deep_extend(
    "force",
    { bufnr = 0, ask = false, callback = vim.cmd.edit },
    opts or {}
  )

  if vim.filetype.match({ buf = opts.bufnr }) ~= "rescript" then
    vim.notify(
      "rescript: This command only can run on *.res or *.resi files.",
      vim.log.levels.INFO
    )
    return
  end

  local name = vim.api.nvim_buf_get_name(opts.bufnr)

  local file_extension = get_extension(name)

  if file_extension == ".resi" then
    -- Go to implementation .res
    open(string.sub(name, 0, string.len(name) - 1), opts.callback)
    return
  elseif file_extension == ".res" then
    -- Go to Interface .resi
    -- if interface doesn't exist, ask the user before creating.
    local target = name .. 'i'
    local interface_exists = vim.loop.fs_stat(target) ~= nil
    if not interface_exists and opts.ask then
      vim.ui.select({ "No", "Yes" }, {
        prompt = "Do you want to create an interface *.resi:",
      }, function(choice)
        if choice == "Yes" then
          M.create_interface()
        end
      end)
    end

    if interface_exists then
      open(target, opts.callback)
      return
    end
  else
    vim.notify(
      "rescript: Faield to detect extension for " .. name,
      vim.log.levels.ERROR
    )
  end
end

return M
