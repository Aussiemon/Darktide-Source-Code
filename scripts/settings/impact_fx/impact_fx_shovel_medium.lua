local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
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
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
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
		}
	},
	blood_ball = {
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball
	}
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_armor_break",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_armor_break",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_armor",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
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
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
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
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_res",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_res",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_combat_weapon_shovel_hit_flat",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_res",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_melee_hits_axe_heavy",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_melee_hits_axe_res",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_shield",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/melee_hits_blunt_no_damage",
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
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
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
local player = nil

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored
	}
}
