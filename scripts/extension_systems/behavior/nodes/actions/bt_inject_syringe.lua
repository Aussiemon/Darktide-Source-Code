-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_inject_syringe.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CharacterStateAssistSettings = require("scripts/settings/character_state/character_state_assist_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BtInjectSyringeAction = class("BtInjectSyringeAction", "BtNode")

BtInjectSyringeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local owner_player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

	scratchpad.owner_player = owner_player
	scratchpad.behavior_component = behavior_component
	scratchpad.animation_extension = animation_extension

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	behavior_component.max_speed = 10
	behavior_component.has_move_to_position = true

	self:_set_move_position(scratchpad, action_data)

	local move_effect_template = action_data.move_effect_template

	if move_effect_template then
		scratchpad.move_effect_id = self:_start_effect_template(unit, scratchpad, move_effect_template)
	end
end

BtInjectSyringeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local ally_character_state_component = scratchpad._ally_character_state_component

	if ally_character_state_component and not PlayerUnitStatus.requires_allied_interaction_help(ally_character_state_component) then
		return "failed"
	end

	if scratchpad._force_assist_delay then
		if t >= scratchpad._force_assist_delay then
			local force_assist_duration = CharacterStateAssistSettings.force_assist_duration

			scratchpad._force_assist_end_t = t + force_assist_duration

			local assisted_state_input_component = scratchpad._target_ally_assisted_state_input_component

			if not assisted_state_input_component then
				return "failed"
			end

			assisted_state_input_component.force_assist = true
			scratchpad._force_assist_delay = nil

			return "running"
		end

		return "running"
	end

	if scratchpad._force_assist_end_t then
		if t >= scratchpad._force_assist_end_t then
			return "done"
		end

		return "running"
	end

	local target_position, target_ally = self:_set_move_position(scratchpad, action_data)
	local unit_position = POSITION_LOOKUP[unit]
	local distance_sq = Vector3.distance_squared(unit_position, target_position)

	if distance_sq < action_data.distance_threshold_sq then
		local inject_start_animation = action_data.inject_start_animation

		if inject_start_animation then
			scratchpad.animation_extension:anim_event(inject_start_animation)
		end

		local success = self:_revive_ally_if_needed(scratchpad.owner_player, target_ally, scratchpad, t)

		if not success then
			return "failed"
		end

		self:_apply_syringe(target_ally, action_data, t)

		scratchpad._force_assist_delay = t + action_data.delay_before_reviving

		local syringe_effect_template_name = action_data.syringe_effect_template_name

		if syringe_effect_template_name then
			scratchpad.syringe_effect_id = self:_start_effect_template(unit, scratchpad, syringe_effect_template_name)
		end
	end

	return "running"
end

BtInjectSyringeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local move_effect_id = scratchpad.move_effect_id

	if move_effect_id then
		self:_stop_effect_template(unit, scratchpad, move_effect_id)
	end

	local syringe_effect_id = scratchpad.syringe_effect_id

	if syringe_effect_id then
		self:_stop_effect_template(unit, scratchpad, syringe_effect_id)
	end

	local inject_stop_animation = action_data.inject_stop_animation

	if inject_stop_animation then
		scratchpad.animation_extension:anim_event(inject_stop_animation)
	end

	local optional_leave_function = action_data.optional_leave_function

	if optional_leave_function then
		local success = reason == "done"

		optional_leave_function(unit, success)
	end
end

BtInjectSyringeAction._set_move_position = function (self, scratchpad, action_data)
	local behavior_component = scratchpad.behavior_component
	local target_ally = behavior_component.target_unit
	local target_position = POSITION_LOOKUP[target_ally]

	target_position.z = target_position.z + action_data.position_height

	behavior_component.move_to_position:store(target_position)

	return target_position, target_ally
end

BtInjectSyringeAction._apply_syringe = function (self, target_ally, action_data, t)
	local target_buff_extension = ScriptUnit.has_extension(target_ally, "buff_system")

	if target_buff_extension then
		target_buff_extension:add_internally_controlled_buff(action_data.buff_name, t, "owner_unit", target_ally)

		local assist_notification_type = action_data.assist_notification_type

		if assist_notification_type and ALIVE[target_ally] then
			PlayerAssistNotifications.show_notification(target_ally, target_ally, assist_notification_type)
		end
	end
end

BtInjectSyringeAction._revive_ally_if_needed = function (self, owner_player, target_ally, scratchpad, t)
	local unit_data_extension = ScriptUnit.has_extension(target_ally, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

	if character_state_component then
		if PlayerUnitStatus.requires_allied_interaction_help(character_state_component) then
			local assisted_state_input_component = unit_data_extension and unit_data_extension:write_component("assisted_state_input")

			if not assisted_state_input_component then
				return false
			end

			if PlayerUnitStatus.is_assisted(assisted_state_input_component) then
				return false
			end

			if owner_player then
				Managers.stats:record_private("hook_cryptic_servo_skull_medicae_helps_ally", owner_player, character_state_component.state_name)
				self:_send_revived_ally_telemetry(owner_player, target_ally, character_state_component.state_name)
			end

			scratchpad._target_ally_assisted_state_input_component = assisted_state_input_component

			if ALIVE[target_ally] then
				PlayerAssistNotifications.show_notification(target_ally, target_ally, "saved")
			end
		end

		scratchpad._ally_character_state_component = character_state_component
	end

	return true
end

BtInjectSyringeAction._start_effect_template = function (self, unit, scratchpad, effect_template_name)
	local effect_template = EffectTemplates[effect_template_name]
	local fx_system = scratchpad.fx_system
	local effect_id = fx_system:start_template_effect(effect_template, unit)

	return effect_id
end

BtInjectSyringeAction._stop_effect_template = function (self, unit, scratchpad, effect_id)
	if effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(effect_id)
	end
end

BtInjectSyringeAction._send_revived_ally_telemetry = function (self, interactor_player, target_unit, from_state_name)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_player = player_unit_spawn_manager:owner(target_unit)
	local interactor_unit = interactor_player.player_unit

	if not HEALTH_ALIVE[interactor_unit] then
		return
	end

	local interactor_position = POSITION_LOOKUP[interactor_unit]
	local interactee_position = POSITION_LOOKUP[target_unit]
	local revived_by_servo_skull = true

	Managers.telemetry_events:player_revived_ally(interactor_player, target_player, interactor_position, interactee_position, from_state_name, revived_by_servo_skull)
end

return BtInjectSyringeAction
