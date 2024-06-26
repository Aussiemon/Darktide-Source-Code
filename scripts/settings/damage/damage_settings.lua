-- chunkname: @scripts/settings/damage/damage_settings.lua

local damage_settings = {}

damage_settings.damage_types = table.enum("chaos_hound_tearing", "daemonhost_execute", "daemonhost_melee", "minion_mutant_smash_ogryn", "minion_mutant_smash", "minion_ogryn_executor_pommel", "minion_ogryn_kick", "minion_ogryn_punch", "minion_beast_of_nurgle_weakspot_hit", "minion_auto_bullet", "minion_large_caliber", "minion_laser", "minion_melee_blunt_elite", "minion_melee_blunt", "minion_melee_sharp", "minion_monster_blunt", "minion_monster_eat", "minion_monster_sharp", "minion_pellet_captain", "minion_pellet", "minion_plasma", "minion_charge", "minion_direct_flamer", "minion_powered_blunt", "minion_powered_sharp", "minion_vomit", "axe_light", "bash", "blunt_heavy", "blunt_light", "blunt_powermaul_active", "blunt_shock", "blunt_thunder", "blunt", "combat_blade", "knife", "metal_slashing_heavy", "metal_slashing_light", "metal_slashing_medium", "ogryn_hook", "ogryn_lunge", "ogryn_physical", "ogryn_pipe_club_heavy", "ogryn_pipe_club", "ogryn_punch", "ogryn_shovel_fold_special", "ogryn_shovel_smack", "ogryn_slap", "physical", "piercing_heavy", "power_sword_2h", "power_sword", "punch", "sawing_2h", "sawing_stuck", "sawing", "shield_push", "shock_stuck", "shovel_heavy", "shovel_light", "shovel_medium", "shovel_smack", "slabshield_push", "slashing_force_stuck", "slashing_force", "spiked_blunt", "weapon_butt", "auto_bullet", "boltshell_non_armed", "boltshell_small", "boltshell", "heavy_stubber_bullet", "laser_bfg", "laser_charged", "laser", "overheat", "pellet_heavy", "pellet_incendiary", "pellet", "plasma", "rippergun_flechette", "rippergun_pellet", "throwing_knife_zealot", "throwing_knife", "grenade_fire", "grenade_frag_ogryn", "grenade_frag", "grenade_krak", "minion_grenade", "ogryn_friend_rock", "ogryn_grenade_box", "bleeding", "burning", "corruption", "grimoire", "kinetic", "ogryn_bullet_bounce", "biomancer_soul", "electrocution", "force_staff_bfg", "force_staff_explosion", "force_staff_single_target", "force_sword_cleave", "psyker_biomancer_discharge", "smite", "warp", "warpfire", "warp_overload")
damage_settings.heal_types = table.enum("knocked_down", "medkit", "healing_station", "blessing", "blessing_grim", "blessing_health_station", "syringe", "blessing_syringe", "heal_over_time_tick", "leech")

local heal_types = damage_settings.heal_types

damage_settings.permanent_heal_types = {
	[heal_types.blessing] = true,
	[heal_types.blessing_health_station] = true,
	[heal_types.blessing_grim] = true,
	[heal_types.blessing_syringe] = true,
}
damage_settings.ranged_close = 8
damage_settings.ranged_far = 30
damage_settings.in_melee_range = 8

local damage_types = damage_settings.damage_types

damage_settings.warp_damage_types = {
	[damage_types.biomancer_soul] = true,
	[damage_types.smite] = true,
	[damage_types.electrocution] = true,
	[damage_types.force_staff_single_target] = true,
	[damage_types.force_staff_explosion] = true,
	[damage_types.force_staff_bfg] = true,
	[damage_types.psyker_biomancer_discharge] = true,
	[damage_types.warp] = true,
	[damage_types.warpfire] = true,
	[damage_types.force_sword_cleave] = true,
	[damage_types.throwing_knife] = true,
}

return settings("DamageSettings", damage_settings)
