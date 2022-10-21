local FixedFrame = require("scripts/utilities/fixed_frame")
local MasterItems = require("scripts/backend/master_items")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ActionUtility = {
	has_ammunition = function (inventory_slot_component, action_settings)
		local ammunition_usage = action_settings.ammunition_usage

		if ammunition_usage then
			if ammunition_usage <= inventory_slot_component.current_ammunition_clip then
				return true
			elseif inventory_slot_component.current_ammunition_clip > 0 and action_settings.allow_shots_with_less_than_required_ammo then
				return true
			else
				return false
			end
		else
			return true
		end
	end
}
local EPSILON = 1e-05

ActionUtility.is_within_trigger_time = function (time_in_action, dt, first_trigger_time, trigger_intervall)
	local first_trigger_time_fixed = FixedFrame.clamp_to_fixed_time(first_trigger_time)
	local first_trigger_diff = math.abs(time_in_action - first_trigger_time_fixed)
	local first_trigger_frame = first_trigger_diff < EPSILON
	local past_first_trigger = not first_trigger_frame and first_trigger_time_fixed < time_in_action

	if first_trigger_frame then
		return true
	elseif past_first_trigger and trigger_intervall then
		local trigger_intervall_fixed = FixedFrame.clamp_to_fixed_time(trigger_intervall)
		local time_since_first_trigger_fixed = time_in_action - first_trigger_time_fixed
		local time_since_last_trigger = time_since_first_trigger_fixed % (trigger_intervall_fixed + dt)
		local trigger_diff = math.abs(time_since_last_trigger - trigger_intervall_fixed)
		local intervall_trigger_frame = trigger_diff < EPSILON

		if intervall_trigger_frame then
			return true
		end
	end

	return false
end

ActionUtility.get_projectile_template = function (action_settings, weapon_template, ability_extension)
	local fire_config = action_settings and action_settings.fire_configuration
	local fire_config_projectile_template = fire_config and fire_config.projectile

	if fire_config_projectile_template then
		return fire_config_projectile_template
	end

	local weapon_template_projectile_template = weapon_template and weapon_template.projectile_template

	if weapon_template_projectile_template then
		return weapon_template_projectile_template
	end

	local ability_item = action_settings and ability_extension and ActionUtility.get_ability_item(action_settings, ability_extension)
	local ability_weapon_template = ability_item and WeaponTemplate.weapon_template_from_item(ability_item)
	local ability_weapon_template_projectile_template = ability_weapon_template.projectile_template

	if ability_weapon_template_projectile_template then
		return ability_weapon_template_projectile_template
	end

	return nil
end

ActionUtility.get_ability_item = function (action_settings, ability_extension)
	local ability_type = action_settings.ability_type
	local equipped_abilities = ability_extension:equipped_abilities()
	local grenade_ability = equipped_abilities[ability_type]
	local inventory_item_name = grenade_ability.inventory_item_name
	local slot_name = ability_extension:get_slot_name(ability_type)
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[inventory_item_name]

	return item, slot_name
end

return ActionUtility
