-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/cryptic_servo_skull_order_point.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local flamethrower_types = CompanionServoSkullSettings.FLAMETHROWER_TYPES
local servo_skull_states = CompanionServoSkullSettings.STATES
local special_rules = SpecialRulesSettings.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.not_scroll_wieldable = true
weapon_template.action_inputs = {
	grenade_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = nil,
	},
	combat_ability = {
		buffer_time = 0,
		input_sequence = nil,
	},
	aim_servo_skull = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "grenade_ability_hold",
				value = true,
			},
		},
	},
	order_servo_skull = {
		buffer_time = 0.6,
		input_sequence = {
			{
				input = "grenade_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	instant_aim_servo_skull = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "grenade_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	instant_order_servo_skull = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = nil,
	},
	cancel = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	unwield_to_previous = {
		buffer_time = 0,
		input_sequence = nil,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "aim_servo_skull",
		transition = {
			{
				input = "order_servo_skull",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "cancel",
				transition = "base",
			},
		},
	},
	{
		input = "instant_aim_servo_skull",
		transition = {
			{
				input = "instant_order_servo_skull",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "cancel",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "cancel",
		transition = "stay",
	},
	{
		input = "unwield_to_previous",
		transition = "stay",
	},
	{
		input = "grenade_ability",
		transition = "stay",
	},
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_unwield_to_previous = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		total_time = 0,
		uninterruptible = true,
		unwield_to_weapon = false,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		kind = "wield",
		total_time = 0.25,
		uninterruptible = true,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			local companion_spawner_extension = condition_func_params.companion_spawner_extension
			local companion_unit = companion_spawner_extension and companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)
			local anim_event = "equip_ally"
			local anim_event_3p = "equip_shield"

			if not ALIVE[companion_unit] then
				return anim_event, anim_event_3p
			end

			local game_session = Managers.state.game_session:game_session()
			local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
			local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

			if not game_object_exists then
				return anim_event, anim_event_3p
			end

			local state = GameSession.game_object_field(game_session, game_object_id, "state")
			local is_in_flame_state = state and (state == servo_skull_states.flamethrower or state == servo_skull_states.flamethrower_shooting)

			if is_in_flame_state then
				return anim_event, anim_event_3p
			end

			local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

			anim_event = current_flamethrower_type == flamethrower_types.circle and "equip_circle" or "equip_cone"

			return anim_event, anim_event_3p
		end,
		conditional_state_to_action_input = {
			action_end = {
				input_name = "aim_servo_skull",
			},
		},
		allowed_chain_actions = {
			instant_aim_servo_skull = {
				action_name = "action_instant_aim_servo_skull",
			},
			aim_servo_skull = {
				action_name = "action_aim_servo_skull",
				chain_time = 0.1,
			},
		},
	},
	action_aim_servo_skull = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "dummy",
		prevent_sprint = true,
		uninterruptible = true,
		total_time = math.huge,
		order_effects = {
			is_2d = true,
			looping_sound_alias = "ability_aiming",
			sfx_source_name = "_charge",
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			order_servo_skull = {
				action_name = "action_order_servo_skull",
				chain_time = 0.1,
			},
			cancel = {
				action_name = "action_cancel",
			},
		},
	},
	action_instant_aim_servo_skull = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "dummy",
		prevent_sprint = true,
		total_time = 0,
		uninterruptible = true,
		conditional_state_to_action_input = {
			action_end = {
				input_name = "instant_order_servo_skull",
			},
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			instant_order_servo_skull = {
				action_name = "action_instant_order_servo_skull",
			},
			cancel = {
				action_name = "action_cancel",
			},
		},
	},
	action_order_servo_skull = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_shoot",
		kind = "dummy",
		prevent_sprint = true,
		total_time = 0.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_4",
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.8,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.4,
			},
			start_modifier = 0.3,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
	action_cancel = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge_cancel",
		anim_time_scale = 1,
		kind = "dummy",
		start_input = "cancel",
		total_time = 0.22,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
}
weapon_template.actions.action_instant_order_servo_skull = table.clone(weapon_template.actions.action_order_servo_skull)
weapon_template.actions.action_instant_order_servo_skull.total_time = 0.1
weapon_template.actions.action_instant_order_servo_skull.place_time = 0
weapon_template.actions.action_instant_order_servo_skull.anim_event = nil

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.keywords = {
	"cryptic",
}
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_running_action",
		input_name = "cancel",
	},
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/cryptic_skull_order_point"
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_muzzle = "fx_right",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

weapon_template.action_aim_servo_skull_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "action_aim_servo_skull"
end

weapon_template.action_switch_servo_skull_flame_mode_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "action_aim_servo_skull"
end

weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
