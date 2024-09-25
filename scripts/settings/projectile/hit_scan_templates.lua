-- chunkname: @scripts/settings/projectile/hit_scan_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local armor_types = ArmorSettings.types
local hit_scan_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_hitscan_templates", hit_scan_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_hitscan_templates", hit_scan_templates, loaded_template_files)

hit_scan_templates.lasgun_assault = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_assault,
		},
	},
}
hit_scan_templates.lasgun_spraynpray_light = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.light_lasgun_snp,
		},
	},
}
hit_scan_templates.lasgun_spraynpray_heavy = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.heavy_lasgun_snp,
		},
	},
}
hit_scan_templates.lasgun_killshot = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_killshot,
		},
	},
}
hit_scan_templates.lasgun_light_killshot = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_killshot,
		},
	},
}
hit_scan_templates.laspistol_killshot = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_laspistol_killshot,
		},
	},
}
hit_scan_templates.lasgun_bfg = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_bfg,
		},
		penetration = {
			depth = 2,
			target_index_increase = 10,
		},
	},
}
hit_scan_templates.lasgun_bfg_spray = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.spray_lasgun_bfg,
		},
		penetration = {
			depth = 1,
			target_index_increase = 10,
		},
	},
}
hit_scan_templates.autogun_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autogun_assault,
		},
	},
}
hit_scan_templates.autopistol_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autopistol_assault,
		},
	},
}
hit_scan_templates.autopistol_snp_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autopistol_snp,
		},
	},
}
hit_scan_templates.autogun_killshot_bullet = table.clone(hit_scan_templates.autogun_bullet)
hit_scan_templates.autogun_killshot_bullet.damage.impact.damage_profile = DamageProfileTemplates.default_autogun_killshot
hit_scan_templates.autogun_snp = table.clone(hit_scan_templates.autogun_bullet)
hit_scan_templates.autogun_snp.damage.impact.damage_profile = DamageProfileTemplates.default_autogun_snp
hit_scan_templates.renegade_rifleman_single_shot = {
	range = 150,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_rifleman_single_shot,
		},
	},
}
hit_scan_templates.renegade_twin_captain_las_pistol_shot = {
	range = 150,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_rifleman,
		},
	},
}
hit_scan_templates.gunner_bullet = {
	range = 150,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.gunner_aimed,
		},
	},
}
hit_scan_templates.chaos_ogryn_gunner_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.chaos_ogryn_gunner_bullet,
		},
	},
}
hit_scan_templates.gunner_bullet_sweep = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.gunner_sweep,
		},
	},
}
hit_scan_templates.gunner_spray_n_pray = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.gunner_spray_n_pray,
		},
	},
}
hit_scan_templates.assaulter_auto_burst = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.assaulter_auto_burst,
		},
	},
}
hit_scan_templates.assaulter_las_burst = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.assaulter_las_burst,
		},
	},
}
hit_scan_templates.shocktrooper_shotgun_bullet = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shocktrooper_shotgun,
		},
	},
}
hit_scan_templates.renegade_captain_shotgun_bullet = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shocktrooper_shotgun,
		},
	},
}
hit_scan_templates.sniper_bullet = {
	range = 150,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.sniper_bullet,
		},
	},
}
hit_scan_templates.renegade_captain_bolt_pistol_boltshell = {
	range = 50,
	damage = {
		explosion_arming_distance = 5,
		impact = {
			damage_profile = DamageProfileTemplates.renegade_captain_bolt_pistol,
			hitmass_consumed_explosion = {
				kill_explosion_template = ExplosionTemplates.renegade_captain_bolt_shell_kill,
				stop_explosion_template = ExplosionTemplates.renegade_captain_bolt_shell_stop,
			},
		},
		penetration = {
			depth = 0.75,
			target_index_increase = 2,
			stop_explosion_template = ExplosionTemplates.renegade_captain_bolt_shell_stop,
		},
	},
}
hit_scan_templates.renegade_captain_plasma_pistol_plasma = {
	range = 50,
	damage = {
		explosion_arming_distance = 5,
		impact = {
			damage_profile = DamageProfileTemplates.renegade_captain_plasma_pistol,
			hitmass_consumed_explosion = {
				kill_explosion_template = ExplosionTemplates.renegade_captain_bolt_shell_kill,
				stop_explosion_template = ExplosionTemplates.renegade_captain_plasma_stop,
			},
		},
		penetration = {
			depth = 0.75,
			target_index_increase = 2,
			stop_explosion_template = ExplosionTemplates.renegade_captain_plasma_stop,
		},
	},
}
hit_scan_templates.renegade_captain_bullet = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_captain_spray,
		},
	},
}
hit_scan_templates.default_plasma_killshot = {
	range = 100,
	damage = {
		impact = {
			destroy_on_impact = false,
			damage_profile = DamageProfileTemplates.default_plasma_killshot,
			armor_explosion = {
				[armor_types.super_armor] = ExplosionTemplates.plasma_rifle_exit,
			},
		},
		penetration = {
			depth = 1.5,
			destroy_on_exit = false,
			target_index_increase = 2,
			exit_explosion_template = ExplosionTemplates.plasma_rifle_exit,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}
hit_scan_templates.medium_charged_plasma = {
	range = 100,
	damage = {
		impact = {
			destroy_on_impact = false,
			damage_profile = DamageProfileTemplates.default_plasma_bfg,
			explosion_template = ExplosionTemplates.plasma_rifle,
		},
		penetration = {
			depth = 2,
			destroy_on_exit = true,
			target_index_increase = 2,
			exit_explosion_template = ExplosionTemplates.plasma_rifle_exit,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}
hit_scan_templates.cultist_flamer = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.cultist_flamer_impact,
		},
	},
}
hit_scan_templates.renegade_flamer = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.renegade_flamer_impact,
		},
	},
}
hit_scan_templates.chaos_beast_of_nurgle_vomit = {
	range = 50,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.beast_of_nurgle_hit_by_vomit,
		},
	},
}

for name, template in pairs(hit_scan_templates) do
	template.name = name
	template.same_side_suppression_enabled = false

	if template.damage.penetration then
		-- Nothing
	end

	if template.collision_tests then
		for i = 1, #template.collision_tests do
			local config = template.collision_tests[i]

			if config.test == "sphere" then
				-- Nothing
			end
		end
	end
end

return settings("HitScanTemplates", hit_scan_templates)
