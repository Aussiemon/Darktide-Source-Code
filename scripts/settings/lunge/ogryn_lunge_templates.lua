local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.ogryn_2
local ogryn_lunge_templates = {
	ogryn_charge = {
		on_screen_effect = "content/fx/particles/screenspace/screen_ogryn_dash",
		stop_sound_event = "wwise/events/player/play_ability_ogryn_charge_stop",
		move_back_cancel = true,
		move_back_cancel_time_threshold = 0.8,
		allow_steering = true,
		combat_ability = true,
		disable_minion_collision = true,
		block_input_cancel = true,
		block_input_cancel_time_threshold = 0.5,
		disallow_weapons = true,
		hit_dot_check = 0.7,
		sensitivity_modifier = 5,
		directional_lunge = false,
		lunge_end_camera_shake = "ogryn_charge_end",
		start_sound_event = "wwise/events/player/play_ability_ogryn_charge_start",
		lunge_speed_at_times = {
			{
				speed = 0,
				time_in_lunge = 0
			},
			{
				speed = 4,
				time_in_lunge = 0.2
			},
			{
				speed = 6,
				time_in_lunge = 0.3
			},
			{
				speed = 8,
				time_in_lunge = 0.4
			},
			{
				speed = 10,
				time_in_lunge = 0.5
			}
		},
		distance = talent_settings.combat_ability.distance,
		rotation_contraints = {
			pitch = 0.25,
			yaw = 0.35
		},
		damage_settings = {
			damage_profile = DamageProfileTemplates.ogryn_charge_impact,
			damage_type = damage_types.ogryn_lunge,
			radius = talent_settings.combat_ability.radius
		},
		anim_settings = {
			on_enter = "ability_charge_in",
			on_exit = "ability_charge_end",
			timing_anims = {
				[1.1] = "ability_charge_out"
			}
		},
		wwise_state = {
			group = "player_ability",
			on_state = "ogryn_charge",
			off_state = "none"
		},
		on_finish_explosion = {
			forward_offset = 1.5,
			explosion_template = ExplosionTemplates.ogryn_charge_impact
		},
		stop_armor_types = {
			armor_types.super_armor,
			armor_types.void_shield,
			armor_types.resistant
		},
		mood = MoodSettings.mood_types.ogryn_combat_ability_charge
	}
}
ogryn_lunge_templates.ogryn_charge_increased_distance = table.clone(ogryn_lunge_templates.ogryn_charge)
ogryn_lunge_templates.ogryn_charge_increased_distance.distance = talent_settings.combat_ability_2.distance
ogryn_lunge_templates.ogryn_charge_increased_distance.stop_tags = {
	monster = true
}
ogryn_lunge_templates.ogryn_charge_increased_distance.stop_armor_types = nil
ogryn_lunge_templates.ogryn_charge_increased_distance.anim_settings.timing_anims = {
	[2.3] = "ability_charge_out"
}
ogryn_lunge_templates.ogryn_charge_damage = table.clone(ogryn_lunge_templates.ogryn_charge)
ogryn_lunge_templates.ogryn_charge_damage.damage_settings = {
	radius = 2,
	damage_profile = DamageProfileTemplates.ogryn_charge_impact_damage,
	damage_type = damage_types.ogryn_lunge
}
ogryn_lunge_templates.ogryn_charge_damage.on_finish_explosion.explosion_template = ExplosionTemplates.ogryn_charge_impact_damage
ogryn_lunge_templates.ogryn_charge_bleed = table.clone(ogryn_lunge_templates.ogryn_charge)
ogryn_lunge_templates.ogryn_charge_bleed.add_debuff_on_hit = "bleed"
ogryn_lunge_templates.ogryn_charge_bleed.add_debuff_on_hit_stacks = talent_settings.combat_ability_1.stacks

return ogryn_lunge_templates
