-- chunkname: @scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_polling.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Colors = require("scripts/utilities/ui/colors")
local HudElementPlayerBuffsSettings = require("scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_settings")
local PlayerBuffDefinitions = require("scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_definitions")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local buff_categories = BuffSettings.buff_categories
local buff_category_order = BuffSettings.buff_category_order
local MAX_BUFFS = HudElementPlayerBuffsSettings.max_buffs
local HALF_MAX_BUFF = math.floor(MAX_BUFFS * 0.5)
local QUATER_MAX_BUFF = math.floor(MAX_BUFFS * 0.25)
local THREE_QUATER_MAX_BUFF = MAX_BUFFS - QUATER_MAX_BUFF
local HudElementPlayerBuffs = class("HudElementPlayerBuffs", "HudElementBase")

HudElementPlayerBuffs.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPlayerBuffs.super.init(self, parent, draw_layer, start_scale, PlayerBuffDefinitions)

	self._player = parent:player()
	self._active_buffs_data = {}
	self._active_positive_buffs = 0
	self._active_negative_buffs = 0

	self:_update_buff_alignments(true, 0)
end

HudElementPlayerBuffs.event_player_buff_proc_start = function (self, player, buff_instance)
	return
end

HudElementPlayerBuffs.event_player_buff_proc_stop = function (self, player, buff_instance)
	return
end

HudElementPlayerBuffs.event_player_buff_added = function (self, player, buff_instance)
	if not self._player or self._player ~= player then
		return
	end

	local add_buff = buff_instance:has_hud()

	if add_buff then
		self:_add_buff(buff_instance)
	end
end

HudElementPlayerBuffs.event_player_buff_removed = function (self, player, buff_instance)
	if not self._player or self._player ~= player then
		return
	end

	local active_buffs_data = self._active_buffs_data

	for i = 1, #active_buffs_data do
		local buff_data = active_buffs_data[i]

		if buff_data.buff_instance == buff_instance then
			self:_remove_buff_at_index(i)

			return
		end
	end
end

HudElementPlayerBuffs._sync_current_active_buffs = function (self, buffs)
	local active_buffs_data = self._active_buffs_data
	local num_active_buffs = #active_buffs_data

	if not buffs then
		return
	end

	for i = 1, #buffs do
		local buff = buffs[i]
		local add_buff = buff:has_hud()

		for j = num_active_buffs, 1, -1 do
			local buff_data = active_buffs_data[j]

			if buff_data.buff_instance == buff then
				add_buff = false

				break
			end
		end

		if add_buff then
			self:_add_buff(buff)
		end
	end
end

HudElementPlayerBuffs._add_buff = function (self, buff_instance)
	local active_buffs_data = self._active_buffs_data

	if #active_buffs_data >= MAX_BUFFS then
		return
	end

	local is_negative = buff_instance:is_negative()

	if is_negative then
		if self._active_negative_buffs >= QUATER_MAX_BUFF then
			return
		end

		self._active_negative_buffs = self._active_negative_buffs + 1
	else
		if self._active_positive_buffs >= THREE_QUATER_MAX_BUFF then
			return
		end

		self._active_positive_buffs = self._active_positive_buffs + 1
	end

	local buff_template = buff_instance and buff_instance:template()
	local buff_category = buff_template and buff_template.buff_category or buff_categories.generic
	local index = #active_buffs_data + 1

	self._active_buffs_data[index] = {
		is_active = false,
		buff_instance = buff_instance,
		is_negative = is_negative,
		activated_time = math.huge,
		start_index = index,
		buff_category = buff_category,
		buff_name = buff_template.name,
	}
end

HudElementPlayerBuffs._remove_buff_at_index = function (self, index)
	local active_buffs_data = self._active_buffs_data
	local buff_data = active_buffs_data[index]
	local is_negative = buff_data.is_negative

	if is_negative then
		self._active_negative_buffs = self._active_negative_buffs - 1
	else
		self._active_positive_buffs = self._active_positive_buffs - 1
	end

	buff_data.remove = true
end

HudElementPlayerBuffs._setup_buff_widget_array = function (self, ui_renderer)
	local buff_widgets_array = {}
	local widgets_by_name = self._widgets_by_name

	for i = 1, MAX_BUFFS do
		local buff_widget_name = "buff_" .. i
		local widget = widgets_by_name[buff_widget_name]

		buff_widgets_array[i] = widget

		for f = 1, #widget.passes do
			local pass_info = widget.passes[f]

			pass_info.retained_mode = self._use_retained_mode
		end

		self:_return_widget(widget, ui_renderer)
	end

	return buff_widgets_array
end

HudElementPlayerBuffs._get_available_widget = function (self)
	local buff_widgets_array = self._buff_widgets_array

	for i = 1, #buff_widgets_array do
		local widget = buff_widgets_array[i]
		local content = widget.content

		if not content.taken then
			content.taken = true
			content.visible = true
			widget.visible = true
			widget.initialize_offset = true

			return widget
		end
	end

	return nil
end

HudElementPlayerBuffs._return_widget = function (self, widget, ui_renderer)
	if not widget then
		return nil
	end

	self:_set_widget_state_colors(widget, false, false)

	widget.dirty = true
	widget.offset[1] = 0
	widget.offset[2] = 0
	widget.visible = false
	widget.initialize_offset = false

	local content = widget.content

	content.taken = false
	content.visible = false
	content.text = nil
	content.duration_progress = 1
	content.opacity = 1

	local style = widget.style

	style.icon.material_values.talent_icon = nil
	style.icon.material_values.gradient_map = nil
	style.text_background.size[1] = 0

	local text_style = style.text

	text_style.size[1] = 0

	UIWidget.set_visible(widget, ui_renderer, false)

	return widget
end

local RESERVED_SPOTS = {
	[buff_categories.generic] = 0,
	[buff_categories.talents] = 0,
	[buff_categories.weapon_traits] = 0,
}
local GAP_OFFSET_SIZE = 0.5
local _number_of_buffs_per_category = {}
local _category_offsets = {}
local _category_numbers = {}

local function _use_categories()
	local save_manager = Managers.save
	local group_buff_icon_in_categories = false

	if save_manager then
		local account_data = save_manager:account_data()

		group_buff_icon_in_categories = account_data.interface_settings.group_buff_icon_in_categories
	end

	return group_buff_icon_in_categories
end

local function _show_aura_category()
	local save_manager = Managers.save
	local show_aura_buff_icons = true

	if save_manager then
		local account_data = save_manager:account_data()

		show_aura_buff_icons = account_data.interface_settings.show_aura_buff_icons
	end

	return show_aura_buff_icons
end

HudElementPlayerBuffs._update_buff_alignments = function (self, force_update, dt)
	local active_buffs_data = self._active_buffs_data
	local num_active_buffs = #active_buffs_data
	local horizontal_spacing = HudElementPlayerBuffsSettings.horizontal_spacing
	local previous_positive_buff_offset = 0
	local previous_negative_buff_offset = 0
	local num_aligned_positive_buffs = 0
	local num_aligned_negative_buffs = 0
	local use_categories = _use_categories()

	if use_categories then
		table.clear(_number_of_buffs_per_category)

		for i = 1, num_active_buffs do
			local buff_data = active_buffs_data[i]
			local buff_category = buff_data.buff_category or buff_categories.generic

			if buff_data.show and not buff_data.is_negative then
				_number_of_buffs_per_category[buff_category] = (_number_of_buffs_per_category[buff_category] or 0) + 1
			end
		end

		table.clear(_category_offsets)
		table.clear(_category_numbers)

		local current_number = 0

		for inxed, buff_category in ipairs(buff_category_order) do
			local number_in_category = math.max(_number_of_buffs_per_category[buff_category] or 0, RESERVED_SPOTS[buff_category] or 0)

			_category_offsets[buff_category] = current_number * horizontal_spacing
			_category_numbers[buff_category] = current_number
			current_number = current_number + number_in_category + (number_in_category > 0 and GAP_OFFSET_SIZE or 0)
		end
	end

	for i = 1, num_active_buffs do
		local buff_data = active_buffs_data[i]
		local buff_category = buff_data.buff_category or buff_categories.generic.generic
		local is_negative = buff_data.is_negative
		local previous_buff_offset = is_negative and previous_negative_buff_offset or previous_positive_buff_offset
		local num_aligned_category_buffs = is_negative and num_aligned_negative_buffs or use_categories and (_category_numbers[buff_category] or 0) or num_aligned_positive_buffs
		local widget = buff_data.widget

		if widget then
			local offset = widget.offset

			offset[2] = is_negative and -42 or 0

			local old_horizontal_offset = offset[1]
			local target_x = horizontal_spacing * num_aligned_category_buffs

			if force_update then
				offset[1] = target_x
				widget.dirty = true
			else
				local initialize_offset = widget.initialize_offset
				local content = widget.content

				if initialize_offset then
					widget.initialize_offset = nil
					offset[1] = target_x + horizontal_spacing
					content.opacity = 0
				else
					offset[1] = math.lerp(old_horizontal_offset, target_x, dt * 6)
					content.opacity = math.lerp(content.opacity, 1, dt * 4)
				end
			end

			if is_negative then
				previous_negative_buff_offset = offset[1]
				num_aligned_negative_buffs = num_aligned_negative_buffs + 1
			elseif use_categories then
				_category_offsets[buff_category] = offset[1]
				_category_numbers[buff_category] = (_category_numbers[buff_category] or 0) + 1
			else
				previous_positive_buff_offset = offset[1]
				num_aligned_positive_buffs = num_aligned_positive_buffs + 1
			end

			if old_horizontal_offset ~= offset[1] then
				widget.dirty = true
			end
		end
	end
end

local function _compare_buffs(a, b)
	if a.activated_time == b.activated_time then
		if a.hud_priority ~= b.hud_priority then
			if a.hud_priority and not b.hud_priority then
				return true
			end

			if not a.hud_priority and b.hud_priority then
				return false
			end

			return a.hud_priority < b.hud_priority
		end

		return a.start_index < b.start_index
	end

	return a.activated_time < b.activated_time
end

HudElementPlayerBuffs._update_buffs = function (self, t, ui_renderer)
	local active_buffs_data = self._active_buffs_data
	local show_aura_category = _show_aura_category()

	for i = 1, #active_buffs_data do
		repeat
			local buff_data = active_buffs_data[i]
			local buff_instance = buff_data.buff_instance
			local widget = buff_data.widget

			if buff_data.remove then
				if widget then
					buff_data.widget = nil
					buff_data.icon = nil
					buff_data.icon_gradient_map = nil
					buff_data.stack_count = nil
					buff_data.activated_time = math.huge

					self:_return_widget(widget, ui_renderer)
				end

				break
			end

			local buff_hud_data = buff_instance:get_hud_data()
			local buff_template = buff_instance:template()
			local buff_category = buff_template.buff_category
			local show_category = buff_category ~= buff_categories.aura or show_aura_category
			local show = buff_hud_data.show and show_category
			local is_active = buff_hud_data.is_active
			local icon = buff_hud_data.hud_icon
			local icon_gradient_map = buff_hud_data.hud_icon_gradient_map
			local hud_priority = buff_hud_data.hud_priority
			local stack_count = buff_hud_data.stack_count
			local show_stack_count = buff_hud_data.show_stack_count
			local is_negative = buff_hud_data.is_negative
			local force_negative_frame = buff_hud_data.force_negative_frame
			local duration_progress = buff_hud_data.duration_progress

			buff_data.show = show
			buff_data.hud_priority = hud_priority

			if show then
				if not widget then
					widget = self:_get_available_widget()
					buff_data.widget = widget
					buff_data.activated_time = t

					self:_set_widget_state_colors(widget, is_negative or force_negative_frame, is_active)
					UIWidget.set_visible(widget, ui_renderer, true)
				end
			else
				if widget then
					buff_data.widget = nil
					buff_data.icon = nil
					buff_data.icon_gradient_map = nil
					buff_data.stack_count = nil
					buff_data.activated_time = math.huge

					self:_return_widget(widget, ui_renderer)
				end

				break
			end

			local content = widget.content
			local style = widget.style

			if icon ~= buff_data.icon or buff_data.icon == nil then
				style.icon.material_values.talent_icon = icon
				style.icon.material_values.gradient_map = icon_gradient_map
				buff_data.icon = icon
				widget.dirty = true
			end

			content.previous_duration_progress = content.duration_progress

			if duration_progress ~= buff_data.duration_progress then
				buff_data.duration_progress = duration_progress

				if duration_progress == 0 then
					duration_progress = 1
				end

				content.duration_progress = duration_progress

				if content.duration_progress ~= content.previous_duration_progress then
					widget.dirty = true
				end
			end

			if stack_count ~= buff_data.stack_count or buff_data.stack_count == nil then
				content.text = show_stack_count and tostring(stack_count) or nil

				local text_style = style.text

				if content.text and content.text ~= "" then
					local buff_size = widget.size or {
						38,
						38,
					}
					local text_font_options = UIFonts.get_font_options_by_style(text_style)
					local text_width, text_height = UIRenderer.text_size(ui_renderer, content.text, text_style.font_type, text_style.font_size, buff_size, text_font_options)
					local text_margin = 5
					local total_width = text_margin + text_width

					style.text_background.size[1] = total_width
					text_style.size[1] = total_width
				else
					style.text_background.size[1] = 0
					text_style.size[1] = 0
				end

				buff_data.stack_count = stack_count
				widget.dirty = true
			end

			if is_active ~= buff_data.is_active or buff_data.is_active == nil or is_negative ~= buff_data.is_negative or buff_data.is_negative == nil or force_negative_frame ~= buff_data.force_negative_frame then
				self:_set_widget_state_colors(widget, is_negative or force_negative_frame, is_active)

				widget.dirty = true
				buff_data.is_active = is_active
				buff_data.is_negative = is_negative
				buff_data.force_negative_frame = force_negative_frame
			end
		until true
	end

	table.sort(active_buffs_data, _compare_buffs)
end

HudElementPlayerBuffs._set_widget_state_colors = function (self, widget, is_negative, is_active)
	local source_colors

	if not is_active then
		source_colors = HudElementPlayerBuffsSettings.inactive_colors
	elseif is_negative then
		source_colors = HudElementPlayerBuffsSettings.negative_colors
	else
		source_colors = HudElementPlayerBuffsSettings.positive_colors
	end

	local style = widget.style

	for pass_id, pass_style in pairs(style) do
		local source_color = source_colors[pass_id]

		if source_color and not pass_style.text_color then
			Colors.color_copy(source_color, pass_style.color)
		end
	end

	widget.dirty = true
end

HudElementPlayerBuffs.destroy = function (self, ui_renderer)
	if self._syncronized then
		self:_unregister_events()

		self._syncronized = nil
	end

	HudElementPlayerBuffs.super.destroy(self, ui_renderer)
end

HudElementPlayerBuffs.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	self._use_retained_mode = use_retained_mode

	if use_retained_mode then
		if visible then
			self:set_dirty()
		else
			self:_destroy_widgets(ui_renderer)
		end
	end

	if self._buff_widgets_array then
		for i = 1, #self._buff_widgets_array do
			local widget = self._buff_widgets_array[i]

			for f = 1, #widget.passes do
				local pass_info = widget.passes[f]

				pass_info.retained_mode = use_retained_mode
			end
		end
	end
end

HudElementPlayerBuffs._destroy_widgets = function (self, ui_renderer)
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		UIWidget.destroy(ui_renderer, widget)
	end
end

HudElementPlayerBuffs.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerBuffs.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._syncronized then
		self:_update_buffs(t, ui_renderer)
		self:_update_buff_alignments(false, dt)

		local active_buffs_data = self._active_buffs_data

		if active_buffs_data then
			for i = 1, #active_buffs_data do
				local buff_data = active_buffs_data[i]

				if buff_data and buff_data.remove == true then
					table.remove(active_buffs_data, i)
				end
			end
		end
	else
		self._buff_widgets_array = self:_setup_buff_widget_array(ui_renderer)

		local extensions = self._parent:player_extensions()
		local buff_extension = extensions and extensions.buff

		if buff_extension then
			local buffs = buff_extension:buffs()

			self:_sync_current_active_buffs(buffs)
			self:_register_events()

			self._syncronized = true
		end
	end
end

HudElementPlayerBuffs.event_present_new_area = function (self, area_id)
	if self._popup_animation_id then
		table.insert(self._area_notificaction_id_queue, 1, area_id)
	else
		self:_present_new_area(area_id)
	end
end

HudElementPlayerBuffs._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._syncronized then
		return
	end

	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		if widget.dirty then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementPlayerBuffs._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerBuffsSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPlayerBuffs._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerBuffsSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPlayerBuffs
