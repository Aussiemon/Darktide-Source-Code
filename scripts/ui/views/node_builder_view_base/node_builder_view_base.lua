-- chunkname: @scripts/ui/views/node_builder_view_base/node_builder_view_base.lua

local Definitions = require("scripts/ui/views/node_builder_view_base/node_builder_view_base_definitions")
local Colors = require("scripts/utilities/ui/colors")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local NODE_STATUS = table.enum("locked", "available", "unavailable", "capped")
local NodeBuilderViewBase = class("NodeBuilderViewBase", "BaseView")

NodeBuilderViewBase.NODE_STATUS = NODE_STATUS

NodeBuilderViewBase.init = function (self, definitions, settings, context)
	self._base_definitions = table.clone_instance(Definitions)

	if definitions then
		table.merge_recursive(self._base_definitions, definitions)
	end

	self._player_mode = context and (context.player_mode or context.changeable_context and context.changeable_context.player_mode)
	self._saved_scenegraph_settings = {}
	self._render_cache_data = {}
	self._global_node_offset = {
		0,
		0,
	}
	self._nodes_render_order_list = {}
	self._current_zoom = 1
	self._layouts = {}
	self._node_widgets = {}
	self._incompatible_talents = {}
	self._points_spent_on_node_widgets = {}
	self._node_points_spent = 0

	NodeBuilderViewBase.super.init(self, self._base_definitions, settings, context)

	self._pass_input = self._player_mode
	self._pass_draw = self._player_mode
	self._allow_close_hotkey = not self._player_mode
end

NodeBuilderViewBase.on_enter = function (self)
	NodeBuilderViewBase.super.on_enter(self)

	local overlay_scenegraph_definition = self._definitions.overlay_scenegraph_definition

	self._ui_overlay_scenegraph = UIScenegraph.init_scenegraph(overlay_scenegraph_definition, self._render_scale)

	self:_setup_node_connection_widget()
	self:_setup_layouts()

	local layout_widgets = {}
	local layout_widget_definitions = self._definitions.layout_widget_definitions

	for widget_name, definition in pairs(layout_widget_definitions) do
		layout_widgets[#layout_widgets + 1] = self:_create_widget(widget_name, definition)
	end

	self._layout_widgets = layout_widgets

	local first_layout = self._layouts[1]
	local first_layout_name = first_layout and first_layout.name

	if first_layout_name then
		self:_activate_layout_by_name(first_layout_name)
	end
end

NodeBuilderViewBase._setup_node_connection_widget = function (self)
	self._node_connection_widget = self:_create_widget("node_connection", self._definitions.default_node_connection_definition)
end

NodeBuilderViewBase._setup_layouts = function (self)
	return
end

NodeBuilderViewBase.on_exit = function (self)
	NodeBuilderViewBase.super.on_exit(self)
end

NodeBuilderViewBase._destroy_node_widgets = function (self)
	if self._node_widgets then
		for i = #self._node_widgets, 1, -1 do
			local widget = self._node_widgets[i]
			local widget_name = widget.name

			self:_destroy_node_widget(widget_name)
		end
	end
end

NodeBuilderViewBase._destroy_node_widget = function (self, widget_name)
	local ui_renderer = self._ui_renderer

	if self._node_widgets then
		for i = 1, #self._node_widgets do
			local widget = self._node_widgets[i]

			if widget.name == widget_name then
				self:_unregister_widget_name(widget_name)
				UIWidget.destroy(ui_renderer, widget)
				table.remove(self._node_widgets, i)

				break
			end
		end
	end
end

NodeBuilderViewBase._get_node_definition_by_type = function (self, node_type)
	local default_scenegraph_definition = self:_get_scenegraph_definition("node_pivot")
	local scenegraph_definition = table.clone(default_scenegraph_definition)
	local definitions = self._definitions
	local fallback_node_definition = definitions.fallback_node_definition

	return fallback_node_definition, scenegraph_definition
end

NodeBuilderViewBase._create_node_widget = function (self, node)
	local widget_name = node.widget_name
	local node_type = node.type
	local node_definition, node_scenegraph_definition = self:_get_node_definition_by_type(node_type)

	self:_add_scenegraph_definition(widget_name, table.clone(node_scenegraph_definition))

	local widget = self:_create_widget(widget_name, node_definition)

	widget.scenegraph_id = widget_name
	widget.content.node_data = node

	local hotspot = widget.content.hotspot

	if hotspot then
		widget.content.hotspot.released_callback = callback(self, "_on_node_widget_left_pressed", widget)
		widget.content.hotspot.right_pressed_callback = callback(self, "_on_node_widget_right_pressed", widget)
	end

	return widget
end

NodeBuilderViewBase._on_node_widget_left_pressed = function (self, widget)
	local success = false
	local already_spent_node_points, max_points = self:_node_points_by_widget(widget)

	if already_spent_node_points < max_points then
		local content = widget.content
		local node_data = content.node_data
		local status = self:_node_availability_status(node_data)

		if status == NODE_STATUS.available then
			success = self:_add_node_point_on_widget(widget)
		end
	end

	return success
end

NodeBuilderViewBase._has_points_spent_in_children = function (self, node)
	local children = node.children
	local parents = node.parents
	local children_counter = 0
	local children_link_counter = 0

	if children then
		local points_spent_on_node_widgets = self._points_spent_on_node_widgets

		for i = 1, #children do
			local child_name = children[i]
			local points_spent = points_spent_on_node_widgets[child_name] or 0

			if points_spent > 0 then
				children_counter = children_counter + 1

				if table.find(parents, child_name) then
					children_link_counter = children_link_counter + 1
				end
			end
		end
	end

	return children_counter > 0, children_counter, children_link_counter
end

NodeBuilderViewBase._has_points_spent_in_parents = function (self, node)
	local parents = node.parents
	local parent_counter = 0

	if parents then
		local points_spent_on_node_widgets = self._points_spent_on_node_widgets

		for i = 1, #parents do
			local parent_name = parents[i]
			local points_spent = points_spent_on_node_widgets[parent_name] or 0

			if points_spent > 0 then
				parent_counter = parent_counter + 1
			end
		end
	end

	return parent_counter > 0, parent_counter
end

NodeBuilderViewBase._is_nodes_bridge_linked = function (self, node_1, node_2)
	if node_1.parents and node_1.children then
		for _, parent_name in ipairs(node_1.parents) do
			if parent_name == node_2.widget_name then
				return true
			end
		end
	end
end

NodeBuilderViewBase._has_node_bridge_links = function (self, node)
	if node.parents and node.children then
		for _, parent_name in ipairs(node.parents) do
			if table.find(node.children, parent_name) then
				return true
			end
		end
	end

	return false
end

NodeBuilderViewBase._can_remove_point_in_node = function (self, node)
	local _, spent_in_parents_counter = self:_has_points_spent_in_parents(node)
	local points_spent_in_children, children_spent_counter, children_spent_link_counter = self:_has_points_spent_in_children(node)
	local can_remove = true

	if points_spent_in_children then
		if children_spent_counter == 1 and children_spent_link_counter == 1 and spent_in_parents_counter == 1 then
			can_remove = true
		else
			local children = node.children

			can_remove = true

			for _, child_name in ipairs(children) do
				local child_node = self:_node_by_name(child_name)
				local points_spent_in_child = self._points_spent_on_node_widgets[child_name] or 0

				if points_spent_in_child > 0 and self:_is_node_dependent_on_parent(child_node, node) then
					can_remove = false

					break
				end
			end
		end
	end

	return can_remove
end

local temp_ignore_list = {}

NodeBuilderViewBase._can_node_traverse_to_start = function (self, node, ignore_list, step_count)
	step_count = (step_count or 0) + 1

	if not ignore_list then
		ignore_list = temp_ignore_list

		table.clear(ignore_list)
	end

	ignore_list[node.widget_name] = true

	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local parents = node.parents

	for i = 1, #parents do
		local parent_name = parents[i]

		if not ignore_list[parent_name] then
			local parent_node = self:_node_by_name(parent_name)

			if parent_node then
				if parent_node.type == "start" then
					return true, step_count
				elseif (points_spent_on_node_widgets[parent_name] or 0) > 0 then
					local could_traverse_parent, parent_step_count = self:_can_node_traverse_to_start(parent_node, ignore_list, step_count)

					if could_traverse_parent then
						return true, parent_step_count
					end
				end
			end
		end
	end

	return false, 0
end

NodeBuilderViewBase._is_node_dependent_on_parent = function (self, node, parent_node)
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local points_spent = points_spent_on_node_widgets[node.widget_name] or 0

	if points_spent == 0 then
		return false
	end

	local _, spent_in_parents_counter = self:_has_points_spent_in_parents(node)

	if spent_in_parents_counter > 1 then
		local ignore_list = {
			[parent_node.widget_name] = true,
		}
		local can_node_traverse_to_start = self:_can_node_traverse_to_start(node, ignore_list)

		if can_node_traverse_to_start then
			return false
		end
	elseif spent_in_parents_counter == 1 then
		return true
	end

	return true
end

NodeBuilderViewBase._on_node_widget_right_pressed = function (self, widget)
	local success = false
	local already_spent_node_points, _ = self:_node_points_by_widget(widget)

	if already_spent_node_points > 0 then
		local content = widget.content
		local node_data = content.node_data
		local status = self:_node_availability_status(node_data, true)
		local can_remove = self:_can_remove_point_in_node(node_data)

		if status ~= NODE_STATUS.locked and can_remove then
			self:_remove_node_point_on_widget(widget)

			success = true
		end
	end

	return success
end

NodeBuilderViewBase._get_scenegraph_definition = function (self, name)
	local scenegraph_definition = self._definitions.scenegraph_definition

	return scenegraph_definition[name]
end

NodeBuilderViewBase.apply_active_background_size = function (self)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local background_width, background_height = self:_background_size()

	self:_set_scenegraph_size(scenegraph_id, background_width, background_height)
	self:_force_update_scenegraph()
end

NodeBuilderViewBase._add_scenegraph_definition = function (self, name, definition)
	local scenegraph_definition = self._definitions.scenegraph_definition

	scenegraph_definition[name] = definition

	local scenegraph = UIScenegraph.init_scenegraph(scenegraph_definition, self._render_scale)

	self._ui_scenegraph = scenegraph

	self:apply_active_background_size()
	self:_force_update_scenegraph()
end

NodeBuilderViewBase._activate_layout_by_name = function (self, name)
	local active_layout

	for i = 1, #self._layouts do
		local layout = self._layouts[i]

		if layout.name == name then
			active_layout = layout

			break
		end
	end

	self._active_layout = active_layout

	self:_destroy_node_widgets()

	local nodes = active_layout.nodes
	local nodes_render_order_list = {}
	local lowest_node_height, highest_node_height = math.huge, 0

	for i = 1, #nodes do
		local node = nodes[i]

		self._node_widgets[#self._node_widgets + 1] = self:_create_node_widget(node)
		nodes_render_order_list[i] = node

		if lowest_node_height > node.y then
			lowest_node_height = node.y
		end

		if highest_node_height < node.y then
			highest_node_height = node.y
		end
	end

	self._nodes_render_order_list = nodes_render_order_list
	self._lowest_node_height = lowest_node_height
	self._highest_node_height = highest_node_height

	self:_refresh_all_nodes()
	self:apply_active_background_size()
end

NodeBuilderViewBase.recreate_widget_for_node = function (self, node)
	self:clear_node_points()

	local node_widgets = self._node_widgets
	local widget_index

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local widget_node_data = node_widget.content.node_data
		local widget_name = widget_node_data.widget_name

		if widget_name == node.widget_name then
			self:_destroy_node_widget(widget_name)

			widget_index = i

			break
		end
	end

	if widget_index then
		local widget = self:_create_node_widget(node)

		table.insert(node_widgets, widget_index, widget)
		self:_refresh_all_nodes()
	end
end

NodeBuilderViewBase._increase_render_priority_of_node = function (self, priority_node)
	local nodes = self._nodes_render_order_list
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local node_current_index = table.find(nodes, priority_node)

	table.remove(nodes, node_current_index)

	local wanted_move_index

	for i = 1, #nodes do
		local node = nodes[i]
		local points_spent = points_spent_on_node_widgets[node.widget_name] or 0

		if points_spent == 0 then
			wanted_move_index = i

			break
		end
	end

	if wanted_move_index then
		table.insert(nodes, wanted_move_index, priority_node)
	else
		table.insert(nodes, node_current_index, priority_node)
	end

	local node_widgets = self._node_widgets

	if node_widgets then
		for i = 1, #node_widgets do
			local node_widget = node_widgets[i]

			if node_widget.content.frame_connection_draw_list then
				table.clear(node_widget.content.frame_connection_draw_list)
			end
		end
	end
end

NodeBuilderViewBase._add_node = function (self, x, y)
	local active_layout = self:get_active_layout()

	active_layout.dirty = true

	local nodes = active_layout.nodes
	local node = {
		max_points = 1,
		type = "default",
		widget_name = "node_" .. math.uuid(),
		x = x or 0,
		y = y or 0,
		parents = {},
		children = {},
		requirements = {
			all_parents_chosen = false,
			children_unlock_points = 1,
			min_points_spent = 0,
		},
	}

	nodes[#nodes + 1] = node
	self._nodes_render_order_list[#self._nodes_render_order_list + 1] = self._nodes_render_order_list
	self._node_widgets[#self._node_widgets + 1] = self:_create_node_widget(node)

	self:_refresh_all_nodes()

	for _, settings in pairs(self._saved_scenegraph_settings) do
		self:_refresh_coordinates(settings, settings.is_node)
	end
end

NodeBuilderViewBase._refresh_all_nodes = function (self)
	local active_layout = self:get_active_layout()
	local nodes = active_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]

		self:_refresh_coordinates(node, true)

		local incompatible_talent = node.requirements.incompatible_talent

		if incompatible_talent and incompatible_talent ~= "" then
			self._incompatible_talents[incompatible_talent] = true
		end
	end

	table.sort(self._nodes_render_order_list, function (a, b)
		local points_spent_on_node_widgets = self._points_spent_on_node_widgets
		local a_points_spent = points_spent_on_node_widgets[a.widget_name] or 0
		local b_points_spent = points_spent_on_node_widgets[b.widget_name] or 0

		if a_points_spent > 0 and b_points_spent > 0 then
			local _, a_step_count = self:_can_node_traverse_to_start(a)
			local _, b_step_count = self:_can_node_traverse_to_start(b)

			return a_step_count < b_step_count
		else
			return b_points_spent < a_points_spent
		end
	end)
end

NodeBuilderViewBase._remove_node = function (self, widget_name)
	local active_layout = self:get_active_layout()

	active_layout.dirty = true

	local nodes = active_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]

		if node.widget_name == widget_name then
			self:_destroy_node_widget(widget_name)
			table.remove(nodes, i)

			break
		end
	end

	local nodes_render_order_list = self._nodes_render_order_list

	for i = 1, #nodes_render_order_list do
		local node = nodes_render_order_list[i]

		if node.widget_name == widget_name then
			table.remove(nodes_render_order_list, i)

			break
		end
	end
end

NodeBuilderViewBase.get_active_layout = function (self)
	return self._active_layout
end

NodeBuilderViewBase.get_active_layout_index = function (self)
	for i = 1, #self._layouts do
		local layout = self._layouts[i]

		if layout.name == self._active_layout.name then
			return i
		end
	end
end

NodeBuilderViewBase.selected_node_widget = function (self)
	local selected_node_index = self._selected_node_index

	if selected_node_index then
		return self._node_widgets[selected_node_index]
	end

	return nil
end

NodeBuilderViewBase.node_widgets = function (self)
	return self._node_widgets
end

NodeBuilderViewBase._set_active_layout_by_index = function (self, index)
	local layout = self._layouts[index]
	local layout_name = layout.name

	self:_activate_layout_by_name(layout_name)
end

NodeBuilderViewBase.post_update = function (self, dt, t, input_service)
	return NodeBuilderViewBase.super.post_update(self, dt, t, input_service)
end

NodeBuilderViewBase.can_exit = function (self)
	return self._can_close
end

NodeBuilderViewBase.update = function (self, dt, t, input_service)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	local player_mode = self._player_mode

	self._can_close = not player_mode and not active_layout.dirty

	local render_scale = Managers.ui:view_render_scale()

	self._render_scale = render_scale * self._current_zoom

	self:_update_node_widgets()
	self:_update_button_statuses(dt, t)

	return NodeBuilderViewBase.super.update(self, dt, t, input_service)
end

NodeBuilderViewBase._node_widget_hovered = function (self, dt, t)
	local widgets = self._node_widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot

		if hotspot and hotspot.is_hover then
			return widget, i
		end
	end
end

NodeBuilderViewBase.on_resolution_modified = function (self, scale)
	self:_force_update_scenegraph()
end

NodeBuilderViewBase._update_button_statuses = function (self, dt, t)
	local widgets_by_name = self._widgets_by_name
end

NodeBuilderViewBase._update_node_widgets = function (self)
	local widgets = self._node_widgets
	local can_draw_tooltip = false
	local hovered_widget
	local allowed_node_input = self:_allowed_node_input()

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot
		local already_spent_node_points, max_points = self:_node_points_by_widget(widget)

		content.has_points_spent = already_spent_node_points > 0

		self:_set_node_points_spent_text(widget, already_spent_node_points, max_points)

		local node_data = content.node_data

		if hotspot then
			hotspot.is_selected = self._selected_node_index == i
			hotspot.disabled = not allowed_node_input

			if hotspot.on_hover_enter then
				self:_setup_tooltip_info(node_data)
				self:_node_on_hovered(node_data)
			end

			if hotspot.is_hover then
				local node_type = node_data.type

				if not node_type or node_type ~= "start" then
					can_draw_tooltip = true
				end

				hovered_widget = hovered_widget or widget
			end
		end

		local status = self:_node_availability_status(node_data)

		content.locked = status == NODE_STATUS.locked
	end

	self._hovered_node_widget = hovered_widget
	self._can_draw_tooltip = can_draw_tooltip and not self._dragging_background
end

NodeBuilderViewBase._set_node_points_spent_text = function (self, widget, points_spent, max_points)
	local content = widget.content

	content.text = tostring(points_spent) .. "/" .. tostring(max_points)
end

NodeBuilderViewBase._node_on_hovered = function (self, node)
	return
end

NodeBuilderViewBase._setup_tooltip_info = function (self, node, instant_tooltip)
	return
end

NodeBuilderViewBase._on_node_hover_enter = function (self, node)
	return
end

local temp_node_table = {}

NodeBuilderViewBase._nodes_in_exclusive_group = function (self, group_name)
	table.clear(temp_node_table)

	local layout = self:get_active_layout()
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local requirements = node.requirements

		if requirements then
			local exclusive_group = requirements.exclusive_group

			if exclusive_group and exclusive_group == group_name then
				temp_node_table[#temp_node_table + 1] = node
			end
		end
	end

	return temp_node_table
end

local temp_incompatible_node_table = {}

NodeBuilderViewBase._node_with_incompatible_talent_is_selected = function (self, incompatible_talent)
	local layout = self:get_active_layout()
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local node_talent = node.talent

		if node_talent == incompatible_talent then
			local node_widget_name = node.widget_name
			local points_spent = points_spent_on_node_widgets[node_widget_name] or 0

			if points_spent > 0 then
				return true
			end
		end
	end

	return false
end

NodeBuilderViewBase._node_incompatible_with_talent_is_selected = function (self, incompatible_talent)
	local layout = self:get_active_layout()
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local node_incompatible_talent = node.requirements.incompatible_talent

		if node_incompatible_talent and node_incompatible_talent == incompatible_talent then
			local node_widget_name = node.widget_name
			local points_spent = points_spent_on_node_widgets[node_widget_name] or 0

			if points_spent > 0 then
				return true
			end
		end
	end

	return false
end

NodeBuilderViewBase._node_by_name = function (self, name)
	local layout = self:get_active_layout()
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local widget_name = node.widget_name

		if widget_name == name then
			return node
		end
	end
end

NodeBuilderViewBase._points_spent_in_group = function (self, group_name)
	local points_spent = 0
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local layout = self:get_active_layout()
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]

		if node.group_name == group_name then
			local node_widget_name = node.widget_name

			points_spent = points_spent + (points_spent_on_node_widgets[node_widget_name] or 0)
		end
	end

	return points_spent
end

NodeBuilderViewBase._points_spent_on_node_in_exclusive_group = function (self, group_name)
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local layout = self:get_active_layout()
	local nodes = layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]

		if node.requirements.exclusive_group == group_name then
			local node_widget_name = node.widget_name
			local points_spent = points_spent_on_node_widgets[node_widget_name] or 0

			if points_spent > 0 then
				return node.widget_name, points_spent
			end
		end
	end
end

NodeBuilderViewBase._node_availability_status = function (self, node, can_always_afford)
	local widget_name = node.widget_name
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local points_spent_in_node = points_spent_on_node_widgets[widget_name] or 0
	local points_available = self:_points_available()
	local can_afford = can_always_afford or points_available > 0
	local max_points = node.max_points or 0

	if max_points <= points_spent_in_node then
		return NODE_STATUS.capped
	end

	local is_incompatible_with_other_nodes = self._incompatible_talents[node.talent]

	if is_incompatible_with_other_nodes then
		local incompatible_node_is_selected = self:_node_incompatible_with_talent_is_selected(node.talent)

		if incompatible_node_is_selected then
			return NODE_STATUS.locked
		end
	end

	local requirements = node.requirements

	if requirements then
		local min_points_spent = requirements.min_points_spent

		if min_points_spent then
			local min_points_spent_in_group = requirements.min_points_spent_in_group

			if min_points_spent_in_group and min_points_spent_in_group ~= "" then
				local points_spent_in_group = self:_points_spent_in_group(min_points_spent_in_group)

				if points_spent_in_group < min_points_spent then
					return NODE_STATUS.locked
				end
			else
				local node_points_spent = self._node_points_spent

				if min_points_spent > node_points_spent - points_spent_in_node then
					return NODE_STATUS.locked
				end
			end
		end

		local exclusive_group = requirements.exclusive_group

		if exclusive_group and exclusive_group ~= "" then
			local exlusive_nodes = self:_nodes_in_exclusive_group(exclusive_group)

			for i = 1, #exlusive_nodes do
				local exlusive_node = exlusive_nodes[i]
				local exlusive_node_name = exlusive_node.widget_name

				if exlusive_node_name ~= widget_name then
					local exlusive_node_points_spent = points_spent_on_node_widgets[exlusive_node_name] or 0

					if exlusive_node_points_spent > 0 then
						return NODE_STATUS.locked
					end
				end
			end
		end

		local incompatible_talent = requirements.incompatible_talent

		if incompatible_talent and incompatible_talent ~= "" then
			local incompatible_node_is_selected = self:_node_with_incompatible_talent_is_selected(incompatible_talent)

			if incompatible_node_is_selected then
				return NODE_STATUS.locked
			end
		end

		local parents = node.parents
		local num_parents = #parents

		if num_parents > 0 then
			local all_parents_chosen = requirements.all_parents_chosen
			local return_result
			local points_spent_on_all_parents = true

			for i = 1, num_parents do
				local parent_name = parents[i]
				local parent_node = self:_node_by_name(parent_name)

				if parent_node then
					local parent_requirement = parent_node.requirements
					local children_unlock_points = parent_requirement.children_unlock_points or 0
					local parent_points_spent = points_spent_on_node_widgets[parent_name] or 0

					if all_parents_chosen and parent_points_spent < children_unlock_points then
						points_spent_on_all_parents = false
					end

					if (children_unlock_points <= parent_points_spent or parent_node.type == "start") and can_afford then
						return_result = NODE_STATUS.available
					end
				end
			end

			if return_result and (not all_parents_chosen or points_spent_on_all_parents) then
				return return_result
			end
		elseif can_afford then
			return NODE_STATUS.available
		end
	end

	return NODE_STATUS.locked
end

NodeBuilderViewBase._node_points_by_widget = function (self, widget)
	local name = widget.name
	local content = widget.content
	local node = content.node_data
	local max_points = node.max_points or 0

	return self._points_spent_on_node_widgets[name] or 0, max_points
end

NodeBuilderViewBase.clear_node_points = function (self)
	table.clear(self._points_spent_on_node_widgets)

	self._node_points_spent = 0
end

NodeBuilderViewBase._max_node_points = function (self)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return 0
	end

	return active_layout.node_points or 0
end

NodeBuilderViewBase._points_available = function (self)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return 0
	end

	local max_node_points = self:_max_node_points()
	local node_points_spent = self._node_points_spent or 0
	local points_available = max_node_points - node_points_spent

	return points_available
end

NodeBuilderViewBase._add_node_point_on_widget = function (self, widget)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	local max_node_points = self:_max_node_points()

	if max_node_points <= self._node_points_spent then
		return
	end

	self._node_points_spent = self._node_points_spent + 1

	local name = widget.name

	self._points_spent_on_node_widgets[name] = (self._points_spent_on_node_widgets[name] or 0) + 1

	local node = widget.content.node_data
	local instant_tooltip = true

	self:_setup_tooltip_info(node, instant_tooltip)
	self:_increase_render_priority_of_node(node)

	return true
end

NodeBuilderViewBase.active_layout_node_by_name = function (self, name)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	local nodes = active_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local widget_name = node.widget_name

		if widget_name == name then
			return node
		end
	end
end

NodeBuilderViewBase._remove_link_between_nodes = function (self, selected_node, pressed_node)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return false
	end

	local success = false

	if pressed_node.parents then
		for index, name in pairs(pressed_node.parents) do
			if name == selected_node.widget_name then
				table.remove(pressed_node.parents, index)

				success = true

				break
			end
		end
	end

	if selected_node.children then
		for index, name in pairs(selected_node.children) do
			if name == pressed_node.widget_name then
				table.remove(selected_node.children, index)

				success = true

				break
			end
		end
	end

	if success then
		active_layout.dirty = true
	end

	return success
end

NodeBuilderViewBase._assign_link_between_nodes = function (self, selected_node, pressed_node)
	if not pressed_node.parents then
		pressed_node.parents = {}
	end

	if not selected_node.children then
		selected_node.children = {}
	end

	pressed_node.parents[#pressed_node.parents + 1] = selected_node.widget_name
	selected_node.children[#selected_node.children + 1] = pressed_node.widget_name

	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	active_layout.dirty = true
end

NodeBuilderViewBase._remove_node_point_on_widget = function (self, widget)
	self._node_points_spent = math.max(self._node_points_spent - 1, 0)

	local name = widget.name

	self._points_spent_on_node_widgets[name] = math.max((self._points_spent_on_node_widgets[name] or 0) - 1, 0)

	if self._points_spent_on_node_widgets[name] == 0 then
		widget.content.highlighted = false
	end

	local instant_tooltip = true

	self:_setup_tooltip_info(widget.content.node_data, instant_tooltip)
end

NodeBuilderViewBase._set_zoom = function (self, zoom)
	self._current_zoom = math.clamp(zoom, 0.25, 1)

	self:_force_update_scenegraph()

	return self._current_zoom
end

NodeBuilderViewBase.render_scale = function (self)
	return
end

NodeBuilderViewBase._force_update_scenegraph = function (self, ui_scenegraph)
	NodeBuilderViewBase.super._force_update_scenegraph(self, ui_scenegraph)
	UIScenegraph.update_scenegraph(self._ui_overlay_scenegraph, RESOLUTION_LOOKUP.scale)
end

NodeBuilderViewBase._background_position = function (self)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local width, height = self:_scenegraph_position(scenegraph_id)

	return width, height
end

NodeBuilderViewBase._background_size = function (self)
	local active_layout = self:get_active_layout()

	if active_layout then
		local background_height = active_layout.background_height

		return 1920, background_height or 0
	end

	local size_multiplier = 4

	return 1920 * size_multiplier, 1024 * size_multiplier
end

NodeBuilderViewBase._get_text_height = function (self, text, text_style, optional_text_size)
	local ui_renderer = self._ui_renderer
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, optional_text_size or text_style.size, text_options)

	return text_height
end

NodeBuilderViewBase._allowed_node_input = function (self)
	local hovering_input_surface = self._widgets_by_name.input_surface.content.hotspot.is_hover

	return hovering_input_surface or not self._using_cursor_navigation
end

NodeBuilderViewBase._can_drag_background = function (self)
	return not self._hovered_node_widget
end

local _temp_cursor_drag_start_position = {}

NodeBuilderViewBase._handle_input = function (self, input_service, dt, t)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	self._input_handled_current_frame = nil

	local render_settings = self._render_settings
	local widgets_by_name = self._widgets_by_name
	local select_text_input_hold = input_service:get("select_text")
	local left_input_pressed = input_service:get("left_pressed")
	local left_input_hold = input_service:get("left_hold")
	local allowed_node_input = self:_allowed_node_input()
	local input_handled = false
	local dragging_background = false
	local is_background_drag_allowed = self:_can_drag_background()

	if is_background_drag_allowed and allowed_node_input then
		local layout_background_widget = widgets_by_name.layout_background
		local move_input_prefix = "left"
		local handled = self:_handle_scenegraph_coordinates(layout_background_widget.name, layout_background_widget.scenegraph_id, input_service, move_input_prefix, render_settings, true)

		if handled then
			if self._background_drag_frame_delay then
				input_handled = true
				dragging_background = true
			else
				self._background_drag_frame_delay = true
			end
		else
			self._background_drag_frame_delay = false
		end
	end

	self._dragging_background = dragging_background

	if allowed_node_input then
		local scroll
		local scroll_axis = input_service:get("scroll_axis")

		scroll = scroll_axis and scroll_axis[2] or 0
		scroll = math.abs(scroll)

		if math.abs(scroll) > 0.1 then
			local previous_direction_multiplier = self._scroll_direction_multiplier

			self._scroll_direction_multiplier = scroll_axis[2] > 0 and 1 or -1

			if previous_direction_multiplier and previous_direction_multiplier ~= self._scroll_direction_multiplier then
				self._scroll_add = nil
			end

			self._scroll_add = (self._scroll_add or 0) + scroll * 2

			local cursor_name = "cursor"
			local cursor_position = input_service:get(cursor_name)

			self._scroll_position = Vector3.to_array(cursor_position)
		end

		if self._scroll_add then
			local scroll_direction_multiplier = self._scroll_direction_multiplier or 1
			local scroll_add = self._scroll_add
			local speed = 20
			local step = math.max(scroll_add * (dt * speed), 0.001)

			if scroll_add > scroll / 500 then
				self._scroll_add = math.max(self._scroll_add - step, 0)
			else
				self._scroll_add = nil
			end

			self:_on_input_scroll_axis_changed(step * scroll_direction_multiplier, self._scroll_position)
		end
	end

	self:_update_scenegraph_positions()

	self._input_handled_current_frame = input_handled
end

NodeBuilderViewBase._on_input_scroll_axis_changed = function (self, scroll_value, cursor_position)
	local current_zoom = self._current_zoom
	local zoom = current_zoom + scroll_value * 0.05

	zoom = self:_set_zoom(zoom)

	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local scenegraph_position_x, scenegraph_position_y, _ = self:_scenegraph_position(scenegraph_id)
	local scenegraph_settings = self:_get_or_create_scenegraph_settings(scenegraph_id, scenegraph_position_x, scenegraph_position_y, false)
	local render_scale = Managers.ui:view_render_scale() * zoom
	local x, y = scenegraph_settings.x, scenegraph_settings.y
	local cursor_x, cursor_y = cursor_position[1] / render_scale, cursor_position[2] / render_scale
	local zoom_ratio = zoom / current_zoom
	local new_cursor_x, new_cursor_y = cursor_x * zoom_ratio, cursor_y * zoom_ratio
	local diff_x, diff_y = new_cursor_x - cursor_x, new_cursor_y - cursor_y

	scenegraph_settings.x = x - diff_x
	scenegraph_settings.y = y - diff_y
end

NodeBuilderViewBase._get_location_pixel_size_by_layout_size = function (self, layout_size, location_fraction_x, location_fraction_y)
	return layout_size[1] * location_fraction_x, layout_size[2] * location_fraction_y
end

NodeBuilderViewBase._refresh_coordinates = function (self, scenegraph_settings, is_node)
	local global_node_offset = self._global_node_offset
	local x = scenegraph_settings.x + (is_node and global_node_offset[1] or 0)
	local y = scenegraph_settings.y + (is_node and global_node_offset[2] or 0)
	local horizontal_alignment = scenegraph_settings.horizontal_alignment
	local vertical_alignment = scenegraph_settings.vertical_alignment
	local scenegraph_id = scenegraph_settings.scenegraph_id or scenegraph_settings.widget_name

	self:_set_scenegraph_position(scenegraph_id, x, y, nil, horizontal_alignment, vertical_alignment)
end

NodeBuilderViewBase.safe_rect = function (self)
	local safe_rect_default_value = 0

	return safe_rect_default_value * 0.01
end

NodeBuilderViewBase._get_or_create_scenegraph_settings = function (self, scenegraph_id, position_x, position_y, is_node)
	local scenegraph_settings = self._saved_scenegraph_settings[scenegraph_id]

	if not scenegraph_settings then
		scenegraph_settings = {
			x = position_x,
			y = position_y,
			is_node = is_node,
			scenegraph_id = scenegraph_id,
		}
		self._saved_scenegraph_settings[scenegraph_id] = scenegraph_settings
	end

	return scenegraph_settings
end

local _temp_widget_size = {}

NodeBuilderViewBase._handle_scenegraph_coordinates = function (self, widget_name, scenegraph_id, input_service, move_input_prefix, render_settings, is_background, optional_scenegraph_settings, cursor_start_position, cursor_pixel_threshold)
	if self._dragging_scenegraph_widget_name and self._dragging_scenegraph_widget_name ~= widget_name then
		return
	end

	local saved_scenegraph_settings = self._saved_scenegraph_settings
	local render_scale = self._render_scale
	local render_inverse_scale = 1 / self._render_scale
	local safe_rect = self:safe_rect()
	local screen_width = RESOLUTION_LOOKUP.width
	local screen_height = RESOLUTION_LOOKUP.height
	local input_key_pressed = move_input_prefix and move_input_prefix .. "_pressed" or "left_pressed"
	local input_key_hold = move_input_prefix and move_input_prefix .. "_hold" or "left_hold"
	local cursor_name = "cursor"
	local left_pressed = input_service:get(input_key_pressed)
	local cursor_position = input_service:get(cursor_name)
	local scenegraph_width, scenegraph_height = self:_scenegraph_size(scenegraph_id)

	_temp_widget_size[1] = scenegraph_width * render_scale
	_temp_widget_size[2] = scenegraph_height * render_scale

	local handled = false

	if left_pressed then
		local world_position = self:_scenegraph_world_position(scenegraph_id, render_scale)

		if math.point_is_inside_2d_box(cursor_position, world_position, _temp_widget_size) or widget_name == "layout_background" and not self._player_mode then
			self._dragging_scenegraph_id = scenegraph_id
			self._dragging_scenegraph_widget_name = widget_name
			self._cursor_last_coordinates = Vector3.to_array(cursor_position)
			self._cursor_box_offset = {
				cursor_position[1] - world_position[1] - _temp_widget_size[1] * 0.5,
				cursor_position[2] - world_position[2] - _temp_widget_size[2] * 0.75,
			}
		end
	end

	local scenegraph_settings = optional_scenegraph_settings or saved_scenegraph_settings[scenegraph_id]

	if self._dragging_scenegraph_id then
		local cursor_box_offset = self._cursor_box_offset
		local cursor_box_offset_x = cursor_box_offset[1]
		local cursor_box_offset_y = cursor_box_offset[2]

		if not scenegraph_settings then
			local scenegraph_position_x, scenegraph_position_y, _ = self:_scenegraph_position(scenegraph_id)

			scenegraph_settings = self:_get_or_create_scenegraph_settings(scenegraph_id, scenegraph_position_x, scenegraph_position_y, not is_background)
		end

		local left_hold = input_service:get(input_key_hold)

		if left_hold then
			local safe_rect_width = screen_width * safe_rect * 0.5
			local safe_rect_height = screen_height * safe_rect * 0.5
			local cursor_current_coordinates = Vector3.to_array(cursor_position)

			if not is_background then
				cursor_current_coordinates[1] = math.clamp(cursor_current_coordinates[1], safe_rect_width + cursor_box_offset_x, screen_width - safe_rect_width - (_temp_widget_size[1] - cursor_box_offset_x))
				cursor_current_coordinates[2] = math.clamp(cursor_current_coordinates[2], safe_rect_height + cursor_box_offset_y, screen_height - safe_rect_height - (_temp_widget_size[2] - cursor_box_offset_y))
			end

			self._cursor_current_coordinates = cursor_current_coordinates
		else
			self._dragging_scenegraph_id = nil
			self._dragging_scenegraph_widget_name = nil
		end

		local final_x, final_y = scenegraph_settings.x, scenegraph_settings.y
		local cursor_current_coordinates = self._cursor_current_coordinates

		if cursor_current_coordinates then
			local cursor_last_coordinates = self._cursor_last_coordinates
			local diff_x = (cursor_current_coordinates[1] - cursor_last_coordinates[1]) * render_inverse_scale
			local diff_y = (cursor_current_coordinates[2] - cursor_last_coordinates[2]) * render_inverse_scale

			final_x = final_x + diff_x
			final_y = final_y + diff_y

			if is_background then
				local background_width, background_height = self:_background_size()
				local min_x = -background_width * 0.5
				local max_x = -background_width * 0.5 + screen_width * render_inverse_scale

				final_x = math.clamp(final_x, min_x, max_x)

				local max_scroll = math.abs(background_height - screen_height * render_inverse_scale)

				if not self._player_mode then
					max_scroll = max_scroll + screen_height * 0.5
				end

				final_y = math.clamp(final_y, -max_scroll, 0)
			end

			local pixel_distance_valid = true

			if cursor_pixel_threshold then
				local cursor_distance = math.distance_2d(cursor_start_position[1], cursor_start_position[2], cursor_position[1], cursor_position[2])

				if cursor_pixel_threshold > math.abs(cursor_distance) then
					pixel_distance_valid = false
				end
			end

			if pixel_distance_valid then
				if not self._dragging_scenegraph_id and not is_background then
					local grid_snapping_position = self._grid_snapping_position

					if grid_snapping_position then
						local background_x, background_y = self:_background_position()

						final_x = grid_snapping_position[1] - background_x
						final_y = grid_snapping_position[2] - background_y

						local grid_size = self._grid_size

						final_x = final_x + (grid_size - scenegraph_width) * 0.5
						final_y = final_y + (grid_size - scenegraph_height) * 0.5
					end
				end

				if not self._player_mode then
					scenegraph_settings.x = final_x
				end

				scenegraph_settings.y = final_y
				self._cursor_last_coordinates = self._cursor_current_coordinates
				handled = true
			end
		end
	end

	return handled
end

NodeBuilderViewBase._update_scenegraph_positions = function (self)
	for scenegraph_id, settings in pairs(self._saved_scenegraph_settings) do
		local render_cache = self:_render_cache(settings)

		if settings.x ~= render_cache.rendered_x or settings.y ~= render_cache.rendered_y then
			render_cache.rendered_x = settings.x
			render_cache.rendered_y = settings.y

			self:_refresh_coordinates(settings, settings.is_node)
		end
	end

	local active_layout = self:get_active_layout()

	if active_layout then
		for i = 1, #active_layout.nodes do
			local node = active_layout.nodes[i]
			local render_cache = self:_render_cache(node)

			if node.x ~= render_cache.rendered_x or node.y ~= render_cache.rendered_y then
				render_cache.rendered_x = node.x
				render_cache.rendered_y = node.y

				self:_refresh_coordinates(node, true)
			end
		end
	end
end

NodeBuilderViewBase._render_cache = function (self, node)
	local cache = self._render_cache_data[node] or {}

	self._render_cache_data[node] = cache

	return cache
end

NodeBuilderViewBase.draw = function (self, dt, t, input_service, layer)
	if self._input_handled_current_frame then
		input_service = input_service:null_service()
	end

	local render_settings = self._render_settings
	local render_scale = RESOLUTION_LOOKUP.scale
	local render_inverse_scale = 1 / render_scale

	render_settings.scale = render_scale
	render_settings.inverse_scale = render_inverse_scale

	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer

	UIRenderer.begin_pass(ui_renderer, self._ui_overlay_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
	self:draw_layout(dt, t, input_service, layer)
end

NodeBuilderViewBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	NodeBuilderViewBase.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

NodeBuilderViewBase.draw_layout = function (self, dt, t, input_service, layer)
	local hovering_input_surface = self._widgets_by_name.input_surface.content.hotspot.is_hover

	if not hovering_input_surface then
		input_service = input_service:null_service()
	end

	local render_settings = self._render_settings
	local start_layer = render_settings.start_layer
	local render_scale = self._render_scale
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local layout_widgets = self._layout_widgets

	if layout_widgets then
		local num_widgets = #layout_widgets

		for i = 1, num_widgets do
			local widget = layout_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local active_layout = self:get_active_layout()

	if active_layout then
		render_settings.start_layer = render_settings.start_layer + 10

		local inverse_scale = render_settings.inverse_scale or 1
		local screen_height = RESOLUTION_LOOKUP.height
		local node_widgets = self._node_widgets

		if node_widgets then
			local num_widgets = #node_widgets

			for i = 1, num_widgets do
				local widget = node_widgets[i]
				local scenegraph_id = widget.scenegraph_id
				local node_widget_world_position = self:_scenegraph_world_position(scenegraph_id)

				if node_widget_world_position[2] < screen_height * inverse_scale then
					UIWidget.draw(widget, ui_renderer)
				end
			end
		end

		render_settings.start_layer = start_layer

		self:_draw_layout_node_connections(dt, t, input_service, ui_renderer, render_settings, active_layout)
	end

	UIRenderer.end_pass(ui_renderer)
end

local line_colors = {
	locked = {
		255,
		50,
		50,
		50,
	},
	unlocked = {
		255,
		255,
		255,
		255,
	},
	chosen = {
		255,
		0,
		255,
		0,
	},
}

NodeBuilderViewBase._draw_layout_node_connections = function (self, dt, t, input_service, ui_renderer, render_settings, layout)
	local node_connection_widget = self._node_connection_widget
	local scenegraph_id = node_connection_widget.scenegraph_id
	local node_connection_widget_world_position = self:_scenegraph_world_position(scenegraph_id)
	local node_connection_widget_width, node_connection_widget_height = self:_scenegraph_size(scenegraph_id)
	local widgets_by_name = self._widgets_by_name
	local screen_height = RESOLUTION_LOOKUP.height
	local nodes = self._nodes_render_order_list

	for i = 1, #nodes do
		local node = nodes[i]
		local node_widget_name = node.widget_name
		local node_widget = widgets_by_name[node_widget_name]

		if node_widget then
			local node_widget_scenegraph_id = node_widget.scenegraph_id
			local node_widget_world_position = self:_scenegraph_world_position(node_widget_scenegraph_id)
			local node_widget_width, node_widget_height = self:_scenegraph_size(node_widget_scenegraph_id)
			local parent_frame_connection_draw_list = node_widget.content.frame_connection_draw_list

			if not parent_frame_connection_draw_list then
				parent_frame_connection_draw_list = {}
				node_widget.content.frame_connection_draw_list = parent_frame_connection_draw_list
			else
				table.clear(parent_frame_connection_draw_list)
			end

			local children = node.children

			for _, child_node_name in ipairs(children) do
				local child_widget = widgets_by_name[child_node_name]

				if child_widget then
					local child_frame_connection_draw_list = child_widget.content.frame_connection_draw_list

					if not child_frame_connection_draw_list or not child_frame_connection_draw_list[node_widget_name] then
						local child_widget_scenegraph_id = child_widget.scenegraph_id
						local child_widget_world_position = self:_scenegraph_world_position(child_widget_scenegraph_id)
						local child_widget_width, child_widget_height = self:_scenegraph_size(child_widget_scenegraph_id)
						local offset_x = node_widget_world_position[1] - node_connection_widget_world_position[1] - (node_connection_widget_width - node_widget_width) * 0.5
						local offset_y = node_widget_world_position[2] - node_connection_widget_world_position[2] - (node_connection_widget_height - node_widget_height) * 0.5

						node_connection_widget.offset[1] = offset_x
						node_connection_widget.offset[2] = offset_y

						local distance = math.distance_2d(child_widget_world_position[1] + child_widget_width * 0.5, child_widget_world_position[2] + child_widget_height * 0.5, node_widget_world_position[1] + node_widget_width * 0.5, node_widget_world_position[2] + node_widget_height * 0.5)
						local angle = math.angle(child_widget_world_position[1] + child_widget_width * 0.5, child_widget_world_position[2] + child_widget_height * 0.5, node_widget_world_position[1] + node_widget_width * 0.5, node_widget_world_position[2] + node_widget_height * 0.5)
						local inverse_scale = render_settings.inverse_scale or 1
						local visible = math.min(child_widget_world_position[2], node_widget_world_position[2]) < screen_height * inverse_scale
						local child_node = child_widget.content.node_data
						local drawn = self:_draw_connection_between_widgets(ui_renderer, visible, dt, node, child_node, offset_x, offset_y, distance, angle)

						parent_frame_connection_draw_list[child_node_name] = drawn
					end
				end
			end
		end
	end
end

NodeBuilderViewBase._draw_connection_between_widgets = function (self, ui_renderer, visible, dt, parent_node, child_node, offset_x, offset_y, distance, angle)
	local node_connection_widget = self._node_connection_widget

	if not node_connection_widget then
		return
	end

	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local is_parent_starting_node = parent_node.type == "start"
	local parent_node_name = parent_node.widget_name
	local parent_node_requirements = parent_node.requirements
	local children_unlock_points = parent_node_requirements and parent_node_requirements.children_unlock_points or 0
	local points_spent_on_parent = points_spent_on_node_widgets[parent_node_name] or 0
	local child_status = self:_node_availability_status(child_node) or NODE_STATUS.available
	local child_node_name = child_node.widget_name
	local child_points_spent = points_spent_on_node_widgets[child_node_name] or 0
	local color_status

	if is_parent_starting_node then
		if child_points_spent > 0 then
			color_status = "locked"
		elseif self._points_available > 0 then
			color_status = "locked"
		end
	else
		color_status = (child_status == NODE_STATUS.locked or child_status == NODE_STATUS.unavailable or not (children_unlock_points <= points_spent_on_parent)) and "locked" or child_points_spent > 0 and "chosen" or "unlocked"
	end

	self:_apply_node_connection_line_colors(color_status)

	local node_connection_style = node_connection_widget.style

	for pass_style_name, pass_style in pairs(node_connection_style) do
		pass_style.size[1] = distance
		pass_style.angle = math.pi - angle
	end

	local arrow_style = node_connection_style.arrow

	if arrow_style then
		arrow_style.offset[1] = distance * 0.5
		arrow_style.pivot[1] = arrow_style.default_pivot[1] - distance * 0.5
		arrow_style.angle = math.pi - angle
	end

	node_connection_widget.content.has_progressed = color_status == "chosen"
	node_connection_widget.content.can_progress = color_status == "unlocked"

	self:_apply_node_connection_anims(node_connection_widget, parent_node, dt)

	if visible then
		UIWidget.draw(node_connection_widget, ui_renderer)
	end

	return visible
end

NodeBuilderViewBase._apply_node_connection_anims = function (self, node_connection_widget, parent_node, dt)
	return
end

NodeBuilderViewBase._apply_node_connection_line_colors = function (self, color_status)
	local node_connection_widget = self._node_connection_widget

	if not node_connection_widget then
		return
	end

	local color

	if color_status == "locked" then
		color = line_colors.locked
	elseif color_status == "chosen" then
		color = line_colors.chosen
	elseif color_status == "unlocked" then
		color = line_colors.unlocked
	end

	local node_connection_style = node_connection_widget.style
	local line_color = node_connection_style.line.color

	Colors.color_copy(color, line_color)

	local arrow_style = node_connection_style.arrow

	if arrow_style then
		local arrow_color = arrow_style.color

		Colors.color_copy(color, arrow_color)
	end
end

return NodeBuilderViewBase
