-- chunkname: @scripts/components/wwise_emitter_occlusion.lua

local WwiseEmitterOcclusion = component("WwiseEmitterOcclusion")

WwiseEmitterOcclusion.init = function (self, unit)
	self:enable(unit)

	self._unit = unit

	local world = Unit.world(unit)
	local wwise_world = Wwise.wwise_world(world)

	self._wwise_world = wwise_world
	self._sound_obstructor_id = nil

	local occlusion_value = self:get_data(unit, "occlusion_value")
	local acoustic_texture = self:get_data(unit, "acoustic_texture")

	self._sound_obstructor_id = WwiseWorld.add_sound_obstructor_unit(wwise_world, unit, occlusion_value, acoustic_texture)
end

WwiseEmitterOcclusion.destroy = function (self, unit)
	local wwise_world = self._wwise_world
	local sound_obstructor_id = self._sound_obstructor_id

	WwiseWorld.remove_sound_obstructor_unit(wwise_world, sound_obstructor_id)
end

WwiseEmitterOcclusion.editor_init = function (self, unit)
	self:enable(unit)
end

WwiseEmitterOcclusion.editor_validate = function (self, unit)
	return true, ""
end

WwiseEmitterOcclusion.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

WwiseEmitterOcclusion.enable = function (self, unit)
	return
end

WwiseEmitterOcclusion.disable = function (self, unit)
	return
end

WwiseEmitterOcclusion.component_data = {
	occlusion_value = {
		ui_type = "slider",
		min = 0,
		decimals = 2,
		max = 1,
		value = 0.5,
		ui_name = "Blocked Time (in %)",
		step = 0.01
	},
	acoustic_texture = {
		value = "brick",
		ui_type = "combo_box",
		ui_name = "Type",
		options_keys = {
			"brick"
		},
		options_values = {
			"brick"
		}
	}
}

return WwiseEmitterOcclusion
