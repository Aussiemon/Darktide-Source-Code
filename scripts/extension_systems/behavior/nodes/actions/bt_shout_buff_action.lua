-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_shout_buff_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtShoutBuffAction = class("BtShoutBuffAction", "BtNode")

BtShoutBuffAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local events = action_data.anim_events
	local event = Animation.random_event(events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(event)

	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local shout_timing = action_data.shout_timings[event]

	scratchpad.shout_timing = t + shout_timing

	local action_duration = action_data.action_durations[event]

	scratchpad.action_duration = t + action_duration

	local vo_event = action_data.vo_event

	if vo_event then
		local breed_name = breed.name

		Vo.enemy_generic_vo_event(unit, vo_event, breed_name)
	end

	local shout_wwise_event_timing = action_data.shout_wwise_event_timing

	if shout_wwise_event_timing then
		scratchpad.shout_wwise_event_timing = t + shout_wwise_event_timing
	end
end

local MINION_BREED_TYPE = BreedSettings.types.minion
local _broadphase_results = {}

BtShoutBuffAction._shout = function (self, unit, action_data, t)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local player_position = POSITION_LOOKUP[unit]
	local allied_side_names = side:relation_side_names("allied")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local vfx_name = "content/fx/particles/enemies/bolstering_shockwave"
	local node_position = Unit.world_position(unit, 1) + Vector3(0, 0, 0.25)
	local fx_system = Managers.state.extension:system("fx_system")
	local rotation = Unit.local_rotation(unit, 1)

	fx_system:trigger_vfx(vfx_name, node_position, rotation)
	table.clear(_broadphase_results)

	local shout_radius = action_data.shout_radius
	local buff_to_add = action_data.buff_to_add
	local num_hits = broadphase.query(broadphase, player_position, shout_radius, _broadphase_results, allied_side_names, MINION_BREED_TYPE)

	for ii = 1, num_hits do
		repeat
			local target_unit = _broadphase_results[ii]

			if target_unit == unit then
				break
			end

			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension and not buff_extension:has_keyword("empowered") then
				buff_extension:add_internally_controlled_buff(buff_to_add, t)
			end
		until true
	end
end

BtShoutBuffAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if t >= scratchpad.action_duration then
		return "done"
	end

	if scratchpad.shout_wwise_event_timing and t >= scratchpad.shout_wwise_event_timing then
		local fx_system = Managers.state.extension:system("fx_system")
		local position = POSITION_LOOKUP[unit]
		local shout_wwise_event = action_data.shout_wwise_event

		fx_system:trigger_wwise_event(shout_wwise_event, position)

		scratchpad.shout_wwise_event_timing = nil
	end

	if scratchpad.shout_timing and t >= scratchpad.shout_timing then
		self:_shout(unit, action_data, t)

		scratchpad.shout_timing = nil
	end

	if not action_data.ignore_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	return "running"
end

return BtShoutBuffAction
