-- chunkname: @scripts/components/randomized_throwing_shard_unit.lua

local RandomizedThrowingShardUnit = component("RandomizedThrowingShardUnit")
local DISSOLVE_TIME = 0.3

RandomizedThrowingShardUnit.init = function (self, unit)
	self._unit = unit

	local world = Unit.world(unit)

	self._world = world
	self._wwise_world = Wwise.wwise_world(world)

	local visiblity_group_names = {}

	self._visiblity_group_names = visiblity_group_names
	self._dissolve_material_slot_name = self:get_data(unit, "dissolve_material_slot_name")
	self._dissolve_variable_name = self:get_data(unit, "dissolve_variable_name")

	local visiblity_groups = self:get_data(unit, "visiblity_groups")
	local num_visiblity_groups = #visiblity_groups

	for ii = 1, num_visiblity_groups do
		local entry = visiblity_groups[ii]
		local visiblity_group_name = entry.visiblity_group_name

		visiblity_group_names[#visiblity_group_names + 1] = visiblity_group_name
	end

	self._num_visibility_groups = #visiblity_group_names
	self._current_visibility_group_index = 1
	self._looping_effect_id = nil

	self:hide_all_vsibility_groups()

	return true
end

RandomizedThrowingShardUnit.enable = function (self, unit)
	return
end

RandomizedThrowingShardUnit.disable = function (self, unit)
	return
end

RandomizedThrowingShardUnit.destroy = function (self, unit)
	self:hide()
end

RandomizedThrowingShardUnit.update = function (self, unit, dt, t)
	self:_update_dissolve(dt, t)

	return true
end

RandomizedThrowingShardUnit._update_dissolve = function (self, dt, t)
	local start_t = self._dissolve_start_t

	if not start_t then
		return
	end

	local unit = self._unit
	local dissolve_material_slot_name = self._dissolve_material_slot_name
	local time_in_dissolve = t - start_t
	local value = time_in_dissolve / DISSOLVE_TIME

	Unit.set_scalar_for_material(unit, dissolve_material_slot_name, self._dissolve_variable_name, math.clamp01(value))

	if value >= 1 then
		self._dissolve_start_t = nil
	end
end

RandomizedThrowingShardUnit._show_visibility_group = function (self, visibility_group_index, scale)
	local unit = self._unit

	Unit.set_visibility(unit, self._visiblity_group_names[visibility_group_index], true, true)
	Unit.set_local_scale(unit, 1, Vector3.one() * scale)
end

RandomizedThrowingShardUnit._hide_visibility_group = function (self, visibility_group_index)
	local unit = self._unit

	Unit.set_visibility(unit, self._visiblity_group_names[visibility_group_index], false, true)
	Unit.set_local_scale(unit, 1, Vector3.one())
end

RandomizedThrowingShardUnit._start_dissolve = function (self, t)
	self._dissolve_start_t = t

	local unit = self._unit
	local dissolve_material_slot_name = self._dissolve_material_slot_name

	Unit.set_scalar_for_material(unit, dissolve_material_slot_name, self._dissolve_variable_name, 0)
end

RandomizedThrowingShardUnit.set_visibility_group_index = function (self, visibility_group_index)
	self._visibility_group_index = visibility_group_index
end

RandomizedThrowingShardUnit.show = function (self, t, particle_effect_name, wwise_event_name, scale)
	if particle_effect_name then
		local world = self._world
		local effect_id = World.create_particles(world, particle_effect_name, Vector3.zero())

		World.link_particles(world, effect_id, self._unit, 1, Matrix4x4.identity(), "stop")

		self._looping_effect_id = effect_id
	end

	if wwise_event_name then
		WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, self._unit)
	end

	self:_show_visibility_group(self._visibility_group_index, scale)
	self:_start_dissolve(t)
end

RandomizedThrowingShardUnit.hide = function (self)
	if self._looping_effect_id then
		World.destroy_particles(self._world, self._looping_effect_id)

		self._looping_effect_id = nil
	end

	self:_hide_visibility_group(self._visibility_group_index)
end

RandomizedThrowingShardUnit.hide_all_vsibility_groups = function (self)
	local num_visibility_groups = self._num_visibility_groups

	for ii = 1, num_visibility_groups do
		self:_hide_visibility_group(ii)
	end
end

RandomizedThrowingShardUnit.num_visibility_groups = function (self)
	return self._num_visibility_groups
end

RandomizedThrowingShardUnit.component_data = {
	visiblity_groups = {
		ui_name = "Visiblity Groups",
		ui_type = "struct_array",
		definition = {
			visiblity_group_name = {
				ui_name = "Visiblity Group Name",
				ui_type = "text_box",
				value = "",
			},
		},
		control_order = {
			"visiblity_group_name",
		},
	},
	dissolve_variable_name = {
		category = "Dissolve",
		ui_name = "Variable Name",
		ui_type = "text_box",
		value = "",
	},
	dissolve_material_slot_name = {
		category = "Dissolve",
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "",
	},
}

return RandomizedThrowingShardUnit
