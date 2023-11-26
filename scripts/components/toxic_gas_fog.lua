-- chunkname: @scripts/components/toxic_gas_fog.lua

local Component = require("scripts/utilities/component")
local NavQueries = require("scripts/utilities/nav_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local ToxicGasFog = component("ToxicGasFog")

ToxicGasFog.init = function (self, unit, is_server, nav_world)
	self._unit = unit

	local run_update = false

	self._is_server = is_server

	if rawget(_G, "LevelEditor") and ToxicGasFog._nav_info == nil then
		ToxicGasFog._nav_info = SharedNav.create_nav_info()

		local nav_gen_guid = SharedNav.check_new_navmesh_generated(ToxicGasFog._nav_info, self._my_nav_gen_guid, true)

		if nav_gen_guid then
			self._my_nav_gen_guid = nav_gen_guid

			self:_generate_liquid_positions(unit)
		end
	end

	return run_update
end

ToxicGasFog.destroy = function (self, unit)
	self:disable(unit)
end

ToxicGasFog.set_volume_enabled = function (self, enabled)
	if enabled and not self._volume_enabled then
		self:enable(self._unit)

		self._volume_enabled = true
	elseif self._volume_enabled then
		self:disable(self._unit)

		self._volume_enabled = false
	end

	if self._is_server and not rawget(_G, "LevelEditor") then
		Component.trigger_event_on_clients(self, enabled and "visibility_enable" or "visibility_disable")
	end
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
	if rawget(_G, "LevelEditor") then
		Volumetrics.unregister_volume(unit)
	elseif self._volume_enabled then
		Volumetrics.unregister_volume(unit)
	end
end

ToxicGasFog.events.visibility_enable = function (self, unit)
	self:set_volume_enabled(true)
end

ToxicGasFog.events.visibility_disable = function (self, unit)
	self:set_volume_enabled(false)
end

ToxicGasFog.hot_join_sync = function (self, joining_client, joining_channel)
	if self._volume_enabled then
		Component.hot_join_sync_event_to_client(joining_client, joining_channel, self, "visibility_enable")
	elseif self._volume_disabled then
		Component.hot_join_sync_event_to_client(joining_client, joining_channel, self, "visibility_disable")
	end
end

ToxicGasFog.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if ToxicGasFog._nav_info == nil then
		ToxicGasFog._nav_info = SharedNav.create_nav_info()

		local with_traverse_logic = true
		local nav_gen_guid = SharedNav.check_new_navmesh_generated(ToxicGasFog._nav_info, self._my_nav_gen_guid, with_traverse_logic)

		if nav_gen_guid then
			self._my_nav_gen_guid = nav_gen_guid

			self:_generate_liquid_positions(unit)
		end
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

ToxicGasFog.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_mesh(unit, "g_fog") then
		success = false
		error_message = error_message .. "\nMissing mesh 'g_fog'"
	end

	return success, error_message
end

ToxicGasFog.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	Volumetrics.unregister_volume(unit)

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

local NAV_TAG_LAYER_COSTS = {
	teleporters = 0,
	ledges_with_fence = 0,
	doors = 0,
	jumps = 0,
	ledges = 0,
	cover_ledges = 0,
	cover_vaults = 0,
	monster_walls = 0
}

ToxicGasFog.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")
	local with_traverse_logic = true
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(ToxicGasFog._nav_info, self._my_nav_gen_guid, with_traverse_logic, NAV_TAG_LAYER_COSTS)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		if draw_liquid then
			self:_generate_liquid_positions(unit)
		end
	end

	if draw_liquid and self._old_liquid_position then
		local distance = Vector3.distance(Unit.local_position(unit, 1), self._old_liquid_position:unbox())

		if distance > 0.25 then
			self:_generate_liquid_positions(unit)
		end
	end

	return true
end

ToxicGasFog._generate_liquid_positions = function (self, unit)
	local nav_world = ToxicGasFog._nav_info.nav_world

	if nav_world then
		local position = Unit.local_position(unit, 1)
		local max_liquid = self:get_data(unit, "max_liquid")
		local flood_fill_positions = {}
		local flood_fill_positions_boxed = {}
		local traverse_logic = ToxicGasFog._nav_info.traverse_logic
		local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, position, 1, 1, 1)

		if position_on_navmesh then
			local num_positions = GwNavQueries.flood_fill_from_position(nav_world, position_on_navmesh, 1, 1, max_liquid, flood_fill_positions, traverse_logic)

			for i = 1, num_positions do
				flood_fill_positions_boxed[#flood_fill_positions_boxed + 1] = Vector3Box(flood_fill_positions[i])
			end

			self._liquid_draw_positions = flood_fill_positions_boxed
			self._fail_liquid_position = nil
		else
			self._fail_liquid_position = Vector3Box(position)
		end

		self._old_liquid_position = Vector3Box(position)

		self:_editor_debug_draw(unit)
	end
end

ToxicGasFog.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid then
		self:_generate_liquid_positions(unit)
	end
end

ToxicGasFog._editor_debug_draw = function (self, unit)
	self._drawer:reset()

	if self._liquid_draw_positions then
		for i = 1, #self._liquid_draw_positions - 1 do
			local pos = self._liquid_draw_positions[i]:unbox()

			if self._fail_liquid_position then
				self._drawer:sphere(pos, 0.3, Color.red())
			else
				self._drawer:sphere(pos, 0.3, Color.lime())
			end
		end
	end

	if self._fail_liquid_position then
		self._drawer:sphere(self._fail_liquid_position:unbox(), 1, Color.red())
	end

	self._drawer:update(self._world)
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
	max_liquid = {
		ui_type = "slider",
		min = 0,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 130,
		decimals = 0,
		ui_name = "Max Liquid",
		max = 400
	},
	draw_liquid = {
		ui_type = "check_box",
		value = false,
		ui_name = "Draw Liquid",
		category = "Circumstance Gameplay Data"
	},
	trigger_clouds = {
		ui_type = "check_box",
		value = true,
		ui_name = "Trigger Clouds",
		category = "Circumstance Gameplay Data"
	},
	dont_trigger_this_cloud = {
		ui_type = "check_box",
		value = false,
		ui_name = "Don't trigger this cloud",
		category = "Circumstance Gameplay Data"
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
