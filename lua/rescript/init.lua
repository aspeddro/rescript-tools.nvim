local cache = require("rescript.cache")
local reanalyze = require("rescript.reanalyze")
local M = {}

M.on_attach = function(client, bufnr, opts)
  opts =
    vim.tbl_deep_extend("force", { autoRunCodeAnalysis = false }, opts or {})
  if client.name == "rescriptls" then
    cache.client = client
    if opts.autoRunCodeAnalysis then
      reanalyze.run()
    end
  end
end

return M
