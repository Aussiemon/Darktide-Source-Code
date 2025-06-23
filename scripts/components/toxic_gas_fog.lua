-- chunkname: @scripts/components/toxic_gas_fog.lua

local Component = require("scripts/utilities/component")
local NavQueries = require("scripts/utilities/nav_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local ToxicGasFog = component("ToxicGasFog")

ToxicGasFog.init = function (self, unit, is_server, nav_world)
	local run_update = true

	return run_update
end

ToxicGasFog.destroy = function (self, unit)
	self:disable(unit)
end

ToxicGasFog.set_volume_enabled = function (self, enabled)
	if enabled and not self._volume_enabled then
		self:enable(self.unit)

		self._volume_enabled = true
	elseif self._volume_enabled then
		self:disable(self.unit)

		self._volume_enabled = false
	end

	if self.is_server and not rawget(_G, "LevelEditor") then
		Component.trigger_event_on_clients(self, enabled and "visibility_enable" or "visibility_disable")
	end
end

local FADE_IN_TIME = 1
local MESH_NAME = "g_fog"

ToxicGasFog.enable = function (self, unit)
	local mesh = Unit.mesh(unit, MESH_NAME)
	local material = Mesh.material(mesh, "mtr_fog")

	self._material = material

	local extinction = self:get_data(unit, "extinction")

	Material.set_scalar(material, "height_fog_extinction", extinction)

	local phase = self:get_data(unit, "phase")

	Material.set_scalar(material, "height_fog_phase", phase)

	local falloff = self:get_data(unit, "falloff"):unbox()

	Material.set_vector3(material, "height_fog_falloff", falloff)

	local albedo = self:get_data(unit, "albedo"):unbox()

	Material.set_vector3(material, "height_fog_color", albedo)
	Volumetrics.register_volume(unit, albedo, extinction, phase, falloff, MESH_NAME)

	if not self._particle_created then
		Unit.flow_event(unit, "create_particle")

		self._particle_created = true
	end

	self._volume_registered = true
	self._fade_in_time = FADE_IN_TIME
end

ToxicGasFog.update = function (self, unit, dt, t)
	if not self._volume_registered then
		self._fade_time = nil
		self._start_fade_time = nil

		return true
	end

	if self._fade_in_time then
		self._fade_in_time = self._fade_in_time - dt

		if self._fade_in_time <= 0 then
			self._fade_in_time = nil

			self:_update_volume_percentage(unit, 1)
		else
			local percentage = (FADE_IN_TIME - self._fade_in_time) / FADE_IN_TIME

			self:_update_volume_percentage(unit, percentage)

			return true
		end
	end

	local fade_time = self._fade_time

	if not self._fade_time then
		return true
	end

	local start_fade_time = self._start_fade_time

	fade_time = fade_time - dt

	local percentage = math.max(fade_time / start_fade_time, 0.05)

	self:_update_volume_percentage(unit, percentage)

	self._fade_time = fade_time

	if fade_time <= 0 then
		self._fade_time = nil
		self._start_fade_time = nil
	end

	return true
end

ToxicGasFog._update_volume_percentage = function (self, unit, percentage)
	if not self._material then
		local mesh = Unit.mesh(unit, MESH_NAME)
		local material = Mesh.material(mesh, "mtr_fog")

		self._material = material
	end

	local material = self._material
	local albedo = self:get_data(unit, "albedo"):unbox()
	local phase = self:get_data(unit, "phase") * percentage

	Material.set_scalar(material, "height_fog_phase", phase)

	local falloff = self:get_data(unit, "falloff"):unbox() * percentage

	Material.set_vector3(material, "height_fog_falloff", falloff)

	local extinction = self:get_data(unit, "extinction") * percentage

	Material.set_scalar(self._material, "height_fog_extinction", extinction)
	Volumetrics.update_volume(unit, albedo, extinction, phase, falloff, MESH_NAME)
end

ToxicGasFog.disable = function (self, unit)
	if self._volume_registered then
		if rawget(_G, "LevelEditor") then
			Volumetrics.unregister_volume(unit, MESH_NAME)

			self._volume_registered = false
		elseif self._volume_enabled then
			Volumetrics.unregister_volume(unit, MESH_NAME)

			self._volume_registered = false
		end
	end

	if self._particle_created then
		Unit.flow_event(unit, "destroy_particle")

		self._particle_created = nil
	end
end

ToxicGasFog.events.visibility_enable = function (self, unit)
	self:set_volume_enabled(true)
end

ToxicGasFog.events.visibility_disable = function (self, unit)
	self:set_volume_enabled(false)
end

ToxicGasFog.events.create_low_gas = function (self)
	if not self._low_gas_created then
		Unit.flow_event(self.unit, "create_low_gas")

		self._low_gas_created = true
	end
end

ToxicGasFog.events.despawn_low_gas = function (self)
	if self._low_gas_created then
		Unit.flow_event(self.unit, "despawn_low_gas")

		self._low_gas_created = nil
	end
end

local FADE_TIME = 4

ToxicGasFog.events.start_fading = function (self)
	self._fade_time = FADE_TIME
	self._start_fade_time = FADE_TIME
end

ToxicGasFog.events.create_trigger_gas = function (self)
	Unit.flow_event(self.unit, "create_trigger_gas")
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
	end

	self._my_nav_gen_guid = nil

	if ToxicGasFog._fog_clouds == nil then
		ToxicGasFog._fog_clouds = {}
	end

	ToxicGasFog._fog_clouds[#ToxicGasFog._fog_clouds + 1] = {
		unit = unit,
		component = self
	}

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._active_debug_draw = false

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)

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

	if self._volume_registered then
		Volumetrics.unregister_volume(unit, MESH_NAME)

		self._volume_registered = false
	end

	if ToxicGasFog._nav_info ~= nil then
		SharedNav.destroy(ToxicGasFog._nav_info)
	end

	local world, line_object = self._world, self._line_object

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)
end

ToxicGasFog.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._in_active_mission_table then
		local with_traverse_logic = true
		local nav_gen_guid = SharedNav.check_new_navmesh_generated(ToxicGasFog._nav_info, self._my_nav_gen_guid, with_traverse_logic)

		if nav_gen_guid then
			self._my_nav_gen_guid = nav_gen_guid

			local draw_liquid = self:get_data(unit, "draw_liquid")

			if draw_liquid then
				self:_generate_liquid_positions(unit)
			end
		end
	end

	return true
end

local TEMP_FLOOD_FILL_POSITIONS = {}

ToxicGasFog._generate_liquid_positions = function (self, unit)
	local active_mission_level_id = LevelEditor:get_active_mission_level()
	local nav_world = ToxicGasFog._nav_info.nav_world_from_level_id[active_mission_level_id]

	if nav_world then
		local position = Unit.local_position(unit, 1)
		local traverse_logic = ToxicGasFog._nav_info.traverse_logic_from_level_id[active_mission_level_id]
		local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, position, 1, 1, 1)

		if position_on_navmesh then
			if self._liquid_draw_positions then
				table.clear_array(self._liquid_draw_positions, #self._liquid_draw_positions)
			else
				self._liquid_draw_positions = {}
			end

			local flood_fill_positions_boxed = self._liquid_draw_positions
			local max_liquid = self:get_data(unit, "max_liquid")
			local num_positions = GwNavQueries.flood_fill_from_position(nav_world, position_on_navmesh, 1, 1, max_liquid, TEMP_FLOOD_FILL_POSITIONS, traverse_logic)

			for i = 1, num_positions do
				flood_fill_positions_boxed[i] = Vector3Box(TEMP_FLOOD_FILL_POSITIONS[i])
				TEMP_FLOOD_FILL_POSITIONS[i] = nil
			end

			self._fail_liquid_position = nil
		else
			self._fail_liquid_position = Vector3Box(position)
		end

		self:_editor_debug_draw(unit)
	end
end

ToxicGasFog.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(self._object_id)

	self._in_active_mission_table = in_active_mission_table

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid and in_active_mission_table then
		self:_generate_liquid_positions(unit)
	elseif self._active_debug_draw and not in_active_mission_table then
		local drawer = self._drawer

		drawer:reset()
		drawer:update(self._world)

		self._active_debug_draw = false
	end
end

ToxicGasFog.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid then
		self:_generate_liquid_positions(unit)
	end
end

ToxicGasFog.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid then
		self:_generate_liquid_positions(unit)
	elseif self._active_debug_draw then
		local drawer = self._drawer

		drawer:reset()
		drawer:update(self._world)

		self._active_debug_draw = false
	end
end

ToxicGasFog._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local fail_liquid_position, liquid_draw_positions = self._fail_liquid_position, self._liquid_draw_positions

	if liquid_draw_positions then
		for i = 1, #liquid_draw_positions - 1 do
			local pos = liquid_draw_positions[i]:unbox()

			if fail_liquid_position then
				drawer:sphere(pos, 0.3, Color.red())
			else
				drawer:sphere(pos, 0.3, Color.lime())
			end
		end
	end

	if fail_liquid_position then
		drawer:sphere(fail_liquid_position:unbox(), 1, Color.red())
	end

	drawer:update(self._world)

	self._active_debug_draw = true
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
	alternating_min_range = {
		ui_type = "number",
		min = 0,
		decimals = 1,
		category = "Circumstance Gameplay Data",
		value = 16,
		ui_name = "Alternating Min Range",
		step = 0.1
	},
	alternating_max_range = {
		ui_type = "number",
		min = 0,
		decimals = 1,
		category = "Circumstance Gameplay Data",
		value = 20,
		ui_name = "Alternating Max Range",
		step = 0.1
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
