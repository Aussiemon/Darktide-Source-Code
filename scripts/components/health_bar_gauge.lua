-- chunkname: @scripts/components/health_bar_gauge.lua

local HealthBarGauge = component("HealthBarGauge")

HealthBarGauge.init = function (self, unit)
	self.needle_node_name = self:get_data(unit, "needle_node_name")
	self.needle_node_handle = Unit.node(self.unit, self.needle_node_name)
	self.offset_min = self:get_data(unit, "offset_min")
	self.offset_max = self:get_data(unit, "offset_max")
	self.offset_axis = self:get_data(unit, "offset_axis")
	self.enabled = self:get_data(unit, "enabled")
	self.current_health_percent = -1

	self:enable(unit)
end

HealthBarGauge.editor_init = function (self, unit)
	self.needle_node_name = self:get_data(unit, "needle_node_name")

	self:enable(unit)

	self._should_debug_draw = false
end

HealthBarGauge.enable = function (self, unit)
	self:set_health(unit, 1)
end

HealthBarGauge.disable = function (self, unit)
	return
end

HealthBarGauge.destroy = function (self, unit)
	return
end

HealthBarGauge.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

HealthBarGauge.set_health = function (self, unit, health_percent)
	if self.enabled and health_percent ~= self.current_health_percent then
		self.current_health_percent = health_percent

		local needle_offset = math.lerp(self.offset_min, self.offset_max, health_percent)
		local new_rotation = Vector3.zero()
		local new_position = Vector3.zero()
		local parent_node_index = Unit.node(unit, self.needle_node_name)

		if self.offset_axis == "rotation_x" or self.offset_axis == "rotation_y" or self.offset_axis == "rotation_z" then
			if self.offset_axis == "rotation_x" then
				Vector3.set_x(new_rotation, needle_offset)
			elseif self.offset_axis == "rotation_y" then
				Vector3.set_y(new_rotation, needle_offset)
			elseif self.offset_axis == "rotation_z" then
				Vector3.set_z(new_rotation, needle_offset)
			end

			local rotation = Quaternion.from_euler_angles_xyz(new_rotation.x, new_rotation.y, new_rotation.z)

			Unit.set_local_rotation(unit, parent_node_index, rotation)
		else
			if self.offset_axis == "position_x" then
				Vector3.set_x(new_position, needle_offset)
			elseif self.offset_axis == "position_y" then
				Vector3.set_y(new_position, needle_offset)
			elseif self.offset_axis == "position_z" then
				Vector3.set_z(new_position, needle_offset)
			end

			Unit.set_local_position(unit, parent_node_index, new_position)
		end
	end
end

HealthBarGauge.component_data = {
	enabled = {
		ui_name = "Enabled",
		ui_type = "check_box",
		value = false,
	},
	needle_node_name = {
		ui_name = "Needle Bone Name",
		ui_type = "text_box",
		value = "j_needle",
	},
	offset_min = {
		max = 90,
		min = -90,
		ui_name = "Offset Min",
		ui_type = "slider",
		value = 35,
	},
	offset_max = {
		max = 90,
		min = -90,
		ui_name = "Offset Max",
		ui_type = "slider",
		value = -35,
	},
	offset_axis = {
		ui_name = "Offset Axis",
		ui_type = "combo_box",
		value = "rotation_y",
		options_keys = {
			"rotation_x",
			"rotation_y",
			"rotation_z",
			"position_x",
			"position_y",
			"position_z",
		},
		options_values = {
			"rotation_x",
			"rotation_y",
			"rotation_z",
			"position_x",
			"position_y",
			"position_z",
		},
	},
}

return HealthBarGauge
