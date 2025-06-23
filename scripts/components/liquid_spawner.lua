-- chunkname: @scripts/components/liquid_spawner.lua

local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local LiquidSpawner = component("LiquidSpawner")

LiquidSpawner.init = function (self, unit, is_server, nav_world)
	self._nav_world = nav_world
	self._max_liquid = self:get_data(unit, "max_liquid")
	self._use_template_max_liquid = self:get_data(unit, "use_template_max_liquid")
	self._liquid_area_template_name = self:get_data(unit, "liquid_area_template_name")
	self._spawn_nodes = self:get_data(unit, "spawn_nodes")
	self._spawned_liquid_units = {}

	local run_update = false

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
	if not self.is_server then
		return
	end

	local template = LiquidAreaTemplates[self._liquid_area_template_name]
	local max_liquid = not self._use_template_max_liquid and self._max_liquid
	local unit = self.unit
	local nav_world = self._nav_world
	local spawn_nodes = self._spawn_nodes

	if spawn_nodes then
		local spawned_liquid_units = self._spawned_liquid_units

		for i = 1, #spawn_nodes do
			local node_name = spawn_nodes[i]
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
	if not self.is_server then
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

LiquidSpawner.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if LiquidSpawner._nav_info == nil then
		LiquidSpawner._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._active_debug_draw = false

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)
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

	if LiquidSpawner._nav_info ~= nil then
		SharedNav.destroy(LiquidSpawner._nav_info)
	end

	local line_object, world = self._line_object, self._world

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)
end

LiquidSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._in_active_mission_table then
		local with_traverse_logic = true
		local nav_gen_guid = SharedNav.check_new_navmesh_generated(LiquidSpawner._nav_info, self._my_nav_gen_guid, with_traverse_logic)

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

LiquidSpawner._generate_single_position = function (self, unit, nav_world, traverse_logic, from_position, node_name)
	local flood_fill_positions = self._flood_fill_positions
	local flood_fill_positions_boxed = self._flood_fill_positions_boxed
	local max_liquid = self:get_data(unit, "max_liquid")
	local use_template_max_liquid = self:get_data(unit, "use_template_max_liquid")
	local liquid_area_template_name = self:get_data(unit, "liquid_area_template_name")
	local template = LiquidAreaTemplates[liquid_area_template_name]

	max_liquid = not use_template_max_liquid and max_liquid or template.max_liquid

	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, from_position, 1, 1, 1)

	if position_on_navmesh then
		local num_positions = GwNavQueries.flood_fill_from_position(nav_world, position_on_navmesh, 1, 1, max_liquid, flood_fill_positions, traverse_logic)

		for i = 1, num_positions do
			flood_fill_positions_boxed[#flood_fill_positions_boxed + 1] = Vector3Box(flood_fill_positions[i])
		end

		self._liquid_draw_positions = flood_fill_positions_boxed
		self._fail_liquid_positions[node_name] = nil
	else
		self._liquid_draw_positions = nil
		self._fail_liquid_positions[node_name] = Vector3Box(from_position)
	end
end

LiquidSpawner._generate_liquid_positions = function (self, unit)
	local active_mission_level_id = LevelEditor:get_active_mission_level()
	local nav_world = LiquidSpawner._nav_info.nav_world_from_level_id[active_mission_level_id]

	if nav_world then
		table.clear(self._flood_fill_positions)
		table.clear(self._flood_fill_positions_boxed)
		table.clear(self._fail_liquid_positions)

		local traverse_logic = LiquidSpawner._nav_info.traverse_logic_from_level_id[active_mission_level_id]
		local spawn_nodes = self._spawn_nodes

		if spawn_nodes then
			for i = 1, #spawn_nodes do
				local node_name = spawn_nodes[i]
				local position = Unit.world_position(unit, Unit.node(unit, node_name))

				self:_generate_single_position(unit, nav_world, traverse_logic, position, node_name)
			end
		else
			local position = Unit.world_position(unit, 1)

			self:_generate_single_position(unit, nav_world, traverse_logic, position, "n/a")
		end

		self:_editor_debug_draw(unit)
	end
end

LiquidSpawner.editor_on_mission_changed = function (self, unit)
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

LiquidSpawner.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local draw_liquid = self:get_data(unit, "draw_liquid")

	if draw_liquid then
		self:_generate_liquid_positions(unit)
	end
end

LiquidSpawner.editor_property_changed = function (self, unit)
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

LiquidSpawner._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local failed_draw = false
	local spawn_nodes = self._spawn_nodes
	local fail_liquid_positions = self._fail_liquid_positions

	if spawn_nodes then
		for i = 1, #spawn_nodes do
			failed_draw = failed_draw or not not fail_liquid_positions[spawn_nodes[i]]

			if failed_draw then
				break
			end
		end
	else
		failed_draw = failed_draw or not not fail_liquid_positions["n/a"]
	end

	local liquid_draw_positions = self._liquid_draw_positions

	if liquid_draw_positions then
		for i = 1, #liquid_draw_positions - 1 do
			local pos = liquid_draw_positions[i]:unbox()
			local color = failed_draw and Color.red() or Color.lime()

			drawer:sphere(pos, 0.3, color)
		end
	end

	if failed_draw then
		drawer:sphere(self._fail_liquid_positions["n/a"]:unbox(), 1, Color.red())
	end

	drawer:update(self._world)

	self._active_debug_draw = true
end

LiquidSpawner.component_data = {
	max_liquid = {
		ui_type = "slider",
		min = 0,
		step = 1,
		decimals = 0,
		value = 130,
		ui_name = "Max Liquid",
		max = 400
	},
	use_template_max_liquid = {
		ui_type = "check_box",
		value = false,
		ui_name = "Use Template Max Liquid"
	},
	liquid_area_template_name = {
		ui_type = "text_box",
		value = "prop_fire",
		ui_name = "Liquid Area Template Name"
	},
	spawn_nodes = {
		ui_type = "text_box_array",
		is_optional = true,
		ui_name = "Spawn Nodes"
	},
	draw_liquid = {
		ui_type = "check_box",
		value = false,
		ui_name = "Draw Liquid (Approx)",
		category = "Debug"
	},
	inputs = {
		spawn_liquid = {
			accessibility = "public",
			type = "event"
		},
		despawn_liquid = {
			accessibility = "public",
			type = "event"
		}
	}
}

return LiquidSpawner
