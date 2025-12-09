-- chunkname: @scripts/ui/views/broker_stimm_builder_view/broker_stimm_builder_view.lua

local NodeBuilderViewBase = require("scripts/ui/views/node_builder_view_base/node_builder_view_base")
local Definitions = require("scripts/ui/views/broker_stimm_builder_view/broker_stimm_builder_view_definitions")
local Archetypes = require("scripts/settings/archetype/archetypes")
local Colors = require("scripts/utilities/ui/colors")
local InputDevice = require("scripts/managers/input/input_device")
local NodeLayout = require("scripts/ui/views/node_builder_view_base/utilities/node_layout")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local ProfileUtils = require("scripts/utilities/profile_utils")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local Text = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementTutorialOverlay = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay")
local BrokerStimmBuilderView = class("BrokerStimmBuilderView", "NodeBuilderViewBase")

BrokerStimmBuilderView.init = function (self, settings, context)
	self._context = context
	self._is_readonly = context and context.is_readonly

	local player = context and context.player or self:_player()

	self._preview_player = player
	self._peer_id = self._preview_player:peer_id()
	self._local_player_id = self._preview_player:local_player_id()
	self._is_own_player = self._preview_player == self:_player()

	BrokerStimmBuilderView.super.init(self, Definitions, settings, context)

	self._save_talent_changes = false

	local resolution_scale = RESOLUTION_LOOKUP.scale
	local resolution_width = RESOLUTION_LOOKUP.width

	self._gamepad_cursor_current_pos = Vector3Box(Vector3(resolution_width * 0.5, 200 * resolution_scale, 0))
	self._gamepad_cursor_current_vel = Vector3Box()
	self._gamepad_cursor_target_pos = Vector3Box(Vector3(resolution_width * 0.5, 200 * resolution_scale, 0))
	self._gamepad_cursor_average_vel = Vector3Box()
	self._gamepad_cursor_snap_delay = 0
	self._grid_size = 30
end

BrokerStimmBuilderView.on_enter = function (self)
	if self._player_mode then
		self._definitions.scenegraph_definition.layout_background.horizontal_alignment = "center"
	end

	self._talent_hover_data = {}

	BrokerStimmBuilderView.super.on_enter(self)
	self:_register_event("event_on_profile_preset_changed", "event_on_profile_preset_changed")

	local player = self._preview_player
	local profile = player:profile()
	local active_talents_version = TalentLayoutParser.talents_version(profile)
	local active_layout = self._active_layout
	local nodes = active_layout.nodes
	local profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if self._is_own_player and not self._is_readonly then
		local talents
		local context = self._context
		local profile_preset = profile_preset_id and ProfileUtils.get_profile_preset(profile_preset_id)

		if profile_preset then
			self._active_profile_preset_id = profile_preset_id

			local profile_preset_talents_version = profile_preset.talents_version

			if not TalentLayoutParser.is_same_version(profile_preset_talents_version, active_talents_version) then
				talents = {}
			else
				talents = profile_preset and TalentLayoutParser.filter_layout_talents(profile, "specialization_talent_layout_file_path", context and context.current_profile_equipped_specialization_talents or profile_preset.talents) or {}
			end
		else
			local current_profile_equipped_specialization_talents = context and context.current_profile_equipped_specialization_talents

			if current_profile_equipped_specialization_talents then
				talents = table.clone(current_profile_equipped_specialization_talents)
			else
				talents = {}

				for i = 1, #nodes do
					local node = nodes[i]
					local widget_name = node.widget_name
					local talent_tier = profile.selected_nodes[widget_name]

					if talent_tier then
						talents[widget_name] = talent_tier
					end
				end
			end
		end

		self._node_widget_tiers = table.clone_instance(talents)

		for widget_name, value in pairs(self._node_widget_tiers) do
			local node = self:_node_by_name(widget_name)

			if not node or type(value) ~= "number" then
				self._node_widget_tiers[widget_name] = nil

				if profile_preset_id then
					ProfileUtils.save_talent_node_for_profile_preset(profile_preset_id, widget_name, nil)
				end
			end
		end
	else
		local widget_tiers = self._node_widget_tiers

		for i = 1, #nodes do
			local node = nodes[i]
			local widget_name = node.widget_name
			local tier = profile.selected_nodes[widget_name]

			if tier then
				widget_tiers[widget_name] = tier
			end
		end
	end

	local all_nodes_cost_one = true
	local widgets = self._node_widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local node_selected, _ = self:_node_points_by_widget(widget)

		content.has_points_spent = node_selected
		content.highlighted = not not content.has_points_spent
		content.alpha_anim_progress = content.has_points_spent and 1 or 0

		local node = content.node_data

		if node.type ~= "start" then
			all_nodes_cost_one = all_nodes_cost_one and node.cost == 1
		end
	end

	self._all_nodes_cost_one = all_nodes_cost_one
	self._draw_instant_lines = true

	self:_refresh_all_nodes()

	self._tutorial_overlay = self:_add_element(ViewElementTutorialOverlay, "tutorial_overlay", 200, {})

	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	local show_tutorial_popup = not save_data or not save_data.stimm_tutorial_popup_shown

	if show_tutorial_popup and not self._is_readonly and self._is_own_player then
		self._widgets_by_name.info_banner.style.badge.material_values.effect_progress = 1
		self._save_tutorial_progress = true

		self:cb_on_help_pressed()
	end
end

BrokerStimmBuilderView.event_on_profile_preset_changed = function (self, profile_preset, on_preset_deleted)
	local player = self._preview_player
	local profile = player:profile()
	local active_talents_version = TalentLayoutParser.talents_version(profile)
	local talents_version = profile_preset and profile_preset.talents_version
	local profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local previously_active_profile_preset_id = self._active_profile_preset_id
	local talents

	if previously_active_profile_preset_id and profile_preset then
		if not TalentLayoutParser.is_same_version(talents_version, active_talents_version) then
			talents = {}
		else
			talents = profile_preset and TalentLayoutParser.filter_layout_talents(profile, "specialization_talent_layout_file_path", profile_preset.talents) or {}
		end
	else
		talents = table.clone_instance(self._node_widget_tiers)
		self._save_talent_changes = true
	end

	self._node_widget_tiers = talents and table.clone_instance(talents) or {}

	for key, value in pairs(self._node_widget_tiers) do
		local node = self:_node_by_name(key)

		if not node or type(value) ~= "number" then
			self._node_widget_tiers[key] = nil

			if profile_preset_id then
				ProfileUtils.save_talent_node_for_profile_preset(profile_preset_id, key, nil)
			end
		end
	end

	local widgets = self._node_widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local node_selected, _ = self:_node_points_by_widget(widget)

		content.has_points_spent = node_selected
		content.highlighted = content.has_points_spent
		content.alpha_anim_progress = content.has_points_spent and 1 or 0
	end

	self._draw_instant_lines = true

	self:_set_selected_node(nil)
	self:_refresh_all_nodes()

	self._active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
end

BrokerStimmBuilderView.on_exit = function (self)
	local layout = self:get_active_layout()

	if not layout then
		return
	end

	BrokerStimmBuilderView.super.on_exit(self)
end

BrokerStimmBuilderView._remove_node_point_on_widget = function (self, widget)
	BrokerStimmBuilderView.super._remove_node_point_on_widget(self, widget)
	Managers.event:trigger("event_player_specialization_talent_node_updated", self._node_widget_tiers)

	self._save_talent_changes = true
end

BrokerStimmBuilderView._add_node_point_on_widget = function (self, widget)
	local success = BrokerStimmBuilderView.super._add_node_point_on_widget(self, widget)

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

		Managers.event:trigger("event_player_specialization_talent_node_updated", self._node_widget_tiers)
	end

	return success
end

BrokerStimmBuilderView.cb_on_clear_all_talents_pressed = function (self)
	local context = {
		description_text = "loc_stimm_lab_reset_desc",
		no_exit_sound = true,
		title_text = "loc_stimm_lab_reset_title",
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

BrokerStimmBuilderView.clear_node_points = function (self)
	BrokerStimmBuilderView.super.clear_node_points(self)

	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local widget = node_widgets[i]
		local parent_line_anim_data = widget.content.parent_line_anim_data

		if parent_line_anim_data then
			table.clear(parent_line_anim_data)
		end
	end

	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if active_profile_preset_id then
		ProfileUtils.clear_layout_talent_nodes_for_profile_preset(active_profile_preset_id, self._active_layout)
	end

	Managers.event:trigger("event_player_specialization_talent_node_updated", self._node_widget_tiers)

	self._save_talent_changes = true
end

BrokerStimmBuilderView._setup_node_connection_widget = function (self)
	self._node_connection_widgets = {}
end

BrokerStimmBuilderView._node_connection_widget_by_index = function (self, index)
	local connection_widgets = self._node_connection_widgets

	if not connection_widgets[index] then
		connection_widgets[index] = self:_create_widget("node_connection_" .. index, self._definitions.node_connection_broker_stimm_definition)
	end

	connection_widgets[index].content.visible = true

	return connection_widgets[index]
end

BrokerStimmBuilderView._on_input_scroll_axis_changed = function (self, scroll_value, cursor_position)
	if not self._player_mode then
		BrokerStimmBuilderView.super._on_input_scroll_axis_changed(self, scroll_value, cursor_position)
	end
end

BrokerStimmBuilderView._get_node_definition_by_type = function (self, node_type)
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

BrokerStimmBuilderView._create_node_widget = function (self, node)
	local widget = BrokerStimmBuilderView.super._create_node_widget(self, node)
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

	if node_type == "start" then
		local content = widget.content

		content.icon = "content/ui/materials/frames/talents/circle_center_stimm_frame"
		content.center_texture = "content/ui/materials/frames/talents/stimm_center_globe"
		content.fill_texture = "content/ui/materials/frames/talents/stimm_circular_filled"
		content.center_texture_glass = "content/ui/materials/frames/talents/circular_glass_reflection"
		widget.style.icon.vertical_alignment = "center"
		widget.style.icon.offset[2] = 0
	end

	return widget
end

BrokerStimmBuilderView._update_start_node_color = function (self, lerp_p)
	local start_node_widget = self:start_node()
	local content = start_node_widget.content
	local orig = content.center_texture_original_color or table.shallow_copy(start_node_widget.style.center_texture.material_values.fill_color)

	content.center_texture_lerped_color = content.center_texture_lerped_color or {}
	content.center_texture_original_color = orig
	content.center_texture_disabled_color = content.center_texture_disabled_color or {
		orig[1] * 0.3,
		orig[2] * 0.3,
		orig[3] * 0.3,
		orig[4],
	}

	local from, to = content.center_texture_disabled_color, content.center_texture_original_color

	if self:_points_available() == self:_max_node_points() then
		from, to = to, from
	end

	local lerped_color = content.center_texture_lerped_color

	lerped_color[1] = math.lerp(from[1], to[1], lerp_p)
	lerped_color[2] = math.lerp(from[2], to[2], lerp_p)
	lerped_color[3] = math.lerp(from[3], to[3], lerp_p)
	lerped_color[4] = math.lerp(from[4], to[4], lerp_p)
	start_node_widget.style.center_texture.material_values.fill_color = lerped_color
end

BrokerStimmBuilderView._is_any_of_widgets_line_progress_done = function (self, widget)
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

BrokerStimmBuilderView._draw_layout_node_connections = function (self, dt, t, input_service, ui_renderer, render_settings, layout)
	local is_any_line_progressing_last_frame = self._is_any_line_progressing

	self._is_any_line_progressing = false

	BrokerStimmBuilderView.super._draw_layout_node_connections(self, dt, t, input_service, ui_renderer, render_settings, layout)

	if is_any_line_progressing_last_frame and not self._is_any_line_progressing then
		self:_play_sound(UISoundEvents.talent_node_line_connection_stop)
	elseif not is_any_line_progressing_last_frame and self._is_any_line_progressing then
		self:_play_sound(UISoundEvents.talent_node_line_connection_start)
	end
end

BrokerStimmBuilderView._draw_connection_between_widgets = function (self, ui_renderer, visible, dt, parent_node, child_node, offset_x, offset_y, distance, angle, connection_index)
	local node_connection_widget = self:_node_connection_widget_by_index(connection_index)
	local widgets_by_name = self._widgets_by_name
	local node_widget_tiers = self._node_widget_tiers
	local is_parent_starting_node = table.is_empty(parent_node.parents)
	local parent_node_name = parent_node.widget_name
	local parent_node_widget = widgets_by_name[parent_node_name]
	local parent_node_requirements = parent_node.requirements
	local children_unlock_points = parent_node_requirements and parent_node_requirements.children_unlock_points or 0
	local parent_tier = node_widget_tiers[parent_node_name]
	local points_spent_on_parent = (parent_tier or 0) * parent_node.cost
	local child_status = self:_node_availability_status(child_node) or BrokerStimmBuilderView.NODE_STATUS.available
	local child_node_name = child_node.widget_name
	local child_widget = widgets_by_name[child_node_name]
	local child_unlocked = node_widget_tiers[child_node_name]
	local points_available = self:_points_available()
	local draw_instant_lines = self._draw_instant_lines
	local color_status

	if is_parent_starting_node then
		if parent_node.type ~= "start" and not node_widget_tiers[parent_node_name] then
			color_status = "locked"
		elseif child_unlocked then
			color_status = "chosen"
		elseif points_available > 0 then
			color_status = "unlocked"
		end
	elseif child_status == BrokerStimmBuilderView.NODE_STATUS.locked or child_status == BrokerStimmBuilderView.NODE_STATUS.unavailable or not parent_tier or points_spent_on_parent < children_unlock_points then
		color_status = "locked"
	elseif child_unlocked then
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
		}
	end

	local anim_line_data = parent_line_anim_data[parent_node_name]
	local anim_line_progress = draw_instant_lines and 1 or anim_line_data.progress_fraction or 0
	local progressing = color_status == "chosen" and anim_line_progress ~= 1
	local can_progress = color_status == "unlocked"
	local has_progressed = color_status == "chosen" and anim_line_progress == 1

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
			local line_anim_speed = 250 / distance

			anim_line_data.progress_fraction = draw_instant_lines and 1 or math.clamp(anim_line_progress + dt * line_anim_speed, 0, 1)
		end
	end

	local fill_distance = math.ease_in_out_sine(anim_line_progress)

	self:_apply_node_connection_line_colors(color_status, connection_index)

	local node_connection_style = node_connection_widget.style

	for pass_style_name, pass_style in pairs(node_connection_style) do
		if pass_style_name == "line" then
			pass_style.size[1] = distance
			pass_style.material_values.noise_scale = pass_style.size[1] / pass_style.size[2]
			pass_style.material_values.fill_amount = fill_distance
			pass_style.material_values.scroll_offset = tonumber(Application.make_hash(parent_node_name, child_node_name), 16) % 10000 / 5000

			local _, rnd = math.next_random(tonumber(Application.make_hash(parent_node_name, child_node_name), 16))

			pass_style.material_values.noise_speed = math.lerp(0.8, 1.2, rnd)
		elseif pass_style_name == "line_available" then
			pass_style.size[1] = distance
			pass_style.material_values.noise_scale = pass_style.size[1] / pass_style.size[2]
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
		local tutorial_overlay = self._tutorial_overlay

		if tutorial_overlay:is_active() then
			local render_settings = self._render_settings

			tutorial_overlay:draw_external_widget(node_connection_widget, ui_renderer, render_settings)
		else
			UIWidget.draw(node_connection_widget, ui_renderer)
		end
	end

	if progressing then
		self._is_any_line_progressing = true
	end

	return visible
end

BrokerStimmBuilderView._finalize_node_connections = function (self, num_connections)
	local connection_widgets = self._node_connection_widgets

	for i = num_connections + 1, #connection_widgets do
		connection_widgets[i].content.visible = false
	end
end

BrokerStimmBuilderView._apply_node_connection_anims = function (self, node_connection_widget, parent_node, dt)
	return
end

BrokerStimmBuilderView._apply_node_connection_line_colors = function (self, color_status, index)
	local node_connection_widget = self:_node_connection_widget_by_index(index)
	local alpha = 255

	if color_status == "locked" then
		alpha = 0
	elseif color_status == "unlocked" then
		node_connection_widget.style.line_available.material_values.noise_speed = 0
	end

	local node_connection_style = node_connection_widget.style
	local line_available_color = node_connection_style.line_available.color

	line_available_color[1] = alpha
end

BrokerStimmBuilderView._setup_layouts = function (self)
	local player_mode = self._player_mode

	if player_mode then
		self._layouts[#self._layouts + 1] = self:_get_player_mode_layout()
	end
end

BrokerStimmBuilderView._get_player_mode_layout = function (self)
	local player = self._preview_player
	local profile = player and player:profile()
	local archetype = profile.archetype

	if archetype then
		local specialization_talent_layout_file_path = archetype.specialization_talent_layout_file_path

		if specialization_talent_layout_file_path then
			return require(specialization_talent_layout_file_path)
		end
	end
end

local resolution_modified_key = "modified"

BrokerStimmBuilderView.update = function (self, dt, t, input_service)
	if self._player_mode and self._preview_player and not Managers.player:player(self._peer_id, self._local_player_id) then
		self._preview_player = nil
	end

	if self._player_mode and not self._preview_player then
		return
	end

	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key]

	if resolution_modified then
		self:_on_input_scroll_axis_changed(0, {
			0,
			0,
		})
	end

	if self._tutorial_overlay:is_active() then
		input_service = input_service:null_service()
	elseif self._save_tutorial_progress then
		self._save_tutorial_progress = nil

		local save_manager = Managers.save
		local save_data = save_manager:account_data()

		if save_data and not save_data.stimm_tutorial_popup_shown then
			save_data.stimm_tutorial_popup_shown = true

			save_manager:queue_save()
		end
	end

	local pass_input, pass_draw = BrokerStimmBuilderView.super.update(self, dt, t, input_service)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.specialization_talents_resource.content.text = string.format("%s/%s", self:_points_available(), self:_max_node_points())

	local selected_node = self._selected_node
	local selected_node_widget = selected_node and self._widgets_by_name[selected_node.widget_name]
	local tooltip_node_widget = selected_node_widget or self._can_draw_tooltip and self._hovered_node_widget

	if tooltip_node_widget then
		local current_zoom = self._current_zoom
		local resolution_inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local render_scale = self._render_scale
		local render_inverse_scale = 1 / render_scale
		local ui_overlay_scenegraph = self._ui_overlay_scenegraph
		local is_node_in_overlay_scenegraph = false
		local node_scenegraph_position = self:_scenegraph_world_position(tooltip_node_widget.scenegraph_id, render_scale, is_node_in_overlay_scenegraph and ui_overlay_scenegraph)
		local node_scenegraph_position_x, node_scenegraph_position_y = node_scenegraph_position[1], node_scenegraph_position[2]
		local node_width, node_height = self:_scenegraph_size(tooltip_node_widget.scenegraph_id, is_node_in_overlay_scenegraph and ui_overlay_scenegraph)
		local node_offset_x, node_offset_y = node_width, node_height
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

BrokerStimmBuilderView.draw = function (self, dt, t, input_service, layer)
	if self._player_mode and not self._preview_player then
		return
	end

	local tutorial_overlay = self._tutorial_overlay

	tutorial_overlay:draw_begin(self._ui_renderer)
	BrokerStimmBuilderView.super.draw(self, dt, t, input_service, layer)
	tutorial_overlay:draw_end(self._ui_renderer)

	if self._draw_instant_lines then
		self._draw_instant_lines = false
	end
end

BrokerStimmBuilderView.draw_layout = function (self, dt, t, input_service, layer)
	self:_update_center_progress(dt, t)
	BrokerStimmBuilderView.super.draw_layout(self, dt, t, input_service, layer)
end

BrokerStimmBuilderView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local tutorial_overlay = self._tutorial_overlay
	local tutorial_overlay_active = tutorial_overlay:is_active()
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				if tutorial_overlay_active then
					tutorial_overlay:draw_external_element(element, dt, t, ui_renderer, render_settings, input_service)
				else
					element:draw(dt, t, ui_renderer, render_settings, input_service)
				end
			end
		end
	end
end

BrokerStimmBuilderView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local tutorial_overlay = self._tutorial_overlay
	local tutorial_overlay_active = tutorial_overlay:is_active()
	local widgets = self._widgets
	local num_widgets = #widgets

	for ii = 1, num_widgets do
		local widget = widgets[ii]

		if tutorial_overlay_active then
			tutorial_overlay:draw_external_widget(widget, ui_renderer, render_settings)
		else
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

BrokerStimmBuilderView._draw_node_widgets = function (self, ui_renderer, screen_height, inverse_scale)
	local tutorial_overlay = self._tutorial_overlay
	local tutorial_overlay_active = tutorial_overlay:is_active()
	local render_settings = self._render_settings
	local node_widgets = self._node_widgets

	if node_widgets then
		local num_widgets = #node_widgets

		for i = 1, num_widgets do
			local widget = node_widgets[i]
			local scenegraph_id = widget.scenegraph_id
			local node_widget_world_position = self:_scenegraph_world_position(scenegraph_id)

			if node_widget_world_position[2] < screen_height * inverse_scale then
				if tutorial_overlay_active then
					tutorial_overlay:draw_external_widget(widget, ui_renderer, render_settings)
				else
					UIWidget.draw(widget, ui_renderer)
				end
			end
		end
	end
end

BrokerStimmBuilderView._allowed_node_input = function (self)
	if self:_is_handling_popup_window() or self._input_blocked then
		return false
	end

	return BrokerStimmBuilderView.super._allowed_node_input(self)
end

BrokerStimmBuilderView.can_exit = function (self)
	return not self:_is_handling_popup_window()
end

BrokerStimmBuilderView.block_input = function (self, block)
	self._input_blocked = block
end

BrokerStimmBuilderView._handle_input = function (self, input_service, dt, t)
	local input_blocked = self._input_blocked

	if input_blocked then
		input_service = input_service:null_service()
	end

	BrokerStimmBuilderView.super._handle_input(self, input_service, dt, t)

	if not self:_is_handling_popup_window() and not input_blocked then
		if not self._using_cursor_navigation then
			local selected_node = self._selected_node

			if not self._input_handled_current_frame and selected_node then
				local widget_name = selected_node.widget_name
				local widget = self._widgets_by_name[widget_name]

				if input_service:get("confirm_pressed") then
					local node_widget_tiers = self._node_widget_tiers
					local tier = node_widget_tiers[widget_name]

					if self:_can_remove_point_in_node(selected_node) and tier then
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

BrokerStimmBuilderView._update_gamepad_cursor = function (self, dt, t, input_service)
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
		local pos = Vector3Box.unbox(self._gamepad_cursor_current_pos)
		local vel = Vector3Box.unbox(self._gamepad_cursor_current_vel)
		local gamepad_cursor_average_vel = Vector3Box.unbox(self._gamepad_cursor_average_vel)
		local gamepad_cursor_target_pos = Vector3Box.unbox(self._gamepad_cursor_target_pos)
		local normalized_gamepad_cursor_average_vel, len_gamepad_cursor_average_vel = Vector3.direction_length(gamepad_cursor_average_vel)
		local allow_new_selection = true

		if input_len > settings.snap_input_length_threshold then
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

		Vector3Box.store(self._gamepad_cursor_current_pos, pos)
		Vector3Box.store(self._gamepad_cursor_current_vel, vel)
		Vector3Box.store(self._gamepad_cursor_average_vel, gamepad_cursor_average_vel)
	end
end

BrokerStimmBuilderView._update_center_progress = function (self, dt, t)
	local max_points = self:_max_node_points()
	local available_points = self:_points_available()
	local target_fill = max_points == 0 and 0 or available_points / max_points
	local start_node = self:start_node()
	local content = start_node.content

	content.velocity = content.velocity or 0

	local current_fill = content.current_fill or target_fill
	local diff = target_fill - current_fill

	if diff ~= 0 or not content.current_fill then
		local target_velocity = math.remap(0, 1, 0.01, 10, math.abs(diff)) * math.sign(diff)
		local dt_multiplier = math.abs(target_velocity) < math.abs(content.velocity) and 40 or 2

		content.velocity = math.lerp(content.velocity, target_velocity, dt * dt_multiplier)

		local step = content.velocity * dt

		if math.abs(step) > math.abs(diff) then
			current_fill = target_fill
		else
			current_fill = current_fill + step
		end

		current_fill = math.clamp01(current_fill)
		content.current_fill = current_fill
		start_node.style.center_texture.material_values.fill_amount = math.remap(0, 1, 0.21, 0.76, current_fill)

		local player = self._preview_player

		if player then
			local widgets_by_name = self._widgets_by_name
			local profile = player:profile()

			widgets_by_name.summary_header.content.viscocity_text = string.format("%s%%", math.round((1 - content.current_fill) * 100))

			local syringe_ability = PlayerAbilities.broker_ability_syringe
			local lerp_cooldown = syringe_ability.cooldown
			local temp_profile = self._temp_profile or {}

			self._temp_profile = temp_profile
			temp_profile.selected_nodes = self._node_widget_tiers
			temp_profile.archetype = profile.archetype
			temp_profile.expertise_points = profile.expertise_points

			local cooldown = syringe_ability.cooldown_lerp_func(self._temp_profile, lerp_cooldown.min, lerp_cooldown.max, 1 - current_fill)

			widgets_by_name.summary_header.content.cooldown_text = string.format("%ss", cooldown)
		end
	end

	local outer_fill_anim_time = 1
	local should_have_fill = self:_node_points_spent() > 0

	content.outer_filled = content.outer_filled or should_have_fill and 1 or 0

	local outer_from = should_have_fill and 0 or 1
	local outer_to = outer_from == 1 and 0 or 1

	if content.had_fill ~= should_have_fill or not content.change_outer_fill_t then
		content.had_fill = should_have_fill
		content.change_outer_fill_t = t - math.ilerp(outer_from, outer_to, content.outer_filled) * outer_fill_anim_time
	end

	local outer_progress = math.ease_in_out_quart(math.clamp01((t - content.change_outer_fill_t) / outer_fill_anim_time))
	local outer_fill = math.lerp_clamped(outer_from, outer_to, outer_progress)

	start_node.style.fill_texture.material_values.fill_amount = outer_fill
	content.outer_filled = outer_fill

	local invert = outer_from == 1

	self:_update_start_node_color(invert and 1 - outer_fill or outer_fill)
end

BrokerStimmBuilderView.apply_active_background_size = function (self)
	local widgets_by_name = self._widgets_by_name
	local layout_background_widget = widgets_by_name.layout_background
	local scenegraph_id = layout_background_widget.scenegraph_id
	local background_width, background_height = self:_background_size()

	self:_set_scenegraph_size(scenegraph_id, background_width, background_height)
	self:_set_scenegraph_size("scroll_background", background_width, background_height, self._ui_overlay_scenegraph)
	self:_force_update_scenegraph()
end

BrokerStimmBuilderView._on_navigation_input_changed = function (self)
	BrokerStimmBuilderView.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		if self._selected_node ~= nil then
			self:_set_selected_node(nil)
		end

		self._widgets_by_name.gamepad_cursor.visible = false
	end
end

BrokerStimmBuilderView._set_selected_node = function (self, node)
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

BrokerStimmBuilderView._node_on_hovered = function (self, node)
	self:_play_sound(UISoundEvents.talent_node_hover_default)
end

BrokerStimmBuilderView._play_select_sound_for_node_widget = function (self, widget)
	local content = widget.content
	local node_data = content.node_data
	local start_node = self:start_node()

	if node_data.parents and node_data.parents[1] == start_node.content.node_data.widget_name then
		self:_play_sound(UISoundEvents.stimm_talent_node_select_keystone)
	elseif not node_data.children or table.is_empty(node_data.children) then
		self:_play_sound(UISoundEvents.stimm_talent_node_base_unlock)
	else
		self:_play_sound(UISoundEvents.stimm_talent_node_add_point)
	end
end

BrokerStimmBuilderView._on_node_widget_left_pressed = function (self, widget)
	if self._is_readonly or not self._is_own_player then
		return
	end

	local node_data = widget.content.node_data
	local type = node_data.type

	if type == "start" then
		return
	end

	local success = BrokerStimmBuilderView.super._on_node_widget_left_pressed(self, widget)

	if success then
		self:_play_sound(UISoundEvents.talent_node_click)
	end
end

BrokerStimmBuilderView._on_node_widget_right_pressed = function (self, widget)
	if self._is_readonly or not self._is_own_player then
		return
	end

	local node_data = widget.content.node_data
	local type = node_data.type

	if type == "start" then
		return
	end

	local success = BrokerStimmBuilderView.super._on_node_widget_right_pressed(self, widget)

	if success then
		self:_play_sound(UISoundEvents.talent_node_clear)
	end
end

BrokerStimmBuilderView._get_relative_path = function (self)
	local path = debug.getinfo(1, "S").source:sub(2)

	return path:match("(.*/)")
end

BrokerStimmBuilderView._max_node_points = function (self)
	if self._player_mode then
		local player = self._preview_player
		local profile = player:profile()

		return profile.expertise_points
	else
		return BrokerStimmBuilderView.super._max_node_points(self)
	end
end

BrokerStimmBuilderView.clear_chosen_talents = function (self)
	local node_widgets = self._node_widgets

	for i = 1, #node_widgets do
		local node_widget = node_widgets[i]
		local node = self:active_layout_node_by_name(node_widget.name)

		node.talent = "not_selected"
	end
end

BrokerStimmBuilderView._set_node_points_spent_text = function (self, widget, points_spent, max_points)
	BrokerStimmBuilderView.super._set_node_points_spent_text(self, widget, points_spent, max_points)

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

BrokerStimmBuilderView._update_node_widgets_blocked_symbol_state = function (self)
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

BrokerStimmBuilderView._update_button_statuses = function (self, dt, t)
	BrokerStimmBuilderView.super._update_button_statuses(self, dt, t)

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
end

BrokerStimmBuilderView._is_handling_popup_window = function (self)
	return self._tutorial_overlay and self._tutorial_overlay:is_active()
end

BrokerStimmBuilderView._on_node_hover_enter = function (self, node)
	self:_setup_tooltip_info(node)
end

local dummy_tooltip_text_size = {
	400,
	20,
}

BrokerStimmBuilderView._setup_tooltip_info = function (self, node, instant_tooltip, is_base_talent_tooltip)
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
			local tier = is_base_talent_tooltip and 1 or self._node_widget_tiers[node.widget_name]
			local points_spent = (tier or 0) * node.cost
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

			local description = TalentLayoutParser.talent_description(talent, points_spent or 0, Color.ui_terminal(255, true))
			local localized_title = TalentLayoutParser.talent_title(talent, points_spent or 0, Color.ui_terminal(255, true))

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

			local present_next_level_text = tier and points_spent < max_points and node.cost > 0

			if present_next_level_text then
				local next_level_title = Text.apply_color_to_text(Localize("loc_talent_mechanic_next_level"), Color.terminal_text_body_sub_header(255, true))
				local next_level_description = TalentLayoutParser.talent_description(talent, points_spent + node.cost, Color.ui_terminal_dark(255, true))

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
				local node_points_spent = self:_node_points_spent()
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

			local can_afford = self:_points_available() >= node.cost

			style.input_text.text_color = points_spent < max_points and not can_afford and style.input_text.cant_interact_color or style.input_text.original_text_color

			local show_input_info = self._is_own_player and not self._is_readonly and (not is_locked or not self._all_nodes_cost_one) and not is_base_talent_tooltip

			if show_input_info then
				if not requirement_added then
					text_vertical_offset = text_vertical_offset + 20
				end

				style.input_background.offset[2] = text_vertical_offset

				local input_text_height_margin = 10

				text_vertical_offset = text_vertical_offset + input_text_height_margin

				local display_cost = not self._all_nodes_cost_one
				local using_cursor_navigation = self._using_cursor_navigation
				local any_parent_unlocked = node.parents and table.any(node.parents, function (_, child_name)
					return self._node_widget_tiers[child_name]
				end)
				local input_text = ""

				if not can_afford and points_spent < max_points and display_cost and any_parent_unlocked then
					local c = Color.ui_grey_medium(255, true)

					input_text = Text.localize_with_button_hint(using_cursor_navigation and "left_pressed" or "gamepad_confirm_pressed", "loc_mastery_trait_no_points", nil, nil, Localize("loc_color_value_fomat_key", true, {
						value = "%s",
						r = c[2],
						g = c[3],
						b = c[4],
					}) .. " %s")
					input_text = input_text .. "  "
				else
					if not is_locked and points_spent ~= max_points and node.cost > 0 then
						if present_next_level_text then
							input_text = Text.localize_with_button_hint(using_cursor_navigation and "left_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_next_level", nil, nil, Localize("loc_input_legend_text_template"))
						else
							input_text = Text.localize_with_button_hint(using_cursor_navigation and "left_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_first_level", nil, nil, Localize("loc_input_legend_text_template"))
						end

						input_text = input_text .. "  "
					end

					if points_spent > node.cost then
						input_text = input_text .. Text.localize_with_button_hint(using_cursor_navigation and "right_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_remove_level", nil, nil, Localize("loc_input_legend_text_template"))
					elseif tier then
						input_text = input_text .. Text.localize_with_button_hint(using_cursor_navigation and "right_pressed" or "gamepad_confirm_pressed", "loc_talent_menu_tooltip_button_hint_remove_level_first", nil, nil, Localize("loc_input_legend_text_template"))
					end
				end

				local input_text_style_color = style.input_text.text_color

				if tier then
					if self:_can_remove_point_in_node(node) then
						input_text_style_color[1] = 255
					else
						input_text_style_color[1] = 100
					end
				else
					input_text_style_color[1] = 255
				end

				if display_cost then
					local tc = (can_afford or points_spent == max_points) and Color.text_default(255, true) or Color.ui_grey_medium(255, true)
					local nc = (can_afford or points_spent == max_points) and Color.ui_input_color(255, true) or Color.text_cant_afford(255, true)
					local text_color_args = {
						r = tc[2],
						g = tc[3],
						b = tc[4],
						value = Localize("loc_stimm_lab_cost", true, {
							cost = "",
						}),
					}
					local number_color_args = {
						r = nc[2],
						g = nc[3],
						b = nc[4],
						value = node.cost,
					}

					content.cost_text = Localize("loc_color_value_fomat_key", true, text_color_args) .. Localize("loc_color_value_fomat_key", true, number_color_args)
				else
					content.cost_text = ""
				end

				style.cost_text.offset[2] = text_vertical_offset

				local cost_text_height = self:_get_text_height(content.cost_text, style.input_text, dummy_tooltip_text_size)

				style.cost_text.size[2] = cost_text_height
				content.input_text = input_text
				style.input_text.offset[2] = text_vertical_offset

				local input_text_height = self:_get_text_height(content.input_text, style.input_text, dummy_tooltip_text_size)

				style.input_text.size[2] = input_text_height

				local max_text_height = math.max(input_text_height, cost_text_height)

				text_vertical_offset = text_vertical_offset + max_text_height
				style.input_background.size[2] = max_text_height + input_text_height_margin * 2
				text_vertical_offset = text_vertical_offset + input_text_height_margin
			else
				content.input_text = ""
				content.cost_text = ""
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

BrokerStimmBuilderView._update_node_widgets = function (self, dt, t)
	BrokerStimmBuilderView.super._update_node_widgets(self, dt, t)

	self._can_draw_tooltip = self._hovered_node_widget and not self._dragging_background and not self:_is_handling_popup_window() and not self._input_blocked
end

BrokerStimmBuilderView.tutorial_overlay = function (self)
	return self._tutorial_overlay
end

BrokerStimmBuilderView.cb_on_help_pressed = function (self)
	local tutorial_overlay_data = {}
	local active_layout = self._active_layout
	local nodes = active_layout.nodes
	local connections = self._node_connection_widgets

	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = function ()
			local widgets = {}

			table.append(widgets, table.select_array(nodes, function (_, node)
				return node.widget_name
			end))
			table.append(widgets, table.select_array(connections, function (_, connection)
				return connection.name
			end))

			return widgets
		end,
		elements = {},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 663,
			y = 235,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_stimm_lab_recipe"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_stimm_lab_onboarding_desc_tree"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					25,
				},
			},
		},
	}

	local syringe_ability = PlayerAbilities.broker_ability_syringe
	local lerp_cooldown = syringe_ability.cooldown

	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"summary_header",
			"specialization_talents_resource",
			"info_banner",
		},
		elements = {},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 520,
			y = 355,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_stimm_lab_volume"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_stimm_lab_onboarding_desc_points", true, {
					volume = 5,
					min_duration = lerp_cooldown.min,
					max_duration = lerp_cooldown.max,
				}),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					225,
					25,
				},
			},
		},
	}

	local tutorial_start_delay = 0.5

	self._tutorial_overlay:activate(tutorial_overlay_data, tutorial_start_delay)
end

BrokerStimmBuilderView.cb_on_close_pressed = function (self)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay:is_active() then
		tutorial_overlay:force_close()
	else
		Managers.ui:close_view(self.view_name)
	end
end

BrokerStimmBuilderView.on_resolution_modified = function (self, scale)
	BrokerStimmBuilderView.super.on_resolution_modified(self, scale)
end

BrokerStimmBuilderView._can_drag_background = function (self)
	return not self._hovered_node_widget
end

BrokerStimmBuilderView._node_icon = function (self, node, layout)
	if node.type == "start" then
		return "content/ui/materials/frames/talents/circle_center_stimm_frame"
	elseif not node.icon then
		return NodeLayout.fallback_icon()
	end

	return node.icon
end

return BrokerStimmBuilderView
