local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local base_talents = {
	archetype = "none",
	specialization = "none",
	talents = {
		frag_grenade = {
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			name = "frag_grenade",
			display_name = "loc_ability_frag_grenade",
			icon = "content/ui/textures/icons/talents/menu/talent_default",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_ranger_frag_grenade
			}
		},
		base_toughness_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_toughness_node_buff_1",
				identifier = "base_toughness_node_buff"
			}
		},
		base_toughness_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_toughness_node_buff_2",
				identifier = "base_toughness_node_buff"
			}
		},
		base_toughness_node_buff_3 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_toughness_node_buff_3",
				identifier = "base_toughness_node_buff"
			}
		},
		base_toughness_node_buff_4 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_toughness_node_buff_4",
				identifier = "base_toughness_node_buff"
			}
		},
		base_toughness_damage_reduction_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_1",
				identifier = "base_toughness_node_buff"
			}
		},
		base_reload_speed_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_reload_speed_node_buff_1",
				identifier = "base_reload_speed_node_buff"
			}
		},
		base_ranged_damage_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_1",
				identifier = "base_ranged_damage_node_buff"
			}
		},
		base_ranged_damage_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_2",
				identifier = "base_ranged_damage_node_buff"
			}
		},
		base_ranged_damage_node_buff_3 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_3",
				identifier = "base_ranged_damage_node_buff"
			}
		},
		base_ranged_damage_node_buff_4 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_4",
				identifier = "base_ranged_damage_node_buff"
			}
		},
		base_movement_speed_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_movement_speed_node_buff_1",
				identifier = "base_movement_speed_node_buff"
			}
		},
		base_movement_speed_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_movement_speed_node_buff_2",
				identifier = "base_movement_speed_node_buff"
			}
		},
		base_HP_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_HP_node_buff_1",
				identifier = "base_HP_node_buff"
			}
		},
		base_HP_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_HP_node_buff_2",
				identifier = "base_HP_node_buff"
			}
		},
		base_melee_damage_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_melee_damage_node_buff_1",
				identifier = "base_melee_damage_node_buff"
			}
		},
		base_melee_damage_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_melee_damage_node_buff_2",
				identifier = "base_melee_damage_node_buff"
			}
		},
		base_melee_heavy_damage_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_1",
				identifier = "base_melee_heavy_damage_node_buff"
			}
		},
		base_melee_heavy_damage_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_2",
				identifier = "base_melee_heavy_damage_node_buff"
			}
		},
		base_wounds_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_1",
				identifier = "base_wounds_node_buff"
			}
		},
		base_wounds_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_2",
				identifier = "base_wounds_node_buff"
			}
		},
		base_stamina_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_stamina_node_buff_1",
				identifier = "base_stamina_node_buff"
			}
		},
		base_stamina_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_stamina_node_buff_2",
				identifier = "base_stamina_node_buff"
			}
		},
		base_max_warp_charge_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_1",
				identifier = "base_max_warp_charge_node_buff"
			}
		},
		base_max_warp_charge_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_2",
				identifier = "base_max_warp_charge_node_buff"
			}
		},
		base_dodge_count_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_1",
				identifier = "base_dodge_count_node_buff"
			}
		},
		base_dodge_count_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_2",
				identifier = "base_dodge_count_node_buff"
			}
		},
		base_crit_chance_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_crit_chance_node_buff_1",
				identifier = "base_crit_chance_node_buff"
			}
		},
		base_crit_chance_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_crit_chance_node_buff_2",
				identifier = "base_crit_chance_node_buff"
			}
		},
		base_max_ammo_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_ammo_node_buff_1",
				identifier = "base_max_ammo_node_buff"
			}
		},
		base_max_ammo_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_ammo_node_buff_2",
				identifier = "base_max_ammo_node_buff"
			}
		},
		base_coherency_regen_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_1",
				identifier = "coherency_regen_node_buff"
			}
		},
		base_coherency_regen_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_2",
				identifier = "coherency_regen_node_buff"
			}
		}
	}
}

return base_talents
