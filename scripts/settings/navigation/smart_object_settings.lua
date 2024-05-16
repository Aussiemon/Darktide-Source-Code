-- chunkname: @scripts/settings/navigation/smart_object_settings.lua

local minion_smart_object_templates = {}
local smart_object_settings = {
	jump_across_max_length = 8,
	jump_across_min_length = 3.5,
	jump_up_max_height = 5.1,
	templates = minion_smart_object_templates,
}

local function _create_template_entry(path)
	local template = require(path)
	local name = string.match(path, "^.+/(.+)_smart_object_template$")

	minion_smart_object_templates[name] = template
end

_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/fallback_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_beast_of_nurgle_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_daemonhost_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_hound_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_ogryn_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_plague_ogryn_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_poxwalker_bomber_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_poxwalker_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/chaos_spawn_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/cultist_mutant_smart_object_template")
_create_template_entry("scripts/settings/navigation/minion_smart_object_templates/renegade_smart_object_template")

return settings("SmartObjectSettings", smart_object_settings)
