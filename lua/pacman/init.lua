local M = {}

local config = {
	width = 30, -- Ширина дорожки
	delay = 600, -- Задержка между кадрами (в миллисекундах)
	pacman_open = "C", -- Символ открытого пакмана
	pacman_closed = "c", -- Символ закрытого пакмана
	path_food = "", -- Символ еды
	path_trail = "─", -- След пакмана
}

local path = {}
local position = 1
local is_open = true

-- Генерация начального пути
local function generate_path()
	path = {}
	for i = 1, config.width do
		if (i % 4) == 0 then
			table.insert(path, config.path_food)
		else
			table.insert(path, " ")
		end
	end
end

generate_path()

-- Получение текущего кадра Pacman
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

	-- Обновление следа пакмана
	if path[position] == config.path_food then
		path[position] = config.path_trail
	elseif path[position] == " " then
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

	-- Таймер для бесконечного обновления
	local timer = vim.loop.new_timer()
	timer:start(
		0,
		config.delay,
		vim.schedule_wrap(function()
			-- Обновление tabline
			vim.o.tabline = M.get_pacman_text()
			vim.cmd("redrawtabline")
		end)
	)
end

return M
