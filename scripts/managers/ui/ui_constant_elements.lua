-- chunkname: @scripts/managers/ui/ui_constant_elements.lua

require("scripts/ui/constant_elements/constant_element_base")

local Hud = require("scripts/utilities/ui/hud")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local VisibilityGroups = require("scripts/ui/constant_elements/constant_element_visibility_groups")
local resolution_modified_key = "modified"
local UIConstantElements = class("UIConstantElements")

UIConstantElements.init = function (self, parent, elements)
	self._parent = parent
	self._render_settings = {}
	self._world_name = self.__class_name .. "_ui_world"
	self._world = parent:create_world(self._world_name, 900)

	local viewport_name = self.__class_name .. "_ui_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = parent:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_renderer_name = self.__class_name .. "_ui_renderer"
	self._ui_renderer = parent:create_renderer(self._ui_renderer_name, self._world)
	self._elements = {}
	self._elements_array = {}
	self._elements_hud_scale_lookup = {}
	self._visibility_groups = table.clone(VisibilityGroups)
	self._visibility_group_parameters = {}

	local element_definitions = table.clone(elements)

	self:_setup_visiblity_groups(element_definitions)
	self:_setup_elements(element_definitions)

	self._element_definitions = element_definitions
end

UIConstantElements.using_input = function (self)
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element.using_input and element:using_input() then
			return true
		end
	end

	return false
end

UIConstantElements.is_element_using_input = function (self, element_name)
	local element = self._elements[element_name]

	if element and element.using_input and element:using_input() then
		return true
	end

	return false
end

UIConstantElements.chat_using_input = function (self)
	local chat = self._elements.ConstantElementChat

	return chat and chat:using_input()
end

UIConstantElements._setup_visiblity_groups = function (self, element_definitions)
	local visibility_groups_lookup = {}

	for _, settings in ipairs(self._visibility_groups) do
		local name = settings.name

		visibility_groups_lookup[name] = settings
	end

	for definitions_index = 1, #element_definitions do
		local definition = element_definitions[definitions_index]
		local class_name = definition.class_name
		local visibility_groups = definition.visibility_groups
		local visibility_group_parameters = definition.visibility_group_parameters
		local fallback_parameter_key = definition.visibility_group_parameters_fallback
		local fallback_parameters = visibility_group_parameters and fallback_parameter_key and visibility_group_parameters[fallback_parameter_key]

		for group_index = 1, #visibility_groups do
			local group_name = visibility_groups[group_index]
			local visibility_group = visibility_groups_lookup[group_name]
			local validation_function = visibility_group.validation_function

			if not visibility_group.visible_elements then
				visibility_group.visible_elements = {}
			end

			local visible_elements = visibility_group.visible_elements

			visible_elements[class_name] = true

			local group_parameters = self._visibility_group_parameters[group_name]

			if not group_parameters then
				self._visibility_group_parameters[group_name] = {}
				group_parameters = self._visibility_group_parameters[group_name]
			end

			group_parameters[class_name] = visibility_group_parameters and visibility_group_parameters[group_name] or fallback_parameters
		end
	end
end

UIConstantElements._setup_elements = function (self, element_definitions)
	local package_manager = Managers.package
	local asynchronous = true

	for _, definition in ipairs(element_definitions) do
		self:_setup_element(definition)
	end
end

UIConstantElements._setup_element = function (self, definition)
	local elements = self._elements
	local elements_array = self._elements_array
	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local class_name = definition.class_name

	if definition.use_hud_scale then
		elements_hud_scale_lookup[class_name] = true
	end

	self:_add_element(definition, elements, elements_array)

	self._current_group_name = nil
end

UIConstantElements._add_element = function (self, definition, elements, elements_array)
	local class_name = definition.class_name
	local validation_function = definition.validation_function

	if not validation_function or validation_function(self) then
		local filename = definition.filename
		local class = require(filename)
		local draw_layer = definition.draw_layer or 0
		local element = class:new(self, draw_layer)

		elements[class_name] = element

		local id = #elements_array + 1

		elements_array[id] = element
	end
end

UIConstantElements.element = function (self, element_name)
	local elements = self._elements
	local element = elements[element_name]

	return element
end

UIConstantElements.ui_renderer = function (self)
	return self._ui_renderer
end

UIConstantElements.post_update = function (self, dt, t)
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name

		if element.post_update and element:should_update() then
			element:post_update(dt, t)
		end
	end
end

UIConstantElements.update = function (self, dt, t, input_service)
	local ui_renderer = self._ui_renderer

	self:_update_element_visibility()
	self:_update_hud_scale_modified()

	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local elements_array = self._elements_array
	local hud_scale_applied = false
	local render_settings = self._render_settings
	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key] or self._hud_scale_modified

	self._hud_scale_modified = nil

	if resolution_modified then
		local scale = RESOLUTION_LOOKUP.scale

		render_settings.scale = scale
		render_settings.inverse_scale = 1 / scale
		render_settings.using_hud_scale = nil
	end

	local using_input = self:using_input()

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name

		if elements_hud_scale_lookup[element_name] then
			hud_scale_applied = true

			self:_apply_hud_scale()
		end

		if resolution_modified then
			if element.set_render_scale then
				element:set_render_scale(render_settings.scale)
			end

			if element.on_resolution_modified then
				element:on_resolution_modified(render_settings.scale)
			end
		end

		if element:should_update() then
			local handle_input = not using_input or element.using_input and element:using_input()

			element:update(dt, t, ui_renderer, render_settings, handle_input and input_service or input_service:null_service())

			if not using_input and element.using_input and element:using_input() then
				using_input = true
			end
		end

		if hud_scale_applied then
			self:_abort_hud_scale()
		end
	end
end

UIConstantElements.draw = function (self, dt, t, input_service)
	local ui_renderer = self._ui_renderer
	local render_settings = self._render_settings
	local saved_start_layer = render_settings.start_layer
	local elements_array = self._elements_array
	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local alpha_multiplier = render_settings.alpha_multiplier
	local hud_scale_applied = false
	local using_input = self:using_input()

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name

		if elements_hud_scale_lookup[element_name] then
			hud_scale_applied = true

			self:_apply_hud_scale()
		end

		if element:should_draw() then
			render_settings.alpha_multiplier = 1

			local handle_input = not using_input or element.using_input and element:using_input()

			element:draw(dt, t, ui_renderer, render_settings, handle_input and input_service or input_service:null_service())

			if not using_input and element.using_input and element:using_input() then
				using_input = true
			end
		end

		if hud_scale_applied then
			self:_abort_hud_scale()
		end
	end

	render_settings.alpha_multiplier = alpha_multiplier
	render_settings.start_layer = saved_start_layer
end

UIConstantElements._apply_hud_scale = function (self)
	local new_scale = Hud.hud_scale()
	local render_settings = self._render_settings

	render_settings.scale = new_scale
	render_settings.inverse_scale = 1 / new_scale
	render_settings.using_hud_scale = true
end

UIConstantElements._abort_hud_scale = function (self)
	local render_settings = self._render_settings
	local scale = RESOLUTION_LOOKUP.scale

	render_settings.scale = scale
	render_settings.inverse_scale = 1 / scale
	render_settings.using_hud_scale = nil
end

UIConstantElements.destroy = function (self)
	local elements_array = self._elements_array

	for _, element in ipairs(elements_array) do
		if element.destroy then
			element:destroy()
		end
	end

	self._elements = nil
	self._elements_array = nil

	ScriptWorld.destroy_viewport(self._world, self._viewport_name)

	self._viewport = nil
	self._viewport_name = nil
	self._ui_renderer = nil

	self._parent:destroy_renderer(self._ui_renderer_name)

	self._ui_renderer_name = nil

	self._parent:destroy_world(self._world)

	self._world = nil
	self._world_name = nil
	self._element_definitions = nil
end

UIConstantElements._update_element_visibility = function (self)
	local visibility_groups = self._visibility_groups
	local num_visibility_groups = #visibility_groups

	for i = 1, num_visibility_groups do
		local visibility_group = visibility_groups[i]
		local group_name = visibility_group.name
		local validation_function = visibility_group.validation_function
		local is_active = not validation_function or validation_function(self)

		if is_active then
			if group_name ~= self._current_group_name then
				local elements_array = self._elements_array
				local visible_elements = visibility_group.visible_elements
				local visibility_group_parameters = self._visibility_group_parameters[group_name]

				for j = 1, #elements_array do
					local element = elements_array[j]
					local element_name = element.__class_name
					local status = visible_elements and visible_elements[element_name] or false
					local visibility_parameters = visibility_group_parameters and visibility_group_parameters[element_name]

					element:set_visible(status, visibility_parameters)
				end

				self._current_group_name = group_name
			end

			break
		end
	end
end

UIConstantElements._update_hud_scale_modified = function (self)
	local new_scale = Hud.hud_scale()

	if self._hud_scale_value ~= new_scale then
		self._hud_scale_value = new_scale
		self._hud_scale_modified = true
	end
end

return UIConstantElements
