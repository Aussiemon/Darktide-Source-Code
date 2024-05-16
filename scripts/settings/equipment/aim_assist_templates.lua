-- chunkname: @scripts/settings/equipment/aim_assist_templates.lua

local aim_assist_templates = {}

aim_assist_templates.killshot_aim = {
	max_ramp_multiplier = 1,
	ramp_decay_delay = 0.3,
	ramp_multiplier = 0.6,
	reset_on_action_finish = false,
	reset_on_attack = false,
}
aim_assist_templates.killshot_fire = {
	max_ramp_multiplier = 1,
	ramp_decay_delay = 0.25,
	ramp_multiplier = 0.3,
	reset_on_action_finish = false,
	reset_on_attack = false,
}
aim_assist_templates.tank_swing = {
	max_ramp_multiplier = 0.8,
	ramp_decay_delay = 0.2,
	ramp_multiplier = 0.4,
	reset_on_action_finish = false,
	reset_on_attack = true,
}
aim_assist_templates.tank_swing_heavy = {
	max_ramp_multiplier = 1,
	ramp_decay_delay = 0.3,
	ramp_multiplier = 0.4,
	reset_on_action_finish = false,
	reset_on_attack = true,
}

return settings("AimAssistTemplates", aim_assist_templates)
