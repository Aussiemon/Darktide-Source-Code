-- chunkname: @scripts/utilities/ailment.lua

local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local MATERIAL_KEY = "offset_time_duration"
local ailment_effect_templates = AilmentSettings.effect_templates
local Ailment = {}
local _apply_ailment_effect

Ailment.play_ailment_effect_template = function (unit, ailment_effect, optional_include_children, optional_custom_duration, optional_custom_offset_time)
	local template = ailment_effect_templates[ailment_effect]
	local material_textures_or_nil = template.material_textures
	local duration = optional_custom_duration or template.duration
	local offset_time = optional_custom_offset_time or template.offset_time
	local start_time = World.time(Unit.world(unit))

	_apply_ailment_effect(unit, offset_time, start_time, duration, material_textures_or_nil, optional_include_children)
end

function _apply_ailment_effect(unit, offset_time, start_time, duration, material_textures_or_nil, optional_include_children)
	if material_textures_or_nil then
		for _, data in pairs(material_textures_or_nil) do
			local slot = data.slot
			local resource = data.resource

			Unit.set_texture_for_materials(unit, slot, resource, optional_include_children)
		end
	end

	local effect_data = Vector3(offset_time, start_time, duration)

	Unit.set_vector3_for_materials(unit, MATERIAL_KEY, effect_data, optional_include_children)
end

return Ailment
