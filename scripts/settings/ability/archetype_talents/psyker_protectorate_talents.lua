local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "psyker",
	specialization = "psyker_3",
	talents = {
		psyker_3_combat = {
			large_icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_combat",
			name = "F-Ability - Channel a Shield that blocks against ranged attacks",
			display_name = "loc_talent_psyker_3_specialization_default",
			description = "loc_talent_psyker_3_specialization_default_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field
			}
		},
		psyker_3_smite = {
			large_icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_combat",
			name = "G-Ability - Chain lightning, Left click for a fast attack, or charge up with Right click for a longer attack",
			display_name = "loc_talent_psyker_3_specialization_default",
			description = "loc_talent_psyker_3_specialization_default_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_chain_lightning
			}
		},
		psyker_3_base_1 = {
			description = "loc_talent_psyker_3_passive_1_description",
			name = "Passive - Kills have a chance to empower your next chain lightning, increasing its damage and make it free",
			display_name = "loc_talent_psyker_3_passive_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_base_1",
			icon_position = {
				8,
				8
			},
			passive = {
				buff_template_name = "psyker_protectorate_base_passive",
				identifier = "psyker_protectorate_base_passive"
			}
		},
		psyker_3_base_2 = {
			description = "loc_talent_psyker_3_passive_2_description",
			name = "Aura - Increased damage",
			display_name = "loc_talent_psyker_3_passive_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_base_1",
			icon_position = {
				7,
				7
			},
			coherency = {
				buff_template_name = "psyker_protectorate_damage_aura",
				identifier = "psyker_protectorate_damage_aura"
			}
		},
		psyker_3_tier_1_name_1 = {
			description = "loc_talent_psyker_3_tier_1_name_1_description",
			name = "Warp charge kills replenish toughness",
			display_name = "loc_talent_psyker_3_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_1_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "psyker_protectorate_warp_kills_replenish_toughness",
				identifier = "mixed"
			}
		},
		psyker_3_tier_1_name_2 = {
			description = "loc_talent_psyker_3_tier_1_name_2_description",
			name = "Chain lightning reduces movement speed of enemies hit",
			display_name = "loc_talent_psyker_3_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_1_name_2",
			icon_position = {
				10,
				1
			},
			passive = {
				buff_template_name = "psyker_protectorate_chain_lightning_reduces_movement_speed",
				identifier = "mixed"
			}
		},
		psyker_3_tier_1_name_3 = {
			description = "loc_talent_psyker_3_tier_1_name_3_description",
			name = "Increased venting speed",
			display_name = "loc_talent_psyker_3_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_1_name_3",
			icon_position = {
				11,
				2
			},
			passive = {
				buff_template_name = "psyker_protectorate_increase_vent_speed",
				identifier = "mixed"
			}
		},
		psyker_3_tier_2_name_1 = {
			description = "loc_talent_psyker_3_tier_2_name_1_description",
			name = "Increase the spread and size of your chain lightning",
			display_name = "loc_talent_psyker_3_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_2_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "psyker_protectorate_increase_chain_lightning_size",
				identifier = "offensive"
			}
		},
		psyker_3_tier_2_name_2 = {
			description = "loc_talent_psyker_3_tier_2_name_2_description",
			name = "You can store up to 3 empowered chain lightnings",
			display_name = "loc_talent_psyker_3_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_2_name_2",
			icon_position = {
				10,
				1
			},
			special_rule = {
				identifier = "offensive",
				special_rule_name = special_rules.psyker_protectorate_increased_chain_lightnings
			}
		},
		psyker_3_tier_2_name_3 = {
			description = "loc_talent_psyker_3_tier_2_name_3_description",
			name = "Your shield deals damage to enemies that pass through it",
			display_name = "loc_talent_psyker_3_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_2_name_3",
			icon_position = {
				11,
				2
			},
			passive = {
				buff_template_name = "psyker_protectorate_units_pass_through_force_field",
				identifier = "offensive"
			}
		},
		psyker_3_tier_3_name_1 = {
			description = "loc_talent_psyker_3_tier_3_name_1_description",
			name = "Reduces the movement speed reduction while channeling your shield",
			display_name = "loc_talent_psyker_3_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_3_name_1",
			icon_position = {
				5,
				1
			},
			passive = {
				buff_template_name = "psyker_protectorate_player_pass_through_force_field",
				identifier = "defensive"
			}
		},
		psyker_3_tier_3_name_2 = {
			description = "loc_talent_psyker_3_tier_3_name_2_description",
			name = "Greatly reduced toughness damage taken",
			display_name = "loc_talent_psyker_3_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_3_name_2",
			icon_position = {
				6,
				1
			},
			passive = {
				buff_template_name = "psyker_protectorate_reduced_toughness_damage_taken",
				identifier = "defensive"
			}
		},
		psyker_3_tier_3_name_3 = {
			description = "loc_talent_psyker_3_tier_3_name_3_description",
			name = "Chain lighting grants a short burst of movement speed",
			display_name = "loc_talent_psyker_3_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_3_name_3",
			icon_position = {
				5,
				2
			},
			passive = {
				buff_template_name = "psyker_protectorate_chain_lightning_increases_movement_speed",
				identifier = "defensive"
			}
		},
		psyker_3_tier_4_name_1 = {
			description = "loc_talent_psyker_3_tier_4_name_1_description",
			name = "Fully restores toughness on allies in coherency, when an ally gets knocked down.",
			display_name = "loc_talent_psyker_3_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_4_name_1",
			icon_position = {
				12,
				4
			},
			passive = {
				buff_template_name = "toughness_when_allied_gets_knocked_down",
				identifier = "coop_aura"
			}
		},
		psyker_3_tier_4_name_2 = {
			description = "loc_talent_psyker_3_tier_4_name_2_description",
			name = "Increased the efficiency of your aura",
			display_name = "loc_talent_psyker_3_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_4_name_2",
			icon_position = {
				13,
				4
			},
			coherency = {
				buff_template_name = "psyker_protectorate_damage_aura_improved",
				identifier = "psyker_protectorate_damage_aura"
			}
		},
		psyker_3_tier_4_name_3 = {
			description = "loc_talent_psyker_3_tier_4_name_3_description",
			name = "Your shield periodically grants toughness to nearby allies",
			display_name = "loc_talent_psyker_3_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_4_name_3",
			icon_position = {
				14,
				4
			},
			passive = {
				buff_template_name = "psyker_protectorate_toughness_regen_at_shield",
				identifier = "coop_aura"
			}
		},
		psyker_3_tier_5_name_1 = {
			description = "loc_talent_psyker_3_tier_5_name_1_description",
			name = "Your empowered chain lightning replenishes toughness for allies in coherency",
			display_name = "loc_talent_psyker_3_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_5_name_1",
			icon_position = {
				2,
				4
			},
			special_rule = {
				identifier = "psyker_protectorate_combat_ability_talent",
				special_rule_name = special_rules.psyker_protectorate_lightning_toughness
			}
		},
		psyker_3_tier_5_name_2 = {
			description = "loc_talent_psyker_3_tier_5_name_2_description",
			name = "Your empowered chain lightning now removes 20% of your current warp charge",
			display_name = "loc_talent_psyker_3_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_5_name_2",
			icon_position = {
				3,
				4
			},
			special_rule = {
				identifier = "psyker_protectorate_combat_ability_talent",
				special_rule_name = special_rules.psyker_protectorate_lightning_warp_charge
			}
		},
		psyker_3_tier_5_name_3 = {
			description = "loc_talent_psyker_3_tier_5_name_3_description",
			name = "Your empowered chain lightning increases the attack speed of all allies in coherency",
			display_name = "loc_talent_psyker_3_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_5_name_3",
			icon_position = {
				4,
				4
			},
			special_rule = {
				identifier = "psyker_protectorate_combat_ability_talent",
				special_rule_name = special_rules.psyker_protectorate_lightning_attack_speed
			}
		},
		psyker_3_tier_6_name_1 = {
			description = "loc_talent_psyker_3_tier_6_name_1_description",
			name = "Increase charges of your combat ability by 1",
			display_name = "loc_talent_psyker_3_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_6_name_1",
			icon_position = {
				5,
				6
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field_increased_charges
			}
		},
		psyker_3_tier_6_name_2 = {
			description = "loc_talent_psyker_3_tier_6_name_2_description",
			name = "Your shield lasts indefinitely, or until you place a new one",
			display_name = "loc_talent_psyker_3_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_6_name_2",
			icon_position = {
				5,
				7
			},
			special_rule = {
				identifier = "psyker_protectorate_combat_ability_talent",
				special_rule_name = special_rules.psyker_protectorate_shield_lasts_indefinetely
			}
		},
		psyker_3_tier_6_name_3 = {
			description = "loc_talent_psyker_3_tier_6_name_3_description",
			name = "Your shield takes the shape of a sphere and forms around you",
			display_name = "loc_talent_psyker_3_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/psyker_3/psyker_3_tier_6_name_3",
			icon_position = {
				6,
				7
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field_dome
			}
		}
	}
}

return archetype_talents
