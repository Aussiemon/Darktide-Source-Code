local HordeSettings = require("scripts/settings/horde/horde_settings")
local HordeTemplates = require("scripts/managers/horde/horde_templates")
local HORDE_TYPES = HordeSettings.horde_types
local HordeManager = class("HordeManager")

HordeManager.init = function (self, nav_world, physics_world)
	self._hordes = {}

	for horde_type, _ in pairs(HORDE_TYPES) do
		self._hordes[horde_type] = {}
	end

	self._total_alive_horde_minions = {}

	for horde_type, _ in pairs(HORDE_TYPES) do
		self._total_alive_horde_minions[horde_type] = 0
	end

	self._nav_world = nav_world
	self._physics_world = physics_world
end

HordeManager.horde = function (self, horde_type, horde_template_name, side_id, target_side_id, composition, ...)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(side_id)
	local target_side = side_system:get_side(target_side_id)
	local horde_template = HordeTemplates[horde_template_name]
	local physics_world = self._physics_world
	local nav_world = self._nav_world
	local horde, horde_position, target_unit, spawned_direction = horde_template.execute(physics_world, nav_world, side, target_side, composition, ...)
	local hordes = self._hordes
	hordes[horde_type][#hordes[horde_type] + 1] = horde
	local success = horde ~= nil
	local group_id = horde and horde.group_id

	return success, horde_position, target_unit, group_id, spawned_direction
end

HordeManager.can_spawn = function (self, horde_type, horde_template_name, side_id, target_side_id, composition, ...)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(side_id)
	local target_side = side_system:get_side(target_side_id)
	local horde_template = HordeTemplates[horde_template_name]
	local physics_world = self._physics_world
	local nav_world = self._nav_world
	local can_spawn = horde_template.can_spawn(physics_world, nav_world, side, target_side, composition, ...)

	return can_spawn
end

HordeManager.num_active_hordes = function (self, horde_type)
	if horde_type then
		return #self._hordes[horde_type]
	else
		local num_hordes = 0

		for _, hordes in pairs(self._hordes) do
			num_hordes = num_hordes + #hordes
		end

		return num_hordes
	end
end

local HORDE_POSITIONS = {}

HordeManager.horde_positions = function (self, horde_type)
	table.clear(HORDE_POSITIONS)

	local hordes = self._hordes[horde_type]
	local group_system = Managers.state.extension:system("group_system")

	for ii = 1, #hordes do
		local horde = hordes[ii]
		local position = group_system:group_position(horde.group_id)
		HORDE_POSITIONS[#HORDE_POSITIONS + 1] = position
	end

	return HORDE_POSITIONS
end

HordeManager.num_alive = function (self, horde_type)
	return self._total_alive_horde_minions[horde_type]
end

HordeManager.update = function (self, dt, t)
	for horde_type, hordes in pairs(self._hordes) do
		local total_alive_horde_minions = 0
		local num_hordes = #hordes
		local horde_index = 1

		while num_hordes >= horde_index do
			local horde = hordes[horde_index]
			local horde_template_name = horde.template_name
			local horde_template = HordeTemplates[horde_template_name]

			if horde_template.update then
				horde_template.update(horde, dt, t)
			end

			local group_system = Managers.state.extension:system("group_system")
			local group = group_system:group_from_id(horde.group_id)

			if not group then
				table.swap_delete(hordes, horde_index)

				num_hordes = num_hordes - 1
			elseif group.min_members_spawned then
				local group_members = group.members
				local num_group_members = #group_members
				total_alive_horde_minions = total_alive_horde_minions + num_group_members
				horde_index = horde_index + 1
			else
				horde_index = horde_index + 1
			end
		end

		self._total_alive_horde_minions[horde_type] = total_alive_horde_minions
	end
end

return HordeManager
