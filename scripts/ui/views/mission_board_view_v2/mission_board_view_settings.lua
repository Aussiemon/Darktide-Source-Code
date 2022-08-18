local MissionBoardViewSettings = {
	difficulty_lookup = {
		"loc_mission_board_danger_lowest",
		"loc_mission_board_danger_low",
		"loc_mission_board_danger_medium",
		"loc_mission_board_danger_high",
		"loc_mission_board_danger_highest"
	},
	mission_lookup = {
		cm_archives = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_archives",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_archives",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_archives"
		},
		cm_habs = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_habs",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_habs",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_habs"
		},
		cm_raid = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_raid",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_raid",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_raid"
		},
		dm_forge = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_forge",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_forge",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_forge"
		},
		dm_propaganda = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_propaganda",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_propaganda",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_propaganda"
		},
		dm_stockpile = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_stockpile",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_stockpile",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_stockpile"
		},
		fm_armoury = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_armoury",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_armoury",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_armoury"
		},
		fm_cargo = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_cargo",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_cargo",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_cargo"
		},
		fm_resurgence = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_resurgence",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_resurgence",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_resurgence"
		},
		hm_cartel = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_cartel",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_cartel",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_cartel"
		},
		hm_complex = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_complex",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_complex",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_complex"
		},
		hm_strain = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_strain",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_strain",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_strain"
		},
		km_enforcer = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_enforcer",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_enforcer",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_enforcer"
		},
		km_heresy = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_heresy",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_heresy",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_heresy"
		},
		km_station = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_station",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_station",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_station"
		},
		lm_cooling = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_cooling",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_cooling",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_cooling"
		},
		lm_rails = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_rails",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_rails",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_rails"
		},
		lm_scavenge = {
			small_texture = "content/ui/materials/mission_board_v2/locations/location_small_scavenge",
			medium_texture = "content/ui/materials/mission_board_v2/locations/location_medium_scavenge",
			big_texture = "content/ui/materials/mission_board_v2/locations/location_big_scavenge"
		},
		default = {
			small_texture = "content/ui/materials/base/ui_default_base",
			medium_texture = "content/ui/materials/base/ui_default_base",
			big_texture = "content/ui/materials/base/ui_default_base"
		}
	},
	objective_lookup = {
		control_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_scanning",
			display_name = "loc_mission_type_control_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_scanning"
		},
		demolition_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_demolition",
			display_name = "loc_mission_type_demolition_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_demolition"
		},
		fortification_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_fortification",
			display_name = "loc_mission_type_fortification_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_fortification"
		},
		decode_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_hacking",
			display_name = "loc_mission_type_decode_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_hacking"
		},
		kill_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_kill",
			display_name = "loc_mission_type_kill_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_kill"
		},
		luggable_objective = {
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_icon_luggable",
			display_name = "loc_mission_type_luggable_objective",
			big_texture = "content/ui/materials/mission_board_v2/mission_types/mission_type_big_luggable"
		},
		default = {
			icon_texture = "content/ui/materials/base/ui_default_base",
			display_name = "default",
			big_texture = "content/ui/materials/base/ui_default_base"
		}
	},
	side_objective_lookup = {
		side_mission_luggables = {
			description = "loc_objective_side_mission_luggables_desc",
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/side_missions/side_objective_icon",
			display_name = "loc_objective_side_mission_luggables_header"
		},
		side_mission_tome = {
			description = "loc_objective_side_mission_tome_desc",
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/side_missions/side_objective_icon",
			display_name = "loc_objective_side_mission_tome_header"
		},
		side_mission_grimoire = {
			description = "loc_objective_side_mission_grimoire_desc",
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/side_missions/side_objective_icon",
			display_name = "loc_objective_side_mission_grimoire_header"
		},
		side_mission_consumable = {
			description = "loc_objective_side_mission_consumable_desc",
			icon_texture = "content/ui/materials/mission_board_v2/mission_types/side_missions/side_objective_icon",
			display_name = "loc_objective_side_mission_consumable_header"
		}
	}
}

return MissionBoardViewSettings
