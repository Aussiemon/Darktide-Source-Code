-- chunkname: @scripts/extension_systems/payload_path/payload_path_node_extension.lua

local PayloadPathNodeExtension = class("PayloadPathNodeExtension")

PayloadPathNodeExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._path_name = "default"
	self._node_id = 0
	self._continue_pathing = true
	self._branching_paths = nil
	self._reach_event = "continue"
	self._reach_event_override = nil
	self._set_speed_controller = "unchanged"
	self._allow_payload_to_pass = false
end

PayloadPathNodeExtension.setup_from_component = function (self, path_name, node_id, continue_pathing, branching_paths, reach_event, set_speed_controller, turn_when_reached, turning_speed_override, movement_horizontal_lerping_speed_multiplier_override, movement_vertical_lerping_speed_multiplier_override, movement_look_rotation_speed_override, surface_rotation_easing_function)
	self._path_name = path_name
	self._node_id = node_id
	self._continue_pathing = continue_pathing
	self._branching_paths = branching_paths
	self._reach_event = reach_event
	self._set_speed_controller = set_speed_controller
	self._turn_when_reached = turn_when_reached
	self._movement_horizontal_lerping_speed_override = movement_horizontal_lerping_speed_multiplier_override
	self._movement_vertical_lerping_speed_override = movement_vertical_lerping_speed_multiplier_override
	self._movement_look_rotation_speed_override = movement_look_rotation_speed_override
	self._turning_speed_override = turning_speed_override
	self._surface_rotation_easing_function = surface_rotation_easing_function
end

PayloadPathNodeExtension.hot_join_sync = function (self, unit, sender, channel)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)

	if self._allow_payload_to_pass then
		RPC.rpc_payload_path_node_allow_payload_to_pass(channel, unit_level_index)
	end
end

PayloadPathNodeExtension.allow_payload_to_pass = function (self)
	self._reach_event_override = "continue"
	self._allow_payload_to_pass = true

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_payload_path_node_allow_payload_to_pass", unit_level_index)
	end
end

PayloadPathNodeExtension.rpc_payload_path_node_allow_payload_to_pass = function (self)
	self:allow_payload_to_pass()
end

PayloadPathNodeExtension.unit = function (self)
	return self._unit
end

PayloadPathNodeExtension.path_name = function (self)
	return self._path_name
end

PayloadPathNodeExtension.node_id = function (self)
	return self._node_id
end

PayloadPathNodeExtension.continue_pathing = function (self)
	return self._continue_pathing
end

PayloadPathNodeExtension.branching_paths = function (self)
	return self._branching_paths
end

PayloadPathNodeExtension.reach_event = function (self)
	return self._reach_event_override or self._reach_event
end

PayloadPathNodeExtension.set_speed_controller = function (self)
	return self._set_speed_controller
end

PayloadPathNodeExtension.turn_when_reached = function (self)
	return self._turn_when_reached
end

PayloadPathNodeExtension.turning_speed_override = function (self)
	return self._turning_speed_override > 0 and self._turning_speed_override or nil
end

PayloadPathNodeExtension.horizontal_movement_lerping_speed_multiplier_override = function (self)
	return self._movement_horizontal_lerping_speed_override > 0 and self._movement_horizontal_lerping_speed_override or nil
end

PayloadPathNodeExtension.vertical_movement_lerping_speed_multiplier_override = function (self)
	return self._movement_vertical_lerping_speed_override > 0 and self._movement_vertical_lerping_speed_override or nil
end

PayloadPathNodeExtension.movement_look_rotation_speed_override = function (self)
	return self._movement_look_rotation_speed_override > 0 and self._movement_look_rotation_speed_override or nil
end

PayloadPathNodeExtension.surface_rotation_easing_function = function (self)
	return self._surface_rotation_easing_function and math[self._surface_rotation_easing_function] or nil
end

PayloadPathNodeExtension.location = function (self)
	return POSITION_LOOKUP[self._unit]
end

PayloadPathNodeExtension.rotation = function (self)
	return Unit.local_rotation(self._unit, 1)
end

return PayloadPathNodeExtension
