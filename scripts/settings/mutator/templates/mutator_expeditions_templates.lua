-- chunkname: @scripts/settings/mutator/templates/mutator_expeditions_templates.lua

local mutator_templates = {
	mutator_exp_dummy_lightning_storm = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		ui = {
			category_name = "loc_expedition_map_enviromental_intel",
			description = "loc_expeditions_modifier_environment_lightning_storm_description",
			display_name = "loc_expeditions_modifier_environment_lightning_storm",
			icon = "content/ui/materials/mission_board/circumstances/expedition_enviromental_intel",
		},
	},
	mutator_exp_dummy_sand_vortex = {
		class = "scripts/managers/mutator/mutators/mutator_minion_extra_spread",
		optional_spread_multiplier = 500,
		ui = {
			category_name = "loc_expedition_map_enviromental_intel",
			description = "loc_expeditions_modifier_environment_sand_vortex_description",
			display_name = "loc_expeditions_modifier_environment_sand_vortex",
			icon = "content/ui/materials/mission_board/circumstances/expedition_enviromental_intel",
		},
	},
	mutator_exp_dummy_nurgle_flies = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		ui = {
			category_name = "loc_expedition_map_enviromental_intel",
			description = "loc_expeditions_modifier_environment_necro_flies_description",
			display_name = "loc_expeditions_modifier_environment_necro_flies",
			icon = "content/ui/materials/mission_board/circumstances/expedition_enviromental_intel",
		},
	},
}

return mutator_templates
