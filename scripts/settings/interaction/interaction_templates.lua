local interaction_templates = {
	default = {
		only_once = false,
		start_anim_event = "arms_down",
		stop_anim_event = "arms_down",
		description = "loc_generic_interaction",
		start_anim_event_3p = "interaction_revive",
		action_text = "loc_generic_interaction",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		stop_anim_event_3p = "interaction_end",
		duration = 3,
		interaction_class_name = "base",
		anim_duration_variable_name_3p = "assist_interaction_duration"
	},
	ammunition = {
		action_text = "loc_action_interaction_pickup",
		ui_interaction_type = "pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/ammunition",
		taggable = true,
		duration = 0,
		interaction_class_name = "ammunition"
	},
	chest = {
		action_text = "loc_action_interaction_open",
		ui_interaction_type = "default",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		taggable = true,
		duration = 0,
		interaction_class_name = "chest"
	},
	decoding = {
		action_text = "loc_action_interaction_decode",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_secondary",
		ui_interaction_type = "mission",
		duration = 0,
		interaction_class_name = "decoding"
	},
	door_control_panel = {
		action_text = "loc_action_interaction_use",
		ui_interaction_type = "default",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		taggable = true,
		duration = 0,
		interaction_class_name = "door_control_panel"
	},
	setup_decoding = {
		wield_slot = "slot_device",
		ui_interaction_type = "mission",
		stop_anim_event = "servo_finished",
		start_anim_event = "servo_start",
		interrupt_anim_event = "servo_interrupt",
		action_text = "loc_action_interaction_plant",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_secondary",
		duration = 3.8,
		interaction_class_name = "setup_decoding"
	},
	grenade = {
		action_text = "loc_action_interaction_pickup",
		ui_interaction_type = "pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/grenade",
		taggable = true,
		duration = 0,
		interaction_class_name = "grenade"
	},
	health = {
		action_text = "loc_action_interaction_use",
		ui_interaction_type = "pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/respawn",
		taggable = true,
		duration = 0,
		interaction_class_name = "health"
	},
	health_station = {
		start_anim_event = "arms_down",
		taggable = true,
		stop_anim_event = "arms_down",
		ui_interaction_type = "point_of_interest",
		start_anim_event_3p = "interaction_revive",
		action_text = "loc_action_interaction_use",
		interaction_icon = "content/ui/materials/hud/interactions/icons/respawn",
		stop_anim_event_3p = "interaction_end",
		duration = 3,
		interaction_class_name = "health_station"
	},
	luggable = {
		action_text = "loc_action_interaction_pickup",
		ui_interaction_type = "pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		taggable = true,
		duration = 0,
		interaction_class_name = "luggable"
	},
	luggable_socket = {
		action_text = "loc_action_interaction_insert",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		ui_interaction_type = "pickup",
		duration = 0,
		interaction_class_name = "luggable_socket"
	},
	mission_board = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/mission_board",
		description = "loc_mission_board_view",
		duration = 0,
		interaction_class_name = "mission_board",
		ui_view_name = "mission_board_view"
	},
	inbox = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/inbox",
		description = "loc_training_ground_view",
		duration = 0,
		interaction_class_name = "inbox",
		ui_view_name = "inbox_view"
	},
	vendor = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/credits_store",
		description = "loc_vendor_view_title",
		duration = 0,
		interaction_class_name = "vendor",
		ui_view_name = "credits_vendor_background_view"
	},
	marks_vendor = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/contracts",
		description = "loc_marks_vendor_view_title",
		duration = 0,
		interaction_class_name = "marks_vendor",
		ui_view_name = "marks_vendor_view"
	},
	training_ground = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/training_grounds",
		description = "loc_training_ground_view",
		duration = 0,
		interaction_class_name = "training_ground",
		ui_view_name = "training_grounds_view"
	},
	contracts = {
		action_text = "loc_action_interaction_view",
		ui_interaction_type = "point_of_interest",
		interaction_icon = "content/ui/materials/hud/interactions/icons/contracts",
		description = "loc_contracts_view",
		duration = 0,
		interaction_class_name = "contracts",
		ui_view_name = "contracts_background_view"
	},
	moveable_platform = {
		action_text = "loc_action_interaction_press",
		ui_interaction_type = "default",
		interaction_icon = "content/ui/materials/hud/interactions/icons/default",
		duration = 0,
		interaction_class_name = "moveable_platform"
	},
	pocketable = {
		action_text = "loc_action_interaction_pickup",
		ui_interaction_type = "pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
		taggable = true,
		duration = 0,
		interaction_class_name = "pocketable"
	},
	pull_up = {
		description = "loc_pull_up",
		ui_interaction_type = "critical",
		stop_anim_event = "arms_down",
		interaction_class_name = "pull_up",
		taggable = true,
		start_anim_event_3p = "interaction_revive",
		action_text = "loc_action_interaction_help",
		interaction_icon = "content/ui/materials/hud/interactions/icons/help",
		stop_anim_event_3p = "interaction_end",
		duration = 3,
		start_anim_event = "arms_down"
	},
	remove_net = {
		description = "loc_remove_net",
		ui_interaction_type = "critical",
		stop_anim_event = "arms_down",
		interaction_class_name = "remove_net",
		vo_event = "start_revive",
		start_anim_event_3p = "interaction_revive",
		taggable = true,
		action_text = "loc_action_interaction_help",
		interaction_icon = "content/ui/materials/hud/interactions/icons/help",
		stop_anim_event_3p = "interaction_end",
		duration = 1,
		start_anim_event = "arms_down"
	},
	revive = {
		description = "loc_revive",
		ui_interaction_type = "critical",
		stop_anim_event = "arms_down",
		only_once = false,
		taggable = false,
		vo_event = "start_revive",
		action_text = "loc_action_interaction_revive",
		interaction_icon = "content/ui/materials/hud/interactions/icons/help",
		stop_anim_event_3p = "interaction_end",
		duration = 3,
		interaction_class_name = "revive",
		anim_duration_variable_name_3p = "assist_interaction_duration",
		start_anim_event_func = function (interactee_unit, interactor_unit)
			local interactee_unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
			local breed = interactee_unit_data_extension:breed()
			local breed_name = breed.name

			if breed_name == "human" then
				return "arms_down", "interaction_revive_human"
			end

			return "arms_down", "interaction_revive_ogryn"
		end
	},
	rescue = {
		description = "loc_rescue",
		ui_interaction_type = "critical",
		stop_anim_event = "arms_down",
		only_once = false,
		taggable = false,
		vo_event = "start_revive",
		action_text = "loc_action_interaction_rescue",
		interaction_icon = "content/ui/materials/hud/interactions/icons/help",
		stop_anim_event_3p = "interaction_end",
		duration = 3,
		interaction_class_name = "rescue",
		anim_duration_variable_name_3p = "assist_interaction_duration",
		start_anim_event_func = function (interactee_unit, interactor_unit)
			local interactee_unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
			local breed = interactee_unit_data_extension:breed()
			local breed_name = breed.name

			if breed_name == "human" then
				return "arms_down", "interaction_revive_human"
			end

			return "arms_down", "interaction_revive_ogryn"
		end
	},
	scanning = {
		description = "loc_scanning",
		ui_interaction_type = "mission",
		stop_anim_event = "scan_end",
		start_anim_event = "scan_start",
		wield_slot = "slot_device",
		interrupt_anim_event = "scan_interrupt",
		action_text = "loc_scanning",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_secondary",
		wwise_player_state = "auspex_scanner",
		duration = 4,
		interaction_class_name = "scanning"
	},
	servo_skull = {
		description = "loc_interactable_servo_skull_scanner",
		ui_interaction_type = "mission",
		stop_anim_event = "arms_down",
		start_anim_event = "arms_down",
		start_anim_event_3p = "interaction_revive",
		action_text = "loc_interactable_servo_skull_scanner_continue",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_secondary",
		stop_anim_event_3p = "interaction_end",
		duration = 1,
		interaction_class_name = "servo_skull",
		anim_duration_variable_name_3p = "assist_interaction_duration"
	},
	servo_skull_activator = {
		description = "loc_interactable_servo_skull_scanner",
		ui_interaction_type = "mission",
		action_text = "loc_interactable_servo_skull_scanner_deploy",
		wield_slot = "slot_device",
		start_anim_event_3p = "interaction_revive",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_secondary",
		stop_anim_event_3p = "interaction_end",
		duration = 1,
		interaction_class_name = "servo_skull_activator"
	},
	side_mission = {
		action_text = "loc_action_interaction_pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/objective_side",
		ui_interaction_type = "pickup",
		duration = 0,
		interaction_class_name = "pickup"
	},
	forge_material = {
		action_text = "loc_action_interaction_pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/environment_generic",
		ui_interaction_type = "pickup",
		duration = 0,
		interaction_class_name = "pickup"
	},
	equip_auspex = {
		action_text = "loc_action_interaction_pickup",
		interaction_icon = "content/ui/materials/hud/interactions/icons/environment_generic",
		ui_interaction_type = "pickup",
		duration = 0,
		interaction_class_name = "equip_auspex"
	}
}

for interaction_type, template in pairs(interaction_templates) do
	template.type = interaction_type
end

return settings("InteractionTemplates", interaction_templates)
