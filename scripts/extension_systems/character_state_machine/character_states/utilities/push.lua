-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/push.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PushSettings = require("scripts/settings/damage/push_settings")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local _is_push_stun_immune_from_buff, _time_to_apply_push
local MAX_PUSH_SPEED = PushSettings.default_max_push_speed
local Push = {}

Push.add = function (unit, locomotion_push_component, push_direction, push_template, attack_type, is_predicted)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_extension then
		return
	end

	local character_state_component = unit_data_extension:read_component("character_state")

	if PlayerUnitStatus.is_disabled(character_state_component) then
		return
	end

	if PlayerUnitStatus.is_climbing_ladder(character_state_component) then
		return
	end

	local lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")

	if lunge_character_state_component.is_lunging then
		return
	end

	local locomotion_steering = unit_data_extension:read_component("locomotion_steering")

	if locomotion_steering.disable_push_velocity then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if _is_push_stun_immune_from_buff(unit, attack_type, buff_extension) then
		return
	end

	local dont_trigger_on_toughness = push_template.dont_trigger_on_toughness

	if dont_trigger_on_toughness then
		local toughness_extension = ScriptUnit.extension(unit, "toughness_system")
		local toughness_percentage = toughness_extension:current_toughness_percent()

		if toughness_percentage > 0 then
			return
		end
	end

	local push_speed = push_template.speed
	local max_push_speed = push_template.max_speed_override or MAX_PUSH_SPEED
	local active_push_velocity = locomotion_push_component.velocity
	local dormant_push_velocity = locomotion_push_component.new_velocity
	local current_push_velocity = active_push_velocity + dormant_push_velocity
	local flat_push_direction = Vector3.normalize(Vector3.flat(push_direction))
	local already_moving_in_dir = Vector3.dot(current_push_velocity, flat_push_direction)
	local clamped_push_speed = math.clamp(already_moving_in_dir, 0, max_push_speed)
	local stat_buffs = buff_extension and buff_extension:stat_buffs()

	if stat_buffs and stat_buffs.push_speed_modifier then
		push_speed = push_speed * stat_buffs.push_speed_modifier
	end

	local push_speed_modifier = (max_push_speed - clamped_push_speed) / max_push_speed
	local wanted_push_velocity = flat_push_direction * push_speed * push_speed_modifier
	local new_push_velocity = dormant_push_velocity + wanted_push_velocity
	local is_server = Managers.state.game_session:is_server()

	locomotion_push_component.new_velocity = new_push_velocity

	if is_predicted then
		locomotion_push_component.time_to_apply = _time_to_apply_push(unit, unit_data_extension, is_server)
	else
		locomotion_push_component.time_to_apply = 0
	end
end

function _is_push_stun_immune_from_buff(unit, attack_type, buff_extension)
	if not buff_extension then
		return false
	end

	local has_buff = false

	if attack_type == attack_types.melee then
		has_buff = has_buff or buff_extension:has_keyword(buff_keywords.melee_push_immune)
	end

	if attack_type == attack_types.ranged then
		has_buff = has_buff or buff_extension:has_keyword(buff_keywords.ranged_push_immune)
	end

	return has_buff
end

function _time_to_apply_push(unit, unit_data_extension, is_server)
	local current_fixed_t = FixedFrame.get_latest_fixed_time()
	local is_local_unit = unit_data_extension:is_local_unit()
	local player = Managers.state.player_unit_spawn:owner(unit)
	local lag_compensation = LagCompensation.rewind_ms(is_server, is_local_unit, player) + 0.05
	local max_allowed_lag_compensation = NetworkConstants.fixed_frame_offset_end_t_4bit.max * Managers.state.game_session.fixed_time_step
	local clamped_lag_compensation = math.min(lag_compensation, max_allowed_lag_compensation)

	return current_fixed_t + clamped_lag_compensation
end

return Push
