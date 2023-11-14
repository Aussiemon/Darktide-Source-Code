local dialogue_category_config = {
	default = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {}
	},
	vox_prio_0 = {
		query_score = 100,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			default = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			npc_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			npc_prio_0 = true,
			enemy_vo_prio_1 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	vox_prio_1 = {
		query_score = 0,
		interrupt_self = true,
		mutually_exclusive = false,
		interrupted_by = {
			vox_prio_1 = true
		},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			default = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			vox_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			enemy_vo_prio_1 = true,
			player_prio_0 = false,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_alerts_prio_0 = {
		query_score = 50,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			default = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			npc_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			vox_prio_0 = true,
			enemy_vo_prio_1 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_alerts_prio_1 = {
		query_score = 10,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			player_on_demand_vo = true,
			player_ability_vo = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			npc_prio_1 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true
		}
	},
	player_on_demand_vo = {
		query_score = 0,
		mutually_exclusive = false,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			vox_prio_0 = true,
			npc_prio_1 = true,
			conversations_prio_1 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			npc_prio_0 = true,
			player_prio_1 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	player_ability_vo = {
		query_score = 20,
		interrupt_self = true,
		mutually_exclusive = false,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_prio_1 = true,
			enemy_vo_prio_1 = true,
			npc_prio_1 = true,
			npc_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			enemy_vo_prio_0 = true,
			vox_prio_0 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	player_prio_0 = {
		query_score = 20,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			conversations_prio_1 = true,
			enemy_vo_prio_1 = true,
			conversations_prio_0 = true,
			player_prio_1 = true,
			player_ability_vo = true,
			default = true,
			enemy_vo_prio_0 = true,
			npc_prio_1 = true,
			enemy_high_prio = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			enemy_basic_prio = true,
			enemy_alerts_prio_0 = true
		}
	},
	player_prio_1 = {
		query_score = 15,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_vo_prio_1 = true,
			player_on_demand_vo = true,
			player_ability_vo = true,
			enemy_high_prio = true,
			enemy_vo_prio_0 = true,
			npc_prio_1 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true
		}
	},
	player_prio_2 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			default = true,
			enemy_vo_prio_1 = true,
			enemy_basic_prio = true,
			player_on_demand_vo = true,
			enemy_alerts_prio_1 = true,
			enemy_high_prio = true,
			npc_prio_1 = true,
			player_ability_vo = true,
			enemy_vo_prio_0 = true
		}
	},
	conversations_prio_0 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {
			vox_prio_0 = true
		},
		playable_during_category = {
			default = true,
			enemy_high_prio = true,
			player_ability_vo = true,
			player_prio_1 = true,
			player_on_demand_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			npc_prio_1 = true,
			npc_prio_0 = false,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			enemy_alerts_prio_0 = true
		}
	},
	conversations_prio_1 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {
			vox_prio_0 = true
		},
		playable_during_category = {
			default = true,
			player_ability_vo = true,
			enemy_basic_prio = true,
			player_on_demand_vo = true,
			enemy_high_prio = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			npc_prio_1 = true
		}
	},
	enemy_vo_prio_0 = {
		query_score = 5,
		mutually_exclusive = false,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			npc_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			vox_prio_0 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	enemy_vo_prio_1 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {
			enemy_vo_prio_0 = true
		},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			npc_prio_1 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	minion_vo_prio_1 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			enemy_vo_prio_1 = true,
			npc_prio_1 = true
		}
	},
	chorus_vo_prio_1 = {
		query_score = 0,
		mutually_exclusive = false,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			player_prio_2 = true,
			enemy_basic_prio = true,
			chorus_vo_prio_1 = true,
			enemy_vo_prio_1 = true,
			npc_prio_1 = true
		}
	},
	cutscene = {
		query_score = 0,
		mutually_exclusive = false,
		interrupted_by = {
			cutscene_prio_high = true
		},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			player_on_demand_vo = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			cutscene = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	cutscene_prio_high = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			player_on_demand_vo = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			cutscene = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	npc_prio_0 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {},
		playable_during_category = {
			player_prio_1 = true,
			enemy_high_prio = true,
			conversations_prio_0 = false,
			default = true,
			conversations_prio_1 = true,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = true,
			player_prio_2 = true,
			player_on_demand_vo = true,
			npc_prio_0 = false,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		}
	},
	npc_prio_1 = {
		query_score = 0,
		mutually_exclusive = true,
		interrupted_by = {
			vox_prio_0 = true,
			player_prio_0 = true,
			enemy_alerts_prio_0 = true
		},
		playable_during_category = {
			player_prio_1 = false,
			enemy_high_prio = true,
			conversations_prio_0 = false,
			default = true,
			conversations_prio_1 = false,
			enemy_basic_prio = true,
			player_ability_vo = true,
			enemy_vo_prio_1 = true,
			enemy_vo_prio_0 = true,
			enemy_alerts_prio_1 = false,
			player_prio_2 = true,
			player_on_demand_vo = true,
			npc_prio_0 = false,
			player_prio_0 = false,
			enemy_alerts_prio_0 = false
		}
	},
	playable_during_cinematic = {
		conversations_prio_1 = false,
		enemy_vo_prio_1 = false,
		cutscene = true,
		player_prio_1 = false,
		npc_prio_0 = false,
		default = false,
		player_on_demand_vo = false,
		npc_prio_1 = false,
		enemy_alerts_prio_1 = false,
		player_prio_0 = false,
		vox_prio_0 = false,
		conversations_prio_0 = false,
		cutscene_prio_high = true,
		vox_prio_1 = false,
		player_prio_2 = false,
		enemy_vo_prio_0 = false,
		enemy_alerts_prio_0 = false
	}
}

return settings("dialogue_category_config", dialogue_category_config)
