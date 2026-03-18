-- chunkname: @scripts/utilities/smart_targeting.lua

local AbilityTemplate = require("scripts/utilities/ability/ability_template")
local Action = require("scripts/utilities/action/action")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SmartTargeting = {}

local function _timed_smart_targeting_template(t, weapon_action_component, action_settings)
	local timed_smart_targeting_template = action_settings.timed_smart_targeting_template
	local start_t = weapon_action_component.start_t or t
	local time_in_action = t - start_t

	if timed_smart_targeting_template then
		local default_template = timed_smart_targeting_template.default
		local num_timed_smart_targeting_template = #timed_smart_targeting_template

		for ii = 1, num_timed_smart_targeting_template do
			local segment = timed_smart_targeting_template[ii]

			if time_in_action < segment.t then
				return segment.template
			end
		end

		return default_template
	end
end

SmartTargeting.smart_targeting_template = function (t, weapon_action_component, combat_ability_action_component, grenade_ability_action_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
	local combat_ability_template = AbilityTemplate.current_ability_template(combat_ability_action_component)
	local combat_ability_actions = combat_ability_template and combat_ability_template.actions
	local current_combat_ability_action = combat_ability_actions and combat_ability_actions[combat_ability_action_component.current_action_name]
	local grenade_ability_template = AbilityTemplate.current_ability_template(grenade_ability_action_component)
	local grenade_ability_actions = grenade_ability_template and grenade_ability_template.actions
	local current_grenade_ability_action = grenade_ability_actions and grenade_ability_actions[grenade_ability_action_component.current_action_name]
	local wanted_smart_targeting_template

	if action_settings then
		wanted_smart_targeting_template = _timed_smart_targeting_template(t, weapon_action_component, action_settings)
		wanted_smart_targeting_template = wanted_smart_targeting_template or action_settings.smart_targeting_template
	end

	local weapon_smart_targeting_template = weapon_template and weapon_template.smart_targeting_template
	local combat_ability_smart_targeting_template = current_combat_ability_action and current_combat_ability_action.smart_targeting_template
	local grenade_ability_smart_targeting_template = current_grenade_ability_action and current_grenade_ability_action.smart_targeting_template

	return wanted_smart_targeting_template or combat_ability_smart_targeting_template or grenade_ability_smart_targeting_template or weapon_smart_targeting_template
end

return SmartTargeting
