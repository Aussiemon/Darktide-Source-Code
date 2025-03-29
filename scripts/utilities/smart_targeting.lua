-- chunkname: @scripts/utilities/smart_targeting.lua

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

SmartTargeting.smart_targeting_template = function (t, weapon_action_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
	local wanted_smart_targeting_template

	if action_settings then
		wanted_smart_targeting_template = _timed_smart_targeting_template(t, weapon_action_component, action_settings)
		wanted_smart_targeting_template = wanted_smart_targeting_template or action_settings.smart_targeting_template
	end

	return wanted_smart_targeting_template or weapon_template and weapon_template.smart_targeting_template
end

return SmartTargeting
