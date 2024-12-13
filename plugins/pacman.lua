local pacman = require("pacman")

vim.api.nvim_create_user_command("PacmanHelp", function()
	vim.cmd("help pacman")
end, {})
