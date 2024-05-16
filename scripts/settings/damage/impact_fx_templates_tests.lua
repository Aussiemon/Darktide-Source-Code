-- chunkname: @scripts/settings/damage/impact_fx_templates_tests.lua

local IMPACT_FX_INTERFACE = {
	blood_ball = true,
	decal = true,
	linked_decal = true,
	material_switch_sfx = true,
	material_switch_sfx_husk = true,
	name = true,
	sfx = true,
	sfx_1p = true,
	sfx_1p_direction_interface = true,
	sfx_3p = true,
	sfx_husk = true,
	unit = true,
	vfx = true,
	vfx_1p = true,
	vfx_3p = true,
}
local success

local function _validate(full_message, test, this_message, ...)
	if not test then
		success = false

		local new_message = full_message .. "\n" .. string.format(this_message, ...)

		return new_message
	end

	return full_message
end

local function test(impact_fx_templates)
	success = true

	local error_msg = "One or more impact FX templates failed validation:"

	for name, impact_fx in pairs(impact_fx_templates) do
		for key, value in pairs(impact_fx) do
			error_msg = _validate(error_msg, IMPACT_FX_INTERFACE[key], "%q contains unknown key %q. If this is intended, add it to the interface in impact_fx_templates_tests.lua", name, key)
		end

		local vfx = impact_fx.vfx

		if vfx then
			error_msg = _validate(error_msg, type(vfx) == "table", "%q: vfx needs to be a table.", name)

			local num_vfx = #vfx

			for i = 1, num_vfx do
				local entry = vfx[i]

				error_msg = _validate(error_msg, entry.effects, "%q: entry %d for vfx needs to have 'effects' entry defined", name, i)
				error_msg = _validate(error_msg, not entry.effects.normal_rotation, "%q: entry %d has 'normal_rotation' defined inside 'effects' table. Move it to the parent.", name, i)
				error_msg = _validate(error_msg, not entry.effects.reverse, "%q: entry %d has 'reverse' defined inside 'effects' table. Move it to the parent.", name, i)
			end
		end

		local vfx_1p = impact_fx.vfx_1p

		if vfx_1p then
			error_msg = _validate(error_msg, type(vfx_1p) == "table", "%q: vfx_1p needs to be a table.", name)

			local num_vfx_1p = #vfx_1p

			for i = 1, num_vfx_1p do
				local entry = vfx_1p[i]

				error_msg = _validate(error_msg, entry.effects, "%q: entry %d for vfx needs to have 'effects' entry defined", name, i)
				error_msg = _validate(error_msg, not entry.effects.normal_rotation, "%q: entry %d has 'normal_rotation' defined inside 'effects' table. Move it to the parent.", name, i)
				error_msg = _validate(error_msg, not entry.effects.reverse, "%q: entry %d has 'reverse' defined inside 'effects' table. Move it to the parent.", name, i)
			end
		end

		local vfx_3p = impact_fx.vfx_3p

		if vfx_3p then
			error_msg = _validate(error_msg, type(vfx_3p) == "table", "%q: vfx_3p needs to be a table.", name)

			local num_vfx_3p = #vfx_3p

			for i = 1, num_vfx_3p do
				local entry = vfx_3p[i]

				error_msg = _validate(error_msg, entry.effects, "%q: entry %d for vfx needs to have 'effects' entry defined", name, i)
				error_msg = _validate(error_msg, not entry.effects.normal_rotation, "%q: entry %d has 'normal_rotation' defined inside 'effects' table. Move it to the parent.", name, i)
				error_msg = _validate(error_msg, not entry.effects.reverse, "%q: entry %d has 'reverse' defined inside 'effects' table. Move it to the parent.", name, i)
			end
		end

		local sfx = impact_fx.sfx

		if sfx then
			error_msg = _validate(error_msg, type(sfx) == "table", "%q: sfx needs to be a table.", name)
		end

		local sfx_1p = impact_fx.sfx_1p

		if sfx_1p then
			error_msg = _validate(error_msg, type(sfx_1p) == "table", "%q: sfx_1p needs to be a table.", name)
		end

		local sfx_3p = impact_fx.sfx_3p

		if sfx_3p then
			error_msg = _validate(error_msg, type(sfx_3p) == "table", "%q: sfx_3p needs to be a table.", name)
		end

		local material_switch_sfx = impact_fx.material_switch_sfx

		if material_switch_sfx then
			error_msg = _validate(error_msg, type(material_switch_sfx) == "table", "%q: material_switch_sfx needs to be a table.", name)

			local num_material_switch_sfx = #material_switch_sfx

			for i = 1, num_material_switch_sfx do
				error_msg = _validate(error_msg, material_switch_sfx[i].event, "%q: entry %d for material_switch_sfx needs to have 'event' entry defined", name, i)
				error_msg = _validate(error_msg, material_switch_sfx[i].group, "%q: entry %d for material_switch_sfx needs to have 'group' entry defined", name, i)
			end
		end

		local decal = impact_fx.decal

		if decal then
			error_msg = _validate(error_msg, type(decal) == "table", "%q: decal needs to be a table.", name)

			local extents = decal.extents
			local uniform_extents = decal.uniform_extents

			if extents then
				error_msg = _validate(error_msg, type(extents) == "table", "%q: extents needs to be a table.", name)
				error_msg = _validate(error_msg, extents.min, "%q: extents needs to have a 'min' entry defined.", name)
				error_msg = _validate(error_msg, extents.max, "%q: extents needs to have a 'max' entry defined.", name)
				error_msg = _validate(error_msg, type(extents.min) == "table", "%q: min needs to be a table.", name)
				error_msg = _validate(error_msg, type(extents.max) == "table", "%q: max needs to be a table.", name)
				error_msg = _validate(error_msg, extents.min.x, "%q: min needs to have a 'x' entry defined.", name)
				error_msg = _validate(error_msg, extents.min.y, "%q: min needs to have a 'y' entry defined.", name)
				error_msg = _validate(error_msg, extents.max.x, "%q: max needs to have a 'x' entry defined.", name)
				error_msg = _validate(error_msg, extents.max.y, "%q: max needs to have a 'y' entry defined.", name)
			elseif uniform_extents then
				error_msg = _validate(error_msg, type(uniform_extents) == "table", "%q: uniform_extents needs to be a table.", name)
				error_msg = _validate(error_msg, uniform_extents.min, "%q: uniform_extents needs to have a 'min' entry defined.", name)
				error_msg = _validate(error_msg, uniform_extents.max, "%q: uniform_extents needs to have a 'max' entry defined.", name)
			end

			error_msg = _validate(error_msg, extents or uniform_extents, "%q: decal needs to have an 'extents' or 'uniform_extents' entry defined.", name)
			error_msg = _validate(error_msg, extents and not uniform_extents or not extents and uniform_extents, "%q: decal cannot have both 'extents' and 'uniform_extents' defined.", name)
			error_msg = _validate(error_msg, decal.units, "%q: decal needs to have an 'units' entry defined.", name)
			error_msg = _validate(error_msg, type(decal.units) == "table", "%q: units needs to be a table.", name)
		end
	end

	return success, error_msg
end

return test
