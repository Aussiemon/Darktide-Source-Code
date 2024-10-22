-- chunkname: @scripts/ui/view_elements/view_element_wintrack/view_element_wintrack.lua

local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local Definitions = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack_definitions")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ViewElementWintrackSettings = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local TextUtils = require("scripts/utilities/ui/text")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementWintrack = class("ViewElementWintrack", "ViewElementBase")

ViewElementWintrack.init = function (self, parent, draw_layer, start_scale, optional_menu_settings, optional_definitions)
	self._pivot_offset = {
		0,
		0,
	}

	local view_definitions = optional_definitions or Definitions

	ViewElementWintrack.super.init(self, parent, draw_layer, start_scale, view_definitions)

	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementWintrackSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementWintrackSettings
	end

	self._ui_animations = {}
	self._points = 0
	self._max_points = 0
	self._visual_points = 0
	self._loaded_icon_id_cache = {}
	self._reward_offset_x = 0
	self._handle_input = true
	self._hint_upcoming_page = true
	self._initialize = false
	self._initial_reward_claim_status_update = true

	if self._menu_settings.use_parent_ui_renderer then
		local ui_renderer = self._parent:ui_renderer()
		local world = ui_renderer.world

		self._ui_reward_renderer = ui_renderer
		self._ui_reward_renderer_is_external = true

		local gui = self._ui_reward_renderer.gui
		local gui_retained = self._ui_reward_renderer.gui_retained
		local resource_renderer_name = self._unique_id
		local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur_02"

		self._ui_resource_renderer = Managers.ui:create_renderer(resource_renderer_name, world, true, gui, gui_retained, material_name)
	else
		local optional_world

		if self._menu_settings.use_parent_world then
			local ui_renderer = self._parent:ui_renderer()

			optional_world = ui_renderer.world
		end

		self:_setup_grid_gui(optional_world)
	end

	self._item_stats = self:_setup_item_stats("item_stats", "item_stats_pivot")
	self._widgets_by_name.navigation_arrow_left.content.hotspot.on_pressed_sound = UISoundEvents.penance_menu_wintrack_page_button_pressed
	self._widgets_by_name.navigation_arrow_left.content.hotspot.on_hover_sound = UISoundEvents.penance_menu_wintrack_page_button_hovered
	self._widgets_by_name.navigation_arrow_right.content.hotspot.on_pressed_sound = UISoundEvents.penance_menu_wintrack_page_button_pressed
	self._widgets_by_name.navigation_arrow_right.content.hotspot.on_hover_sound = UISoundEvents.penance_menu_wintrack_page_button_hovered

	local front_widgets = {}

	for name, definition in pairs(self._definitions.front_widget_definitions) do
		local widget = self:_create_widget(name, definition)

		front_widgets[#front_widgets + 1] = widget
	end

	self._front_widgets = front_widgets
	self._read_only = optional_menu_settings.read_only or false

	self:_update_claim_button_state()
end

ViewElementWintrack.ui_resource_renderer = function (self)
	return self._ui_resource_renderer
end

ViewElementWintrack.ui_reward_renderer = function (self)
	return self._ui_reward_renderer
end

ViewElementWintrack._setup_grid_gui = function (self, optional_world)
	local ui_manager = Managers.ui

	if not optional_world then
		local timer_name = "ui"
		local world_layer = 101 + self._draw_layer
		local world_name = self._unique_id .. "_ui_reward_world"
		local parent = self._parent
		local view_name = parent.view_name

		self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

		local viewport_name = self._unique_id .. "_ui_reward_world_viewport"
		local viewport_type = "overlay"
		local viewport_layer = 1

		self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
		self._viewport_name = viewport_name
	end

	local world = optional_world or self._world
	local renderer_name = self._unique_id .. "_reward_renderer"

	self._ui_reward_renderer = ui_manager:create_renderer(renderer_name, world)

	local gui = self._ui_reward_renderer.gui
	local gui_retained = self._ui_reward_renderer.gui_retained
	local resource_renderer_name = self._unique_id
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur_02"

	self._ui_resource_renderer = ui_manager:create_renderer(resource_renderer_name, world, true, gui, gui_retained, material_name)
end

ViewElementWintrack._destroy_grid_gui = function (self)
	if self._ui_resource_renderer then
		local renderer_name = self._unique_id

		self._ui_resource_renderer = nil

		Managers.ui:destroy_renderer(renderer_name)
	end

	if self._ui_reward_renderer then
		self._ui_reward_renderer = nil

		if not self._ui_reward_renderer_is_external then
			Managers.ui:destroy_renderer(self._unique_id .. "_reward_renderer")
		end
	end

	local world = self._world

	if self._world then
		local viewport_name = self._viewport_name

		if viewport_name then
			ScriptWorld.destroy_viewport(world, viewport_name)

			self._viewport_name = nil
		end

		Managers.ui:destroy_world(world)

		self._world = nil
	end
end

ViewElementWintrack.assign_rewards = function (self, rewards, points_per_reward)
	self._rewards = rewards
	self._points_per_reward = points_per_reward
	self._num_rewards_per_bar = 5

	local num_pages = math.ceil(#rewards / self._num_rewards_per_bar)

	if self._hint_upcoming_page then
		self._num_rewards_per_bar = self._num_rewards_per_bar + 1
	end

	self._num_reward_pages = num_pages
	self._points_per_bar = self._num_rewards_per_bar * self._points_per_reward
	self._max_points = #self._rewards * self._points_per_reward
end

ViewElementWintrack.is_initialized = function (self)
	return self._initialize
end

ViewElementWintrack._replace_border = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")

	grid_divider_top.content.texture = "content/ui/materials/frames/item_info_upper_slots"

	local style = grid_divider_top.style.texture
	local scale = self._default_grid_size[1] / 1060

	style.size = {
		[2] = 116 * scale,
	}
end

ViewElementWintrack.destroy = function (self, ui_renderer)
	if self._item_stats then
		self._item_stats:stop_presenting()
		self._item_stats:destroy(ui_renderer)

		self._item_stats = nil
	end

	local ui_resource_renderer = self._ui_resource_renderer
	local reward_widgets = self._reward_widgets

	if reward_widgets then
		local num_widgets = #reward_widgets

		for i = 1, num_widgets do
			local widget = reward_widgets[i]

			UIWidget.destroy(ui_resource_renderer, widget)
		end
	end

	local content_blueprints = self._content_blueprints
	local reward_item_widgets = self._reward_item_widgets

	if reward_item_widgets then
		local num_widgets = #reward_item_widgets

		for i = 1, num_widgets do
			local widget = reward_item_widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element

				if template.destroy then
					template.destroy(self, widget, element, ui_resource_renderer)
				end
			end

			UIWidget.destroy(ui_resource_renderer, widget)
		end
	end

	self:_destroy_grid_gui()
	ViewElementWintrack.super.destroy(self, ui_renderer)
end

ViewElementWintrack._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementWintrack.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local page_tumb_widgets = self._page_tumb_widgets

	if page_tumb_widgets then
		local num_widgets = #page_tumb_widgets

		for i = 1, num_widgets do
			local widget = page_tumb_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

ViewElementWintrack._is_reward_widget_visible = function (self, widget, extra_margin)
	local width, height = self:_scenegraph_size("reward_mask")
	local position = self:scenegraph_world_position("reward_mask")
	local scale = self._render_scale or 1
	local draw_length = width * scale
	local draw_start_length = 0
	local draw_end_length = draw_length
	local scenegraph_id = "reward"
	local reward_width, reward_height = self:_scenegraph_size(scenegraph_id)
	local start_position_start = widget.offset[1] * scale
	local start_position_end = start_position_start + reward_width

	if draw_end_length < start_position_start then
		return false
	elseif start_position_end < draw_start_length then
		return false
	end

	return true
end

ViewElementWintrack.draw_reward_widgets = function (self, dt, t, input_service, render_settings)
	local ui_reward_renderer = self._ui_reward_renderer
	local ui_resource_renderer = self._ui_resource_renderer
	local ui_scenegraph = self._ui_scenegraph
	local base_render_pass = ui_resource_renderer.base_render_pass
	local render_target = ui_resource_renderer.render_target

	UIRenderer.add_render_pass(ui_reward_renderer, 0, base_render_pass, true, render_target)
	UIRenderer.add_render_pass(ui_reward_renderer, 1, "to_screen", false)
	UIRenderer.begin_pass(ui_resource_renderer, ui_scenegraph, input_service, dt, render_settings)

	local reward_widgets = self._reward_widgets

	if reward_widgets then
		local num_widgets = #reward_widgets

		for i = 1, num_widgets do
			local widget = reward_widgets[i]
			local reward_widget = self._reward_item_widgets[i]

			if self:_is_reward_widget_visible(widget) then
				UIWidget.draw(widget, ui_resource_renderer)
				UIWidget.draw(reward_widget, ui_resource_renderer)
			end
		end
	end

	UIRenderer.end_pass(ui_resource_renderer)
	UIRenderer.begin_pass(ui_reward_renderer, ui_scenegraph, input_service, dt, render_settings)

	local front_widgets = self._front_widgets

	if front_widgets then
		local num_widgets = #front_widgets

		for i = 1, num_widgets do
			local widget = front_widgets[i]

			UIWidget.draw(widget, ui_reward_renderer)
		end
	end

	UIRenderer.end_pass(ui_resource_renderer)
end

ViewElementWintrack.on_resolution_modified = function (self, scale)
	ViewElementWintrack.super.on_resolution_modified(self, scale)
end

ViewElementWintrack.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._handle_input then
		input_service = input_service:null_service()
	end

	local ui_resource_renderer = self._ui_resource_renderer
	local ui_reward_renderer = self._ui_reward_renderer

	ui_resource_renderer.color_intensity_multiplier = ui_renderer.color_intensity_multiplier or 1
	ui_reward_renderer.color_intensity_multiplier = ui_renderer.color_intensity_multiplier or 1

	if not self._initialize and self._rewards then
		self._initialize = true

		self:_create_reward_widgets(self._rewards, ui_reward_renderer)
		self:_create_page_indicators()
		self:_set_reward_page(1, true)
	end

	if not self._ui_grid_renderer_is_external then
		UIRenderer.clear_render_pass_queue(ui_reward_renderer)
	end

	self:draw_reward_widgets(dt, t, input_service, render_settings)
	self:_draw_reward_render_target(render_settings)
	self:_update_reward_item_widgets_visibility(ui_reward_renderer)

	local previous_scale = render_settings.scale

	if self._item_stats then
		self._item_stats:set_render_scale(previous_scale)
		self._item_stats:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	render_settings.scale = previous_scale

	ViewElementWintrack.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementWintrack._draw_reward_render_target = function (self, render_settings)
	local ui_reward_renderer = self._ui_reward_renderer
	local gui = ui_reward_renderer.gui
	local color = Color(255, 255, 255, 255)
	local ui_resource_renderer = self._ui_resource_renderer
	local material = ui_resource_renderer.render_target_material
	local scale = self._render_scale or 1
	local width, height = self:_scenegraph_size("reward_mask")
	local position = self:scenegraph_world_position("reward_mask")
	local start_layer = (render_settings.start_layer or 0) + self._draw_layer
	local gui_position = Vector3(position[1] * scale, position[2] * scale, 999)
	local gui_size = Vector3(width * scale, height * scale, 0)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size, color)
end

ViewElementWintrack.on_reward_claimed = function (self, index)
	local reward_widgets = self._reward_widgets
	local reward_item_widgets = self._reward_item_widgets
	local widget = reward_widgets[index]

	if widget then
		widget.content.claimed = true

		self:_play_sound(UISoundEvents.penance_menu_wintrack_reward_claimed)
	end

	local reward_item_widgets = self._reward_item_widgets
	local reward_widget = reward_item_widgets[index]

	if reward_widget then
		reward_widget.content.claimed = true
	end
end

ViewElementWintrack.set_index_claimed = function (self, index)
	local reward_widgets = self._reward_widgets
	local widget = reward_widgets[index]

	if widget then
		widget.content.claimed = true
	end

	local reward_item_widgets = self._reward_item_widgets
	local reward_widget = reward_item_widgets[index]

	if reward_widget then
		reward_widget.content.claimed = true
	end
end

ViewElementWintrack.ready_to_claim_reward_by_index = function (self)
	return self._reward_index_to_claim
end

ViewElementWintrack._update_reward_claim_status = function (self, dt, t, input_service)
	if self._read_only then
		return
	end

	local reward_widgets = self._reward_widgets
	local reward_item_widgets = self._reward_item_widgets

	self._reward_index_to_claim = nil
	self._can_claim_rewards = false
	self._next_reward_to_claim = nil

	local is_initial_reward_claim_status_update = self._initial_reward_claim_status_update
	local play_sounds = not is_initial_reward_claim_status_update
	local claim_button_pressed = self._widgets_by_name.claim_button.content.hotspot.on_pressed
	local visual_points = self._points

	for i = 1, #reward_widgets do
		local reward_widget = reward_widgets[i]
		local reward_item_widget = reward_item_widgets[i]
		local content = reward_widget.content

		if not content.claimed then
			local element = reward_item_widget.content.element
			local required_points = element.required_points

			if required_points <= visual_points then
				if not content.can_claim then
					if not play_sounds then
						self:_play_sound(UISoundEvents.penance_menu_wintrack_reward_reached)
					end

					content.can_claim = true
					self._force_reward_page_change = true
				end

				self._can_claim_rewards = true

				local hotspot = content.hotspot

				if hotspot.on_pressed or claim_button_pressed then
					self._reward_index_to_claim = i
				end

				self._next_reward_to_claim = i

				break
			end
		end
	end

	if not self._can_claim_rewards then
		for i = 1, #reward_widgets do
			local reward_widget = reward_widgets[i]
			local reward_item_widget = reward_item_widgets[i]
			local content = reward_widget.content
			local element = reward_item_widget.content.element
			local required_points = element.required_points

			if visual_points < required_points then
				self._next_reward_to_claim = i

				break
			end
		end
	end

	self._initial_reward_claim_status_update = false
end

ViewElementWintrack.set_handle_input = function (self, handle_input)
	self._handle_input = handle_input
end

ViewElementWintrack.update = function (self, dt, t, input_service)
	if not self._initialize then
		return
	end

	if not self._handle_input then
		input_service = input_service:null_service()
	end

	if not self._using_cursor_navigation then
		if input_service:get("hotkey_menu_special_2") then
			self._widgets_by_name.claim_button.content.hotspot.on_pressed = true
		else
			local current_index
			local reward_item_widgets = self._reward_item_widgets

			if reward_item_widgets then
				local hovered_items
				local num_widgets = #reward_item_widgets

				for i = 1, num_widgets do
					local widget = reward_item_widgets[i]
					local content = widget.content
					local hotspot = content.hotspot
					local is_selected = hotspot and hotspot.is_selected

					if is_selected then
						current_index = i

						break
					end
				end

				if current_index then
					local wanted_index = current_index
					local max_index = #reward_item_widgets

					if input_service:get("navigate_left_continuous") then
						wanted_index = math.clamp(current_index - 1, 1, max_index)
					elseif input_service:get("navigate_right_continuous") then
						wanted_index = math.clamp(current_index + 1, 1, max_index)
					end

					if wanted_index ~= current_index then
						self:focus_on_reward(wanted_index)
					end
				end
			end
		end
	end

	self:_update_reward_claim_status(dt, t, input_service)

	if not self._ui_animations.page_scroll then
		local widgets_by_name = self._widgets_by_name

		if widgets_by_name.navigation_arrow_left.content.hotspot.on_pressed and self._current_reward_page_index > 1 then
			self:_set_reward_page(self._current_reward_page_index - 1, true)
		elseif widgets_by_name.navigation_arrow_right.content.hotspot.on_pressed and self._current_reward_page_index < self._num_reward_pages then
			self:_set_reward_page(self._current_reward_page_index + 1, true)
		end
	end

	local currently_hovered_item = self:currently_hovered_item()

	if currently_hovered_item then
		self:_handle_reward_scroll(input_service, dt)
	end

	self:_update_claim_button_state()

	local anim_progress = self._anim_progress
	local play_progress_sounds = self._play_progress_sounds
	local visual_points, added_points

	if self._animate_visual_points then
		self._current_points_anim_time = self._current_points_anim_time + dt

		local anim_time_progress = math.clamp(self._current_points_anim_time / self._total_points_anim_time, 0, 1)
		local points_to_add = self._visual_points_to_add or 0

		visual_points = math.ceil((self._anim_start_points or self._points - points_to_add) + math.easeCubic(anim_time_progress) * points_to_add)
		self._visual_points = math.clamp(visual_points, 0, self._max_points)
		added_points = self._visual_points_to_add

		if anim_time_progress == 1 then
			self._animate_visual_points = false
			self._play_progress_sounds = false
			self._visual_points_to_add = nil
			self._anim_start_points = nil
			self._total_points_anim_time = nil
			self._current_points_anim_time = nil

			if play_progress_sounds then
				self:_play_sound(UISoundEvents.penance_menu_wintrack_bar_stop)
			end
		end
	else
		visual_points = self._points
		added_points = visual_points and self._visual_points and visual_points - self._visual_points
		self._visual_points = visual_points
	end

	local total_progress = visual_points / (self._points_per_bar * self._num_reward_pages)
	local next_reward_item_widget = self._next_reward_to_claim and self._reward_item_widgets[self._next_reward_to_claim] or nil
	local next_reward_points = next_reward_item_widget and next_reward_item_widget.content.element.required_points or visual_points
	local reward_points = math.min(visual_points, next_reward_points)
	local reward_progress = reward_points / (self._points_per_bar * self._num_reward_pages)
	local bar_width = self:_get_progress_bars_width()
	local total_reward_track_length = self._total_reward_track_length * self._num_reward_pages
	local length_moved_on_track = (total_reward_track_length - bar_width) * anim_progress
	local total_progress_length_on_track = total_reward_track_length * total_progress
	local next_reward_progress_length_on_track = total_reward_track_length * reward_progress
	local visible_pixels_of_progress_bar = math.clamp(total_progress_length_on_track - length_moved_on_track, 0, bar_width)
	local bar_progress_anim = visible_pixels_of_progress_bar / bar_width
	local total_reward_length_on_track = total_reward_track_length * reward_progress
	local visible_pixels_of_reward_bar = math.clamp(total_reward_length_on_track - length_moved_on_track, 0, bar_width)
	local bar_reward_anim = visible_pixels_of_reward_bar / bar_width
	local page_point_reduction = 0

	if self._hint_upcoming_page then
		local progress_per_reward = 1 / self._num_rewards_per_bar

		page_point_reduction = self._points_per_bar * progress_per_reward
	end

	local reward_page_index = math.max(math.ceil(reward_points / (self._points_per_bar - page_point_reduction)), 1)
	local current_index = self._current_reward_page_index
	local new_page_index = math.max(math.ceil(visual_points / (self._points_per_bar - page_point_reduction)), 1)
	local previous_reward_index = math.max(math.ceil((visual_points - self._points_per_reward * 2) / (self._points_per_bar - page_point_reduction)), 1)
	local page_point_reduction = 0

	if self._hint_upcoming_page then
		local progress_per_reward = 1 / self._num_rewards_per_bar

		page_point_reduction = self._points_per_bar * progress_per_reward
	end

	local reward_index = self._next_reward_to_claim
	local reward_widget = self._reward_item_widgets and self._reward_item_widgets[reward_index]
	local rewards_required_points = reward_widget and reward_widget.content.element.required_points
	local reward_points = rewards_required_points or visual_points
	local wanted_page_index = math.ceil(reward_points / (self._points_per_bar - page_point_reduction))
	local reward_bar_changed_to_reward_page = false
	local reward_is_now_available = false

	if added_points and added_points > 0 then
		reward_bar_changed_to_reward_page = current_index and current_index ~= new_page_index and new_page_index == reward_page_index and previous_reward_index == current_index
		reward_is_now_available = reward_points == visual_points and reward_points > visual_points - added_points
	end

	local reward_bar_change = reward_is_now_available or reward_bar_changed_to_reward_page or self._force_reward_page_change

	if self._move_wintrack_next_frame then
		local animate = self._animate_visual_points

		self:_set_reward_page(wanted_page_index, animate)

		self._move_wintrack_next_frame = false
	end

	if reward_bar_change then
		self._force_reward_page_change = false
		self._move_wintrack_next_frame = true
	end

	if play_progress_sounds then
		self:_set_sound_parameter(UISoundEvents.penance_menu_wintrack_bar_progress, bar_progress_anim)
	end

	self:_set_bars_progress(bar_progress_anim, bar_reward_anim, false)
	self:_update_reward_widget_positions(dt, t)
	self:_animate_progress_bars(dt, t)
	self:_update_animations(dt, t)

	local reward_item_widgets = self._reward_item_widgets
	local widget

	if reward_item_widgets then
		local hovered_items
		local num_widgets = #reward_item_widgets

		for i = 1, num_widgets do
			widget = reward_item_widgets[i]

			local content = widget.content
			local hotspot = content.hotspot
			local is_hover = hotspot and hotspot.is_hover
			local is_selected = hotspot and hotspot.is_selected

			if is_hover or is_selected then
				local element = content.element
				local items = element.items

				hovered_items = items

				break
			end
		end

		if hovered_items then
			if not self._currently_hovered_item or hovered_items ~= self._currently_hovered_items then
				self:_on_reward_items_hover_start(hovered_items, nil, widget)
			end
		elseif self._currently_hovered_item then
			self:_on_reward_items_hover_stop()
		end
	end

	if self._item_stats then
		if self._currently_hovered_item and (not self._currently_hovered_widget or not self._currently_hovered_widget.content.element.hide_tooltip) then
			self:_update_item_stats_position("item_stats_pivot", self._item_stats)
		end

		self._item_stats:update(dt, t, input_service)
	end

	return ViewElementWintrack.super.update(self, dt, t, input_service)
end

ViewElementWintrack._update_claim_button_state = function (self, force_effect)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.claim_button
	local widget_content = widget.content

	widget_content.visible = not self._read_only
	self._widgets_by_name.reward_field_2.content.read_only = self._read_only

	if widget_content.visible == false then
		return
	end

	local widget_hotspot = widget_content.hotspot
	local disabled = not self._can_claim_rewards

	if disabled and not widget_hotspot.disabled and not force_effect then
		self:stop_claim_button_animation()
	elseif (widget_hotspot.disabled or force_effect) and not disabled then
		self:play_claim_button_animation()
	end

	widget_hotspot.disabled = disabled
end

ViewElementWintrack.play_claim_button_animation = function (self)
	if self._activate_claim_button_anim_id then
		self:_stop_animation(self._activate_claim_button_anim_id)

		self._activate_claim_button_anim_id = nil
	end

	if self._deactivate_claim_button_anim_id then
		self:_stop_animation(self._deactivate_claim_button_anim_id)

		self._deactivate_claim_button_anim_id = nil
	end

	self._activate_claim_button_anim_id = self:_start_animation("activate_claim_button", self._widgets_by_name, nil)

	self:_play_sound(UISoundEvents.crafting_craft_button_activation)
end

ViewElementWintrack.stop_claim_button_animation = function (self)
	if self._claim_button_anim_id then
		self:_stop_animation(self._claim_button_anim_id)

		self._claim_button_anim_id = nil
	end

	if self._deactivate_claim_button_anim_id then
		self:_stop_animation(self._deactivate_claim_button_anim_id)

		self._deactivate_claim_button_anim_id = nil
	end

	self._deactivate_claim_button_anim_id = self:_start_animation("deactivate_claim_button", self._widgets_by_name)

	self:_play_sound(UISoundEvents.crafting_craft_button_deactivation)
end

ViewElementWintrack._on_navigation_input_changed = function (self)
	ViewElementWintrack.super._on_navigation_input_changed(self)
	self:_update_reward_tooltip_hint()

	if not self._using_cursor_navigation then
		self:apply_focus_on_reward()
	else
		self:remove_focus_on_reward()
	end

	self._widgets_by_name.navigation_arrow_left.content.visible = self._using_cursor_navigation
	self._widgets_by_name.navigation_arrow_right.content.visible = self._using_cursor_navigation
end

ViewElementWintrack._update_reward_tooltip_hint = function (self)
	local widget = self._widgets_by_name.reward_input_description
	local content = widget.content
	local visible = false

	if self._currently_hovered_items and #self._currently_hovered_items > 1 then
		local gamepad_input = "navigate_controller_right"
		local pc_input = "scroll_axis"
		local input = not self._using_cursor_navigation and gamepad_input or pc_input
		local loc_string = "loc_account_profile_next_reward"
		local input_service_name = "View"
		local text = TextUtils.localize_with_button_hint(input, loc_string, nil, input_service_name, nil, nil, true)

		if not self._using_cursor_navigation then
			local input_device_list = InputUtils.platform_device_list()

			for i = 1, #input_device_list do
				local device = input_device_list[i]

				if device.active() then
					local ui_input_color = Color.ui_input_color(255, true)
					local input_text = InputUtils.apply_color_to_input_text("", ui_input_color)

					if IS_PLAYSTATION then
						input_text = InputUtils.apply_color_to_input_text("", ui_input_color)
					end

					text = string.format("%s%s%s", input_text, "     ", Localize(loc_string))

					break
				end
			end
		end

		content.text = text
		visible = true
	end

	content.visible = visible
end

ViewElementWintrack._get_progress_bars_width = function (self)
	local bar_width = self:_scenegraph_size("experience_progress_bar")
	local num_rewards_per_bar = self._num_rewards_per_bar + 1
	local experience_bar_progress = 1 / num_rewards_per_bar

	return bar_width
end

ViewElementWintrack._handle_reward_scroll = function (self, input_service, dt)
	local navigation_value = 0

	if not self._using_cursor_navigation then
		local controller_right = "navigate_controller_right"
		local gamepad_input = input_service:get(controller_right)
		local axis = 2

		navigation_value = gamepad_input[axis] * 10 * dt
	else
		local axis = 2
		local scroll_axis = input_service:get("scroll_axis")

		navigation_value = scroll_axis[axis]
	end

	if navigation_value ~= 0 then
		self._accumulated_scroll_value = self._accumulated_scroll_value or 0
		self._accumulated_scroll_value = self._accumulated_scroll_value + navigation_value

		if self._accumulated_scroll_value >= 1 or self._accumulated_scroll_value <= -1 then
			local currently_hovered_hovered_items = self._currently_hovered_items

			if currently_hovered_hovered_items then
				local num_rewards = #currently_hovered_hovered_items

				if num_rewards > 1 then
					local current_index = self._currently_hovered_items_index
					local simplified_scroll_value = self._accumulated_scroll_value < 0 and math.ceil(self._accumulated_scroll_value) or math.floor(self._accumulated_scroll_value)
					local wanted_index = math.index_wrapper(math.ceil(current_index - simplified_scroll_value), num_rewards)

					if wanted_index ~= current_index then
						self:_play_sound(UISoundEvents.penance_menu_reward_scroll)
						self:_on_reward_items_hover_start(currently_hovered_hovered_items, wanted_index, self._currently_hovered_widget)
					end
				end
			end

			self._accumulated_scroll_value = 0
		end
	elseif self._accumulated_scroll_value ~= 0 then
		self._accumulated_scroll_value = 0
	end
end

ViewElementWintrack._handle_track_scroll = function (self, input_service, dt)
	local anim_progress = self._anim_progress or 0
	local axis = 2
	local scroll_axis = input_service:get("scroll_axis")
	local scroll_multiplier = math.abs(scroll_axis[axis]) * 0.8
	local default_scroll_amount = 0.0005
	local scroll_amount = default_scroll_amount * scroll_multiplier

	if scroll_axis[axis] ~= 0 then
		local previous_scroll_add = self._scroll_add or 0
		local current_scroll_direction = scroll_axis[axis] > 0 and -1 or 1

		if current_scroll_direction > 1 then
			self._wanted_carousel_index = self._wanted_carousel_index or 0 or (self._current_crousel_index or 1) + 1
		else
			self._wanted_carousel_index = self._wanted_carousel_index or 0 or (self._current_crousel_index or 1) - 1
		end

		if self._current_scroll_direction and self._current_scroll_direction ~= current_scroll_direction then
			previous_scroll_add = 0
		end

		self._current_scroll_direction = current_scroll_direction
		self._scroll_add = previous_scroll_add + scroll_amount
	end

	local scroll_add = self._scroll_add

	if scroll_add then
		local speed = 3
		local step = scroll_add * (dt * speed)

		if math.abs(scroll_add) > scroll_amount / 500 then
			self._scroll_add = math.max(scroll_add - step * 1.5, 0)
		else
			self._scroll_add = nil
		end
	end

	local current_scroll_direction = self._current_scroll_direction or 0

	self._anim_progress = math.clamp(anim_progress + (self._scroll_add or 0) * current_scroll_direction, 0, 1)
end

ViewElementWintrack.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementWintrack.visual_points = function (self)
	return self._visual_points or self._points
end

ViewElementWintrack.points = function (self)
	return self._points
end

ViewElementWintrack.max_points = function (self)
	return self._max_points
end

ViewElementWintrack.add_points = function (self, points_to_add, animate, force_reward_page_change)
	if self._points >= self._max_points then
		return
	end

	local new_total_points = math.min((self._points or 0) + points_to_add, self._max_points)

	self._animate_visual_points = animate

	if animate then
		self._anim_start_points = self._visual_points

		local points_diff = new_total_points - self._visual_points
		local min_anim_time = 0.5
		local max_anim_time = 6
		local time_per_bar = 2
		local anim_time_multiplier = points_diff / self._points_per_bar

		self._total_points_anim_time = math.clamp(anim_time_multiplier * time_per_bar, min_anim_time, max_anim_time)
		self._current_points_anim_time = 0
		self._visual_points_to_add = points_diff

		self:_play_sound(UISoundEvents.penance_menu_wintrack_bar_start)

		self._play_progress_sounds = true

		self:_start_animation("on_points_added", self._widgets_by_name, {
			anim_only_experience_bar = (self._reward_bar_progress or 0) < (self._experience_bar_progress or 0),
		})
	else
		self._anim_start_points = nil
		self._total_points_anim_time = nil
		self._current_points_anim_time = nil
	end

	if force_reward_page_change then
		self._force_reward_page_change = true
	end

	self._points = new_total_points
end

ViewElementWintrack._create_reward_widgets = function (self, rewards, ui_renderer)
	local widgets = {}
	local item_widgets = {}
	local item_size = ViewElementWintrackSettings.item_size
	local amount = #rewards
	local bar_width = self:_get_progress_bars_width()
	local distance_between_reward = bar_width / self._num_rewards_per_bar
	local pass_template = self._definitions.reward_base_pass_template
	local scenegraph_id = "reward"
	local reward_width, reward_height = self:_scenegraph_size(scenegraph_id)
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id)
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local ContentBlueprints, blueprint_widget_type_by_slot = generate_blueprints_function(item_size)

	self._content_blueprints = ContentBlueprints
	self._blueprint_widget_type_by_slot = blueprint_widget_type_by_slot

	local offset_x = -(reward_width * 0.5)
	local reward_item_scenegraph_id = "reward_item"
	local reward_item_width, reward_item_height = self:_scenegraph_size(reward_item_scenegraph_id)

	for i = 1, amount do
		local reward = rewards[i]
		local items = reward.items
		local first_item = items and items[1]
		local first_item_slots = first_item and first_item.slots
		local slot_name = first_item_slots and first_item_slots[1]
		local widget_type = blueprint_widget_type_by_slot and blueprint_widget_type_by_slot[slot_name]
		local template = ContentBlueprints[widget_type]
		local item_pass_template = template and template.pass_template

		if item_pass_template then
			local index = #item_widgets + 1
			local reward_item_widget_name = "reward_item_widget_" .. index
			local item_widget_definition = UIWidget.create_definition(item_pass_template, "reward_item")
			local item_widget = self:_create_widget(reward_item_widget_name, item_widget_definition)

			item_widgets[index] = item_widget
			item_widget.type = widget_type

			local required_points = self._points_per_reward * index
			local item_widget_element = {
				show_icon = true,
				item = first_item,
				items = items,
				slot = ItemSlotSettings[slot_name],
				required_points = required_points,
				size = {
					reward_item_width,
					reward_item_height,
				},
			}

			item_widget.content.element = item_widget_element

			local callback_name, secondary_callback_name, double_click_callback

			template.init(self, item_widget, item_widget_element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)

			local name = "reward_widget_" .. index
			local widget = self:_create_widget(name, widget_definition)

			widget.offset[1] = offset_x
			widget.content.required_points = required_points
			item_widget.style.style_id_1.on_pressed_sound = nil

			if #items > 1 then
				widget.content.reward_count = "+" .. tostring(#items - 1)
			end

			widgets[index] = widget
			offset_x = offset_x + distance_between_reward
		end
	end

	self._total_reward_track_length = distance_between_reward * self._num_rewards_per_bar
	self._current_reward_page_index = 1
	self._reward_widgets = widgets
	self._reward_item_widgets = item_widgets
end

ViewElementWintrack._get_progress_required_to_page = function (self, index)
	local progress_per_page = 1 / (self._num_reward_pages - 1)
	local progress_required_to_page = progress_per_page * (index - 1)

	if self._hint_upcoming_page then
		local progress_per_reward_per_bar = 1 / self._num_rewards_per_bar
		local progress_per_reward = progress_per_reward_per_bar / (self._num_reward_pages - 1)

		progress_required_to_page = progress_required_to_page - progress_per_reward * (index - 1)
	end

	return progress_required_to_page
end

ViewElementWintrack._set_reward_page = function (self, index, animate)
	local clamped_index = math.clamp(index, 1, self._num_reward_pages)

	if clamped_index ~= self._current_reward_page_index and animate then
		self:_play_sound(UISoundEvents.penance_menu_wintrack_move_page)
	end

	local previous_index = self._current_reward_page_index

	self._current_reward_page_index = clamped_index

	self:_set_page_indicator_focus(clamped_index)

	local progress_required_to_page = self:_get_progress_required_to_page(clamped_index)
	local anim_progress = self._anim_progress or 0
	local current_diff = progress_required_to_page - anim_progress

	self._scroll_add = nil

	local func = UIAnimation.function_by_time
	local target = self
	local target_index = "_anim_progress"
	local from = anim_progress
	local to = anim_progress + current_diff
	local duration = 0.9
	local easing = math.ease_quad

	self._ui_animations.page_scroll = UIAnimation.init(func, target, target_index, from, to, duration, easing)
end

ViewElementWintrack._update_animations = function (self, dt, t)
	local ui_animations = self._ui_animations

	for key, ui_animation in pairs(ui_animations) do
		UIAnimation.update(ui_animation, dt)

		if UIAnimation.completed(ui_animation) then
			ui_animations[key] = nil
		end
	end

	ViewElementWintrack.super._update_animations(self, dt, t)
end

ViewElementWintrack._update_reward_widget_positions = function (self, dt, t)
	local bar_width = self:_get_progress_bars_width()
	local total_bar_background_width = self:_scenegraph_size("experience_progress_bar")
	local distance_between_reward = bar_width / self._num_rewards_per_bar
	local anim_progress = self._anim_progress or 0
	local reward_widgets = self._reward_widgets
	local reward_item_widgets = self._reward_item_widgets
	local num_reward_pages = self._num_reward_pages
	local num_rewards_per_bar = self._num_rewards_per_bar
	local num_visible_entries = num_rewards_per_bar
	local num_options = #reward_widgets
	local progress_per_option = 1 / (num_reward_pages * num_rewards_per_bar - num_visible_entries)
	local entry_move_progress = anim_progress % progress_per_option / progress_per_option
	local start_reading_index = math.floor(anim_progress / progress_per_option)
	local progress_per_page = 1 / (self._num_reward_pages - 1)
	local progress_required_to_last_page = self:_get_progress_required_to_page(num_reward_pages)
	local normalized_progress = anim_progress / progress_required_to_last_page
	local pixel_progress = distance_between_reward * entry_move_progress

	self._widgets_by_name.reward_field.content.pixel_progress = pixel_progress
	self._widgets_by_name.reward_field.content.normalized_progress = entry_move_progress * 0.5

	local loop_end_index = num_visible_entries + 2
	local reward_width = self:_scenegraph_size("reward")

	for i = 1, num_options do
		local widget_index = (start_reading_index + (i - 1)) % num_options + 1
		local visible = start_reading_index <= widget_index and widget_index < start_reading_index + loop_end_index
		local widget = reward_widgets[widget_index]

		if widget then
			local item_widget = reward_item_widgets[widget_index]
			local content = widget.content
			local previous_visibility_state = content.visible

			content.visible_last_frame = content.visible
			content.visible = visible
			content.render_icon = visible

			local item_widget_content = item_widget.content

			item_widget_content.visible_last_frame = previous_visibility_state
			item_widget_content.visible = visible
			item_widget_content.render_icon = visible
		end
	end

	for i = 0, num_visible_entries + 2 do
		local read_index = start_reading_index + i
		local widget = reward_widgets[read_index]
		local item_widget = reward_item_widgets[read_index]

		if widget then
			local entry_position_x = distance_between_reward * i
			local previous_entry_position_x = distance_between_reward * (i - 1)
			local index_anim_offset_x = entry_move_progress * (entry_position_x - previous_entry_position_x)
			local x = -(reward_width * 0.5) + entry_position_x - index_anim_offset_x

			widget.offset[1] = x + self._reward_offset_x
			item_widget.offset[1] = x + self._reward_offset_x
		end
	end
end

ViewElementWintrack._update_reward_item_widgets_visibility = function (self, ui_renderer)
	local widgets = self._reward_item_widgets

	if widgets then
		local content_blueprints = self._content_blueprints
		local num_widgets = #widgets
		local update_visible_icon_prioritization_load = false

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible
				local render_icon = content.render_icon or visible

				if not render_icon and template.unload_icon then
					template.unload_icon(self, widget, element, ui_renderer)
				end
			end
		end

		for i = num_widgets, 1, -1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible
				local visible_last_frame = content.visible_last_frame
				local render_icon = content.render_icon or visible

				if render_icon and template.load_icon then
					local prioritize = visible

					if content.icon_load_id and visible and not visible_last_frame then
						update_visible_icon_prioritization_load = true
					end

					local profile = self._item_icon_profile

					template.load_icon(self, widget, element, ui_renderer, profile, prioritize)

					local icon_load_id = content.icon_load_id

					if icon_load_id and self._cache_loaded_icons and not self._loaded_icon_id_cache[icon_load_id] then
						self._loaded_icon_id_cache[icon_load_id] = Managers.ui:increment_item_icon_load_by_existing_id(icon_load_id)
					end
				end
			end
		end

		if update_visible_icon_prioritization_load then
			for j = #widgets, 1, -1 do
				local widget = widgets[j]
				local widget_type = widget.type
				local template = content_blueprints[widget_type]
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if visible and template.update_item_icon_priority then
					template.update_item_icon_priority(self, widget, element, ui_renderer)
				end
			end
		end
	end
end

ViewElementWintrack._set_bars_progress = function (self, experience_progress, reward_progress, animate)
	if animate then
		self._animated_experience_bar_progress = 0
		self._animated_reward_bar_progress = 0
	else
		self._animated_experience_bar_progress = 1
		self._animated_reward_bar_progress = 1
	end

	self._experience_bar_progress = experience_progress
	self._reward_bar_progress = reward_progress
end

ViewElementWintrack._animate_progress_bars = function (self, dt, t)
	local anim_experience_progress = self._animated_experience_bar_progress
	local index = self._current_reward_page_index
	local rewards_per_page = self._num_rewards_per_bar
	local points_per_page = rewards_per_page * self._points_per_reward
	local previous_page_overflow_experience_bar = points_per_page * (index - 1) < self._points
	local overflow_experience_bar = points_per_page * index < self._points
	local next_reward_item_widget = self._next_reward_to_claim and self._reward_item_widgets[self._next_reward_to_claim] or nil
	local next_reward_required_points = next_reward_item_widget and next_reward_item_widget.content.element.required_points or 0
	local overflow_reward_bar = next_reward_required_points > points_per_page * index
	local previous_page_overflow_reward_bar = next_reward_required_points > points_per_page * (index - 1)
	local progress_required_to_page = self:_get_progress_required_to_page(index)
	local anim_progress = self._anim_progress or 0
	local page_progress = progress_required_to_page - anim_progress
	local current_diff = math.abs(progress_required_to_page - (anim_progress - page_progress))
	local experience_bar_extra_width_next_page = 0
	local reward_bar_extra_width_next_page = 0
	local extra_width = 0

	if overflow_experience_bar or not overflow_experience_bar and previous_page_overflow_experience_bar and current_diff > 0.1 then
		experience_bar_extra_width_next_page = extra_width
	end

	if overflow_reward_bar or not overflow_reward_bar and previous_page_overflow_reward_bar and current_diff > 0.1 then
		reward_bar_extra_width_next_page = extra_width
	end

	if anim_experience_progress then
		local widgets_by_name = self._widgets_by_name
		local widget = widgets_by_name.experience_progress_bar
		local style = widget.style
		local bar_style = style.bar
		local outer_glow_style = style.outer_glow
		local bar_width = self:_get_progress_bars_width()
		local progress = math.clamp(anim_experience_progress * self._experience_bar_progress, 0, 1)
		local bar_width_progress = (bar_width + self._reward_offset_x + experience_bar_extra_width_next_page) * progress

		bar_style.size[1] = bar_width_progress
		outer_glow_style.size[1] = bar_width_progress
	end

	local anim_reward_progress = self._animated_reward_bar_progress

	if anim_reward_progress then
		local widgets_by_name = self._widgets_by_name
		local widget = widgets_by_name.reward_progress_bar
		local style = widget.style
		local bar_style = style.bar
		local outer_glow_style = style.outer_glow
		local bar_width = self:_get_progress_bars_width()
		local progress = math.clamp(anim_reward_progress * self._reward_bar_progress, 0, 1)
		local bar_width_progress = (bar_width + self._reward_offset_x + reward_bar_extra_width_next_page) * progress

		bar_style.size[1] = bar_width_progress
		outer_glow_style.size[1] = bar_width_progress
	end
end

ViewElementWintrack._create_page_indicators = function (self)
	local widget_definition = self._definitions.page_thumb_widget_definition
	local widgets = {}
	local page_thumb_size_width = ViewElementWintrackSettings.page_thumb_size[1]
	local thumb_offset = 10
	local total_width = 0
	local num_reward_pages = self._num_reward_pages
	local offset_x = -(num_reward_pages * page_thumb_size_width + (num_reward_pages - 1) * thumb_offset - page_thumb_size_width) * 0.5

	for i = 1, num_reward_pages do
		local widget = self:_create_widget("page_thumb_" .. i, widget_definition)

		widgets[i] = widget
		widget.offset[1] = offset_x
		offset_x = offset_x + page_thumb_size_width + thumb_offset
		total_width = total_width + page_thumb_size_width

		if i < num_reward_pages then
			total_width = total_width + thumb_offset
		end
	end

	self._page_tumb_widgets = widgets

	self:_set_scenegraph_size("page_thumb_indicator", total_width)
end

ViewElementWintrack._cb_on_page_indicator_pressed = function (self, index)
	return
end

ViewElementWintrack._set_page_indicator_focus = function (self, index)
	local page_tumb_widgets = self._page_tumb_widgets

	for i = 1, #page_tumb_widgets do
		local widget = page_tumb_widgets[i]

		widget.content.active = i == index
	end
end

ViewElementWintrack._setup_item_stats = function (self, reference_name, scenegraph_id)
	local layer = self._draw_layer + 50
	local title_height = 70
	local edge_padding = 12
	local grid_width = 530
	local grid_height = 840
	local grid_size = {
		grid_width - edge_padding,
		grid_height,
	}
	local grid_spacing = {
		0,
		0,
	}
	local mask_size = {
		grid_width + 40,
		grid_height,
	}
	local context = {
		ignore_blur = true,
		scrollbar_width = 7,
		grid_spacing = grid_spacing,
		grid_size = grid_size,
		mask_size = mask_size,
		title_height = title_height,
		edge_padding = edge_padding,
	}
	local scale = self:render_scale()
	local item_stats = ViewElementWeaponStats:new(self, layer, scale, context)

	return item_stats
end

ViewElementWintrack._update_item_stats_position = function (self, scenegraph_id, item_stats)
	local scale = self:render_scale() or 1
	local render_scale = item_stats:render_scale() or 1
	local scale_difference = math.round_with_precision(render_scale - scale, 3)
	local position = self:scenegraph_world_position(scenegraph_id)
	local length = item_stats:grid_length() or 0
	local menu_settings = item_stats:menu_settings()
	local grid_size = menu_settings.grid_size
	local edge_padding = menu_settings.edge_padding
	local grid_width = grid_size[1]

	item_stats:set_pivot_offset(position[1] - grid_size[1] * 0.5, position[2] - length)
end

ViewElementWintrack.currently_hovered_item = function (self)
	return self._currently_hovered_item
end

ViewElementWintrack._on_reward_items_hover_start = function (self, items, index, widget)
	index = index or 1

	if self._currently_hovered_item then
		self:_on_reward_items_hover_stop()
	end

	local item = items[index]

	self._currently_hovered_item = item
	self._currently_hovered_items = items
	self._currently_hovered_items_index = index
	self._currently_hovered_widget = widget

	local no_tooltip = widget and widget.content.element and widget.content.element.hide_tooltip

	if self._item_stats and item and not no_tooltip then
		local context = {
			hide_source = true,
			show_requirement = true,
			hide_description = item.item_type == "WEAPON_SKIN",
		}

		self._item_stats:present_item(item, context)
	end

	self:_update_reward_tooltip_hint()
end

ViewElementWintrack._on_reward_items_hover_stop = function (self)
	self._currently_hovered_item = nil
	self._currently_hovered_items = nil
	self._currently_hovered_items_index = nil
	self._currently_hovered_widget = nil

	self:_update_reward_tooltip_hint()

	if self._item_stats then
		self._item_stats:stop_presenting()
	end
end

ViewElementWintrack.focus_on_reward = function (self, index)
	local reward_item_widgets = self._reward_item_widgets

	if not reward_item_widgets then
		return
	end

	for i = 1, #reward_item_widgets do
		local widget = reward_item_widgets[i]
		local content = widget.content

		content.hotspot.is_selected = index == i

		local frame_widget = self._reward_widgets[i]
		local frame_content = frame_widget.content

		frame_content.hotspot.is_selected = index == i
	end

	self._currently_selected_index = index

	if not index then
		return self:_on_reward_items_hover_stop()
	end

	local widget = reward_item_widgets[index]
	local content = widget.content
	local element = content.element
	local items = element.items

	self:_on_reward_items_hover_start(items, index, widget)

	local rewards_per_page = self._hint_upcoming_page and self._num_rewards_per_bar - 1 or self._num_rewards_per_bar
	local reward_page_index = math.ceil(index / rewards_per_page)

	if reward_page_index ~= self._current_reward_page_index then
		self:_set_reward_page(reward_page_index, true)
	end
end

ViewElementWintrack.remove_focus_on_reward = function (self)
	local selected_index = self._currently_selected_index

	self:focus_on_reward(nil)

	self._currently_selected_index = selected_index
end

ViewElementWintrack.apply_focus_on_reward = function (self)
	local index = self._currently_selected_index or self._next_reward_to_claim or 1

	self:focus_on_reward(index)
end

ViewElementWintrack.tooltip_visible = function (self)
	return self._item_stats and self._item_stats:is_presenting()
end

return ViewElementWintrack
