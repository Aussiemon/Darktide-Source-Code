-- chunkname: @scripts/settings/equipment/reload_templates/basic_reload_template.lua

local reload_template = {
	name = "basic",
	states = {
		"reload",
	},
	reload = {
		anim_1p = "reload",
		time = 2.4,
		state_transitions = {
			reload = 2.3,
		},
		functionality = {
			refill_ammunition = 2.3,
		},
	},
}

return reload_template
