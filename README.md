# rescript-tools.nvim

A plugin to improve your ReScript experience in Neovim.

## Requirements

- Neovim >= 0.8
- [rescript-vscode](https://github.com/rescript-lang/rescript-vscode) >= 1.8.3

## Install

**packer.nvim**

```lua
use 'aspeddro/rescript-tools.nvim'
```

## Recommendations

The rescript-vscode plugin contains a language server than can be power other editors. I recommend using [mason.nvim](https://github.com/williamboman/mason.nvim) to install the language server. It will download the `vsix` file from the latest release and add it to the Neovim `PATH` as `rescript-lsp`.

## Setup

```lua
local on_attach = function(client, bufnr)
  -- on_attach function will create buffer commands when LSP is attached
  require('rescript-tools').on_attach(client, bufnr)
end

--Setup rescript LSP
require'lspconfig'.rescriptls.setup{
  -- Using mason.nvim plugin
  cmd = { 'rescript-lsp', '--stdio' },
  -- or pass the path to server.js
  -- cmd = {
  --   'node',
  --   '/home/username/path/to/server/out/server.js',
  --   '--stdio'
  -- }
  init_options = {
    extensionConfiguration = {
      binaryPath = nil,
      platformPath = nil,
      askToStartBuild = false,
      codeLens = true,
      signatureHelp = {
        enable = true,
      },
      inlayHints = {
        enable = false,
      },
    },
  },
  on_attach = on_attach
}
```

Mode details see `help rescript-tools`

## Using pre-releases channel

You can test the pre-release channel similar to [vscode-plugin](https://forum.rescript-lang.org/t/ann-vscode-extension-pre-releases/3588).

Install from latest-master:
```
MasonInstall rescript-lsp@latest-master
```
