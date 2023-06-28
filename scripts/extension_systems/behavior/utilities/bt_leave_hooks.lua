local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ChaosBeastOfNurgleSettings = require("scripts/settings/monster/chaos_beast_of_nurgle_settings")
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
	end,
	set_scratchpad_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local field = args.field
		local value = args.value
		scratchpad[field] = value
	end,
	captain_charge_exit = function (unit, breed, blackboard, scratchpad, action_data, t, args)
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
	end,
	captain_grenade_exit = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		if breed.phase_template then
			local phase_component = Blackboard.write_component(blackboard, "phase")
			phase_component.lock = false
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local wielded_slot_name = visual_loadout_extension:wielded_slot_name()
		local exit_anim_states = args.exit_anim_states
		local wanted_anim_state = exit_anim_states[wielded_slot_name]

		if wanted_anim_state then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:anim_event(wanted_anim_state)
		end
	end,
	bulwark_climb_leave = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(true)

		local slot_name = args.slot_name
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		if visual_loadout_extension:can_wield_slot(slot_name) then
			visual_loadout_extension:wield_slot(slot_name)
		end
	end,
	wield_slot = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local slot_name = args.slot_name
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		if visual_loadout_extension:can_wield_slot(slot_name) then
			visual_loadout_extension:wield_slot(slot_name)
		end
	end,
	poxwalker_bomber_lunge_stagger_check = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local death_component = blackboard.death

		if death_component.staggered_during_lunge then
			local stagger_component = blackboard.stagger
			local attacker_unit = ALIVE[stagger_component.attacker_unit] and stagger_component.attacker_unit

			Attack.execute(unit, DamageProfileTemplates.default, "attacking_unit", attacker_unit, "instakill", true)
		end
	end,
	beast_of_nurgle_set_melee_cooldown = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		local cooldowns = ChaosBeastOfNurgleSettings.cooldowns
		local cooldown = cooldowns.melee
		behavior_component.melee_cooldown = t + cooldown
	end,
	beast_of_nurgle_set_melee_aoe_cooldown = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		local cooldowns = ChaosBeastOfNurgleSettings.cooldowns
		local cooldown = cooldowns.melee_aoe
		behavior_component.melee_aoe_cooldown = t + cooldown
	end,
	beast_of_nurgle_set_vomit_cooldown = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		local cooldowns = ChaosBeastOfNurgleSettings.cooldowns
		local cooldown = cooldowns.vomit
		behavior_component.vomit_cooldown = t + cooldown
	end,
	beast_of_nurgle_set_consume_cooldown = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		local cooldowns = ChaosBeastOfNurgleSettings.cooldowns
		local cooldown = cooldowns.consume
		behavior_component.consume_cooldown = t + cooldown
	end,
	beast_of_nurgle_reset_alerted = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.wants_to_play_alerted = false
	end,
	beast_of_nurgle_force_spit_out = function (unit, breed, blackboard, scratchpad, action_data, t, args, reason)
		if reason == "failed" then
			local behavior_component = Blackboard.write_component(blackboard, "behavior")
			behavior_component.force_spit_out = true
			local cooldowns = ChaosBeastOfNurgleSettings.cooldowns
			local cooldown = cooldowns.consume
			behavior_component.consume_cooldown = t + cooldown
		end
	end,
	netgunner_reset_cooldown = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.net_is_ready = true
		behavior_component.shoot_net_cooldown = 0
	end
}

return BtLeaveHooks
