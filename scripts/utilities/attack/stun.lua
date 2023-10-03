local Action = require("scripts/utilities/weapon/action")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_keywords = BuffSettings.keywords
local _is_stun_immune_from_current_action, _is_stun_immune_from_buff, _is_stun_immune_from_character_state, _apply_stun = nil
local Stun = {
	apply = function (unit, disorientation_type, hit_direction, weapon_template, ignore_stun_immunity, is_predicted)
		if not disorientation_type then
			return
		end

		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if not unit_data_extension then
			return
		end

		local breed = unit_data_extension:breed()

		if not Breed.is_player(breed) then
			return
		end

		local character_state_component = unit_data_extension:read_component("character_state")

		if PlayerUnitStatus.is_disabled(character_state_component) then
			return
		end

		if not ignore_stun_immunity and (_is_stun_immune_from_current_action(unit_data_extension, weapon_template, unit) or _is_stun_immune_from_buff(unit) or _is_stun_immune_from_character_state(unit_data_extension)) then
			return
		end

		_apply_stun(unit_data_extension, disorientation_type, hit_direction, unit, is_predicted)
	end
}

function _is_stun_immune_from_current_action(unit_data_extension, weapon_template, unit)
	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")

	if alternate_fire_component.is_active and weapon_template.alternate_fire_settings and weapon_template.alternate_fire_settings.uninterruptible then
		return true
	end

	local current_action_name, action_settings = Action.current_action(weapon_action_component, weapon_template)
	local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	local ability_action_settings = ability_extension and ability_extension:running_action_settings()

	if (current_action_name == "none" or not action_settings) and not ability_action_settings then
		return false
	end

	if action_settings and action_settings.uninterruptible or ability_action_settings and ability_action_settings.uninterruptible then
		return true
	end

	local action_sweep_component = unit_data_extension:read_component("action_sweep")

	if action_sweep_component and action_sweep_component.is_sticky then
		return true
	end

	return false
end

function _is_stun_immune_from_buff(unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension then
		return false
	end

	local has_buff = buff_extension:has_keyword(buff_keywords.stun_immune)

	return has_buff
end

function _is_stun_immune_from_character_state(unit_data_extension)
	local character_state_component = unit_data_extension:read_component("character_state")
	local current_state_name = character_state_component.state_name

	if current_state_name == "exploding" then
		return true
	end

	local lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")

	if lunge_character_state_component.is_lunging then
		return true
	end

	return false
end

function _apply_stun(unit_data_extension, disorientation_type, push_direction, unit, is_predicted)
	local stun_state_input = unit_data_extension:write_component("stun_state_input")
	stun_state_input.disorientation_type = disorientation_type
	stun_state_input.push_direction = push_direction
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local frame_offset = 0

	if player and player.remote and not is_predicted then
		frame_offset = math.ceil(player:lag_compensation_rewind_s() * 60)
	end

	local current_fixed_frame = unit_data_extension:last_fixed_frame()
	stun_state_input.stun_frame = current_fixed_frame + frame_offset
end

return Stun
