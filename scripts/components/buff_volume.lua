-- chunkname: @scripts/components/buff_volume.lua

local BuffVolume = component("BuffVolume")

BuffVolume.init = function (self, unit, is_server, nav_world)
	local run_update = false

	if not is_server then
		return run_update
	end

	local buff_template_name = self:get_data(unit, "buff_template_name")

	if buff_template_name ~= "default" then
		self._buff_template_name = buff_template_name
		run_update = true
	end

	local leaving_buff_template_name = self:get_data(unit, "leaving_buff_template_name")

	if leaving_buff_template_name ~= "default" then
		run_update = true
	end

	local heroes_buff_template_name = self:get_data(unit, "heroes_buff_template_name")

	if heroes_buff_template_name ~= "default" then
		self._heroes_buff_template_name = heroes_buff_template_name
		run_update = true
	end

	local villains_buff_template_name = self:get_data(unit, "villains_buff_template_name")

	if villains_buff_template_name ~= "default" then
		self._villains_buff_template_name = villains_buff_template_name
		run_update = true
	end

	self._inverse = self:get_data(unit, "inverse")
	self._forbidden_keyword = self:get_data(unit, "forbidden_keyword")
	self._buff_affected_units = {}
	self._unit = unit

	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase

	local side_system = extension_manager:system("side_system")
	local affected_side_name = self:get_data(unit, "affected_side_name")

	if affected_side_name == "both" then
		self._affected_side_names = side_system:side_names()
	else
		local side = side_system:get_side_from_name(affected_side_name)

		self._affected_side = side
		self._affected_side_names = side:relation_side_names("allied")
	end

	self:_calculate_broadphase_size()

	local start_enabled = self:get_data(unit, "start_enabled")

	if start_enabled then
		self._buffs_enabled = true
	end

	return run_update
end

BuffVolume.destroy = function (self)
	return
end

BuffVolume.enable = function (self, unit)
	return
end

BuffVolume.disable = function (self, unit)
	return
end

local TEMP_ALREADY_CHECKED_UNITS = {}
local BROADPHASE_RESULTS = {}

BuffVolume.update = function (self, unit, dt, t)
	local broadphase, side_names = self._broadphase, self._affected_side_names
	local broadphase_center, broadphase_radius = self._broadphase_center:unbox(), self._broadphase_radius

	if not self._buffs_enabled then
		return true
	end

	local num_results = broadphase.query(broadphase, broadphase_center, broadphase_radius, BROADPHASE_RESULTS, side_names)

	if num_results == 0 and not self._inverse then
		return true
	end

	table.clear(TEMP_ALREADY_CHECKED_UNITS)

	if self._inverse then
		self:_update_inverse_buffs(unit, dt, t)
	else
		self:_update_buffs(unit, dt, t, num_results)
	end

	return true
end

BuffVolume._update_buffs = function (self, unit, dt, t, num_results)
	local buff_affected_units = self._buff_affected_units
	local ALIVE = ALIVE

	for buff_affected_unit, buff_indices in pairs(buff_affected_units) do
		local is_inside_volume = false

		if not ALIVE[buff_affected_unit] then
			is_inside_volume = true
		else
			local affected_unit_position = (POSITION_LOOKUP[buff_affected_unit] or Unit.world_position(buff_affected_unit, 1)) + Vector3(0, 0, 0.1)

			if Unit.is_point_inside_volume(unit, "volume", affected_unit_position) then
				is_inside_volume = true
			end
		end

		if not is_inside_volume then
			self:_remove_buff(buff_affected_unit, buff_indices, t)

			buff_affected_units[buff_affected_unit] = nil
		end

		TEMP_ALREADY_CHECKED_UNITS[buff_affected_unit] = true
	end

	for i = 1, num_results do
		repeat
			local affected_unit = BROADPHASE_RESULTS[i]

			if not ALIVE[affected_unit] or TEMP_ALREADY_CHECKED_UNITS[affected_unit] then
				break
			end

			local affected_unit_position = (POSITION_LOOKUP[affected_unit] or Unit.world_position(affected_unit, 1)) + Vector3(0, 0, 0.1)
			local unit_is_inside = Unit.is_point_inside_volume(unit, "volume", affected_unit_position)

			if unit_is_inside then
				local buff_extension = ScriptUnit.has_extension(affected_unit, "buff_system")

				if buff_extension and not TEMP_ALREADY_CHECKED_UNITS[affected_unit] then
					local forbidden_keyword = self._forbidden_keyword ~= "default" and self._forbidden_keyword

					if not forbidden_keyword or not buff_extension:has_keyword(forbidden_keyword) then
						local local_index, component_index = self:_add_buff(affected_unit, t)

						buff_affected_units[affected_unit] = {
							local_index = local_index,
							component_index = component_index,
						}
					end
				end

				TEMP_ALREADY_CHECKED_UNITS[affected_unit] = true
			end
		until true
	end
end

BuffVolume._update_inverse_buffs = function (self, unit, dt, t)
	local buff_affected_units = self._buff_affected_units
	local ALIVE = ALIVE

	for buff_affected_unit, buff_indices in pairs(buff_affected_units) do
		local is_inside_volume = false

		if not ALIVE[buff_affected_unit] then
			is_inside_volume = true
		else
			local affected_unit_position = (POSITION_LOOKUP[buff_affected_unit] or Unit.world_position(buff_affected_unit, 1)) + Vector3(0, 0, 0.1)

			if Unit.is_point_inside_volume(unit, "volume", affected_unit_position) then
				is_inside_volume = true
			end
		end

		if is_inside_volume then
			self:_remove_buff(buff_affected_unit, buff_indices, t)

			buff_affected_units[buff_affected_unit] = nil
		end

		TEMP_ALREADY_CHECKED_UNITS[buff_affected_unit] = true
	end

	local target_units = self._affected_side.valid_player_units
	local num_valid_target_units = #target_units

	for i = 1, num_valid_target_units do
		repeat
			local affected_unit = target_units[i]

			if not ALIVE[affected_unit] or TEMP_ALREADY_CHECKED_UNITS[affected_unit] then
				break
			end

			local affected_unit_position = POSITION_LOOKUP[affected_unit] + Vector3(0, 0, 0.1)
			local unit_is_inside = Unit.is_point_inside_volume(unit, "volume", affected_unit_position)

			if not unit_is_inside then
				local buff_extension = ScriptUnit.has_extension(affected_unit, "buff_system")

				if buff_extension and not TEMP_ALREADY_CHECKED_UNITS[affected_unit] then
					local local_index, component_index = self:_add_buff(affected_unit, t)

					buff_affected_units[affected_unit] = {
						local_index = local_index,
						component_index = component_index,
					}
				end

				TEMP_ALREADY_CHECKED_UNITS[affected_unit] = true
			end
		until true
	end
end

BuffVolume._add_buff = function (self, unit, t)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local side_extension = ScriptUnit.extension(unit, "side_system")
	local side_name = side_extension.side:name()
	local buff_template_name = self._buff_template_name

	if self._villains_buff_template_name and side_name == "villains" then
		buff_template_name = self._villains_buff_template_name
	elseif self._heroes_buff_template_name and side_name == "heroes" then
		buff_template_name = self._heroes_buff_template_name
	end

	local _, local_index, component_index = buff_extension:add_externally_controlled_buff(buff_template_name, t, "owner_unit", self._unit)

	return local_index, component_index
end

BuffVolume._remove_buff = function (self, unit, buff_indices, t)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension then
		return
	end

	local local_index = buff_indices.local_index
	local component_index = buff_indices.component_index

	buff_extension:remove_externally_controlled_buff(local_index, component_index)

	local leaving_liquid_buff_template_name = self._leaving_buff_template_name

	if leaving_liquid_buff_template_name then
		buff_extension:add_internally_controlled_buff(leaving_liquid_buff_template_name, t, "owner_unit", self._unit)
	end
end

local MAX_BROADPHASE_RADIUS = 50
local TEMP_POSITIONS = {}

BuffVolume._calculate_broadphase_size = function (self)
	self._broadphase_center, self._broadphase_radius = Vector3Box()

	local Vector3_max, Vector3_min = Vector3.max, Vector3.min
	local volume_points = Unit.volume_points(self._unit, "volume")
	local first_position = volume_points[1]
	local max_position, min_position = first_position, first_position
	local num_points = 0

	for _, point in pairs(volume_points) do
		max_position = Vector3_max(max_position, point)
		min_position = Vector3_min(min_position, point)
		num_points = num_points + 1
		TEMP_POSITIONS[num_points] = point
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local max_distance_sq = -math.huge
	local center_position = (max_position + min_position) / 2

	for i = 1, num_points do
		local position = TEMP_POSITIONS[i]
		local distance_sq = Vector3_distance_squared(center_position, position)

		if max_distance_sq < distance_sq then
			max_distance_sq = distance_sq
		end

		TEMP_POSITIONS[i] = nil
	end

	self._broadphase_center:store(center_position)

	self._broadphase_radius = math.min(math.sqrt(max_distance_sq), MAX_BROADPHASE_RADIUS)
end

BuffVolume.enable_buffs = function (self)
	self._buffs_enabled = true
end

BuffVolume.disable_buffs = function (self)
	self._buffs_enabled = false

	local buff_affected_units = self._buff_affected_units

	if not buff_affected_units then
		return
	end

	local ALIVE = ALIVE
	local t = Managers.time:time("gameplay")

	for buff_affected_unit, buff_indices in pairs(buff_affected_units) do
		if ALIVE[buff_affected_unit] then
			self:_remove_buff(buff_affected_unit, buff_indices, t)
		end

		buff_affected_units[buff_affected_unit] = nil
	end
end

BuffVolume.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)

	return true
end

BuffVolume.editor_validate = function (self, unit)
	return true, ""
end

BuffVolume.editor_destroy = function (self, unit)
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

BuffVolume.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

BuffVolume.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

BuffVolume.component_data = {
	start_enabled = {
		ui_name = "start_enabled",
		ui_type = "check_box",
		value = true,
	},
	buff_template_name = {
		ui_name = "Buff Name",
		ui_type = "text_box",
		value = "default",
	},
	leaving_buff_template_name = {
		ui_name = "Leaving Buff Name",
		ui_type = "text_box",
		value = "default",
	},
	heroes_buff_template_name = {
		ui_name = "Heroes Buff Name",
		ui_type = "text_box",
		value = "default",
	},
	villains_buff_template_name = {
		ui_name = "Villains Buff Name",
		ui_type = "text_box",
		value = "default",
	},
	forbidden_keyword = {
		ui_name = "Forbidden Keyword",
		ui_type = "text_box",
		value = "default",
	},
	affected_side_name = {
		ui_name = "Side",
		ui_type = "combo_box",
		value = "heroes",
		options_keys = {
			"Heroes",
			"Villains",
			"Both",
		},
		options_values = {
			"heroes",
			"villains",
			"both",
		},
	},
	inverse = {
		ui_name = "Inverse",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		enable_buffs = {
			accessibility = "public",
			type = "event",
		},
		disable_buffs = {
			accessibility = "public",
			type = "event",
		},
	},
}

return BuffVolume
