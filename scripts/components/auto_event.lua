-- chunkname: @scripts/components/auto_event.lua

local AutoEvent = component("AutoEvent")

AutoEvent.init = function (self, unit, is_server, nav_world)
	self._is_server = is_server

	if not is_server then
		return
	end

	self._unit = unit

	local start_enabled = self:get_data(unit, "start_enabled")

	if start_enabled then
		self._enabled = true
	end
end

AutoEvent.destroy = function (self)
	return
end

AutoEvent.enable = function (self, unit)
	return
end

AutoEvent.disable = function (self, unit)
	return
end

AutoEvent.start_auto_event = function (self, unit)
	local is_server = self._is_server

	if not is_server then
		return
	end

	unit = self._unit

	local position = Unit.world_position(unit, 1) or Vector3(0, 0, 0)
	local auto_event_context = {
		worldposition = position,
		intial_cooldown_multiplier_value = self:get_data(unit, "inital_cooldown_type"),
		size = self:get_data(unit, "size"),
		composition = self:get_data(unit, "composition"),
		node_id = math.uuid(),
	}

	self._auto_event_id = Managers.state.pacing:request_auto_event(auto_event_context)
end

AutoEvent.stop_auto_event = function (self, unit)
	local is_server = self._is_server

	if not is_server then
		return
	end

	Managers.state.pacing:request_auto_event_end(self._auto_event_id)
end

AutoEvent.get_auto_event_data = function (self)
	if not self._is_server then
		return
	end

	return Managers.state.pacing:get_auto_event_data(self._auto_event_id)
end

AutoEvent.kill_remaining_enemies = function (self)
	if not self._is_server then
		return
	end

	return Managers.state.pacing:kill_remaining_enemies(self._auto_event_id)
end

AutoEvent.highlight_remaining_enemies = function (self)
	if not self._is_server then
		return
	end

	return Managers.state.pacing:highlight_remaining_enemies(self._auto_event_id)
end

AutoEvent.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)

	return true
end

AutoEvent.editor_validate = function (self, unit)
	return true, ""
end

AutoEvent.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world
	local gui = self._gui

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)
	end

	if self._section_debug_text_id then
		Gui.destroy_text_3d(gui, self._section_debug_text_id)
	end

	World.destroy_gui(world, gui)

	self._line_object = nil
	self._world = nil
end

AutoEvent.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

AutoEvent.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

AutoEvent.component_data = {
	start_enabled = {
		ui_name = "start_enabled",
		ui_type = "check_box",
		value = true,
	},
	size = {
		ui_name = "Size",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"default",
			"small",
			"large",
		},
		options_values = {
			"default",
			"small",
			"large",
		},
	},
	composition = {
		ui_name = "composition",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"default",
			"melee",
			"ranged",
		},
		options_values = {
			"default",
			"melee",
			"ranged",
		},
	},
	inital_cooldown_type = {
		ui_name = "Inital Cooldown Type",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"default",
			"extraction",
			"safe_room",
		},
		options_values = {
			"default",
			"extraction",
			"safe_room",
		},
	},
	inputs = {
		start_auto_event = {
			accessibility = "public",
			type = "event",
		},
		stop_auto_event = {
			accessibility = "public",
			type = "event",
		},
	},
}

return AutoEvent
