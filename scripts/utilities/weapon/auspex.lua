-- chunkname: @scripts/utilities/weapon/auspex.lua

local Auspex = {}

Auspex.in_focus = function (player_unit)
	if not player_unit then
		return false
	end

	local character_state_machine_extension = ScriptUnit.has_extension(player_unit, "character_state_machine_system")
	local current_state_name = character_state_machine_extension:current_state_name()

	return current_state_name == "minigame"
end

Auspex.focused_minigame = function (player)
	local player_unit = player.player_unit

	if not player_unit then
		return nil
	end

	local character_state_machine_extension = ScriptUnit.has_extension(player_unit, "character_state_machine_system")
	local current_state_name = character_state_machine_extension:current_state_name()

	if current_state_name ~= "minigame" then
		return nil
	end

	local current_state = character_state_machine_extension:current_state()

	return current_state:minigame()
end

Auspex.idle_out_of_focus_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not Auspex.in_focus(player.player_unit) and (not current_action_name or current_action_name == "none")
end

Auspex.can_give_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_target_finder_component = condition_func_params.action_module_target_finder_component
	local target_unit = action_module_target_finder_component.target_unit_1

	return not Auspex.in_focus(player.player_unit) and current_action_name == "action_aim_give" and target_unit ~= nil
end

Auspex.cant_give_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_target_finder_component = condition_func_params.action_module_target_finder_component
	local target_unit = action_module_target_finder_component.target_unit_1

	return not Auspex.in_focus(player.player_unit) and current_action_name == "action_aim_give" and target_unit == nil
end

local function _move_ui_validate(player)
	local minigame = Auspex.focused_minigame(player)

	return minigame and minigame:uses_joystick()
end

Auspex.confirm_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local minigame = Auspex.focused_minigame(player)

	return Auspex.in_focus(player.player_unit) and minigame and minigame:uses_action()
end

Auspex.move_gamepad_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if not Auspex.in_focus(player.player_unit) then
		return false
	end

	if Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

Auspex.move_keyboard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	if not Auspex.in_focus(player.player_unit) then
		return false
	end

	if not Managers.input:device_in_use("gamepad") then
		return _move_ui_validate(player)
	end

	return false
end

Auspex.cancel_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local minigame = Auspex.focused_minigame(player)

	return Auspex.in_focus(player.player_unit) and minigame
end

return Auspex
