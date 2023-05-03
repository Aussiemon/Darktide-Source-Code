local ToxicGasFog = component("ToxicGasFog")

ToxicGasFog.init = function (self, unit, is_server, nav_world)
	self._unit = unit
	local run_update = false

	return run_update
end

ToxicGasFog.destroy = function (self, unit)
	self:disable(unit)
end

ToxicGasFog.set_volume_enabled = function (self, enabled)
	if enabled then
		self:enable(self._unit)
	else
		self:disable(self._unit)
	end

	self._volume_enabled = enabled
end

ToxicGasFog.enable = function (self, unit)
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

ToxicGasFog.disable = function (self, unit)
	if self._volume_enabled then
		Volumetrics.unregister_volume(unit)
	end
end

ToxicGasFog.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit
	local world = Application.main_world()
	self._world = world
	local line_object = World.create_line_object(world)
	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)

	self:set_volume_enabled(true)

	return true
end

ToxicGasFog.editor_toggle_visibility_state = function (self, visible)
	if visible and not self._volume_enabled then
		self:set_volume_enabled(true)
	elseif not visible and self._volume_enabled then
		self:set_volume_enabled(false)
	end
end

ToxicGasFog.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world
	local gui = self._gui

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)
	end

	if self._section_debug_text_id then
		Gui.destroy_text_3d(gui, self._section_debug_text_id)
	end

	World.destroy_gui(world, gui)

	self._line_object = nil
	self._world = nil
end

ToxicGasFog.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

ToxicGasFog._editor_debug_draw = function (self, unit)
	return
end

ToxicGasFog.component_data = {
	id = {
		ui_type = "number",
		min = 1,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 1,
		ui_name = "ID",
		max = 100
	},
	section = {
		ui_type = "number",
		min = 1,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 1,
		ui_name = "Section ID",
		max = 50
	},
	albedo = {
		ui_type = "vector",
		ui_name = "Albedo",
		category = "Fog Properties",
		value = Vector3Box(0.1, 0.1, 0.1)
	},
	falloff = {
		ui_type = "vector",
		ui_name = "Falloff",
		category = "Fog Properties",
		value = Vector3Box(0, 0, 0)
	},
	extinction = {
		ui_type = "number",
		min = 0,
		step = 0.001,
		category = "Fog Properties",
		value = 0.01,
		decimals = 3,
		ui_name = "Extinction",
		max = 1
	},
	phase = {
		ui_type = "number",
		min = 0,
		decimals = 1,
		category = "Fog Properties",
		value = 0,
		ui_name = "Phase",
		step = 0.1
	}
}

return ToxicGasFog
