local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local BtLeaveHooks = {
	reset_enter_combat_range_flag = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.enter_combat_range_flag = false
	end,
	trigger_anim_event = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local anim_event = args.anim_event
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(anim_event)
	end,
	activate_shield_blocking = function (unit, breed, blackboard, scratchpad, action_data, t)
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(true)
	end,
	set_component_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local component_name = args.component_name
		local field = args.field
		local value = args.value
		local component = Blackboard.write_component(blackboard, component_name)
		component[field] = value
	end
}

BtLeaveHooks.set_scratchpad_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local field = args.field
	local value = args.value
	scratchpad[field] = value
end

BtLeaveHooks.captain_charge_exit = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local phase_component = Blackboard.write_component(blackboard, "phase")
	phase_component.lock = false
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local wielded_slot_name = visual_loadout_extension:wielded_slot_name()
	local exit_anim_states = args.exit_anim_states
	local wanted_anim_state = exit_anim_states[wielded_slot_name]

	if wanted_anim_state then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(wanted_anim_state)
	end
end

BtLeaveHooks.captain_grenade_exit = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local phase_component = Blackboard.write_component(blackboard, "phase")
	phase_component.lock = false
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local wielded_slot_name = visual_loadout_extension:wielded_slot_name()
	local exit_anim_states = args.exit_anim_states
	local wanted_anim_state = exit_anim_states[wielded_slot_name]

	if wanted_anim_state then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(wanted_anim_state)
	end
end

BtLeaveHooks.bulwark_climb_leave = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local shield_extension = ScriptUnit.extension(unit, "shield_system")

	shield_extension:set_blocking(true)

	local slot_name = args.slot_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	if visual_loadout_extension:can_wield_slot(slot_name) then
		visual_loadout_extension:wield_slot(slot_name)
	end
end

BtLeaveHooks.wield_slot = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local slot_name = args.slot_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	if visual_loadout_extension:can_wield_slot(slot_name) then
		visual_loadout_extension:wield_slot(slot_name)
	end
end

BtLeaveHooks.poxwalker_bomber_lunge_stagger_check = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local death_component = blackboard.death

	if death_component.staggered_during_lunge then
		local stagger_component = blackboard.stagger
		local attacker_unit = ALIVE[stagger_component.attacker_unit] and stagger_component.attacker_unit

		Attack.execute(unit, DamageProfileTemplates.default, "attacking_unit", attacker_unit, "instakill", true)
	end
end

return BtLeaveHooks
