-- chunkname: @scripts/extension_systems/liquid_area/liquid_area_drawer.lua

local HexGrid = require("scripts/foundation/utilities/hex_grid")
local LiquidAreaDrawer = class("LiquidAreaDrawer")

LiquidAreaDrawer.init = function (self, world, liquid_template)
	self._name = liquid_template.name
	self._template = liquid_template
	self._world = world
	self._vfx_name_rim = liquid_template.vfx_name_rim
	self._vfx_name_filled = liquid_template.vfx_name_filled

	local center = Vector3(0, 0, 0)
	local x_cell_size = liquid_template.cell_size
	local z_cell_size = liquid_template.z_cell_size or 1
	local xy_extents = 1000 / x_cell_size
	local z_extents = 1000 / z_cell_size

	self._hex_grid = HexGrid:new(center, xy_extents, z_extents, x_cell_size, z_cell_size)
	self._particles = {}
	self._particle_count = {}
	self._particle_group = World.create_particle_group(self._world)
end

LiquidAreaDrawer.add_cell = function (self, position, rotation)
	local particle_group

	if GameParameters.destroy_unmanaged_particles then
		particle_group = self._particle_group
	end

	local index = self._hex_grid:real_index_from_position(position)

	if self._particles[index] then
		self._particle_count[index] = self._particle_count[index] + 1

		local particle_id = self._particles[index]

		World.stop_spawning_particles(self._world, particle_id)

		particle_id = World.create_particles(self._world, self._vfx_name_filled, position, rotation, nil, particle_group)
		self._particles[index] = particle_id
	else
		self._particle_count[index] = 1

		local particle_id = World.create_particles(self._world, self._vfx_name_filled, position, rotation, nil, particle_group)

		self._particles[index] = particle_id
	end

	return index
end

LiquidAreaDrawer.remove_cell = function (self, index)
	if self._particles[index] then
		local new_count = self._particle_count[index] - 1

		if new_count == 0 then
			local particle_id = self._particles[index]

			World.stop_spawning_particles(self._world, particle_id)

			self._particles[index] = nil
			self._particle_count[index] = nil
		else
			self._particle_count[index] = new_count
		end
	end
end

LiquidAreaDrawer.destroy = function (self)
	for _, particle_id in pairs(self._particles) do
		World.stop_spawning_particles(self._world, particle_id)
	end

	World.destroy_particle_group(self._world, self._particle_group)
end

return LiquidAreaDrawer
