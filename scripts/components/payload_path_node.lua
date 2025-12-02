-- chunkname: @scripts/components/payload_path_node.lua

local PayloadPathNode = component("PayloadPathNode")

PayloadPathNode.init = function (self, unit)
	local payload_path_node_extension = ScriptUnit.fetch_component_extension(unit, "payload_path_system")

	if payload_path_node_extension then
		self._payload_path_node_extension = payload_path_node_extension

		local path_name = self:get_data(unit, "path_name")
		local node_id = self:get_data(unit, "node_id")
		local continue_pathing = self:get_data(unit, "continue_pathing")
		local branching_paths = self:get_data(unit, "branching_paths")
		local reach_event = self:get_data(unit, "reach_event")
		local set_speed_controller = self:get_data(unit, "set_speed_controller")
		local turn_when_reached = self:get_data(unit, "turn_when_reached")
		local movement_lerping_speed_multiplier = self:get_data(unit, "movement_lerping_speed_multiplier")
		local vertical_lerping_speed_multiplier = self:get_data(unit, "vertical_lerping_speed_multiplier")
		local movement_look_rotation_speed_override = self:get_data(unit, "movement_look_rotation_speed_override")
		local turning_speed_override = self:get_data(unit, "turning_speed_override")
		local surface_rotation_easing_function = self:get_data(unit, "surface_rotation_easing_function")

		payload_path_node_extension:setup_from_component(path_name, node_id, continue_pathing, branching_paths, reach_event, set_speed_controller, turn_when_reached, turning_speed_override, movement_lerping_speed_multiplier, vertical_lerping_speed_multiplier, movement_look_rotation_speed_override, surface_rotation_easing_function)
	end
end

PayloadPathNode.allow_payload_to_pass = function (self)
	local payload_path_node_extension = self._payload_path_node_extension

	if payload_path_node_extension then
		payload_path_node_extension:allow_payload_to_pass()
	end
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.8

PayloadPathNode.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._world = Unit.world(unit)
	self._unit = unit

	local text_color = Color.red()
	local text_position = Unit.local_position(unit, 1)
	local translation_matrix = Matrix4x4.from_translation(text_position)

	self._gui = World.create_world_gui(self._world, Matrix4x4.identity(), 1, 1)
	self._debug_text_id = Gui.text_3d(self._gui, "Node", FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)

	Gui.set_visible(self._gui, false)
end

PayloadPathNode.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	Gui.destroy_text_3d(self._gui, self._debug_text_id)
	World.destroy_gui(self._world, self._gui)

	self._debug_text_ids = nil
	self._guis = nil
	self._world = nil
end

PayloadPathNode.editor_validate = function (self, unit)
	return true, ""
end

PayloadPathNode.enable = function (self, unit)
	return
end

PayloadPathNode.disable = function (self, unit)
	return
end

PayloadPathNode.destroy = function (self, unit)
	return
end

PayloadPathNode.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)
end

PayloadPathNode.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable

	self:_editor_debug_draw(self._unit)
end

PayloadPathNode._editor_debug_draw = function (self, unit)
	if self._should_debug_draw then
		local path_name = self:get_data(unit, "path_name")
		local node_id = self:get_data(unit, "node_id")
		local text = path_name .. " - " .. node_id
		local text_position = Unit.world_position(unit, 1) + Vector3.up() * 3.5
		local translation_matrix = Matrix4x4.from_translation(text_position)
		local text_color = Color.deep_sky_blue()

		Gui.destroy_text_3d(self._gui, self._debug_text_id)

		self._debug_text_id = Gui.text_3d(self._gui, text, FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)
	end

	if self._gui then
		Gui.set_visible(self._gui, not not self._should_debug_draw)
	end
end

PayloadPathNode.component_data = {
	path_name = {
		category = "Path",
		ui_name = "Path Name",
		ui_type = "text_box",
		value = "default",
	},
	node_id = {
		category = "Path",
		decimals = 0,
		min = 0,
		step = 1,
		ui_name = "Node Id",
		ui_type = "number",
		value = 0,
	},
	branching_paths = {
		category = "Path",
		ui_name = "Next Path Name",
		ui_type = "text_box_array",
		values = {},
	},
	continue_pathing = {
		category = "Path",
		ui_name = "Continue Pathing",
		ui_type = "check_box",
		value = true,
	},
	movement_lerping_speed_multiplier = {
		category = "Smooth Movement Override",
		decimals = 2,
		ui_name = "Horizontal Movement Lerping Speed",
		ui_type = "number",
		value = 0,
	},
	vertical_lerping_speed_multiplier = {
		category = "Smooth Movement Override",
		decimals = 2,
		ui_name = "Vertical Movement Lerping Speed",
		ui_type = "number",
		value = 0,
	},
	movement_look_rotation_speed_override = {
		category = "Smooth Movement Override",
		decimals = 2,
		ui_name = "Movement Look Rotation Speed",
		ui_type = "number",
		value = 0,
	},
	surface_rotation_easing_function = {
		category = "Movement Override",
		ui_name = "Surface Rotation Easing",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Ease In Sin",
			"Ease In Out Sin",
			"Ease In Cubic",
			"Ease In Out Cubic",
			"Ease Out Exp",
			"Ease Out Bounce",
			"Ease In Out Bounce",
			"Ease In Out Quart",
		},
		options_values = {
			"none",
			"ease_in_sine",
			"ease_sine",
			"easeInCubic",
			"easeCubic",
			"ease_out_exp",
			"ease_out_bounce",
			"ease_in_out_bounce",
			"ease_in_out_quart",
		},
	},
	turn_when_reached = {
		category = "Event",
		ui_name = "Turn Before Continuing",
		ui_type = "check_box",
		value = false,
	},
	turning_speed_override = {
		category = "Event",
		decimals = 2,
		ui_name = "Turning Speed Override",
		ui_type = "number",
		value = 0,
	},
	reach_event = {
		category = "Event",
		ui_name = "Event",
		ui_type = "combo_box",
		value = "continue",
		options_keys = {
			"Continue",
			"Stop",
			"Teleport",
		},
		options_values = {
			"continue",
			"stop",
			"teleport",
		},
	},
	set_speed_controller = {
		category = "Event",
		ui_name = "Set Payload Controller",
		ui_type = "combo_box",
		value = "unchanged",
		options_keys = {
			"Unchanged",
			"Proximity",
			"Main Path",
			"Flow",
			"Max",
		},
		options_values = {
			"unchanged",
			"proximity",
			"main_path",
			"flow",
			"max",
		},
	},
	inputs = {
		allow_payload_to_pass = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"PayloadPathNodeExtension",
	},
}

return PayloadPathNode
