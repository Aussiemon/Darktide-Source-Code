local LadderNavTransition = require("scripts/managers/bot_nav_transition/utilities/ladder_nav_transition")
local SharedNav = require("scripts/components/utilities/shared_nav")
local Ladder = component("Ladder")

Ladder.init = function (self, unit, is_server)
	self._is_server = is_server

	fassert(Unit.has_node(unit, "node_top"), "[Ladder][init] missing unit node 'node_top'")
	fassert(Unit.has_node(unit, "node_bottom"), "[Ladder][init] missing unit node 'node_bottom'")
	fassert(Unit.has_node(unit, "node_leave"), "[Ladder][init] missing unit node 'node_leave'")
	fassert(Unit.has_node(unit, "node_enter_end"), "[Ladder][init] missing unit node 'node_enter_end'")

	local run_update = false

	return run_update
end

Ladder.on_gameplay_post_init = function (self, unit, level)
	if self._is_server then
		Managers.state.bot_nav_transition:register_ladder(unit)

		self._ladder_registered = true
	end
end

Ladder.destroy = function (self, unit)
	if self._is_server and self._ladder_registered then
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
	self._unit = unit
	self._should_debug_draw = false

	return true
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

	local nav_world = Ladder._nav_info.nav_world

	if nav_world and self._should_debug_draw then
		local rotation = Unit.local_rotation(unit, 1)
		local down_direction = -Quaternion.up(rotation)
		local backward_direction = -Quaternion.forward(rotation)
		local bottom_node = self._bottom_node
		local top_node = self._top_node
		local bottom_position = Unit.world_position(unit, bottom_node)
		local top_position = Unit.world_position(unit, top_node)
		local ladder_length = Vector3.distance(bottom_position, top_position)
		local physics_world = self._physics_world
		local ground_position = LadderNavTransition.find_ground_position(top_position, ladder_length, backward_direction, down_direction, physics_world, drawer)

		if ground_position then
			drawer:sphere(ground_position, 0.15, Color.light_green())
		end

		local flat_backward_direction = Vector3.normalize(Vector3.flat(backward_direction))
		local flat_forward_direction = -flat_backward_direction
		local traverse_logic = self._traverse_logic
		local top_on_nav_mesh_postion = LadderNavTransition.find_position_on_nav_mesh(top_position, nav_world, flat_forward_direction, traverse_logic, drawer)
		local ground_on_nav_mesh_position = nil

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

	self._should_debug_draw = enable

	self:_editor_debug_draw(self._unit)
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
