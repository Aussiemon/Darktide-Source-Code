local Annotation = component("Annotation")

Annotation.init = function (self, unit)
	self._unit = unit
	self._color_boxed = self:get_data(unit, "color")
	self._description = self:get_data(unit, "description")
	self._font_size = self:get_data(unit, "font_size")

	return true
end

Annotation.destroy = function (self)
	return
end

Annotation.update = function (self)
	local color_boxed = self._color_boxed
	local x, y, z, _ = Quaternion.to_elements(color_boxed:unbox())
	local text_color = Color(x, y, z)
	local description = self._description
	local font_size = self._font_size
	local unit = self._unit
	local position = Unit.world_position(unit, 1)
	local options = {
		text_size = font_size,
		color = text_color,
		rotation = Unit.world_rotation(unit, 1)
	}

	return true
end

Annotation.editor_init = function (self, unit)
	self._unit = unit
	local world = Application.main_world()
	self._world = world
	self._should_debug_draw = true
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)
	self._debug_text_id = nil

	self:_editor_draw_text()

	return false
end

Annotation.editor_destroy = function (self)
	local gui = self._gui

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)

		self._debug_text_id = nil
	end

	local world = self._world

	World.destroy_gui(world, gui)

	self._world = nil
	self._gui = nil
end

Annotation.editor_update = function (self, unit)
	return false
end

Annotation.enable = function (self, unit)
	return
end

Annotation.disable = function (self, unit)
	return
end

Annotation.editor_world_transform_modified = function (self, unit)
	self:_editor_draw_text()
end

Annotation.editor_property_changed = function (self, unit)
	self:_editor_draw_text()
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"

Annotation._editor_draw_text = function (self)
	local gui = self._gui

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)

		self._debug_text_id = nil
	end

	if self._should_debug_draw then
		local unit = self._unit
		local color_boxed = self:get_data(unit, "color")
		local x, y, z, _ = Quaternion.to_elements(color_boxed:unbox())
		local text_color = Color(x, y, z)
		local description = self:get_data(unit, "description")
		local font_size = self:get_data(unit, "font_size")
		local text_pose = Unit.world_pose(unit, 1)
		local offset = self:_offset(unit, gui, description, FONT, font_size)
		local layer = 1
		self._debug_text_id = Gui.text_3d(gui, description, FONT_MATERIAL, font_size, FONT, text_pose, offset, layer, text_color)
	end
end

Annotation._offset = function (self, unit, gui, text, font, font_size)
	local min, max = Gui.slug_text_max_extents(gui, text, font, font_size, "flags", Gui.FormatDirectives)
	local text_width = max.x - min.x
	local text_height = max.y - min.y
	local offset = Vector3(-text_width * 0.5, text_height * 0.5, 0)

	return offset
end

Annotation.editor_toggle_debug_draw = function (self, enabled)
	self._should_debug_draw = enabled

	self:_editor_draw_text()
end

Annotation.component_data = {
	description = {
		ui_type = "text_box",
		value = "",
		ui_name = "Description"
	},
	color = {
		ui_type = "color",
		ui_name = "Color",
		value = QuaternionBox(1, 0.5, 0, 0.5)
	},
	font_size = {
		ui_type = "number",
		min = 0.3,
		step = 0.1,
		decimals = 1,
		value = 0.3,
		ui_name = "Font Size",
		max = 1.5
	}
}

return Annotation
