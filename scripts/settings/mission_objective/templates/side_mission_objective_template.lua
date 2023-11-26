-- chunkname: @scripts/settings/mission_objective/templates/side_mission_objective_template.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local mission_objective_templates = {
	side_mission = {
		objectives = {
			side_mission_test_one = {
				description = "loc_objective_side_mission_test_one_desc",
				unit_name = "consumable",
				collect_amount = 3,
				header = "loc_objective_side_mission_test_one_header",
				is_side_mission = true,
				is_testable = false,
				mission_objective_type = "side",
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/mission_types/mission_type_08"
			},
			side_mission_consumable = {
				description = "loc_objective_side_mission_consumable_desc",
				unit_name = "consumable",
				collect_amount = 6,
				header = "loc_objective_side_mission_consumable_header",
				evaluate_at_level_end = true,
				is_side_mission = true,
				mission_objective_type = "side",
				is_testable = true,
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/mission_types/mission_type_08"
			},
			side_mission_grimoire = {
				description = "loc_objective_side_mission_grimoire_desc",
				unit_name = "grimoire",
				collect_amount = 2,
				header = "loc_objective_side_mission_grimoire_header",
				evaluate_at_level_end = true,
				is_side_mission = true,
				mission_objective_type = "side",
				is_testable = true,
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/mission_types/mission_type_08",
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
				is_testable = true,
				side_objective_type = "collect",
				icon = "content/ui/materials/icons/mission_types/mission_type_08"
			},
			side_mission_luggables = {
				is_side_mission = true,
				unit_name = "battery_01_luggable",
				side_objective_type = "luggable",
				header = "loc_objective_side_mission_luggables_header",
				description = "loc_objective_side_mission_luggables_desc",
				icon = "content/ui/materials/icons/mission_types/mission_type_08",
				mission_objective_type = "side",
				is_testable = false
			}
		}
	}
}

return mission_objective_templates
