-- chunkname: @scripts/ui/constant_elements/elements/subtitles/constant_element_subtitles.lua

local Definitions = require("scripts/ui/constant_elements/elements/subtitles/constant_element_subtitles_definitions")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local ConstantElementSubtitlesSettings = require("scripts/ui/constant_elements/elements/subtitles/constant_element_subtitles_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Views = require("scripts/ui/views/views")
local debug_subtitles = {
	{
		text = "{#color(255,0,0)}Sgt.Morrow:{#color(255,242,230)} This is a placeholder subtitle line 1 This is a placeholder subtitle line 1",
		duration = 2
	},
	{
		text = "{#color(255,0,0)}Sgt.Morrow:{#color(255,242,230)} This is a placeholder subtitle line 2 This is a placeholder subtitle line 2",
		duration = 2
	},
	{
		text = "{#color(255,0,0)}Sgt.Morrow:{#color(255,242,230)} This is a placeholder subtitle line 3 This is a placeholder subtitle line 3",
		duration = 2
	},
	{
		text = "{#color(255,0,0)}Sgt.Morrow:{#color(255,242,230)} This is a placeholder subtitle line 4 This is a placeholder subtitle line 4",
		duration = 2
	}
}
local DUMMY_MEASURE_TEXT_LINE = "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
local ConstantElementSubtitles = class("ConstantElementSubtitles", "ConstantElementBase")

ConstantElementSubtitles.init = function (self, parent, draw_layer, start_scale)
	ConstantElementSubtitles.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._line_queue = {}
	self._letterbox_widget = self:_create_widget("letterbox", Definitions.letterbox_definition)
	self._letterbox_lines_width = {}
	self._secondary_letterbox_lines_width = {}

	self:_initialize_settings()
	self:_register_events()
end

ConstantElementSubtitles.event_player_authenticated = function (self)
	self:_initialize_settings()
end

ConstantElementSubtitles._initialize_settings = function (self)
	self._settings_initialized = true

	self:_setup_font_size()
	self:_setup_secondary_font_size()
	self:_setup_text_opacity()
	self:_setup_letterbox()
	self:_setup_subtitles_enabled()
	self:_setup_secondary_subtitles_enabled()
	self:_setup_subtitle_speaker_enabled()
end

ConstantElementSubtitles.event_update_subtitles_enabled = function (self)
	self:_setup_subtitles_enabled()
end

ConstantElementSubtitles.event_update_secondary_subtitles_enabled = function (self)
	self:_setup_secondary_subtitles_enabled()
end

ConstantElementSubtitles.event_update_subtitle_text_opacity = function (self)
	self:_setup_text_opacity()
end

ConstantElementSubtitles.event_update_subtitles_font_size = function (self)
	self:_setup_font_size()
end

ConstantElementSubtitles.event_update_secondary_subtitles_font_size = function (self)
	self:_setup_secondary_font_size()
end

ConstantElementSubtitles.event_update_subtitle_speaker_enabled = function (self)
	self:_setup_subtitle_speaker_enabled()
end

ConstantElementSubtitles.event_update_subtitles_background_opacity = function (self)
	self:_setup_letterbox()
end

ConstantElementSubtitles._setup_subtitles_enabled = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local subtitle_enabled = interface_settings.subtitle_enabled

	self._subtitle_enabled = subtitle_enabled
end

ConstantElementSubtitles._setup_font_size = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local font_size = interface_settings.subtitle_font_size

	self:_set_font_size(font_size)

	if self._line_duration then
		local widgets_by_name = self._widgets_by_name
		local widget = widgets_by_name.subtitles
		local content = widget.content
		local text = content.text or ""
		local duration = self._line_duration or 0

		self:_display_text_line(text, duration)
		self:_update_letterbox_size()
	end
end

ConstantElementSubtitles._setup_secondary_subtitles_enabled = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local secondary_subtitle_enabled = interface_settings.secondary_subtitle_enabled

	self._secondary_subtitle_enabled = secondary_subtitle_enabled
end

ConstantElementSubtitles._setup_secondary_font_size = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local font_size = interface_settings.secondary_subtitle_font_size

	self:_set_secondary_font_size(font_size)

	if self._secondary_letterbox_added then
		self:_display_text_line("", nil, true)
	end
end

ConstantElementSubtitles._update_letterbox_size = function (self)
	local letterbox_lines_width = self._letterbox_lines_width

	if letterbox_lines_width then
		local num_lines = #letterbox_lines_width
		local text_height = self._letterbox_height or 0

		for i = 1, num_lines do
			local width = letterbox_lines_width[i]
			local widget = self._letterbox_widget
			local rect_size = widget.style.rect.size

			rect_size[1] = width
			rect_size[2] = text_height
		end
	end
end

ConstantElementSubtitles._setup_letterbox = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local subtitle_background_opacity = interface_settings.subtitle_background_opacity
	local subtitle_background_enabled = subtitle_background_opacity > 0
	local alpha = subtitle_background_enabled and 255 * (subtitle_background_opacity * 0.01) or nil

	self:_set_letterbox_opacity(alpha)
end

ConstantElementSubtitles._setup_text_opacity = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local subtitle_text_opacity = interface_settings.subtitle_text_opacity or 100
	local alpha = 255 * (subtitle_text_opacity * 0.01)

	self:_set_text_opacity(alpha)
end

ConstantElementSubtitles._setup_subtitle_speaker_enabled = function (self)
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local subtitle_speaker_enabled = interface_settings.subtitle_speaker_enabled

	self._subtitle_speaker_enabled = subtitle_speaker_enabled

	if self._line_duration then
		local widgets_by_name = self._widgets_by_name
		local widget = widgets_by_name.subtitles
		local content = widget.content
		local text = content.text or ""
		local duration = self._line_duration or 0

		self:_display_text_line(text, duration)
		self:_update_letterbox_size()
	end
end

ConstantElementSubtitles._set_text_opacity = function (self, alpha)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.subtitles
	local style = widget.style
	local text_style = style.text

	text_style.text_color[1] = alpha or 0

	local secondary_widget = widgets_by_name.secondary_subtitles
	local secondary_style = secondary_widget.style
	local secondary_text_style = secondary_style.text

	secondary_text_style.text_color[1] = alpha or 0
end

ConstantElementSubtitles._set_letterbox_opacity = function (self, alpha)
	local widget = self._letterbox_widget

	widget.style.rect.color[1] = alpha or 0
	self._draw_letterbox = alpha ~= nil
end

ConstantElementSubtitles.destroy = function (self)
	self:_unregister_events()
	ConstantElementSubtitles.super.destroy(self)
end

ConstantElementSubtitles._debug_add_subtitle_lines = function (self)
	for i = 1, #debug_subtitles do
		local line_data = debug_subtitles[i]

		self:_debug_trigger_subtitle(line_data.text, line_data.duration)
	end
end

local subtitle_format_context = {
	speaker = "n/a",
	subtitle = "n/a"
}

ConstantElementSubtitles._get_active_dialogue_system = function (self)
	local ui_manager = Managers.ui
	local active_views = ui_manager:active_views()
	local num_views = #active_views

	if num_views > 0 then
		for i = 1, num_views do
			local view_name = active_views[i]
			local view = ui_manager:view_instance(view_name)

			if view and view.dialogue_system then
				local state_managers = Managers.state

				if state_managers then
					local extension_manager = state_managers.extension
					local system_name = "dialogue_system"
					local world_dialogue_system = extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
					local view_dialogue_system = view:dialogue_system()

					if world_dialogue_system and world_dialogue_system ~= view_dialogue_system then
						world_dialogue_system:force_stop_all()
					end
				end

				return view:dialogue_system()
			end
		end
	end

	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension
		local system_name = "dialogue_system"

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

ConstantElementSubtitles.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	ConstantElementSubtitles.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local dialogue_system = self:_get_active_dialogue_system()

	if not dialogue_system then
		if self._line_currently_playing then
			self:_display_text_line("", nil)

			self._line_currently_playing = nil
		end

		return
	end

	local dialogue_system_subtitle = dialogue_system:dialogue_system_subtitle()
	local is_dialogue_playing = dialogue_system_subtitle:is_audible_localized_dialogue_playing()
	local playing_dialogues_array = is_dialogue_playing and dialogue_system_subtitle:playing_audible_localized_dialogues_array()
	local currently_playing = playing_dialogues_array and playing_dialogues_array[#playing_dialogues_array]

	if currently_playing then
		local new_main_subtitle = self:_add_subtitle(currently_playing)

		if self._secondary_subtitle_enabled then
			local num_playing_dialogues = #playing_dialogues_array
			local currently_playing_secondary = num_playing_dialogues > 1 and playing_dialogues_array[num_playing_dialogues - 1]

			if currently_playing_secondary then
				local previously_playing_secondary = self._secondary_line_currently_playing

				if currently_playing_secondary ~= previously_playing_secondary then
					if not new_main_subtitle then
						self:_remove_secondary_letterbox()
					end

					self._secondary_letterbox_added = false
				end

				self:_add_subtitle(currently_playing_secondary, true)

				self._secondary_line_currently_playing = currently_playing_secondary
			else
				self:_remove_secondary_letterbox()
				self:_display_text_line("", nil, true)

				self._secondary_letterbox_added = false
			end
		end
	elseif self._line_currently_playing then
		self:_display_text_line("", nil)
		self:_display_text_line("", nil, true)

		self._line_currently_playing = nil
	end

	if self._line_duration then
		local line_duration = self._line_duration - dt

		if line_duration <= 0 then
			self._line_duration = nil

			if #self._line_queue > 0 then
				local subtitle_data = table.remove(self._line_queue, #self._line_queue)
				local text = subtitle_data.text
				local duration = subtitle_data.duration

				self:_display_text_line(text, duration)
			end
		else
			self._line_duration = line_duration
		end
	end
end

ConstantElementSubtitles._add_subtitle = function (self, currently_playing, secondary_subtitle)
	local currently_playing_subtitle = currently_playing.currently_playing_subtitle

	if currently_playing_subtitle ~= self._line_currently_playing then
		if not secondary_subtitle then
			self._line_currently_playing = currently_playing_subtitle
		end

		local player
		local currently_playing_unit = currently_playing.currently_playing_unit

		if currently_playing_unit then
			local state_manager = Managers.state
			local player_unit_spawn_manager = state_manager and state_manager.player_unit_spawn

			player = player_unit_spawn_manager and player_unit_spawn_manager:is_player_unit(currently_playing_unit) and player_unit_spawn_manager:owner(currently_playing_unit)
		end

		local subtitle_format = "loc_subtitle_speaker_format"
		local speaker_display_name

		if player then
			local player_slot = player and player.slot and player:slot()

			if player_slot <= 4 then
				subtitle_format = subtitle_format .. "_player_slot_" .. player_slot
			end
		end

		if player and player:is_human_controlled() then
			speaker_display_name = player:name()
		else
			local speaker_name = currently_playing.speaker_name

			if speaker_name then
				local speaker_voice_settings = DialogueSpeakerVoiceSettings[speaker_name]
				local character_short_name = speaker_voice_settings.short_name

				speaker_display_name = self:_localize(character_short_name)
			else
				subtitle_format = "loc_subtitle_speaker_format_speakerless"
			end
		end

		local no_cache = true
		local currently_playing_subtitle_localized = self:_localize(currently_playing_subtitle, no_cache)

		subtitle_format_context.speaker = speaker_display_name
		subtitle_format_context.subtitle = currently_playing_subtitle_localized

		if not self._subtitle_speaker_enabled then
			subtitle_format = "loc_subtitle_speaker_format_speakerless"
			subtitle_format_context.speaker = nil
		end

		local string_exists = Managers.localization:exists(currently_playing_subtitle)

		if not string_exists then
			self:_display_text_line("", nil)

			self._line_currently_playing = nil
		else
			currently_playing_subtitle_localized = self:_localize(subtitle_format, no_cache, subtitle_format_context)

			self:_display_text_line(currently_playing_subtitle_localized, nil, secondary_subtitle)
		end

		return true
	end
end

ConstantElementSubtitles._remove_secondary_letterbox = function (self)
	local num_letterbox_lines = #self._letterbox_lines_width
	local num_secondary_letterbox_lines = #self._secondary_letterbox_lines_width
	local secondary_start = num_letterbox_lines - num_secondary_letterbox_lines + 1

	for i = num_letterbox_lines, secondary_start, -1 do
		if num_secondary_letterbox_lines ~= num_letterbox_lines then
			table.remove(self._letterbox_lines_width, i)
		end
	end
end

ConstantElementSubtitles._debug_trigger_subtitle = function (self, text, duration)
	if self._line_duration then
		table.insert(self._line_queue, 1, {
			text = text,
			duration = duration
		})
	else
		self:_display_text_line(text, duration)
		self:_display_text_line("", nil, true)
	end
end

local dummy_text_size = {
	2000,
	20
}

ConstantElementSubtitles._set_font_size = function (self, new_size)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.subtitles
	local style = widget.style
	local text_style = style.text

	text_style.font_size = new_size

	local parent = self._parent
	local ui_renderer = parent:ui_renderer()
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_width, text_height, _, _ = UIRenderer.text_size(ui_renderer, DUMMY_MEASURE_TEXT_LINE, text_style.font_type, text_style.font_size, dummy_text_size, text_options)

	text_style.size[1] = text_width
	text_style.size[2] = text_height
end

ConstantElementSubtitles._set_secondary_font_size = function (self, new_size)
	local widgets_by_name = self._widgets_by_name
	local secondary_widget = widgets_by_name.secondary_subtitles
	local secondary_style = secondary_widget.style
	local secondary_text_style = secondary_style.text

	secondary_text_style.font_size = new_size

	local parent = self._parent
	local ui_renderer = parent:ui_renderer()
	local secondary_text_options = UIFonts.get_font_options_by_style(secondary_text_style)
	local secondary_text_width, secondary_text_height, _, _ = UIRenderer.text_size(ui_renderer, DUMMY_MEASURE_TEXT_LINE, secondary_text_style.font_type, secondary_text_style.font_size, dummy_text_size, secondary_text_options)

	secondary_text_style.size[1] = secondary_text_width
	secondary_text_style.size[2] = secondary_text_height
end

ConstantElementSubtitles._display_text_line = function (self, text, duration, secondary_subtitle)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.subtitles

	if secondary_subtitle then
		widget = widgets_by_name.secondary_subtitles

		if text == "" then
			self._secondary_line_currently_playing = nil
		end

		self._secondary_line_duration = duration
	else
		self._line_duration = duration
	end

	local content = widget.content

	content.text = text

	local parent = self._parent
	local ui_renderer = parent:ui_renderer()
	local style = widget.style
	local text_style = style.text
	local text_width = text_style.size[1]
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local rows = UIRenderer.word_wrap(ui_renderer, text, text_style.font_type, text_style.font_size, text_width)
	local total_height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, text_style.size, text_options)

	if not secondary_subtitle then
		table.clear(self._letterbox_lines_width)
	else
		table.clear(self._secondary_letterbox_lines_width)
	end

	local text_max_height = 0
	local num_rows = #rows

	for i = 1, num_rows do
		local text_line = rows[i]
		local line_text_width, _, _, _ = UIRenderer.text_size(ui_renderer, text_line, text_style.font_type, text_style.font_size, dummy_text_size, text_options)
		local line_height = UIRenderer.text_height(ui_renderer, text_line, text_style.font_type, text_style.font_size, dummy_text_size, text_options)

		if not secondary_subtitle then
			self._letterbox_lines_width[i] = line_text_width + 20
		else
			self._secondary_letterbox_lines_width[i] = line_text_width + 20
		end

		if text_max_height < line_height then
			text_max_height = line_height

			if not secondary_subtitle then
				self._subtitle_text_max_height = text_max_height
			end
		end
	end

	if secondary_subtitle and not self._secondary_letterbox_added then
		local subtitle_text_max_height = self._subtitle_text_max_height or 0
		local subtitle_total_height = subtitle_text_max_height * #self._letterbox_lines_width
		local secondary_subtitle_total_height = text_max_height * #self._secondary_letterbox_lines_width

		text_style.offset[2] = subtitle_total_height / 2 + secondary_subtitle_total_height / 2

		table.append(self._letterbox_lines_width, self._secondary_letterbox_lines_width)

		self._secondary_letterbox_added = true
	end

	local letterbox_total_height = math.ceil(total_height)
	local letterbox_height = math.ceil(text_max_height)
	local total_spacing = math.max(letterbox_total_height - letterbox_height * num_rows, 0)
	local letterbox_spacing = total_spacing > 0 and total_spacing / num_rows or 0

	if not secondary_subtitle then
		self._letterbox_height = letterbox_height
		self._letterbox_spacing = letterbox_spacing
	else
		self._secondary_letterbox_height = letterbox_height
		self._secondary_letterbox_spacing = letterbox_spacing
	end
end

ConstantElementSubtitles._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._subtitle_enabled then
		return
	end

	if not self._line_duration and not self._line_currently_playing then
		return
	end

	if self._draw_letterbox then
		local letterbox_lines_width = self._letterbox_lines_width
		local num_lines = #letterbox_lines_width
		local line_spacing = self._letterbox_spacing or 0
		local text_height = self._letterbox_height or 0
		local start_offset = -((num_lines - 1) * (text_height + line_spacing)) * 0.5
		local secondary_letterbox_lines_width = self._secondary_letterbox_lines_width
		local num_secondary_lines = #secondary_letterbox_lines_width
		local secondary_line_spacing = self._secondary_letterbox_spacing or 0
		local secondary_text_height = self._secondary_letterbox_height or 0
		local secondary_i_start = num_lines - num_secondary_lines

		if self._secondary_letterbox_added then
			start_offset = start_offset + num_secondary_lines * (text_height + secondary_line_spacing) * 0.5
		end

		for i = 1, num_lines do
			local width = letterbox_lines_width[i]
			local widget = self._letterbox_widget
			local offset = widget.offset
			local rect_size = widget.style.rect.size

			rect_size[1] = width
			rect_size[2] = text_height

			if self._secondary_letterbox_added and secondary_i_start < i then
				rect_size[2] = secondary_text_height
			end

			offset[2] = start_offset

			UIWidget.draw(widget, ui_renderer)

			if self._secondary_letterbox_added and secondary_i_start <= i then
				if i == secondary_i_start then
					start_offset = start_offset + (secondary_text_height + secondary_line_spacing + text_height + line_spacing) / 2
				else
					start_offset = start_offset + secondary_text_height + secondary_line_spacing
				end
			else
				start_offset = start_offset + text_height + line_spacing
			end
		end
	end

	ConstantElementSubtitles.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ConstantElementSubtitles._register_events = function (self)
	local event_manager = Managers.event
	local events = ConstantElementSubtitlesSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

ConstantElementSubtitles._unregister_events = function (self)
	local event_manager = Managers.event
	local events = ConstantElementSubtitlesSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return ConstantElementSubtitles
