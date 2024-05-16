-- chunkname: @scripts/components/moveable_platform.lua

local MoveablePlatform = component("MoveablePlatform")

MoveablePlatform.init = function (self, unit, is_server)
	self._is_server = is_server

	local moveable_platform_extension = ScriptUnit.fetch_component_extension(unit, "moveable_platform_system")

	if moveable_platform_extension then
		local story = self:get_data(unit, "story")
		local player_side = self:get_data(unit, "player_side")
		local walls_collision = self:get_data(unit, "walls_collision")
		local walls_collision_filter = self:get_data(unit, "walls_collision_filter")
		local require_all_players_onboard = self:get_data(unit, "require_all_players_onboard")
		local interactable_story_actions = self:get_data(unit, "interactable_story_actions")
		local interactable_hud_descriptions = self:get_data(unit, "interactable_hud_descriptions")
		local story_speed_forward, story_speed_backward = self:_calculate_story_speed(unit)
		local end_sound_time = self:get_data(unit, "end_sound_time")
		local nav_handling_enabled = self:get_data(unit, "nav_handling_enabled")
		local stop_position = self:get_data(unit, "stop_position")

		moveable_platform_extension:setup_from_component(story, player_side, walls_collision, walls_collision_filter, require_all_players_onboard, interactable_story_actions, interactable_hud_descriptions, story_speed_forward, story_speed_backward, end_sound_time, nav_handling_enabled, stop_position)

		self._moveable_platform_extension = moveable_platform_extension
	end
end

MoveablePlatform.editor_init = function (self, unit)
	if rawget(_G, "LevelEditor") then
		self._unit = unit
		self._stop_units = {}

		local world = Application.main_world()

		self._world = world
		self._debug_text_id = nil
		self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)

		self:_spawn_stop_points()
	end
end

MoveablePlatform.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") then
		if self:get_data(unit, "walls_collision") and Unit.find_actor(unit, "c_wall_1") == nil then
			success = false
			error_message = error_message .. "\nCouldn't find any wall actors on unit"
		end

		if Unit.find_actor(unit, "c_box_center") == nil then
			success = false
			error_message = error_message .. "\nCouldn't find actor 'c_box_center' on unit"
		end
	end

	return success, error_message
end

MoveablePlatform.get_navgen_units = function (self)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return self._stop_units
end

MoveablePlatform._spawn_stop_points = function (self)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local unit = self._unit
	local nav_handling_enabled = self:get_data(unit, "nav_handling_enabled")
	local unit_name = self:get_data(unit, "stop_unit")
	local stop_position = self:get_data(unit, "stop_position")
	local stop_rotation = Unit.world_rotation(unit, 1)

	if not nav_handling_enabled or not unit_name then
		return
	end

	local world = self._world
	local end_unit = World.spawn_unit_ex(world, unit_name, nil, stop_position:unbox(), stop_rotation)

	table.insert(self._stop_units, end_unit)
end

MoveablePlatform._unspawn_stop_points = function (self)
	local world = self._world

	if not world then
		return
	end

	for _, stop_unit in ipairs(self._stop_units) do
		if stop_unit then
			World.destroy_unit(world, stop_unit)
		else
			Log.error("MoveablePlatform", "Trying to destroy nil unit")
		end
	end

	table.clear(self._stop_units)
end

MoveablePlatform.enable = function (self, unit)
	return
end

MoveablePlatform.disable = function (self, unit)
	return
end

MoveablePlatform.destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_unspawn_stop_points()
end

MoveablePlatform.editor_property_changed = function (self, unit)
	self:_setup_change(unit)
end

MoveablePlatform.editor_world_transform_modified = function (self, unit)
	self:_setup_change(unit)
end

MoveablePlatform._setup_change = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_calculate_story_speed(unit)
	self:_unspawn_stop_points()
	self:_spawn_stop_points()
end

MoveablePlatform.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_unspawn_stop_points()

	local world = self._world
	local gui = self._gui

	self._line_object = nil
	self._world = nil

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)
	end

	World.destroy_gui(world, gui)
end

MoveablePlatform.editor_reset_physics = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local center_actor_id = Unit.find_actor(unit, "c_box_center")

	if center_actor_id then
		Unit.destroy_actor(unit, center_actor_id)
	end

	local wall_count = 1
	local wall_prefix = "c_wall_"
	local actor_id = Unit.find_actor(unit, wall_prefix .. tostring(wall_count))

	while actor_id ~= nil do
		Unit.destroy_actor(unit, actor_id)

		wall_count = wall_count + 1
		actor_id = Unit.find_actor(unit, wall_prefix .. tostring(wall_count))
	end
end

MoveablePlatform._calculate_story_speed = function (self, unit)
	if unit == nil then
		self:_draw_warning(unit, "Unit null")

		return 1, 1
	end

	local story_name = self:get_data(unit, "story")
	local override_forward = self:get_data(unit, "story_override_forward")
	local override_backward = self:get_data(unit, "story_override_backward")
	local story_speed_forward = 1
	local story_speed_backward = 1

	if override_forward or override_backward then
		local story_length = self:_get_story_length(unit, story_name)

		if story_length >= 0 then
			local min_speed = -2
			local max_speed = 1.9990234375

			if NetworkConstants then
				local story_speed_constants = NetworkConstants.story_speed

				min_speed = story_speed_constants.min
				max_speed = story_speed_constants.max
			end

			if override_forward then
				local story_time_forward = self:get_data(unit, "story_time_forward")

				story_speed_forward = story_length / story_time_forward

				if story_speed_forward < min_speed then
					self:_draw_warning(unit, string.format("forward override time is %s vs %s base time, causing speed multiplier to be too small %sx (%sx min)", story_time_forward, story_length, story_speed_forward, min_speed))

					story_speed_forward = min_speed
				elseif max_speed < story_speed_forward then
					self:_draw_warning(unit, string.format("forward override time is %ss vs %ss base time, causing speed multiplier to be too large %sx (%sx max) ", story_time_forward, story_length, story_speed_forward, max_speed))

					story_speed_forward = max_speed
				end
			end

			if override_backward then
				local story_time_backward = self:get_data(unit, "story_time_backward")

				story_speed_backward = story_length / story_time_backward

				if story_speed_backward < min_speed then
					self:_draw_warning(unit, string.format("backward override time is %ss vs %ss base time, causing speed multiplier to be too small %sx (%sx min)", story_time_backward, story_length, story_speed_backward, min_speed))

					story_speed_backward = min_speed
				elseif max_speed < story_speed_backward then
					self:_draw_warning(unit, string.format("backward override time is %ss vs %ss base time, causing speed multiplier to be too large %sx (%sx max)", story_time_backward, story_length, story_speed_backward, max_speed))

					story_speed_backward = max_speed
				end
			end
		end
	end

	return story_speed_forward, story_speed_backward
end

MoveablePlatform._get_story_length = function (self, unit, story_name)
	if rawget(_G, "LevelEditor") then
		local stories = LevelEditor:get_unit_story(Unit.id_string(unit))
		local num_stories = 0

		for id, story in pairs(stories) do
			local story_length = LevelEditor:get_story_length(story)

			if story_length then
				return story_length
			end
		end

		self:_draw_warning(unit, string.format("No story connected to unit", story_name, num_stories))

		return -1
	else
		local level = Unit.level(unit)
		local world = Unit.world(unit)

		if level == nil or world == nil then
			self:_draw_warning(unit, string.format("Unable to check story length. world: %s, level: %s", world ~= nil, level ~= nil))

			return -1
		end

		local storyteller = World.storyteller(world)
		local story_length = storyteller:length_from_name(level, story_name)

		return story_length
	end
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.3

MoveablePlatform._draw_warning = function (self, unit, text)
	if self._gui then
		local text_color = Color.red()
		local text_position = Unit.local_position(unit, 1) + Vector3.up()
		local translation_matrix = Matrix4x4.from_translation(text_position)

		if self._debug_text_id then
			Gui.update_text_3d(self._gui, self._debug_text_id, "MovablePlatform - " .. text, FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)
		else
			self._debug_text_id = Gui.text_3d(self._gui, "MovablePlatform - " .. text, FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)
		end
	else
		Log.error("MovablePlatform", text)
	end
end

MoveablePlatform.set_story = function (self, story_name)
	local moveable_platform_extension = self._moveable_platform_extension

	if moveable_platform_extension and self._is_server then
		moveable_platform_extension:set_story(story_name)
	end
end

MoveablePlatform.move_forward = function (self)
	local moveable_platform_extension = self._moveable_platform_extension

	if moveable_platform_extension and self._is_server then
		moveable_platform_extension:move_forward()
	end
end

MoveablePlatform.move_backward = function (self)
	local moveable_platform_extension = self._moveable_platform_extension

	if moveable_platform_extension and self._is_server then
		moveable_platform_extension:move_backward()
	end
end

MoveablePlatform.toggle_require_all_players_onboard = function (self)
	local moveable_platform_extension = self._moveable_platform_extension

	if moveable_platform_extension then
		moveable_platform_extension:toggle_require_all_players_onboard()
	end
end

MoveablePlatform.component_data = {
	story = {
		category = "Story",
		ui_name = "Story",
		ui_type = "text_box",
		value = "story_name",
	},
	story_override_forward = {
		category = "Story",
		ui_name = "Override Forward Story Time",
		ui_type = "check_box",
		value = false,
	},
	story_time_forward = {
		category = "Story",
		decimals = 100,
		step = 0.1,
		ui_name = "Forward Play Time (sec.)",
		ui_type = "number",
		value = 0,
	},
	story_override_backward = {
		category = "Story",
		ui_name = "Override Backward Story Time",
		ui_type = "check_box",
		value = false,
	},
	story_time_backward = {
		category = "Story",
		decimals = 100,
		step = 0.1,
		ui_name = "Backward Story Time (sec.)",
		ui_type = "number",
		value = 0,
	},
	player_side = {
		ui_name = "Player Side",
		ui_type = "text_box",
		value = "heroes",
	},
	walls_collision = {
		ui_name = "Walls Collision",
		ui_type = "check_box",
		value = true,
	},
	walls_collision_filter = {
		ui_name = "Walls Collision Filter",
		ui_type = "text_box",
		value = "default",
	},
	require_all_players_onboard = {
		ui_name = "Require All Players Onboard",
		ui_type = "check_box",
		value = false,
	},
	interactable_story_actions = {
		category = "Interactables",
		size = 0,
		ui_name = "Story Actions",
		ui_type = "text_box_array",
	},
	interactable_hud_descriptions = {
		category = "Interactables",
		size = 0,
		ui_name = "HUD Descriptions",
		ui_type = "text_box_array",
	},
	end_sound_time = {
		ui_name = "End Sound Time",
		ui_type = "number",
		value = 0,
	},
	nav_handling_enabled = {
		category = "Nav",
		ui_name = "Nav Handling",
		ui_type = "check_box",
		value = false,
	},
	stop_unit = {
		category = "Nav",
		filter = "unit",
		preview = true,
		ui_name = "Stop Unit",
		ui_type = "resource",
		value = "",
	},
	stop_position = {
		category = "Nav",
		step = 0.1,
		ui_name = "Stop Position",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	inputs = {
		move_forward = {
			accessibility = "public",
			type = "event",
		},
		move_backward = {
			accessibility = "public",
			type = "event",
		},
		toggle_require_all_players_onboard = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"MoveablePlatformExtension",
		"InteracteeExtension",
	},
}

return MoveablePlatform
