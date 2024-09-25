-- chunkname: @scripts/settings/equipment/weapon_templates/devices/auspex_scanner.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
}
weapon_template.action_input_hierarchy = {
	wield = "stay",
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		anim_event = "unequip",
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "scan_start",
		kind = "wield",
		total_time = 0.1,
		uninterruptible = true,
	},
}
weapon_template.crosshair = {
	crosshair_type = "ironsight",
}
weapon_template.keywords = {
	"devices",
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/scanner",
	ogryn = "content/characters/player/ogryn/first_person/animations/scanner",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_speaker = "fx_speaker",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "auspex"
weapon_template.look_delta_template = "auspex_scanner"
weapon_template.hud_icon = "content/ui/materials/icons/pickups/default"
weapon_template.hide_slot = true
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.require_minigame = true
weapon_template.not_player_wieldable = true

local function _get_minigame(player)
	local player_unit = player.player_unit

	if not player_unit then
		return nil
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
	local is_level_unit = true
	local level_unit_id = minigame_character_state_component.interface_unit_id
	local interface_unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

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

	return minigame and minigame:uses_action()
end

weapon_template.action_move_gamepad_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

weapon_template.action_move_keyboard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if not Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

return weapon_template
