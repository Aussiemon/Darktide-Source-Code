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

		if is_upwards or (smart_object_type and smart_object_type == "ledges_with_fence") then
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
	end,
	set_scratchpad_value = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local field = args.field
		local value = args.value
		scratchpad[field] = value
	end,
	captain_charge_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local phase_component = Blackboard.write_component(blackboard, "phase")
		phase_component.lock = true
	end,
	captain_grenade_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event("to_grenade")

		local phase_component = Blackboard.write_component(blackboard, "phase")
		phase_component.lock = true
	end,
	bulwark_climb_enter = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(false)

		local slot_name = args.slot_name
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		visual_loadout_extension:unwield_slot(slot_name)
	end,
	unwield_slot = function (unit, breed, blackboard, scratchpad, action_data, t, args)
		local slot_name = args.slot_name
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		visual_loadout_extension:unwield_slot(slot_name)
	end
}

return BtEnterHooks
