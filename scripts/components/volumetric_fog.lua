-- chunkname: @scripts/components/volumetric_fog.lua

local VolumetricFog = component("VolumetricFog")

VolumetricFog.init = function (self, unit)
	self:enable(unit)
end

VolumetricFog.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_mesh(unit, "g_fog") then
		success = false
		error_message = error_message .. "\nMissing mesh 'g_fog'"
	end

	return success, error_message
end

VolumetricFog.enable = function (self, unit)
	local mesh = Unit.mesh(unit, "g_fog")
	local material = Mesh.material(mesh, "mtr_fog")
	local extinction = self:get_data(unit, "extinction")

	Material.set_scalar(material, "height_fog_extinction", extinction)

	local phase = self:get_data(unit, "phase")

	Material.set_scalar(material, "height_fog_phase", phase)

	local falloff = self:get_data(unit, "falloff"):unbox()

	Material.set_vector3(material, "height_fog_falloff", falloff)

	local albedo = self:get_data(unit, "albedo"):unbox()

	Material.set_vector3(material, "height_fog_color", albedo)
	Volumetrics.register_volume(unit, albedo, extinction, phase, falloff)
end

VolumetricFog.disable = function (self, unit)
	Volumetrics.unregister_volume(unit)
end

VolumetricFog.destroy = function (self, unit)
	self:disable(unit)
end

VolumetricFog.component_data = {
	albedo = {
		Category = "Fog Properties",
		ui_name = "Albedo",
		ui_type = "vector",
		value = Vector3Box(0.1, 0.1, 0.1),
	},
	falloff = {
		Category = "Fog Properties",
		ui_name = "Falloff",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	extinction = {
		Category = "Fog Properties",
		decimals = 3,
		max = 1,
		min = 0,
		step = 0.001,
		ui_name = "Extinction",
		ui_type = "number",
		value = 0.01,
	},
	phase = {
		Category = "Fog Properties",
		decimals = 1,
		min = 0,
		step = 0.1,
		ui_name = "Phase",
		ui_type = "number",
		value = 0,
	},
}

return VolumetricFog
