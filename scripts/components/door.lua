-- chunkname: @scripts/components/door.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local Door = component("Door")

Door.init = function (self, unit, is_server)
	self:enable(unit)

	self._is_server = is_server

	local door_extension = ScriptUnit.fetch_component_extension(unit, "door_system")

	if door_extension then
		local door_type = self:get_data(unit, "type")
		local start_state = self:get_data(unit, "start_state")
		local open_time = self:get_data(unit, "open_time")
		local close_time = self:get_data(unit, "close_time")
		local allow_closing = self:get_data(unit, "allow_closing")
		local self_closing_time = self:get_data(unit, "self_closing_time")
		local blocked_time = self:get_data(unit, "blocked_time")
		local open_type = self:get_data(unit, "open_type")
		local control_panel_props = self:_get_non_empty_control_panels(unit)
		local control_panels_active = self:get_data(unit, "control_panels_active")
		local ignore_broadphase = self:get_data(unit, "ignore_broadphase")

		if open_type ~= "open_only" and open_type == "close_only" then
			-- Nothing
		end

		door_extension:setup_from_component(door_type, start_state, open_time, close_time, allow_closing, self_closing_time, blocked_time, open_type, control_panel_props, control_panels_active, ignore_broadphase)

		self._door_extension = door_extension
	end
end

Door._toggle = function (self, state, interactor_unit)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		if door_extension:can_open(interactor_unit) then
			door_extension:open(state, interactor_unit)
		elseif door_extension:can_close() then
			door_extension:close()
		end
	end
end

Door._open = function (self, state, interactor_unit)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		if door_extension:can_open() then
			door_extension:open(state, interactor_unit)
		elseif not door_extension:started() then
			door_extension:set_start_state(state)
		end
	end
end

Door._close = function (self)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		if not door_extension:started() then
			door_extension:set_start_state("closed")
		elseif door_extension:can_close() then
			door_extension:close()
		end
	end
end

Door._teleport_bots = function (self)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		door_extension:teleport_bots()
	end
end

Door.editor_init = function (self, unit)
	self:enable(unit)

	if not rawget(_G, "LevelEditor") and not rawget(_G, "UnitEditor") then
		return
	end

	self._control_panel_units = {}

	self:_spawn_control_panels(unit)

	local door_type = self:get_data(unit, "type")
	local start_state = self:get_data(unit, "start_state")

	if LevelEditor then
		require("core/editor_slave/settings")

		local DoorSettings = require("scripts/settings/components/door_settings")

		self:_editor_set_open_or_closed(unit, door_type, start_state, DoorSettings)
	end
end

Door.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_animation_state_machine(unit) then
		success = false
		error_message = error_message .. "\nMissing unit animation state machine"
	end

	return success, error_message
end

Door._editor_set_open_or_closed = function (self, unit, door_type, start_state, DoorSettings)
	local TYPES = DoorSettings.TYPES
	local STATES = DoorSettings.STATES

	if door_type == TYPES.two_states then
		if start_state == STATES.open_fwd or start_state == STATES.open_bwd then
			start_state = STATES.open
		end
	elseif door_type == TYPES.three_states and start_state == STATES.open then
		start_state = STATES.open_fwd
	end

	local anim = DoorSettings.anim[start_state]
	local variable_index = Unit.animation_find_variable(unit, "anim_duration")

	Unit.animation_set_variable(unit, variable_index, 0.1)
	Unit.animation_event(unit, anim.event)
end

Door.editor_destroy = function (self, unit)
	self:_unspawn_control_panels(unit)
end

Door.editor_reset_physics = function (self, unit)
	local actors = Unit.get_node_actors(unit, 1, true, false)

	if actors ~= nil then
		for _, actor in ipairs(actors) do
			if Actor.is_kinematic(Unit.actor(unit, actor)) then
				Unit.destroy_actor(unit, actor)
			end
		end
	end
end

Door._spawn_control_panels = function (self, unit)
	local control_panel_props = self:_get_non_empty_control_panels(unit)
	local world = Unit.world(unit)

	for i = 1, #control_panel_props do
		local control_panel_prop = control_panel_props[i]
		local node_name = "ap_control_panel_" .. tostring(i)

		if not Unit.has_node(unit, node_name) then
			Log.error("DoorExtension", "[_spawn_control_panel] Missing node '%s' to spawn control panel '%s'.", node_name, control_panel_prop)

			return
		end

		local props_settings = LevelProps[control_panel_prop]
		local control_panel_unit_name = props_settings.unit_name
		local control_panel_node = Unit.node(unit, node_name)
		local control_panel_unit = World.spawn_unit_ex(world, control_panel_unit_name, nil, Unit.world_pose(unit, control_panel_node))

		self._control_panel_units[#self._control_panel_units + 1] = control_panel_unit

		World.link_unit(world, control_panel_unit, 1, unit, control_panel_node)
	end
end

Door._unspawn_control_panels = function (self, unit)
	local world = Unit.world(unit)
	local control_panel_units = self._control_panel_units

	for i = 1, #control_panel_units do
		local control_panel_unit = control_panel_units[i]

		World.unlink_unit(world, control_panel_unit)
		World.destroy_unit(world, control_panel_unit)

		control_panel_units[i] = nil
	end
end

Door.editor_property_changed = function (self, unit)
	self:_unspawn_control_panels(unit)
	self:_spawn_control_panels(unit)
end

Door.enable = function (self, unit)
	return
end

Door.disable = function (self, unit)
	return
end

Door.destroy = function (self, unit)
	return
end

Door.events.interaction_success = function (self, door_type, interactor_unit)
	self:_toggle(nil, interactor_unit)
end

Door.open = function (self)
	self:_open("open")
end

Door.toggle_open = function (self)
	self:_toggle("open")
end

Door.open_fwd = function (self)
	self:_open("open_fwd")
end

Door.toggle_fwd = function (self)
	self:_toggle("open_fwd")
end

Door.open_bwd = function (self)
	self:_open("open_bwd")
end

Door.toggle_bwd = function (self)
	self:_toggle("open_bwd")
end

Door.close = function (self)
	self:_close()
end

Door.teleport_bots = function (self)
	self:_teleport_bots()
end

Door.activate_control_panels = function (self)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		door_extension:set_control_panel_active(true)
	end
end

Door.deactivate_control_panels = function (self)
	local door_extension = self._door_extension

	if self._is_server and door_extension then
		door_extension:set_control_panel_active(false)
	end
end

Door._get_non_empty_control_panels = function (self, unit)
	local control_panel_props = self:get_data(unit, "control_panel_props")
	local cleared_list = {}

	for i = 1, #control_panel_props do
		local control_panel_prop = control_panel_props[i]

		if control_panel_prop ~= "empty" then
			cleared_list[#cleared_list + 1] = control_panel_prop
		end
	end

	return cleared_list
end

Door.component_data = {
	type = {
		value = "two_states",
		ui_type = "combo_box",
		ui_name = "Type",
		options_keys = {
			"2 States ('Open, Close')",
			"3 States (Open Forward/Backward, Close)"
		},
		options_values = {
			"two_states",
			"three_states"
		}
	},
	open_type = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Open Type",
		options_keys = {
			"Normal",
			"Open Only",
			"Close Only"
		},
		options_values = {
			"none",
			"open_only",
			"close_only"
		}
	},
	start_state = {
		value = "closed",
		ui_type = "combo_box",
		ui_name = "Start State",
		options_keys = {
			"Open",
			"Open Forward",
			"Open Backwards",
			"Closed"
		},
		options_values = {
			"open",
			"open_fwd",
			"open_bwd",
			"closed"
		}
	},
	open_time = {
		ui_type = "number",
		min = 0.1,
		decimals = 2,
		category = "Animation",
		value = 1,
		ui_name = "Open Animation Time (in sec.)",
		step = 0.01
	},
	close_time = {
		ui_type = "number",
		min = 0.1,
		decimals = 2,
		category = "Animation",
		value = 1,
		ui_name = "Close Animation Time (in sec.)",
		step = 0.01
	},
	allow_closing = {
		ui_type = "check_box",
		value = true,
		ui_name = "Allow closing"
	},
	self_closing_time = {
		ui_type = "number",
		min = 0,
		decimals = 2,
		value = 0,
		ui_name = "Time for door to self close (in sec.)",
		step = 0.01
	},
	blocked_time = {
		ui_type = "slider",
		min = 0,
		decimals = 2,
		category = "Nav",
		value = 0.5,
		max = 1,
		ui_name = "Blocked Time (in %)",
		step = 0.01
	},
	control_panel_props = {
		category = "Control Panels",
		ui_type = "combo_box_array",
		size = 0,
		ui_name = "Control Panel Props (see 'settings/level_prop')",
		values = {},
		options_keys = {
			"Empty",
			"Control Panel 01",
			"Control Panel scan airlock 01"
		},
		options_values = {
			"empty",
			"door_controlpanel_01",
			"control_panel_scan_airlock_01"
		}
	},
	control_panels_active = {
		ui_type = "check_box",
		value = true,
		ui_name = "Control Panels Active",
		category = "Control Panels"
	},
	ignore_broadphase = {
		ui_type = "check_box",
		value = false,
		ui_name = "Ignore Broadphase System"
	},
	inputs = {
		open = {
			accessibility = "public",
			type = "event"
		},
		toggle_open = {
			accessibility = "public",
			type = "event"
		},
		open_fwd = {
			accessibility = "public",
			type = "event"
		},
		toggle_fwd = {
			accessibility = "public",
			type = "event"
		},
		open_bwd = {
			accessibility = "public",
			type = "event"
		},
		toggle_bwd = {
			accessibility = "public",
			type = "event"
		},
		close = {
			accessibility = "public",
			type = "event"
		},
		activate_control_panels = {
			accessibility = "public",
			type = "event"
		},
		deactivate_control_panels = {
			accessibility = "public",
			type = "event"
		},
		teleport_bots = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"DoorExtension"
	}
}

return Door
