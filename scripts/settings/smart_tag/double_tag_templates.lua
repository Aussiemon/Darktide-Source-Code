-- chunkname: @scripts/settings/smart_tag/double_tag_templates.lua

local templates = {}

local function _create_entry(path)
	local entry_templates = require(path)

	for name, template in pairs(entry_templates) do
		templates[name] = template
	end
end

_create_entry("scripts/settings/smart_tag/double_tag/adamant_double_tag_templates")
_create_entry("scripts/settings/smart_tag/double_tag/cryptic_double_tag_templates")

return settings("DoubleTagTemplates", templates)
