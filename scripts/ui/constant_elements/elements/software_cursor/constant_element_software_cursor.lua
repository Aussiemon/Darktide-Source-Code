local class_definitions = require("scripts/ui/constant_elements/elements/software_cursor/constant_element_software_cursor_definitions")
local ConstantElementBase = require("scripts/ui/constant_elements/constant_element_base")
local ConstantElementSoftwareCursor = class("ConstantElementSoftwareCursor", "ConstantElementBase")

ConstantElementSoftwareCursor.init = function (self, parent, draw_layer, start_scale, definitions)
	ConstantElementSoftwareCursor.super.init(self, parent, draw_layer, start_scale, class_definitions)

	self._cursor_settings = class_definitions.cursor_settings
end

ConstantElementSoftwareCursor._recreate_software_cursor = function (self, render_settings)
	self._cursor_settings = class_definitions.cursor_settings
	self._ui_scenegraph = ConstantElementSoftwareCursor.super._create_scenegraph(self, class_definitions, render_settings.scale)
	self._widgets_by_name = {}
	self._widgets = {}

	ConstantElementSoftwareCursor.super._create_widgets(self, class_definitions, self._widgets, self._widgets_by_name)
end

ConstantElementSoftwareCursor.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	self:_handle_input(input_service)
	ConstantElementSoftwareCursor.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementSoftwareCursor._handle_input = function (self, input_service)
	local cursor_pos = input_service:get("cursor")
	local left_held = input_service:get("left_hold")
	local pos1 = math.clamp(cursor_pos[1], 0, 1920)
	local pos2 = math.clamp(cursor_pos[2], 0, 1080) - 1080
	local widget = self._widgets_by_name.software_cursor
	local widget_content = widget.content
	widget_content.left_held = left_held
	widget.offset[1] = pos1
	widget.offset[2] = pos2
end

return ConstantElementSoftwareCursor
