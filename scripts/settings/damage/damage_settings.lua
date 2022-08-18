local damage_settings = {
	damage_types = table.enum("chaos_hound_tearing", "daemonhost_melee", "daemonhost_execute", "minion_mutant_smash", "minion_mutant_smash_ogryn", "minion_ogryn_kick", "minion_ogryn_executor_pommel", "minion_ogryn_punch", "minion_auto_bullet", "minion_large_caliber", "minion_laser", "minion_plasma", "minion_melee_blunt", "minion_melee_blunt_elite", "minion_melee_sharp", "minion_pellet", "minion_powered_sharp", "minion_powered_blunt", "minion_charge", "blunt_thunder", "blunt", "blunt_light", "blunt_heavy", "combat_blade", "metal_slashing_heavy", "metal_slashing_light", "metal_slashing_medium", "ogryn_physical", "physical", "power_sword", "sawing_stuck", "sawing", "shield_push", "shovel_heavy", "shovel_light", "shovel_medium", "shovel_smack", "slashing_force_stuck", "slashing_force", "knife", "axe_light", "spiked_blunt", "bash", "ogryn_pipe_club", "ogryn_pipe_club_heavy", "ogryn_punch", "ogryn_slap", "punch", "auto_bullet", "boltshell", "laser", "overheat", "pellet", "plasma", "rippergun_pellet", "throwing_knife", "fire", "frag", "krak", "minion_grenade", "bleeding", "burning", "corruption", "kinetic", "ogryn_bullet_bounce", "biomancer_soul", "smite", "electrocution", "force_staff_single_target", "psyker_biomancer_discharge", "warpfire", "warp"),
	heal_types = table.enum("knocked_down", "medkit", "healing_station", "blessing", "heal_over_time_tick", "leech")
}
local heal_types = damage_settings.heal_types
damage_settings.permanent_heal_types = {
	[heal_types.blessing] = true
}

return settings("DamageSettings", damage_settings)
