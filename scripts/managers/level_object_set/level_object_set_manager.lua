-- chunkname: @scripts/managers/level_object_set/level_object_set_manager.lua

local Component = require("scripts/utilities/component")
local LevelObjectSetsSettings = require("scripts/settings/level_object_sets/level_object_sets_settings")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local LevelObjectSetManager = class("LevelObjectSetManager")
local OBJECT_SET_TYPES = LevelObjectSetsSettings.object_set_types
local MAX_NUM_UNITS_IN_OBJECT_SETS = 8192
local UNITS_PER_FRAME = 256
local Unit_get_data = Unit.get_data
local Unit_flow_event = Unit.flow_event

LevelObjectSetManager.init = function (self, world, level_name)
	self._world = world
	self._main_level = ScriptWorld.level(world, level_name)
	self._level_object_set_data = {
		read_index = 1,
		size = 0,
		write_index = 1,
		ring_buffer = Script.new_array(MAX_NUM_UNITS_IN_OBJECT_SETS),
		max_size = MAX_NUM_UNITS_IN_OBJECT_SETS,
		units_per_frame = UNITS_PER_FRAME,
	}
end

LevelObjectSetManager.destroy = function (self)
	return
end

LevelObjectSetManager.post_update = function (self, dt, t)
	local data = self._level_object_set_data
	local size = data.size
	local flush = self._flush_object_set_enable

	if size > 0 then
		local units_per_frame = flush and math.huge or data.units_per_frame
		local num_units = math.min(units_per_frame, size)
		local read_index = data.read_index
		local max_size = data.max_size
		local buffer = data.ring_buffer
		local level = self._main_level

		for ii = 1, num_units do
			local unit_index = buffer[read_index]

			self:_set_object_set_unit_visible(level, unit_index)

			read_index = read_index % max_size + 1
			size = size - 1
		end

		data.size = size
		data.read_index = read_index
	end

	if flush and flush == 1 then
		self._flush_object_set_enable = false
	elseif flush then
		self._flush_object_set_enable = flush - 1
	end
end

LevelObjectSetManager.register_object_sets = function (self, level_object_sets)
	local object_sets_data = {}

	for object_set_name, object_sets in pairs(level_object_sets) do
		object_sets_data[object_set_name] = object_sets

		for ii = 1, #object_sets do
			local object_set = object_sets[ii]

			if object_set.object_set_type == OBJECT_SET_TYPES.controllable then
				self:_set_object_set_visible(object_set, false, object_set_name)
			end
		end
	end

	self._object_sets_data = object_sets_data
end

LevelObjectSetManager.set_object_set_visible = function (self, object_set_name, visible)
	local object_sets = self._object_sets_data[object_set_name]

	for ii = 1, #object_sets do
		local object_set = object_sets[ii]

		self:_set_object_set_visible(object_set, visible, object_set_name)
	end
end

LevelObjectSetManager._set_object_set_visible = function (self, object_set, visible)
	if object_set.visible == visible then
		return
	end

	object_set.visible = visible

	local level = self._main_level
	local data = self._level_object_set_data
	local buffer = data.ring_buffer
	local write_index = data.write_index
	local read_index = data.read_index
	local size = data.size
	local max_size = data.max_size
	local units_indices = object_set.units_indices
	local new_units_size = #units_indices
	local new_size = size + new_units_size
	local overflow = new_size - max_size

	if overflow > 0 then
		local amount_to_remove = math.min(overflow, size)

		for ii = 1, amount_to_remove do
			local unit_index = buffer[read_index]

			self:_set_object_set_unit_visible(level, unit_index)

			read_index = read_index % max_size + 1
			size = size - 1
		end

		data.read_index = read_index
	end

	local object_set_size_overflow = new_units_size - max_size

	for ii = 1, #units_indices do
		local unit_index = units_indices[ii]
		local unit = Managers.state.unit_spawner:unit(unit_index, true)

		if unit then
			local references = Unit.get_data(unit, "object_set_references") or 1

			if visible then
				references = references + 1
			else
				references = math.max(references - 1, 0)
			end

			Unit.set_data(unit, "object_set_references", references)

			if ii <= object_set_size_overflow then
				self:_set_object_set_unit_visible(level, unit_index)
			else
				buffer[write_index] = unit_index
				write_index = write_index % max_size + 1
				size = size + 1
			end
		end
	end

	data.write_index = write_index
	data.size = size
end

LevelObjectSetManager._set_object_set_unit_visible = function (self, level, unit_index)
	local unit = Managers.state.unit_spawner:unit(unit_index, true)
	local references = Unit_get_data(unit, "object_set_references")
	local enabled = Unit_get_data(unit, "object_set_enabled")

	if enabled == nil then
		enabled = true
	end

	local enable = not enabled and references > 0
	local disable = enabled and references == 0
	local new_state

	if enable then
		new_state = true
	elseif disable then
		new_state = false
	end

	if new_state ~= nil then
		Unit.set_data(unit, "object_set_enabled", new_state)

		if Unit.has_data(unit, "LevelEditor", "is_gizmo_unit") then
			local is_gizmo = Unit.get_data(unit, "LevelEditor", "is_gizmo_unit")
			local is_decal = Unit.get_data(unit, "is_decal")
			local is_reflection_probe = Unit.is_a(unit, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

			if is_gizmo and not is_reflection_probe and not is_decal then
				Unit.set_unit_visibility(unit, false)
			else
				Unit.set_unit_visibility(unit, new_state)
			end
		else
			Unit.set_unit_visibility(unit, new_state)
		end

		if Unit.has_visibility_group(unit, "gizmo") then
			Unit.set_visibility(unit, "gizmo", false)
		end

		local ignore_physics = Unit_get_data(unit, "physics_ignores_object_set")

		if ignore_physics then
			if new_state then
				Unit_flow_event(unit, "hide_helper_mesh")
				Unit_flow_event(unit, "unit_object_set_enabled")
				Component.event(unit, "set_object_set_unit_visible", true)
			else
				Unit_flow_event(unit, "unit_object_set_disabled")
				Component.event(unit, "set_object_set_unit_visible", false)
			end
		else
			local actor_list

			if new_state then
				actor_list = Unit_get_data(unit, "flow_object_set_actor_list")
			else
				actor_list = {}
			end

			for ii = 1, Unit.num_actors(unit) do
				if new_state and actor_list[ii] then
					Unit.create_actor(unit, ii)
				elseif not new_state and Unit.actor(unit, ii) then
					Unit.destroy_actor(unit, ii)

					actor_list[ii] = true
				end
			end

			if new_state then
				Unit.set_data(unit, "flow_object_set_actor_list", nil)
				Unit_flow_event(unit, "hide_helper_mesh")
				Unit_flow_event(unit, "unit_object_set_enabled")
				Component.event(unit, "set_object_set_unit_visible", true)
			else
				Unit.set_data(unit, "flow_object_set_actor_list", actor_list)
				Unit_flow_event(unit, "unit_object_set_disabled")
				Component.event(unit, "set_object_set_unit_visible", false)
			end
		end
	end
end

return LevelObjectSetManager
