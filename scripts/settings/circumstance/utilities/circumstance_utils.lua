-- chunkname: @scripts/settings/circumstance/utilities/circumstance_utils.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local CircumstanceBuilder = {}

CircumstanceBuilder.inherit = function (templates, mutators, overrides, id, optional_old_id)
	local old_id = optional_old_id or "<ID>"
	local new_templates = {}

	for old_key, template in pairs(templates) do
		local new_template = table.clone(template)

		new_template.mutators = (new_template.mutators or mutators) and table.append(new_template.mutators or {}, mutators or {})
		new_template.mission_overrides = (new_template.mission_overrides or overrides) and MissionOverrides.append(new_template.mission_overrides or {}, unpack(overrides or {}))

		local new_key = old_key:gsub(old_id, id)

		new_templates[new_key] = new_template
	end

	return new_templates
end

CircumstanceBuilder.set_theme_tag = function (templates, theme_tag)
	for _, template in pairs(templates) do
		template.theme_tag = theme_tag
	end

	return templates
end

CircumstanceBuilder.set_wwise_state = function (templates, wwise_state)
	for _, template in pairs(templates) do
		template.wwise_state = wwise_state
	end

	return templates
end

CircumstanceBuilder.set_dialogue_id = function (templates, dialogue_id)
	for _, template in pairs(templates) do
		template.dialogue_id = dialogue_id
	end

	return templates
end

return CircumstanceBuilder
