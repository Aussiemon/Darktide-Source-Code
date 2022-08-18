local ability_templates = {}

local function _require_ability_templates(path_prefix, template_names)
	for i = 1, #template_names, 1 do
		local template_name = template_names[i]
		local full_path = string.format(path_prefix, template_name)
		local template_data = require(full_path)
		template_data.name = template_name
		ability_templates[template_name] = template_data
	end

	setmetatable(ability_templates, {
		__index = function (table, template_name)
			ferror("Archetype ability %q does not exist. Has it been added to ability_templates.lua?", template_name)
		end
	})
end

local path_prefix = "scripts/settings/ability/ability_templates/%s"
local template_names = {
	"base_shout",
	"base_combat_attack",
	"base_stance",
	"dash",
	"gunlugger_stance",
	"melee_stance",
	"ogryn_charge",
	"psyker_proximity_tag",
	"psyker_stance",
	"psyker_shout",
	"ranged_stance",
	"squad_leader_shout",
	"targeted_dash",
	"zealot_invisibility",
	"zealot_shout"
}

_require_ability_templates(path_prefix, template_names)

return settings("AbilityTemplates", ability_templates)
