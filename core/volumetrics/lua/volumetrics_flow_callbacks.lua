VolumetricsFlowCallbacks = VolumetricsFlowCallbacks or {}

VolumetricsFlowCallbacks.register_fog_volume = function (params)
	local unit = params.unit
	local albedo_r = stingray.Unit.get_data(unit, "FogProperties", "albedo", 1)
	local albedo_g = stingray.Unit.get_data(unit, "FogProperties", "albedo", 2)
	local albedo_b = stingray.Unit.get_data(unit, "FogProperties", "albedo", 3)
	local albedo = Vector3(albedo_r, albedo_g, albedo_b)
	local extinction = stingray.Unit.get_data(unit, "FogProperties", "extinction")
	local phase = stingray.Unit.get_data(unit, "FogProperties", "phase")
	local falloff_x = stingray.Unit.get_data(unit, "FogProperties", "falloff", 1)
	local falloff_y = stingray.Unit.get_data(unit, "FogProperties", "falloff", 2)
	local falloff_z = stingray.Unit.get_data(unit, "FogProperties", "falloff", 3)
	local falloff = Vector3(falloff_x, falloff_y, falloff_z)

	if unit then
		stingray.Volumetrics.register_volume(unit, albedo, extinction, phase, falloff)
	end
end

VolumetricsFlowCallbacks.unregister_fog_volume = function (params)
	local unit = params.unit

	if unit then
		stingray.Volumetrics.unregister_volume(unit)
	end
end

return
