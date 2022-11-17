local OutOfBoundsManager = class("OutOfBoundsManager")
local World_update_out_of_bounds_checker = World.update_out_of_bounds_checker
local Unit_local_position = Unit.local_position
local Unit_world_position = Unit.world_position
local Unit_has_node = Unit.has_node
local Unit_node = Unit.node
local RAGDOLL_POSITION_NODE_NAME = "j_hips"

local function update_hard_oob(current_hard_oob, previous_hard_oob)
	for unit in pairs(previous_hard_oob) do
		if current_hard_oob[unit] == nil then
			previous_hard_oob[unit] = nil
		end
	end
end

local function out_of_bounds_error(current_hard_oob)
	local units_text = ""

	for unit in pairs(current_hard_oob) do
		local position = Unit_local_position(unit, 1)
		local ragdoll_position_text = ""

		if Unit_has_node(unit, RAGDOLL_POSITION_NODE_NAME) then
			local ragdoll_position_node_index = Unit_node(unit, RAGDOLL_POSITION_NODE_NAME)
			local ragdoll_position = Unit_world_position(unit, ragdoll_position_node_index)
			ragdoll_position_text = string.format(" : %s = %s", RAGDOLL_POSITION_NODE_NAME, tostring(ragdoll_position))
		end

		local is_owned_by_death_manager = false
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if unit_data_extension and unit_data_extension:is_owned_by_death_manager() then
			is_owned_by_death_manager = true
		end

		units_text = string.format("%s\n\t%s (%s%s) is_owned_by_death_manager: %s; level(%s)", units_text, tostring(unit), tostring(position), ragdoll_position_text, tostring(is_owned_by_death_manager), tostring(Unit.level(unit)))
	end

	ferror("[OutOfBoundsManager] Following units were out-of-bounds: %s\n", units_text)
end

local function register_new_hard_oob_units(current_hard_oob, previous_hard_oob)
	local unit_spawner_manager = Managers.state.unit_spawner

	for unit in pairs(current_hard_oob) do
		local game_object_id_or_nil = unit_spawner_manager:game_object_id(unit)

		if game_object_id_or_nil or previous_hard_oob[unit] then
			out_of_bounds_error(current_hard_oob)

			return
		else
			previous_hard_oob[unit] = true
		end
	end
end

OutOfBoundsManager.init = function (self, world, hard_cap_extents, soft_cap_extents)
	self._registered_units = Script.new_map(16)
	self._local_hard_cap_out_of_bounds_units = Script.new_map(16)
	self._hard_cap_extents = Vector3Box(hard_cap_extents)
	self._soft_cap_extents = Vector3Box(soft_cap_extents)
end

OutOfBoundsManager.pre_update = function (self, shared_state)
	local hard_cap_out_of_bounds_units = shared_state.hard_cap_out_of_bounds_units
	local soft_cap_out_of_bounds_units = shared_state.soft_cap_out_of_bounds_units
	local world = shared_state.world

	table.clear(soft_cap_out_of_bounds_units)
	table.clear(hard_cap_out_of_bounds_units)

	local num_hard_cap_units, _ = World_update_out_of_bounds_checker(world, hard_cap_out_of_bounds_units, soft_cap_out_of_bounds_units)
	local local_hard_cap_out_of_bounds_units = self._local_hard_cap_out_of_bounds_units

	update_hard_oob(hard_cap_out_of_bounds_units, local_hard_cap_out_of_bounds_units)

	if num_hard_cap_units > 0 then
		register_new_hard_oob_units(hard_cap_out_of_bounds_units, local_hard_cap_out_of_bounds_units)
	end
end

OutOfBoundsManager.update = function (self, shared_state)
	local soft_cap_out_of_bounds_units = shared_state.soft_cap_out_of_bounds_units
	local registered_units = self._registered_units

	for unit in pairs(soft_cap_out_of_bounds_units) do
		local callbacks = registered_units[unit]

		if callbacks then
			for object, callback_name in pairs(callbacks) do
				object[callback_name](object, unit)
			end
		end
	end
end

OutOfBoundsManager.register_soft_oob_unit = function (self, unit, object, callback_name)
	local registered_units = self._registered_units

	if registered_units[unit] then
		registered_units[unit][object] = callback_name
	else
		registered_units[unit] = registered_units[unit] or setmetatable({
			[object] = callback_name
		}, {
			__mode = "v"
		})
	end
end

OutOfBoundsManager.unregister_soft_oob_unit = function (self, unit, object)
	local registered_units = self._registered_units
	local callbacks = registered_units[unit]

	if callbacks then
		callbacks[object] = nil

		if table.is_empty(callbacks) then
			registered_units[unit] = nil
		end
	end
end

OutOfBoundsManager.hard_cap_extents = function (self)
	return self._hard_cap_extents:unbox()
end

OutOfBoundsManager.soft_cap_extents = function (self)
	return self._soft_cap_extents:unbox()
end

return OutOfBoundsManager
