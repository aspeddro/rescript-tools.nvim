# rescript-tools.nvim

A plugin to improve your ReScript experience in Neovim.

## Requirements

- Neovim >= 0.8
- [ReScript LSP](https://github.com/rescript-lang/rescript-vscode) >= 1.10.0

## Install

**packer.nvim**

```lua
use 'aspeddro/rescript-tools.nvim'
```

## Recommendations

The [rescript-vscode](https://github.com/rescript-lang/rescript-vscode) plugin contains a language server than can be power other editors. I recommend using [mason.nvim](https://github.com/williamboman/mason.nvim) to install the language server. It will download the `vsix` file from the latest stable release and add it to the Neovim `PATH` as `rescript-lsp`.

## Usage

```lua
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
  on_attach = on_attach,
  commands = {
    ResOpenCompiled = {
      require('rescript-tools').open_compiled,
      description = 'Open Compiled JS',
    },
    ResCreateInterface = {
      require('rescript-tools').create_interface,
      description = 'Create Interface file',
    },
    ResSwitchImplInt = {
      require('rescript-tools').switch_impl_intf,
      description = 'Switch Implementation/Interface',
    },
  },
}
```

Mode details see `help rescript-tools`

## Using pre-releases channel

You can test the pre-release channel similar to [vscode-plugin](https://forum.rescript-lang.org/t/ann-vscode-extension-pre-releases/3588).

Install from latest-master:
```
MasonInstall rescript-lsp@latest-master
```
