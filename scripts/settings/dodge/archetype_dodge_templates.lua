-- chunkname: @scripts/settings/dodge/archetype_dodge_templates.lua

local archetype_dodge_templates = {}
local default_distance = 2.5
local default_time = 0.4
local default_average_speed = default_distance / default_time
local default_speed_curve = {
	{
		time_in_dodge = default_time * 0,
		speed = default_average_speed * 1.5,
	},
	{
		time_in_dodge = default_time * 0.2,
		speed = default_average_speed * 1.5,
	},
	{
		time_in_dodge = default_time * 0.25,
		speed = default_average_speed * 1.25,
	},
	{
		time_in_dodge = default_time * 0.4,
		speed = default_average_speed * 1,
	},
	{
		time_in_dodge = default_time * 0.7,
		speed = default_average_speed * 1,
	},
	{
		time_in_dodge = default_time * 0.85,
		speed = default_average_speed * 0.75,
	},
	{
		time_in_dodge = default_time * 0.9,
		speed = default_average_speed * 0.55,
	},
	{
		time_in_dodge = default_time * 1,
		speed = default_average_speed * 0.5,
	},
}
local zealot_distance = 2.75
local zealot_time = 0.4
local zealot_average_speed = zealot_distance / zealot_time
local zealot_speed_curve = {
	{
		time_in_dodge = zealot_time * 0,
		speed = zealot_average_speed * 1.5,
	},
	{
		time_in_dodge = zealot_time * 0.2,
		speed = zealot_average_speed * 1.5,
	},
	{
		time_in_dodge = zealot_time * 0.25,
		speed = zealot_average_speed * 1.25,
	},
	{
		time_in_dodge = zealot_time * 0.4,
		speed = zealot_average_speed * 1,
	},
	{
		time_in_dodge = zealot_time * 0.7,
		speed = zealot_average_speed * 1 * 0.9,
	},
	{
		time_in_dodge = zealot_time * 0.85,
		speed = zealot_average_speed * 0.75 * 0.9,
	},
	{
		time_in_dodge = zealot_time * 0.9,
		speed = zealot_average_speed * 0.55 * 0.9,
	},
	{
		time_in_dodge = zealot_time * 1,
		speed = zealot_average_speed * 0.5 * 0.9,
	},
}
local ogryn_distance = 2.25
local ogryn_time = 0.35
local ogryn_average_speed = ogryn_distance / ogryn_time
local speed_curve_ogryn = {
	{
		time_in_dodge = ogryn_time * 0,
		speed = ogryn_average_speed * 0.5,
	},
	{
		time_in_dodge = ogryn_time * 0.2,
		speed = ogryn_average_speed * 1,
	},
	{
		time_in_dodge = ogryn_time * 0.25,
		speed = ogryn_average_speed * 1.2,
	},
	{
		time_in_dodge = ogryn_time * 0.4,
		speed = ogryn_average_speed * 1.4,
	},
	{
		time_in_dodge = ogryn_time * 0.7,
		speed = ogryn_average_speed * 1.5,
	},
	{
		time_in_dodge = ogryn_time * 0.85,
		speed = ogryn_average_speed * 1,
	},
	{
		time_in_dodge = ogryn_time * 0.9,
		speed = ogryn_average_speed * 0.5,
	},
	{
		time_in_dodge = ogryn_time * 1,
		speed = ogryn_average_speed * 0.75,
	},
}

archetype_dodge_templates.default = {
	base_distance = 2.5,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.2,
	dodge_jump_override_timer = 0.5,
	dodge_linger_time = 0.25,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.25,
	dodge_speed_at_times = default_speed_curve,
}
archetype_dodge_templates.zealot = {
	base_distance = 2.5,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.15,
	dodge_jump_override_timer = 0.5,
	dodge_linger_time = 0.25,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.25,
	dodge_speed_at_times = zealot_speed_curve,
}
archetype_dodge_templates.psyker = {
	base_distance = 2,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.15,
	dodge_jump_override_timer = 0.3,
	dodge_linger_time = 0.2,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.25,
	dodge_speed_at_times = default_speed_curve,
}
archetype_dodge_templates.ogryn = {
	base_distance = 3,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.25,
	dodge_jump_override_timer = 0.25,
	dodge_linger_time = 0,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.15,
	dodge_speed_at_times = speed_curve_ogryn,
}
archetype_dodge_templates.adamant = {
	base_distance = 2,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.15,
	dodge_jump_override_timer = 0.3,
	dodge_linger_time = 0.2,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.25,
	dodge_speed_at_times = default_speed_curve,
}
archetype_dodge_templates.broker = {
	base_distance = 2.5,
	consecutive_dodges_reset = 0.85,
	dodge_cooldown = 0.15,
	dodge_jump_override_timer = 0.5,
	dodge_linger_time = 0.25,
	minimum_dodge_input = 0.25,
	stop_threshold = 0.25,
	dodge_speed_at_times = default_speed_curve,
}

return settings("ArchetypeDodgeTemplates", archetype_dodge_templates)
