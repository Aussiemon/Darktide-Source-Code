local projectile_templates = {}

local function _require_templates(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		projectile_templates[name] = template
	end
end

_require_templates("scripts/settings/projectile/minion_projectile_templates")
_require_templates("scripts/settings/projectile/player_projectile_templates")

for name, template in pairs(projectile_templates) do
	template.name = name
	template.same_side_suppression_enabled = false
	local impact_damage = template.damage.impact

	if impact_damage then
		-- Nothing
	end

	local fuse_damage = template.damage.fuse

	if fuse_damage then
		-- Nothing
	end

	if template.effects then
		for index, effect in ipairs(template.effects) do
			local vfx = effect.vfx

			if vfx then
				-- Nothing
			end

			local sfx = effect.sfx

			if sfx and not effect.looping_sound_event_name and effect.looping_sound_stop_event_name then
				-- Nothing
			end
		end
	end
end

return settings("ProjectileTemplates", projectile_templates)
