-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_exhausted_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Vo = require("scripts/utilities/vo")
local BtWizardExhuastedAction = class("BtWizardExhuastedAction", "BtNode")
local STATES = table.enum("start", "loop", "exit")

local function _play_anim(unit, anim_event)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(anim_event)
end

BtWizardExhuastedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events
	local anim_duration = action_data.anim_duration
	local requested_duration = blackboard.abilites.exhaust_duration

	scratchpad.requested_duration = requested_duration and requested_duration > 0 and requested_duration or nil
	scratchpad.loop_event = anim_events[2]
	scratchpad.exit_event = anim_events[3]

	local skip_intro = blackboard.abilites.skip_exhaust_intro

	if skip_intro then
		local abilites_component = Blackboard.write_component(blackboard, "abilites")

		abilites_component.skip_exhaust_intro = false

		_play_anim(unit, scratchpad.loop_event)

		scratchpad.state = STATES.loop

		local loop_duration = scratchpad.requested_duration or anim_duration[scratchpad.loop_event]

		scratchpad.loop_end_t = t + loop_duration
		scratchpad.state_end_t = t + anim_duration[scratchpad.loop_event]
	else
		local start_event = anim_events[1]

		_play_anim(unit, start_event)

		scratchpad.state = STATES.start
		scratchpad.state_end_t = t + anim_duration[start_event]
	end

	local vo_event = action_data.vo_event

	if vo_event then
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

		if toughness_extension and not toughness_extension:is_invulnerable() then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end
	end
end

BtWizardExhuastedAction.init_values = function (self, blackboard, action_data, node_data)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.exhaust_duration = 0
	abilites_component.skip_exhaust_intro = false
end

BtWizardExhuastedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.current_ability = ""

	abilites_component.ability_position:store(0, 0, 0)

	abilites_component.exhaust_duration = 0
end

BtWizardExhuastedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == STATES.start then
		if t >= scratchpad.state_end_t then
			_play_anim(unit, scratchpad.loop_event)

			scratchpad.state = STATES.loop

			local loop_duration = scratchpad.requested_duration or action_data.anim_duration[scratchpad.loop_event]

			scratchpad.loop_end_t = t + loop_duration
			scratchpad.state_end_t = t + action_data.anim_duration[scratchpad.loop_event]
		end
	elseif state == STATES.loop then
		if t >= scratchpad.loop_end_t then
			_play_anim(unit, scratchpad.exit_event)

			scratchpad.state = STATES.exit
			scratchpad.state_end_t = t + action_data.anim_duration[scratchpad.exit_event]
		elseif t >= scratchpad.state_end_t then
			_play_anim(unit, scratchpad.loop_event)

			scratchpad.state_end_t = t + action_data.anim_duration[scratchpad.loop_event]
		end
	elseif state == STATES.exit and t >= scratchpad.state_end_t then
		local abilites_component = Blackboard.write_component(blackboard, "abilites")

		abilites_component.current_ability = ""
		abilites_component.exhaust_duration = 0

		return "done"
	end

	return "running"
end

return BtWizardExhuastedAction
