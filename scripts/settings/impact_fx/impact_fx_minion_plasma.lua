-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_plasma.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal = {
	extents = {
		min = {
			x = 0.25,
			y = 0.25
		},
		max = {
			x = 0.25,
			y = 0.25
		}
	},
	units = {
		"content/fx/units/weapons/vfx_decal_plasma_scorchmark"
	}
}
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
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_combat_lasgun_ricochet_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball
	}
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_combat_lasgun_ricochet_husk",
				only_3p = true
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
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
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball
	}
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
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
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball
	}
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_plasma",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_plasma",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true
			}
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor"
				}
			}
		}
	},
	linked_decal = {},
	blood_ball = {}
}
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_impact_lasgun_material",
				normal_rotation = true
			}
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		}
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weapon_impact_lasgun_material",
				normal_rotation = true
			}
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"
				}
			}
		}
	},
	[hit_types.penetration_exit] = nil
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

local surface_decal = {}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored
	},
	surface = surface_fx,
	surface_decal = surface_decal
}
