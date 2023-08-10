return {
  "AstroNvim/astroui",
  lazy = false, -- disable lazy loading
  priority = 10000, -- load AstroUI first
  ---@type AstroUIConfig
  opts = {
    -- Colorscheme set on startup, a string that is used with `:colorscheme astrodark`
    colorscheme = "catppuccin",

    -- Override highlights in any colorscheme
    -- Keys can be:
    --   `init`: table of highlights to apply to all colorschemes
    --   `<colorscheme_name>` override highlights in the colorscheme with name: `<colorscheme_name>`
    highlights = {},

    -- A table of icons in the UI using NERD fonts
    icons = {
      GitAdd = "",
      VimIcon = "",
      GitBranch = "",
      GitChange = "",
      GitDelete = "",
      ScrollText = "",
    },

    -- A table of only text "icons" used when icons are disabled
    text_icons = {
      GitAdd = "[+]",
    },

    -- Configuration options for the AstroNvim lines and bars built with the `status` API.
    status = {
      -- Configure attributes of components defined in the `status` API. Check the AstroNvim documentation for a complete list of color names, this applies to colors that have `_fg` and/or `_bg` names with the suffix removed (ex. `git_branch_fg` as attributes from `git_branch`).
      attributes = {
        mode = { bold = true },
        git_branch = { bold = true },
      },

      -- Configure colors of components defined in the `status` API. Check the AstroNvim documentation for a complete list of color names.
      colors = function(hl)
        local get_hlgroup = require("astrocore").get_hlgroup

        -- use helper function to get highlight group properties
        local comment_fg = get_hlgroup("Comment").fg
        hl.git_branch_fg = comment_fg
        hl.git_added = comment_fg
        hl.git_changed = comment_fg
        hl.git_removed = comment_fg
        hl.blank_bg = get_hlgroup("Folded").fg
        hl.file_info_bg = get_hlgroup("Visual").bg
        hl.nav_icon_bg = get_hlgroup("String").fg
        hl.nav_fg = hl.nav_icon_bg
        hl.folder_icon_bg = get_hlgroup("Error").fg

        return hl
      end,

      -- Configure which icons that are highlighted based on context
      icon_highlights = {
        -- enable or disable breadcrumb icon highlighting
        breadcrumbs = true,
        -- Enable or disable the highlighting of filetype icons both in the statusline and tabline
        file_icon = {
          tabline = function(self)
            return self.is_active or self.is_visible
          end,
          statusline = true,
        },
      },

      -- Configure characters used as separators for various elements
      separators = {
        none = { "", "" },
        center = { "  ", "  " },
        breadcrumbs = "  ",
        path = "  ",
        left = { "", " " }, -- separator for the left side of the statusline
        right = { " ", "" }, -- separator for the right side of the statusline
        tab = { "", "" },
      },
    },
  },
}
