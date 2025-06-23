-- chunkname: @scripts/settings/lunge/lunge_templates.lua

local lunge_templates = {}

local function _add_lunge_templates(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		template.name = name

		local entry = template

		lunge_templates[name] = entry
	end
end

_add_lunge_templates("scripts/settings/lunge/zealot_lunge_templates")
_add_lunge_templates("scripts/settings/lunge/ogryn_lunge_templates")
_add_lunge_templates("scripts/settings/lunge/adamant_lunge_templates")

return settings("LungeTemplates", lunge_templates)
