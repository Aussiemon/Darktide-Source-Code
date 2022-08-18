local Definitions = require("scripts/ui/views/talents_view/talents_view_definitions")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewBlueprints = require("scripts/ui/views/talents_view/talents_view_blueprints")
local ViewElementUniformGrid = require("scripts/ui/view_elements/view_element_uniform_grid/view_element_uniform_grid")
local SPECIALIZATION_SELECTION_VIEW = "talents_career_choice_view"
local TalentsView = class("TalentsView", "BaseView")

TalentsView.init = function (self, settings, context)
	self._context = context
	self._parent = context.parent
	self._is_readonly = context and context.is_readonly

	if not context then
		self._preview_player = self:_player()
	else
		self._preview_player = (context.debug and Managers.player:local_player(1)) or context.player
	end

	TalentsView.super.init(self, Definitions, settings)

	self._pass_input = true
	self._allow_close_hotkey = false
end

TalentsView.on_enter = function (self)
	TalentsView.super.on_enter(self)

	self._selected_talents = {}
	self._data_service = Managers.data_service.talents
	local profile = self._preview_player:profile()
	local specialization_name = profile.specialization

	if specialization_name == "none" then
		self:_open_specialization_selection()
	else
		self:_setup_talent_presentation()
	end
end

TalentsView._setup_talent_presentation = function (self)
	local player = self._preview_player
	local profile = player:profile()
	self._selected_talents = table.create_copy(self._selected_talents, profile.talents)

	self:_setup_grid()
	self:_populate_data(profile)

	self._presenting_player_talents = true
end

TalentsView.on_exit = function (self)
	if self._specialization_selection_view_open then
		local ui_manager = Managers.ui

		if ui_manager:view_active(SPECIALIZATION_SELECTION_VIEW) and not ui_manager:is_view_closing(SPECIALIZATION_SELECTION_VIEW) then
			ui_manager:close_view(SPECIALIZATION_SELECTION_VIEW)
		end

		self._specialization_selection_view_open = nil
	end

	TalentsView.super.on_exit(self)
end

TalentsView._open_specialization_selection = function (self)
	local player = self._preview_player
	local context = {
		player = player
	}

	Managers.ui:open_view(SPECIALIZATION_SELECTION_VIEW, nil, nil, nil, nil, context)

	self._specialization_selection_view_open = true
end

TalentsView.update = function (self, dt, t, input_service)
	local player = self._preview_player
	local profile = player:profile()
	local specialization_name = profile.specialization

	if self._specialization_selection_view_open and specialization_name ~= "none" then
		local ui_manager = Managers.ui

		if ui_manager:view_active(SPECIALIZATION_SELECTION_VIEW) and not ui_manager:is_view_closing(SPECIALIZATION_SELECTION_VIEW) then
			ui_manager:close_view(SPECIALIZATION_SELECTION_VIEW)
		end

		self._specialization_selection_view_open = nil

		self:_setup_talent_presentation()
	end

	if self._presenting_player_talents then
		self:_update_focused_talent()
		self:_update_talent_details(dt)
	end

	return TalentsView.super.update(self, dt, t, input_service)
end

TalentsView.cb_widget_clicked = function (self, widget, group_index)
	local talent_group = self._talent_groups[group_index]

	if not talent_group.non_selectable_group then
		self:_select_widget_in_group(talent_group, widget)
		self:_update_profile_talents()
	end
end

TalentsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	if not self._presenting_player_talents then
		return
	end

	TalentsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

TalentsView._on_navigation_input_changed = function (self)
	TalentsView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if grid then
		if not self._using_cursor_navigation then
			if not grid:focused_grid_widget() then
				grid:focus_first_index(8, 4)
			end
		elseif grid:focused_grid_widget() then
			grid:set_focused_grid_widget(nil)
		end
	end
end

TalentsView._update_focused_talent = function (self)
	local talent_groups = self._talent_groups
	local using_gamepad = not self._using_cursor_navigation
	local focus_ring_widget = self._widgets_by_name.highlight_ring
	focus_ring_widget.visible = false
	local focused_talent_name = ""
	local focused_talent_description = ""

	for i = 1, #talent_groups, 1 do
		local talent_group = talent_groups[i]
		local group_widget = talent_group.group_widget
		local group_hotspot = group_widget and group_widget.content.hotspot
		local group_focused_last_frame = group_hotspot and group_hotspot.is_focused
		local talent_widgets = talent_group.talent_widgets
		local group_is_focused = group_hotspot and group_hotspot.is_hover

		for j = 1, #talent_widgets, 1 do
			local talent_widget = talent_widgets[j]
			local content = talent_widget.content
			content.focused = group_focused_last_frame
			local hotspot = content.hotspot
			local widget_is_focused = hotspot.is_focused or hotspot.is_hover

			if widget_is_focused then
				focused_talent_name = content.talent_display_name
				focused_talent_description = content.talent_description
				group_is_focused = true
				local x, y = self._grid:grid_cell_world_position(content.column, content.row, 1)
				focus_ring_widget.visible = content.has_focus_ring
				focus_ring_widget.offset[1] = x
				focus_ring_widget.offset[2] = y

				if not content.has_played_on_focus_sound then
					self:_play_sound(UISoundEvents.talents_node_hover)

					content.has_played_on_focus_sound = true
				end
			else
				content.has_played_on_focus_sound = nil
			end
		end

		if group_hotspot then
			group_hotspot.is_focused = group_is_focused
			group_hotspot.disabled = using_gamepad or nil

			if group_is_focused and not group_focused_last_frame then
				self:_play_sound(UISoundEvents.talents_talent_group_hover)
			end
		end

		self._focused_talent_name = focused_talent_name
		self._focused_talent_description = focused_talent_description
	end
end

TalentsView._update_talent_details = function (self, dt)
	local details_widget = self._widgets_by_name.details
	local content = details_widget.content
	local next_talent_name = self._focused_talent_name
	local next_talent_description = self._focused_talent_description
	local alpha_multiplier = details_widget.alpha_multiplier or 0
	local fade_time = content.fade_time

	if next_talent_name == content.talent_name then
		alpha_multiplier = math.min(alpha_multiplier + dt / fade_time, 1)
	elseif alpha_multiplier > 0 then
		alpha_multiplier = math.max(alpha_multiplier - dt / fade_time, 0)
	else
		content.talent_name = next_talent_name or ""
		content.talent_description = next_talent_description or ""
	end

	details_widget.alpha_multiplier = alpha_multiplier
end

TalentsView._select_widget_in_group = function (self, group, selected_widget)
	local talent_widgets = group.talent_widgets
	local selected_talents = self._selected_talents

	for i = 1, #talent_widgets, 1 do
		local widget = talent_widgets[i]
		local widget_content = widget.content
		local hotspot = widget_content.hotspot
		local talent_name = widget_content.talent_name
		local is_selected = widget == selected_widget
		hotspot.is_selected = is_selected
		selected_talents[talent_name] = is_selected or nil
	end
end

TalentsView._update_profile_talents = function (self)
	local player = self:_player()
	local selected_talents = self._selected_talents

	self._data_service:set_talents(player, selected_talents)
end

TalentsView._setup_grid = function (self)
	local reference_name = "grid"
	local layer = 10
	local grid = self:_add_element(ViewElementUniformGrid, reference_name, layer)
	local scenegraph_definition = self._definitions.scenegraph_definition
	local grid_area_definition = scenegraph_definition.grid_area
	local scale = self._render_scale or 1
	local grid_area_position = self:_scenegraph_world_position("grid_area", scale)
	local grid_area_size = grid_area_definition.size

	grid:set_grid_area_position(grid_area_position, "left", "top")
	grid:set_grid_area_size(grid_area_size)

	local num_columns = 15
	local num_rows = 8
	local horizontal_grid_spacing = 0
	local vertical_grid_spacing = 0

	grid:set_grid_size(num_columns, num_rows)
	grid:set_grid_spacing(horizontal_grid_spacing, vertical_grid_spacing)
	grid:set_is_hexagonal(true)
	grid:force_grid_recalculation()

	self._grid = grid
end

TalentsView._populate_data = function (self, profile)
	local player_level = profile.current_level
	local specialization_name = profile.specialization
	local archetype = profile.archetype
	local specialization = archetype.specializations[specialization_name]

	if not specialization then
		return
	end

	local talents = archetype.talents[specialization_name]
	self._talents = talents
	local selected_talents = self._selected_talents

	self:_populate_archetype_data(archetype, specialization)
	self:_populate_talents_data(archetype, talents, specialization, player_level, selected_talents)
end

TalentsView._populate_archetype_data = function (self, archetype, specialization)
	local class_header_widget = self._widgets_by_name.class_header
	local content = class_header_widget.content
	content.class_icon = archetype.archetype_icon_large
	local localized_archetype_name = self:_localize(archetype.archetype_title)

	if specialization.name == "none" then
		content.class_name = ""
		content.specialization_name = localized_archetype_name
	else
		content.class_name = self:_localize("loc_talents_class_specialization", true, {
			class_name = localized_archetype_name
		})
		content.specialization_name = self:_localize(specialization.title)
	end

	local background_widget = self._widgets_by_name.background
	content = background_widget.content
	content.specialization_background = specialization.background_large
	content.class_icon = archetype.archetype_background_large
end

TalentsView._populate_talents_data = function (self, archetype, talents, specialization, player_level, selected_talents)
	local talent_group_definitions = specialization.talent_groups
	local talent_groups = {}
	local group_index = 0

	for i = 1, #talent_group_definitions, 1 do
		local group_defintion = talent_group_definitions[i]
		local required_level = group_defintion.required_level or 0
		local is_locked = player_level < required_level
		local is_non_selectable = group_defintion.non_selectable_group
		local is_group_invisible = group_defintion.invisible_in_ui
		local group_talents = group_defintion.talents
		local group_widget = nil
		local group_boundary_widget_template_name = group_defintion.group_boundary_widget_template

		if group_boundary_widget_template_name then
			local grid_position = group_defintion.top_left_grid_position
			local blueprint = ViewBlueprints[group_boundary_widget_template_name]
			local group_widget_name = "group_" .. i

			local function init(widget)
				local content = widget.content
				local group_label = group_defintion.group_name
				content.talent_type = group_label and self:_localize(group_label)
				content.hotspot.disabled = is_non_selectable
				local style = widget.style

				if is_locked then
					local label_style = style.talent_type
					label_style.color_default = label_style.color_locked
					local outline_style = style.outline

					if outline_style then
						outline_style.color_focused = outline_style.color_locked
					end

					content.level = self:_localize("loc_talents_talent_level_locked", true, {
						required_level = required_level
					})
				else
					content.level = self:_localize("loc_talents_talent_level", true, {
						required_level = required_level
					})
				end

				if required_level == 0 then
					style.level.visible = false
				end
			end

			group_widget = self._grid:add_widget_to_grid(grid_position[1], grid_position[2], group_widget_name, blueprint, init)
		end

		if not is_group_invisible then
			group_index = group_index + 1
			local talent_widgets = {}

			for j = 1, #group_talents, 1 do
				local talent_name = group_talents[j]
				local talent = talents[talent_name]
				local callback_group_index = group_widget and group_index
				local is_selected_talent = selected_talents[talent_name] or false
				talent_widgets[j] = self:_create_talent_widget(talent_name, talent, group_defintion, callback_group_index, is_locked, is_selected_talent)
			end

			local new_talent_group = {
				definition = group_defintion,
				group_widget = group_widget,
				talent_widgets = talent_widgets,
				non_selectable_group = is_non_selectable
			}
			talent_groups[group_index] = new_talent_group
		end
	end

	self._talent_groups = talent_groups
end

local talent_icon_blueprint = ViewBlueprints.talent_icon
local locked_talent_icon_blueprint = ViewBlueprints.talent_icon_locked

TalentsView._create_talent_widget = function (self, name, talent, group_defintion, callback_group_index, is_locked, is_selected_talent)
	local talent_icon = talent.icon
	local blueprint = nil

	if talent_icon and is_locked then
		blueprint = locked_talent_icon_blueprint
	elseif talent_icon then
		blueprint = talent_icon_blueprint
	elseif talent.large_icon then
		blueprint = ViewBlueprints.talent_icon_large
	end

	local is_non_selectable = group_defintion.non_selectable_group
	local grid_position = talent.icon_position

	local function init(widget)
		local widget_content = widget.content
		widget_content.talent_icon = talent_icon or talent.large_icon
		widget_content.has_focus_ring = blueprint.has_focus_ring
		widget_content.talent_name = name
		widget_content.talent = talent
		widget_content.talent_display_name = self:_localize(talent.display_name)
		widget_content.talent_description = self:_localize(talent.description)

		if is_non_selectable then
			local hotspot = widget_content.hotspot
			hotspot.is_selected = not is_locked
		elseif callback_group_index and not is_locked then
			local hotspot = widget_content.hotspot
			hotspot.is_selected = is_selected_talent

			if not self._is_readonly then
				hotspot.pressed_callback = callback(self, "cb_widget_clicked", widget, callback_group_index)
			end
		end
	end

	local talent_widget = self._grid:add_widget_to_grid(grid_position[1], grid_position[2], name, blueprint, init)

	return talent_widget
end

return TalentsView
