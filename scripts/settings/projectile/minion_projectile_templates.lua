local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local damage_types = DamageSettings.damage_types
local projectile_templates = {
	renegade_grenadier_fire_grenade = {
		spawn_flow_event = "grenade_thrown",
		impact_damage_type = "minion_grenade",
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
				damage_type = damage_types.physical
			},
			fuse = {
				fuse_time = 1.3,
				impact_triggered = true,
				explosion_template = ExplosionTemplates.renegade_grenadier_fire_grenade_impact,
				liquid_area_template = LiquidAreaTemplates.renegade_grenadier_fire_grenade
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "stop",
					link = true,
					particle_name = "content/fx/particles/weapons/grenades/grenadier_trail"
				},
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep"
				}
			},
			impact = {
				sfx = {
					event_name = "wwise/events/weapon/stop_enemy_combat_grenadier_throw_beep"
				}
			},
			fuse = {
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse"
				}
			}
		}
	},
	renegade_captain_frag_grenade = {
		spawn_flow_event = "grenade_thrown",
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
		damage = {
			fuse = {
				fuse_time = 2.2,
				explosion_template = ExplosionTemplates.renegade_captain_frag_grenade
			},
			impact = {
				damage_profile = DamageProfileTemplates.frag_grenade_impact,
				damage_type = damage_types.grenade_frag
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "destroy",
					link = true,
					particle_name = "content/fx/particles/weapons/grenades/grenade_trail"
				}
			}
		}
	},
	renegade_captain_fire_grenade = {
		spawn_flow_event = "grenade_thrown",
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
				damage_type = damage_types.physical
			},
			fuse = {
				fuse_time = 2,
				explosion_template = ExplosionTemplates.renegade_captain_fire_grenade,
				liquid_area_template = LiquidAreaTemplates.renegade_grenadier_fire_grenade
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "stop",
					link = true,
					particle_name = "content/fx/particles/weapons/grenades/grenadier_trail"
				},
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep"
				}
			},
			impact = {
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_ground_impact"
				}
			},
			fuse = {
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse"
				}
			}
		}
	},
	cultist_grenadier_grenade = {
		spawn_flow_event = "grenade_thrown",
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade_cultist_grenadier,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
				damage_type = damage_types.physical
			},
			fuse = {
				fuse_time = 2,
				skip_reset = true,
				max_lifetime = 12,
				impact_triggered = true,
				explosion_template = ExplosionTemplates.cultist_grenadier_gas_grenade_impact,
				liquid_area_template = LiquidAreaTemplates.cultist_grenadier_gas
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "stop",
					link = true,
					particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail"
				},
				sfx = {
					event_name = "wwise/events/weapon/play_enemy_combat_cultist_grenadier_throw_beep"
				}
			},
			impact = {
				num_impacts = 5,
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_gas_grenade_ground_impact"
				}
			},
			fuse = {
				sfx = {
					event_name = "wwise/events/weapon/play_minion_grenadier_gas_grenade_fuse"
				}
			}
		}
	},
	twin_grenade = {
		spawn_flow_event = "grenade_thrown",
		uses_script_components = true,
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade_twin,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
				damage_type = damage_types.physical
			},
			fuse = {
				proximity_triggered = true,
				fuse_time = 1,
				skip_reset = false,
				arm_time = 3,
				kill_at_lifetime = 180,
				explosion_z_offset = 0.5,
				aoe_threat_size = 3,
				proximity_radius = 2,
				kill_at_z_position = -200,
				max_lifetime = 180,
				aoe_threat_duration = 1,
				explosion_template = ExplosionTemplates.twin_gas_grenade_impact
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "stop",
					link = true,
					particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail"
				},
				sfx = {
					event_name = "wwise/events/weapon/play_minion_twin_captain_throw_beep"
				}
			},
			impact = {
				num_impacts = 1,
				flow_event = "on_impact",
				vfx = {
					orphaned_policy = "stop",
					link = true,
					particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_smoke"
				},
				sfx = {
					event_name = "wwise/events/weapon/play_minion_gas_proximity_mine_impact_ground"
				}
			},
			fuse = {
				flow_event = "fuse_started",
				sfx = {
					event_name = "wwise/events/weapon/play_minion_gas_proximity_mine_fuse"
				}
			}
		}
	},
	renegade_shocktrooper_frag_grenade = {
		spawn_flow_event = "grenade_thrown",
		locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
		damage = {
			fuse = {
				fuse_time = 0,
				impact_triggered = true,
				explosion_template = ExplosionTemplates.renegade_shocktrooper_frag_grenade
			},
			impact = {
				damage_profile = DamageProfileTemplates.frag_grenade_impact,
				damage_type = damage_types.grenade_frag
			}
		},
		effects = {
			spawn = {
				vfx = {
					orphaned_policy = "destroy",
					link = true,
					particle_name = "content/fx/particles/weapons/grenades/grenade_trail"
				}
			}
		}
	}
}

return projectile_templates
