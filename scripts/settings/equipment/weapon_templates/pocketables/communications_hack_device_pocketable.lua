-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/communications_hack_device_pocketable.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PocketableUtils = require("scripts/settings/equipment/weapon_templates/pocketables/pockatables_utils")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	use_self = {
		anim_event = "scan_start",
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	push = {
		buffer_time = 0.4,
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
	aim_give = {
		buffer_time = 0.3,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	aim_give_release = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	unwield = {
		anim_event = "unequip",
		buffer_time = 0,
		clear_input_queue = true,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "use_self",
		transition = "stay",
	},
	{
		input = "push",
		transition = "stay",
	},
	{
		input = "unwield",
		transition = "stay",
	},
	{
		input = "aim_give",
		transition = {
			{
				input = "aim_give_release",
				transition = "previous",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_scanner",
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
	},
	action_use_self = {
		allowed_during_sprint = true,
		kind = "use_auspex",
		remove_item_from_inventory = false,
		self_use = true,
		start_input = "use_self",
		total_time = 0,
		uninterruptible = true,
	},
	action_push = {
		anim_end_event = "attack_finished",
		anim_event = "attack_push",
		block_duration = 0.4,
		kind = "push",
		push_radius = 2.5,
		start_input = "push",
		total_time = 0.67,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.67,
			},
			start_modifier = 1,
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
				chain_time = 0.4,
			},
		},
	},
	action_aim_give = {
		abort_sprint = true,
		aim_ready_up_time = 0,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		anim_end_event = "share_aim_end",
		anim_event = "share_aim",
		clear_on_hold_release = true,
		kind = "target_ally",
		minimum_hold_time = 0.01,
		prevent_sprint = true,
		sprint_ready_up_time = 0,
		start_input = "aim_give",
		stop_input = "aim_give_release",
		uninterruptible = true,
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		validate_target_func = PocketableUtils.validate_give_pocketable_target_func,
		smart_targeting_template = SmartTargetingTemplates.target_ally_close,
		allowed_chain_actions = {
			aim_give_release = {
				action_name = "action_give",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
		},
	},
	action_give = {
		allowed_during_sprint = true,
		anim_end_event = "share_aim_end",
		anim_event = "share_ally",
		assist_notification_type = "gifted",
		give_time = 0.7,
		kind = "give_pocketable",
		total_time = 0.7,
		smart_targeting_template = SmartTargetingTemplates.target_ally_close,
		validate_target_func = PocketableUtils.validate_give_pocketable_target_func,
		voice_event_data = {
			voice_tag_concept = "on_demand_com_wheel",
			voice_tag_id = "com_take_this",
		},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_mission_zone",
		input_name = "unwield",
	},
}
weapon_template.crosshair = {
	crosshair_type = "ironsight",
}
weapon_template.keywords = {
	"pocketable",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables_2h",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables_2h",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/scanner_equip",
	ogryn = "content/characters/player/ogryn/first_person/animations/scanner_equip",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {
	_passive = "fx_passive",
	_speaker = "fx_speaker",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/corrupted_auspex_scanner"
weapon_template.hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_corrupted_auspex_scanner"
weapon_template.swap_pickup_name = "communications_hack_device"
weapon_template.give_pickup_name = "communications_hack_device"
weapon_template.require_minigame = true
weapon_template.auto_start_minigame = false
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

local function _is_minigame_in_focus(player)
	local player_unit = player.player_unit

	if not player_unit then
		return nil
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
	local pocketable_device_active = minigame_character_state_component.pocketable_device_active

	return pocketable_device_active
end

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not _is_minigame_in_focus(player) and (not current_action_name or current_action_name == "none")
end

weapon_template.action_none_gift_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not _is_minigame_in_focus(player) and (not current_action_name or current_action_name == "none")
end

weapon_template.action_scan_on_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not _is_minigame_in_focus(player) and (not current_action_name or current_action_name == "none")
end

weapon_template.action_can_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_targeting_component = condition_func_params.action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1

	return not _is_minigame_in_focus(player) and current_action_name == "action_aim_give" and target_unit ~= nil
end

weapon_template.action_cant_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_targeting_component = condition_func_params.action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1

	return not _is_minigame_in_focus(player) and current_action_name == "action_aim_give" and target_unit == nil
end

local function _get_minigame(player)
	local player_unit = player.player_unit

	if not player_unit then
		return nil
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
	local is_level_unit = minigame_character_state_component.interface_is_level_unit
	local unit_id

	if is_level_unit then
		unit_id = minigame_character_state_component.interface_level_unit_id

		if unit_id == NetworkConstants.invalid_level_unit_id then
			return nil
		end
	else
		unit_id = minigame_character_state_component.interface_game_object_id

		if unit_id == NetworkConstants.invalid_game_object_id then
			return nil
		end
	end

	local interface_unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	if not interface_unit then
		return nil
	end

	local minigame_extension = interface_unit and ScriptUnit.has_extension(interface_unit, "minigame_system")
	local minigame = minigame_extension:minigame()

	return minigame
end

local function _move_ui_validate(player)
	local minigame = _get_minigame(player)

	return minigame and minigame:uses_joystick()
end

weapon_template.action_confirm_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local minigame = _get_minigame(player)

	return _is_minigame_in_focus(player) and minigame and minigame:uses_action()
end

weapon_template.action_move_gamepad_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if not _is_minigame_in_focus(player) then
		return false
	end

	if Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

weapon_template.action_move_keyboard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if not _is_minigame_in_focus(player) then
		return false
	end

	if not Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

weapon_template.action_cancel_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local minigame = _get_minigame(player)

	return _is_minigame_in_focus(player) and minigame
end

return weapon_template
