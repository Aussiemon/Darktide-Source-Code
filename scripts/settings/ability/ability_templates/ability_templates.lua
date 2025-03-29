-- chunkname: @scripts/settings/ability/ability_templates/ability_templates.lua

local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local ability_templates = {}

local function _require_ability_templates(path_prefix, template_names)
	for i = 1, #template_names do
		local template_name = template_names[i]
		local full_path = string.format(path_prefix, template_name)
		local template_data = require(full_path)

		template_data.name = template_name
		ability_templates[template_name] = template_data
	end

	setmetatable(ability_templates, {
		__index = function (table, template_name)
			ferror("Archetype ability %q does not exist. Has it been added to ability_templates.lua?", template_name)
		end,
	})
end

local template_names = {}

for _, ability in pairs(PlayerAbilities) do
	template_names[#template_names + 1] = ability.ability_template
end

local path_prefix = "scripts/settings/ability/ability_templates/%s"

_require_ability_templates(path_prefix, template_names)

return settings("AbilityTemplates", ability_templates)
