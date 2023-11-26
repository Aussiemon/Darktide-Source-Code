-- chunkname: @scripts/settings/impact_fx/impact_fx_rippergun_pellet.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal
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
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
		damage_negated = default_armor_decal
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
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
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
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
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
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored"
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
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored"
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
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored"
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
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored"
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
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
		damage_negated = default_armor_decal
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball
	}
}
local resistant = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
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
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01"
				}
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
				}
			}
		}
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
		damage_negated = default_armor_decal
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
local berserker = table.clone(unarmored)
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01"
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
				event = "wwise/events/weapon/play_bullet_hits_gen",
				normal_rotation = true
			}
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_ogryn_impact_01"
				}
			}
		}
	},
	[hit_types.penetration_entry] = {
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_ogryn_impact_01"
				}
			}
		}
	},
	[hit_types.penetration_exit] = nil
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

local surface_decal = {
	concrete = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_large_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_large_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_large_01"
			}
		}
	},
	metal_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		}
	},
	metal_sheet = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		}
	},
	metal_catwalk = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_medium_01"
			}
		}
	},
	cloth = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.28,
				min = 0.23
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.28,
				min = 0.23
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.28,
				min = 0.23
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01"
			}
		}
	},
	glass_breakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		}
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.2
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_medium_01"
			}
		}
	},
	nurgle_flesh = NO_SURFACE_DECAL,
	wood_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		}
	},
	wood_plywood = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.22,
				min = 0.15
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01"
			}
		}
	},
	nurgle_flesh = NO_SURFACE_DECAL
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
		[armor_types.unarmored] = unarmored
	},
	surface = surface_fx,
	surface_decal = surface_decal
}
