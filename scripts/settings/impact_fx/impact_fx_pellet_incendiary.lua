local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal = nil
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
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored",
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
				}
			}
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
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
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
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
local prop_armor = table.clone(armored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
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
					"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
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
local default_surface_decal = {
	Vector3(0.2, 0.2, 0.2),
	Vector3(0.2, 0.2, 0.2),
	{
		"content/fx/units/decal_cross_01"
	}
}
local default_surface_fx = {
	sfx = {
		{
			group = "surface_material",
			append_husk_to_event_name = true,
			event = "wwise/events/weapon/play_bullet_hits_gen",
			normal_rotation = true
		}
	},
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/weapons/shotgun/shotgun_incendiary_impact_small"
			}
		}
	}
}
local surface_decal = {
	concrete = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	metal_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	metal_sheet = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	metal_catwalk = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	cloth = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	glass_breakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		}
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01"
			}
		}
	},
	wood_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	},
	wood_plywood = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.6,
				min = 0.3
			},
			units = {
				"content/fx/units/weapons/incendiary_shotgun_scorchmark_small_01"
			}
		}
	}
}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

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
	},
	surface = {
		[hit_types.stop] = default_surface_fx,
		[hit_types.penetration_entry] = default_surface_fx,
		[hit_types.penetration_exit] = nil
	},
	surface_decal = surface_decal
}
