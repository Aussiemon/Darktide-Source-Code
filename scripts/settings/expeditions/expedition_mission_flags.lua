-- chunkname: @scripts/settings/expeditions/expedition_mission_flags.lua

local expedition_mission_flags = {
	generic = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_generic",
		},
	},
	extract_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_extraction_last_location",
		},
	},
	auspex_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_auspex_disabled",
		},
	},
	timer_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_timer_disabled",
		},
	},
	timer_02 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_timer_shorter",
		},
	},
	timer_03 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_timer_longer",
		},
	},
	store_gen = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_unique_inventory_generic",
		},
	},
	store_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_free",
		},
	},
	store_02 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_disabled",
		},
	},
	store_03 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_mines_only",
		},
	},
	store_04 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_valkyrie_only",
		},
	},
	store_05 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_explosives_only",
		},
	},
	store_06 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_store_artillery_only",
		},
	},
	opps_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_opportunities_disabled",
		},
	},
	opps_02 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_opportunities_more",
		},
	},
	locs_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_locations_more",
		},
	},
	locs_02 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_locations_fewer",
		},
	},
	locs_03 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_locations_single",
		},
	},
	theme_01 = {
		ui = {
			display_string = "loc_expeditions_modifier_simple_theme_darkness",
		},
	},
}

return settings("ExpeditionMissionFlags", expedition_mission_flags)
