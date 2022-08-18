local Definitions = require("scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_definitions")
local HudElementPlayerBuffsSettings = require("scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MAX_BUFFS = HudElementPlayerBuffsSettings.max_buffs
local HudElementPlayerBuffs = class("HudElementPlayerBuffs", "HudElementBase")

HudElementPlayerBuffs.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPlayerBuffs.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._player = parent:player()
	self._active_buffs_data = {}
	self._active_positive_buffs = 0
	self._active_negative_buffs = 0
	self._buff_widgets_array = self:_setup_buff_widget_array()

	self:_update_buff_alignments(true)
end

HudElementPlayerBuffs.event_player_buff_added = function (self, player, buff_instance)
	if not self._player or self._player ~= player then
		return
	end

	local add_buff = buff_instance:show_in_hud()

	if add_buff then
		self:_add_buff(buff_instance)
	end
end

HudElementPlayerBuffs.event_player_buff_removed = function (self, player, buff_instance)
	if not self._player or self._player ~= player then
		return
	end

	local active_buffs_data = self._active_buffs_data

	for i = 1, #active_buffs_data, 1 do
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

	for i = 1, #buffs, 1 do
		local buff = buffs[i]
		local add_buff = buff:show_in_hud()

		for j = num_active_buffs, 1, -1 do
			local buff_data = num_active_buffs[j]

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

	if MAX_BUFFS <= #active_buffs_data then
		return
	end

	local is_negative = buff_instance:is_negative()
	local half_max_buff_amount = math.floor(MAX_BUFFS * 0.5)

	if is_negative then
		if self._active_negative_buffs == half_max_buff_amount then
			return
		end

		self._active_negative_buffs = self._active_negative_buffs + 1
	else
		if self._active_positive_buffs == half_max_buff_amount then
			return
		end

		self._active_positive_buffs = self._active_positive_buffs + 1
	end

	local widget = self:_get_available_widget()
	self._active_buffs_data[#active_buffs_data + 1] = {
		widget = widget,
		buff_instance = buff_instance,
		is_negative = is_negative
	}
	widget.initialize_offset = true
	widget.dirty = true
end

HudElementPlayerBuffs._remove_buff_at_index = function (self, index)
	local active_buffs_data = self._active_buffs_data
	local is_negative = active_buffs_data.is_negative

	if is_negative then
		self._active_negative_buffs = self._active_negative_buffs - 1
	else
		self._active_positive_buffs = self._active_positive_buffs - 1
	end

	local buff_data = table.remove(active_buffs_data, index)
	local widget = buff_data.widget
	local content = widget.content
	content.taken = false
	content.visible = false
	widget.dirty = true
end

HudElementPlayerBuffs._get_available_widget = function (self)
	local buff_widgets_array = self._buff_widgets_array

	for i = 1, #buff_widgets_array, 1 do
		local widget = buff_widgets_array[i]
		local content = widget.content

		if not content.taken then
			content.taken = true
			content.visible = true

			return widget
		end
	end
end

HudElementPlayerBuffs._setup_buff_widget_array = function (self)
	local buff_widgets_array = {}
	local widgets_by_name = self._widgets_by_name

	for i = 1, MAX_BUFFS, 1 do
		local buff_widget_name = "buff_" .. i
		local widget = widgets_by_name[buff_widget_name]
		buff_widgets_array[i] = widget
		widget.content.visible = false
	end

	return buff_widgets_array
end

HudElementPlayerBuffs._update_buff_alignments = function (self, force_update)
	local active_buffs_data = self._active_buffs_data
	local num_active_buffs = #active_buffs_data
	local horizontal_spacing = HudElementPlayerBuffsSettings.horizontal_spacing
	local previous_positive_buff_offset = 0
	local previous_negative_buff_offset = 0
	local num_aligned_positive_buffs = 0
	local num_aligned_negative_buffs = 0

	for i = 1, num_active_buffs, 1 do
		local buff_data = active_buffs_data[i]
		local is_negative = buff_data.is_negative
		local previous_buff_offset = (is_negative and previous_negative_buff_offset) or previous_positive_buff_offset
		local num_aligned_category_buffs = (is_negative and num_aligned_negative_buffs) or num_aligned_positive_buffs
		local widget = buff_data.widget
		local offset = widget.offset
		offset[2] = (is_negative and -42) or 0
		local old_horizontal_offset = offset[1]
		local target_x = horizontal_spacing * num_aligned_category_buffs

		if force_update then
			offset[1] = target_x
			widget.dirty = true
		else
			local initialize_offset = widget.initialize_offset

			if initialize_offset then
				widget.initialize_offset = nil

				if i > 1 then
					offset[1] = previous_buff_offset + horizontal_spacing
				end
			else
				offset[1] = math.lerp(offset[1], target_x, 0.1)
			end
		end

		if is_negative then
			previous_negative_buff_offset = offset[1]
			num_aligned_negative_buffs = num_aligned_negative_buffs + 1
		else
			previous_positive_buff_offset = offset[1]
			num_aligned_positive_buffs = num_aligned_positive_buffs + 1
		end

		if old_horizontal_offset ~= offset[1] then
			widget.dirty = true
		end
	end
end

HudElementPlayerBuffs._update_buffs = function (self)
	local active_buffs_data = self._active_buffs_data

	for i = 1, #active_buffs_data, 1 do
		local buff_data = active_buffs_data[i]
		local buff_instance = buff_data.buff_instance

		if buff_instance then
			local widget = buff_data.widget
			local content = widget.content
			local style = widget.style
			local duration_progress = buff_instance:duration_progress()
			local icon = buff_instance:hud_icon()
			local inactive = buff_instance:inactive()
			local is_negative = buff_instance:is_negative()
			local stack_count = buff_instance:visual_stack_count()

			if icon ~= buff_data.icon or buff_data.icon == nil then
				style.icon.material_values.talent_icon = icon
				buff_data.icon = icon
				widget.dirty = true
			end

			content.previous_duration_progress = content.duration_progress

			if duration_progress ~= buff_data.duration_progress then
				if duration_progress == 0 then
					duration_progress = 1
				end

				content.duration_progress = duration_progress
				buff_data.duration_progress = duration_progress

				if content.duration_progress ~= content.previous_duration_progress then
					widget.dirty = true
				end
			end

			if stack_count ~= buff_data.stack_count or buff_data.stack_count == nil then
				content.text = (stack_count and stack_count > 1 and tostring(stack_count)) or nil
				buff_data.stack_count = stack_count
				widget.dirty = true
			end

			local buff_inactive = buff_data.inactive
			local buff_negative = buff_data.is_negative

			if inactive ~= buff_data.inactive or buff_data.inactive == nil or is_negative ~= buff_data.is_negative or buff_data.is_negative == nil then
				buff_data.inactive = inactive
				buff_data.is_negative = is_negative

				self:_set_widget_state_colors(widget, is_negative, inactive)
			end
		end
	end
end

HudElementPlayerBuffs._set_widget_state_colors = function (self, widget, is_negative, is_inactive)
	local source_colors = nil

	if is_inactive then
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
			ColorUtilities.color_copy(source_color, pass_style.color)
		end
	end

	widget.dirty = true
end

HudElementPlayerBuffs.destroy = function (self)
	if self._syncronized then
		self:_unregister_events()

		self._syncronized = nil
	end

	HudElementPlayerBuffs.super.destroy(self)
end

HudElementPlayerBuffs.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerBuffs.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._syncronized then
		self:_update_buff_alignments()
		self:_update_buffs()
	else
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

	for i = 1, num_widgets, 1 do
		local widget = widgets[i]

		if widget.dirty then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementPlayerBuffs._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerBuffsSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPlayerBuffs._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerBuffsSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPlayerBuffs
