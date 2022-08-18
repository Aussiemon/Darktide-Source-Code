local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local mission_objective_templates = {
	side_mission = {
		objectives = {
			side_mission_test_one = {
				is_side_mission = true,
				unit_name = "consumable",
				collect_amount = 3,
				header = "loc_objective_side_mission_test_one_header",
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/objectives/bonus",
				mission_objective_type = "side",
				description = "loc_objective_side_mission_test_one_desc"
			},
			side_mission_consumable = {
				is_side_mission = true,
				unit_name = "consumable",
				collect_amount = 6,
				header = "loc_objective_side_mission_consumable_header",
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/objectives/bonus",
				mission_objective_type = "side",
				description = "loc_objective_side_mission_consumable_desc"
			},
			side_mission_grimoire = {
				description = "loc_objective_side_mission_grimoire_desc",
				unit_name = "grimoire",
				collect_amount = 2,
				header = "loc_objective_side_mission_grimoire_header",
				evaluate_at_level_end = true,
				is_side_mission = true,
				mission_objective_type = "side",
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/objectives/bonus",
				proc_event_at_max_progression = proc_events.on_all_grimoires_picked_up
			},
			side_mission_tome = {
				description = "loc_objective_side_mission_tome_desc",
				unit_name = "tome",
				collect_amount = 3,
				header = "loc_objective_side_mission_tome_header",
				evaluate_at_level_end = true,
				is_side_mission = true,
				mission_objective_type = "side",
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/objectives/bonus"
			},
			side_mission_luggables = {
				is_side_mission = true,
				unit_name = "battery_01_luggable",
				side_objective_type = "luggable",
				header = "loc_objective_side_mission_luggables_header",
				description = "loc_objective_side_mission_luggables_desc",
				icon = "content/ui/materials/icons/objectives/bonus",
				mission_objective_type = "side"
			}
		}
	}
}

return mission_objective_templates
