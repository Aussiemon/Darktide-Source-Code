local VolumetricFog = component("VolumetricFog")

VolumetricFog.init = function (self, unit)
	self:enable(unit)
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
		ui_type = "vector",
		ui_name = "Albedo",
		Category = "Fog Properties",
		value = Vector3Box(0.1, 0.1, 0.1)
	},
	falloff = {
		ui_type = "vector",
		ui_name = "Falloff",
		Category = "Fog Properties",
		value = Vector3Box(0, 0, 0)
	},
	extinction = {
		ui_type = "number",
		min = 0,
		step = 0.001,
		Category = "Fog Properties",
		value = 0.01,
		decimals = 3,
		ui_name = "Extinction",
		max = 1
	},
	phase = {
		ui_type = "number",
		min = 0,
		decimals = 1,
		Category = "Fog Properties",
		value = 0,
		ui_name = "Phase",
		step = 0.1
	}
}

return VolumetricFog
