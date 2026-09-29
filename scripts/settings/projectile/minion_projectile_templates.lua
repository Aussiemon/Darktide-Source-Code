-- chunkname: @scripts/settings/projectile/minion_projectile_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local ProjectileSettings = require("scripts/settings/projectile/projectile_settings")
local damage_types = DamageSettings.damage_types
local projectile_types = ProjectileSettings.projectile_types
local projectile_templates = {}

projectile_templates.renegade_grenadier_fire_grenade = {
	impact_damage_type = "minion_grenade",
	item_name = "content/items/weapons/minions/ranged/renegade_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	projectile_type = projectile_types.minion_grenade,
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
				link = true,
				orphaned_policy = "stop",
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
}
projectile_templates.renegade_captain_frag_grenade = {
	item_name = "content/items/weapons/minions/ranged/renegade_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 1.2,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_captain_frag_grenade
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
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
}
projectile_templates.renegade_frag_grenade = {
	item_name = "content/items/weapons/minions/ranged/renegade_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 1.2,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_shocktrooper_frag_grenade
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenadier_trail"
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_frag_grenade_throw_beep"
			}
		},
		impact = {
			sfx = {
				event_name = "wwise/events/weapon/stop_minion_frag_grenade_throw_beep"
			}
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_frag_grenade_fuse"
			}
		}
	}
}
projectile_templates.renegade_captain_fire_grenade = {
	item_name = "content/items/weapons/minions/ranged/renegade_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	projectile_type = projectile_types.minion_grenade,
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
				link = true,
				orphaned_policy = "stop",
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
}
projectile_templates.cultist_grenadier_grenade = {
	item_name = "content/items/weapons/minions/ranged/cultist_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade_cultist_grenadier,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical
		},
		fuse = {
			fuse_time = 2,
			impact_triggered = true,
			max_lifetime = 12,
			skip_fuse_reset = true,
			explosion_template = ExplosionTemplates.cultist_grenadier_gas_grenade_impact,
			liquid_area_template = LiquidAreaTemplates.cultist_grenadier_gas
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
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
}
projectile_templates.twin_grenade = {
	item_name = "content/items/weapons/minions/ranged/twin_grenade",
	spawn_flow_event = "grenade_thrown",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade_twin,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical
		},
		fuse = {
			aoe_threat_duration = 1,
			aoe_threat_size = 3,
			arm_time = 3,
			explosion_z_offset = 0.5,
			fuse_time = 1,
			kill_at_lifetime = 180,
			max_lifetime = 180,
			proximity_radius = 2,
			proximity_triggered = true,
			skip_fuse_reset = false,
			explosion_template = ExplosionTemplates.twin_gas_grenade_impact
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail"
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_twin_captain_throw_beep"
			}
		},
		impact = {
			flow_event = "on_impact",
			num_impacts = 1,
			vfx = {
				link = true,
				orphaned_policy = "stop",
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
}
projectile_templates.renegade_shocktrooper_frag_grenade = {
	item_name = "content/items/weapons/minions/ranged/renegade_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 0,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_shocktrooper_frag_grenade
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail"
			}
		}
	}
}

local function force_ball_attack_type_validation_func(unit, hit_actor, attack_type)
	local destructible_ranged = Unit.actor(unit, "destructible_ranged")
	local destructible = Unit.actor(unit, "destructible")

	if destructible_ranged == hit_actor and attack_type ~= "ranged" then
		return false
	elseif destructible == hit_actor then
		return false
	end

	return true
end

projectile_templates.renegade_wizard_force_ball_nurgle = {
	always_hidden = true,
	item_name = "content/items/weapons/minions/ranged/minion_psyker_projectile",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.renegade_wizard_ball,
	projectile_type = projectile_types.force_staff_ball,
	sticks_to_armor_types = {},
	states = {
		thrown = {
			explosion_template = ExplosionTemplates.renegade_wizard_projectile_nurgle
		},
		rebounding = {
			explosion_template = ExplosionTemplates.renegade_wizard_projectile_nurgle_rebounding
		}
	},
	damage = {
		impact = {
			delete_on_hit_mass = true,
			damage_profile = DamageProfileTemplates.spillway_wizard_force_ball_impact
		},
		fuse = {
			fuse_time = 20
		}
	},
	catapult_data = {
		FORCE = 8,
		RADIUS = 5,
		Z_FORCE = 4,
		CATEGORIES = {
			"heroes"
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_nurgle"
			},
			sfx = {
				looping_event_name = "wwise/events/minions/play_enemy_psyker_nurgle_projectile",
				looping_stop_event_name = "wwise/events/minions/stop_enemy_psyker_nurgle_projectile"
			}
		},
		on_sweep_hit = {
			client_latency_window = 0.2,
			prioritize_client_instantiation = true,
			sfx = {
				event_name = "wwise/events/minions/play_enemy_psyker_projectile_deflected"
			},
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_nurgle_dissipate"
			}
		},
		on_killed = {
			sfx = {
				event_name = "wwise/events/minions/play_enemy_psyker_nurgle_projectile_destroyed"
			},
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_nurgle_dissipate"
			}
		}
	},
	health_component_data = {
		create_game_object = false,
		difficulty_scaling = 1,
		has_health_bar = false,
		hit_mass = 1,
		invulnerable = false,
		max_health = 10,
		regenerate_health = false,
		speed_on_hit = 5,
		unkillable = false,
		breed_white_list = {},
		ignored_colliders = {},
		attack_type_validation_func = force_ball_attack_type_validation_func
	}
}
projectile_templates.renegade_wizard_force_ball_warp = {
	always_hidden = true,
	apply_buff_on_player_impact = true,
	apply_stagger_on_enemy_impact = true,
	buff_name = "spillway_wizard_warp_lightning",
	item_name = "content/items/weapons/minions/ranged/minion_psyker_projectile",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.renegade_wizard_ball,
	projectile_type = projectile_types.force_staff_ball,
	sticks_to_armor_types = {},
	states = {
		thrown = {
			explosion_template = ExplosionTemplates.renegade_wizard_projectile_warp
		},
		rebounding = {
			explosion_template = ExplosionTemplates.renegade_wizard_projectile_warp_rebounding
		}
	},
	damage = {
		impact = {
			delete_on_hit_mass = true,
			damage_profile = DamageProfileTemplates.spillway_wizard_force_ball_impact
		},
		fuse = {
			fuse_time = 20
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_warp"
			},
			sfx = {
				looping_event_name = "wwise/events/minions/play_enemy_psyker_warp_projectile",
				looping_stop_event_name = "wwise/events/minions/stop_enemy_psyker_warp_projectile"
			}
		},
		on_sweep_hit = {
			client_latency_window = 0.2,
			prioritize_client_instantiation = true,
			sfx = {
				event_name = "wwise/events/minions/play_enemy_psyker_projectile_deflected"
			},
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_warp_dissipate"
			}
		},
		on_killed = {
			sfx = {
				event_name = "wwise/events/minions/play_enemy_psyker_warp_projectile_destroyed"
			},
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_warp_dissipate"
			}
		}
	},
	health_component_data = {
		create_game_object = false,
		difficulty_scaling = 1,
		has_health_bar = false,
		hit_mass = 1,
		invulnerable = false,
		max_health = 10,
		regenerate_health = false,
		speed_on_hit = 5,
		unkillable = false,
		breed_white_list = {},
		ignored_colliders = {},
		attack_type_validation_func = force_ball_attack_type_validation_func
	}
}
projectile_templates.mutator_pestilent_bauble_projectile = {
	item_name = "content/items/weapons/minions/ranged/twin_grenade",
	spawn_flow_event = "grenade_thrown",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.mutator_pestilent_bauble,
	projectile_type = projectile_types.minion_grenade,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical
		},
		fuse = {
			aoe_threat_duration = 1,
			aoe_threat_size = 3,
			arm_time = 3,
			explosion_z_offset = 0.5,
			fuse_time = 1,
			kill_at_lifetime = 180,
			max_lifetime = 180,
			proximity_radius = 2,
			proximity_triggered = true,
			skip_fuse_reset = false,
			explosion_template = ExplosionTemplates.twin_gas_grenade_impact
		}
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail"
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_twin_captain_throw_beep"
			}
		},
		impact = {
			flow_event = "on_impact",
			num_impacts = 1,
			vfx = {
				link = true,
				orphaned_policy = "stop",
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
}

return projectile_templates
