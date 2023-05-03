local damage_settings = {
	damage_types = table.enum("chaos_hound_tearing", "daemonhost_melee", "daemonhost_execute", "minion_mutant_smash", "minion_mutant_smash_ogryn", "minion_ogryn_kick", "minion_ogryn_executor_pommel", "minion_ogryn_punch", "minion_beast_of_nurgle_weakspot_hit", "minion_auto_bullet", "minion_large_caliber", "minion_laser", "minion_plasma", "minion_melee_blunt", "minion_melee_blunt_elite", "minion_melee_sharp", "minion_monster_sharp", "minion_monster_blunt", "minion_monster_eat", "minion_pellet", "minion_pellet_captain", "minion_direct_flamer", "minion_powered_sharp", "minion_powered_blunt", "minion_charge", "minion_vomit", "blunt_thunder", "blunt", "blunt_light", "blunt_heavy", "blunt_shock", "combat_blade", "metal_slashing_heavy", "metal_slashing_light", "metal_slashing_medium", "ogryn_physical", "physical", "power_sword", "sawing_stuck", "sawing", "sawing_2h", "shield_push", "slabshield_push", "shock_stuck", "shovel_heavy", "shovel_light", "shovel_medium", "shovel_smack", "slashing_force_stuck", "slashing_force", "knife", "axe_light", "spiked_blunt", "bash", "ogryn_pipe_club", "ogryn_pipe_club_heavy", "blunt_powermaul_active", "ogryn_punch", "ogryn_slap", "punch", "weapon_butt", "auto_bullet", "boltshell", "laser", "laser_charged", "laser_bfg", "overheat", "pellet", "pellet_heavy", "pellet_incendiary", "plasma", "rippergun_pellet", "rippergun_flechette", "throwing_knife", "heavy_stubber_bullet", "grenade_fire", "grenade_frag", "grenade_krak", "minion_grenade", "ogryn_grenade_box", "bleeding", "burning", "corruption", "kinetic", "ogryn_bullet_bounce", "grimoire", "biomancer_soul", "smite", "electrocution", "force_sword_cleave", "force_staff_single_target", "force_staff_explosion", "force_staff_bfg", "psyker_biomancer_discharge", "warpfire", "warp", "warp_overload"),
	heal_types = table.enum("knocked_down", "medkit", "healing_station", "blessing", "blessing_grim", "blessing_health_station", "syringe", "blessing_syringe", "heal_over_time_tick", "leech")
}
local heal_types = damage_settings.heal_types
damage_settings.permanent_heal_types = {
	[heal_types.blessing] = true,
	[heal_types.blessing_health_station] = true,
	[heal_types.blessing_grim] = true,
	[heal_types.blessing_syringe] = true
}
damage_settings.ranged_close = 15
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
	[damage_types.force_sword_cleave] = true
}

return settings("DamageSettings", damage_settings)
