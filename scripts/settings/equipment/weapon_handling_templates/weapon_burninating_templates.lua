-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_burninating_templates.lua

local weapon_burninating_templates = {
	flamer_p1_m1 = {
		initial_burn_delay = 0.1,
		max_stacks = {
			lerp_perfect = 20,
			lerp_basic = 4
		},
		stack_application_rate = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		}
	},
	forcestaff_p2_m1 = {
		initial_burn_delay = 0.1,
		max_stacks = {
			lerp_perfect = 20,
			lerp_basic = 4
		},
		stack_application_rate = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		}
	}
}

return settings("WeaponBurninatingTemplates", weapon_burninating_templates)
