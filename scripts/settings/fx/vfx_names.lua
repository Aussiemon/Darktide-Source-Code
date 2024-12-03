-- chunkname: @scripts/settings/fx/vfx_names.lua

local BreedShieldTemplates = require("scripts/settings/breed/breed_shield_templates")
local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local MinionToughnessTemplates = require("scripts/settings/toughness/minion_toughness_templates")
local vfx_names = {}

local function _add_vfx_names_from_explosion_templates(templates)
	for name, template in pairs(templates) do
		local scalable_vfx = template.scalable_vfx

		if scalable_vfx then
			for i = 1, #scalable_vfx do
				local data = scalable_vfx[i]
				local effects = data.effects

				for j = 1, #effects do
					local effect_name = effects[j]

					vfx_names[effect_name] = true
				end
			end
		end

		local vfx = template.vfx

		if vfx then
			for i = 1, #vfx do
				local vfx_name = vfx[i]

				vfx_names[vfx_name] = true
			end
		end
	end
end

_add_vfx_names_from_explosion_templates(ExplosionTemplates)

for name, template in pairs(BreedShootTemplates) do
	local shoot_vfx_name = template.shoot_vfx_name

	if shoot_vfx_name then
		vfx_names[shoot_vfx_name] = true
	end

	local line_vfx_name = template.line_vfx_name

	if line_vfx_name then
		vfx_names[line_vfx_name] = true
	end

	local scope_reflection_vfx_name = template.scope_reflection_vfx_name

	if scope_reflection_vfx_name then
		vfx_names[scope_reflection_vfx_name] = true
	end
end

for name, template in pairs(GroundImpactFxTemplates) do
	local materials = template.materials

	for _, data in pairs(materials) do
		local vfx = data.vfx

		if vfx then
			if type(vfx) == "table" then
				for i = 1, #vfx do
					local entry = vfx[i]

					vfx_names[entry] = true
				end
			else
				vfx_names[vfx] = true
			end
		end
	end
end

for name, template in pairs(MinionToughnessTemplates) do
	local depleted_settings = template.depleted_settings

	if depleted_settings then
		local vfx = depleted_settings.vfx

		if vfx then
			vfx_names[vfx] = true
		end
	end

	local reactivated_settings = template.reactivated_settings

	if reactivated_settings then
		local vfx = reactivated_settings.vfx

		if vfx then
			vfx_names[vfx] = true
		end
	end
end

for name, template in pairs(BreedShieldTemplates) do
	local vfx = template.open_up_vfx

	if vfx then
		vfx_names[vfx] = true
	end
end

for name, template in pairs(MinionPushFxTemplates) do
	local vfx = template.vfx

	if vfx then
		vfx_names[vfx] = true
	end
end

vfx_names["content/fx/particles/enemies/bolstering_shockwave"] = true
vfx_names["content/fx/particles/debug/fx_debug_1m_burst"] = true
vfx_names["content/fx/particles/impacts/flesh/nurgle_corruption_death"] = true
vfx_names["content/fx/particles/liquid_area/nurgle_buff_slime"] = true

return vfx_names
