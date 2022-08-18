local projectile_templates = {}

local function _require_templates(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		fassert(not projectile_templates[name], "Projectile template %q already exists!", name)

		projectile_templates[name] = template
	end
end

_require_templates("scripts/settings/projectile/minion_projectile_templates")
_require_templates("scripts/settings/projectile/player_projectile_templates")

for name, template in pairs(projectile_templates) do
	template.name = name
	template.same_side_suppression_enabled = false

	fassert(template.damage, "Projectile template [\"%s\"] is missing 'damage' setting", name)

	local impact_damage = template.damage.impact

	if impact_damage then
		fassert(impact_damage.damage_profile, "Projectile template [\"%s\"] is missing 'damage_profile' setting under 'damage.impact'", name)
	end

	local fuse_damage = template.damage.fuse

	if fuse_damage then
		fassert(fuse_damage.fuse_time, "Projectile template [\"%s\"] is missing 'fuse_time' setting under 'damage.fuse'", name)
	end

	if template.effects then
		for index, effect in ipairs(template.effects) do
			local vfx = effect.vfx

			if vfx then
				fassert(effect.particle_name, "Projectile template [\"%s\"] is missing 'particle_name' setting under 'vfx", name)
				fassert(effect.orphaned_policy, "Projectile template [\"%s\"] is missing 'orphaned_policy' setting under 'vfx", name)
				fassert(effect.orphaned_policy == "destroy" or effect.orphaned_policy == "stop", "Projectile template [\"%s\"] has invalid setting 'orphaned_policy' \"%s\". Valid options are \"destroy\" and \"stop\"", name, tostring(effect.orphaned_policy))
			end

			local sfx = effect.sfx

			if sfx and (effect.looping_sound_event_name or effect.looping_sound_stop_event_name) then
				fassert(effect.looping_sound_event_name and effect.looping_sound_stop_event_name, "Projectile template [\"%s\"] needs to have both 'looping_sound_event_name' and 'looping_sound_stop_event_name' setting under 'sfx if one of them is defined", name)
			end
		end
	end
end

return settings("ProjectileTemplates", projectile_templates)
