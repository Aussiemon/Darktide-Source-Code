local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function _quick_throw_allowed(action_settings, condition_func_params, used_input)
	local slot_to_wield = "slot_grenade_ability"
	local weapon_extension = condition_func_params.weapon_extension
	local visual_loadout_extension = condition_func_params.visual_loadout_extension
	local ability_extension = condition_func_params.ability_extension

	if not weapon_extension:can_wield(slot_to_wield) then
		return false
	end

	if not visual_loadout_extension:can_wield(slot_to_wield) then
		return false
	end

	if not ability_extension:can_wield(slot_to_wield) then
		return false
	end

	local talent_extension = condition_func_params.talent_extension
	local has_special_rule = talent_extension:has_special_rule(special_rules.enable_quick_throw_grenades)

	return has_special_rule
end

local base_template_settings = {
	action_inputs = {
		combat_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		grenade_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "grenade_ability_pressed"
				}
			}
		},
		inspect_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "weapon_inspect_hold"
				},
				{
					value = true,
					duration = 0.2,
					input = "weapon_inspect_hold"
				}
			}
		},
		inspect_stop = {
			buffer_time = 0.02,
			input_sequence = {
				{
					value = false,
					input = "weapon_inspect_hold",
					time_window = math.huge
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		}
	},
	actions = {
		combat_ability = {
			slot_to_wield = "slot_combat_ability",
			start_input = "combat_ability",
			uninterruptible = true,
			kind = "unwield_to_specific",
			sprint_ready_up_time = 0,
			total_time = 0,
			allowed_chain_actions = {}
		},
		grenade_ability = {
			allowed_during_sprint = true,
			slot_to_wield = "slot_grenade_ability",
			start_input = "grenade_ability",
			kind = "unwield_to_specific",
			action_priority = 1,
			uninterruptible = true,
			total_time = 0,
			allowed_chain_actions = {},
			action_condition_func = function (action_settings, condition_func_params, used_input)
				return not _quick_throw_allowed(action_settings, condition_func_params, used_input)
			end
		},
		grenade_ability_quick_throw = {
			sprint_requires_press_to_interrupt = false,
			start_input = "grenade_ability",
			stop_alternate_fire = true,
			kind = "spawn_projectile",
			fire_time = 0.25,
			action_priority = 2,
			uninterruptible = true,
			use_ability_charge = true,
			ability_type = "grenade_ability",
			allowed_during_sprint = true,
			anim_event = "ability_knife_throw",
			anim_time_scale = 1.25,
			total_time = 0.55,
			action_movement_curve = {
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.5
				},
				start_modifier = 0.8
			},
			projectile_template = ProjectileTemplates.zealot_throwing_knives,
			action_condition_func = function (action_settings, condition_func_params, used_input)
				return _quick_throw_allowed(action_settings, condition_func_params, used_input)
			end
		}
	},
	action_input_hierarchy = {
		grenade_ability = "stay",
		combat_ability = "stay",
		inspect_start = {
			inspect_stop = "base"
		}
	}
}

return base_template_settings
