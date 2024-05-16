-- chunkname: @scripts/components/liquid_spawner.lua

local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local LiquidSpawner = component("LiquidSpawner")

LiquidSpawner.init = function (self, unit, is_server, nav_world)
	self._unit = unit
	self._nav_world = nav_world

	local run_update = false

	self._is_server = is_server
	self._max_liquid = self:get_data(unit, "max_liquid")
	self._use_template_max_liquid = self:get_data(unit, "use_template_max_liquid")
	self._liquid_area_template_name = self:get_data(unit, "liquid_area_template_name")
	self._spawn_nodes = self:get_data(unit, "spawn_nodes")
	self._spawned_liquid_units = {}

	if rawget(_G, "LevelEditor") and LiquidSpawner._nav_info == nil then
		LiquidSpawner._nav_info = SharedNav.create_nav_info()

		local nav_gen_guid = SharedNav.check_new_navmesh_generated(LiquidSpawner._nav_info, self._my_nav_gen_guid, true)

		if nav_gen_guid then
			self._my_nav_gen_guid = nav_gen_guid

			self:_generate_liquid_positions(unit)
		end
	end

	return run_update
end

LiquidSpawner.destroy = function (self, unit)
	return
end

LiquidSpawner.enable = function (self, unit)
	return
end

LiquidSpawner.disable = function (self, unit)
	return
end

LiquidSpawner.spawn_liquid = function (self)
	if not self._is_server then
		return
	end

	local template = LiquidAreaTemplates[self._liquid_area_template_name]
	local max_liquid = not self._use_template_max_liquid and self._max_liquid
	local unit = self._unit
	local nav_world = self._nav_world
	local spawn_nodes = self._spawn_nodes

	if spawn_nodes then
		local spawned_liquid_units = self._spawned_liquid_units

		for ii = 1, #spawn_nodes do
			local node_name = spawn_nodes[ii]
			local position = Unit.world_position(unit, Unit.node(unit, node_name))
			local liquid_unit = LiquidArea.try_create(position, Vector3(0, 0, 1), nav_world, template, nil, max_liquid)

			if liquid_unit then
				self._liquid_spawned = true
				spawned_liquid_units[liquid_unit] = true
			end
		end
	else
		local position = POSITION_LOOKUP[unit]
		local liquid_unit = LiquidArea.try_create(position, Vector3(0, 0, 1), nav_world, template, nil, max_liquid)

		if liquid_unit then
			self._liquid_spawned = true
			self._spawned_liquid_units[liquid_unit] = true
		end
	end
end

LiquidSpawner.despawn_liquid = function (self)
	if not self._is_server then
		return
	end

	if self._liquid_spawned then
		local spawned_liquid_units = self._spawned_liquid_units

		for unit, _ in pairs(spawned_liquid_units) do
			Managers.state.unit_spawner:mark_for_deletion(unit)
		end

		self._liquid_spawned = false

		table.clear(spawned_liquid_units)
	end
end

LiquidSpawner.hot_join_sync = function (self, joining_client, joining_channel)
	return
end

LiquidSpawner.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if LiquidSpawner._nav_info == nil then
		LiquidSpawner._nav_info = SharedNav.create_nav_info()

		local with_traverse_logic = true
		local nav_gen_guid = SharedNav.check_new_navmesh_generated(LiquidSpawner._nav_info, self._my_nav_gen_guid, with_traverse_logic)

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
	self._flood_fill_positions = {}
	self._flood_fill_positions_boxed = {}
	self._fail_liquid_positions = {}

	return true
end

LiquidSpawner.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

LiquidSpawner.editor_destroy = function (self, unit)
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

local NAV_TAG_LAYER_COSTS = {
	cover_ledges = 0,
	cover_vaults = 0,
	doors = 0,
	jumps = 0,
	ledges = 0,
	ledges_with_fence = 0,
	monster_walls = 0,
	teleporters = 0,
}

LiquidSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")
	local with_traverse_logic = true
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(LiquidSpawner._nav_info, self._my_nav_gen_guid, with_traverse_logic, NAV_TAG_LAYER_COSTS)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		if draw_liquid then
			self:_generate_liquid_positions(unit)
		end
	end

	if draw_liquid and self._old_gizmo_position then
		local distance = Vector3.distance(Unit.local_position(unit, 1), self._old_gizmo_position:unbox())

		if distance > 0.25 then
			self:_generate_liquid_positions(unit)
		end
	end

	return true
end

LiquidSpawner._generate_single_position = function (self, unit, nav_world, from_position, node_name)
	local flood_fill_positions = self._flood_fill_positions
	local flood_fill_positions_boxed = self._flood_fill_positions_boxed
	local max_liquid = self:get_data(unit, "max_liquid")
	local use_template_max_liquid = self:get_data(unit, "use_template_max_liquid")
	local liquid_area_template_name = self:get_data(unit, "liquid_area_template_name")
	local template = LiquidAreaTemplates[liquid_area_template_name]

	max_liquid = not use_template_max_liquid and max_liquid or template.max_liquid

	local traverse_logic = LiquidSpawner._nav_info.traverse_logic
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, from_position, 1, 1, 1)

	if position_on_navmesh then
		local num_positions = GwNavQueries.flood_fill_from_position(nav_world, position_on_navmesh, 1, 1, max_liquid, flood_fill_positions, traverse_logic)

		for ii = 1, num_positions do
			flood_fill_positions_boxed[#flood_fill_positions_boxed + 1] = Vector3Box(flood_fill_positions[ii])
		end

		self._liquid_draw_positions = flood_fill_positions_boxed
		self._fail_liquid_positions[node_name] = nil
	else
		self._liquid_draw_positions = nil
		self._fail_liquid_positions[node_name] = Vector3Box(from_position)
	end
end

LiquidSpawner._generate_liquid_positions = function (self, unit)
	local nav_world = LiquidSpawner._nav_info.nav_world

	if nav_world then
		table.clear(self._flood_fill_positions)
		table.clear(self._flood_fill_positions_boxed)
		table.clear(self._fail_liquid_positions)

		local spawn_nodes = self._spawn_nodes

		if spawn_nodes then
			for ii = 1, #spawn_nodes do
				local node_name = spawn_nodes[ii]
				local position = Unit.world_position(unit, Unit.node(unit, node_name))

				self:_generate_single_position(unit, nav_world, position, node_name)
			end
		else
			local position = Unit.world_position(unit, 1)

			self:_generate_single_position(unit, nav_world, position, "n/a")
		end

		self._old_gizmo_position = Vector3Box(Unit.world_position(unit, 1))

		self:_editor_debug_draw(unit)
	end
end

LiquidSpawner.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid then
		self:_generate_liquid_positions(unit)
	end
end

LiquidSpawner._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local failed_draw = false
	local spawn_nodes = self._spawn_nodes
	local fail_liquid_positions = self._fail_liquid_positions

	if spawn_nodes then
		for ii = 1, #spawn_nodes do
			failed_draw = failed_draw or not not fail_liquid_positions[spawn_nodes[ii]]
		end
	else
		failed_draw = failed_draw or not not fail_liquid_positions["n/a"]
	end

	local liquid_draw_positions = self._liquid_draw_positions

	if liquid_draw_positions then
		for ii = 1, #liquid_draw_positions - 1 do
			local pos = liquid_draw_positions[ii]:unbox()
			local color = failed_draw and Color.red() or Color.lime()

			drawer:sphere(pos, 0.3, color)
		end
	end

	if failed_draw then
		drawer:sphere(self._fail_liquid_positions["n/a"]:unbox(), 1, Color.red())
	end

	drawer:update(self._world)
end

LiquidSpawner.component_data = {
	max_liquid = {
		decimals = 0,
		max = 400,
		min = 0,
		step = 1,
		ui_name = "Max Liquid",
		ui_type = "slider",
		value = 130,
	},
	use_template_max_liquid = {
		ui_name = "Use Template Max Liquid",
		ui_type = "check_box",
		value = false,
	},
	liquid_area_template_name = {
		ui_name = "Liquid Area Template Name",
		ui_type = "text_box",
		value = "prop_fire",
	},
	spawn_nodes = {
		is_optional = true,
		ui_name = "Spawn Nodes",
		ui_type = "text_box_array",
	},
	draw_liquid = {
		category = "Debug",
		ui_name = "Draw Liquid (Approx)",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		spawn_liquid = {
			accessibility = "public",
			type = "event",
		},
		despawn_liquid = {
			accessibility = "public",
			type = "event",
		},
	},
}

return LiquidSpawner
