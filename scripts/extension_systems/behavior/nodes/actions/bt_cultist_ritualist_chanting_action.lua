-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_cultist_ritualist_chanting_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtCultistRitualistChantingAction = class("BtCultistRitualistChantingAction", "BtNode")

BtCultistRitualistChantingAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system

	local spawn_component = blackboard.spawn
	local perception_component = blackboard.perception

	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.spawn_component = spawn_component
	scratchpad.perception_component = perception_component
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state ~= "chanting" then
		local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id
		local anim_events = action_data.anim_events
		local anim_event = Animation.random_event(anim_events)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(anim_event)

		local current_effect_template_variation_id = scratchpad.effect_template_variation_id
		local effect_template_variation_id = action_data.effect_template_variant_lookup[anim_event]

		if scratchpad.chanting_effect_id and current_effect_template_variation_id ~= effect_template_variation_id then
			scratchpad.fx_system:stop_template_effect(scratchpad.chanting_effect_id)

			scratchpad.chanting_effect_id = nil
		end

		if not scratchpad.chanting_effect_id then
			GameSession.set_game_object_field(game_session, game_object_id, "effect_template_variation_id", effect_template_variation_id)

			local chanting_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)

			scratchpad.chanting_effect_id = chanting_effect_id
		end

		behavior_component.move_state = "chanting"
	end

	local vo_event = action_data.vo_event

	if vo_event and perception_component.aggro_state == "passive" then
		Vo.enemy_vo_event(unit, vo_event)
	end
end

BtCultistRitualistChantingAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.chanting_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.chanting_effect_id)

		scratchpad.chanting_effect_id = nil

		local spawn_component = scratchpad.spawn_component
		local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "effect_template_variation_id", -1)
	end
end

BtCultistRitualistChantingAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	MinionMovement.rotate_towards_target_unit(unit, scratchpad)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state == "chanting" then
		local spawn_component = scratchpad.spawn_component
		local perception_component = scratchpad.perception_component
		local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id
		local target_unit = perception_component.target_unit
		local level_unit_id = target_unit and Unit.alive(target_unit) and Managers.state.unit_spawner:level_index(target_unit) or NetworkConstants.invalid_level_unit_id

		GameSession.set_game_object_field(game_session, game_object_id, "level_unit_id", level_unit_id)
	end

	return "running"
end

return BtCultistRitualistChantingAction
