-- chunkname: @scripts/components/payload.lua

local Payload = component("Payload")

Payload.init = function (self, unit)
	local payload_extension = ScriptUnit.fetch_component_extension(unit, "payload_system")

	if payload_extension then
		local path_name = self:get_data(unit, "path_name")
		local movement_type = self:get_data(unit, "movement_type")
		local rotation_type_in_movement = self:get_data(unit, "rotation_type_in_movement")
		local rotation_speed_in_movement = self:get_data(unit, "rotation_speed_in_movement")
		local speed_controller = self:get_data(unit, "speed_controller")
		local speed_passive = self:get_data(unit, "speed_passive")
		local speed_active = self:get_data(unit, "speed_active")
		local speed_additional_player = self:get_data(unit, "speed_additional_player")
		local acceleration = self:get_data(unit, "acceleration")
		local deceleration = self:get_data(unit, "deceleration")
		local floor_normal_adjustment_speed = self:get_data(unit, "floor_normal_adjustment_speed")
		local normal_adjustment_square_half_extents = self:get_data(unit, "normal_adjustment_square_half_extents")
		local turn_type = self:get_data(unit, "turn_type")
		local turning_speed = self:get_data(unit, "turning_speed")
		local time_for_turning_pi = self:get_data(unit, "time_for_turning_pi")
		local optional_aiming_node_name = self:get_data(unit, "optional_aiming_node_name")
		local optional_aiming_constraint_target = self:get_data(unit, "optional_aiming_constraint_target")
		local proximity_distance = self:get_data(unit, "proximity_distance")
		local player_push_power = self:get_data(unit, "player_push_power")
		local player_push_distance = self:get_data(unit, "player_push_distance")
		local random_spawn_radius = self:get_data(unit, "random_spawn_radius")

		payload_extension:setup_from_component(path_name, movement_type, rotation_type_in_movement, rotation_speed_in_movement, speed_controller, speed_passive, speed_active, speed_additional_player, acceleration, deceleration, floor_normal_adjustment_speed, normal_adjustment_square_half_extents, turn_type, turning_speed, time_for_turning_pi, optional_aiming_node_name, optional_aiming_constraint_target, proximity_distance, player_push_power, player_push_distance, random_spawn_radius)

		self._payload_extension = payload_extension
	end

	self:enable(unit)
end

Payload.editor_init = function (self, unit)
	return
end

Payload.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

Payload.enable = function (self, unit)
	return
end

Payload.disable = function (self, unit)
	return
end

Payload.destroy = function (self, unit)
	return
end

Payload.payload_path = function (self)
	local payload_extension = self._payload_extension

	if payload_extension then
		payload_extension:start_pathing(true)
	end
end

Payload.payload_continue_path = function (self)
	local payload_extension = self._payload_extension

	if payload_extension then
		payload_extension:start_pathing(false)
	end
end

Payload.payload_start = function (self)
	local payload_extension = self._payload_extension

	if payload_extension then
		payload_extension:start_moving()
	end
end

Payload.component_data = {
	path_name = {
		ui_name = "Path Name",
		ui_type = "text_box",
		value = "default",
	},
	movement_type = {
		category = "Movement",
		ui_name = "Movement Type",
		ui_type = "combo_box",
		value = "smooth",
		options_keys = {
			"Linear",
			"Smooth",
		},
		options_values = {
			"linear",
			"smooth",
		},
	},
	rotation_type_in_movement = {
		category = "Movement",
		ui_name = "Rotation in Movement",
		ui_type = "combo_box",
		value = "constant",
		options_keys = {
			"Constant",
			"Lerp",
		},
		options_values = {
			"constant",
			"lerp",
		},
	},
	rotation_speed_in_movement = {
		category = "Movement",
		decimals = 2,
		ui_name = "Rotation Speed in Movement",
		ui_type = "number",
		value = 1,
	},
	speed_controller = {
		category = "Movement",
		ui_name = "Speed Controller",
		ui_type = "combo_box",
		value = "proximity",
		options_keys = {
			"Proximity",
			"Main Path",
			"Flow",
			"Max",
		},
		options_values = {
			"proximity",
			"main_path",
			"flow",
			"max",
		},
	},
	speed_passive = {
		category = "Movement",
		ui_name = "Passive Speed",
		ui_type = "number",
		value = 0,
	},
	speed_active = {
		category = "Movement",
		ui_name = "Active Speed",
		ui_type = "number",
		value = 2,
	},
	speed_additional_player = {
		category = "Movement",
		ui_name = "Additional Player Speed",
		ui_type = "number",
		value = 0.25,
	},
	acceleration = {
		category = "Movement",
		ui_name = "Acceleration",
		ui_type = "number",
		value = 1,
	},
	deceleration = {
		category = "Movement",
		ui_name = "Deceleration",
		ui_type = "number",
		value = 1,
	},
	floor_normal_adjustment_speed = {
		category = "Smooth Movement",
		decimals = 2,
		ui_name = "Floor Normal Adjustment Speed",
		ui_type = "number",
		value = 1,
	},
	normal_adjustment_square_half_extents = {
		category = "Smooth Movement",
		ui_name = "Normal Adjustment Square Half Extents",
		ui_type = "vector",
		value = Vector3Box(0.75, 1, 0),
	},
	turn_type = {
		category = "Turning In Place",
		ui_name = "Turn Type",
		ui_type = "combo_box",
		value = "constant",
		options_keys = {
			"Constant",
			"Lerp",
			"Timed Bezier",
		},
		options_values = {
			"constant",
			"lerp",
			"timed_bezier",
		},
	},
	turning_speed = {
		category = "Turning In Place",
		decimals = 2,
		ui_name = "Turning Speed",
		ui_type = "number",
		value = 1,
	},
	time_for_turning_pi = {
		category = "Turning In Place",
		decimals = 2,
		ui_name = "Timed Bezier: Time for 180º turn",
		ui_type = "number",
		value = 15,
	},
	optional_aiming_node_name = {
		category = "Optional - Aim Target",
		ui_name = "Node Name",
		ui_type = "text_box",
		value = "",
	},
	optional_aiming_constraint_target = {
		category = "Optional - Aim Target",
		ui_name = "Aim Constraint Target",
		ui_type = "text_box",
		value = "",
	},
	proximity_distance = {
		category = "Proximity",
		ui_name = "Proximity Distance",
		ui_type = "number",
		value = 12,
	},
	player_push_power = {
		category = "Push",
		ui_name = "Player Push Power",
		ui_type = "number",
		value = 3,
	},
	player_push_distance = {
		category = "Push",
		ui_name = "Player Push Distance",
		ui_type = "number",
		value = 2,
	},
	random_spawn_radius = {
		category = "Spawn",
		ui_name = "Random Spawn Radius",
		ui_type = "number",
		value = 0,
	},
	inputs = {
		payload_path = {
			accessibility = "public",
			type = "event",
		},
		payload_continue_path = {
			accessibility = "public",
			type = "event",
		},
		payload_start = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"PayloadExtension",
	},
}

return Payload
