-- chunkname: @scripts/settings/mission_objective/templates/side_mission_objective_template.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local mission_objective_templates = {
	side_mission = {
		objectives = {
			side_mission_test_one = {
				collect_amount = 3,
				description = "loc_objective_side_mission_test_one_desc",
				header = "loc_objective_side_mission_test_one_header",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				is_testable = false,
				mission_objective_type = "side",
				objective_category = "side_mission",
				side_objective_type = "collect",
				unit_name = "consumable",
			},
			side_mission_consumable = {
				collect_amount = 6,
				description = "loc_objective_side_mission_consumable_desc",
				evaluate_at_level_end = true,
				header = "loc_objective_side_mission_consumable_header",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				is_testable = true,
				mission_objective_type = "side",
				objective_category = "side_mission",
				side_objective_type = "collect",
				unit_name = "consumable",
			},
			side_mission_grimoire = {
				collect_amount = 2,
				description = "loc_objective_side_mission_grimoire_desc",
				evaluate_at_level_end = true,
				header = "loc_objective_side_mission_grimoire_header",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				is_testable = true,
				mission_objective_type = "side",
				objective_category = "side_mission",
				side_objective_type = "collect",
				unit_name = "grimoire",
				proc_event_at_max_progression = proc_events.on_all_grimoires_picked_up,
			},
			side_mission_tome = {
				collect_amount = 3,
				description = "loc_objective_side_mission_tome_desc",
				evaluate_at_level_end = true,
				header = "loc_objective_side_mission_tome_header",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				is_testable = true,
				mission_objective_type = "side",
				objective_category = "side_mission",
				side_objective_type = "collect",
				unit_name = "tome",
			},
			side_mission_luggables = {
				description = "loc_objective_side_mission_luggables_desc",
				header = "loc_objective_side_mission_luggables_header",
				icon = "content/ui/materials/icons/mission_types/mission_type_side",
				is_testable = false,
				mission_objective_type = "side",
				objective_category = "side_mission",
				side_objective_type = "luggable",
				unit_name = "battery_01_luggable",
			},
		},
	},
}

return mission_objective_templates
