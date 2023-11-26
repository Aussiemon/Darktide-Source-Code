-- chunkname: @scripts/settings/projectile_locomotion/projectile_locomotion_templates.lua

local projectile_locomotion_templates = {}

local function _extract_projectile_locomotion_templates(path)
	local locomotion_templates = require(path)

	for name, locomotion_data in pairs(locomotion_templates) do
		projectile_locomotion_templates[name] = locomotion_data
	end
end

_extract_projectile_locomotion_templates("scripts/settings/projectile_locomotion/templates/grenade_projectile_locomotion_templates")
_extract_projectile_locomotion_templates("scripts/settings/projectile_locomotion/templates/luggable_battery_projectile_locomotion_templates")
_extract_projectile_locomotion_templates("scripts/settings/projectile_locomotion/templates/minion_grenade_projectile_locomotion_templates")
_extract_projectile_locomotion_templates("scripts/settings/projectile_locomotion/templates/weapon_projectile_locomotion_templates")

for name, locomotion_data in pairs(projectile_locomotion_templates) do
	locomotion_data.name = name
end

return settings("ProjectileLocomotionTemplates", projectile_locomotion_templates)
