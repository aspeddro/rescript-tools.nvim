# rescript-tools.nvim

A plugin to improve your ReScript experience in Neovim.

## Requirements

- Neovim >= 0.8
- [ReScript Language Server](https://github.com/rescript-lang/rescript-vscode/tree/master/server) >= 1.10.0

## Install

**lazy.nvim**

```lua
{ 'aspeddro/rescript-tools.nvim' }
```

## Usage

```lua
-- Setup rescript LSP
require'lspconfig'.rescriptls.setup{
  cmd = { 'rescript-language-server', '--stdio' },
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
