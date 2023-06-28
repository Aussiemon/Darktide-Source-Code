local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local BtEnterHooks = {
	trigger_anim_event = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local anim_event = args.anim_event
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(anim_event)
	end,
	deactivate_shield_blocking = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(false)
	end,
	poxwalker_bomber_jump_explode_check = function (unit, breed, blackboard, scratchpad, action_data, t)
		local nav_smart_object_component = blackboard.nav_smart_object
		local exit_position = nav_smart_object_component.exit_position:unbox()
		local smart_object_type = nav_smart_object_component.type
		local unit_position = POSITION_LOOKUP[unit]
		local is_upwards = unit_position.z < exit_position.z

		if is_upwards or smart_object_type and smart_object_type == "ledges_with_fence" then
			Managers.state.pacing:refund_special_slot()

			local damage_profile = DamageProfileTemplates.default

			Attack.execute(unit, damage_profile, "instakill", true)
		end
	end,
	set_component_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local component_name = args.component_name
		local field = args.field
		local value = args.value
		local component = Blackboard.write_component(blackboard, component_name)
		component[field] = value
	end
}

BtEnterHooks.set_scratchpad_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local field = args.field
	local value = args.value
	scratchpad[field] = value
end

BtEnterHooks.captain_charge_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local phase_component = Blackboard.write_component(blackboard, "phase")
	phase_component.lock = true
end

BtEnterHooks.captain_grenade_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event("to_grenade")

	if breed.phase_template then
		local phase_component = Blackboard.write_component(blackboard, "phase")
		phase_component.lock = true
	end
end

BtEnterHooks.bulwark_climb_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local shield_extension = ScriptUnit.extension(unit, "shield_system")

	shield_extension:set_blocking(false)

	local slot_name = args.slot_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	visual_loadout_extension:unwield_slot(slot_name)
end

BtEnterHooks.unwield_slot = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local slot_name = args.slot_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	visual_loadout_extension:unwield_slot(slot_name)
end

BtEnterHooks.beast_of_nurgle_stagger_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local consumed_unit = behavior_component.consumed_unit

	if HEALTH_ALIVE[consumed_unit] then
		local consumed_unit_data_extension = ScriptUnit.extension(consumed_unit, "unit_data_system")
		local disabled_state_input = consumed_unit_data_extension:write_component("disabled_state_input")
		disabled_state_input.trigger_animation = "none"
		disabled_state_input.disabling_unit = nil
		behavior_component.wants_to_catapult_consumed_unit = true
	end
end

BtEnterHooks.poxwalker_bomber_death_enter = function (unit, breed, blackboard, scratchpad, action_data, t)
	local death_component = Blackboard.write_component(blackboard, "death")
	local fuse_timer = death_component.fuse_timer

	if fuse_timer > 0 and fuse_timer <= t then
		death_component.hit_zone_name = "center_mass"
		death_component.damage_profile_name = "default"
		death_component.herding_template_name = nil
	end
end

return BtEnterHooks
