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
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_gen",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_gen",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
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
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_armor_break",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_armor",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_armor",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_no_damage",
				only_1p = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage = {
			{
				reverse = true,
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
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
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_resilient",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_resilient",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_resilient",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_power_sword_hit",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/melee_hits_sword_reduced_damage",
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
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
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
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
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
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/power_sword/power_sword_1h_impact"
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
local prop_armor = table.clone(unarmored)
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
