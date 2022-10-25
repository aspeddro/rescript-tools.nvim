local M = {}

M.run = function()
  local group =
    vim.api.nvim_create_augroup("recript/compilationFinished", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function()
      -- vim.lsp.buf.format({
      --   timeout_ms = 2000,
      --   async = true,
      -- })
    end,
    buffer = bufnr,
  })
end

return M
