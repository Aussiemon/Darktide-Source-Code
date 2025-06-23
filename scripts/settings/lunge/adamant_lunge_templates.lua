-- chunkname: @scripts/settings/lunge/adamant_lunge_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.adamant
local adamant_lunge_templates = {}

adamant_lunge_templates.adamant_charge = {
	cancel_on_unwield = true,
	disable_minion_collision = true,
	is_dodging = true,
	move_back_cancel = true,
	move_back_cancel_time_threshold = 0.4,
	on_screen_effect = "content/fx/particles/screenspace/screen_adamant_charge",
	combat_ability = true,
	on_screen_effect_delay = 0.01,
	keep_slot_wielded_on_lunge_end = true,
	block_input_cancel = true,
	on_hit_gear_alias = "ability_bash",
	slot_to_wield = "slot_primary",
	block_input_cancel_time_threshold = 0.4,
	on_exit_vfx = "content/fx/particles/abilities/adamant/adamant_charge_ability",
	hit_dot_check = 0.7,
	sensitivity_modifier = 0.1,
	directional_lunge = false,
	disable_weapon_actions = true,
	lunge_end_camera_shake = "adamant_charge_end",
	start_sound_event = "wwise/events/player/play_player_ability_adamant_charge",
	lunge_speed_at_times = {
		{
			speed = 8,
			time_in_lunge = 0
		},
		{
			speed = 10,
			time_in_lunge = 0.1
		},
		{
			speed = 12,
			time_in_lunge = 0.15
		},
		{
			speed = 13,
			time_in_lunge = 0.2
		},
		{
			speed = 13,
			time_in_lunge = 0.25
		},
		{
			speed = 13,
			time_in_lunge = 0.35
		},
		{
			speed = 13,
			time_in_lunge = 0.4
		}
	},
	distance = talent_settings.combat_ability.charge.range,
	damage_settings = {
		radius = 1,
		damage_profile = DamageProfileTemplates.adamant_charge_impact,
		damage_type = damage_types.physical
	},
	on_finish_directional_shout = {
		shout_dot = -0.25,
		force_stagger_type_if_not_staggered_duration = 2.5,
		anim_event_1p = "shake_medium",
		force_stagger_type_if_not_staggered = "heavy",
		power_level = 0,
		forward_range = 5,
		damage_profile = DamageProfileTemplates.adamant_charge_impact
	},
	anim_settings = {
		on_enter = {
			"move_fwd",
			"sprint",
			"parry_pose"
		},
		on_exit = {
			"parry_pose",
			"parry_finished",
			"attack_push"
		}
	},
	stop_tags = {
		monster = true,
		cultist_captain = true,
		special = true,
		captain = true,
		elite = true
	},
	mood = MoodSettings.mood_types.adamant_combat_ability_charge
}

return adamant_lunge_templates
