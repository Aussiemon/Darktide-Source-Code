local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local explosion_templates = {}
local loaded_template_files = {}

local function _add_template_entries(path)
	local templates = require(path)

	for name, template in pairs(templates) do
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
	if template.min_radius then
		-- Nothing
	end

	if template.close_radius then
		-- Nothing
	end

	if template.static_power_level then
		-- Nothing
	end

	local scalable_vfx = template.scalable_vfx

	if scalable_vfx then
		for i = #scalable_vfx, 1, -1 do
			local vfx_data = scalable_vfx[i]
		end

		table.sort(scalable_vfx, function (a, b)
			return a.min_radius < b.min_radius
		end)

		template.scalable_vfx = scalable_vfx
	end
end

for name, explosion_template in pairs(explosion_templates) do
	explosion_template.name = name
end

return settings("ExplosionTemplates", explosion_templates)
