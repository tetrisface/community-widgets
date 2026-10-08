function widget:GetInfo()
	return {
		name = 'Raptor Grid Draw 12 players (Full Metal Plate)',
		desc = 'Paints base build lines for 12 players on the map Full Metal Plate. With bases divided evenly in size',
		author = 'Lu5ck, tetrisface',
		date = '31 May 2025',
		license = 'GNU GPL, v2 or later',
		layer = 1,
		enabled = true,
	}
end

--[[
Border values
NONE = 0
TOP = 1
RIGHT = 2
BOTTOM = 4
LEFT = 8
Diagonal \ = 16
Diagonal / = 32

For multiple borders in same cell, add the value together
TOP and RIGHT border = 1 + 2 = 3
]]
--

-- stylua: ignore
local mapping = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 12, 4, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 6, 12, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 4, 6, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 6, 12, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 0, 0, 0, 0, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 6, 12, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 0, 0, 0, 0, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 12, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 3, 9, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 3, 9, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 9, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 3, 9, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 3, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local gridsize = 12 -- 3 is nano, wind etc size. 12 is efus size. This define the cell size for the mapping
local gridsquare = 16 -- The smallest build grid to map size is 16x16

-- BAR ships "Auto mapmark eraser" enabled by default, which wipes every marker
-- eraseTime (default 60) seconds after it was drawn, on every client. So the grid has to
-- be re-sent forever. The margin makes sure a re-sent segment lands *after* the pending
-- erase: the eraser matches a line by its first point within a 100 elmo radius, so an
-- early redraw would only hand it a fresh copy to delete.
local ERASE_SECONDS = 60
local MARGIN_SECONDS = 1
local REDRAW_FRAMES = (ERASE_SECONDS + MARGIN_SECONDS) * 30

-- Several players may run this widget. The lowest playerID keeps the grid up, the rest skip
-- any line it drew within the last cycle and take over once it stops. Recency is when its
-- draw arrived here, so nobody's eraser setting matters. The slack covers its send queue
-- running behind ours, worst after pregame where every draw lands on frame 0.
local YIELD_FRAMES = REDRAW_FRAMES + 15 * 30

-- The grid is a placement aid, so stop maintaining it once the game is past that stage.
-- Whatever is on the map then survives until each client's eraser gets to it.
local STOP_FRAME = 13 * 60 * 30

-- A client that joins a running game first replays it at full speed. Markers sent then would
-- reach every player at once, so lines only go out while the sim runs at about real time.
-- ponytail: rate heuristic, a catch-up slower than CATCHUP_RATE reads as live play.
-- GameProgress(serverFrame) is exact but first arrives up to 5 s into the catch-up.
local CATCHUP_RATE = 2
local RATE_WINDOW_SECONDS = 2

-- Other lobby setups move the players' start box, lines farther than this from it are left out
local START_BOX_MARGIN = 0.1 -- of map width

local NOTICE = "To keep map lines for the whole match disable 'Interface' -> 'Auto erase map marks' in settings or download widget 'Raptor Grid Draw'"

local timer = 0
local noticeSent = false -- by us or anyone else, see AddConsoleLine
local live = false -- not replaying a running game, see CATCHUP_RATE
local rateFrame, rateSeconds = 0, 0

local lines = {} -- every segment of the grid, built once and then re-sent forever
local sendQueue = {} -- indices into lines awaiting transmission (workaround for spring draw spam protection)
local sendHead, sendTail = 1, 0
local pendingIndex, pendingDue = {}, {} -- sent segments awaiting their redraw, ordered by due frame
local pendingHead, pendingTail = 1, 0
local lineIndexByKey = {} -- endpoints -> index into lines, to recognise another player's copy
local drawnByOtherFrame = {} -- index into lines -> last frame a lower playerID drew it, see YIELD_FRAMES

-- Map draw positions travel as integers
local function lineKey(x1, z1, x2, z2)
	return string.format('%d %d %d %d', math.floor(x1 + 0.5), math.floor(z1 + 0.5), math.floor(x2 + 0.5), math.floor(z2 + 0.5))
end

local function pushSend(index)
	sendTail = sendTail + 1
	sendQueue[sendTail] = index
end

local function pushPending(index, dueFrame)
	pendingTail = pendingTail + 1
	pendingIndex[pendingTail] = index
	pendingDue[pendingTail] = dueFrame
end

local function drawLine(y, startX, startZ, endX, endZ)
	local maxLength = 24 * gridsquare

	local dx = endX - startX
	local dz = endZ - startZ
	local length = math.sqrt(dx * dx + dz * dz)

	local lengthCount = math.ceil(length / maxLength)

	for i = 0, lengthCount - 1 do
		local t1 = i / lengthCount
		local t2 = (i + 1) / lengthCount

		local sx = startX + dx * t1
		local sz = startZ + dz * t1
		local ex = startX + dx * t2
		local ez = startZ + dz * t2

		local key = lineKey(sx, sz, ex, ez)
		if not lineIndexByKey[key] then -- neighbouring cells both name their shared border
			lines[#lines + 1] = { startX = sx, startZ = sz, endX = ex, endZ = ez, y = y }
			lineIndexByKey[key] = #lines
		end
	end
end

local function hasBit(val, bit)
	return math.floor(val / bit) % 2 == 1
end

-- 0 inside the polygon, otherwise the distance to its nearest edge
local function distanceToPolygon(x, z, polygon)
	local inside = false
	local nearestSq = math.huge
	local j = #polygon
	for i = 1, #polygon do
		local ax, az = polygon[j][1], polygon[j][2]
		local bx, bz = polygon[i][1], polygon[i][2]
		if (az > z) ~= (bz > z) and x < ax + (z - az) * (bx - ax) / (bz - az) then
			inside = not inside
		end
		local ex, ez = bx - ax, bz - az
		local lengthSq = ex * ex + ez * ez
		local t = lengthSq > 0 and math.max(0, math.min(1, ((x - ax) * ex + (z - az) * ez) / lengthSq)) or 0
		local dx, dz = ax + ex * t - x, az + ez * t - z
		nearestSq = math.min(nearestSq, dx * dx + dz * dz)
		j = i
	end
	return inside and 0 or math.sqrt(nearestSq)
end

-- Polygon start boxes (mapmetadata modoptions) come from the parser BAR's own start box
-- widget uses. It expands both lobby box formats, a 2 point rectangle and an N point
-- polygon, into polygons. Without a polygon config the engine rectangle is the start box,
-- which for a polygon is only its bounding box.
local function getStartPolygons(allyTeamID)
	local included, startboxLib = pcall(VFS.Include, 'luarules/gadgets/include/startbox_utilities.lua')
	-- Two return formats: older BAR returns ParseBoxes itself, newer BAR (require
	-- refactor, #9338) a module table holding it. Calling the module fails inside the
	-- pcall below and silently degrades to the bounding box, so pick the function out.
	local parseBoxes = type(startboxLib) == 'table' and startboxLib.ParseBoxes or startboxLib
	if included and parseBoxes then
		local parsed, config, _, isExplicit = pcall(parseBoxes)
		if parsed and isExplicit and config[allyTeamID] and config[allyTeamID].boxes then
			return config[allyTeamID].boxes
		end
	end
	local xMin, zMin, xMax, zMax = Spring.GetAllyTeamStartBox(allyTeamID)
	return { { { xMin, zMin }, { xMax, zMin }, { xMax, zMax }, { xMin, zMax } } }
end

local function isNearAny(polygons, x, z, maxDistance)
	for _, polygon in ipairs(polygons) do
		if distanceToPolygon(x, z, polygon) <= maxDistance then
			return true
		end
	end
	return false
end

local function updateLive(dt, frame)
	rateSeconds = rateSeconds + dt
	if rateSeconds < RATE_WINDOW_SECONDS then
		return
	end
	local userSpeed = Spring.GetGameSpeed()
	live = frame - rateFrame <= rateSeconds * 30 * userSpeed * CATCHUP_RATE
	rateFrame, rateSeconds = frame, 0
end

-- Game-side utilities (BAR.Utilities on current versions, Spring.Utilities on
-- older ones) have been observed missing at Initialize time (crashed with
-- "attempt to index field 'Utilities'"), so fall back to the same team LuaAI
-- scan BAR's Gametype helpers use, which needs only engine API.
local function isPveGame()
	local gametype = (BAR and BAR.Utilities and BAR.Utilities.Gametype) or (Spring.Utilities and Spring.Utilities.Gametype)
	if gametype then
		return gametype.IsRaptors() or gametype.IsScavengers()
	end
	for _, teamID in ipairs(Spring.GetTeamList() or {}) do
		local luaAI = Spring.GetTeamLuaAI(teamID)
		if luaAI and (string.find(luaAI, 'Raptors') or string.find(luaAI, 'Scavengers')) then
			return true
		end
	end
	return false
end

function widget:Initialize()
	if Spring.GetSpectatingState() then
		widgetHandler:RemoveWidget() -- Don't draw when spectating
		return
	end

	if not isPveGame() then
		widgetHandler:RemoveWidget() -- Don't draw when not pve
		return
	end

	-- Substring so future Full Metal Plate revisions keep working. The row/column check
	-- below still rejects any revision whose size no longer matches the mapping.
	if not string.find(string.lower(Game.mapName or ''), 'full metal plate', 1, true) then
		widgetHandler:RemoveWidget() -- Don't draw when not supported map
		return
	end

	local cellsize = gridsize * gridsquare
	local expectedRows = Game.mapSizeZ / cellsize
	local expectedCols = Game.mapSizeX / cellsize
	if #mapping ~= expectedRows then
		Spring.Echo('Error: Mapping has ' .. #mapping .. ' rows, expected ' .. expectedRows)
		widgetHandler:RemoveWidget()
		return
	end

	for row = 1, #mapping do
		if #mapping[row] ~= expectedCols then
			Spring.Echo('Error: Row ' .. row .. ' has ' .. #mapping[row] .. ' columns, expected ' .. expectedCols)
			widgetHandler:RemoveWidget()
			return
		end
	end

	for row = 1, #mapping do
		for col = 1, #mapping[row] do
			local val = mapping[row][col]
			local x = (col - 1) * cellsize
			local z = (row - 1) * cellsize

			if hasBit(val, 1) then
				drawLine(0, x, z, x + cellsize, z) -- Top
			end
			if hasBit(val, 2) then
				drawLine(0, x + cellsize, z, x + cellsize, z + cellsize) -- Right
			end
			if hasBit(val, 4) then
				drawLine(0, x, z + cellsize, x + cellsize, z + cellsize) -- Bottom
			end
			if hasBit(val, 8) then
				drawLine(0, x, z, x, z + cellsize) -- Left
			end
			if hasBit(val, 16) then
				drawLine(0, x, z, x + cellsize, z + cellsize) -- Diagonal \
			end
			if hasBit(val, 32) then
				drawLine(0, x + cellsize, z, x, z + cellsize) -- Diagonal /
			end
		end
	end

	local startPolygons = getStartPolygons(Spring.GetMyAllyTeamID())
	local maxDistance = START_BOX_MARGIN * Game.mapSizeX
	for i = 1, #lines do
		local line = lines[i]
		if isNearAny(startPolygons, (line.startX + line.endX) / 2, (line.startZ + line.endZ) / 2, maxDistance) then
			pushSend(i)
		end
	end
end

function widget:Update(dt)
	-- Game frames, not dt, so we stall together with the eraser when the game is paused
	local frame = Spring.GetGameFrame()

	if frame >= STOP_FRAME then
		widgetHandler:RemoveWidget() -- Done redrawing, stop the widget
		return
	end

	updateLive(dt, frame)
	if not live then
		return
	end

	-- Due frames are monotonic, so the head is always the next segment to come back
	while pendingHead <= pendingTail and pendingDue[pendingHead] <= frame do
		pushSend(pendingIndex[pendingHead])
		pendingIndex[pendingHead] = nil
		pendingDue[pendingHead] = nil
		pendingHead = pendingHead + 1
	end
	if pendingHead > pendingTail then -- fully drained, rewind so the tables stay flat
		pendingHead, pendingTail = 1, 0
	end

	if sendHead > sendTail then
		return -- nothing due, keep timer where it is so the next redraw goes out at once
	end

	timer = timer + dt
	if timer <= 0.1 then
		return
	end
	timer = 0

	local dueFrame = frame + REDRAW_FRAMES
	for _ = 1, 10 do -- Draw 10 lines at a time, I think max is 12?
		if sendHead > sendTail then
			break
		end
		-- A skipped line still takes its slot, so we trail a player who started earlier
		-- instead of catching up and drawing the same lines in lockstep with them
		local index = sendQueue[sendHead]
		local otherFrame = drawnByOtherFrame[index]
		if not otherFrame or frame - otherFrame >= YIELD_FRAMES then
			local line = lines[index]
			Spring.MarkerAddLine(line.startX, line.y, line.startZ, line.endX, line.y, line.endZ)
		end
		pushPending(index, dueFrame)
		sendQueue[sendHead] = nil
		sendHead = sendHead + 1
	end

	if sendHead > sendTail then
		sendHead, sendTail = 1, 0
		if not noticeSent then -- once per match, the redraws must not repeat it
			noticeSent = true
			Spring.SendCommands('say ' .. NOTICE) -- no prefix, so players and spectators both see it
		end
	end
end

-- Every player running this widget, or another implementation of it, would post the hint.
-- One in chat is enough, so a line naming the setting and settings counts as already sent.
-- Rejoining clients replay the chat, so they see an earlier hint as well.
function widget:AddConsoleLine(msg)
	if noticeSent then
		return
	end
	local lower = string.lower(msg)
	noticeSent = string.find(lower, 'auto erase map marks', 1, true) ~= nil and string.find(lower, 'settings', 1, true) ~= nil
end

-- Higher playerIDs, and our own draws coming back, never make us yield, see YIELD_FRAMES
function widget:MapDrawCmd(playerID, cmdType, x1, _, z1, x2, _, z2)
	if cmdType ~= 'line' or playerID >= Spring.GetMyPlayerID() then
		return
	end
	local index = lineIndexByKey[lineKey(x1, z1, x2, z2)]
	if index then
		drawnByOtherFrame[index] = Spring.GetGameFrame()
	end
end
