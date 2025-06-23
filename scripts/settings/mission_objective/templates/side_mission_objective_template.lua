-- chunkname: @scripts/settings/mission_objective/templates/side_mission_objective_template.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local mission_objective_templates = {
	side_mission = {
		objectives = {
			side_mission_test_one = {
				description = "loc_objective_side_mission_test_one_desc",
				side_objective_type = "collect",
				collect_amount = 3,
				header = "loc_objective_side_mission_test_one_header",
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				is_testable = false,
				mission_objective_type = "side",
				unit_name = "consumable",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side"
			},
			side_mission_consumable = {
				description = "loc_objective_side_mission_consumable_desc",
				side_objective_type = "collect",
				collect_amount = 6,
				header = "loc_objective_side_mission_consumable_header",
				evaluate_at_level_end = true,
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				mission_objective_type = "side",
				is_testable = true,
				unit_name = "consumable",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side"
			},
			side_mission_grimoire = {
				description = "loc_objective_side_mission_grimoire_desc",
				side_objective_type = "collect",
				collect_amount = 2,
				header = "loc_objective_side_mission_grimoire_header",
				evaluate_at_level_end = true,
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				mission_objective_type = "side",
				is_testable = true,
				unit_name = "grimoire",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				proc_event_at_max_progression = proc_events.on_all_grimoires_picked_up
			},
			side_mission_tome = {
				description = "loc_objective_side_mission_tome_desc",
				side_objective_type = "collect",
				collect_amount = 3,
				header = "loc_objective_side_mission_tome_header",
				evaluate_at_level_end = true,
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				mission_objective_type = "side",
				is_testable = true,
				unit_name = "tome",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side"
			},
			side_mission_luggables = {
				description = "loc_objective_side_mission_luggables_desc",
				side_objective_type = "luggable",
				is_testable = false,
				header = "loc_objective_side_mission_luggables_header",
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				mission_objective_type = "side",
				unit_name = "battery_01_luggable",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side"
			},
			side_mission_hack_communications = {
				description = "loc_objective_side_mission_communications_hack_desc",
				side_objective_type = "collect",
				collect_amount = 3,
				header = "loc_objective_side_mission_communications_hack",
				evaluate_at_level_end = true,
				mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_side",
				mission_objective_type = "side",
				is_testable = true,
				unit_name = "communications_hack_device",
				objective_category = "side_mission",
				icon = "content/ui/materials/icons/mission_types/mission_type_side"
			}
		}
	}
}

return mission_objective_templates
