-- chunkname: @scripts/foundation/utilities/hex_grid.lua

local HexGrid = class("HexGrid")
local pi_div_3 = math.pi / 3
local two_pi = math.two_pi
local DIRECTIONS = {
	{
		angle = 0,
		i = 1,
		j = 0,
	},
	{
		i = 1,
		j = -1,
		angle = two_pi - pi_div_3,
	},
	{
		i = 0,
		j = -1,
		angle = two_pi - pi_div_3 * 2,
	},
	{
		i = -1,
		j = 0,
		angle = two_pi - pi_div_3 * 3,
	},
	{
		i = -1,
		j = 1,
		angle = two_pi - pi_div_3 * 4,
	},
	{
		i = 0,
		j = 1,
		angle = two_pi - pi_div_3 * 5,
	},
}
local NUM_DIRECTIONS = #DIRECTIONS

HexGrid.init = function (self, center, xy_extents, z_extents, x_cell_size, z_cell_size)
	local x_vector = Vector3.right()
	local y_vector = Vector3.forward()
	local z_vector = Vector3.up()
	local y_cell_size = math.tan(pi_div_3) * 0.5 * x_cell_size
	local root = center - x_vector * ((xy_extents + 1 + xy_extents * 0.5) * x_cell_size) - y_vector * ((xy_extents + 1) * y_cell_size) - z_vector * (z_extents + 1) * z_cell_size

	self._root_position = Vector3Box(root)
	self._x_cell_size = x_cell_size
	self._y_cell_size = y_cell_size
	self._z_cell_size = z_cell_size

	local row_size = xy_extents * 2 + 1

	self._row_size = row_size
	self._layer_size = row_size * row_size
end

HexGrid.directions = function (self)
	return DIRECTIONS, NUM_DIRECTIONS
end

HexGrid.ijk_from_real_index = function (self, real_index)
	local row_size = self._row_size
	local i = real_index % row_size
	local left = (real_index - i) / row_size
	local j = left % row_size

	left = left - j

	local k = left / row_size

	return i, j + 1, k + 1
end

HexGrid.ijk_from_position = function (self, position)
	local root = self._root_position:unbox()
	local relative_position = position - root
	local x_cell_size = self._x_cell_size
	local y_cell_size = self._y_cell_size
	local z_cell_size = self._z_cell_size
	local j = math.floor(relative_position.y / y_cell_size + 0.5)
	local i = math.floor((relative_position.x - (j - 1) * 0.5 * x_cell_size) / x_cell_size + 0.5)
	local k = math.floor(relative_position.z / z_cell_size + 0.5)

	return i, j, k
end

HexGrid.position_from_ijk = function (self, i, j, k)
	local root = self._root_position:unbox()
	local z = k * self._z_cell_size
	local y = j * self._y_cell_size
	local x = (i + 0.5 * (j - 1)) * self._x_cell_size

	return root + Vector3(x, y, z)
end

HexGrid.real_index_from_ijk = function (self, i, j, k)
	local row_size = self._row_size
	local layer_size = self._layer_size

	return i + (j - 1) * row_size + (k - 1) * layer_size
end

HexGrid.real_index_from_position = function (self, position)
	local i, j, k = self:ijk_from_position(position)
	local real_index = self:real_index_from_ijk(i, j, k)

	return real_index
end

HexGrid.is_out_of_bounds = function (self, i, j, k)
	local row_size = self._row_size

	return i < 0 or row_size <= i or j < 0 or row_size <= j or k < 0
end

return HexGrid
