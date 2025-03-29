-- chunkname: @scripts/extension_systems/weapon/actions/debug/sweep_editor.lua

local Action = require("scripts/utilities/action/action")
local SweepSpline = require("scripts/extension_systems/weapon/actions/utilities/sweep_spline")
local SweepSplineExported = require("scripts/extension_systems/weapon/actions/utilities/sweep_spline_exported")
local SweepSplineVisualizer = require("scripts/extension_systems/weapon/actions/utilities/sweep_spline_visualizer")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local SweepEditor = class("SweepEditor")

SweepEditor.LOG_TAG = "SweepEditor"

local POINT_MODIFICATION_TYPES = {
	"up",
	"depth",
}

for i = 1, #POINT_MODIFICATION_TYPES do
	local type_name = POINT_MODIFICATION_TYPES[i]

	POINT_MODIFICATION_TYPES[type_name] = i
end

SweepEditor.init = function (self)
	self._drawer = Debug:drawer({
		mode = "immediate",
		name = "SweepEditor",
	})
	self._input_service = nil
end

SweepEditor.run = function (self, unit, weapon_template_name, action_name)
	self._first_person_component = ScriptUnit.extension(unit, "unit_data_system"):read_component("first_person")

	local weapon_template = WeaponTemplates[weapon_template_name]
	local action_settings = Action.action_settings(weapon_template, action_name)
	local spline_settings = action_settings.spline_settings
	local sweep_type

	if spline_settings.matrices_data_location then
		self._sweep_spline = SweepSplineExported:new(action_settings, self._first_person_component)
		sweep_type = "exported"
	else
		self._sweep_spline = SweepSpline:new(action_settings.spline_settings, self._first_person_component)
		sweep_type = "hermite"
	end

	self._sweep_type = sweep_type
	self._sweep_time = 1
	self._sweep_timer = 0
	self._selected_point = 1
	self._action_settings = action_settings
	self._point_modification_index = 1
	self._modifying_anchor_point = false
	self._weapon_template_name = weapon_template_name
	self._action_name = action_name
end

SweepEditor._exit = function (self)
	self._sweep_spline = nil
end

SweepEditor._dump = function (self)
	local spline_settings = self._action_settings.spline_settings
	local dump_string = string.format("%s - %s\nspline_settings = {\n", self._weapon_template_name, self._action_name)
	local apo = spline_settings.anchor_point_offset

	dump_string = string.format("%s    anchor_point_offset = {%.2f, %.2f, %.2f},\n", dump_string, apo[1], apo[2], apo[3])

	local points = spline_settings.points

	dump_string = string.format("%s    points = {\n", dump_string)

	for i = 1, #points do
		local point = points[i]

		dump_string = string.format("%s        {%.2f, %.2f, %.2f},\n", dump_string, point[1], point[2], point[3])
	end

	dump_string = string.format("%s    },\n", dump_string)
	dump_string = string.format("%s},", dump_string)

	Log.info(SweepEditor.LOG_TAG, dump_string)
end

SweepEditor._rebuild = function (self, spline_settings)
	self._sweep_spline:rebuild(spline_settings)
end

SweepEditor.update = function (self, dt, t)
	self._input_service = Debug:debug_input_service()

	local sweep_spline = self._sweep_spline

	if sweep_spline then
		if self._sweep_type == "exported" then
			-- Nothing
		elseif self._sweep_type == "hermite" then
			self._selected_point = self:_update_point_cycling(sweep_spline, self._selected_point)
			self._modifying_anchor_point = self:_update_anchor_point_toggle(self._modifying_anchor_point)
			self._point_modification_index = self:_update_point_modification_cycling(self._point_modification_index)

			local spline_settings = self._action_settings.spline_settings
			local rebuild

			if self._modifying_anchor_point then
				local point = spline_settings.anchor_point_offset

				rebuild = self:_update_point_modification(sweep_spline, point, self._point_modification_index, dt)
			else
				local point = spline_settings.points[self._selected_point]

				rebuild = self:_update_point_modification(sweep_spline, point, self._point_modification_index, dt)
			end

			if rebuild then
				self:_rebuild(spline_settings)
			end
		end

		local sweep_timer = self._sweep_timer
		local sweep_time = self._sweep_time

		self:_draw(sweep_timer, sweep_time)

		if sweep_timer == sweep_time then
			self._sweep_timer = 0
		else
			self._sweep_timer = math.min(sweep_timer + dt, self._sweep_time)
		end

		if self._input_service:get("sweep_editor_dump") then
			self:_dump()
		end

		if self._input_service:get("sweep_editor_exit") then
			self:_exit()
		end
	end
end

SweepEditor._update_anchor_point_toggle = function (self, modifying_anchor_point)
	if self._input_service:get("sweep_anchor_point_toggle") then
		return not modifying_anchor_point
	end

	return modifying_anchor_point
end

SweepEditor._update_point_cycling = function (self, sweep_spline, selected_point)
	local index = selected_point - 1

	if self._input_service:get("sweep_point_forward") then
		index = index + 1
	end

	if self._input_service:get("sweep_point_backward") then
		index = index - 1
	end

	local num_points = sweep_spline:num_points()

	return index % num_points + 1
end

SweepEditor._update_point_modification_cycling = function (self, current_modification_index)
	local index = current_modification_index - 1

	if self._input_service:get("sweep_point_axis_cycle") then
		index = index + 1
	end

	local num_types = #POINT_MODIFICATION_TYPES

	return index % num_types + 1
end

SweepEditor._update_point_modification = function (self, sweep_spline, point, modification_index, dt)
	local up_down = 0

	if self._input_service:get("up_key_hold") then
		up_down = 1
	elseif self._input_service:get("down_key_hold") then
		up_down = -1
	end

	local left_right = 0

	if self._input_service:get("left_key_hold") then
		left_right = -1
	elseif self._input_service:get("right_key_hold") then
		left_right = 1
	end

	if up_down == 0 and left_right == 0 then
		return false
	end

	local increment_value = 0.1
	local modification_type = POINT_MODIFICATION_TYPES[modification_index]

	if modification_type == "up" then
		point[1] = point[1] + increment_value * left_right * dt
		point[3] = point[3] + increment_value * up_down * dt
	elseif modification_type == "depth" then
		point[1] = point[1] + increment_value * left_right * dt
		point[2] = point[2] + increment_value * up_down * dt
	end

	return true
end

SweepEditor._update_axis_cycling = function (self, axis)
	local index = axis - 1

	if self._input_service:get("sweep_point_axis_cycle") then
		index = index + 1
	end

	return index % 3 + 1
end

SweepEditor._draw = function (self, sweep_timer, sweep_time)
	local drawer = self._drawer
	local sweep_spline = self._sweep_spline
	local combined_spline, control_splines = true, false
	local color = Color.white()

	SweepSplineVisualizer.draw_splines(sweep_spline, drawer, sweep_time, combined_spline, control_splines, color)

	local sweep_t = sweep_timer / sweep_time
	local show_rotation = true

	SweepSplineVisualizer.draw_point_on_spline(sweep_spline, drawer, sweep_t, show_rotation)

	if self._sweep_type == "hermite" then
		self:_draw_points(drawer, sweep_spline, self._point_modification_index)

		sweep_t = sweep_timer / sweep_time

		self:_draw_current_position(drawer, sweep_spline, sweep_t)
		self:_draw_point_modification_type(self._point_modification_index)

		if self._modifying_anchor_point then
			self:_draw_modifying_anchor_point()
		else
			self:_draw_selected_point(self._selected_point)
		end
	end
end

SweepEditor._draw_curves = function (self, drawer, sweep_spline, sweep_time)
	sweep_spline:draw_curves(drawer, Color.white(), sweep_time)
end

SweepEditor._draw_points = function (self, drawer, sweep_spline, modification_index)
	local num_points = sweep_spline:num_points()

	for i = 1, num_points do
		local selected_point = self._modifying_anchor_point or i == self._selected_point
		local color = selected_point and Color.gold() or Color.black()

		sweep_spline:draw_point(drawer, color, i)

		if selected_point then
			local length = 0.1
			local rotation = self._first_person_component.rotation
			local right = Quaternion.rotate(rotation, Vector3.right())

			sweep_spline:draw_vector_at_point(drawer, Color.red(), i, right * length)

			local dir, dir_color
			local modification_type = POINT_MODIFICATION_TYPES[modification_index]

			if modification_type == "up" then
				dir = Vector3.up()
				dir_color = Color.blue()
			elseif modification_type == "depth" then
				dir = Vector3.forward()
				dir_color = Color.green()
			end

			dir = Quaternion.rotate(rotation, dir)

			sweep_spline:draw_vector_at_point(drawer, dir_color, i, dir * length)
		end
	end
end

SweepEditor._draw_point_modification_type = function (self, point_modification_index)
	local type_name = POINT_MODIFICATION_TYPES[point_modification_index]

	Debug:text("Current point modification type: %s", type_name)
end

SweepEditor._draw_modifying_anchor_point = function (self)
	Debug:text("Modyfing anchor point offset.")

	local point = self._action_settings.spline_settings.anchor_point_offset

	Debug:text("{%.2f, %.2f, %.2f}", point[1], point[2], point[3])
end

SweepEditor._draw_selected_point = function (self, selected_point)
	Debug:text("Modifying point: %i", selected_point)

	local point = self._action_settings.spline_settings.points[selected_point]

	Debug:text("{%.2f, %.2f, %.2f}", point[1], point[2], point[3])
end

SweepEditor._draw_current_position = function (self, drawer, sweep_spline, t)
	local position, rotation = sweep_spline:position_and_rotation(t)

	drawer:sphere(position, 0.01, Color.white())
	drawer:quaternion(position, rotation, 0.1)
end

return SweepEditor
