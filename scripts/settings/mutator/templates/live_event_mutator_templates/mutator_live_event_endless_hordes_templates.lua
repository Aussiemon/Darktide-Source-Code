-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_endless_hordes_templates.lua

local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local mutator_templates = {
	mutator_no_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0,
			horde_timer_modifier = 99999,
			num_boss_patrol_override = 0,
			num_captains_override = 0,
			num_encampments_override = 0,
			num_monsters_override = 0,
			num_witches_override = 0,
			specials_timer_modifier = 99999,
			override_num_roamer_range = {
				0,
				0,
			},
		},
	},
	mutator_live_event_endless_hordes = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_endless_hordes",
			start_module_on_activate = true,
			settings = {},
		},
	},
}

return mutator_templates
