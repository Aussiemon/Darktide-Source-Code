-- chunkname: @scripts/settings/corruptor/corruptor_settings.lua

local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local damage_types = DamageSettings.damage_types
local destructible_node_names = {}
local corruptor_settings = {
	animation_length_impact = 0.5,
	close_hatch_distance = 15,
	constrain_aim_speed = 20,
	constrain_lerp_amount = 0.5,
	constraint_name = "eye_aim",
	contrain_dot_threshold = 0.7,
	destructible_count = 3,
	emerge_done_timing = 3.6666666666666665,
	explosion_power_level = 1000,
	explosion_timing = 2.3333333333333335,
	eye_node_name = "j_eye",
	liquid_above = 4,
	liquid_below = 6,
	liquid_goo_distance = 2.25,
	liquid_horizontal = 4,
	liquid_node_name = "fx_eye_socket",
	look_at_enter_distance = 10,
	look_at_leave_distance = 11,
	look_at_node = "j_head",
	open_hatch_distance = 14,
	target_side_name = "heroes",
	tick_frequency = 2,
	tick_power_level = 150,
	emerge_explosion_template = ExplosionTemplates.corruptor_emerge,
	tick_damage_profile = DamageProfileTemplates.corruptor_damage_tick,
	tick_damage_type = damage_types.corruption,
	destructible_node_names = destructible_node_names,
	animation_speed_multiplier = {
		retract = 10,
		spawn = 1.75,
		regrowth = {
			0.25,
			0.5,
			0.75,
			1,
			1.5,
		},
	},
	liquid_area_template = LiquidAreaTemplates.prop_corruptor,
}

for i = 1, corruptor_settings.destructible_count do
	destructible_node_names[i] = "j_bulb_0" .. i
end

return settings("CorruptorSettings", corruptor_settings)
