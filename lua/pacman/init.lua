local M = {}

local config = {
	width = 30,
	delay = 600,
	pacman_open = "C",
	pacman_closed = "c",
	path_food = "",
	path_empty = " ",
}

local path = {}
local position = 1
local is_open = true

local function generate_path()
	path = {}
	for i = 1, config.width do
		if (i % 4) == 0 then
			table.insert(path, config.path_food)
		else
			table.insert(path, config.path_empty)
		end
	end
end

generate_path()

function M.get_pacman_text()
	local pacman = is_open and config.pacman_open or config.pacman_closed
	local line = {}
	for i, char in ipairs(path) do
		if i == position then
			table.insert(line, pacman)
		else
			table.insert(line, char)
		end
	end

	if path[position] == config.path_food then
		path[position] = "─"
	elseif path[position] == config.path_empty then
		path[position] = "─"
	end

	position = position + 1
	if position > #path then
		position = 1
		generate_path()
	end

	is_open = not is_open

	return table.concat(line)
end

-- Устанавливаем статусную строку с анимацией
function M.setup(user_config)
	if user_config then
		config = vim.tbl_extend("force", config, user_config)
	end

	-- Функция для обновления statusline
	vim.o.statusline = "%!v:lua.require('pacman').get_pacman_text()"

	-- Таймер для постоянного обновления
	local timer = vim.loop.new_timer()
	timer:start(
		0,
		config.delay,
		vim.schedule_wrap(function()
			vim.cmd("redrawstatus") -- Обновляем statusline
		end)
	)
end

return M