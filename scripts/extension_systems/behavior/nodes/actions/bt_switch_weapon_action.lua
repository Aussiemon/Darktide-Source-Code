require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtSwitchWeaponAction = class("BtSwitchWeaponAction", "BtNode")

BtSwitchWeaponAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local weapon_switch_component = Blackboard.write_component(blackboard, "weapon_switch")
	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = blackboard.perception
	scratchpad.weapon_switch_component = weapon_switch_component
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	scratchpad.animation_extension = animation_extension
	scratchpad.visual_loadout_extension = visual_loadout_extension
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local wanted_weapon_slot = weapon_switch_component.wanted_weapon_slot
	local switch_data = action_data[wanted_weapon_slot]
	local switch_anim_events = switch_data.switch_anim_events
	local switch_timing = 0
	local switch_finished_timing = 0

	if switch_anim_events then
		local switch_anim_event = Animation.random_event(switch_anim_events)
		local switch_anim_equip_timings = switch_data.switch_anim_equip_timings
		switch_timing = switch_anim_equip_timings[switch_anim_event]
		local switch_anim_durations = switch_data.switch_anim_durations
		switch_finished_timing = switch_anim_durations[switch_anim_event]

		animation_extension:anim_event(switch_anim_event)

		behavior_component.move_state = "idle"
	end

	scratchpad.switch_timing = t + switch_timing
	scratchpad.switch_finished_timing = t + switch_finished_timing
	scratchpad.switch_data = switch_data
	scratchpad.wanted_weapon_slot = wanted_weapon_slot
	local wielded_slot_name = visual_loadout_extension:wielded_slot_name()

	if wielded_slot_name then
		visual_loadout_extension:unwield_slot(wielded_slot_name)
	end

	scratchpad.slot_that_got_unwielded = wielded_slot_name
	local vo_event = switch_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtSwitchWeaponAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_switching_weapons then
		local switch_data = scratchpad.switch_data
		local switch_anim_state = switch_data.anim_state

		if switch_anim_state then
			scratchpad.animation_extension:anim_event(switch_anim_state)
		end

		local weapon_switch_component = scratchpad.weapon_switch_component
		weapon_switch_component.is_switching_weapons = false
		weapon_switch_component.last_weapon_switch_t = t
		local wanted_combat_range = weapon_switch_component.wanted_combat_range
		local behavior_component = scratchpad.behavior_component
		behavior_component.combat_range = wanted_combat_range
	else
		local slot_that_got_unwielded = scratchpad.slot_that_got_unwielded
		local can_wield_slot = scratchpad.visual_loadout_extension:can_wield_slot(slot_that_got_unwielded)

		if can_wield_slot then
			scratchpad.visual_loadout_extension:wield_slot(slot_that_got_unwielded)
		end
	end
end

BtSwitchWeaponAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_rotate_towards_target_unit(unit, scratchpad)

	if scratchpad.switch_timing and scratchpad.switch_timing <= t then
		scratchpad.visual_loadout_extension:wield_slot(scratchpad.wanted_weapon_slot)

		scratchpad.switch_timing = nil
		scratchpad.is_switching_weapons = true
	elseif scratchpad.switch_finished_timing <= t then
		return "done"
	end

	return "running"
end

BtSwitchWeaponAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if ALIVE[target_unit] then
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end
end

return BtSwitchWeaponAction
