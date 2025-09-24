-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_use_stim_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtUseStimAction = class("BtUseStimAction", "BtNode")
local _stim_use

BtUseStimAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	scratchpad.animation_extension = animation_extension

	local perception_extension = ScriptUnit.extension(unit, "perception_system")

	scratchpad.perception_extension = perception_extension

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.side = side

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	scratchpad.visual_loadout_extension = visual_loadout_extension
	scratchpad.duration = action_data.duration + t
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_component = blackboard.perception

	local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
	local dt = Managers.time:delta_time("gameplay")

	behavior_extension:update_combat_range(unit, blackboard, dt, t)
end

local DEFUALT_TIMINGS = {
	1,
	5,
}

BtUseStimAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local stim_component = blackboard.stim

	if stim_component.t_til_use == 0 then
		local write_stim_component = Blackboard.write_component(blackboard, "stim")
		local timings = action_data.delay_timings or DEFUALT_TIMINGS

		write_stim_component.t_til_use = t + math.random(timings[1], timings[2])

		return "done"
	end

	if not scratchpad.used then
		scratchpad.used = true

		local write_stim_component = Blackboard.write_component(blackboard, "stim")

		write_stim_component.currently_using_stim = true

		_stim_use(unit, breed, blackboard, scratchpad, action_data, dt, t)
	end

	if not action_data.ignore_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	if scratchpad.apply_buff and t > scratchpad.apply_buff then
		local random_stim_buff = action_data.stim_buffs[math.random(1, #action_data.stim_buffs)]
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local time = Managers.time:time("gameplay")

		buff_extension:add_internally_controlled_buff(random_stim_buff, time)

		scratchpad.apply_buff = nil
	end

	if t > scratchpad.duration and scratchpad.duration then
		return "done"
	else
		return "running"
	end
end

BtUseStimAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.used then
		local fx_system = Managers.state.extension:system("fx_system")
		local effect_id = scratchpad.effect_id

		fx_system:stop_template_effect(effect_id)

		if HEALTH_ALIVE[unit] then
			local stim_component = Blackboard.write_component(blackboard, "stim")

			stim_component.can_use_stim = false

			local special_visual_wield_considerations = action_data.special_visual_wield_considerations
			local visual_loadout_extension = scratchpad.visual_loadout_extension

			if scratchpad.wield_slot then
				visual_loadout_extension:wield_slot(scratchpad.wield_slot)
			elseif special_visual_wield_considerations then
				visual_loadout_extension:unwield_slot(special_visual_wield_considerations)
			end
		end

		local write_stim_component = Blackboard.write_component(blackboard, "stim")

		write_stim_component.currently_using_stim = false
	end
end

function _stim_use(unit, breed, blackboard, scratchpad, action_data, dt, t)
	local special_visual_wield_considerations = action_data.special_visual_wield_considerations
	local visual_loadout_extension = scratchpad.visual_loadout_extension
	local wielded_slot_name = visual_loadout_extension:wielded_slot_name()

	scratchpad.wield_slot = wielded_slot_name

	if wielded_slot_name then
		visual_loadout_extension:unwield_slot(wielded_slot_name)
	end

	if special_visual_wield_considerations then
		visual_loadout_extension:wield_slot(special_visual_wield_considerations)
	end

	local fx_system = Managers.state.extension:system("fx_system")
	local effect_template = action_data.effect_template

	scratchpad.effect_id = fx_system:start_template_effect(effect_template, unit)

	local animation_extension = scratchpad.animation_extension
	local anim_event = action_data.anim_event

	animation_extension:anim_event(anim_event)

	scratchpad.apply_buff = t + 0.5
end

BtUseStimAction.init_values = function (self, blackboard)
	local stim_component = Blackboard.write_component(blackboard, "stim")

	stim_component.t_til_use = 0
	stim_component.can_use_stim = false
	stim_component.currently_using_stim = false
end

return BtUseStimAction
