local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local talent_settings = TalentSettings.veteran_3
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
		action_shout = {
			sound_event = "wwise/events/player/play_veteran_ability_shout",
			start_input = "shout_pressed",
			target_enemies = true,
			kind = "shout",
			revive_allies = true,
			sprint_ready_up_time = 0.5,
			uninterruptible = true,
			recover_toughness_effect = "content/fx/particles/abilities/squad_leader_ability_toughness_buff",
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			anim = "ability_shout",
			target_allies = true,
			suppress_enemies = true,
			special_rule_buff = "veteran_squad_leader_shout_damage_boost",
			use_charge_at_start = true,
			vo_tag = "ability_squad_leader",
			use_ability_charge = true,
			total_time = 0.3,
			radius = talent_settings.combat_ability.radius,
			damage_profile = DamageProfileTemplates.shout_stagger,
			power_level = talent_settings.combat_ability.power_level,
			cone_dot = talent_settings.combat_ability.cone_dot,
			cone_range = talent_settings.combat_ability.cone_range
		}
	},
	fx_sources = {},
	equiped_ability_effect_scripts = {
		"ShoutEffects"
	},
	vfx = {
		delay = 0.2,
		name = "content/fx/particles/abilities/squad_leader_ability_shout_activate"
	}
}

return ability_template
