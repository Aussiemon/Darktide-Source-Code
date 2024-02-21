local UNIT_NAME = "content/smoke_fog/empty_unit/empty_unit"
local UNIT_TEMPLATE = "smoke_fog"
local SmokeFogAreaSpawner = component("SmokeFogAreaSpawner")

SmokeFogAreaSpawner.init = function (self, unit, is_server, nav_world)
	self._unit = unit
	self._nav_world = nav_world
	local run_update = false
	self._is_server = is_server
	self._inner_radius = self:get_data(unit, "inner_radius")
	self._outer_radius = self:get_data(unit, "outer_radius")
	self._draw_smoke_fog = self:get_data(unit, "draw_smoke_fog")
	self._spawned_liquid_units = {}

	return run_update
end

SmokeFogAreaSpawner.destroy = function (self, unit)
	return
end

SmokeFogAreaSpawner.enable = function (self, unit)
	return
end

SmokeFogAreaSpawner.disable = function (self, unit)
	return
end

SmokeFogAreaSpawner.spawn_smoke_fog = function (self)
	if not self._is_server then
		return
	end

	local unit_name = UNIT_NAME
	local husk_unit_name = UNIT_NAME
	local unit_template = UNIT_TEMPLATE
	local unit = self._unit
	local position = POSITION_LOOKUP[unit]
	local rotation = Quaternion.identity()
	local material, placed_on_unit, owner_unit = nil
	local unit_template_parameters = {
		in_fog_buff_template_name = "in_smoke_fog",
		leaving_fog_buff_template_name = "left_smoke_fog",
		block_line_of_sight = true,
		duration = math.huge,
		inner_radius = self._inner_radius,
		outer_radius = self._outer_radius
	}
	local smoke_fog_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, husk_unit_name, placed_on_unit, owner_unit, unit_template_parameters)
	self._smoke_fog_spawned = true
	self._spawned_unit = smoke_fog_unit
end

SmokeFogAreaSpawner.despawn_smoke_fog = function (self)
	if not self._is_server then
		return
	end

	if self._smoke_fog_spawned then
		Managers.state.unit_spawner:mark_for_deletion(self._spawned_unit)

		self._smoke_fog_spawned = nil
		self._spawned_unit = nil
	end
end

SmokeFogAreaSpawner.hot_join_sync = function (self, joining_client, joining_channel)
	return
end

SmokeFogAreaSpawner.editor_init = function (self, unit)
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
	self._old_gizmo_position = Vector3Box(Unit.world_position(unit, 1))

	return true
end

SmokeFogAreaSpawner.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

SmokeFogAreaSpawner.editor_destroy = function (self, unit)
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

SmokeFogAreaSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_smoke_fog = self:get_data(unit, "draw_smoke_fog")

	if draw_smoke_fog then
		local new_position = Unit.world_position(unit, 1)
		local distance = Vector3.distance(new_position, self._old_gizmo_position:unbox())

		if distance > 0.25 then
			self._old_gizmo_position:store(new_position)
			self:_editor_debug_draw(unit)
		end
	end

	return true
end

SmokeFogAreaSpawner.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_smoke_fog = self:get_data(unit, "draw_smoke_fog")

	if draw_smoke_fog then
		self._old_gizmo_position:store(Unit.world_position(unit, 1))
		self:_editor_debug_draw(unit)
	end
end

SmokeFogAreaSpawner._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()
	drawer:sphere(self._old_gizmo_position:unbox(), self:get_data(unit, "inner_radius"), Color.magenta())
	drawer:sphere(self._old_gizmo_position:unbox(), self:get_data(unit, "outer_radius"), Color.cyan())
	drawer:update(self._world)
end

SmokeFogAreaSpawner.component_data = {
	inner_radius = {
		ui_type = "number",
		min = 0,
		step = 0.1,
		category = "Radius",
		value = 4.5,
		decimals = 1,
		ui_name = "Inner",
		max = 100
	},
	outer_radius = {
		ui_type = "number",
		min = 0,
		step = 0.1,
		category = "Radius",
		value = 5.5,
		decimals = 1,
		ui_name = "Outer",
		max = 100
	},
	draw_smoke_fog = {
		ui_type = "check_box",
		value = false,
		ui_name = "Draw Smoke (Approx)",
		category = "Debug"
	},
	inputs = {
		spawn_smoke_fog = {
			accessibility = "public",
			type = "event"
		},
		despawn_smoke_fog = {
			accessibility = "public",
			type = "event"
		}
	}
}

return SmokeFogAreaSpawner
