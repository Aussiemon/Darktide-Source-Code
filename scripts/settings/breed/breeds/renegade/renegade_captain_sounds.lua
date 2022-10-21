local RenegadeCommonSounds = require("scripts/settings/breed/breeds/renegade/renegade_common_sounds")
local sounds = {
	vce_combo_attack_single = "wwise/events/minions/play_minion_captain__combo_attack_single_vce",
	swing_start = "wwise/events/minions/play_minion_captain_swing_light_charge",
	vce_melee_attack_charged_long = "wwise/events/minions/play_minion_captain__melee_attack_charged_long_vce",
	foley_movement_short = "wwise/events/minions/play_minion_captain_foley_short",
	run_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_run",
	vce_kick = "wwise/events/minions/play_minion_captain__kick_vce",
	vce_mocking_laughter = "wwise/events/minions/play_minion_captain__mocking_laughter_vce",
	charge = "wwise/events/weapon/play_minion_captain_powersword_charge",
	vce_breathing_running = "wwise/events/minions/play_minion_captain__breathing_running_vce",
	vce_melee_attack_short = "wwise/events/minions/play_minion_captain__melee_attack_short_vce",
	footstep_land = "wwise/events/minions/play_minion_footsteps_boots_heavy_land",
	foley_drastic_short = "wwise/events/minions/play_minion_captain_drastic_short",
	vce_death_quick = "wwise/events/minions/play_minion_captain__death_quick_vce",
	vce_melee_attack_charged = "wwise/events/minions/play_minion_captain__melee_attack_charged_vce",
	vce_grunt = "wwise/events/minions/play_minion_captain__grunt_vce",
	vce_force_field_overload = "wwise/events/minions/play_minion_captain__force_field_overload_vce",
	sprint_start = "wwise/events/minions/play_minion_captain_sprint_start",
	footstep = "wwise/events/minions/play_minion_captain_footsteps",
	equip_melee = {
		slot_power_sword = "wwise/events/minions/play_minion_captain_equip_sword",
		slot_powermaul = "wwise/events/minions/play_minion_captain_equip_maul"
	},
	swing_heavy = {
		slot_power_sword = "wwise/events/weapon/play_minion_captain_swing_powered",
		slot_powermaul = "wwise/events/weapon/play_minion_captain_swing_powered"
	},
	swing = {
		slot_power_sword = "wwise/events/weapon/play_minion_captain_swing",
		slot_powermaul = "wwise/events/weapon/play_minion_swing_2h_blunt"
	}
}

table.add_missing(sounds, RenegadeCommonSounds)

return sounds
