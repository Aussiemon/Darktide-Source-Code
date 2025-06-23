-- chunkname: @scripts/components/bot_jump_assist.lua

local BotNavTransition = require("scripts/managers/bot_nav_transition/utilities/bot_nav_transition")
local SharedNav = require("scripts/components/utilities/shared_nav")
local BotJumpAssist = component("BotJumpAssist")

BotJumpAssist.init = function (self, unit, is_server)
	local run_update = false

	return run_update
end

BotJumpAssist.on_gameplay_post_init = function (self, unit)
	if self.is_server then
		local wanted_from = Unit.world_position(unit, 1)
		local via = Unit.world_position(unit, Unit.node(unit, "waypoint"))
		local wanted_to = Unit.world_position(unit, Unit.node(unit, "destination"))
		local should_jump = self:get_data(unit, "should_jump")
		local make_permanent = true
		local success, transition_index = Managers.state.bot_nav_transition:create_transition(wanted_from, via, wanted_to, should_jump, make_permanent)

		if success then
			self._transition_index = transition_index
		else
			Log.error("BotJumpAssist", "Failed creating bot nav transition at %s.", tostring(wanted_from))
		end
	end
end

BotJumpAssist.destroy = function (self, unit)
	if self.is_server and self._transition_index then
		Managers.state.bot_nav_transition:unregister_transition(self._transition_index)
	end
end

BotJumpAssist.enable = function (self, unit)
	return
end

BotJumpAssist.disable = function (self, unit)
	return
end

BotJumpAssist.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world
	self._physics_world = World.physics_world(world)

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._should_jump = self:get_data(unit, "should_jump")

	if BotJumpAssist._nav_info == nil then
		BotJumpAssist._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._debug_draw_enabled = false

	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")

	self._object_id = object_id
	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(object_id)

	return true
end

BotJumpAssist.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_node(unit, "waypoint") then
		error_message = error_message .. "\nmissing unit node 'waypoint'"
		success = false
	end

	if not Unit.has_node(unit, "destination") then
		error_message = error_message .. "\nmissing unit node 'destination'"
		success = false
	end

	return success, error_message
end

BotJumpAssist.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if BotJumpAssist._nav_info ~= nil then
		SharedNav.destroy(BotJumpAssist._nav_info)
	end

	local world, line_object = self._world, self._line_object

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)
end

BotJumpAssist.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local with_traverse_logic = true
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(BotJumpAssist._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		self:_editor_debug_draw(unit)
	end

	return true
end

BotJumpAssist._editor_debug_draw = function (self, unit)
	local drawer = self._drawer

	drawer:reset()

	local nav_world, active_mission_level_id

	if self._in_active_mission_table and self._debug_draw_enabled then
		active_mission_level_id = LevelEditor:get_active_mission_level()
		nav_world = BotJumpAssist._nav_info.nav_world_from_level_id[active_mission_level_id]
	end

	if nav_world then
		local wanted_from, via = Unit.world_position(unit, 1), Unit.world_position(unit, Unit.node(unit, "waypoint"))
		local wanted_to = Unit.world_position(unit, Unit.node(unit, "destination"))
		local traverse_logic = BotJumpAssist._nav_info.traverse_logic_from_level_id[active_mission_level_id]
		local success, from, to = BotNavTransition.check_nav_mesh(wanted_from, wanted_to, nav_world, traverse_logic, drawer)
		local any_error = from == nil

		if from then
			local should_jump = self._should_jump

			if success then
				local success_color = Color.green()

				LineObject.add_segmented_line(self._line_object, success_color, wanted_to, to, 20, 50)
				drawer:line(from, to, success_color)
				drawer:sphere(from, 0.3, success_color)
				drawer:sphere(to, 0.3, success_color)
				drawer:cone(to - Vector3.normalize(from - to) * 0.25, to, 0.3, Color.light_green(), 9, 9, false)

				local layer_name = BotNavTransition.calculate_nav_tag_layer(from, to, should_jump)

				if not layer_name then
					drawer:sphere((to + from) / 2, 0.25, Color.red())
					drawer:line(from, to, Color.red())

					any_error = true
				end
			else
				any_error = true
			end

			local physics_world = self._physics_world
			local waypoint = BotNavTransition.resolve_waypoint_position(from, via, should_jump, physics_world)

			drawer:sphere(waypoint, 0.15, Color.white())
		end

		if any_error then
			local start_position = from and from or wanted_from

			drawer:line(start_position, start_position + Vector3.up() * 15, Color.red())
		end
	end

	drawer:update(self._world)
end

BotJumpAssist.editor_on_mission_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._in_active_mission_table = LevelEditor:is_level_object_in_active_mission_table(self._object_id)

	self:_editor_debug_draw(unit)
end

BotJumpAssist.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)
end

BotJumpAssist.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._debug_draw_enabled = enable

	self:_editor_debug_draw(self.unit)
end

BotJumpAssist.component_data = {
	should_jump = {
		ui_type = "check_box",
		value = true,
		ui_name = "Should Jump"
	}
}

return BotJumpAssist
