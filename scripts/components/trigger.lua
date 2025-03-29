-- chunkname: @scripts/components/trigger.lua

local Trigger = component("Trigger")

Trigger.init = function (self, unit)
	self:enable(unit)

	local trigger_extension = ScriptUnit.fetch_component_extension(unit, "trigger_system")

	if trigger_extension then
		local only_once = self:get_data(unit, "only_once")
		local action_on_machine = self:get_data(unit, "action_on_machine")
		local start_active = self:get_data(unit, "start_active")
		local condition_evaluates_bots = self:get_data(unit, "condition_evaluates_bots")
		local trigger_condition = self:get_data(unit, "trigger_condition")
		local trigger_action = self:get_data(unit, "trigger_action")
		local action_target = self:get_data(unit, "action_target")
		local action_location_name_full = self:get_data(unit, "action_location_name_full")
		local action_location_name_short = self:get_data(unit, "action_location_name_short")
		local action_player_side = self:get_data(unit, "action_player_side")
		local volume_type = self:get_data(unit, "volume_type")
		local target_extension_name = self:get_data(unit, "target_extension_name")
		local action_parameters = {
			action_target = action_target,
			action_location_name_full = action_location_name_full,
			action_location_name_short = action_location_name_short,
			action_player_side = action_player_side,
			action_machine_target = action_on_machine,
		}

		trigger_extension:setup_from_component(trigger_condition, condition_evaluates_bots, trigger_action, action_parameters, only_once, start_active, volume_type, target_extension_name)

		self._trigger_extension = trigger_extension
	end
end

Trigger.destroy = function (self, unit)
	return
end

Trigger.enable = function (self, unit)
	return
end

Trigger.disable = function (self, unit)
	return
end

Trigger.editor_init = function (self, unit)
	self:enable(unit)
end

Trigger.editor_validate = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return true, ""
	end

	local success, error_message = true, ""

	if not Unit.has_volume(unit, "c_volume") then
		success, error_message = false, "Missing volume 'c_volume'\n"
	end

	local trigger_condition = self:get_data(unit, "trigger_condition")

	if trigger_condition == "all_players_inside_no_enemies" and not Unit.has_volume(unit, "enemy_check_volume") then
		success, error_message = false, error_message .. "Missing volume 'enemy_check_volume' (used by 'all_players_inside_no_enemies')"
	end

	return success, error_message
end

Trigger.activate = function (self)
	local trigger_extension = self._trigger_extension

	if trigger_extension then
		trigger_extension:set_active(true)
	end
end

Trigger.deactivate = function (self)
	local trigger_extension = self._trigger_extension

	if trigger_extension then
		trigger_extension:set_active(false)
	end
end

Trigger.reset = function (self)
	local trigger_extension = self._trigger_extension

	if trigger_extension then
		trigger_extension:reset()
	end
end

Trigger.component_data = {
	start_active = {
		ui_name = "Start Active",
		ui_type = "check_box",
		value = true,
	},
	trigger_condition = {
		category = "Condition",
		ui_name = "Trigger Condition",
		ui_type = "combo_box",
		value = "at_least_one_player_inside",
		options_keys = {
			"all_alive_players_inside",
			"all_players_inside",
			"all_players_inside_no_enemies",
			"all_required_players_in_end_zone",
			"at_least_half_players_inside",
			"at_least_one_boss_inside",
			"at_least_one_player_inside",
			"only_enter",
			"luggable_inside",
		},
		options_values = {
			"all_alive_players_inside",
			"all_players_inside",
			"all_players_inside_no_enemies",
			"all_required_players_in_end_zone",
			"at_least_half_players_inside",
			"at_least_one_boss_inside",
			"at_least_one_player_inside",
			"only_enter",
			"luggable_inside",
		},
	},
	only_once = {
		category = "Condition",
		ui_name = " Condition Behaviour",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"false",
			"only_once_per_unit",
			"only_once_for_all_units",
		},
		options_values = {
			"none",
			"only_once_per_unit",
			"only_once_for_all_units",
		},
	},
	condition_evaluates_bots = {
		category = "Condition",
		ui_name = "Include Bots",
		ui_type = "check_box",
		value = false,
	},
	trigger_action = {
		category = "Action",
		ui_name = "Action on Trigger",
		ui_type = "combo_box",
		value = "send_flow",
		options_keys = {
			"send_flow",
			"set_location",
			"safe_volume",
			"vector_field",
		},
		options_values = {
			"send_flow",
			"set_location",
			"safe_volume",
			"vector_field",
		},
	},
	action_target = {
		category = "Action",
		ui_name = "Action Target",
		ui_type = "combo_box",
		value = "player_side",
		options_keys = {
			"none",
			"player_side",
			"entering_unit",
			"exiting_unit",
			"entering_and_exiting_unit",
			"units_in_volume",
		},
		options_values = {
			"none",
			"player_side",
			"entering_unit",
			"exiting_unit",
			"entering_and_exiting_unit",
			"units_in_volume",
		},
	},
	action_on_machine = {
		category = "Action",
		ui_name = "Where to Activate",
		ui_type = "combo_box",
		value = "server_and_client",
		options_keys = {
			"server",
			"client",
			"server_and_client",
		},
		options_values = {
			"server",
			"client",
			"server_and_client",
		},
	},
	action_location_name = {
		category = "Action",
		ui_name = "Location Name",
		ui_type = "text_box",
		value = "loc_location_name",
	},
	action_location_name_full = {
		category = "Action",
		ui_name = "Location Name (Full)",
		ui_type = "text_box",
		value = "loc_location_name_full",
	},
	action_location_name_short = {
		category = "Action",
		ui_name = "Location Name (Short)",
		ui_type = "text_box",
		value = "loc_location_name_short",
	},
	action_player_side = {
		category = "Action",
		ui_name = "Player Side",
		ui_type = "text_box",
		value = "heroes",
	},
	volume_type = {
		ui_name = "Volume Type",
		ui_type = "combo_box",
		value = "content/volume_types/player_trigger",
		options_keys = {
			"content/volume_types/minion_trigger",
			"content/volume_types/minion_instakill_no_cost",
			"content/volume_types/nav_tag_volumes/minion_instakill_high_cost",
			"content/volume_types/nav_tag_volumes/bot_impassable",
			"content/volume_types/player_trigger",
			"content/volume_types/player_instakill",
			"content/volume_types/level_prop_trigger",
			"content/volume_types/end_zone",
			"content/volume_types/safe_volume",
		},
		options_values = {
			"content/volume_types/minion_trigger",
			"content/volume_types/minion_instakill_no_cost",
			"content/volume_types/nav_tag_volumes/minion_instakill_high_cost",
			"content/volume_types/nav_tag_volumes/bot_impassable",
			"content/volume_types/player_trigger",
			"content/volume_types/player_instakill",
			"content/volume_types/level_prop_trigger",
			"content/volume_types/end_zone",
			"content/volume_types/safe_volume",
		},
	},
	target_extension_name = {
		ui_name = "Target Extension Name",
		ui_type = "combo_box",
		value = "PlayerVolumeEventExtension",
		options_keys = {
			"PlayerVolumeEventExtension",
			"MinionVolumeEventExtension",
			"TriggerVolumeEventExtension",
		},
		options_values = {
			"PlayerVolumeEventExtension",
			"MinionVolumeEventExtension",
			"TriggerVolumeEventExtension",
		},
	},
	inputs = {
		activate = {
			accessibility = "public",
			type = "event",
		},
		deactivate = {
			accessibility = "public",
			type = "event",
		},
		reset = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"TriggerExtension",
	},
}

return Trigger
