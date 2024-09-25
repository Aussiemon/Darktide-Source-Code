-- chunkname: @scripts/components/ladder.lua

local LadderNavTransition = require("scripts/managers/bot_nav_transition/utilities/ladder_nav_transition")
local SharedNav = require("scripts/components/utilities/shared_nav")
local Ladder = component("Ladder")

Ladder.init = function (self, unit, is_server)
	local run_update = false

	return run_update
end

Ladder.on_gameplay_post_init = function (self, unit, level)
	if self.is_server then
		Managers.state.bot_nav_transition:register_ladder(unit)

		self._ladder_registered = true
	end
end

Ladder.destroy = function (self, unit)
	if self.is_server and self._ladder_registered then
		Managers.state.bot_nav_transition:unregister_ladder(unit)
	end
end

Ladder.enable = function (self, unit)
	return
end

Ladder.disable = function (self, unit)
	return
end

Ladder.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world
	self._physics_world = World.physics_world(world)

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._top_node = Unit.node(unit, "node_top")
	self._bottom_node = Unit.node(unit, "node_bottom")
	self._leave_node = Unit.node(unit, "node_leave")
	self._enter_end_node = Unit.node(unit, "node_enter_end")

	if Ladder._nav_info == nil then
		Ladder._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._debug_draw_enabled = false

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)

	return true
end

Ladder.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_node(unit, "node_top") then
		error_message = error_message .. "\nmissing unit node 'node_top'"
		success = false
	end

	if not Unit.has_node(unit, "node_bottom") then
		error_message = error_message .. "\nmissing unit node 'node_bottom'"
		success = false
	end

	if not Unit.has_node(unit, "node_leave") then
		error_message = error_message .. "\nmissing unit node 'node_leave'"
		success = false
	end

	if not Unit.has_node(unit, "node_enter_end") then
		error_message = error_message .. "\nmissing unit node 'node_enter_end'"
		success = false
	end

	return success, error_message
end

Ladder.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local with_traverse_logic = true
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(Ladder._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		self:_editor_debug_draw(unit)
	end

	return true
end

Ladder._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local nav_world, active_mission_level_id

	if self._in_active_mission_table and self._debug_draw_enabled then
		active_mission_level_id = LevelEditor:get_active_mission_level()
		nav_world = Ladder._nav_info.nav_world_from_level_id[active_mission_level_id]
	end

	if nav_world then
		local rotation = Unit.local_rotation(unit, 1)
		local down_direction, backward_direction = -Quaternion.up(rotation), -Quaternion.forward(rotation)
		local bottom_node, top_node = self._bottom_node, self._top_node
		local bottom_position, top_position = Unit.world_position(unit, bottom_node), Unit.world_position(unit, top_node)
		local ladder_length, physics_world = Vector3.distance(bottom_position, top_position), self._physics_world
		local ground_position = LadderNavTransition.find_ground_position(top_position, ladder_length, backward_direction, down_direction, physics_world, drawer)

		if ground_position then
			drawer:sphere(ground_position, 0.15, Color.light_green())
		end

		local flat_backward_direction = Vector3.normalize(Vector3.flat(backward_direction))
		local flat_forward_direction = -flat_backward_direction
		local traverse_logic = Ladder._nav_info.traverse_logic_from_level_id[active_mission_level_id]
		local top_on_nav_mesh_postion = LadderNavTransition.find_position_on_nav_mesh(top_position, nav_world, flat_forward_direction, traverse_logic, drawer)
		local ground_on_nav_mesh_position

		if ground_position then
			ground_on_nav_mesh_position = LadderNavTransition.find_position_on_nav_mesh(ground_position, nav_world, flat_backward_direction, traverse_logic, drawer)

			local midway_position = (bottom_position + top_position) / 2

			drawer:vector(midway_position, down_direction * 0.5, Color.blue())

			local ladder_is_bidirectional = LadderNavTransition.is_bidirectional(ground_position, bottom_position)

			if ladder_is_bidirectional then
				local up_direction = -down_direction

				drawer:vector(midway_position, up_direction * 0.5, Color.blue())
			end
		end

		local any_errors = not ground_position or not top_on_nav_mesh_postion or not ground_on_nav_mesh_position

		if any_errors then
			drawer:line(top_position, top_position + Vector3.up() * 15, Color.red())
		end
	end

	local world = self._world

	drawer:update(world)
end

Ladder.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(self._object_id)

	self:_editor_debug_draw(unit)
end

Ladder.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)
end

Ladder.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._debug_draw_enabled = enable

	self:_editor_debug_draw(self.unit)
end

Ladder.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	self._line_object = nil
	self._world = nil
end

Ladder.component_data = {}

return Ladder
