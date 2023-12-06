require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local BtRenegadeTwinCaptainDisappearAction = class("BtRenegadeTwinCaptainDisappearAction", "BtNode")

BtRenegadeTwinCaptainDisappearAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events
	local anim_event = Animation.random_event(anim_events)
	local anim_extension = ScriptUnit.extension(unit, "animation_system")

	anim_extension:anim_event(anim_event)

	local disappear_timing = action_data.disappear_timings[anim_event]
	scratchpad.disappear_timing = t + disappear_timing
end

BtRenegadeTwinCaptainDisappearAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.should_disappear = false
	behavior_component.should_disappear_instant = false
	behavior_component.disappear_index = 0
end

BtRenegadeTwinCaptainDisappearAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.disappear_timing <= t then
		local explode_position_node = action_data.explode_position_node
		local position = Unit.world_position(unit, Unit.node(unit, explode_position_node))
		local spawn_component = blackboard.spawn
		local world = spawn_component.world
		local physics_world = spawn_component.physics_world
		local impact_normal = Vector3.up()
		local charge_level = 1
		local attack_type = nil
		local power_level = action_data.power_level
		local explosion_template = action_data.explosion_template

		Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, power_level, charge_level, attack_type)

		local minion_spawn_manager = Managers.state.minion_spawn

		minion_spawn_manager:despawn(unit)

		return "done"
	end

	return "running"
end

return BtRenegadeTwinCaptainDisappearAction
