local Definitions = require("scripts/ui/views/talents_view/talents_view_definitions")
local ProfileUtils = require("scripts/utilities/profile_utils")
local TextUtilities = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewBlueprints = require("scripts/ui/views/talents_view/talents_view_blueprints")
local ViewElementUniformGrid = require("scripts/ui/view_elements/view_element_uniform_grid/view_element_uniform_grid")
local ViewSettings = require("scripts/ui/views/talents_view/talents_view_settings")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")
local ViewFadeTime = 0.5
local TalentsView = class("TalentsView", "BaseView")

TalentsView.init = function (self, settings, context)
	self._context = context
	self._parent = context.parent
	self._talent_icons_package_id = nil
	self._init_done = false
	self._view_alpha = 0
	self._focused_talent_widget = nil
	self._is_readonly = context and context.is_readonly

	if context then
		self._preview_player = context.debug and Managers.player:local_player(1) or context.player
	else
		self._preview_player = self:_player()
	end

	TalentsView.super.init(self, Definitions, settings)

	self._pass_input = true
	self._allow_close_hotkey = false
end

TalentsView.on_enter = function (self)
	TalentsView.super.on_enter(self)

	self._talents_modified = false
	self._talent_widgets = {}
	self._talent_groups = {}
	self._selected_talents = {}
	self._talent_service = Managers.data_service.talents
	self._render_settings.alpha_multiplier = self._view_alpha

	self:_setup_talent_presentation()

	local context = self._context
	local changeable_context = context and context.changeable_context
	local camera_settings = changeable_context and changeable_context.camera_settings

	if camera_settings then
		self:_move_camera(camera_settings)
	end

	local focus_ring_widget = self._widgets_by_name.highlight_ring
	focus_ring_widget.visible = false

	self:_register_event("event_on_profile_preset_changed", "event_on_profile_preset_changed")
end

TalentsView.on_exit = function (self)
	self:_update_profile_talents()

	self._talents_modified = false

	TalentsView.super.on_exit(self)

	if self._talent_service then
		self._talent_service:release_icons(self._talent_icons_package_id)
	end
end

TalentsView.profile_preset_handling_input = function (self)
	local view_name = "inventory_background_view"
	local ui_manager = Managers.ui

	if ui_manager:view_active(view_name) then
		local view_instance = ui_manager:view_instance(view_name)

		return view_instance:profile_preset_handling_input()
	end
end

TalentsView.update = function (self, dt, t, input_service)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	if self._view_alpha < 1 and self._init_done then
		self._view_alpha = math.min(self._view_alpha + dt / ViewFadeTime, 1)
		local render_settings = self._render_settings
		render_settings.alpha_multiplier = self._view_alpha
	end

	self:_update_focused_talent()
	self:_update_talent_details(dt)
	self:_update_equip_button(dt)

	return TalentsView.super.update(self, dt, t, input_service)
end

TalentsView.draw = function (self, dt, t, input_service, layer)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	if self._init_done then
		TalentsView.super.draw(self, dt, t, input_service, layer)
	end
end

TalentsView.on_resolution_modified = function (self, scale)
	TalentsView.super.on_resolution_modified(self, scale)

	local scenegraph_definition = self._definitions.scenegraph_definition
	local grid_area_definition = scenegraph_definition.grid_area
	local grid_area_position = self:_scenegraph_world_position("grid_area")
	local grid_area_size = grid_area_definition.size
	local grid = self._grid

	grid:set_grid_area_position(grid_area_position, "left", "top")
	grid:set_grid_area_size(grid_area_size)
	grid:force_grid_recalculation()
	self:_on_navigation_input_changed()
	self:_update_focused_talent(true)
end

TalentsView.cb_widget_clicked = function (self, widget, group_index, is_right_button)
	local talent_group = self._talent_groups[group_index]
	local content = widget.content
	local hotspot = content.hotspot
	local is_equipped = hotspot.is_selected and not content.is_new or false
	local using_gamepad = not self._using_cursor_navigation

	if (is_equipped == is_right_button or using_gamepad) and not talent_group.non_selectable_group then
		local widget_style = widget.style
		local sound = not is_equipped and widget_style.equip_sound or widget_style.unequip_sound

		self:_play_sound(sound)
		self:_select_widget_in_group(talent_group, widget)

		self._talents_modified = true
	end
end

TalentsView._on_navigation_input_changed = function (self)
	TalentsView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if grid and not grid:focused_grid_widget() then
		local start_cell = ViewSettings.grid_gamepad_start_cell

		grid:focus_first_index(start_cell[1], start_cell[2])
	end
end

TalentsView._setup_talent_presentation = function (self)
	local player = self._preview_player
	local profile = player:profile()
	local selected_talents = table.create_copy(self._selected_talents, profile.talents)
	self._selected_talents = selected_talents

	self:_setup_grid()

	local on_package_loaded = callback(self, "_populate_data", profile, selected_talents)
	self._talent_icons_package_id = self._talent_service:load_icons_for_profile(profile, "TalentsView", on_package_loaded, true)
end

TalentsView._update_focused_talent = function (self, force_update)
	local current_focused_widget = self._focused_talent_widget
	local focus_ring_widget = self._widgets_by_name.highlight_ring
	local talent_widgets = self._talent_widgets

	for i = 1, #talent_widgets do
		local talent_widget = talent_widgets[i]
		local content = talent_widget.content
		local hotspot = content.hotspot

		if talent_widget ~= current_focused_widget or force_update then
			local is_focused = hotspot.is_hover or hotspot.is_focused

			if is_focused then
				local x, y = self._grid:grid_cell_world_position(content.column, content.row, 1)
				local talent_widget_offset = talent_widget.offset
				hotspot.is_focused = true

				if current_focused_widget and not force_update then
					current_focused_widget.content.hotspot.is_focused = false
				end

				focus_ring_widget.visible = content.has_focus_ring
				focus_ring_widget.offset[1] = x + talent_widget_offset[1]
				focus_ring_widget.offset[2] = y + talent_widget_offset[2]
				local focus_ring_content = focus_ring_widget.content

				if not force_update then
					focus_ring_content.anim_focus_progress = 0

					self:_play_sound(UISoundEvents.talents_talent_hover)
				end

				current_focused_widget = talent_widget
				self._focused_talent_widget = current_focused_widget
			end
		else
			local focus_ring_content = focus_ring_widget.content
			focus_ring_content.anim_focus_progress = hotspot.anim_focus_progress or 0
		end
	end
end

TalentsView._move_camera = function (self, camera_settings)
	local event_manager = Managers.event

	for i = 1, #camera_settings do
		local settings = camera_settings[i]

		event_manager:trigger(settings[1], settings[2], settings[3], settings[4], settings[5])
	end
end

TalentsView._update_talent_details = function (self, dt)
	local talent_widget = self._focused_talent_widget
	local talent_widget_content = talent_widget and talent_widget.content
	local next_talent_name = talent_widget_content and talent_widget_content.talent_display_name
	local next_talent_description = talent_widget_content and talent_widget_content.talent_description
	local details_widget = self._widgets_by_name.details
	local details_widget_content = details_widget.content
	local alpha_multiplier = details_widget.alpha_multiplier or 0
	local fade_time = details_widget_content.fade_time

	if next_talent_name == details_widget_content.talent_name and details_widget.visible == false then
		details_widget.visible = true
		local next_talent = talent_widget_content and talent_widget_content.talent
		local next_talent_icon = next_talent.icon
		local large_talent_icon = next_talent.large_icon

		if next_talent_icon or large_talent_icon then
			local widget_style = details_widget.style
			local talent_name_style = widget_style.talent_name
			local _, talent_name_height, min = self:_text_size_for_style(next_talent_name, talent_name_style)
			talent_name_height = math.max(math.floor(talent_name_height + min[2]), talent_name_style.size[2])
			local icon_frame_style, icon_style = nil

			if next_talent_icon then
				icon_frame_style = widget_style.talent_icon_frame
				icon_style = widget_style.talent_icon
				icon_style.material_values.icon_texture = next_talent_icon
			else
				icon_frame_style = widget_style.large_icon_frame
				icon_style = widget_style.large_icon
				icon_style.material_values.texture_map = large_talent_icon
			end

			icon_frame_style.offset[2] = talent_name_style.offset[2] + talent_name_height + icon_frame_style.offset_to_text_above
			icon_frame_style.visible = true
			icon_style.offset[2] = talent_name_style.offset[2] + talent_name_height + icon_style.offset_to_text_above
			icon_style.visible = true
			local talent_description_style = widget_style.talent_description
			talent_description_style.offset[2] = icon_style.offset[2] + icon_style.size[2] + talent_description_style.offset_to_icon_above
		end
	elseif next_talent_name == details_widget_content.talent_name then
		alpha_multiplier = math.min(alpha_multiplier + dt / fade_time, 1)
	elseif alpha_multiplier > 0 then
		alpha_multiplier = math.max(alpha_multiplier - dt / fade_time, 0)
	else
		details_widget.visible = false
		details_widget_content.talent_name = next_talent_name or ""
		details_widget_content.talent_description = next_talent_description or ""
		local widget_style = details_widget.style
		widget_style.talent_icon_frame.visible = false
		widget_style.talent_icon.visible = false
		widget_style.large_icon_frame.visible = false
		widget_style.large_icon.visible = false
	end

	details_widget.alpha_multiplier = alpha_multiplier
end

TalentsView._update_equip_button = function (self, dt)
	local talent_widget = self._focused_talent_widget
	local talent_widget_content = talent_widget and talent_widget.content
	local talent_widget_hotspot = talent_widget_content and talent_widget_content.hotspot
	local equip_button = self._widgets_by_name.equip_button
	local equip_button_content = equip_button.content
	local is_selectable = talent_widget and talent_widget_content.is_selectable
	local is_equipped = talent_widget and talent_widget_hotspot.is_selected and not talent_widget_content.is_new
	local alpha_multiplier = equip_button.alpha_multiplier or 0
	local fade_time = equip_button_content.fade_time

	if is_selectable and not equip_button.visible then
		equip_button.visible = true
		local equip_button_hotspot = equip_button_content.hotspot

		if is_equipped then
			local equip_button_text = ViewSettings.equip_button_text_unequip
			local unequip_action = ViewSettings.equip_button_action_unequip
			equip_button_content.text = TextUtilities.localize_with_button_hint(unequip_action, equip_button_text)
			equip_button_hotspot.pressed_callback = talent_widget_hotspot.right_pressed_callback
		else
			local equip_button_text = ViewSettings.equip_button_text_equip
			local equip_action = ViewSettings.equip_button_action_equip
			equip_button_content.text = TextUtilities.localize_with_button_hint(equip_action, equip_button_text)
			equip_button_hotspot.pressed_callback = talent_widget_hotspot.pressed_callback
		end

		equip_button_content.is_equipped = is_equipped
	elseif is_selectable and is_equipped == equip_button_content.is_equipped then
		alpha_multiplier = math.min(alpha_multiplier + dt / fade_time, 1)
	elseif alpha_multiplier > 0 then
		alpha_multiplier = math.max(alpha_multiplier - dt / fade_time, 0)
	else
		equip_button.visible = false
	end

	equip_button.alpha_multiplier = alpha_multiplier
end

TalentsView._select_widget_in_group = function (self, group, selected_widget)
	local talent_widgets = group.talent_widgets
	local selected_talents = self._selected_talents
	local group_has_selected_talent = true

	for i = 1, #talent_widgets do
		local widget = talent_widgets[i]
		local widget_content = widget.content
		local hotspot = widget_content.hotspot
		local talent_name = widget_content.talent_name
		local is_selected = widget == selected_widget and (not hotspot.is_selected or widget_content.is_new)
		hotspot.is_selected = is_selected
		selected_talents[talent_name] = is_selected or nil
		widget_content.is_new = nil
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		if active_profile_preset_id then
			ProfileUtils.save_talent_id_for_profile_preset(active_profile_preset_id, talent_name, is_selected or nil)
		end

		group_has_selected_talent = group_has_selected_talent or is_selected
	end

	local group_widget = group.group_widget
	group_widget.content.is_new = nil
	group_widget.content.group_has_selected_talent = group_has_selected_talent
end

TalentsView._update_profile_talents = function (self)
	local player = self._preview_player
	local selected_talents = self._selected_talents

	if self._talents_modified then
		self._talent_service:set_talents(player, selected_talents)
	end
end

TalentsView._setup_grid = function (self)
	local reference_name = "grid"
	local layer = 10
	local grid = self:_add_element(ViewElementUniformGrid, reference_name, layer)
	local num_columns = ViewSettings.grid_num_columns
	local num_rows = ViewSettings.grid_num_rows

	grid:set_grid_size(num_columns, num_rows)

	self._grid = grid
	local scale = self._render_scale or 1
end

TalentsView.event_on_profile_preset_changed = function (self, profile_preset)
	local player = self._preview_player
	local profile = player:profile()
	local profile_preset_talents = profile_preset and profile_preset.talents
	local selected_talents = table.create_copy(table.clone(self._selected_talents), profile_preset_talents)
	self._selected_talents = selected_talents
	local talent_widgets = self._talent_widgets

	if talent_widgets then
		for i = 1, #talent_widgets do
			local widget = talent_widgets[i]
			local widget_name = widget.name
			local content = widget.content

			if content.is_selectable then
				local hotspot = content.hotspot
				local talent_value = selected_talents[widget_name]
				hotspot.is_selected = talent_value or false
			end
		end
	end
end

TalentsView._populate_data = function (self, profile, selected_talents)
	local character_id = profile.character_id
	local player_level = profile.current_level
	local specialization_name = profile.specialization
	local archetype = profile.archetype
	local specialization = archetype.specializations[specialization_name]

	if not specialization then
		return
	end

	local talents = archetype.talents[specialization_name]
	self._talents = talents

	self:_populate_archetype_data(archetype, specialization)
	self:_set_level_bar(player_level)
	self:_populate_talents_data(character_id, archetype, specialization, talents, selected_talents, player_level)
	self:on_resolution_modified()

	self._init_done = true
end

TalentsView._populate_archetype_data = function (self, archetype, specialization)
	local archetype_header_widget = self._widgets_by_name.archetype_header
	local content = archetype_header_widget.content
	content.class_icon = archetype.archetype_icon_large
	local localized_archetype_name = self:_localize(archetype.archetype_title)
	local localized_specialization_name = self:_localize(specialization.title)
	content.text = string.format("%s %s", localized_archetype_name, localized_specialization_name)
end

TalentsView._set_level_bar = function (self, player_level)
	if player_level < 5 then
		return
	end

	local widget = self._widgets_by_name.main_panel
	local level_bar_style = widget.style.level_bar_fill
	local num_levels_between_groups = 5
	local num_level_plates_big = math.floor(player_level / num_levels_between_groups)
	local num_level_plates_small = player_level % num_levels_between_groups
	local level_bar_width = level_bar_style.size[1]
	local fill_width = level_bar_style.plate_big_width + (num_level_plates_big - 1) * level_bar_style.distance_between_big_plates + num_level_plates_small * level_bar_style.plate_small_width
	level_bar_style.material_values.progression = fill_width / level_bar_width
end

TalentsView._populate_talents_data = function (self, character_id, archetype, specialization, talents, selected_talents, player_level)
	local talent_group_definitions = specialization.talent_groups
	local talent_widgets = self._talent_widgets

	if talent_widgets then
		for i = 1, #talent_widgets do
			local widget = talent_widgets[i]

			self._grid:remove_widget(widget)
		end
	end

	table.clear(talent_widgets)

	local talent_groups = self._talent_groups

	if talent_groups then
		for i = 1, #talent_groups do
			local talent_group = talent_groups[i]
			local group_widget = talent_group.group_widget

			self._grid:remove_widget(group_widget)
		end
	end

	table.clear(talent_groups)

	local talent_service = self._talent_service
	local group_index = 0

	for i = 1, #talent_group_definitions do
		local group_definition = talent_group_definitions[i]
		local group_name = group_definition.group_name
		local group_settings = ViewSettings.talent_groups[group_name]
		local is_group_invisible = not group_settings or group_definition.invisible_in_ui
		local required_level = group_definition.required_level or 0
		local is_locked = player_level < required_level
		local is_non_selectable = group_settings and group_settings.non_selectable_group
		local group_talents = group_definition.talents
		local group_widget = nil

		if not is_group_invisible then
			local grid_positions = group_settings.positions
			local blueprint = is_locked and ViewBlueprints[group_settings.blueprint_locked] or ViewBlueprints[group_settings.blueprint] or ViewBlueprints.talent_group_single_slot
			local group_widget_name = "group_" .. i
			local init = blueprint.init
			group_widget = self._grid:add_widget_to_grid(grid_positions[1][1], grid_positions[1][2], group_widget_name, blueprint, init, group_settings, group_definition, player_level)
			group_index = group_index + 1
			local is_empty_group = not is_locked and not is_non_selectable
			local group_talent_widgets = {}

			for talent_index = 1, #group_talents do
				local talent_name = group_talents[talent_index]
				local talent = talents[talent_name]
				local callback_group_index = group_widget and group_index
				local is_selected_talent = selected_talents[talent_name] or false
				local talent_widget = self:_create_talent_widget(talent_name, talent_index, talent, group_definition, group_settings, callback_group_index, is_locked, is_selected_talent)
				talent_widgets[#talent_widgets + 1] = talent_widget
				group_talent_widgets[talent_index] = talent_widget
				is_empty_group = is_empty_group and not is_selected_talent
			end

			group_widget.content.group_has_selected_talent = not is_empty_group
			local is_new_unlocked_group = talent_service:is_group_marked_as_new(character_id, i)

			if is_new_unlocked_group then
				group_widget.content.is_new = true

				for j = 1, #group_talent_widgets do
					local widget = group_talent_widgets[j]
					local widget_content = widget.content
					widget_content.is_new = is_empty_group
				end

				talent_service:unmark_unlocked_group_as_new(character_id, i)
			end

			local new_talent_group = {
				definition = group_definition,
				group_widget = group_widget,
				talent_widgets = group_talent_widgets,
				non_selectable_group = is_non_selectable
			}
			talent_groups[group_index] = new_talent_group
		end
	end
end

local _talent_icon_blueprint = ViewBlueprints.talent_icon
local _passive_talent_icon_blueprint = ViewBlueprints.passive_talent_icon
local _locked_talent_icon_blueprint = ViewBlueprints.locked_talent_icon

TalentsView._create_talent_widget = function (self, name, talent_index, talent, group_definition, group_settings, callback_group_index, is_locked, is_selected_talent)
	local talent_icon = talent.icon
	local is_non_selectable = group_settings.non_selectable_group
	local blueprint = nil

	if talent_icon and is_locked then
		blueprint = _locked_talent_icon_blueprint
	elseif talent_icon and is_non_selectable then
		blueprint = _passive_talent_icon_blueprint
	elseif talent_icon then
		blueprint = _talent_icon_blueprint
	elseif talent.large_icon then
		blueprint = ViewBlueprints.talent_icon_large
	end

	local grid_position = group_settings.positions[talent_index]
	local widget_offset_x = nil
	local num_talent_widgets = #group_definition.talents

	if group_settings.even_talents_offset_x and num_talent_widgets % 2 == 0 then
		widget_offset_x = group_settings.even_talents_offset_x
	elseif group_settings.odd_talents_offset_x and num_talent_widgets % 2 == 1 then
		widget_offset_x = group_settings.odd_talents_offset_x
	end

	local function init(widget)
		if widget_offset_x then
			widget.offset[1] = widget_offset_x
		end

		local widget_content = widget.content
		widget_content.has_focus_ring = blueprint.has_focus_ring
		widget_content.talent_name = name
		widget_content.talent = talent
		widget_content.talent_display_name = self:_localize(talent.display_name)
		widget_content.is_selectable = not is_non_selectable and not is_locked
		local format_values = talent.format_values
		local localized_description = self:_localize(talent.description, false, format_values)
		widget_content.talent_description = localized_description
		local widget_style = widget.style

		if callback_group_index and not is_locked then
			local hotspot = widget_content.hotspot
			hotspot.is_selected = is_selected_talent

			if not self._is_readonly then
				hotspot.pressed_callback = callback(self, "cb_widget_clicked", widget, callback_group_index, false)
				hotspot.right_pressed_callback = callback(self, "cb_widget_clicked", widget, callback_group_index, true)
			end
		end

		local icon_style = widget_style.icon
		local material_values = icon_style.material_values
		material_values.icon_texture = talent_icon or talent.large_icon
	end

	local talent_widget = self._grid:add_widget_to_grid(grid_position[1], grid_position[2], name, blueprint, init)

	return talent_widget
end

return TalentsView
