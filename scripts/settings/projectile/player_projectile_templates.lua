-- chunkname: @scripts/settings/projectile/player_projectile_templates.lua

local AimPlacement = require("scripts/extension_systems/weapon/actions/utilities/aim_placement")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DeployableLocomotion = require("scripts/extension_systems/locomotion/utilities/deployable_locomotion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local ProjectileSettings = require("scripts/settings/projectile/projectile_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local projectile_types = ProjectileSettings.projectile_types
local special_rules = SpecialRulesSettings.special_rules
local adamant_talent_settings = TalentSettings.adamant
local projectile_templates = {}

projectile_templates.ogryn_gauntlet_grenade = {
	item_name = "content/items/weapons/player/ranged/bullets/grenade_thumper_frag",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_gauntlet_grenade,
	projectile_type = projectile_types.weapon_grenade,
	damage = {
		fuse = {
			fuse_time = 1,
			explosion_template = ExplosionTemplates.default_gauntlet_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.default_gauntlet_bfg_ignore_hitzone,
			damage_type = damage_types.grenade_frag,
			explosion_template = ExplosionTemplates.default_gauntlet_grenade,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}

local function _ogryn_thumper_sticks_to_check(projectile_unit, hit_unit, hit_zone_name)
	local attacking_unit = AttackingUnitResolver.resolve(projectile_unit)
	local buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")
	local has_keyword = buff_extension and buff_extension:has_keyword(BuffSettings.keywords.sticky_projectiles)

	return has_keyword
end

projectile_templates.ogryn_thumper_grenade_hip_fire = {
	item_name = "content/items/weapons/player/ranged/bullets/grenade_thumper_frag",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_thumper_grenade,
	projectile_type = projectile_types.weapon_grenade,
	sticks_to_tags = {
		monster = true,
		ogryn = true,
	},
	sticks_to_func = _ogryn_thumper_sticks_to_check,
	damage = {
		fuse = {
			fuse_time = 1.5,
			impact_triggered = true,
			min_lifetime = 0.5,
			explosion_template = ExplosionTemplates.ogryn_thumper_grenade_instant,
		},
		impact = {
			first_impact_activated = true,
			damage_profile = DamageProfileTemplates.thumper_grenade_impact,
			damage_type = damage_types.ogryn_bullet_bounce,
			explosion_template = ExplosionTemplates.ogryn_thumper_grenade_instant,
			speed_to_charge_settings = {
				charge_max = 1,
				charge_min = 0,
				max_speed = 60,
			},
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/rifles/ogryn_thumper/ogryn_thumper_projectile_smoke_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_thumper_grenade_aim = {
	item_name = "content/items/weapons/player/ranged/bullets/grenade_thumper_frag",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_thumper_grenade_aimed,
	projectile_type = projectile_types.weapon_grenade,
	sticks_to_tags = {
		monster = true,
		ogryn = true,
	},
	sticks_to_func = _ogryn_thumper_sticks_to_check,
	damage = {
		fuse = {
			fuse_time = 1.5,
			impact_triggered = true,
			min_lifetime = 0.5,
			explosion_template = ExplosionTemplates.ogryn_thumper_grenade_instant,
		},
		impact = {
			first_impact_activated = true,
			damage_profile = DamageProfileTemplates.thumper_grenade_impact,
			damage_type = damage_types.ogryn_bullet_bounce,
			explosion_template = ExplosionTemplates.ogryn_thumper_grenade_instant,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/rifles/ogryn_thumper/ogryn_thumper_projectile_smoke_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_grenade_frag = {
	item_name = "content/items/weapons/player/grenade_ogryn_frag",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_frag_grenade,
	projectile_type = projectile_types.ogryn_grenade,
	damage = {
		fuse = {
			fuse_time = 2,
			impact_fuse_time = 0.9,
			impact_triggered = true,
			min_lifetime = 0.6,
			explosion_template = ExplosionTemplates.ogryn_grenade_frag,
		},
		impact = {
			damage_profile = DamageProfileTemplates.ogryn_grenade_impact,
			damage_type = damage_types.grenade_frag_ogryn,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.broker_missile = {
	item_name = "content/items/weapons/player/ranged/bullets/broker_missile",
	locomotion_template = ProjectileLocomotionTemplates.broker_missile,
	projectile_type = projectile_types.weapon_grenade,
	damage = {
		fuse = {
			fuse_time = 1.5,
			impact_fuse_time = 0,
			explosion_template = ExplosionTemplates.broker_missile_launcher,
		},
		impact = {
			delete_on_hit_mass = true,
			damage_profile = DamageProfileTemplates.broker_missile_launcher_impact,
			damage_type = damage_types.grenade_frag_ogryn,
			explosion_template = ExplosionTemplates.broker_missile_launcher,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/broker_boom_bringer_projectile_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_outlaw_missile_launcher_projectile_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_outlaw_missile_launcher_projectile_loop",
			},
		},
	},
}
projectile_templates.frag_grenade = {
	item_name = "content/items/weapons/player/grenade_frag",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 1.7,
			explosion_template = ExplosionTemplates.frag_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.fire_grenade = {
	item_name = "content/items/weapons/player/grenade_fire",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 1.7,
			explosion_template = ExplosionTemplates.fire_grenade,
			liquid_area_template = LiquidAreaTemplates.fire_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.fire_grenade_impact,
			damage_type = damage_types.grenade_fire,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.broker_tox_grenade = {
	item_name = "content/items/weapons/player/grenade_tox",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 5,
			impact_fuse_time = 1.5,
			impact_triggered = true,
			kill_at_lifetime = 5,
			skip_fuse_reset = true,
			explosion_template = ExplosionTemplates.broker_tox_grenade,
			liquid_area_template = LiquidAreaTemplates.broker_tox_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.fire_grenade_impact,
			damage_type = damage_types.grenade_fire,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/chem_grenade/chem_grenade_gas_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.krak_grenade = {
	item_name = "content/items/weapons/player/grenade_krak",
	locomotion_template = ProjectileLocomotionTemplates.krak_grenade,
	projectile_type = projectile_types.player_grenade,
	sticks_to_armor_types = {
		[armor_types.resistant] = true,
		[armor_types.armored] = true,
		[armor_types.super_armor] = true,
	},
	damage = {
		fuse = {
			fuse_time = 1,
			impact_triggered = true,
			max_lifetime = 2,
			sticky_fuse_time = 1,
			explosion_template = ExplosionTemplates.krak_grenade,
			default_explosion_normal = Vector3Box(0, 0, -1),
		},
		impact = {
			damage_profile = DamageProfileTemplates.krak_grenade_impact,
			damage_type = damage_types.grenade_krak,
		},
	},
	split_settings = {
		split_angle = math.pi * 0.05,
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/krak_grenade/krak_grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
		target_aquired = {
			sfx = {
				event_name = "wwise/events/weapon/play_krak_detected",
			},
		},
		stick = {
			sfx = {
				event_name = "wwise/events/weapon/play_krak_stuck",
			},
		},
		build_up_start = {
			sfx = {
				event_name = "wwise/events/weapon/play_krak_build_up",
			},
		},
		build_up_stop = {
			sfx = {
				event_name = "wwise/events/weapon/stop_krak_build_up",
			},
		},
		fuse = {
			sfx = {
				event_name = "wwise/events/weapon/play_krak_build_up",
			},
		},
	},
}
projectile_templates.shock_grenade = {
	item_name = "content/items/weapons/player/grenade_shock",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 1.5,
			explosion_template = ExplosionTemplates.shock_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_grenade_box_cluster_grenade = {
	item_name = "content/items/weapons/player/grenade_frag",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 2,
			skip_fuse_reset = true,
			explosion_template = ExplosionTemplates.ogryn_box_cluster_frag,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.grenade_frag_ogryn,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_grenade_box = {
	item_name = "content/items/weapons/player/grenade_box_ogryn",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_grenade_box,
	projectile_type = projectile_types.ogryn_box,
	damage = {
		fuse = {
			fuse_time = 2,
			impact_triggered = true,
		},
		impact = {
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.ogryn_grenade_box_impact,
			damage_type = damage_types.ogryn_grenade_box,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_grenade_friend_rock = {
	item_name = "content/items/weapons/player/grenade_ogryn_friend_rock",
	play_vce = true,
	locomotion_template = ProjectileLocomotionTemplates.ogryn_friendly_rock,
	projectile_type = projectile_types.ogryn_rock,
	damage = {
		fuse = {
			fuse_time = 2,
			impact_triggered = true,
		},
		impact = {
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.ogryn_friendly_rock_impact,
			damage_type = damage_types.ogryn_friend_rock,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.zealot_throwing_knives = {
	item_name = "content/items/weapons/player/zealot_throwing_knives",
	play_vce = true,
	locomotion_template = ProjectileLocomotionTemplates.zealot_throwing_knife_projectile,
	projectile_type = projectile_types.throwing_knife,
	sticks_to_armor_types = {},
	damage = {
		use_suppression = true,
		impact = {
			delete_on_hit_mass = true,
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.zealot_throwing_knives,
			damage_type = damage_types.throwing_knife_zealot,
			suppression_settings = {
				distance = 5,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 5,
			},
		},
		fuse = {
			fuse_time = 1.5,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_zealot_throw_knife_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_zealot_throw_knife_loop",
			},
		},
	},
}
projectile_templates.psyker_throwing_knives = {
	item_name = "content/items/weapons/player/psyker_throwing_knives",
	play_vce = true,
	psyker_smite = true,
	locomotion_template = ProjectileLocomotionTemplates.psyker_throwing_knife_projectile,
	projectile_type = projectile_types.throwing_knife,
	sticks_to_armor_types = {},
	damage = {
		use_suppression = true,
		impact = {
			delete_on_hit_mass = true,
			damage_profile = DamageProfileTemplates.psyker_throwing_knives,
			damage_type = damage_types.throwing_knife,
			suppression_settings = {
				distance = 5,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 5,
			},
		},
		fuse = {
			fuse_time = 1.5,
			impact_triggered = true,
			kill_at_lifetime = 2.5,
			skip_fuse_reset = true,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/abilities/psyker_throwing_knife_trail",
				particle_name_critical_strike = "content/fx/particles/abilities/psyker_throwing_knife_trail_critical_strike",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_throw_knife_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_throw_knife_loop",
			},
		},
	},
	unit_rotation_offset = QuaternionBox(0.5, 0, 0, -0.5),
}
projectile_templates.psyker_throwing_knives_piercing = table.clone_instance(projectile_templates.psyker_throwing_knives)
projectile_templates.psyker_throwing_knives_piercing.damage.impact.damage_profile = DamageProfileTemplates.psyker_throwing_knives_pierce
projectile_templates.psyker_throwing_knives_aimed = table.clone_instance(projectile_templates.psyker_throwing_knives)
projectile_templates.psyker_throwing_knives_aimed.damage.fuse.kill_at_lifetime = 3
projectile_templates.psyker_throwing_knives_aimed.damage.impact.damage_profile = DamageProfileTemplates.psyker_throwing_knives_aimed
projectile_templates.psyker_throwing_knives_aimed.locomotion_template = ProjectileLocomotionTemplates.psyker_throwing_knife_projectile_aimed
projectile_templates.psyker_throwing_knives_aimed_piercing = table.clone_instance(projectile_templates.psyker_throwing_knives)
projectile_templates.psyker_throwing_knives_aimed_piercing.damage.fuse.kill_at_lifetime = 3.5
projectile_templates.psyker_throwing_knives_aimed_piercing.damage.impact.damage_profile = DamageProfileTemplates.psyker_throwing_knives_aimed_pierce
projectile_templates.psyker_throwing_knives_aimed_piercing.locomotion_template = ProjectileLocomotionTemplates.psyker_throwing_knife_projectile_aimed
projectile_templates.dual_shivs_p1_throwing_knives = {
	item_name = "content/items/weapons/player/shivs_throwing_knives",
	locomotion_template = ProjectileLocomotionTemplates.dual_shivs_throwing_knife_projectile,
	projectile_type = projectile_types.throwing_knife,
	sticks_to_armor_types = {},
	damage = {
		use_suppression = true,
		impact = {
			delete_on_hit_mass = true,
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.dual_shivs_throwing_knives,
			damage_type = damage_types.throwing_knife_zealot,
			suppression_settings = {
				distance = 5,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 5,
			},
		},
		fuse = {
			fuse_time = 1,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail_toxin_broker",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_zealot_throw_knife_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_zealot_throw_knife_loop",
			},
		},
	},
}
projectile_templates.force_staff_ball = {
	always_hidden = true,
	item_name = "content/items/weapons/player/ranged/bullets/force_staff_projectile_01",
	locomotion_template = ProjectileLocomotionTemplates.force_staff_ball,
	projectile_type = projectile_types.force_staff_ball,
	sticks_to_armor_types = {},
	damage = {
		use_suppression = true,
		impact = {
			delete_on_hit_mass = true,
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.force_staff_ball,
			damage_type = damage_types.force_staff_single_target,
			suppression_settings = {
				distance = 5,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 5,
			},
		},
		fuse = {
			fuse_time = 5,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/abilities/psyker_smite_projectile_01",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_psyker_smite_fire_projectile",
				looping_stop_event_name = "wwise/events/weapon/stop_psyker_smite_fire_projectile",
			},
		},
	},
}
projectile_templates.force_staff_ball_heavy = {
	always_hidden = true,
	item_name = "content/items/weapons/player/ranged/bullets/force_staff_projectile_01",
	locomotion_template = ProjectileLocomotionTemplates.force_staff_ball_heavy,
	projectile_type = projectile_types.force_staff_ball,
	sticks_to_armor_types = {},
	damage = {
		impact = {
			delete_on_hit_mass = true,
			damage_profile = DamageProfileTemplates.default_force_staff_bfg,
			damage_type = damage_types.force_staff_bfg,
			suppression_settings = {
				distance = 5,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 5,
			},
			explosion_template = ExplosionTemplates.force_staff_p4_demolition,
		},
		fuse = {
			fuse_time = 2,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				min_charge_level = 0.35,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/bfg_staff/psyker_bfg_projectile_01",
				use_charge_level = true,
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_psyker_smite_fire_projectile",
				looping_stop_event_name = "wwise/events/weapon/stop_psyker_smite_fire_projectile",
			},
		},
	},
}
projectile_templates.smoke_grenade = {
	item_name = "content/items/weapons/player/grenade_smoke",
	locomotion_template = ProjectileLocomotionTemplates.grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 1.5,
			explosion_template = ExplosionTemplates.smoke_grenade,
			spawn_unit = {
				unit_name = "content/characters/player/human/attachments_combat/smoke_fog/smoke_fog_volume",
				unit_template = "smoke_fog",
				unit_template_parameters = {
					block_line_of_sight = true,
					duration = 15,
					in_fog_buff_template_name = "in_smoke_fog",
					inner_radius = 4.5,
					leaving_fog_buff_template_name = "left_smoke_fog",
					outer_radius = 5.5,
				},
			},
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	split_settings = {
		split_angle = math.pi * 0.1,
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "stop",
				particle_name = "content/fx/particles/weapons/grenades/smoke_grenade/smoke_grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_grenade_projectile_loop_smoke",
				looping_stop_event_name = "wwise/events/weapon/stop_grenade_projectile_loop_smoke",
			},
		},
	},
}
projectile_templates.ogryn_grenade_box_cluster = {
	item_name = "content/items/weapons/player/grenade_box_ogryn_cluster",
	locomotion_template = ProjectileLocomotionTemplates.ogryn_grenade_box,
	projectile_type = projectile_types.ogryn_box,
	damage = {
		fuse = {
			fuse_time = 2,
			impact_triggered = true,
		},
		impact = {
			delete_on_hit_mass = true,
			delete_on_impact = true,
			damage_profile = DamageProfileTemplates.ogryn_grenade_box_cluster_impact,
			damage_type = damage_types.ogryn_grenade_box,
			cluster = {
				item = "content/items/weapons/player/grenade_frag",
				number = 6,
				start_fuse_time = 0.8,
				stat_buff = "ogryn_grenade_box_cluster_amount",
				fuse_time_steps = {
					max = 0.8,
					min = 0.4,
				},
				start_speed = {
					max = 8,
					min = 6,
				},
				randomized_angular_velocity = math.pi / 10,
				projectile_template = projectile_templates.ogryn_grenade_box_cluster_grenade,
				randomized_settings = {
					buff_keyword = "ogryn_box_of_surprise",
					chance = 1,
					list = {
						{
							projectile_template = projectile_templates.ogryn_grenade_box_cluster_grenade,
						},
						{
							projectile_template = projectile_templates.krak_grenade,
						},
						{
							projectile_template = projectile_templates.fire_grenade,
						},
						{
							projectile_template = projectile_templates.ogryn_grenade_frag,
						},
						{
							projectile_template = projectile_templates.smoke_grenade,
						},
						{
							projectile_template = projectile_templates.shock_grenade,
						},
					},
				},
			},
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.ogryn_grenade_box.damage.impact.conditional_cluster = projectile_templates.ogryn_grenade_box_cluster.damage.impact.cluster
projectile_templates.luggable = {
	locomotion_template = ProjectileLocomotionTemplates.luggable_battery,
	projectile_type = projectile_types.luggable,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.luggable_battery,
		},
	},
}
projectile_templates.adamant_grenade = {
	item_name = "content/items/weapons/player/grenade_adamant",
	locomotion_template = ProjectileLocomotionTemplates.adamant_grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 2,
			impact_fuse_time = 0,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.adamant_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.adamant_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}
projectile_templates.shock_mine = {
	item_name = "content/items/weapons/player/mine_shock",
	unit_template_name = "item_deployable_projectile",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.shock_mine,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = adamant_talent_settings.blitz_ability.shock_mine.duration,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.shock_mine,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
	deployable = {
		relation_init_data = {
			enemy = {
				proximity_radius = 3,
				stickiness_limit = 5,
				stickiness_time = 1,
				logic = {
					{
						class_name = "ProximityShockMine",
						use_as_job = true,
						init_data = {
							arming_time = 1,
							buff_to_add = "shock_mine_interval",
							life_time = 150,
							num_targets_per_trigger = 3,
							trigger_interval = 0.2,
						},
					},
				},
			},
		},
		deploy_func = function (world, physics_world, unit)
			local job_class = ScriptUnit.extension(unit, "proximity_system")

			Managers.state.unit_job:register_job(unit, job_class, true)

			local can_place, _, _, placed_on_unit = AimPlacement.from_unit(physics_world, unit)

			if can_place and placed_on_unit then
				DeployableLocomotion.set_placed_on_unit(world, unit, placed_on_unit)
			end
		end,
	},
}
projectile_templates.area_buff_drone = {
	item_name = "content/items/weapons/player/drone_area_buff",
	unit_template_name = "item_deployable_projectile",
	uses_script_components = true,
	locomotion_template = ProjectileLocomotionTemplates.area_buff_drone,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 10,
		},
		impact = {
			damage_profile = DamageProfileTemplates.frag_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
	deployable = {
		relation_init_data = {
			allied = {
				stickiness_limit = 5,
				stickiness_time = 1,
				proximity_radius = adamant_talent_settings.blitz_ability.drone.range,
				logic = {
					{
						class_name = "ProximityAreaBuffDrone",
						use_as_job = false,
						init_data = {
							buff_to_add = "adamant_drone_base_buff",
							buff_to_add_special_rule = "adamant_drone_talent_buff",
							improved_buff_to_add = "adamant_drone_improved_buff",
							life_time = adamant_talent_settings.blitz_ability.drone.duration,
							special_rule = special_rules.adamant_drone_buff_talent,
						},
					},
				},
			},
			enemy = {
				stickiness_limit = 5,
				stickiness_time = 1,
				proximity_radius = adamant_talent_settings.blitz_ability.drone.range,
				logic = {
					{
						class_name = "ProximityAreaBuffDrone",
						use_as_job = true,
						init_data = {
							buff_to_add = "adamant_drone_enemy_debuff",
							buff_to_add_special_rule = "adamant_drone_talent_debuff",
							life_time = adamant_talent_settings.blitz_ability.drone.duration,
							special_rule = special_rules.adamant_drone_debuff_talent,
						},
					},
				},
			},
		},
		deploy_func = function (world, physics_world, unit)
			local job_class = ScriptUnit.extension(unit, "proximity_system")

			Managers.state.unit_job:register_job(unit, job_class, true)

			local can_place, _, _, placed_on_unit = AimPlacement.from_unit(physics_world, unit)

			if can_place and placed_on_unit then
				DeployableLocomotion.set_placed_on_unit(world, unit, placed_on_unit)
			end
		end,
	},
}
projectile_templates.quick_flash_grenade = {
	item_name = "content/items/weapons/player/grenade_quick_flash",
	locomotion_template = ProjectileLocomotionTemplates.broker_flash_grenade,
	projectile_type = projectile_types.player_grenade,
	damage = {
		fuse = {
			fuse_time = 0.2,
			impact_fuse_time = 0,
			impact_triggered = true,
			explosion_template = ExplosionTemplates.broker_flash_grenade,
		},
		impact = {
			damage_profile = DamageProfileTemplates.broker_flash_grenade_impact,
			damage_type = damage_types.grenade_frag,
		},
	},
	effects = {
		spawn = {
			vfx = {
				link = true,
				orphaned_policy = "destroy",
				particle_name = "content/fx/particles/weapons/grenades/grenade_trail",
			},
			sfx = {
				looping_event_name = "wwise/events/weapon/play_player_combat_weapon_grenader_loop",
				looping_stop_event_name = "wwise/events/weapon/stop_player_combat_weapon_grenader_loop",
			},
		},
	},
}

return projectile_templates
