-- chunkname: @scripts/components/damage_volume.lua

local DamageVolumeSettings = require("scripts/settings/components/damage_volume_settings")
local DamageVolume = component("DamageVolume")

DamageVolume.init = function (self, unit, is_server, nav_world)
	local run_update = false

	if not is_server then
		return run_update
	end

	self._buff_affected_units = {}
	self._unit = unit

	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase

	local damage_type = self:get_data(unit, "damage_type")

	self._damage_type = damage_type
	self._damage_type_settings = DamageVolumeSettings[damage_type]
	self._forbidden_keyword = self._damage_type_settings.forbidden_keyword
	self._buff_template_name = self._damage_type_settings.buff_template_name

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
		self._enabled = true
	end

	run_update = true

	return run_update
end

DamageVolume.destroy = function (self)
	return
end

DamageVolume.enable = function (self, unit)
	return
end

DamageVolume.disable = function (self, unit)
	return
end

local TEMP_ALREADY_CHECKED_UNITS = {}
local BROADPHASE_RESULTS = {}

DamageVolume.update = function (self, unit, dt, t)
	local broadphase, side_names = self._broadphase, self._affected_side_names
	local broadphase_center, broadphase_radius = self._broadphase_center:unbox(), self._broadphase_radius

	if not self._enabled then
		return true
	end

	local num_results = broadphase.query(broadphase, broadphase_center, broadphase_radius, BROADPHASE_RESULTS, side_names)

	if num_results == 0 and not self._inverse then
		return true
	end

	table.clear(TEMP_ALREADY_CHECKED_UNITS)
	self:_update(unit, dt, t, num_results)

	return true
end

DamageVolume._update = function (self, unit, dt, t, num_results)
	local buff_affected_units = self._buff_affected_units
	local ALIVE = ALIVE

	for i = 1, num_results do
		repeat
			local affected_unit = BROADPHASE_RESULTS[i]

			if not ALIVE[affected_unit] then
				break
			end

			local affected_unit_position = (POSITION_LOOKUP[affected_unit] or Unit.world_position(affected_unit, 1)) + Vector3(0, 0, 0.1)
			local unit_is_inside = Unit.is_point_inside_volume(unit, "volume", affected_unit_position)

			if unit_is_inside then
				local buff_extension = ScriptUnit.has_extension(affected_unit, "buff_system")

				if buff_extension and not TEMP_ALREADY_CHECKED_UNITS[affected_unit] then
					local forbidden_keyword = self._forbidden_keyword ~= "default" and self._forbidden_keyword

					if not forbidden_keyword or not buff_extension:has_keyword(forbidden_keyword) then
						self:_add_buff(affected_unit, t)

						buff_affected_units[affected_unit] = true
					end
				end

				TEMP_ALREADY_CHECKED_UNITS[affected_unit] = true
			end
		until true
	end
end

DamageVolume._add_buff = function (self, unit, t)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local side_extension = ScriptUnit.extension(unit, "side_system")
	local side_name = side_extension.side:name()
	local buff_template_name = self._buff_template_name

	buff_extension:add_internally_controlled_buff(buff_template_name, t, "owner_unit", self._unit)
end

local MAX_BROADPHASE_RADIUS = 50
local TEMP_POSITIONS = {}

DamageVolume._calculate_broadphase_size = function (self)
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

DamageVolume.enable_volume = function (self)
	self._enabled = true
end

DamageVolume.disable_volume = function (self)
	self._enabled = false
end

DamageVolume.editor_init = function (self, unit)
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

DamageVolume.editor_validate = function (self, unit)
	return true, ""
end

DamageVolume.editor_destroy = function (self, unit)
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

DamageVolume.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

DamageVolume.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

DamageVolume.component_data = {
	start_enabled = {
		ui_name = "start_enabled",
		ui_type = "check_box",
		value = true,
	},
	damage_type = {
		ui_name = "Damage_Type",
		ui_type = "combo_box",
		value = "electrical",
		options_keys = {
			"electrical",
			"radioactive",
			"burning",
			"instakill",
		},
		options_values = {
			"electrical",
			"radioactive",
			"burning",
			"instakill",
		},
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
	inputs = {
		enable_volume = {
			accessibility = "public",
			type = "event",
		},
		disable_volume = {
			accessibility = "public",
			type = "event",
		},
	},
}

return DamageVolume
