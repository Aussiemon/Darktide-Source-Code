-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_burninating_templates.lua

local weapon_burninating_templates = {
	flamer_p1_m1 = {
		initial_burn_delay = 0.1,
		max_stacks = {
			lerp_basic = 4,
			lerp_perfect = 20,
		},
		stack_application_rate = {
			lerp_basic = 0.5,
			lerp_perfect = 0.25,
		},
	},
	forcestaff_p2_m1 = {
		initial_burn_delay = 0.1,
		max_stacks = {
			lerp_basic = 4,
			lerp_perfect = 20,
		},
		stack_application_rate = {
			lerp_basic = 0.5,
			lerp_perfect = 0.25,
		},
	},
}

return settings("WeaponBurninatingTemplates", weapon_burninating_templates)
