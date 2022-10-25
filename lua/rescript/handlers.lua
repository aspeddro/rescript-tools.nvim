local M = {}



M.create_interface = function (err, result, ctx)
  -- bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- local name = vim.api.nvim_buf_get_name(bufnr)

  -- if err ~= nil then
  --   vim.notify('Failed to create interface file', vim.log.levels.ERROR)
  --   return
  -- end

  P{err, result, ctx}


  -- if vim.loop.fs_stat(name .. 'i') ~= nil then
  --   vim.notify('Interface file already exists', vim.log.levels.INFO)
  --   return
  -- end

  -- client.request(M.methods.create_interface, vim.lsp.util.make_text_document_params(), function (err, result)
  --   
  -- end, bufnr)

  -- vim.lsp.buf_request(bufnr, M.methods.create_interface, vim.lsp.util.make_text_document_params(), function (err, result, ctx)
  --   P{err, result, ctx}
  -- end)
end

return M
