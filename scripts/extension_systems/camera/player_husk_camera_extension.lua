local PlayerHuskCameraExtension = class("PlayerHuskCameraExtension")

PlayerHuskCameraExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._camera_tree_component = unit_data_extension:read_component("camera_tree")
	self._is_local_unit = extension_init_data.is_local_unit
end

PlayerHuskCameraExtension.camera_tree_node = function (self)
	local camera_comp = self._camera_tree_component

	return camera_comp.tree, camera_comp.node
end

PlayerHuskCameraExtension.trigger_camera_shake = function (self, event_name)
	local is_in_first_person_mode = self._first_person_extension:is_in_first_person_mode()

	if is_in_first_person_mode then
		Managers.state.camera:camera_effect_shake_event(event_name)
	end
end

return PlayerHuskCameraExtension
