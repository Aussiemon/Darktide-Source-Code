-- chunkname: @scripts/settings/equipment/reload_templates/plasma_rifle_reload_template.lua

local reload_template = {
	name = "plasma_rifle",
	states = {
		"lift_weapon",
		"remove_canister",
		"replace_canister"
	},
	lift_weapon = {
		overheat_clear_speed = 1,
		anim_1p = "reload",
		time = 9,
		state_transitions = {
			lift_weapon = 6.7,
			remove_canister = 2.2,
			replace_canister = 5.3
		},
		functionality = {
			refill_ammunition = 6.7,
			clear_overheat = 2.5,
			remove_ammunition = 2.2
		}
	},
	remove_canister = {
		anim_1p = "reload_middle",
		time = 5.7,
		state_transitions = {
			replace_canister = 1.7,
			lift_weapon = 3.5
		},
		functionality = {
			refill_ammunition = 3.5
		}
	},
	replace_canister = {
		anim_1p = "reload_end_long",
		time = 3,
		state_transitions = {
			lift_weapon = 0.9
		},
		functionality = {
			refill_ammunition = 0.9
		}
	}
}

return reload_template
