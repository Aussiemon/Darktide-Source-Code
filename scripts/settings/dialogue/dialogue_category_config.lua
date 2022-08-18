local dialogue_category_config = {
	default = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {}
	},
	vox_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_alerts_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			player_prio_1 = true,
			enemy_basic_prio = true,
			default = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			vox_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_alerts_prio_1 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_vo_prio_1 = true,
			enemy_high_prio = true,
			player_on_demand_vo = true,
			player_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true
		}
	},
	player_on_demand_vo = {
		mutually_exclusive = false,
		interrupted_by = {
			player_prio_0 = true,
			vox_prio_0 = true,
			conversations_prio_0 = true
		},
		playable_during_category = {
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			conversations_prio_0 = false,
			enemy_basic_prio = true,
			default = true,
			vox_prio_0 = false,
			enemy_high_prio = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_vo_prio_0 = true
		}
	},
	player_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_vo_prio_1 = true,
			conversations_prio_0 = true,
			player_prio_1 = true,
			default = true,
			enemy_vo_prio_0 = true,
			enemy_basic_prio = true,
			enemy_high_prio = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			enemy_alerts_prio_0 = true
		}
	},
	player_prio_1 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			enemy_high_prio = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true
		}
	},
	player_prio_2 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			enemy_alerts_prio_1 = true,
			enemy_basic_prio = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true
		}
	},
	conversations_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {
			vox_prio_0 = true
		},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			player_on_demand_vo = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			enemy_alerts_prio_0 = true
		}
	},
	conversations_prio_1 = {
		mutually_exclusive = true,
		interrupted_by = {
			enemy_alerts_prio_0 = true,
			vox_prio_0 = true
		},
		playable_during_category = {
			default = true,
			enemy_vo_prio_1 = true,
			enemy_high_prio = true,
			enemy_basic_prio = true,
			enemy_vo_prio_0 = true
		}
	},
	enemy_vo_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_vo_prio_1 = {
		mutually_exclusive = true,
		interrupted_by = {
			enemy_vo_prio_0 = true
		},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	cutscene = {
		mutually_exclusive = false,
		interrupted_by = {
			cutscene_prio_high = true
		},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			enemy_basic_prio = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			cutscene = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	cutscene_prio_high = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			enemy_basic_prio = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			cutscene = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	npc_prio_0 = {
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	}
}

return settings("dialogue_category_config", dialogue_category_config)
