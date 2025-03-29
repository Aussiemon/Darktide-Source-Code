-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_renegade_twin_captain_disappear_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local BtRenegadeTwinCaptainDisappearAction = class("BtRenegadeTwinCaptainDisappearAction", "BtNode")
local Vo = require("scripts/utilities/vo")

BtRenegadeTwinCaptainDisappearAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events
	local anim_event = Animation.random_event(anim_events)
	local anim_extension = ScriptUnit.extension(unit, "animation_system")

	anim_extension:anim_event(anim_event)

	local disappear_timing = action_data.disappear_timings[anim_event]

	scratchpad.disappear_timing = t + disappear_timing

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event_2d(vo_event.voice_profile, vo_event.trigger_id, breed.name)
	end
end

BtRenegadeTwinCaptainDisappearAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.should_disappear = false
	behavior_component.should_disappear_instant = false
	behavior_component.disappear_index = 0
end

BtRenegadeTwinCaptainDisappearAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if t >= scratchpad.disappear_timing then
		local explode_position_node = action_data.explode_position_node
		local position = Unit.world_position(unit, Unit.node(unit, explode_position_node))
		local spawn_component = blackboard.spawn
		local world, physics_world = spawn_component.world, spawn_component.physics_world
		local impact_normal, charge_level, attack_type = Vector3.up(), 1
		local power_level = action_data.power_level
		local explosion_template = action_data.explosion_template

		Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, power_level, charge_level, attack_type)

		local minion_spawn_manager = Managers.state.minion_spawn

		minion_spawn_manager:despawn_minion(unit)

		return "done"
	end

	return "running"
end

return BtRenegadeTwinCaptainDisappearAction
