local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local damage_types = DamageSettings.damage_types
local destructible_node_names = {}
local corruptor_settings = {
	contrain_dot_threshold = 0.7,
	destructible_count = 3,
	open_hatch_distance = 14,
	close_hatch_distance = 15,
	liquid_below = 6,
	liquid_horizontal = 4,
	eye_node_name = "j_eye",
	look_at_enter_distance = 10,
	emerge_done_timing = 3.6666666666666665,
	target_side_name = "heroes",
	look_at_node = "j_head",
	liquid_goo_distance = 2.25,
	constraint_name = "eye_aim",
	liquid_node_name = "fx_eye_socket",
	animation_length_impact = 0.5,
	look_at_leave_distance = 11,
	explosion_power_level = 1000,
	liquid_above = 4,
	constrain_lerp_amount = 0.5,
	tick_power_level = 150,
	explosion_timing = 2.3333333333333335,
	constrain_aim_speed = 20,
	tick_frequency = 2,
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
			2
		}
	},
	liquid_area_template = LiquidAreaTemplates.prop_corruptor
}

for i = 1, corruptor_settings.destructible_count do
	destructible_node_names[i] = "j_bulb_0" .. i
end

return settings("CorruptorSettings", corruptor_settings)
