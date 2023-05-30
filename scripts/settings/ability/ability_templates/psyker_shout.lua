local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.psyker_2
local ability_template = {
	action_inputs = {
		shout_pressed = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		shout_pressed = "stay"
	},
	actions = {
		action_psyker_shout = {
			sound_event = "wwise/events/player/play_psyker_ability_shout",
			start_input = "shout_pressed",
			kind = "psyker_shout",
			sprint_ready_up_time = 0,
			target_enemies = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			anim = "ability_shout",
			shout_shape = "cone",
			use_charge_at_start = true,
			vfx = "content/fx/particles/abilities/psyker_warp_charge_shout",
			uninterruptible = true,
			allowed_during_explode = true,
			vo_type = "warp_charge",
			use_ability_charge = true,
			total_time = 0.75,
			vo_tag = {
				low = "ability_biomancer_low",
				high = "ability_biomancer_high"
			},
			radius = talent_settings.combat_ability.radius,
			min_radius = talent_settings.combat_ability.min_radius,
			max_radius = talent_settings.combat_ability.max_radius,
			override_radius = talent_settings.combat_ability.override_radius,
			override_min_radius = talent_settings.combat_ability.override_min_radius,
			override_max_radius = talent_settings.combat_ability.override_max_radius,
			damage_profile = DamageProfileTemplates.psyker_biomancer_shout,
			initial_damage_profile = DamageProfileTemplates.psyker_biomancer_shout_damage,
			damage_type = damage_types.psyker_biomancer_discharge,
			attack_type = attack_types.shout,
			power_level = talent_settings.combat_ability.power_level,
			shout_range = talent_settings.combat_ability.shout_range,
			shout_dot = talent_settings.combat_ability.shout_dot
		}
	},
	fx_sources = {}
}

return ability_template
