-- chunkname: @scripts/settings/impact_fx/impact_fx_laser_bfg.lua

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
		"content/fx/units/weapons/vfx_decal_lasgun_scorchmark"
	}
}
local default_shield_block_decal = {
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
		"content/fx/units/weapons/vfx_decal_lasgun_scorchmark"
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
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		}
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			}
		}
	},
	linked_decal = {},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		dead = blood_ball
	}
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_reduced",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
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
local super_armor = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_death",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_reduced",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
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
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
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
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_sparks_armor_player"
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
		shield_blocked = default_shield_block_decal
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball
	}
}
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = false
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_ranged_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
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
					"content/fx/particles/impacts/armor_ricochet"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			}
		}
	},
	linked_decal = {},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball
	}
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
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
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/super_armor_lasgun"
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
				event = "wwise/events/weapon/play_bullet_hits_lasgun",
				normal_rotation = true
			}
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
				}
			}
		}
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_lasgun",
				normal_rotation = true
			}
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/lasgun/lasgun_impact_surface_bfg_player"
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
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		}
	},
	metal_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		}
	},
	cloth = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2
				},
				max = {
					x = 0.2,
					y = 0.2
				}
			},
			units = {
				"content/fx/units/weapons/lasgun_concrete_small_01",
				"content/fx/units/weapons/lasgun_concrete_medium_01",
				"content/fx/units/weapons/lasgun_concrete_large_01"
			}
		}
	},
	nurgle_flesh = NO_SURFACE_DECAL
}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

return {
	test = "charged",
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
