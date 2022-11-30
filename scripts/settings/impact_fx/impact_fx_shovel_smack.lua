local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball"
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker"
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		shove = {
			{
				event = "wwise/events/weapon/play_player_push_unarmored",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		}
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball
	}
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_reduced_damage",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		shove = {
			{
				event = "wwise/events/weapon/play_player_push_armored",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		}
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		no_damage = blood_ball
	}
}
local super_armor = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_armor",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_hit_indicator_melee_super_armor_no_damage",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_hit_indicator_melee_super_armor_no_damage",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		shove = {
			{
				event = "wwise/events/weapon/play_player_push_super_armor",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		}
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
		damage_reduced = blood_ball,
		dead = blood_ball
	}
}
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_blunt",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				only_1p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_blunt_gen",
				only_1p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		shove = {
			{
				event = "wwise/events/weapon/play_player_push_resilient",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
				}
			},
			{
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			}
		}
	},
	blood_ball = {
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball
	}
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local prop_armor = table.clone(armored)
local player = nil

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
		[armor_types.prop_armor] = prop_armor
	}
}
