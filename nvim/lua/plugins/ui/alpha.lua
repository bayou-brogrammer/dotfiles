return {
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"

      -- dashboard.section.header.val = [[
      --   ##:::'##:'####::'######::'##:::'##::'######::'########::::'###::::'########::'########:'##::: ##:'##::::'##:'####:'##::::'##:
      --   ##::'##::. ##::'##... ##: ##::'##::'##... ##:... ##..::::'## ##::: ##.... ##:... ##..:: ###:: ##: ##:::: ##:. ##:: ###::'###:
      --   ##:'##:::: ##:: ##:::..:: ##:'##::: ##:::..::::: ##:::::'##:. ##:: ##:::: ##:::: ##:::: ####: ##: ##:::: ##:: ##:: ####'####:
      --   #####::::: ##:: ##::::::: #####::::. ######::::: ##::::'##:::. ##: ########::::: ##:::: ## ## ##: ##:::: ##:: ##:: ## ### ##:
      --   ##. ##:::: ##:: ##::::::: ##. ##::::..... ##:::: ##:::: #########: ##.. ##:::::: ##:::: ##. ####:. ##:: ##::: ##:: ##. #: ##:
      --   ##:. ##::: ##:: ##::: ##: ##:. ##::'##::: ##:::: ##:::: ##.... ##: ##::. ##::::: ##:::: ##:. ###::. ## ##:::: ##:: ##:.:: ##:
      --   ##::. ##:'####:. ######:: ##::. ##:. ######::::: ##:::: ##:::: ##: ##:::. ##:::: ##:::: ##::. ##:::. ###::::'####: ##:::: ##:
      --   ..::::..::....:::......:::..::::..:::......::::::..:::::..:::::..::..:::::..:::::..:::::..::::..:::::...:::::....::..:::::..:
      -- ]]

      -- dashboard.section.header.val = [[
      --   _       _________ _______  _        _______ _________ _______  _______ _________ _                _________ _______
      --   | \    /\\__   __/(  ____ \| \    /\(  ____ \\__   __/(  ___  )(  ____ )\__   __/( (    /||\     /|\__   __/(       )
      --   |  \  / /   ) (   | (    \/|  \  / /| (    \/   ) (   | (   ) || (    )|   ) (   |  \  ( || )   ( |   ) (   | () () |
      --   |  (_/ /    | |   | |      |  (_/ / | (_____    | |   | (___) || (____)|   | |   |   \ | || |   | |   | |   | || || |
      --   |   _ (     | |   | |      |   _ (  (_____  )   | |   |  ___  ||     __)   | |   | (\ \) |( (   ) )   | |   | |(_)| |
      --   |  ( \ \    | |   | |      |  ( \ \       ) |   | |   | (   ) || (\ (      | |   | | \   | \ \_/ /    | |   | |   | |
      --   |  /  \ \___) (___| (____/\|  /  \ \/\____) |   | |   | )   ( || ) \ \__   | |   | )  \  |  \   /  ___) (___| )   ( |
      --   |_/    \/\_______/(_______/|_/    \/\_______)   )_(   |/     \||/   \__/   )_(   |/    )_)   \_/   \_______/|/     \|
      -- ]]

      dashboard.section.header.val = [[
         _   __ _        _          _                 _    _   _         _            
        | | / /(_)      | |        | |               | |  | \ | |       (_)           
        | |/ /  _   ___ | | __ ___ | |_   __ _  _ __ | |_ |  \| |__   __ _  _ __ ___  
        |    \ | | / __|| |/ // __|| __| / _` || '__|| __|| . ` |\ \ / /| || '_ ` _ \ 
        | |\  \| || (__ |   < \__ \| |_ | (_| || |   | |_ | |\  | \ V / | || | | | | |
        \_| \_/|_| \___||_|\_\|___/ \__| \__,_||_|    \__|\_| \_/  \_/  |_||_| |_| |_|
      ]]
      dashboard.section.header.opts.hl = "DashboardHeader"

      local button = require("kickstart.utils").alpha_button
      local get_icon = require("kickstart.utils").get_icon
      dashboard.section.buttons.val = {
        button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
        button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
        button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
        button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
        button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
        button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
      }

      dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
      dashboard.config.layout[3].val = 5
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = require "plugins.configs.ui.alpha",
  },
}
