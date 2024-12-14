local M = {}

local config = {
	width = 30, -- Ширина строки
	delay = 600, -- Задержка обновления (в миллисекундах)
	pacman_open = "C", -- Символ Pac-Man с открытым ртом
	pacman_closed = "c", -- Символ Pac-Man с закрытым ртом
	path_food = "", -- Символ еды
	path_empty = " ", -- Символ пустого пути
	path_trail = "─", -- Символ следа
}

local path = {}
local position = 1
local is_open = true

-- Генерация пути
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

-- Получение строки Pac-Man
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
		path[position] = config.path_trail
	elseif path[position] == config.path_empty then
		path[position] = config.path_trail
	end

	position = position + 1
	if position > #path then
		position = 1
		generate_path()
	end

	is_open = not is_open

	return table.concat(line)
end

-- Настройка плагина
function M.setup(user_config)
	if user_config then
		config = vim.tbl_extend("force", config, user_config)
	end

	local timer = vim.loop.new_timer()
	timer:start(
		0,
		config.delay,
		vim.schedule_wrap(function()
			vim.cmd("redrawtabline")
		end)
	)
end

return M
