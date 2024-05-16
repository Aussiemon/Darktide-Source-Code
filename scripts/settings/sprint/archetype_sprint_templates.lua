-- chunkname: @scripts/settings/sprint/archetype_sprint_templates.lua

local archetype_sprint_templates = {}

archetype_sprint_templates.default = {
	sprint_move_speed = 5.2,
}
archetype_sprint_templates.ogryn = {
	sprint_move_speed = 5,
}
archetype_sprint_templates.psyker = {
	sprint_move_speed = 5,
}

return settings("ArchetypeSprintTemplates", archetype_sprint_templates)
