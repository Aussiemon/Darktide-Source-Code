-- chunkname: @scripts/settings/lunge/zealot_lunge_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.zealot_2
local zealot_lunge_templates = {}

zealot_lunge_templates.zealot_dash = {
	on_screen_effect_delay = 0.13,
	is_dodging = true,
	move_back_cancel = true,
	add_buff_delay = 0.13,
	on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash",
	move_back_cancel_time_threshold = 0.4,
	sensitivity_modifier = 0.1,
	disable_minion_collision = true,
	add_buff = "no_toughness_damage_buff",
	block_input_cancel = true,
	combat_ability = true,
	block_input_cancel_time_threshold = 0.4,
	add_delayed_buff = "zealot_dash_buff",
	hit_dot_check = 0.7,
	stop_sound_event = "wwise/events/player/play_ability_zealot_maniac_dash_exit",
	directional_lunge = false,
	start_sound_event = "wwise/events/player/play_ability_zealot_maniac_dash_enter",
	lunge_speed_at_times = {
		{
			speed = 8,
			time_in_lunge = 0
		},
		{
			speed = 6,
			time_in_lunge = 0.1
		},
		{
			speed = 10,
			time_in_lunge = 0.15
		},
		{
			speed = 11,
			time_in_lunge = 0.2
		},
		{
			speed = 12,
			time_in_lunge = 0.25
		},
		{
			speed = 12,
			time_in_lunge = 0.35
		},
		{
			speed = 11,
			time_in_lunge = 0.5
		},
		{
			speed = 10,
			time_in_lunge = 0.55
		}
	},
	distance = talent_settings.combat_ability.distance,
	has_target_distance = talent_settings.combat_ability.has_target_distance,
	damage_settings = {
		damage_profile = DamageProfileTemplates.zealot_dash_impact,
		damage_type = damage_types.physical,
		radius = talent_settings.combat_ability.radius
	},
	anim_settings = {
		on_enter = {
			"move_fwd",
			"sprint"
		}
	},
	wwise_state = {
		group = "player_ability",
		on_state = "zealot_dash",
		off_state = "none"
	},
	restore_toughness = talent_settings.combat_ability.toughness,
	stop_armor_types = {
		armor_types.super_armor,
		armor_types.void_shield,
		armor_types.resistant
	},
	mood = MoodSettings.mood_types.zealot_combat_ability_dash
}
zealot_lunge_templates.zealot_dash_with_burning = {
	has_target_distance = 15,
	distance = 7,
	is_dodging = true,
	combat_ability = true,
	on_screen_effect_delay = 0.13,
	on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash",
	disable_minion_collision = true,
	block_input_cancel = true,
	start_sound_event = "wwise/events/player/play_special_ability_zealot_dash",
	lunge_speed_at_times = {
		{
			speed = 0,
			time_in_lunge = 0
		},
		{
			speed = 2,
			time_in_lunge = 0.1
		},
		{
			speed = 8,
			time_in_lunge = 0.15
		},
		{
			speed = 10,
			time_in_lunge = 0.2
		},
		{
			speed = 10,
			time_in_lunge = 0.25
		},
		{
			speed = 12,
			time_in_lunge = 0.35
		},
		{
			speed = 14,
			time_in_lunge = 0.5
		},
		{
			speed = 12,
			time_in_lunge = 0.55
		}
	},
	damage_settings = {
		radius = 2,
		damage_profile = DamageProfileTemplates.zealot_dash_impact,
		damage_type = damage_types.physical
	},
	anim_settings = {
		on_enter = "sprint"
	},
	on_finish_explosion = {
		forward_offset = 1.5,
		explosion_template = ExplosionTemplates.zealot_charge_impact_with_burning
	},
	stop_armor_types = {
		armor_types.super_armor,
		armor_types.void_shield,
		armor_types.resistant
	},
	mood = MoodSettings.mood_types.zealot_combat_ability_dash
}

return zealot_lunge_templates
