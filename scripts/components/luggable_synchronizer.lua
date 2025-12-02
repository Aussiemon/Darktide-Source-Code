-- chunkname: @scripts/components/luggable_synchronizer.lua

local LuggableSynchronizer = component("LuggableSynchronizer")

LuggableSynchronizer.init = function (self, unit, is_server)
	self:enable(unit)

	self._is_server = is_server

	local luggable_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	if luggable_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local objective_stages = self:get_data(unit, "objective_stages")
		local auto_start = self:get_data(unit, "automatic_start")
		local shuffle_stages = self:get_data(unit, "shuffle_stages")
		local use_safe_zone = self:get_data(unit, "use_safe_zone")
		local manual_luggable_spawn = self:get_data(unit, "manual_luggable_spawn")
		local max_socket_target = self:get_data(unit, "max_socket_target")
		local keep_unused_sockets = self:get_data(unit, "keep_unused_sockets")
		local luggable_should_respawn = self:get_data(unit, "luggable_should_respawn")
		local luggable_respawn_timer = self:get_data(unit, "luggable_respawn_timer")
		local luggable_reset_timer = self:get_data(unit, "luggable_reset_timer")
		local luggable_consume_timer = self:get_data(unit, "luggable_consume_timer")
		local is_side_mission_synchronizer = self:get_data(unit, "is_side_mission_synchronizer")
		local automatic_start_on_level_spawned = self:get_data(unit, "automatic_start_on_level_spawned")

		luggable_synchronizer_extension:setup_from_component(objective_name, objective_stages, auto_start, shuffle_stages, use_safe_zone, manual_luggable_spawn, max_socket_target, keep_unused_sockets, luggable_should_respawn, luggable_respawn_timer, luggable_reset_timer, luggable_consume_timer, is_side_mission_synchronizer, automatic_start_on_level_spawned)

		self._luggable_synchronizer_extension = luggable_synchronizer_extension
	end
end

LuggableSynchronizer.editor_init = function (self, unit)
	self:enable(unit)
end

LuggableSynchronizer.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "g_luggable_safe_zone") then
		success = false
		error_message = error_message .. "\nMissing volume 'g_luggable_safe_zone'"
	end

	return success, error_message
end

LuggableSynchronizer.enable = function (self, unit)
	return
end

LuggableSynchronizer.disable = function (self, unit)
	return
end

LuggableSynchronizer.destroy = function (self, unit)
	return
end

LuggableSynchronizer.start_luggable_event = function (self, unit)
	if self._luggable_synchronizer_extension then
		self._luggable_synchronizer_extension:start_event()
	end
end

LuggableSynchronizer.spawn_single_luggable = function (self, unit)
	local luggable_synchronizer_extension = self._luggable_synchronizer_extension

	if self._is_server and luggable_synchronizer_extension then
		luggable_synchronizer_extension:spawn_single_luggable()
	end
end

LuggableSynchronizer.hide_all_luggables = function (self, unit)
	local luggable_synchronizer_extension = self._luggable_synchronizer_extension

	if self._is_server and luggable_synchronizer_extension then
		luggable_synchronizer_extension:hide_all_luggables()
	end
end

LuggableSynchronizer.component_data = {
	objective_name = {
		ui_name = "Objective Name",
		ui_type = "text_box",
		value = "default",
	},
	objective_stages = {
		decimals = 0,
		min = 1,
		ui_name = "Objective Stages",
		ui_type = "number",
		value = 1,
	},
	automatic_start = {
		ui_name = "Auto Start On Mission Start",
		ui_type = "check_box",
		value = false,
	},
	shuffle_stages = {
		ui_name = "Shuffle Stages",
		ui_type = "check_box",
		value = false,
	},
	use_safe_zone = {
		ui_name = "Use Safe Zone",
		ui_type = "check_box",
		value = true,
	},
	manual_luggable_spawn = {
		ui_name = "Spawn Luggable Manually",
		ui_type = "check_box",
		value = false,
	},
	max_socket_target = {
		decimals = 0,
		min = 1,
		ui_name = "Max Socket Target",
		ui_type = "number",
		value = 10,
	},
	keep_unused_sockets = {
		ui_name = "Keep Unused Sockets",
		ui_type = "check_box",
		value = false,
	},
	luggable_should_respawn = {
		category = "Spawn settings",
		ui_name = "Luggable should Respawn",
		ui_type = "check_box",
		value = true,
	},
	luggable_respawn_timer = {
		category = "Spawn settings",
		decimals = 1,
		step = 0.1,
		ui_name = "Luggable Respawn Timer (in sec.)",
		ui_type = "number",
		value = 3,
	},
	luggable_reset_timer = {
		category = "Spawn settings",
		decimals = 1,
		step = 0.1,
		ui_name = "Luggable Reset Timer (in sec.)",
		ui_type = "number",
		value = 120,
	},
	luggable_consume_timer = {
		category = "Spawn settings",
		decimals = 1,
		step = 0.1,
		ui_name = "Luggable Consume Timer (in sec.)",
		ui_type = "number",
		value = 3,
	},
	is_side_mission_synchronizer = {
		category = "Side Mission",
		ui_name = "Is Side Mission Synchronizer",
		ui_type = "check_box",
		value = false,
	},
	automatic_start_on_level_spawned = {
		category = "Side Mission",
		ui_name = "Automatic Start On Mission Start",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		start_luggable_event = {
			accessibility = "public",
			type = "event",
		},
		spawn_single_luggable = {
			accessibility = "public",
			type = "event",
		},
		hide_all_luggables = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"LuggableSynchronizerExtension",
	},
}

return LuggableSynchronizer
