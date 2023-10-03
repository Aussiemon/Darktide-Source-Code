local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
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
				event = "wwise/events/weapon/play_indicator_death_psyker",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_indicator_death_psyker",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored_reduced",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_death",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
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
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				only_1p = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_armored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_death_psyker",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_indicator_death_psyker",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_hit_indicator_weakspot_melee_sharp",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_damage_negated",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
				append_husk_to_event_name = true
			}
		},
		dead = {
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
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
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/flesh/gib_flesh_bits_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
				}
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
local prop_armor = table.clone(armored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_laser_unarmored",
				append_husk_to_event_name = true
			},
			{
				event = "wwise/events/weapon/play_explosion_force_sml",
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
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
				}
			}
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_01"
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
				event = "wwise/events/weapon/play_explosion_force_sml",
				normal_rotation = true
			}
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_wall_01"
				}
			}
		}
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_explosion_force_sml",
				normal_rotation = true
			}
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/force_staff/force_impact_wall_01"
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
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	metal_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	cloth = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	glass_breakable = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	wood_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		}
	},
	wood_plywood = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
			}
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 1.25,
					y = 1.25
				},
				max = {
					x = 1.25,
					y = 1.25
				}
			},
			units = {
				"content/fx/units/weapons/vfx_psyker_projectile_glow"
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
	surface = surface_fx,
	surface_decal = surface_decal
}
