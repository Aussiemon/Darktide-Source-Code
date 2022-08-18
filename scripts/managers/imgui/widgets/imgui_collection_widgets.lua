local InputWidgets = require("scripts/managers/imgui/widgets/imgui_input_widgets")
local WidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local ImguiCollectionWidgets = {
	list = {
		new = function (widgets, wrap_navigation, optional_column_width)
			return {
				type = "list",
				widgets = widgets,
				wrap_navigation = wrap_navigation,
				column_width = optional_column_width or {}
			}
		end,
		render = function (list)
			local widgets = list.widgets
			local wrap_navigation = list.wrap_navigation
			local column_width = list.column_width
			local focused_index, active_index = nil

			Imgui.columns(2, false)

			if column_width[1] then
				Imgui.set_column_width(column_width[1], 0)
			end

			if column_width[2] then
				Imgui.set_column_width(column_width[2], 1)
			end

			for i = 1, #widgets, 1 do
				local widget = widgets[i]
				local display_name = widget.display_name

				Imgui.text(display_name)
				Imgui.next_column()
				InputWidgets.render(widget)

				if widget.is_active then
					active_index = i
				end

				if widget.is_focused then
					focused_index = i
				end

				Imgui.next_column()
			end

			Imgui.columns(1)

			if wrap_navigation and focused_index and not active_index then
				local key_up = Imgui.is_key_pressed(Imgui.KEY_UP_ARROW)
				local key_down = Imgui.is_key_pressed(Imgui.KEY_DOWN_ARROW)

				if key_up or key_down then
					local new_widget = WidgetUtilities.wrap_array(widgets, focused_index, (key_up and -1) or 1)

					WidgetUtilities.focus_widget(new_widget.label)
				end
			end

			list.focused_index = focused_index
			list.active_index = active_index
		end,
		reset = function (list)
			list.focused_index = nil
			list.active_index = nil
		end
	},
	list_tree = {
		new = function (nodes, lists)
			return {
				type = "list_tree",
				nodes = nodes,
				lists = lists
			}
		end,
		render = function (list_tree, auto_expand_nodes)
			local nodes = list_tree.nodes
			local lists = list_tree.lists
			local opened_node_index, focused_node_index, focused_widget_index, focused_widget_node_index, active_widget_index = nil

			for i = 1, #nodes, 1 do
				local node = nodes[i]
				local list = lists[node]
				local node_was_open = WidgetUtilities.is_tree_node_open(node)
				local node_is_open = Imgui.collapsing_header(node, false)

				if not node_was_open and node_is_open then
					opened_node_index = i
				end

				if Imgui.is_item_focused() then
					focused_node_index = i

					if focused_node_index ~= list_tree.focused_node_index then
						WidgetUtilities.scroll_last_item_into_view()
					end
				end

				if node_is_open then
					Imgui.indent()
					ImguiCollectionWidgets.list.render(list)

					if list.focused_index then
						focused_widget_index = list.focused_index
						focused_widget_node_index = i
					end

					if list.active_index then
						active_widget_index = list.active_index
					end

					Imgui.unindent()
				end
			end

			if focused_node_index or focused_widget_index then
				local key_up = Imgui.is_key_pressed(Imgui.KEY_UP_ARROW)
				local key_down = Imgui.is_key_pressed(Imgui.KEY_DOWN_ARROW)
				local key_left = Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW)
				local key_right = Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW)

				if not key_up and not key_down and not key_left and not key_right and (Imgui.is_key_down(Imgui.KEY_UP_ARROW) or Imgui.is_key_down(Imgui.KEY_DOWN_ARROW) or Imgui.is_key_down(Imgui.KEY_LEFT_ARROW) or Imgui.is_key_down(Imgui.KEY_RIGHT_ARROW)) then
					Imgui.nav_move_request_cancel()
				end

				if focused_node_index then
					if not opened_node_index and key_right then
						local widget = lists[nodes[focused_node_index]].widgets[1]

						WidgetUtilities.focus_widget(widget.label)
					elseif key_up or key_down then
						if auto_expand_nodes then
							local focused_node = nodes[focused_node_index]

							WidgetUtilities.close_tree_node(focused_node)

							local step = (key_up and -1) or 1
							local new_node_index = math.min(focused_node_index + step, #nodes)

							if new_node_index > 0 then
								local new_node = nodes[new_node_index]

								if auto_expand_nodes then
									WidgetUtilities.open_tree_node(new_node)
								end

								WidgetUtilities.focus_widget(new_node)
							end
						end
					end
				elseif focused_widget_node_index and not active_widget_index and key_left then
					local node = nodes[focused_widget_node_index]

					WidgetUtilities.focus_widget(node)
				end
			end

			list_tree.focused_node_index = focused_node_index
			list_tree.focused_widget_index = focused_widget_index
			list_tree.active_widget_index = active_widget_index
		end,
		reset = function (list)
			list.focused_node_index = nil
			list.focused_widget_index = nil
			list.active_widget_index = nil
		end
	},
	render = function (widget, ...)
		ImguiCollectionWidgets[widget.type].render(widget, ...)
	end,
	reset = function (widget, ...)
		ImguiCollectionWidgets[widget.type].reset(widget, ...)
	end
}

return ImguiCollectionWidgets
