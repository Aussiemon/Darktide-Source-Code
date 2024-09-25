-- chunkname: @scripts/extension_systems/camera/player_husk_camera_extension.lua

local PlayerHuskCameraExtension = class("PlayerHuskCameraExtension")

PlayerHuskCameraExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._camera_tree_component = unit_data_extension:read_component("camera_tree")
	self._is_local_unit = extension_init_data.is_local_unit
	self._ignore_offset = false
end

local NODE_IGNORE_SCALED_TRANSFORM_OFFSETS = {
	consumed = true,
}
local NODE_OBJECT_NAMES = {
	consumed = "j_hips",
}

PlayerHuskCameraExtension.camera_tree_node = function (self)
	local camera_comp = self._camera_tree_component
	local tree, node = camera_comp.tree, camera_comp.node
	local object_name = NODE_OBJECT_NAMES[node]
	local object

	if object_name and Unit.has_node(self._unit, object_name) then
		object = Unit.node(self._unit, object_name)
	end

	local ignore_offset = NODE_IGNORE_SCALED_TRANSFORM_OFFSETS[node]

	if self._ignore_offset ~= ignore_offset then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(self._unit)

		if player:is_human_controlled() then
			local viewport_name = player.viewport_name

			if viewport_name then
				Managers.state.camera:set_variable(viewport_name, "ignore_offset", ignore_offset)
			end
		end
	end

	self._ignore_offset = ignore_offset

	return tree, node, object
end

PlayerHuskCameraExtension.trigger_camera_shake = function (self, event_name)
	local is_in_first_person_mode = self._first_person_extension:is_in_first_person_mode()

	if is_in_first_person_mode then
		Managers.state.camera:add_camera_effect_shake_event(event_name)
	end
end

return PlayerHuskCameraExtension
