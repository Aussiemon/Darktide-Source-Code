local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local explosion_templates = {}
local loaded_template_files = {}

local function _add_template_entries(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		fassert(explosion_templates[name] == nil, "[ExplosionTemplates] Duplicate entries of %s.", name)

		template.name = name
		explosion_templates[name] = template
	end
end

_add_template_entries("scripts/settings/damage/explosion_templates/minion_explosion_templates")
_add_template_entries("scripts/settings/damage/explosion_templates/player_explosion_templates")
_add_template_entries("scripts/settings/damage/explosion_templates/prop_explosion_templates")
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_explosion_templates", explosion_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_explosion_templates", explosion_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_explosion_templates", explosion_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_explosion_templates", explosion_templates, loaded_template_files)

for name, template in pairs(explosion_templates) do
	fassert(template.radius, "Explosion template [\"%s\"] is missing 'radius' setting", name)

	if template.min_radius then
	end

	fassert(template.damage_profile, "Explosion template [\"%s\"] is missing 'damage_profile' setting", name)

	if template.close_radius then
		fassert(template.close_damage_profile, "Explosion template [\"%s\"] with close_radius is missing 'close_damage_profile' setting", name)
	end

	if template.static_power_level then
		fassert(type(template.static_power_level) == "number", "Explosion template [\"%s\"] needs 'static_power_level' to be a number", name)
	end

	local scalable_vfx = template.scalable_vfx

	if scalable_vfx then
		for i = #scalable_vfx, 1, -1 do
			local vfx_data = scalable_vfx[i]

			fassert(vfx_data.radius_variable_name, "Scalable VFX for explosion template [\"%s\"] has no 'radius_variable_name' defined", name)
			fassert(type(vfx_data.radius_variable_name) == "string", "'radius_variable_name' in scalable VFX for explosion template [\"%s\"] is not a string", name)
			fassert(vfx_data.min_radius, "Scalable VFX for explosion template [\"%s\"] has no 'min_radius' defined", name)
			fassert(type(vfx_data.min_radius) == "number", "'min_radius' in scalable VFX for explosion template [\"%s\"] is not a number", name)
		end

		table.sort(scalable_vfx, function (a, b)
			return a.min_radius < b.min_radius
		end)

		template.scalable_vfx = scalable_vfx
	end
end

return settings("ExplosionTemplates", explosion_templates)
