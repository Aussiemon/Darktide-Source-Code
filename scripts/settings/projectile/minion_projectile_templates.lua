﻿-- chunkname: @scripts/settings/projectile/minion_projectile_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local damage_types = DamageSettings.damage_types
local projectile_templates = {}

projectile_templates.renegade_grenadier_fire_grenade = {
	impact_damage_type = "minion_grenade",
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical,
		},
		fuse = {
			fuse_time = 1.3,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_grenadier_fire_grenade_impact,
			liquid_area_template = LiquidAreaTemplates.renegade_grenadier_fire_grenade,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenadier_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep",
			},
		},
		impact = {
			sfx = {
				event_name = "wwise/events/weapon/stop_enemy_combat_grenadier_throw_beep",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse",
			},
		},
	},
}
projectile_templates.renegade_captain_frag_grenade = {
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 1.2,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_captain_frag_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenadier_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep",
			},
		},
		impact = {
			sfx = {
				event_name = "wwise/events/weapon/stop_enemy_combat_grenadier_throw_beep",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse",
			},
		},
	},
}
projectile_templates.renegade_frag_grenade = {
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 1.2,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_shocktrooper_frag_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenadier_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep",
			},
		},
		impact = {
			sfx = {
				event_name = "wwise/events/weapon/stop_enemy_combat_grenadier_throw_beep",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse",
			},
		},
	},
}
projectile_templates.renegade_captain_fire_grenade = {
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical,
		},
		fuse = {
			fuse_time = 2,
			explosion_template = ExplosionTemplates.renegade_captain_fire_grenade,
			liquid_area_template = LiquidAreaTemplates.renegade_grenadier_fire_grenade,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenadier_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_throw_beep",
			},
		},
		impact = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_ground_impact",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_fire_grenade_fuse",
			},
		},
	},
}
projectile_templates.cultist_grenadier_grenade = {
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade_cultist_grenadier,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical,
		},
		fuse = {
			fuse_time = 2,
			impact_triggered = true,
			max_lifetime = 12,
			skip_reset = true,
			explosion_template = ExplosionTemplates.cultist_grenadier_gas_grenade_impact,
			liquid_area_template = LiquidAreaTemplates.cultist_grenadier_gas,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_enemy_combat_cultist_grenadier_throw_beep",
			},
		},
		impact = {
			num_impacts = 5,
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_gas_grenade_ground_impact",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_minion_grenadier_gas_grenade_fuse",
			},
		},
	},
}
projectile_templates.twin_grenade = {
	spawn_flow_event = "grenade_thrown",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade_twin,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_grenadier_grenade_blunt,
			damage_type = damage_types.physical,
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
			skip_reset = false,
			explosion_template = ExplosionTemplates.twin_gas_grenade_impact,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_trail",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_twin_captain_throw_beep",
			},
		},
		impact = {
			flow_event = "on_impact",
			num_impacts = 1,
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/enemies/cultist_blight_grenadier/cultist_gas_grenade_smoke",
			},
			sfx = {
				event_name = "wwise/events/weapon/play_minion_gas_proximity_mine_impact_ground",
			},
		},
		fuse = {
			flow_event = "fuse_started",
			sfx = {
				event_name = "wwise/events/weapon/play_minion_gas_proximity_mine_fuse",
			},
		},
	},
}
projectile_templates.renegade_shocktrooper_frag_grenade = {
	spawn_flow_event = "grenade_thrown",
	locomotion_template = ProjectileLocomotionTemplates.minion_grenade,
	damage = {
		fuse = {
			fuse_time = 0,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.renegade_shocktrooper_frag_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
		},
	},
}

return projectile_templates
