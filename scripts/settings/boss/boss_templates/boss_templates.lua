local boss_templates = {}

local function _create_boss_template_entry(path)
	local boss_template = require(path)
	local boss_template_name = boss_template.name
	boss_templates[boss_template_name] = boss_template
end

_create_boss_template_entry("scripts/settings/boss/boss_templates/chaos_daemonhost_boss_template")
_create_boss_template_entry("scripts/settings/boss/boss_templates/chaos_beast_of_nurgle_boss_template")
_create_boss_template_entry("scripts/settings/boss/boss_templates/chaos_spawn_boss_template")

return settings("BossTemplates", boss_templates)
