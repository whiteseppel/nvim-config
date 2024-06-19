return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    update_focused_file = {
      enable = true,
      update_root = {
        enable = false,
        ignore_list = {},
      },
      exclude = false,
    },
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 40,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
      git_ignored = true,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    }
  },
}
