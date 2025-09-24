-- chunkname: @scripts/ui/views/talent_builder_view/talent_builder_view.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local CharacterSheet = require("scripts/utilities/character_sheet")
local Colors = require("scripts/utilities/ui/colors")
local Definitions = require("scripts/ui/views/talent_builder_view/talent_builder_view_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local NodeBuilderViewBase = require("scripts/ui/views/node_builder_view_base/node_builder_view_base")
local ProfileUtils = require("scripts/utilities/profile_utils")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local TalentBuilderViewSummaryBlueprints = require("scripts/ui/views/talent_builder_view/talent_builder_view_summary_blueprints")
local TalentBuilderViewTutorialBlueprints = require("scripts/ui/views/talent_builder_view/talent_builder_view_tutorial_blueprints")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local Text = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local loadout_ability_widget_name_list = {
	"loadout_slot_ability",
	"loadout_slot_tactical",
	"loadout_slot_aura",
}
local base_loadout_presentation_order = {
	"ability",
	"blitz",
	"aura",
}
local class_loadout = {
	ability = {},
	blitz = {},
	aura = {},
}
local base_loadout_to_type = {
	ability = "ability",
	aura = "aura",
	blitz = "tactical",
}
local TalentBuilderView = class("TalentBuilderView", "NodeBuilderViewBase")

TalentBuilderView.init = function (self, settings, context)
	self._context = context
	self._is_readonly = context and context.is_readonly

	local player = context and context.player or self:_player()

	self._preview_player = player
	self._peer_id = self._preview_player:peer_id()
	self._local_player_id = self._preview_player:local_player_id()
	self._is_own_player = self._preview_player == self:_player()

	TalentBuilderView.super.init(self, Definitions, settings, context)

	self._save_talent_changes = false

	local resolution_scale = RESOLUTION_LOOKUP.scale
	local resolution_width = RESOLUTION_LOOKUP.width

	self._gamepad_cursor_current_pos = Vector3Box(Vector3(resolution_width * 0.5, 200 * resolution_scale, 0))
	self._gamepad_cursor_current_vel = Vector3Box()
	self._gamepad_cursor_target_pos = Vector3Box(Vector3(resolution_width * 0.5, 200 * resolution_scale, 0))
	self._gamepad_cursor_average_vel = Vector3Box()
	self._gamepad_cursor_snap_delay = 0
	self._gamepad_cursor_previous_scroll_height = 0
	self._summery_window_input_action = "talents_summery_overview_pressed"
	self._grid_size = 30
end

TalentBuilderView.on_enter = function (self)
	if self._player_mode then
		self._definitions.scenegraph_definition.layout_background.horizontal_alignment = "center"
	end

	self._talent_hover_data = {}

	TalentBuilderView.super.on_enter(self)
	self:_register_event("event_on_profile_preset_changed", "event_on_profile_preset_changed")

	self._widgets_by_name.summary_window.content.visible = false
	self._widgets_by_name.summary_button.style.text.text_horizontal_alignment = "center"
	self._widgets_by_name.summary_button.style.text.text_vertical_alignment = "top"
	self._widgets_by_name.summary_button.content.hotspot.pressed_callback = callback(self, "cb_on_talent_summary_pressed")

	self:_update_summery_button_text()

	local active_layout = self._active_layout
	local nodes = active_layout.nodes
	local active_layout_version = active_layout.version
	local profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if self._is_own_player and not self._is_readonly then
		local talents
		local profile_preset = profile_preset_id and ProfileUtils.get_profile_preset(profile_preset_id)

		if profile_preset then
			self._active_profile_preset_id = profile_preset_id

			local profile_preset_talents_version = profile_preset.talents_version

			if profile_preset_talents_version ~= active_layout_version then
				talents = {}
			else
				talents = profile_preset and profile_preset.talents or {}
			end
		else
			local context = self._context
			local current_profile_equipped_talents = context and context.current_profile_equipped_talents

			if current_profile_equipped_talents then
				talents = table.clone(current_profile_equipped_talents)
			else
				local player = self._preview_player
				local profile = player:profile()

				talents = {}

				for node_index_s, points_spent_on_node in pairs(profile.selected_nodes) do
					local node_index = tonumber(node_index_s)
					local node = nodes[node_index]

					if node then
						talents[node.widget_name] = points_spent_on_node
					end
				end
			end
		end

		self._points_spent_on_node_widgets = table.clone_instance(talents)

		local total_points_spent = 0

		for key, value in pairs(self._points_spent_on_node_widgets) do
			local node = self:_node_by_name(key)

			if type(value) == "number" and node then
				total_points_spent = total_points_spent + value
			else
				self._points_spent_on_node_widgets[key] = nil

				if profile_preset_id then
					ProfileUtils.save_talent_node_for_profile_preset(profile_preset_id, key, nil)
				end
			end
		end

		self._node_points_spent = total_points_spent or 0
	else
		local player = self._preview_player
		local profile = player:profile()
		local points_spent_on_node_widgets = self._points_spent_on_node_widgets
		local total_points_spent = 0

		for node_index_s, points_spent_on_node in pairs(profile.selected_nodes) do
			local node_index = tonumber(node_index_s)
			local node = nodes[node_index]

			points_spent_on_node_widgets[node.widget_name] = points_spent_on_node
			total_points_spent = total_points_spent + points_spent_on_node
		end

		self._node_points_spent = total_points_spent or 0
	end

	local widgets = self._node_widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local already_spent_node_points, _ = self:_node_points_by_widget(widget)

		content.has_points_spent = already_spent_node_points > 0
		content.highlighted = content.has_points_spent
		content.alpha_anim_progress = content.has_points_spent and 1 or 0
	end

	self._draw_instant_lines = true

	self:_refresh_all_nodes()
	self:_update_base_talent_loadout_presentation()

	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	local show_tutorial_popup = not save_data or not save_data.talent_tutorial_popup_shown

	if show_tutorial_popup and not self._is_readonly and self._is_own_player then
		self:_setup_tutorial_grid()
		self:_present_tutorial_popup_page(1)
	else
		self:_close_tutorial_window()
	end
end

TalentBuilderView._update_summery_button_text = function (self)
	local action = self._summery_window_input_action
	local service_type = "View"
	local include_input_type = false
	local summery_button_text = Text.localize_with_button_hint(action, "loc_alias_talent_builder_view_hotkey_summary", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)

	self._widgets_by_name.summary_button.content.text = summery_button_text
end

TalentBuilderView.event_on_profile_preset_changed = function (self, profile_preset, on_preset_deleted)
	local layout = self:get_active_layout()
	local active_layout_version = layout.version
	local talents_version = profile_preset and profile_preset.talents_version
	local profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local previously_active_profile_preset_id = self._active_profile_preset_id
	local trigger_talent_nodes_event_update = false
	local talents

	if previously_active_profile_preset_id and profile_preset then
		if talents_version ~= active_layout_version then
			talents = {}
		else
			talents = profile_preset and profile_preset.talents or {}
		end
	else
		talents = table.clone_instance(self._points_spent_on_node_widgets)
		trigger_talent_nodes_event_update = true
		self._save_talent_changes = true
	end

	self._points_spent_on_node_widgets = talents and table.clone_instance(talents) or {}

	local total_points_spent = 0

	for key, value in pairs(self._points_spent_on_node_widgets) do
		local node = self:_node_by_name(key)

		if type(value) == "number" and node then
			total_points_spent = total_points_spent + value
		else
			self._points_spent_on_node_widgets[key] = nil

			if profile_preset_id then
				ProfileUtils.save_talent_node_for_profile_preset(profile_preset_id, key, nil)
			end
		end
	end

	self._node_points_spent = total_points_spent or 0

	local widgets = self._node_widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local already_spent_node_points, _ = self:_node_points_by_widget(widget)

		content.has_points_spent = already_spent_node_points > 0
		content.highlighted = content.has_points_spent
		content.alpha_anim_progress = content.has_points_spent and 1 or 0
	end

	self._draw_instant_lines = true

	self:_set_selected_node(nil)
	self:_refresh_all_nodes()

	self._active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	self:_update_base_talent_loadout_presentation()
end

TalentBuilderView.on_exit = function (self)
	local layout = self:get_active_layout()

	if not layout then
		return
	end

	TalentBuilderView.super.on_exit(self)
end

TalentBuilderView.get_talent_points_spent_on_nodes = function (self)
	return self._points_spent_on_node_widgets
end

TalentBuilderView._remove_node_point_on_widget = function (self, widget)
	TalentBuilderView.super._remove_node_point_on_widget(self, widget)
	self:_update_base_talent_loadout_presentation()
	Managers.event:trigger("event_player_talent_node_updated", self._points_spent_on_node_widgets)

	self._save_talent_changes = true
end

TalentBuilderView._add_node_point_on_widget = function (self, widget)
	local success = TalentBuilderView.super._add_node_point_on_widget(self, widget)

	if success then
		self._save_talent_changes = true

		local parent_line_anim_data = widget.content.parent_line_anim_data

		if parent_line_anim_data then
			table.clear(parent_line_anim_data)
		end

		local node = widget.content.node_data
		local widget_name = widget.name
		local widgets_by_name = self._widgets_by_name
		local children = node.children

		for i = 1, #children do
			local child_name = children[i]

			if self:_node_by_name(child_name) then
				local child_widget = widgets_by_name[child_name]
				local child_parent_line_anim_data = child_widget.content.parent_line_anim_data
				local child_widget_anim_data = child_parent_line_anim_data and child_parent_line_anim_data[widget_name]

				if child_widget_anim_data then
					child_widget_anim_data.progress_fraction = 0
					child_widget_anim_data.progress_complete = false
				end
			end
		end

		if self:_points_available() == 0 then
			self:_play_sound(UISoundEvents.talent_last_point_spent)
		end

		self:_update_base_talent_loadout_presentation()
		Managers.event:trigger("event_player_talent_node_updated", self._points_spent_on_node_widgets)
	end

	return success
end

TalentBuilderView.cb_on_talent_summary_pressed = function (self)
	if not self._summary_grid then
		self._setup_summery_grid_next_frame = true
	else
		self:_close_summary_window()
	end
end

TalentBuilderView._close_summary_window = function (self)
	if self._summary_grid then
		self:_remove_element("summary_grid")

		self._summary_grid = nil
		self._widgets_by_name.summary_window.content.visible = false
		self._summary_window_hovered = false

		self:_play_sound(UISoundEvents.summary_popup_exit)
	end

	self._close_summery_grid_next_frame = false
end

TalentBuilderView._close_tutorial_window = function (self)
	self._widgets_by_name.tutorial_window.content.visible = false
	self._tutorial_window_hovered = false
	self._widgets_by_name.tutorial_button_1.content.visible = false
	self._widgets_by_name.tutorial_button_2.content.visible = false

	if self._tutorial_grid then
		self:_remove_element("tutorial_grid")

		self._tutorial_grid = nil

		self:_play_sound(UISoundEvents.tutorial_popup_exit)

		local save_manager = Managers.save
		local save_data = save_manager:account_data()

		if save_data and not save_data.talent_tutorial_popup_shown then
			save_data.talent_tutorial_popup_shown = true

			save_manager:queue_save()
		end
	end

	self._close_tutorial_grid_next_frame = false
end

TalentBuilderView.cb_on_clear_all_talents_pressed = function (self)
	local context = {
		description_text = "loc_talent_menu_popup_clear_all_points_description",
		no_exit_sound = true,
		title_text = "loc_talent_menu_popup_clear_all_points_title",
		options = {
			{
				close_on_pressed = true,
				text = "loc_talent_menu_popup_clear_all_button_label",
				callback = callback(function ()
					self:clear_node_points()
					self:_play_sound(UISoundEvents.talent_node_clear_all)
				end),
			},
			{
				close_on_pressed = true,
				hotkey = "back",
				template_type = "terminal_button_small",
				text = "loc_popup_button_cancel",
				callback = callback(function ()
					self:_play_sound(UISoundEvents.system_popup_exit)
				end),
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

TalentBuilderView.clear_node_points = function (self)
	TalentBuilderView.super.clear_node_points(self)

	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local widget = node_widgets[i]
		local parent_line_anim_data = widget.content.parent_line_anim_data

		if parent_line_anim_data then
			table.clear(parent_line_anim_data)
		end
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.talent_points.content.play_badge_effect_anim = true

	self:_update_base_talent_loadout_presentation()

	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if active_profile_preset_id then
		ProfileUtils.clear_all_talent_nodes_for_profile_preset(active_profile_preset_id)
	end

	Managers.event:trigger("event_player_talent_node_updated", self._points_spent_on_node_widgets)

	self._save_talent_changes = true
end

TalentBuilderView._setup_node_connection_widget = function (self)
	self._node_connection_widget = self:_create_widget("node_connection", self._definitions.node_connection_definition)
end

TalentBuilderView.on_archetype_name_changed = function (self, archetype_name)
	local glow_colors = TalentBuilderViewSettings.glow_colors_by_class[archetype_name]

	self._global_node_offset = TalentBuilderViewSettings.starting_talent_nodes_offset_by_name[archetype_name] or {
		0,
		0,
	}

	local node_connection_style = self._node_connection_widget.style

	node_connection_style.line.material_values.fill_color = Colors.format_color_to_material(glow_colors.line_chosen.fill_color)
	node_connection_style.line.material_values.blur_color = Colors.format_color_to_material(glow_colors.line_chosen.blur_color)
	node_connection_style.line_available.material_values.fill_color = Colors.format_color_to_material(glow_colors.line_available.fill_color)
	node_connection_style.line_available.material_values.blur_color = Colors.format_color_to_material(glow_colors.line_available.blur_color)

	local material_name = TalentBuilderViewSettings.starting_points_material_by_name[archetype_name]
	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local node = self:active_layout_node_by_name(node_widget.name)

		if node.type == "start" then
			node_widget.content.icon = material_name
			node_widget.style.icon.material_values.fill_color = Colors.format_color_to_material(glow_colors.line_chosen.fill_color)
			node_widget.style.icon.material_values.blur_color = Colors.format_color_to_material(glow_colors.line_chosen.blur_color)
		elseif node_widget.style.frame_selected then
			node_widget.style.frame_selected.material_values.fill_color = Colors.format_color_to_material(glow_colors.line_chosen.fill_color)
			node_widget.style.frame_selected.material_values.blur_color = Colors.format_color_to_material(glow_colors.line_chosen.blur_color)
		end
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.info_banner.style.badge.material_values.badge = TalentBuilderViewSettings.archetype_badge_texture_by_name[archetype_name]
	widgets_by_name.info_banner.content.play_badge_effect_anim = true

	local talent_archetype_background = TalentBuilderViewSettings.archetype_backgrounds_by_name[archetype_name]

	widgets_by_name.layout_background.content.image = talent_archetype_background
end

TalentBuilderView._refresh_all_nodes = function (self)
	TalentBuilderView.super._refresh_all_nodes(self)

	local layout = self:get_active_layout()
	local archetype_name = layout.archetype_name

	if archetype_name then
		self:on_archetype_name_changed(archetype_name)
	end

	self:_update_base_talent_loadout_presentation()
end

TalentBuilderView._on_input_scroll_axis_changed = function (self, scroll_value, cursor_position)
	if self._player_mode then
		self._is_scrolling = true
		self._gamepad_selected_base_widget = nil
		self._tooltip_alpha_multiplier = 0
		self._tooltip_draw_delay = TalentBuilderViewSettings.tooltip_fade_delay

		if self._selected_node ~= nil then
			self:_set_selected_node(nil)
		end

		local widgets_by_name = self._widgets_by_name
		local layout_background_widget = widgets_by_name.layout_background
		local scenegraph_id = layout_background_widget.scenegraph_id
		local saved_scenegraph_settings = self._saved_scenegraph_settings
		local final_y
		local _, scenegraph_position_y, _ = self:_scenegraph_position(scenegraph_id)
		local scenegraph_settings = saved_scenegraph_settings[scenegraph_id]

		if scenegraph_settings then
			final_y = scenegraph_settings.y
		else
			final_y = scenegraph_position_y
		end

		local scroll_add_value = self._using_cursor_navigation and 100 or 20

		self:_scroll_to_height(final_y + scroll_value * scroll_add_value)
	else
		TalentBuilderView.super._on_input_scroll_axis_changed(self, scroll_value, cursor_position)
	end
end

TalentBuilderView._scroll_to_height = function (self, height)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local screen_height = RESOLUTION_LOOKUP.height
	local saved_scenegraph_settings = self._saved_scenegraph_settings
	local render_scale = self._render_scale
	local render_inverse_scale = 1 / render_scale
	local scenegraph_settings = saved_scenegraph_settings[scenegraph_id]
	local _, background_height = self:_background_size()
	local final_y = math.clamp(height, -math.max(background_height - screen_height * render_inverse_scale), 0)

	self:_set_scenegraph_position(scenegraph_id, nil, final_y)
	self:_set_scenegraph_position("scroll_background", nil, final_y, nil, nil, nil, self._ui_overlay_scenegraph)

	if scenegraph_settings then
		scenegraph_settings.y = final_y
	end
end

TalentBuilderView._background_scrolled_amount = function (self)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local _, scenegraph_position_y, _ = self:_scenegraph_position(scenegraph_id)

	return scenegraph_position_y
end

TalentBuilderView._get_node_definition_by_type = function (self, node_type)
	local default_scenegraph_definition = self:_get_scenegraph_definition("talent")
	local scenegraph_definition = table.clone(default_scenegraph_definition)
	local definitions = self._definitions
	local node_definition
	local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[node_type]

	if settings_by_node_type then
		node_definition = settings_by_node_type.node_definition
		scenegraph_definition.size[1] = settings_by_node_type.size[1]
		scenegraph_definition.size[2] = settings_by_node_type.size[2]
	else
		node_definition = definitions.node_definition
		scenegraph_definition.size[1] = 144
		scenegraph_definition.size[2] = 144
	end

	return node_definition, scenegraph_definition
end

TalentBuilderView._create_node_widget = function (self, node)
	local widget = TalentBuilderView.super._create_node_widget(self, node)
	local node_type = node.type
	local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[node_type]

	if settings_by_node_type and widget.style.icon then
		local node_gradient_color

		if not node_gradient_color or node_gradient_color == "not_selected" then
			widget.style.icon.material_values.gradient_map = settings_by_node_type.gradient_map
		else
			widget.style.icon.material_values.gradient_map = node_gradient_color
		end
	end

	return widget
end

TalentBuilderView._is_any_of_widgets_line_progress_done = function (self, widget)
	local parent_line_anim_data = widget.content.parent_line_anim_data

	if parent_line_anim_data then
		for _, data in pairs(parent_line_anim_data) do
			local progress_fraction = data.progress_fraction or 0

			if progress_fraction >= 1 then
				return true
			end
		end
	end

	return false
end

TalentBuilderView._draw_layout_node_connections = function (self, dt, t, input_service, ui_renderer, render_settings, layout)
	local is_any_line_progressing_last_frame = self._is_any_line_progressing

	self._is_any_line_progressing = false

	TalentBuilderView.super._draw_layout_node_connections(self, dt, t, input_service, ui_renderer, render_settings, layout)

	if is_any_line_progressing_last_frame and not self._is_any_line_progressing then
		self:_play_sound(UISoundEvents.talent_node_line_connection_stop)
	elseif not is_any_line_progressing_last_frame and self._is_any_line_progressing then
		self:_play_sound(UISoundEvents.talent_node_line_connection_start)
	end
end

TalentBuilderView._draw_connection_between_widgets = function (self, ui_renderer, visible, dt, parent_node, child_node, offset_x, offset_y, distance, angle)
	local node_connection_widget = self._node_connection_widget

	if not node_connection_widget then
		return
	end

	local widgets_by_name = self._widgets_by_name
	local points_spent_on_node_widgets = self._points_spent_on_node_widgets
	local is_parent_starting_node = parent_node.type == "start"
	local parent_node_name = parent_node.widget_name
	local parent_node_widget = widgets_by_name[parent_node_name]
	local parent_node_requirements = parent_node.requirements
	local children_unlock_points = parent_node_requirements and parent_node_requirements.children_unlock_points or 0
	local points_spent_on_parent = points_spent_on_node_widgets[parent_node_name] or 0
	local child_status = self:_node_availability_status(child_node) or TalentBuilderView.NODE_STATUS.available
	local child_node_name = child_node.widget_name
	local child_widget = widgets_by_name[child_node_name]
	local child_points_spent = points_spent_on_node_widgets[child_node_name] or 0
	local points_available = self:_points_available()
	local draw_instant_lines = self._draw_instant_lines
	local color_status

	if is_parent_starting_node then
		if child_points_spent > 0 then
			color_status = "chosen"
		elseif points_available > 0 then
			color_status = "unlocked"
		end
	elseif child_status == TalentBuilderView.NODE_STATUS.locked or child_status == TalentBuilderView.NODE_STATUS.unavailable or not (children_unlock_points <= points_spent_on_parent) then
		color_status = "locked"
	elseif child_points_spent > 0 then
		color_status = "chosen"
	elseif points_available > 0 then
		color_status = "unlocked"
	end

	local parent_line_anim_data = child_widget.content.parent_line_anim_data

	if not parent_line_anim_data then
		parent_line_anim_data = {}
		child_widget.content.parent_line_anim_data = parent_line_anim_data
	end

	if not parent_line_anim_data[parent_node_name] or draw_instant_lines then
		parent_line_anim_data[parent_node_name] = {
			progress_complete = false,
			progress_fraction = draw_instant_lines and 1 or 0,
			alpha_fraction = draw_instant_lines and 1 or 0,
		}
	end

	local anim_line_data = parent_line_anim_data[parent_node_name]
	local anim_line_progress = draw_instant_lines and 1 or anim_line_data.progress_fraction or 0
	local progressing = color_status == "chosen" and anim_line_progress ~= 1
	local can_progress = color_status == "unlocked"
	local has_progressed = color_status == "chosen" and anim_line_progress == 1
	local alpha_anim_speed = draw_instant_lines and 0 or 1.5

	anim_line_data.alpha_fraction = (can_progress or progressing or has_progressed) and math.clamp(anim_line_data.alpha_fraction + dt * alpha_anim_speed, 0, 1) or 0

	if has_progressed and not anim_line_data.progress_complete then
		anim_line_data.progress_complete = true

		if not child_widget.content.highlighted then
			child_widget.content.play_select_anim = true
			child_widget.content.highlighted = true

			self:_play_select_sound_for_node_widget(child_widget)
		end
	end

	if progressing then
		local is_any_of_widgets_line_progress_done = self:_is_any_of_widgets_line_progress_done(parent_node_widget)

		if is_any_of_widgets_line_progress_done or is_parent_starting_node or draw_instant_lines then
			local line_anim_speed = 3

			anim_line_data.progress_fraction = draw_instant_lines and 1 or math.clamp(anim_line_progress + dt * line_anim_speed, 0, 1)
		end
	end

	local fill_distance = distance * math.easeInCubic(anim_line_progress)

	self:_apply_node_connection_line_colors(color_status, anim_line_data.alpha_fraction)

	local node_connection_style = node_connection_widget.style

	for pass_style_name, pass_style in pairs(node_connection_style) do
		if pass_style_name == "line" then
			pass_style.size[1] = fill_distance
		elseif pass_style_name ~= "arrow" then
			pass_style.size[1] = distance
		end

		pass_style.angle = math.pi - angle
	end

	node_connection_widget.content.progressing = not has_progressed and progressing
	node_connection_widget.content.has_progressed = has_progressed
	node_connection_widget.content.can_progress = can_progress

	self:_apply_node_connection_anims(node_connection_widget, parent_node, dt)

	if visible then
		UIWidget.draw(node_connection_widget, ui_renderer)
	end

	if progressing then
		self._is_any_line_progressing = true
	end

	return visible
end

TalentBuilderView._apply_node_connection_anims = function (self, node_connection_widget, parent_node, dt)
	return
end

TalentBuilderView._apply_node_connection_line_colors = function (self, color_status, alpha_multiplier)
	local node_connection_widget = self._node_connection_widget

	if not node_connection_widget then
		return
	end

	local alpha = 255

	if color_status == "locked" then
		alpha = 0
	elseif color_status == "chosen" then
		alpha = 0
	elseif color_status == "unlocked" then
		local pulse_speed = 4
		local time_since_launch = Application.time_since_launch()
		local pulse_progress = 0.5 + math.sin(time_since_launch * pulse_speed) * 0.5

		alpha = 200
	end

	local node_connection_style = node_connection_widget.style
	local line_available_color = node_connection_style.line_available.color

	line_available_color[1] = alpha * alpha_multiplier
end

TalentBuilderView._setup_layouts = function (self)
	local player_mode = self._player_mode

	if player_mode then
		self._layouts[#self._layouts + 1] = self:_get_player_mode_layout()
	end
end

TalentBuilderView._get_player_mode_layout = function (self)
	local player = self._preview_player
	local profile = player and player:profile()
	local archetype = profile.archetype

	if archetype then
		local talent_layout_file_path = archetype.talent_layout_file_path

		if talent_layout_file_path then
			return require(talent_layout_file_path)
		end
	end
end

local resolution_modified_key = "modified"

TalentBuilderView.update = function (self, dt, t, input_service)
	if self._player_mode and self._preview_player and not Managers.player:player(self._peer_id, self._local_player_id) then
		self._preview_player = nil
	end

	if self._player_mode and not self._preview_player then
		return
	end

	self._is_scrolling = nil

	if self._close_tutorial_grid_next_frame then
		self:_close_tutorial_window()
	end

	if self._setup_summery_grid_next_frame then
		self:_setup_talents_summary_grid()

		self._setup_summery_grid_next_frame = false
		self._widgets_by_name.summary_window.content.visible = true
	elseif self._close_summery_grid_next_frame then
		self:_close_summary_window()
	end

	self._summary_window_hovered = self._widgets_by_name.summary_window.content.hotspot.is_hover
	self._summary_button_hovered = self._widgets_by_name.summary_button.content.hotspot.is_hover

	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key]

	if resolution_modified then
		self:_on_input_scroll_axis_changed(0, {
			0,
			0,
		})
	end

	local pass_input, pass_draw = TalentBuilderView.super.update(self, dt, t, input_service)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.talent_points.content.text = self:_points_available()

	local selected_node = self._selected_node
	local selected_node_widget = selected_node and self._widgets_by_name[selected_node.widget_name]
	local tooltip_node_widget = selected_node_widget or self._can_draw_tooltip and (self._hovered_node_widget or self._hovered_base_talent_widget)

	if tooltip_node_widget then
		local current_zoom = self._current_zoom
		local resolution_inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local render_scale = self._render_scale
		local render_inverse_scale = 1 / render_scale
		local ui_overlay_scenegraph = self._ui_overlay_scenegraph
		local is_node_in_overlay_scenegraph = tooltip_node_widget == self._hovered_base_talent_widget and ui_overlay_scenegraph
		local node_scenegraph_position = self:_scenegraph_world_position(tooltip_node_widget.scenegraph_id, render_scale, is_node_in_overlay_scenegraph and ui_overlay_scenegraph)
		local node_scenegraph_position_x, node_scenegraph_position_y = node_scenegraph_position[1], node_scenegraph_position[2]
		local node_width, node_height = self:_scenegraph_size(tooltip_node_widget.scenegraph_id, is_node_in_overlay_scenegraph and ui_overlay_scenegraph)
		local node_offset_x, node_offset_y = node_width, node_height
		local layout_background_widget = widgets_by_name.layout_background
		local tooltip_widget = widgets_by_name.tooltip
		local tooltip_offset = tooltip_widget.offset
		local tooltip_scenegraph_position_x, tooltip_scenegraph_position_y, _ = self:_scenegraph_position(tooltip_widget.scenegraph_id, ui_overlay_scenegraph)
		local input_surface_widget = widgets_by_name.input_surface
		local input_surface_size_addition = input_surface_widget.style.hotspot.size_addition
		local input_surface_offset = input_surface_widget.style.hotspot.offset
		local resolution_width = RESOLUTION_LOOKUP.width
		local resolution_height = RESOLUTION_LOOKUP.height
		local tooltip_width, tooltip_height = self:_scenegraph_size(tooltip_widget.scenegraph_id, ui_overlay_scenegraph)

		if is_node_in_overlay_scenegraph then
			tooltip_offset[1] = 440
			tooltip_offset[2] = 638
		else
			tooltip_offset[1] = math.clamp(tooltip_scenegraph_position_x + (node_scenegraph_position_x + node_offset_x * render_scale) * resolution_inverse_scale, 0, resolution_width * render_inverse_scale * current_zoom - tooltip_width)
			tooltip_offset[2] = math.clamp(tooltip_scenegraph_position_y + (node_scenegraph_position_y + node_offset_y * render_scale) * resolution_inverse_scale, input_surface_offset[2] + 50, resolution_height * render_inverse_scale * current_zoom + (input_surface_offset[2] + input_surface_size_addition[2]) - tooltip_height)
		end

		math.point_is_inside_2d_box = function (pos, lower_left_corner, size)
			return pos[1] > lower_left_corner[1] and pos[1] < lower_left_corner[1] + size[1] and pos[2] > lower_left_corner[2] and pos[2] < lower_left_corner[2] + size[2]
		end
	end

	self:_update_node_widgets_blocked_symbol_state()

	if self:_is_handling_popup_window() then
		pass_input = false
	end

	return pass_input, pass_draw
end

TalentBuilderView.draw = function (self, dt, t, input_service, layer)
	if self._player_mode and not self._preview_player then
		return
	end

	TalentBuilderView.super.draw(self, dt, t, input_service, layer)

	if self._draw_instant_lines then
		self._draw_instant_lines = false
	end
end

TalentBuilderView.draw_layout = function (self, dt, t, input_service, layer)
	TalentBuilderView.super.draw_layout(self, dt, t, input_service, layer)
end

TalentBuilderView._allowed_node_input = function (self)
	if self:_is_handling_popup_window() or self._input_blocked then
		return false
	end

	if self._summary_button_hovered then
		return false
	end

	return TalentBuilderView.super._allowed_node_input(self)
end

TalentBuilderView.can_exit = function (self)
	return not self:_is_handling_popup_window()
end

TalentBuilderView.block_input = function (self, block)
	self._input_blocked = block
end

TalentBuilderView._handle_input = function (self, input_service, dt, t)
	local input_blocked = self._input_blocked

	if input_blocked then
		input_service = input_service:null_service()
	end

	local widgets_by_name = self._widgets_by_name

	if self._tutorial_grid then
		if not self._close_tutorial_grid_next_frame and not self._tutorial_window_open_animation_id then
			self:_handle_tutorial_button_gamepad_navigation(input_service)

			if input_service:get("back") then
				self:cb_on_tutorial_button_1_pressed()
			elseif input_service:get("gamepad_confirm_pressed") then
				if widgets_by_name.tutorial_button_1.content.hotspot.is_selected then
					self:cb_on_tutorial_button_1_pressed()
				elseif widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
					self:cb_on_tutorial_button_2_pressed()
				end
			end
		end

		if self._tutorial_window_open_animation_id and self:_is_animation_completed(self._tutorial_window_open_animation_id) then
			self._tutorial_window_open_animation_id = nil
		end
	elseif not self._setup_summery_grid_next_frame then
		if input_service:get(self._summery_window_input_action) then
			if not self._summary_grid then
				self._setup_summery_grid_next_frame = true
			else
				self:_close_summary_window()
			end
		elseif self._summary_grid and (input_service:get("back") or input_service:get("left_pressed") and not self._summary_window_hovered and not self._summary_button_hovered) then
			self._close_summery_grid_next_frame = true
		end
	end

	TalentBuilderView.super._handle_input(self, input_service, dt, t)

	if not self:_is_handling_popup_window() and not input_blocked then
		if not self._using_cursor_navigation then
			local selected_node = self._selected_node

			if not self._input_handled_current_frame and selected_node then
				local widget_name = selected_node.widget_name
				local widget = self._widgets_by_name[widget_name]

				if input_service:get("confirm_pressed") then
					local points_spent_on_node_widgets = self._points_spent_on_node_widgets
					local points_spent = points_spent_on_node_widgets[widget_name]

					if self:_can_remove_point_in_node(selected_node) and points_spent and points_spent > 0 then
						self:_on_node_widget_right_pressed(widget)

						self._input_handled_current_frame = true
					else
						self:_on_node_widget_left_pressed(widget)

						self._input_handled_current_frame = true
					end
				end
			end
		end

		if not self._using_cursor_navigation then
			self:_update_gamepad_cursor(dt, t, input_service)
		end

		self:_handle_base_talent_loadout_hover()
	else
		local gamepad_cursor = self._widgets_by_name.gamepad_cursor

		gamepad_cursor.visible = false
	end
end

local function process_gamepad_cursor_widget_func(self, widget, cursor_size, is_sticky, is_selected, cursor_center_position, normalized_gamepad_cursor_average_vel, optional_ui_scenegraph)
	local settings = TalentBuilderViewSettings.gamepad_cursor_settings
	local cursor_pos = cursor_center_position - 0.5 * cursor_size

	if widget.visible then
		local widget_scenegraph_id = widget.scenegraph_id
		local widget_world_position = self:_scenegraph_world_position(widget_scenegraph_id, nil, optional_ui_scenegraph)
		local widget_pos = Vector2(widget_world_position[1], widget_world_position[2])
		local widget_height, widget_width = self:_scenegraph_size(widget_scenegraph_id, optional_ui_scenegraph)
		local widget_size = Vector3(widget_height, widget_width, 0)
		local widget_center = widget_pos + 0.5 * widget_size
		local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center_position)
		local dot = math.max(1e-06, Vector3.dot(normalized_gamepad_cursor_average_vel, delta_dir))
		local score = math.sqrt(dot) / math.max(1, delta_len)

		if is_sticky then
			if is_selected then
				score = score + 10 * math.max(0, settings.selected_stickiness_radius - delta_len * delta_len)
			else
				score = score + 10 * math.max(0, settings.stickiness_radius - delta_len * delta_len)
			end
		end

		local has_overlap = math.box_overlap_box(widget_pos, widget_size, cursor_pos, cursor_size)

		return has_overlap, score, widget_size, widget_center
	end
end

TalentBuilderView._update_gamepad_cursor = function (self, dt, t, input_service)
	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_cursor = self._widgets_by_name.gamepad_cursor
	local cursor_active = last_pressed_device and last_pressed_device:type() ~= "mouse"

	gamepad_cursor.visible = cursor_active

	local screen_height = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale

	if cursor_active then
		local input = input_service:get("navigation_keys_virtual_axis") + input_service:get("navigate_controller")

		input[2] = -input[2]

		local input_len = Vector3.length(input)

		if input_len > 1 then
			input = input / input_len
			input_len = 1
		end

		local settings = TalentBuilderViewSettings.gamepad_cursor_settings
		local gamepad_cursor_previous_scroll_height = self._gamepad_cursor_previous_scroll_height or 0
		local pos = Vector3Box.unbox(self._gamepad_cursor_current_pos)
		local vel = Vector3Box.unbox(self._gamepad_cursor_current_vel)
		local gamepad_cursor_average_vel = Vector3Box.unbox(self._gamepad_cursor_average_vel)
		local gamepad_cursor_target_pos = Vector3Box.unbox(self._gamepad_cursor_target_pos)

		pos[2] = pos[2] + gamepad_cursor_previous_scroll_height

		local normalized_gamepad_cursor_average_vel, len_gamepad_cursor_average_vel = Vector3.direction_length(gamepad_cursor_average_vel)
		local allow_new_selection = not self._is_scrolling
		local allow_background_scroll = false

		if input_len > settings.snap_input_length_threshold then
			allow_background_scroll = true
			allow_new_selection = false
			self._gamepad_cursor_snap_delay = math.max(self._gamepad_cursor_snap_delay, t + settings.snap_delay)
			self._tooltip_alpha_multiplier = 0
			self._tooltip_draw_delay = TalentBuilderViewSettings.tooltip_fade_delay
		elseif t > self._gamepad_cursor_snap_delay then
			pos = Vector3.lerp(gamepad_cursor_target_pos, pos, settings.snap_movement_rate^dt)
		end

		local drag_coefficient = 1
		local scenegraph = self._ui_scenegraph
		local cursor_size = Vector3.from_array_flat(scenegraph.gamepad_cursor.size)
		local wanted_size = Vector2(settings.default_size_x, settings.default_size_y)

		pos = pos + vel * dt
		vel = vel * settings.cursor_friction_coefficient^dt + settings.cursor_acceleration * drag_coefficient * dt * input

		if Vector3.length_squared(vel) < settings.cursor_minimum_speed then
			Vector3.set_xyz(vel, 0, 0, 0)
		end

		gamepad_cursor_average_vel = math.lerp(gamepad_cursor_average_vel, vel, settings.average_speed_smoothing^dt)

		local zoom_scale = self._current_zoom or 1
		local inverse_zoom_scale = 1 / zoom_scale
		local bounds_min_x = settings.bounds_min_x * inverse_zoom_scale
		local bounds_max_x = settings.bounds_max_x * inverse_zoom_scale
		local edge_margin_top = settings.edge_margin_top
		local edge_margin_bottom = settings.edge_margin_bottom
		local bounds_max_y = screen_height * inverse_scale - edge_margin_bottom

		pos[1] = math.clamp(pos[1], bounds_min_x, bounds_max_x)

		if bounds_max_y < pos[2] then
			if allow_background_scroll then
				self:_on_input_scroll_axis_changed(-0.5)
			end
		elseif edge_margin_top > pos[2] and allow_background_scroll then
			self:_on_input_scroll_axis_changed(0.5)
		end

		pos[2] = math.clamp(pos[2], edge_margin_top, bounds_max_y)

		do
			local best_pos
			local best_score = -math.huge
			local best_widget
			local is_sticky = len_gamepad_cursor_average_vel < settings.stickiness_speed_threshold
			local cursor_center = pos
			local cursor_pos = cursor_center - 0.5 * cursor_size
			local node_widgets = self._node_widgets

			for i = 1, #node_widgets do
				local widget = node_widgets[i]
				local node_data = widget.content.node_data
				local type = node_data.type

				if type ~= "start" then
					local is_selected = i == self._selected_node_index
					local has_overlap, score, widget_size, widget_center = process_gamepad_cursor_widget_func(self, widget, cursor_size, is_sticky, is_selected, pos, normalized_gamepad_cursor_average_vel)
					local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center)

					if has_overlap then
						drag_coefficient = settings.widget_drag_coefficient

						if delta_len < settings.stickiness_radius then
							wanted_size = widget_size
							score = score + 1000
						end
					end

					if best_score < score then
						best_score = score
						best_pos = widget_center
						best_widget = widget
					end
				end
			end

			local is_base_widget = false
			local ui_overlay_scenegraph = self._ui_overlay_scenegraph
			local widgets_by_name = self._widgets_by_name

			for i = 1, #loadout_ability_widget_name_list do
				local widget_name = loadout_ability_widget_name_list[i]
				local widget = widgets_by_name[widget_name]

				if widget then
					local is_selected = i == self._selected_node_index
					local has_overlap, score, widget_size, widget_center = process_gamepad_cursor_widget_func(self, widget, cursor_size, is_sticky, is_selected, pos, normalized_gamepad_cursor_average_vel, ui_overlay_scenegraph)
					local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center)

					if has_overlap then
						drag_coefficient = settings.widget_drag_coefficient

						if delta_len < settings.stickiness_radius then
							wanted_size = widget_size
							score = score + 1000
						end
					end

					if best_score < score then
						best_score = score
						best_pos = widget_center
						best_widget = widget
						is_base_widget = true
					end
				end
			end

			self._gamepad_selected_base_widget = is_base_widget and allow_new_selection and best_widget or nil

			if len_gamepad_cursor_average_vel > settings.snap_selection_speed_threshold and best_pos then
				Vector3Box.store(self._gamepad_cursor_target_pos, best_pos)

				if allow_new_selection and best_widget and self._selected_node ~= best_widget.content.node_data then
					self:_set_selected_node(best_widget.content.node_data)
				end
			end
		end

		local x, y = Vector3.to_elements(pos)

		self:_set_scenegraph_position("gamepad_cursor_pivot", x, y)

		local width, height = Vector3.to_elements(math.lerp(wanted_size, cursor_size, settings.size_resize_rate^dt))
		local max_side = math.max(width, height)

		self:_set_scenegraph_size("gamepad_cursor", max_side, max_side)

		local alpha = 255 * (1 - math.clamp(t - self._gamepad_cursor_snap_delay, 0, 1))

		gamepad_cursor.style.glow.color[1] = alpha
		pos[2] = pos[2] - self._gamepad_cursor_previous_scroll_height

		Vector3Box.store(self._gamepad_cursor_current_pos, pos)
		Vector3Box.store(self._gamepad_cursor_current_vel, vel)
		Vector3Box.store(self._gamepad_cursor_average_vel, gamepad_cursor_average_vel)

		self._gamepad_cursor_previous_scroll_height = self:_background_scrolled_amount()
	end
end

TalentBuilderView.apply_active_background_size = function (self)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local background_width, background_height = self:_background_size()

	self:_set_scenegraph_size(scenegraph_id, background_width, background_height)
	self:_set_scenegraph_size("scroll_background", background_width, background_height, self._ui_overlay_scenegraph)
	self:_force_update_scenegraph()
end

TalentBuilderView._on_navigation_input_changed = function (self)
	TalentBuilderView.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		self._gamepad_selected_base_widget = nil

		if self._selected_node ~= nil then
			self:_set_selected_node(nil)
		end

		self._widgets_by_name.gamepad_cursor.visible = false
	end

	self:_update_summery_button_text()
	self:_update_tutorial_button_texts()
end

TalentBuilderView._set_selected_node = function (self, node)
	local index
	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local content = node_widget.content

		if content.node_data == node then
			index = i

			break
		end
	end

	local privous_selected_node = self._selected_node

	self._selected_node = node
	self._selected_node_index = index

	if node then
		local instant_tooltip = privous_selected_node == node

		self:_setup_tooltip_info(node, instant_tooltip)
	end
end

TalentBuilderView._node_on_hovered = function (self, node)
	self:_play_sound(UISoundEvents.talent_node_hover_default)
end

TalentBuilderView._play_select_sound_for_node_widget = function (self, widget)
	local already_spent_node_points = self:_node_points_by_widget(widget)

	if already_spent_node_points > 1 then
		self:_play_sound(UISoundEvents.talent_node_add_point)
	else
		local content = widget.content
		local node_data = content.node_data
		local node_type = node_data.type

		if node_type == "ability" then
			self:_play_sound(UISoundEvents.talent_node_select_ability)
		elseif node_type == "aura" then
			self:_play_sound(UISoundEvents.talent_node_select_aura)
		elseif node_type == "keystone" then
			self:_play_sound(UISoundEvents.talent_node_select_keystone)
		elseif node_type == "stat" then
			self:_play_sound(UISoundEvents.talent_node_select_stat)
		elseif node_type == "tactical" then
			self:_play_sound(UISoundEvents.talent_node_select_tactical)
		else
			self:_play_sound(UISoundEvents.talent_node_select_default)
		end
	end
end

TalentBuilderView._on_node_widget_left_pressed = function (self, widget)
	if self._is_readonly or not self._is_own_player then
		return
	end

	local node_data = widget.content.node_data
	local type = node_data.type

	if type == "start" then
		return
	end

	local success = TalentBuilderView.super._on_node_widget_left_pressed(self, widget)

	if success then
		self:_play_sound(UISoundEvents.talent_node_click)
	end
end

TalentBuilderView._on_node_widget_right_pressed = function (self, widget)
	if self._is_readonly or not self._is_own_player then
		return
	end

	local node_data = widget.content.node_data
	local type = node_data.type

	if type == "start" then
		return
	end

	local success = TalentBuilderView.super._on_node_widget_right_pressed(self, widget)

	if success then
		self:_play_sound(UISoundEvents.talent_node_clear)
	end
end

TalentBuilderView._get_relative_path = function (self)
	local path = debug.getinfo(1, "S").source:sub(2)

	return path:match("(.*/)")
end

TalentBuilderView._max_node_points = function (self)
	if self._player_mode then
		local player = self._preview_player
		local profile = player:profile()

		return profile.talent_points
	else
		return TalentBuilderView.super._max_node_points(self)
	end
end

TalentBuilderView.clear_chosen_talents = function (self)
	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local node = self:active_layout_node_by_name(node_widget.name)

		node.talent = "not_selected"
	end
end

TalentBuilderView._set_node_points_spent_text = function (self, widget, points_spent, max_points)
	TalentBuilderView.super._set_node_points_spent_text(self, widget, points_spent, max_points)

	local style = widget.style
	local text_style = style.text

	if text_style then
		local node_text_colors = TalentBuilderViewSettings.node_text_colors
		local color

		if not points_spent or points_spent == 0 then
			color = node_text_colors.default
		elseif points_spent == max_points then
			color = node_text_colors.maxed_out
		else
			color = node_text_colors.chosen
		end

		local ignore_alpha = true

		Colors.color_copy(color, text_style.text_color, ignore_alpha)
	end
end

TalentBuilderView._update_node_widgets_blocked_symbol_state = function (self)
	local hovered_node_widget = self._hovered_node_widget
	local hovered_node_name = hovered_node_widget and hovered_node_widget.name
	local hovered_node = self._selected_node or hovered_node_name and self:active_layout_node_by_name(hovered_node_name)
	local exclusive_group = hovered_node and hovered_node.requirements.exclusive_group
	local exclusive_group_node_names = exclusive_group and exclusive_group ~= "" and self:_nodes_in_exclusive_group(exclusive_group)
	local hovered_incompatible_talent = hovered_node and hovered_node.requirements.incompatible_talent
	local hovered_node_talent = hovered_node and hovered_node.talent
	local hovered_node_is_incompatible_node = hovered_node_talent and self._incompatible_talents[hovered_node_talent]
	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local is_blocked = false
		local draw_blocked_highlight = false
		local node_name = node_widget.name
		local node = self:active_layout_node_by_name(node_name)
		local node_exclusive_group = node.requirements.exclusive_group

		if node_exclusive_group and node_exclusive_group ~= "" then
			local active_exclusive_group_node_name = self:_points_spent_on_node_in_exclusive_group(node_exclusive_group)
			local always_show = active_exclusive_group_node_name and active_exclusive_group_node_name ~= node_name
			local hovering_exclusive_node = node ~= hovered_node and exclusive_group_node_names and table.find(exclusive_group_node_names, node)

			is_blocked = always_show or hovering_exclusive_node and true or false
			draw_blocked_highlight = is_blocked and (hovering_exclusive_node or not always_show)
			node_widget.style.blocked.material_values.saturation = is_blocked and always_show and not hovering_exclusive_node and 0.6 or 1
		end

		local node_talent = node.talent
		local node_incompatible = self._incompatible_talents[node_talent]

		if node_incompatible then
			local hovered_node_is_incompatible = hovered_incompatible_talent and node.talent == hovered_incompatible_talent
			local incompatible_node_is_selected = self:_node_incompatible_with_talent_is_selected(node_talent)
			local should_be_blocked = incompatible_node_is_selected or hovered_node_is_incompatible

			if should_be_blocked then
				is_blocked = true
			end

			draw_blocked_highlight = is_blocked and hovered_node_is_incompatible
			node_widget.style.blocked.material_values.saturation = is_blocked and 0.6 or 1
		end

		local incompatible_talent = node.requirements.incompatible_talent

		if incompatible_talent and incompatible_talent ~= "" then
			local hovered_node_is_incompatible = hovered_node_is_incompatible_node and node.requirements.incompatible_talent == hovered_node_talent
			local incompatible_node_is_selected = self:_node_with_incompatible_talent_is_selected(incompatible_talent)
			local should_be_blocked = hovered_node_is_incompatible or incompatible_node_is_selected

			if should_be_blocked then
				is_blocked = true
			end

			draw_blocked_highlight = is_blocked and hovered_node_is_incompatible
			node_widget.style.blocked.material_values.saturation = is_blocked and 0.6 or 1
		end

		node_widget.content.is_blocked = is_blocked
		node_widget.content.draw_blocked_highlight = draw_blocked_highlight
	end
end

TalentBuilderView._update_button_statuses = function (self, dt, t)
	TalentBuilderView.super._update_button_statuses(self, dt, t)

	local widgets_by_name = self._widgets_by_name
	local handling_popup_window = self:_is_handling_popup_window()
	local input_blocked = self._input_blocked
	local draw_tooltip = (self._can_draw_tooltip or self._selected_node_index ~= nil) and not handling_popup_window and not input_blocked

	widgets_by_name.tooltip.content.visible = draw_tooltip
	widgets_by_name.tooltip.alpha_multiplier = draw_tooltip and (self._tooltip_alpha_multiplier or 0) or 0

	if draw_tooltip then
		if not self._tooltip_draw_delay or self._tooltip_draw_delay < 0 then
			local tooltip_fade_speed = TalentBuilderViewSettings.tooltip_fade_speed

			self._tooltip_alpha_multiplier = math.clamp((self._tooltip_alpha_multiplier or 0) + dt * tooltip_fade_speed, 0, 1)
		else
			self._tooltip_draw_delay = self._tooltip_draw_delay - dt
		end
	end

	widgets_by_name.summary_button.content.hotspot.disabled = handling_popup_window or input_blocked
	widgets_by_name.loadout_slot_aura.content.hotspot.disabled = handling_popup_window or input_blocked
	widgets_by_name.loadout_slot_ability.content.hotspot.disabled = handling_popup_window or input_blocked
	widgets_by_name.loadout_slot_tactical.content.hotspot.disabled = handling_popup_window or input_blocked
end

TalentBuilderView._is_handling_popup_window = function (self)
	return (self._summary_grid or self._tutorial_grid) and true or false
end

TalentBuilderView._on_node_hover_enter = function (self, node)
	self:_setup_tooltip_info(node)
end

local dummy_tooltip_text_size = {
	400,
	20,
}

TalentBuilderView._setup_tooltip_info = function (self, node, instant_tooltip, is_base_talent_tooltip)
	local active_layout = self:get_active_layout()

	if not active_layout then
		return
	end

	self._tooltip_alpha_multiplier = instant_tooltip and self._tooltip_alpha_multiplier or 0
	self._tooltip_draw_delay = instant_tooltip and self._tooltip_draw_delay or self._using_cursor_navigation and 0 or TalentBuilderViewSettings.tooltip_fade_delay

	local can_always_afford = is_base_talent_tooltip
	local node_status = self:_node_availability_status(node, can_always_afford)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.tooltip
	local content = widget.content
	local style = widget.style

	content.title = node.widget_name or ""
	content.description = "n/a"

	local talent_name = node.talent
	local talent = type(node.talent) == "table" and node.talent

	if talent or talent_name and talent_name ~= "not_selected" then
		local archetype_name = active_layout.archetype_name
		local archetype = archetype_name and Archetypes[archetype_name]

		if not talent and archetype then
			talent = archetype.talents[talent_name]
		end

		local is_locked = node_status == NodeBuilderViewBase.NODE_STATUS.locked

		if talent then
			local max_points = node.max_points or 0
			local points_spent = is_base_talent_tooltip and 1 or self._points_spent_on_node_widgets[node.widget_name] or 0
			local text_vertical_offset = 14

			content.level_counter = is_locked and " " .. Localize("loc_talent_mechanic_locked") or ""

			local level_counter_height = self:_get_text_height(content.level_counter, style.level_counter, dummy_tooltip_text_size)

			style.level_counter.offset[2] = text_vertical_offset
			style.level_counter.size[2] = level_counter_height

			local node_type = node.type
			local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[node_type]

			if settings_by_node_type then
				content.talent_type_title = settings_by_node_type.display_name and Localize(settings_by_node_type.display_name) or ""
			end

			local talent_type_title_height = self:_get_text_height(content.talent_type_title, style.talent_type_title, dummy_tooltip_text_size)

			style.talent_type_title.offset[2] = text_vertical_offset
			style.talent_type_title.size[2] = talent_type_title_height
			text_vertical_offset = text_vertical_offset + talent_type_title_height

			local description = TalentLayoutParser.talent_description(talent, points_spent, Color.ui_terminal(255, true))
			local localized_title = self:_localize(talent.display_name)

			content.title = localized_title or ""
			content.description = description or ""

			local widget_width, _ = self:_scenegraph_size(widget.scenegraph_id, self._ui_overlay_scenegraph)
			local text_size_addition = style.title.size_addition

			dummy_tooltip_text_size[1] = widget_width + text_size_addition[1]

			local title_height = self:_get_text_height(content.title, style.title, dummy_tooltip_text_size)

			style.title.offset[2] = text_vertical_offset
			style.title.size[2] = title_height
			text_vertical_offset = text_vertical_offset + title_height + 10

			local description_height = self:_get_text_height(content.description, style.description, dummy_tooltip_text_size)

			style.description.offset[2] = text_vertical_offset
			style.description.size[2] = description_height
			text_vertical_offset = text_vertical_offset + description_height

			local present_next_level_text = points_spent > 0 and points_spent < max_points

			if present_next_level_text then
				local next_level_title = Text.apply_color_to_text(Localize("loc_talent_mechanic_next_level"), Color.terminal_text_body_sub_header(255, true))
				local next_level_description = TalentLayoutParser.talent_description(talent, points_spent + 1, Color.ui_terminal_dark(255, true))

				content.next_level_title = next_level_title
				content.next_level_description = next_level_description
				text_vertical_offset = text_vertical_offset + 20

				local next_level_title_height = self:_get_text_height(content.next_level_title, style.next_level_title, dummy_tooltip_text_size)

				style.next_level_title.offset[2] = text_vertical_offset
				style.next_level_title.size[2] = next_level_title_height
				text_vertical_offset = text_vertical_offset + next_level_title_height

				local next_level_description_height = self:_get_text_height(content.next_level_description, style.next_level_description, dummy_tooltip_text_size)

				style.next_level_description.offset[2] = text_vertical_offset
				style.next_level_description.size[2] = next_level_description_height
				text_vertical_offset = text_vertical_offset + next_level_description_height
			else
				content.next_level_title = ""
				content.next_level_description = ""
			end

			content.exculsive_group_description = ""

			local requirements = node.requirements

			if requirements and requirements.exclusive_group and requirements.exclusive_group ~= "" then
				local loc_key = settings_by_node_type.mutually_exclusive_tooltip_string or "loc_talent_mechanic_mutually_exclusive"

				text_vertical_offset = text_vertical_offset + 20
				content.exculsive_group_description = Text.apply_color_to_text(Localize(loc_key), Color.ui_terminal(255, true))

				local exculsive_group_description_height = self:_get_text_height(content.exculsive_group_description, style.exculsive_group_description, dummy_tooltip_text_size)

				style.exculsive_group_description.offset[2] = text_vertical_offset
				style.exculsive_group_description.size[2] = exculsive_group_description_height
				text_vertical_offset = text_vertical_offset + exculsive_group_description_height
			end

			local requirement_added = false
			local clear_requirement_info = true

			if node_status == NodeBuilderViewBase.NODE_STATUS.locked and requirements then
				local requirement_text_height = 0
				local node_points_spent = self._node_points_spent or 0
				local requirement_description = ""

				if requirements.min_points_spent and requirements.min_points_spent > 0 then
					if requirements.min_points_spent_in_group then
						if requirement_added then
							requirement_description = requirement_description .. "\n"
						end

						requirement_description = requirement_description .. Localize("loc_talent_mechanic_group_unlock", true, {
							total_points = Text.apply_color_to_text(tostring(requirements.min_points_spent), Color.terminal_text_header(255, true)),
							group_talents_amount = Text.apply_color_to_text(tostring(self:_points_spent_in_group(requirements.min_points_spent_in_group)), Color.terminal_text_header(255, true)),
						})
						requirement_added = true
					else
						if requirement_added then
							requirement_description = requirement_description .. "\n"
						end

						requirement_description = requirement_description .. Localize("loc_talent_mechanic_min_unlock_child", true, {
							total_points = Text.apply_color_to_text(tostring(requirements.min_points_spent), Color.terminal_text_header(255, true)),
							points_left = Text.apply_color_to_text(tostring(requirements.min_points_spent - node_points_spent), Color.terminal_text_header(255, true)),
						})
						requirement_added = true
					end
				end

				if requirement_added then
					clear_requirement_info = false
					text_vertical_offset = text_vertical_offset + 20
					style.requirement_background.offset[2] = text_vertical_offset

					local requirement_description_height_margin = 15

					text_vertical_offset = text_vertical_offset + requirement_description_height_margin
					content.requirement_title = Localize("loc_talent_mechanic_unlock_requirement")

					local requirement_title_height = self:_get_text_height(content.requirement_title, style.requirement_title, dummy_tooltip_text_size)

					style.requirement_title.offset[2] = text_vertical_offset
					style.requirement_title.size[2] = requirement_title_height
					text_vertical_offset = text_vertical_offset + requirement_title_height + 4
					requirement_text_height = requirement_text_height + requirement_title_height + 4
					content.requirement_description = requirement_description
					dummy_tooltip_text_size[1] = widget_width + style.requirement_description.size_addition[1]

					local requirement_description_height = self:_get_text_height(content.requirement_description, style.requirement_description, dummy_tooltip_text_size)

					style.requirement_description.offset[2] = text_vertical_offset
					style.requirement_description.size[2] = requirement_description_height
					text_vertical_offset = text_vertical_offset + requirement_description_height
					requirement_text_height = requirement_text_height + requirement_description_height
					style.requirement_background.size[2] = requirement_text_height + requirement_description_height_margin * 2
					text_vertical_offset = text_vertical_offset + requirement_description_height_margin
				end
			end

			local show_input_info = self._is_own_player and not self._is_readonly and not is_locked and not is_base_talent_tooltip

			if show_input_info then
				if not requirement_added then
					text_vertical_offset = text_vertical_offset + 20
				end

				style.input_background.offset[2] = text_vertical_offset

				local input_text_height_margin = 10

				text_vertical_offset = text_vertical_offset + input_text_height_margin

				local using_cursor_navigation = self._using_cursor_navigation
				local input_text = ""

				if points_spent ~= max_points then
					if present_next_level_text then
						input_text = Text.localize_with_button_hint(using_cursor_navigation and "left_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_next_level", nil, nil, Localize("loc_input_legend_text_template"))
					else
						input_text = Text.localize_with_button_hint(using_cursor_navigation and "left_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_first_level", nil, nil, Localize("loc_input_legend_text_template"))
					end

					input_text = input_text .. "  "
				end

				if points_spent > 1 then
					input_text = input_text .. Text.localize_with_button_hint(using_cursor_navigation and "right_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_remove_level", nil, nil, Localize("loc_input_legend_text_template"))
				elseif points_spent > 0 then
					input_text = input_text .. Text.localize_with_button_hint(using_cursor_navigation and "right_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_remove_level_first", nil, nil, Localize("loc_input_legend_text_template"))
				end

				local input_text_style_color = style.input_text.text_color

				if points_spent > 0 then
					if self:_can_remove_point_in_node(node) then
						input_text_style_color[1] = 255
					else
						input_text_style_color[1] = 100
					end
				else
					input_text_style_color[1] = 255
				end

				content.input_text = input_text

				local input_text_height = self:_get_text_height(content.input_text, style.input_text, dummy_tooltip_text_size)

				style.input_text.offset[2] = text_vertical_offset
				style.input_text.size[2] = input_text_height
				text_vertical_offset = text_vertical_offset + input_text_height
				style.input_background.size[2] = input_text_height + input_text_height_margin * 2
				text_vertical_offset = text_vertical_offset + input_text_height_margin
			else
				content.input_text = ""
				style.input_background.size[2] = 0
				text_vertical_offset = text_vertical_offset + 20
			end

			if clear_requirement_info then
				content.requirement_title = ""
				content.requirement_description = ""
				style.requirement_background.size[2] = 0
			end

			self:_set_scenegraph_size(widget.scenegraph_id, nil, text_vertical_offset, self._ui_overlay_scenegraph)
		end
	end
end

TalentBuilderView._update_base_talent_loadout_presentation = function (self)
	local player = self._preview_player
	local profile = player and player:profile()
	local active_layout = self:get_active_layout()
	local packed_talents = TalentLayoutParser.pack_backend_data(active_layout, self._points_spent_on_node_widgets)
	local selected_nodes = {}

	TalentLayoutParser.unpack_backend_data(active_layout, packed_talents, selected_nodes)
	CharacterSheet.class_loadout(profile, class_loadout, nil, selected_nodes)

	local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type
	local widgets_by_name = self._widgets_by_name

	for i = 1, #loadout_ability_widget_name_list do
		local widget_name = loadout_ability_widget_name_list[i]
		local widget = widgets_by_name[widget_name]
		local widget_style = widget.style
		local widget_content = widget.content
		local style_id = "icon"
		local talent_widget_style = widget_style[style_id]
		local talent_style_material_values = talent_widget_style.material_values
		local loadout_id = base_loadout_presentation_order[i]
		local loadout = class_loadout[loadout_id]
		local node_type = base_loadout_to_type[loadout_id]

		widget_content.talent = loadout.talent
		widget_content.node_type = node_type
		talent_style_material_values.icon = loadout.icon

		local node_gradient_color

		if not node_gradient_color or node_gradient_color == "not_selected" then
			talent_style_material_values.gradient_map = settings_by_node_type[node_type].gradient_map
		else
			talent_style_material_values.gradient_map = node_gradient_color
		end
	end
end

TalentBuilderView._handle_base_talent_loadout_hover = function (self)
	local widgets_by_name = self._widgets_by_name
	local talent_hover_data = self._talent_hover_data
	local hovered_base_talent_widget
	local gamepad_selected_base_widget = self._gamepad_selected_base_widget

	for i = 1, #loadout_ability_widget_name_list do
		local widget_name = loadout_ability_widget_name_list[i]
		local widget = widgets_by_name[widget_name]
		local widget_content = widget.content
		local hotspot_content = widget_content.hotspot

		hotspot_content.force_hover = gamepad_selected_base_widget == widget

		if hotspot_content.is_hover then
			hovered_base_talent_widget = widget

			local talent = widget_content.talent
			local node_type = widget_content.node_type

			talent_hover_data.talent = talent
			talent_hover_data.type = node_type
			self._hovered_slot_talent = talent_hover_data

			break
		end
	end

	if hovered_base_talent_widget ~= self._hovered_base_talent_widget then
		self:_setup_tooltip_info(talent_hover_data, nil, true)
	end

	self._hovered_base_talent_widget = hovered_base_talent_widget
end

TalentBuilderView._update_node_widgets = function (self, dt, t)
	TalentBuilderView.super._update_node_widgets(self, dt, t)

	self._can_draw_tooltip = (self._hovered_node_widget or self._hovered_base_talent_widget) and not self._dragging_background and not self._summary_button_hovered and not self:_is_handling_popup_window() and not self._input_blocked
end

TalentBuilderView._setup_talents_summary_grid = function (self)
	local definitions = self._definitions

	if not self._summary_grid then
		local grid_scenegraph_id = "summary_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 18,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._summary_grid = self:_add_element(ViewElementGrid, "summary_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("summary_grid", self._summary_grid)
		self._summary_grid:set_empty_message("")
	end

	local grid = self._summary_grid
	local layout = {}
	local active_layout = self:get_active_layout()
	local archetype_name = active_layout.archetype_name
	local archetype = archetype_name and Archetypes[archetype_name]

	if archetype then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				500,
				25,
			},
		}

		local points_spent_on_node_widgets = self._points_spent_on_node_widgets
		local nodes_to_present = {}
		local ability_added, blitz_added, aura_added = false, false, false

		for node_name, points_spent in pairs(points_spent_on_node_widgets) do
			if points_spent > 0 then
				local node = self:_node_by_name(node_name)

				if node then
					local talent_name = node.talent
					local talent = archetype.talents[talent_name]

					if talent then
						local node_type = node.type

						nodes_to_present[#nodes_to_present + 1] = {
							widget_name = node.widget_name,
							type = node_type,
							talent = talent,
							icon = node.icon,
						}

						if node_type == "ability" then
							ability_added = true
						elseif node_type == "tactical" then
							blitz_added = true
						elseif node_type == "aura" then
							aura_added = true
						end
					end
				end
			end
		end

		local base_class_loadout = {
			ability = {},
			blitz = {},
			aura = {},
		}
		local player = self._preview_player
		local profile = player and player:profile()

		CharacterSheet.class_loadout(profile, base_class_loadout, true)

		if not ability_added then
			local talent = base_class_loadout.ability.talent

			nodes_to_present[#nodes_to_present + 1] = {
				points_spent = 1,
				type = "ability",
				talent = talent,
				icon = base_class_loadout.ability.icon,
			}
		end

		if not blitz_added then
			local talent = base_class_loadout.blitz.talent

			nodes_to_present[#nodes_to_present + 1] = {
				points_spent = 1,
				type = "tactical",
				talent = talent,
				icon = base_class_loadout.blitz.icon,
			}
		end

		if not aura_added then
			local talent = base_class_loadout.aura.talent

			nodes_to_present[#nodes_to_present + 1] = {
				points_spent = 1,
				type = "aura",
				talent = talent,
				icon = base_class_loadout.aura.icon,
			}
		end

		table.sort(nodes_to_present, function (a, b)
			local a_type = a.type
			local b_type = b.type
			local a_type_settings = a_type and TalentBuilderViewSettings.settings_by_node_type[a_type]
			local b_type_settings = b_type and TalentBuilderViewSettings.settings_by_node_type[b_type]
			local has_same_sort_order = (a_type_settings and a_type_settings.sort_order or math.huge) == (b_type_settings and b_type_settings.sort_order or math.huge)
			local a_talent = a.talent
			local b_talent = b.talent

			if has_same_sort_order and a_talent and b_talent then
				return Localize(a_talent.display_name) < Localize(b_talent.display_name)
			end

			return (a_type_settings and a_type_settings.sort_order or math.huge) < (b_type_settings and b_type_settings.sort_order or math.huge)
		end)

		local presented_node_type_headers = {}

		for index, data in ipairs(nodes_to_present) do
			local widget_name = data.widget_name
			local points_spent = data.points_spent or points_spent_on_node_widgets[widget_name] or 0
			local talent = type(data.talent) == "table" and data.talent

			if not talent then
				local talent_name = data.talent

				talent = talent_name and archetype.talents[talent_name]
			end

			local description, display_name
			local add = false

			if talent then
				display_name = talent.display_name
				description = TalentLayoutParser.talent_description(talent, points_spent, Color.ui_terminal(255, true))
				add = true
			elseif data.base_talent then
				description = data.description
				display_name = data.display_name
				add = true
			end

			if add then
				local node_type = data.type
				local icon = data.icon
				local gradient_map, frame, icon_mask
				local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[node_type]

				if settings_by_node_type then
					local node_gradient_color = data.gradient_color or "not_selected"

					if not node_gradient_color or node_gradient_color == "not_selected" then
						gradient_map = settings_by_node_type.gradient_map
					else
						gradient_map = node_gradient_color
					end

					frame = settings_by_node_type.frame
					icon_mask = settings_by_node_type.icon_mask
				end

				if not presented_node_type_headers[node_type] then
					layout[#layout + 1] = {
						widget_type = "header",
						text = Localize(settings_by_node_type.display_name),
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							500,
							10,
						},
					}
					presented_node_type_headers[node_type] = true
				end

				layout[#layout + 1] = {
					widget_type = "talent_info",
					talent = talent,
					display_name = display_name,
					description = description,
					gradient_map = gradient_map,
					icon = icon,
					frame = frame,
					icon_mask = icon_mask,
					node_type = node_type,
				}

				if node_type ~= "stat" then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							500,
							25,
						},
					}
				end
			end
		end

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				500,
				25,
			},
		}
	end

	grid:present_grid_layout(layout, TalentBuilderViewSummaryBlueprints)
	grid:set_handle_grid_navigation(true)
	self:_play_sound(UISoundEvents.summary_popup_enter)
end

TalentBuilderView._setup_tutorial_grid = function (self)
	local definitions = self._definitions

	if not self._tutorial_grid then
		local grid_scenegraph_id = "tutorial_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 18,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._tutorial_grid = self:_add_element(ViewElementGrid, "tutorial_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("tutorial_grid", self._tutorial_grid)
		self._tutorial_grid:set_empty_message("")
	end

	self._widgets_by_name.tutorial_button_1.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_1_pressed")
	self._widgets_by_name.tutorial_button_2.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_2_pressed")
	self._tutorial_window_open_animation_id = self:_start_animation("tutorial_window_open", self._widgets_by_name, self)

	self:_play_sound(UISoundEvents.tutorial_popup_enter)
end

TalentBuilderView._present_tutorial_popup_page = function (self, page_index)
	local tutorial_popup_pages = TalentBuilderViewSettings.tutorial_popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.tutorial_window.content.page_counter = tostring(page_index) .. "/" .. tostring(#tutorial_popup_pages)
	widgets_by_name.tutorial_window.content.title = Localize(page_content.header)
	widgets_by_name.tutorial_window.content.image = page_content.image

	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}
	layout[#layout + 1] = {
		widget_type = "text",
		text = Localize(page_content.text),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}

	local grid = self._tutorial_grid

	grid:present_grid_layout(layout, TalentBuilderViewTutorialBlueprints)
	grid:set_handle_grid_navigation(true)

	self._active_tutorial_popup_page = page_index

	self:_update_tutorial_button_texts()
end

TalentBuilderView._handle_tutorial_button_gamepad_navigation = function (self, input_service)
	local widgets_by_name = self._widgets_by_name

	if input_service:get("navigate_left_continuous") then
		if not widgets_by_name.tutorial_button_1.content.hotspot.is_selected then
			widgets_by_name.tutorial_button_1.content.hotspot.is_selected = true
			widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false

			self:_play_sound(UISoundEvents.default_mouse_hover)
		end
	elseif input_service:get("navigate_right_continuous") and not widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true

		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

TalentBuilderView._update_tutorial_button_texts = function (self)
	local page_index = self._active_tutorial_popup_page

	if not page_index then
		return
	end

	local tutorial_popup_pages = TalentBuilderViewSettings.tutorial_popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local using_cursor_navigation = self._using_cursor_navigation
	local widgets_by_name = self._widgets_by_name
	local button_1_default_text = page_content.button_1 and Localize(page_content.button_1) or "n/a"
	local button_2_default_text = page_content.button_2 and Localize(page_content.button_2) or "n/a"

	widgets_by_name.tutorial_button_1.content.original_text = button_1_default_text
	widgets_by_name.tutorial_button_2.content.original_text = button_2_default_text

	if using_cursor_navigation then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false
	elseif not widgets_by_name.tutorial_button_1.content.hotspot.is_selected or widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true
	end
end

TalentBuilderView.cb_on_tutorial_button_1_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index > 1 then
		local next_page_index = math.max(current_page_index - 1, 1)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_previous)
	else
		self._close_tutorial_grid_next_frame = true
	end
end

TalentBuilderView.cb_on_tutorial_button_2_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index < #TalentBuilderViewSettings.tutorial_popup_pages then
		local next_page_index = math.min(current_page_index + 1, #TalentBuilderViewSettings.tutorial_popup_pages)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_next)
	else
		self._close_tutorial_grid_next_frame = true
	end
end

TalentBuilderView.on_resolution_modified = function (self, scale)
	TalentBuilderView.super.on_resolution_modified(self, scale)
end

TalentBuilderView._can_drag_background = function (self)
	return not self._hovered_node_widget and not self._hovered_base_talent_widget
end

return TalentBuilderView
