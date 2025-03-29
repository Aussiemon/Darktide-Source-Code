-- chunkname: @scripts/settings/projectile/projectile_templates.lua

local ProjectileSettings = require("scripts/settings/projectile/projectile_settings")
local projectile_types = ProjectileSettings.projectile_types
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

	local projectil_type = template.projectile_type

	if projectil_type == nil then
		template.projectile_type = projectile_types.defaults
	end

	local item_name = template.item_name

	if item_name == nil then
		template.item_name = template.projectile_type == projectile_types.minion_grenade and "content/items/weapons/minions/ranged/renegade_grenade" or "content/items/weapons/player/grenade_frag"
	end

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
