-- chunkname: @scripts/settings/equipment/aim_assist_templates.lua

local aim_assist_templates = {}

aim_assist_templates.killshot_aim = {
	ramp_decay_delay = 0.3,
	reset_on_attack = false,
	max_ramp_multiplier = 1,
	reset_on_action_finish = false,
	ramp_multiplier = 0.6
}
aim_assist_templates.killshot_fire = {
	ramp_decay_delay = 0.25,
	reset_on_attack = false,
	max_ramp_multiplier = 1,
	reset_on_action_finish = false,
	ramp_multiplier = 0.3
}
aim_assist_templates.tank_swing = {
	ramp_decay_delay = 0.2,
	reset_on_attack = true,
	max_ramp_multiplier = 0.8,
	reset_on_action_finish = false,
	ramp_multiplier = 0.4
}
aim_assist_templates.tank_swing_heavy = {
	ramp_decay_delay = 0.3,
	reset_on_attack = true,
	max_ramp_multiplier = 1,
	reset_on_action_finish = false,
	ramp_multiplier = 0.4
}

return settings("AimAssistTemplates", aim_assist_templates)
