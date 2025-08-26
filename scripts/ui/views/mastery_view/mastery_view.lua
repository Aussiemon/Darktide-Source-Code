-- chunkname: @scripts/ui/views/mastery_view/mastery_view.lua

local MasteryViewDefinitions = require("scripts/ui/views/mastery_view/mastery_view_definitions")
local MasteryViewSettings = require("scripts/ui/views/mastery_view/mastery_view_settings")
local InputUtils = require("scripts/managers/input/input_utils")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local MasteryViewBlueprints = require("scripts/ui/views/mastery_view/mastery_view_blueprints")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementTutorialOverlay = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay")
local ViewElementWintrackMastery = require("scripts/ui/view_elements/view_element_wintrack_mastery/view_element_wintrack_mastery")
local PI = math.pi
local TWO_PI = PI * 2
local MAX_RARITY_LEVEL = 4
local TIME_PER_BAR = 2
local DIRECTION = {
	DOWN = "down",
	LEFT = "left",
	RIGHT = "right",
	UP = "up",
}
local MasteryView = class("MasteryView", "BaseView")

MasteryView.init = function (self, settings, context)
	self._mastery = context.mastery
	self._mastery_id = context.mastery.mastery_id
	self._traits = context.traits
	self._milestones = context.milestones
	self._traits_id = context.traits_id
	self._parent = context.parent
	self._weapon_type = context.slot_type and context.slot_type == "slot_secondary" and "ranged" or "melee"
	self._preview_player = context.player or Managers.player:local_player(1)
	self._wintracks_focused = false

	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	MasteryView.super.init(self, MasteryViewDefinitions, settings, context)

	self._pass_input = false
	self._pass_draw = false
	self._allow_close_hotkey = false
	self._is_backend_syncing = true
end

MasteryView.on_enter = function (self)
	MasteryView.super.on_enter(self)
	self:_set_button_callbacks()
	self:_setup_input_legend()
	self:_setup_forward_gui()

	self._loading_widget = self:_create_widget("loading", MasteryViewDefinitions.loading_definitions)
	self._tooltip_widget = self:_create_widget("tooltip_widget", self._definitions.tooltip_widget_definition)

	self:_register_event("event_mastery_overview_updated", "_update_mastery_data")
	self:_check_buttons_visibility()

	self._tutorial_overlay = self:_add_element(ViewElementTutorialOverlay, "tutorial_overlay", 200, {})
	self._initialized = true
end

MasteryView._update_mastery_data = function (self, mastery_id)
	if mastery_id == self._mastery_id then
		self._mastery = self._parent._masteries[self._mastery_id]
		self._traits = self._parent._mastery_traits[self._mastery_id]
	end
end

MasteryView.cb_on_help_pressed = function (self)
	local tutorial_overlay_data = {}

	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"mastery_level",
		},
		elements = {
			self._wintrack_element,
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 140,
			y = 550,
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
				text = Localize("loc_mastery_blessings_tutorial_left_p1_header"),
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
				text = Localize("loc_mastery_blessings_tutorial_left_p1_text"),
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

	local trait_index = 1
	local available_traits_position = MasteryViewSettings.trait_positions
	local traits_grid_pivot_scenegraph = self._ui_scenegraph.traits_grid_pivot
	local traits_grid_position = traits_grid_pivot_scenegraph.position

	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"trait_" .. trait_index,
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			z = 0,
			x = traits_grid_position[1] + available_traits_position[trait_index][1] + 250,
			y = traits_grid_position[2] + available_traits_position[trait_index][2] + 80,
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
				text = Localize("loc_mastery_blessings_tutorial_left_p2_header"),
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
				text = Localize("loc_mastery_blessings_tutorial_left_p2_text"),
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
	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"mastery_unlock_bar",
			"mastery_points",
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 680,
			y = 350,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_mastery_blessings_tutorial_left_p3_header"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_mastery_blessings_tutorial_left_p3_text"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
		},
	}

	local tutorial_start_delay = 0.5

	self._tutorial_overlay:activate(tutorial_overlay_data, tutorial_start_delay)
end

MasteryView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
	end
end

MasteryView._setup_forward_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 110
	local world_name = self._unique_id .. "_ui_forward_world"
	local view_name = self.view_name

	self._forward_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = self._unique_id .. "_ui_forward_world_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1

	self._forward_viewport = ui_manager:create_viewport(self._forward_world, viewport_name, viewport_type, viewport_layer)
	self._forward_viewport_name = viewport_name

	local renderer_name = self._unique_id .. "_forward_renderer"

	self._ui_forward_renderer = ui_manager:create_renderer(renderer_name, self._forward_world)
end

MasteryView.cb_on_close_pressed = function (self)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay and tutorial_overlay:is_active() then
		tutorial_overlay:force_close()
	else
		Managers.ui:close_view(self.view_name)
	end
end

MasteryView._reset_mastery_info = function (self)
	local level = 0
	local exp = 0
	local claimed_level = -1

	self._mastery.mastery_level = level
	self._mastery.claimed_level = claimed_level
	self._mastery.current_xp = exp

	local start_exp, end_exp = Mastery.get_start_and_end_xp(self._mastery)

	self._mastery.start_exp = start_exp
	self._mastery.end_exp = end_exp
	self._mastery.points_total = 0

	self:_setup_mastery_info()
end

MasteryView._setup_mastery_info = function (self)
	local mastery_level = self._mastery.mastery_level

	self._widgets_by_name.header.content.pattern_name = self._mastery.display_name

	if self._weapon_type == "ranged" then
		self._widgets_by_name.header.style.pattern_nameplate.material_values.texture_map = "content/ui/textures/frames/mastery_tree/pattern_nameplate_ranged"
	end

	self._widgets_by_name.mastery_level.content.mastery_level = string.format(" %d", mastery_level)
	self._widgets_by_name.mastery_level.content.visible = true

	local points_total = self._mastery.points_total
	local points_available = self._mastery.points_available

	self._widgets_by_name.mastery_points.content.mastery_points_value = string.format(" %s", points_available)
end

MasteryView.draw = function (self, dt, t, input_service, layer)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay then
		tutorial_overlay:draw_begin(self._ui_renderer)
		tutorial_overlay:draw_begin(self._ui_forward_renderer)

		if self._wintrack_element then
			tutorial_overlay:draw_begin(self._wintrack_element:ui_reward_renderer())
			tutorial_overlay:draw_begin(self._wintrack_element:ui_resource_renderer())
		end
	end

	if tutorial_overlay and tutorial_overlay:is_active() or self._is_backend_syncing then
		input_service = input_service:null_service()
	end

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local ui_forward_renderer = self._ui_forward_renderer

	UIRenderer.begin_pass(self._ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._trait_widgets then
		local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()

		for ii = 1, #self._trait_widgets do
			local widget = self._trait_widgets[ii]

			if tutorial_overlay_active then
				tutorial_overlay:draw_external_widget(widget, self._ui_renderer, render_settings)
			else
				UIWidget.draw(widget, self._ui_renderer)
			end

			if self._node_widgets then
				for jj = 1, #self._node_widgets do
					local node_widget = self._node_widgets[jj]

					UIWidget.draw(node_widget, ui_renderer)
				end
			end
		end
	end

	UIRenderer.end_pass(self._ui_renderer)
	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._tooltip_widget then
		UIWidget.draw(self._tooltip_widget, ui_forward_renderer)
	end

	if self._loading_widget then
		UIWidget.draw(self._loading_widget, ui_forward_renderer)
	end

	UIWidget.draw(self._widgets_by_name.mastery_level, ui_forward_renderer)
	UIRenderer.end_pass(ui_forward_renderer)
	MasteryView.super.draw(self, dt, t, input_service, layer)

	if tutorial_overlay then
		tutorial_overlay:draw_end(self._ui_renderer)
		tutorial_overlay:draw_end(self._ui_forward_renderer)

		if self._wintrack_element then
			tutorial_overlay:draw_end(self._wintrack_element:ui_reward_renderer())
			tutorial_overlay:draw_end(self._wintrack_element:ui_resource_renderer())
		end
	end
end

MasteryView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local tutorial_overlay = self._tutorial_overlay
				local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()

				if tutorial_overlay_active then
					tutorial_overlay:draw_external_element(element, dt, t, ui_renderer, render_settings, input_service)
				else
					element:draw(dt, t, ui_renderer, render_settings, input_service)
				end
			end
		end
	end
end

MasteryView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local tutorial_overlay = self._tutorial_overlay
	local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()
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

MasteryView.on_resolution_modified = function (self, scale)
	MasteryView.super.on_resolution_modified(self, scale)
end

MasteryView._setup_node_widgets = function (self)
	if self._node_widgets then
		for i = 1, #self._node_widgets do
			local widget = self._node_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._node_widgets = nil
	end

	local costs = Mastery.get_trait_costs()
	local traits = self._traits
	local unlocked_rarity_level = self._widgets_by_name.mastery_unlock_bar.content.max_unlocked_rarity
	local points_spent = Mastery.get_spent_points(traits)
	local thresholds = costs.trait_unlock_threshold
	local current_threshold = thresholds[tostring(unlocked_rarity_level)]
	local next_threshold

	if unlocked_rarity_level == MAX_RARITY_LEVEL then
		next_threshold = self._mastery.points_total
	else
		next_threshold = thresholds[tostring(unlocked_rarity_level + 1)]
	end

	if unlocked_rarity_level < MAX_RARITY_LEVEL then
		local rarity_points = next_threshold - current_threshold
		local circ_radius = 102
		local max_angle = TWO_PI
		local portion_angle = max_angle / rarity_points
		local widgets = {}
		local points_to_next_level = next_threshold - points_spent

		for i = 1, rarity_points do
			local position_angle = -(portion_angle * i) + PI
			local offset = {
				math.sin(position_angle) * circ_radius,
				math.cos(position_angle) * circ_radius,
			}
			local widget = self:_create_widget("node_" .. i, MasteryViewDefinitions.node_widgets_definitions)

			widget.style.mastery_unlock_node.offset = {
				offset[1] - 13,
				offset[2] - 13,
				50,
			}
			widgets[#widgets + 1] = widget

			if i > rarity_points - points_to_next_level then
				widget.style.mastery_unlock_node.material_values.tier_icon_intensity = 0
			end
		end

		self._node_widgets = widgets
	end
end

MasteryView.update = function (self, dt, t, input_service)
	if not self._mastery.syncing and self._is_backend_syncing then
		self._is_backend_syncing = false

		if self._loading_widget then
			self._loading_widget.content.visible = false
		end

		self:_setup_mastery_info()
		self:_setup_milestones()
		self:_setup_traits()
	end

	if self._is_backend_syncing then
		if input_service:get("back") then
			self:cb_on_close_pressed()
		else
			input_service = input_service:null_service()
		end
	end

	local handle_input = false
	local wintrack_element = self._wintrack_element

	if wintrack_element then
		local handle_wintrack_input = true

		if self._tutorial_overlay and handle_wintrack_input then
			handle_wintrack_input = not self._tutorial_overlay:is_active()
			handle_input = not self._tutorial_overlay:is_active()
		end

		wintrack_element:set_handle_input(handle_wintrack_input)

		if wintrack_element:is_initialized() and self._claimed_tiers_index then
			for i = 1, self._claimed_tiers_index do
				self._wintrack_element:set_index_claimed(i)
			end

			self._claimed_tiers = nil
		end
	end

	local trait_widgets = self._trait_widgets

	self._hovered_trait_widget = nil
	self._draw_tooltip = false

	if trait_widgets and not self._result_overlay then
		for i = 1, #trait_widgets do
			local widget = trait_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot

			if hotspot and (hotspot.is_hover or hotspot.is_selected) then
				self._hovered_trait_widget = widget
				self._selected_trait_index = i
				self._draw_tooltip = true

				break
			end
		end
	end

	if self._tooltip_widget then
		self:_tooltip_update()
	end

	self:_unlock_progress_animation_update(dt, t)

	local pass_input, pass_draw = MasteryView.super.update(self, dt, t, input_service)

	return handle_input and pass_input, pass_draw
end

MasteryView._unlock_progress_animation_update = function (self, dt, t)
	local animating_progress_bar = false
	local unlocked_rarity_level = self._widgets_by_name.mastery_unlock_bar.content.max_unlocked_rarity

	if self._threshold_animation_id and self:_is_animation_completed(self._threshold_animation_id) then
		self._threshold_animation_id = nil

		local traits = self._traits

		self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.tier_icon_intensity = 1

		if unlocked_rarity_level == MAX_RARITY_LEVEL then
			self._widgets_by_name.mastery_unlock_bar.style.progress_bar.color[1] = 0
		end
	elseif self._stop_next_step then
		self._stop_next_step = nil
		self._progress_per_point = nil
	elseif not self._threshold_animation_id and self._progress_per_point then
		if self._await_nodes_before_transition then
			if not self._animating_nodes then
				self._await_nodes_before_transition = false
				self._threshold_animation_id = self:_start_animation("on_threshold_reached", self._widgets_by_name, {
					traits = self._trait_widgets,
					nodes = self._node_widgets,
					next_rarity = unlocked_rarity_level,
				})
			end
		else
			if table.is_empty(self._progress_per_point) then
				self._stop_next_step = true

				return
			end

			local bar_progress = dt / TIME_PER_BAR

			self._acumulated_point_time = self._acumulated_point_time or 0

			local current_total_point_time = self._progress_per_point[1]
			local removed_point = false

			if current_total_point_time then
				if current_total_point_time <= self._acumulated_point_time + bar_progress then
					bar_progress = current_total_point_time - self._acumulated_point_time
					self._acumulated_point_time = nil

					table.remove(self._progress_per_point, 1)

					removed_point = true
				else
					self._acumulated_point_time = self._acumulated_point_time + bar_progress
				end
			end

			self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress = self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress + bar_progress
			animating_progress_bar = true

			if self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress + 0.05 >= 1 then
				self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress = 1
				self._await_nodes_before_transition = true

				if not removed_point and self._progress_per_point then
					table.remove(self._progress_per_point, 1)
				end

				self._acumulated_point_time = nil
			end
		end
	end

	if self._node_widgets and animating_progress_bar or self._animating_nodes then
		local total_node_progress = 0.5

		self._animating_nodes = false

		local current_bar_progress = self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress
		local nodes_count = #self._node_widgets
		local single_node_progress = 1 / nodes_count
		local nodes_progressed = math.floor(current_bar_progress / single_node_progress + 0.05)

		for i = 1, nodes_progressed do
			local node_widget = self._node_widgets[i]
			local current_intensity = node_widget.style.mastery_unlock_node.material_values.tier_icon_intensity

			if current_intensity < 1 then
				node_widget.style.mastery_unlock_node.material_values.tier_icon_intensity = math.min(node_widget.style.mastery_unlock_node.material_values.tier_icon_intensity + dt, total_node_progress) / total_node_progress
				self._animating_nodes = true
			end
		end
	end
end

MasteryView._tooltip_update = function (self)
	local trait_widget = self._draw_tooltip and self._hovered_trait_widget
	local widgets_by_name = self._widgets_by_name
	local tooltip_widget = self._tooltip_widget

	if trait_widget then
		local element = trait_widget.content.element
		local rarity = element.rarity
		local item = element.item
		local next_rarity = element.next_rarity
		local reached_max_rarity = rarity == next_rarity
		local has_rarity = rarity and rarity > 0
		local height_margin = 20
		local start_offset = 20
		local trait_header_size = 20
		local rarity_content_size = 0

		if has_rarity then
			tooltip_widget.style.rarity_header.offset[2] = start_offset

			local rarity_title_style = tooltip_widget.style.rarity_title
			local rarity_description_style = tooltip_widget.style.rarity_description
			local rarity_title_font_style_options = UIFonts.get_font_options_by_style(rarity_title_style)
			local rarity_description_font_style_options = UIFonts.get_font_options_by_style(rarity_description_style)
			local title_text_size = {
				rarity_title_style.size[1],
				5000,
			}
			local description_text_size = {
				rarity_description_style.size[1],
				5000,
			}
			local rarity_title = Localize(item.display_name)
			local rarity_description = Items.trait_description(item, rarity, math.lerp(1, 4, rarity - 1))

			tooltip_widget.content.rarity_title = rarity_title
			tooltip_widget.content.rarity_description = rarity_description

			local _, rarity_title_height = UIRenderer.text_size(self._ui_renderer, rarity_title, rarity_title_style.font_type, rarity_title_style.font_size, title_text_size, rarity_title_font_style_options)
			local _, rarity_description_height = UIRenderer.text_size(self._ui_renderer, rarity_description, rarity_description_style.font_type, rarity_description_style.font_size, description_text_size, rarity_description_font_style_options)

			rarity_title_style.offset[2] = start_offset + height_margin + trait_header_size
			tooltip_widget.style.rarity_icon.offset[2] = rarity_title_style.offset[2]

			local icon_material_values = tooltip_widget.style.rarity_icon.material_values

			icon_material_values.icon, icon_material_values.frame = Items.trait_textures(item, rarity)
			rarity_description_style.offset[2] = rarity_title_style.offset[2] + rarity_title_height + 5

			local rarity_block_height = math.max(tooltip_widget.style.rarity_icon.size[2], rarity_title_height + 5 + rarity_description_height) + height_margin

			rarity_content_size = rarity_title_style.offset[2] + rarity_block_height
		end

		tooltip_widget.content.warning_message = ""

		if not reached_max_rarity then
			tooltip_widget.style.divider.offset[2] = rarity_content_size

			local next_rarity_title_style = tooltip_widget.style.next_rarity_title
			local next_rarity_description_style = tooltip_widget.style.next_rarity_description
			local next_rarity_title_font_style_options = UIFonts.get_font_options_by_style(next_rarity_title_style)
			local next_rarity_description_font_style_options = UIFonts.get_font_options_by_style(next_rarity_description_style)
			local next_title_text_size = {
				next_rarity_title_style.size[1],
				5000,
			}
			local next_description_text_size = {
				next_rarity_description_style.size[1],
				5000,
			}
			local next_rarity_title = Localize(item.display_name)
			local next_rarity_description = Items.trait_description(item, next_rarity, math.lerp(1, 4, next_rarity))

			tooltip_widget.content.next_rarity_title = next_rarity_title
			tooltip_widget.content.next_rarity_description = next_rarity_description

			local _, next_rarity_title_height = UIRenderer.text_size(self._ui_renderer, next_rarity_title, next_rarity_title_style.font_type, next_rarity_title_style.font_size, next_title_text_size, next_rarity_title_font_style_options)
			local _, next_rarity_description_height = UIRenderer.text_size(self._ui_renderer, next_rarity_description, next_rarity_description_style.font_type, next_rarity_description_style.font_size, next_description_text_size, next_rarity_description_font_style_options)

			tooltip_widget.style.next_rarity_header.offset[2] = rarity_content_size + tooltip_widget.style.divider.size[2]

			local next_trait_start = tooltip_widget.style.next_rarity_header.offset[2] + height_margin

			tooltip_widget.style.next_rarity_header.offset[2] = next_trait_start
			next_rarity_title_style.offset[2] = next_trait_start + height_margin + trait_header_size
			tooltip_widget.style.next_rarity_icon.offset[2] = next_rarity_title_style.offset[2]

			local next_icon_material_values = tooltip_widget.style.next_rarity_icon.material_values

			next_icon_material_values.icon, next_icon_material_values.frame = Items.trait_textures(item, next_rarity)
			next_rarity_description_style.offset[2] = next_rarity_title_style.offset[2] + next_rarity_title_height + 5

			local next_rarity_block_height = math.max(tooltip_widget.style.next_rarity_icon.size[2], next_rarity_title_height + 5 + next_rarity_description_height) + height_margin
			local can_be_acquired, warning_message = self:_can_trait_be_acquired(element)

			tooltip_widget.content.warning_message = warning_message

			local mastery_cost_height = 50

			tooltip_widget.style.mastery_cost.offset[2] = next_rarity_title_style.offset[2] + next_rarity_block_height
			tooltip_widget.style.requirement_background.offset[2] = tooltip_widget.style.mastery_cost.offset[2]
			rarity_content_size = tooltip_widget.style.mastery_cost.offset[2] + mastery_cost_height

			local using_cursor = self._using_cursor_navigation

			if not using_cursor then
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key("confirm_pressed", service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

				tooltip_widget.content.mastery_cost = element.cost and string.format("{#color(226,199,126)}%s{#reset()} %s", input_text, Localize("loc_mastery_trait_cost", true, {
					cost = element.cost,
				})) or ""
			else
				tooltip_widget.content.mastery_cost = element.cost and Localize("loc_mastery_trait_cost", true, {
					cost = element.cost,
				}) or ""
			end

			if not can_be_acquired then
				tooltip_widget.style.warning_message_background.offset[2] = rarity_content_size
				tooltip_widget.style.warning_message.offset[2] = rarity_content_size

				local warning_message_height = 50

				rarity_content_size = rarity_content_size + warning_message_height
			end
		end

		tooltip_widget.content.reached_max_rarity = reached_max_rarity
		tooltip_widget.content.has_rarity = has_rarity

		self:_set_scenegraph_size(tooltip_widget.scenegraph_id, nil, rarity_content_size)

		local resolution_width = RESOLUTION_LOOKUP.width
		local resolution_height = RESOLUTION_LOOKUP.height
		local resolution_inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local trait_scenegraph_position = self:_scenegraph_world_position(trait_widget.scenegraph_id)
		local trait_scenegraph_position_x, trait_scenegraph_position_y = trait_scenegraph_position[1], trait_scenegraph_position[2]
		local trait_offset_x = trait_widget.offset[1] or 0
		local trait_offset_y = trait_widget.offset[2] or 0
		local trait_size_x = trait_widget.content.size[1] or 0
		local trait_size_y = trait_widget.content.size[2] or 0
		local tooltip_scenegraph_position_x, tooltip_scenegraph_position_y, _ = self:_scenegraph_position(tooltip_widget.scenegraph_id)
		local tooltip_width, tooltip_height = self:_scenegraph_size(tooltip_widget.scenegraph_id)
		local tooltip_start_position_x = trait_scenegraph_position_x + trait_offset_x + trait_size_x - 80
		local tooltip_start_position_y = trait_scenegraph_position_y + trait_offset_y + trait_size_y - 20
		local tooltip_offset = tooltip_widget.offset

		tooltip_offset[1] = math.clamp(tooltip_start_position_x, 0, resolution_width * resolution_inverse_scale - tooltip_width - 20)
		tooltip_offset[2] = math.clamp(tooltip_start_position_y, 0, resolution_height * resolution_inverse_scale - tooltip_height - 20)

		math.clamp(tooltip_start_position_x, 0, resolution_width - tooltip_width)

		self._tooltip_widget.content.visible = true
	else
		self._tooltip_widget.content.visible = false
	end
end

MasteryView._destroy_forward_gui = function (self)
	if self._ui_forward_renderer then
		self._ui_forward_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_forward_renderer")

		local world = self._forward_world
		local viewport_name = self._forward_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._forward_viewport_name = nil
		self._forward_world = nil
	end
end

MasteryView.on_exit = function (self)
	self:_destroy_forward_gui()

	if self._purchased_traits then
		Managers.data_service.mastery:purchase_traits(self._mastery_id, self._purchased_traits):next(function (failed_traits)
			for i = 1, #failed_traits do
				local failed_trait = failed_traits[i]
				local rarity = failed_trait.rarity
				local index = failed_trait.index

				self._traits[index].trait_status[rarity] = "unseen"
			end
		end)
	end

	MasteryView.super.on_exit(self)
end

MasteryView._setup_traits = function (self)
	if self._trait_widgets then
		for i = 1, #self._trait_widgets do
			local widget = self._trait_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._trait_widgets = nil
	end

	local traits_layout = {}
	local max_traits = #MasteryViewSettings.trait_positions
	local points_used = 0
	local traits = self._traits

	for ii = 1, #traits do
		local trait = traits[ii]
		local name = trait.trait_name
		local trait_status = trait.trait_status
		local item = MasterItems.get_item(name)

		if item then
			local icon = item and item.icon
			local texture_icon = icon or "content/ui/textures/icons/traits/weapon_trait_default"
			local valid_traits = {}
			local max_unlocked_rarity_index = 0

			for jj = 1, #trait_status do
				local rarity = jj
				local unlocked = trait_status[jj] == "seen"
				local valid = trait_status[jj] ~= "invalid"

				if valid then
					local index = #valid_traits + 1

					max_unlocked_rarity_index = unlocked and max_unlocked_rarity_index < index and index or max_unlocked_rarity_index
					valid_traits[index] = {
						rarity = rarity,
						unlocked = unlocked,
					}
				end

				if unlocked then
					local cost = Mastery.get_trait_cost(rarity)

					points_used = points_used + cost
				end
			end

			if not table.is_empty(valid_traits) then
				local max_unlocked_rarity = max_unlocked_rarity_index > 0 and valid_traits[max_unlocked_rarity_index].rarity or 0
				local next_rarity_index = math.clamp(max_unlocked_rarity_index + 1, 1, #valid_traits)
				local next_rarity = valid_traits[next_rarity_index].rarity
				local cost = Mastery.get_trait_cost(next_rarity)

				traits_layout[#traits_layout + 1] = {
					widget_type = "trait_new",
					texture_icon = texture_icon,
					traits = valid_traits,
					rarity = max_unlocked_rarity,
					next_rarity = next_rarity,
					cost = cost or nil,
					item = item,
					name = name,
					index = ii,
				}
			end
		end
	end

	for ii = #traits_layout, max_traits - 1 do
		traits_layout[#traits_layout + 1] = {
			widget_type = "trait_new_empty",
			index = ii,
		}
	end

	local scenegraph_size = {
		0,
		0,
	}
	local trait_widgets = {}
	local available_traits_position = MasteryViewSettings.trait_positions
	local unlocked_rarity_level = Mastery.get_max_blessing_rarity_unlocked_level_by_points_spent(traits)
	local mastery_unlock_bar_widget = self._widgets_by_name.mastery_unlock_bar
	local max_unlocked_rarity_level = mastery_unlock_bar_widget.content.max_unlocked_rarity

	if max_unlocked_rarity_level then
		if max_unlocked_rarity_level == 3 and unlocked_rarity_level == MAX_RARITY_LEVEL then
			self:_play_sound(UISoundEvents.mastery_traits_rank_up_max)
		elseif max_unlocked_rarity_level < (unlocked_rarity_level or 1) then
			self:_play_sound(UISoundEvents.mastery_traits_rank_up)
		end
	end

	mastery_unlock_bar_widget.content.max_unlocked_rarity = unlocked_rarity_level or 1
	self._widgets_by_name.mastery_unlock_bar.style.progress_bar.color[1] = unlocked_rarity_level == MAX_RARITY_LEVEL and 0 or 255

	local costs = Mastery.get_trait_costs()
	local thresholds = costs.trait_unlock_threshold
	local current_threshold = thresholds[tostring(unlocked_rarity_level)]
	local next_threshold

	if unlocked_rarity_level == MAX_RARITY_LEVEL then
		next_threshold = self._mastery.points_total
	else
		next_threshold = thresholds[tostring(unlocked_rarity_level + 1)]
	end

	local points_spent = Mastery.get_spent_points(traits)

	if self._node_widgets then
		for i = 1, #self._node_widgets do
			local widget = self._node_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._node_widgets = nil
	end

	self:_setup_node_widgets()

	local progress_to_next_level = points_spent < next_threshold and math.ilerp(current_threshold, next_threshold, points_spent) or 1

	self._widgets_by_name.mastery_unlock_bar.style.progress_bar.material_values.progress = progress_to_next_level

	for ii = 1, #traits_layout do
		if ii <= #available_traits_position then
			local trait_layout = traits_layout[ii]
			local trait_blueprint = MasteryViewBlueprints[trait_layout.widget_type]
			local trait_size = trait_blueprint.size
			local trait_width_offset = available_traits_position[ii][1]
			local trait_height_offset = available_traits_position[ii][2]
			local offset = {
				trait_width_offset,
				trait_height_offset,
				1,
			}
			local config = table.clone(trait_layout)

			if config.traits then
				for jj = 1, #config.traits do
					local trait = config.traits[jj]

					trait.available = unlocked_rarity_level >= trait.rarity
				end
			end

			local pass_template = trait_blueprint.pass_template_function and trait_blueprint.pass_template_function(self, config) or trait_blueprint.pass_template
			local definition = UIWidget.create_definition(pass_template, "traits_grid_pivot")
			local name = "trait_" .. ii

			config.widget_name = name

			local widget = self:_create_widget(name, definition)

			if trait_blueprint.init then
				trait_blueprint.init(self, widget, config)
			end

			if widget.content.hotspot then
				widget.content.hotspot.pressed_callback = function ()
					self:_cb_trait_left_pressed(widget, config)
				end
			end

			widget.offset = offset
			widget.content.size = trait_size
			scenegraph_size = {
				math.max(scenegraph_size[1], offset[1] + trait_size[1]),
				math.max(scenegraph_size[2], offset[2] + trait_size[2]),
			}
			trait_widgets[#trait_widgets + 1] = widget
		end
	end

	self:_set_scenegraph_size("traits_grid_pivot", scenegraph_size[1], scenegraph_size[2])

	self._trait_widgets = trait_widgets
end

MasteryView._update_traits = function (self, updated_trait_widget)
	local content = updated_trait_widget.content
	local style = updated_trait_widget.style
	local config = content.element
	local new_rarity = config.next_rarity
	local trait_index

	for i = 1, #config.traits do
		local trait = config.traits[i]

		if trait.rarity == new_rarity then
			trait_index = config.traits[i + 1] and i + 1 or i
		end
	end

	content["rarity_" .. new_rarity .. "_unlocked"] = true

	local icon_material_values = style.icon.material_values

	icon_material_values.frame_tier = "content/ui/textures/buttons/mastery_tree/trait_node_tier_" .. new_rarity

	local new_next_rarity = config.traits[trait_index].rarity
	local unlocked_rarity_level = Mastery.get_max_blessing_rarity_unlocked_level_by_points_spent(self._traits)
	local cost = Mastery.get_trait_cost(new_rarity) or nil

	content.rarity = new_rarity
	content.next_rarity = new_next_rarity
	config.cost = cost
	config.rarity = new_rarity
	config.next_rarity = new_next_rarity

	for i = 1, #self._trait_widgets do
		local trait_widget = self._trait_widgets[i]
		local trait_content = trait_widget.content
		local trait_config = trait_content.element

		if trait_config then
			for ii = 1, #trait_config.traits do
				local trait = trait_config.traits[ii]
				local trait_rarity = trait.rarity
				local available = trait_rarity <= unlocked_rarity_level

				trait_content["rarity_" .. trait_rarity .. "_available"] = available
				trait_config.available = available
			end
		end
	end

	self:_unselect_trait()
end

MasteryView._setup_milestones = function (self)
	local milestones = self._milestones
	local milestone_rewards_by_level = {}

	for i = 1, #milestones do
		local milestone = milestones[i]
		local milestone_data = {
			widget_type = "wintrack",
			icon = milestone.icon,
			display_name = milestone.display_name,
			text = milestone.text,
			icon_size = milestone.icon_size,
			icon_color = milestone.icon_color,
			icon_material_values = milestone.icon_material_values,
			type = milestone.type,
		}

		milestone_rewards_by_level[milestone.level] = milestone_rewards_by_level[milestone.level] or {}

		local next_index = #milestone_rewards_by_level[milestone.level] + 1

		milestone_rewards_by_level[milestone.level][next_index] = milestone_data
	end

	local wintrack_rewards = {}

	for level, rewards in ipairs(milestone_rewards_by_level) do
		wintrack_rewards[#wintrack_rewards + 1] = {
			points_required = level,
			items = rewards,
		}
	end

	self._wintrack_rewards = wintrack_rewards
	self._wintrack_element = self:_add_element(ViewElementWintrackMastery, "wintrack", 1, {
		read_only = true,
	}, "milestones_grid_pivot")

	self._wintrack_element:assign_rewards(wintrack_rewards, 1)

	local mastery_level = self._mastery.mastery_level
	local claimed_level = self._mastery.claimed_level
	local progress_to_next_level = math.ilerp(self._mastery.start_exp, self._mastery.end_exp, self._mastery.current_xp)
	local points_progress = mastery_level + progress_to_next_level

	self._wintrack_element:add_points(points_progress, false, true)

	self._claimed_tiers_index = math.min(claimed_level + 1, #wintrack_rewards)
end

MasteryView._can_trait_be_acquired = function (self, trait_item_element)
	local points_available = self._mastery.points_available
	local unlocked_rarity_level = Mastery.get_max_blessing_rarity_unlocked_level_by_points_spent(self._traits)
	local rarity = trait_item_element.rarity
	local next_rarity = trait_item_element.next_rarity
	local reached_max_rarity = trait_item_element.rarity == trait_item_element.next_rarity
	local cost = trait_item_element.cost
	local can_be_acquired = not not cost and cost <= points_available and next_rarity <= unlocked_rarity_level and not reached_max_rarity
	local reason = not can_be_acquired and (not not cost and points_available < cost and Localize("loc_mastery_trait_no_points") or unlocked_rarity_level < next_rarity and Localize("loc_mastery_trait_level_locked", true, {
		rarity_level = next_rarity,
	}) or "") or ""

	return can_be_acquired, reason
end

MasteryView._cb_trait_left_pressed = function (self, trait_widget, config)
	if self._wintracks_focused then
		return
	end

	if self._using_cursor_navigation and self._trait_widgets then
		for i = 1, #self._trait_widgets do
			local widget = self._trait_widgets[i]
			local content = widget.content
			local style = widget.style

			if content.hotspot then
				if widget ~= trait_widget then
					content.hotspot.is_selected = false
				else
					content.hotspot.is_selected = true
				end
			end
		end
	end

	self._selected_trait = config

	local rarity = config.rarity
	local next_rarity = config.next_rarity
	local reached_max_rarity = config.rarity == config.next_rarity
	local item = config.item
	local trait = self._selected_trait
	local rarity = trait.next_rarity
	local trait_name = trait.name
	local can_be_acquired = self:_can_trait_be_acquired(config)

	if not can_be_acquired or self._purchasing_trait then
		self:_unselect_trait()

		return
	end

	local previous_unlocked_rarity_level = Mastery.get_max_blessing_rarity_unlocked_level_by_points_spent(self._traits)

	self._purchasing_trait = true

	local cost = config.cost

	self._traits[self._selected_trait.index].trait_status[self._selected_trait.next_rarity] = "seen"
	self._mastery.points_used = self._mastery.points_used + cost
	self._mastery.points_available = self._mastery.points_available - cost
	self._widgets_by_name.mastery_points.content.mastery_points_value = string.format(" %s", self._mastery.points_available)

	if self._selected_trait then
		Managers.event:trigger("event_add_notification_message", "item_granted", self._selected_trait.item)
		self:_check_buttons_visibility()

		self._purchasing_trait = false
	end

	self._purchased_traits = self._purchased_traits or {}
	self._purchased_traits[#self._purchased_traits + 1] = {
		trait_name = trait_name,
		rarity = rarity,
		index = self._selected_trait.index,
	}

	local costs = Mastery.get_trait_costs()
	local thresholds = costs.trait_unlock_threshold
	local current_threshold = thresholds[tostring(previous_unlocked_rarity_level)]
	local next_threshold

	if previous_unlocked_rarity_level == MAX_RARITY_LEVEL then
		next_threshold = self._mastery.points_total
	else
		next_threshold = thresholds[tostring(previous_unlocked_rarity_level + 1)]
	end

	local points_in_threshold = next_threshold - current_threshold
	local time_added = TIME_PER_BAR / points_in_threshold

	if previous_unlocked_rarity_level < MAX_RARITY_LEVEL then
		self._progress_per_point = self._progress_per_point or {}
		self._progress_per_point[#self._progress_per_point + 1] = 1 / points_in_threshold
	end

	self:_update_traits(trait_widget)
	Managers.event:trigger("event_mastery_traits_update", self._mastery_id, {
		trait_name = trait_name,
		rarity = rarity,
	})
end

MasteryView._set_button_callbacks = function (self)
	return
end

MasteryView._check_buttons_visibility = function (self)
	return
end

MasteryView._change_buttons_disable_state = function (self, state)
	if self._trait_widgets then
		for i = 1, #self._trait_widgets do
			local trait_widget = self._trait_widgets[i]

			if trait_widget.content.hotspot then
				trait_widget.content.hotspot.disabled = state
			end
		end
	end
end

MasteryView._unselect_trait = function (self)
	if not self._using_cursor_navigation then
		return
	end

	if self._trait_widgets then
		for i = 1, #self._trait_widgets do
			local widget = self._trait_widgets[i]
			local content = widget.content
			local style = widget.style

			if content.hotspot then
				content.hotspot.is_selected = false
			end
		end
	end

	self._selected_trait = nil
end

MasteryView._update_animations = function (self, dt, t)
	MasteryView.super._update_animations(self, dt, t)

	if not self._initialized then
		return
	end

	local wintrack_element = self._wintrack_element

	if not wintrack_element then
		return
	end

	local tooltip_visible = wintrack_element:tooltip_visible()
	local anim_speed = 3
	local previous_anim_wintrack_reward_hover_progress = self._anim_wintrack_reward_hover_progress or 0
	local anim_wintrack_reward_hover_progress

	if tooltip_visible then
		anim_wintrack_reward_hover_progress = math.min(previous_anim_wintrack_reward_hover_progress + dt * anim_speed, 1)
	else
		anim_wintrack_reward_hover_progress = math.max(previous_anim_wintrack_reward_hover_progress - dt * anim_speed, 0)
	end

	if previous_anim_wintrack_reward_hover_progress ~= anim_wintrack_reward_hover_progress then
		local global_alpha_multiplier = 1 - math.easeOutCubic(self._anim_wintrack_reward_hover_progress or 0)
		local widgets_by_name = self._widgets_by_name

		if self._tooltip_widget then
			self._tooltip_widget.alpha_multiplier = global_alpha_multiplier
		end

		for i = 1, #self._trait_widgets do
			local widget = self._trait_widgets[i]

			widget.alpha_multiplier = global_alpha_multiplier
		end
	end

	self._anim_wintrack_reward_hover_progress = anim_wintrack_reward_hover_progress
end

MasteryView._find_closest_neighbour_vertical = function (self, index, input_direction)
	local grid_settings = MasteryViewSettings.trait_grid_settings
	local rows = grid_settings[1]
	local columns = grid_settings[2]
	local max_index

	for i = #self._trait_widgets, 1, -1 do
		local widget = self._trait_widgets[i]

		if widget.content.hotspot then
			max_index = i

			break
		end
	end

	if not max_index then
		return
	end

	local current_row = index / columns
	local start_row = 1
	local end_row = rows

	if input_direction == DIRECTION.DOWN and current_row < end_row then
		local result = index + columns

		if result <= max_index then
			return result
		end
	end

	if input_direction == DIRECTION.UP and start_row < current_row then
		local result = index - columns

		if result >= 1 then
			return result
		end
	end
end

MasteryView._find_closest_neighbour_horizontal = function (self, index, input_direction)
	local grid_settings = MasteryViewSettings.trait_grid_settings
	local rows = grid_settings[1]
	local columns = grid_settings[2]
	local max_index

	for i = #self._trait_widgets, 1, -1 do
		local widget = self._trait_widgets[i]

		if widget.content.hotspot then
			max_index = i

			break
		end
	end

	if not max_index then
		return
	end

	local current_row = math.floor((index - 1) / columns)
	local start_column = current_row * columns + 1
	local end_column = math.min(start_column + columns - 1, max_index)

	if input_direction == DIRECTION.RIGHT and index < end_column then
		return index + 1
	end

	if input_direction == DIRECTION.LEFT and start_column < index then
		return index - 1
	end
end

MasteryView._handle_input = function (self, input_service, dt, t)
	if not self._using_cursor_navigation and not self._tutorial_overlay:is_active() and not self._wintracks_focused and self._trait_widgets then
		local new_selection_index
		local current_index = self._selected_trait_index or 1

		if input_service:get("navigate_up_continuous") then
			new_selection_index = self:_find_closest_neighbour_vertical(current_index, DIRECTION.UP)
		elseif input_service:get("navigate_down_continuous") then
			new_selection_index = self:_find_closest_neighbour_vertical(current_index, DIRECTION.DOWN)
		elseif input_service:get("navigate_left_continuous") then
			new_selection_index = self:_find_closest_neighbour_horizontal(current_index, DIRECTION.LEFT)
		elseif input_service:get("navigate_right_continuous") then
			new_selection_index = self:_find_closest_neighbour_horizontal(current_index, DIRECTION.RIGHT)
		end

		if new_selection_index then
			self._selected_trait_index = new_selection_index

			for i = 1, #self._trait_widgets do
				local widget = self._trait_widgets[i]
				local content = widget.content
				local style = widget.style

				if content.hotspot then
					if i ~= new_selection_index then
						content.hotspot.is_selected = false
					else
						content.hotspot.is_selected = true
					end
				end
			end
		end
	end
end

MasteryView._on_navigation_input_changed = function (self)
	if self._wintrack_element then
		self._wintrack_element:remove_focus_on_reward()

		self._wintracks_focused = false
	end

	if not self._using_cursor_navigation then
		if not self._selected_trait_index then
			self._selected_trait_index = 1
		end

		if self._trait_widgets then
			for i = 1, #self._trait_widgets do
				local widget = self._trait_widgets[i]
				local content = widget.content
				local style = widget.style

				if content.hotspot then
					if i ~= self._selected_trait_index then
						content.hotspot.is_selected = false
					else
						content.hotspot.is_selected = true
					end
				end
			end
		end
	elseif self._trait_widgets then
		for i = 1, #self._trait_widgets do
			local widget = self._trait_widgets[i]
			local content = widget.content
			local style = widget.style

			if content.hotspot then
				content.hotspot.is_selected = false
			end
		end
	end
end

MasteryView.cb_on_switch_focus = function (self)
	if not self._using_cursor_navigation and self._wintrack_element then
		self._wintracks_focused = not self._wintracks_focused

		if self._wintracks_focused then
			self._wintrack_element:apply_focus_on_reward()
		else
			self._wintrack_element:remove_focus_on_reward()
		end
	end
end

return MasteryView
