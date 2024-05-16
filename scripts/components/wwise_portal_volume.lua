-- chunkname: @scripts/components/wwise_portal_volume.lua

local WwisePortalVolume = component("WwisePortalVolume")

WwisePortalVolume.init = function (self, unit)
	self._unit = unit
	self._wwise_world = Wwise.wwise_world(Unit.world(unit))
	self._open = false

	local register_portal = self:get_data(unit, "register_portal")

	if not register_portal then
		return false
	end

	if Unit.has_volume(unit, "portal_volume") == false then
		Log.error("WwisePortalVolume", "[init][Unit: %s] missing 'portal_volume'", Unit.id_string(unit))

		return false
	end

	if Managers then
		Managers.state.rooms_and_portals:register_portal(self)
	end

	return true
end

WwisePortalVolume.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit

	local world = Application.main_world()

	self._world = world
	self._line_object = World.create_line_object(self._world)
	self._drawer = DebugDrawer(self._line_object, "retained")
	self._should_debug_draw = false

	if Unit.has_volume(unit, "portal_volume") == false then
		Log.error("WwisePortalVolume", "[init][Unit: %s] missing 'portal_volume'", Unit.id_string(unit))

		return false
	end

	if Managers then
		Managers.state.rooms_and_portals:register_portal(self)
	end

	return true
end

WwisePortalVolume.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "portal_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'portal_volume'"
	end

	return success, error_message
end

WwisePortalVolume.enable = function (self, unit)
	if Managers then
		self._open = true

		Managers.state.rooms_and_portals:toggle_portal(self, true)
	end
end

WwisePortalVolume.get_unit = function (self)
	return self._unit
end

WwisePortalVolume.disable = function (self, unit)
	if Managers then
		self._open = false

		Managers.state.rooms_and_portals:toggle_portal(self, false)
	end
end

WwisePortalVolume.destroy = function (self, unit)
	if Managers then
		Managers.state.rooms_and_portals:remove_portal(self)
	end
end

WwisePortalVolume.update = function (self, unit, dt, t)
	return
end

WwisePortalVolume.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_debug_draw(unit)

	return true
end

WwisePortalVolume.editor_destroy = function (self, unit)
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

WwisePortalVolume._editor_debug_draw = function (self, unit)
	local should_debug_draw = self._should_debug_draw

	if should_debug_draw then
		local drawer = self._drawer

		drawer:reset()

		local tm = Unit.world_pose(unit, 1)
		local rotation = Matrix4x4.rotation(tm)
		local unit_forward = Quaternion.forward(rotation)
		local center = Unit.world_position(unit, 1)
		local from = center - unit_forward * 2
		local to = center + unit_forward * 2
		local color = Color.red()

		drawer:arrow_2d(from, to, color)

		local world = self._world

		drawer:update(world)
	else
		self._drawer:reset()
		self._drawer:update(self._world)
	end
end

WwisePortalVolume.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable
end

WwisePortalVolume.events.portal_added = function (self)
	local unit = self._unit

	if not self:get_data(unit, "start_enabled") then
		self:disable(unit)
	end
end

WwisePortalVolume.flow_enable = function (self)
	local unit = self._unit

	self:enable(unit)
end

WwisePortalVolume.flow_disable = function (self)
	local unit = self._unit

	self:disable(unit)
end

WwisePortalVolume.door_apply_portal_obstruction = function (self, door_is_closed, normalize_anim_time, anim_time, anim_duration)
	if Managers then
		local unit = self._unit
		local adjust_open_anim_time = self:get_data(unit, "adjust_open_anim_time")

		if adjust_open_anim_time then
			local actual_open_time = self:get_data(unit, "actual_open_time")
			local new_length = anim_duration - actual_open_time

			if new_length > 0 then
				local new_anim_time = anim_time - actual_open_time

				new_anim_time = math.max(new_anim_time, 0)
				normalize_anim_time = new_anim_time / new_length
			else
				Log.error("WwisePortalVolume", "[door_apply_portal_obstruction] Unit(%s, %s), 'actual_open_time' settings longer than door animation time. actual_open_time(%.2f) > anim_duration(%.2f)", tostring(unit), Unit.id_string(unit), actual_open_time, anim_duration)
			end
		end

		if door_is_closed then
			normalize_anim_time = 1 - normalize_anim_time
		end

		local min_obstruction = self:get_data(unit, "min_obstruction")
		local max_obstruction = self:get_data(unit, "max_obstruction")

		normalize_anim_time = 1 - normalize_anim_time
		normalize_anim_time = math.clamp(normalize_anim_time, 0, 1)
		normalize_anim_time = math.lerp(min_obstruction, max_obstruction, normalize_anim_time)

		local obstruction = normalize_anim_time
		local occlusion = normalize_anim_time

		if self._open then
			if obstruction >= 1 and occlusion >= 1 then
				Managers.state.rooms_and_portals:toggle_portal(self, false)

				self._open = false
			end
		elseif obstruction < 1 or occlusion < 1 then
			Managers.state.rooms_and_portals:toggle_portal(self, true)

			self._open = true
		end

		Managers.state.rooms_and_portals:set_portal_obstruction_and_occlusion(self, obstruction, occlusion)
	end
end

WwisePortalVolume.component_data = {
	start_enabled = {
		ui_name = "Start Enabled",
		ui_type = "check_box",
		value = true,
	},
	register_portal = {
		ui_name = "Register Portal",
		ui_type = "check_box",
		value = true,
	},
	min_obstruction = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 0.01,
		ui_name = "Lowest Possible Obstruction & Occlusion Ratio",
		ui_type = "number",
		value = 0,
	},
	max_obstruction = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 0.01,
		ui_name = "Higest Possible Obstruction & Occlusion Ratio",
		ui_type = "number",
		value = 1,
	},
	adjust_open_anim_time = {
		category = "Adjust Open Anim",
		ui_name = "Adjust Open Anim Time Calculation",
		ui_type = "check_box",
		value = false,
	},
	actual_open_time = {
		category = "Adjust Open Anim",
		decimals = 2,
		min = 0,
		step = 0.01,
		ui_name = "Actual Open Start Time (in sec.)",
		ui_type = "number",
		value = 0,
	},
	inputs = {
		flow_enable = {
			accessibility = "private",
			type = "event",
		},
		flow_disable = {
			accessibility = "private",
			type = "event",
		},
	},
}

return WwisePortalVolume
