local CollectionWidgets = require("scripts/managers/imgui/widgets/imgui_collection_widgets")
local InputWidgets = require("scripts/managers/imgui/widgets/imgui_input_widgets")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local WidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local DefaultDevParameters = require("scripts/foundation/utilities/parameters/default_dev_parameters").parameters
local ImguiDevParametersGui = class("ImguiDevParametersGui")
local FILTER_FUNCTION = WidgetUtilities.filter_functions.match_substring_replace_underscore
local FILTER_INPUT_FIELD_WIDTH = 200

ImguiDevParametersGui.init = function (self, config)
	self:_parse_config(config)
	self:_setup_filter(config)
	self:_setup_widget_collections()
end

ImguiDevParametersGui._get_dev_param_value = function (self, param_key, get_function)
	return DevParameters[param_key]
end

ImguiDevParametersGui._set_dev_param_value = function (self, param_key, on_value_set, new_value, old_value)
	ParameterResolver.set_dev_parameter(param_key, new_value)

	if on_value_set then
		on_value_set(new_value, old_value)
	end
end

ImguiDevParametersGui._parse_config = function (self, config)
	local config_parameters = config.parameters
	local config_categories = config.categories
	local widgets_by_category = {}
	local widgets_by_index = {}
	local widgets_by_name = {}
	local widget_names = {}

	for param_key, param_config in table.sorted(config_parameters, Managers.frame_table:get_table()) do
		if not param_config.hidden then
			local category = param_config.category or "Uncategorized"
			widgets_by_category[category] = widgets_by_category[category] or {}
			local index_in_category = #widgets_by_category[category] + 1
			local widget = self:_create_widget_from_config(param_key, param_config, category)
			widgets_by_category[category][index_in_category] = widget
			widget = self:_create_widget_from_config(param_key, param_config, category)
			widgets_by_index[#widgets_by_index + 1] = widget
			widgets_by_name[widget.display_name] = widget
			widget_names[#widget_names + 1] = widget.display_name
		end
	end

	self._widgets_by_category = widgets_by_category
	self._widgets_by_index = widgets_by_index
	self._widgets_by_name = widgets_by_name
	self._widget_names = widget_names
	local all_categories = table.clone(config_categories)
	all_categories[#all_categories + 1] = "Uncategorized"
	local categories = {}

	for i = 1, #all_categories do
		local category = all_categories[i]

		if widgets_by_category[category] then
			categories[#categories + 1] = category
		end
	end

	self._categories = categories
end

ImguiDevParametersGui._create_widget_from_config = function (self, param_key, config, category)
	local default_value = config.value
	local param_type = type(default_value)
	local display_name = config.name or param_key

	if config.value ~= nil then
		local get_value_func = callback(self, "_get_dev_param_value", param_key)
		local on_value_changed = callback(self, "_set_dev_param_value", param_key, config.on_value_set)

		if config.readonly then
			return InputWidgets.readonly.new(display_name, get_value_func)
		elseif config.options or config.options_function then
			return InputWidgets.dropdown.new(display_name, get_value_func, config.options_function or config.options, config.options_texts, on_value_changed, config.num_decimals, config.dynamic_contents)
		elseif param_type == "boolean" then
			return InputWidgets.checkbox.new(display_name, get_value_func, on_value_changed)
		elseif param_type == "number" then
			return InputWidgets.number_input.new(display_name, get_value_func, on_value_changed, config.num_decimals)
		elseif param_type == "string" then
			return InputWidgets.text_input.new(display_name, get_value_func, on_value_changed, true)
		end
	elseif config.readonly then
		return InputWidgets.readonly.new(display_name, config.get_function)
	elseif config.on_activated then
		if config.options or config.options_function then
			return InputWidgets.dropdown.new(display_name, config.get_function, config.options_function or config.options, config.options_texts, config.on_activated, config.num_decimals, config.dynamic_contents)
		elseif config.vector3_input then
			return InputWidgets.vector3.new(display_name, config.button_text, config.on_activated, config.num_decimals, config.width)
		elseif config.number_button then
			return InputWidgets.number_button.new(display_name, config.button_text and config.button_text or "Activate", config.on_activated, config.num_decimals, config.width)
		elseif config.debug_mission_input then
			return InputWidgets.debug_mission_input.new(display_name, config.button_text and config.button_text or "Activate", config.on_activated, config.maps, config.circumstances, config.side_missions, config.default_value, config.width)
		elseif config.get_function then
			param_type = type(config.get_function())

			if param_type == "boolean" then
				return InputWidgets.checkbox.new(display_name, config.get_function, config.on_activated)
			elseif param_type == "number" then
				return InputWidgets.number_input.new(display_name, config.get_function, config.on_activated, config.num_decimals)
			elseif param_type == "string" then
				return InputWidgets.text_input.new(display_name, config.get_function, config.on_activated, true)
			end
		else
			return InputWidgets.function_button.new(display_name, config.button_text and config.button_text or "Activate", config.on_activated)
		end
	end

	ferror("[ImguiDevParametersGui] Couldn't parse Dev Parameter %q", param_key)
end

ImguiDevParametersGui._setup_filter = function (self, config)
	local filter_widgets = {}
	self._filter_string = ""
	local get_filter_cb = callback(self, "_get_filter_string")
	local set_filter_cb = callback(self, "_set_filter_string")
	local text_display_name = "Filter Text"
	local return_value_on_enter = false
	self._filter_input_widget = InputWidgets.text_input.new(text_display_name, get_filter_cb, set_filter_cb, return_value_on_enter, FILTER_INPUT_FIELD_WIDTH)
	filter_widgets[#filter_widgets + 1] = self._filter_input_widget

	if config.enable_filter_by_defaults then
		self._filter_by_defaults = false
		local get_filter_by_defaults_cb = callback(self, "_get_filter_by_defaults")
		local set_filter_by_defaults_cb = callback(self, "_set_filter_by_defaults")
		local defaults_display_name = "Changed Settings Only"
		self._filter_by_defaults_input_widget = InputWidgets.checkbox.new(defaults_display_name, get_filter_by_defaults_cb, set_filter_by_defaults_cb)
		filter_widgets[#filter_widgets + 1] = self._filter_by_defaults_input_widget
	end

	self._filter_widget_list = CollectionWidgets.list.new(filter_widgets, false, false)
	self._filtered_categories = table.clone(self._categories)
	self._filtered_widgets = table.clone(self._widgets_by_index)
end

ImguiDevParametersGui._setup_widget_collections = function (self)
	local list_column_width = {
		WidgetUtilities.calculate_max_text_size(self._widget_names) + 20,
		400
	}
	self._widget_list = CollectionWidgets.list.new(self._filtered_widgets, false, list_column_width)
	local tree_lists = {}

	for _, category in pairs(self._filtered_categories) do
		tree_lists[category] = CollectionWidgets.list.new(self._widgets_by_category[category], true, list_column_width)
	end

	self._widget_tree = CollectionWidgets.list_tree.new(self._filtered_categories, tree_lists)
end

ImguiDevParametersGui._get_filter_by_defaults = function (self)
	return self._filter_by_defaults
end

ImguiDevParametersGui._set_filter_by_defaults = function (self, value)
	self:_filter_tree(self._filter_string, value, FILTER_FUNCTION)
	self:_filter_list(self._filter_string, value, FILTER_FUNCTION)

	self._filter_by_defaults = value
end

ImguiDevParametersGui._get_filter_string = function (self)
	return self._filter_string
end

ImguiDevParametersGui._set_filter_string = function (self, value)
	self:_filter_tree(value, self._filter_by_defaults, FILTER_FUNCTION)
	self:_filter_list(value, self._filter_by_defaults, FILTER_FUNCTION)

	self._filter_string = value
end

ImguiDevParametersGui.on_activated = function (self)
	if DevParameters.dev_params_gui_reset_filter_on_open then
		self:_set_filter_string("")
		CollectionWidgets.reset(self._widget_list)
	end

	self._reset_focus = true
end

ImguiDevParametersGui.update = function (self, dt, t)
	self:_render()
	self:_update_navigation()
end

ImguiDevParametersGui._render = function (self)
	CollectionWidgets.render(self._filter_widget_list)
	Imgui.text("")

	if self._filter_string ~= "" or self._filter_by_defaults then
		Imgui.indent()
		CollectionWidgets.render(self._widget_list)
		Imgui.unindent()
	end

	local auto_expand_tree = DevParameters.dev_params_gui_auto_expand_tree

	CollectionWidgets.render(self._widget_tree, auto_expand_tree)
end

ImguiDevParametersGui._update_navigation = function (self)
	local widget_list = self._widget_list
	local widget_tree = self._widget_tree
	local filter_input_widget = self._filter_input_widget
	local list_is_visible = self._filter_string ~= ""
	local auto_expand_tree = DevParameters.dev_params_gui_auto_expand_tree

	if self._reset_focus then
		self._reset_focus = nil

		WidgetUtilities.activate_widget(filter_input_widget.label)
	elseif auto_expand_tree and not list_is_visible and filter_input_widget.is_focused and Imgui.is_key_pressed(Imgui.KEY_DOWN_ARROW) then
		if #widget_tree.nodes > 0 then
			WidgetUtilities.open_tree_node(widget_tree.nodes[1])
		end
	elseif auto_expand_tree and widget_list.focused_index == #widget_list.widgets and Imgui.is_key_pressed(Imgui.KEY_DOWN_ARROW) then
		if #widget_tree.nodes > 0 then
			WidgetUtilities.open_tree_node(widget_tree.nodes[1])
		end
	elseif widget_list.focused_index == 1 and not widget_list.active_index and Imgui.is_key_pressed(Imgui.KEY_UP_ARROW) then
		WidgetUtilities.activate_widget(filter_input_widget.label)
	elseif not list_is_visible and widget_tree.focused_node_index == 1 and Imgui.is_key_pressed(Imgui.KEY_UP_ARROW) then
		WidgetUtilities.activate_widget(filter_input_widget.label)
	elseif not widget_list.active_index and not widget_tree.active_widget_index and Imgui.is_key_pressed(Imgui.KEY_BACKSPACE) then
		WidgetUtilities.focus_widget(filter_input_widget.label)
		WidgetUtilities.activate_widget(filter_input_widget.label)

		if auto_expand_tree and widget_tree.focused_node_index then
			WidgetUtilities.close_tree_node(widget_tree.nodes[widget_tree.focused_node_index])
		end
	end
end

ImguiDevParametersGui._filter_tree = function (self, filter_string, filter_defaults, filter_func)
	local categories = self._categories
	local filtered_categories = self._filtered_categories

	table.clear(filtered_categories)

	if filter_defaults then
		return
	end

	WidgetUtilities.filter_array(categories, filtered_categories, filter_string, filter_func)
end

local string_filtered_widget_names = {}
local default_filtered_widget_names = {}

ImguiDevParametersGui._filter_list = function (self, filter_string, filter_defaults, filter_func)
	table.clear(string_filtered_widget_names)
	table.clear(default_filtered_widget_names)

	local filtered_widget_names = nil
	local widget_names = self._widget_names

	WidgetUtilities.filter_array(widget_names, string_filtered_widget_names, filter_string, filter_func)

	if filter_defaults then
		WidgetUtilities.filter_array_defaults(string_filtered_widget_names, default_filtered_widget_names, DevParameters, DefaultDevParameters)

		filtered_widget_names = default_filtered_widget_names
	else
		filtered_widget_names = string_filtered_widget_names
	end

	local widgets_by_name = self._widgets_by_name
	local filtered_widgets = self._filtered_widgets

	table.clear(filtered_widgets)

	for i = 1, #filtered_widget_names do
		local widget_name = filtered_widget_names[i]
		filtered_widgets[i] = widgets_by_name[widget_name]
	end
end

return ImguiDevParametersGui
