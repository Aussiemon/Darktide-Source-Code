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
			action_machine_target = action_on_machine
		}

		trigger_extension:setup_from_component(trigger_condition, condition_evaluates_bots, trigger_action, action_parameters, only_once, start_active, volume_type, target_extension_name)

		self._trigger_extension = trigger_extension
	end
end

Trigger.editor_init = function (self, unit)
	self:enable(unit)
end

Trigger.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "c_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'c_volume'"
	end

	return success, error_message
end

Trigger.enable = function (self, unit)
	return
end

Trigger.disable = function (self, unit)
	return
end

Trigger.destroy = function (self, unit)
	return
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
		ui_type = "check_box",
		value = true,
		ui_name = "Start Active"
	},
	trigger_condition = {
		ui_type = "combo_box",
		category = "Condition",
		value = "at_least_one_player_inside",
		ui_name = "Trigger Condition",
		options_keys = {
			"all_alive_players_inside",
			"all_players_inside",
			"all_required_players_in_end_zone",
			"at_least_one_player_inside",
			"only_enter",
			"luggable_inside"
		},
		options_values = {
			"all_alive_players_inside",
			"all_players_inside",
			"all_required_players_in_end_zone",
			"at_least_one_player_inside",
			"only_enter",
			"luggable_inside"
		}
	},
	only_once = {
		ui_type = "combo_box",
		category = "Condition",
		value = "none",
		ui_name = " Condition Behaviour",
		options_keys = {
			"false",
			"only_once_per_unit",
			"only_once_for_all_units"
		},
		options_values = {
			"none",
			"only_once_per_unit",
			"only_once_for_all_units"
		}
	},
	condition_evaluates_bots = {
		ui_type = "check_box",
		value = false,
		ui_name = "Include Bots",
		category = "Condition"
	},
	trigger_action = {
		ui_type = "combo_box",
		category = "Action",
		value = "send_flow",
		ui_name = "Action on Trigger",
		options_keys = {
			"send_flow",
			"set_location",
			"safe_volume",
			"vector_field"
		},
		options_values = {
			"send_flow",
			"set_location",
			"safe_volume",
			"vector_field"
		}
	},
	action_target = {
		ui_type = "combo_box",
		category = "Action",
		value = "player_side",
		ui_name = "Action Target",
		options_keys = {
			"none",
			"player_side",
			"entering_unit",
			"exiting_unit",
			"entering_and_exiting_unit",
			"units_in_volume"
		},
		options_values = {
			"none",
			"player_side",
			"entering_unit",
			"exiting_unit",
			"entering_and_exiting_unit",
			"units_in_volume"
		}
	},
	action_on_machine = {
		ui_type = "combo_box",
		category = "Action",
		value = "server_and_client",
		ui_name = "Where to Activate",
		options_keys = {
			"server",
			"client",
			"server_and_client"
		},
		options_values = {
			"server",
			"client",
			"server_and_client"
		}
	},
	action_location_name = {
		ui_type = "text_box",
		value = "loc_location_name",
		ui_name = "Location Name",
		category = "Action"
	},
	action_location_name_full = {
		ui_type = "text_box",
		value = "loc_location_name_full",
		ui_name = "Location Name (Full)",
		category = "Action"
	},
	action_location_name_short = {
		ui_type = "text_box",
		value = "loc_location_name_short",
		ui_name = "Location Name (Short)",
		category = "Action"
	},
	action_player_side = {
		ui_type = "text_box",
		value = "heroes",
		ui_name = "Player Side",
		category = "Action"
	},
	volume_type = {
		value = "content/volume_types/player_trigger",
		ui_type = "combo_box",
		ui_name = "Volume Type",
		options_keys = {
			"content/volume_types/minion_instakill_no_cost",
			"content/volume_types/nav_tag_volumes/minion_instakill_high_cost",
			"content/volume_types/nav_tag_volumes/bot_impassable",
			"content/volume_types/player_trigger",
			"content/volume_types/player_instakill",
			"content/volume_types/level_prop_trigger",
			"content/volume_types/end_zone",
			"content/volume_types/safe_volume"
		},
		options_values = {
			"content/volume_types/minion_instakill_no_cost",
			"content/volume_types/nav_tag_volumes/minion_instakill_high_cost",
			"content/volume_types/nav_tag_volumes/bot_impassable",
			"content/volume_types/player_trigger",
			"content/volume_types/player_instakill",
			"content/volume_types/level_prop_trigger",
			"content/volume_types/end_zone",
			"content/volume_types/safe_volume"
		}
	},
	target_extension_name = {
		value = "PlayerVolumeEventExtension",
		ui_type = "combo_box",
		ui_name = "Target Extension Name",
		options_keys = {
			"PlayerVolumeEventExtension",
			"MinionVolumeEventExtension",
			"TriggerVolumeEventExtension"
		},
		options_values = {
			"PlayerVolumeEventExtension",
			"MinionVolumeEventExtension",
			"TriggerVolumeEventExtension"
		}
	},
	inputs = {
		activate = {
			accessibility = "public",
			type = "event"
		},
		deactivate = {
			accessibility = "public",
			type = "event"
		},
		reset = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"TriggerExtension"
	}
}

return Trigger
