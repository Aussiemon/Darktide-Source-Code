-- chunkname: @scripts/utilities/smart_targeting.lua

local Action = require("scripts/utilities/weapon/action")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SmartTargeting = {}

SmartTargeting.smart_targeting_template = function (t, weapon_action_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
	local smart_targeting_template

	if action_settings then
		local template = action_settings.smart_targeting_template
		local timed_templates = action_settings.timed_smart_targeting_template
		local start_t = weapon_action_component.start_t or t
		local time_in_action = t - start_t

		if timed_templates then
			local default_template = timed_templates.default
			local num_timed_templates = #timed_templates

			for ii = 1, num_timed_templates do
				local segment = timed_templates[ii]

				if time_in_action < segment.t then
					smart_targeting_template = segment.template

					break
				end
			end

			smart_targeting_template = smart_targeting_template or default_template
		elseif template then
			smart_targeting_template = template
		else
			smart_targeting_template = weapon_template.smart_targeting_template
		end
	elseif weapon_template then
		smart_targeting_template = weapon_template.smart_targeting_template
	end

	return smart_targeting_template
end

return SmartTargeting
