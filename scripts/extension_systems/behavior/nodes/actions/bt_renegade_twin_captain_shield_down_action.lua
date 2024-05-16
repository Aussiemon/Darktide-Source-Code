-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_renegade_twin_captain_shield_down_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local BtRenegadeTwinCaptainShieldDownAction = class("BtRenegadeTwinCaptainShieldDownAction", "BtNode")
local Vo = require("scripts/utilities/vo")

BtRenegadeTwinCaptainShieldDownAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events
	local anim_event = Animation.random_event(anim_events)
	local anim_extension = ScriptUnit.extension(unit, "animation_system")

	anim_extension:anim_event(anim_event)

	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

	scratchpad.toughness_extension = toughness_extension

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component
	behavior_component.move_state = "idle"

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system

	local spawn_component = blackboard.spawn

	scratchpad.spawn_component = spawn_component
end

BtRenegadeTwinCaptainShieldDownAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.toughness_broke = false
	behavior_component.remove_toughness_clamp = false
	behavior_component.other_twin_unit = nil
	behavior_component.disappear_idle = false
	behavior_component.disappear_index = false
end

BtRenegadeTwinCaptainShieldDownAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	local toughness_extension = scratchpad.toughness_extension

	toughness_extension:set_override_regen_speed(nil)
	toughness_extension:set_invulnerable(false)

	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", false)

	local behavior_component = scratchpad.behavior_component

	behavior_component.toughness_broke = false
	behavior_component.remove_toughness_clamp = true
end

local HARD_MODE_REGEN_SPEED = {
	800,
	800,
	800,
	800,
	1600,
}
local DRAIN_SPEED = {
	200,
	200,
	200,
	200,
	150,
}
local HARD_MODE_DRAIN_SPEED = {
	200,
	200,
	200,
	200,
	150,
}

BtRenegadeTwinCaptainShieldDownAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local other_twin_unit = behavior_component.other_twin_unit
	local toughness_extension = scratchpad.toughness_extension
	local other_twin_blackboard = BLACKBOARDS[other_twin_unit]

	if other_twin_blackboard then
		local other_twin_behavior = other_twin_blackboard.behavior
		local other_twin_toughness = ScriptUnit.extension(other_twin_unit, "toughness_system")
		local other_twin_is_broke = other_twin_behavior.toughness_broke or other_twin_toughness:current_toughness_percent() <= 0

		if not other_twin_is_broke then
			local spawn_component = blackboard.spawn
			local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id
			local has_hard_mode = Managers.state.pacing:has_hard_mode()

			if not scratchpad.is_regenerating then
				local regen_speed = Managers.state.difficulty:get_table_entry_by_challenge(has_hard_mode and HARD_MODE_REGEN_SPEED or action_data.regen_speed)

				toughness_extension:set_override_regen_speed(regen_speed)
				toughness_extension:set_invulnerable(true)
				GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", true)

				scratchpad.is_regenerating = true
			else
				local drain_speed = Managers.state.difficulty:get_table_entry_by_challenge(has_hard_mode and HARD_MODE_DRAIN_SPEED or DRAIN_SPEED)
				local new_other_twin_toughness = math.clamp(other_twin_toughness:toughness_damage() + dt * drain_speed, 1, other_twin_toughness:max_toughness() - 1)

				other_twin_toughness:set_toughness_damage(new_other_twin_toughness)
			end

			if not scratchpad.global_effect_id then
				local other_twin_game_object_id = Managers.state.unit_spawner:game_object_id(other_twin_unit)

				GameSession.set_game_object_field(game_session, game_object_id, "linked_object_id", other_twin_game_object_id)

				scratchpad.global_effect_id = scratchpad.fx_system:start_template_effect(action_data.charge_effect_template, unit)

				local vo_event = action_data.vo_event

				if vo_event then
					Vo.enemy_generic_vo_event(other_twin_unit, vo_event, breed.name)
				end
			end
		else
			self:_break_shield(unit, breed, blackboard, scratchpad, action_data, dt, t)

			return "done"
		end
	else
		self:_break_shield(unit, breed, blackboard, scratchpad, action_data, dt, t)

		return "done"
	end

	if toughness_extension:current_toughness_percent() >= 1 and not scratchpad.stand_up_anim_duration then
		local anim_events = action_data.stand_up_anim_events
		local anim_event = Animation.random_event(anim_events)
		local anim_extension = ScriptUnit.extension(unit, "animation_system")

		anim_extension:anim_event(anim_event)

		scratchpad.stand_up_anim_duration = t + action_data.stand_up_anim_duration
	elseif scratchpad.stand_up_anim_duration and t >= scratchpad.stand_up_anim_duration then
		behavior_component.toughness_broke = false
		behavior_component.remove_toughness_clamp = false

		local reactivation_override = true

		toughness_extension:set_toughness_damage(0, reactivation_override)
		toughness_extension:set_invulnerable(false)
		toughness_extension:set_override_regen_speed(nil)

		local spawn_component = blackboard.spawn
		local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", false)

		return "done"
	end

	return "running"
end

BtRenegadeTwinCaptainShieldDownAction._break_shield = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local toughness_extension = scratchpad.toughness_extension
	local behavior_component = scratchpad.behavior_component
	local ignore_stagger = false
	local regenerate_full_delay = Managers.state.difficulty:get_table_entry_by_challenge(action_data.regenerate_full_delay)
	local optional_regenerate_full_delay_t = t + regenerate_full_delay

	toughness_extension:break_shield(Vector3.up(), ignore_stagger, optional_regenerate_full_delay_t)
	toughness_extension:set_toughness_damage(scratchpad.toughness_extension:max_toughness())
	toughness_extension:set_override_regen_speed(nil)
	toughness_extension:set_invulnerable(false)

	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", false)

	scratchpad.shield_break_duration = t + action_data.shield_break_duration

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)

		scratchpad.global_effect_id = nil
	end

	scratchpad.is_regenerating = nil
	behavior_component.toughness_broke = false
	behavior_component.remove_toughness_clamp = true
end

return BtRenegadeTwinCaptainShieldDownAction
