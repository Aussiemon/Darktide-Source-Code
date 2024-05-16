-- chunkname: @scripts/ui/views/end_party_view/end_party_view.lua

local Definitions = require("scripts/ui/views/end_party_view/end_party_view_definitions")
local EndPartyViewSettings = require("scripts/ui/views/end_party_view/end_party_view_settings")
local EndViewSettings = require("scripts/ui/views/end_view/end_view_settings")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementAccolade = require("scripts/ui/view_elements/view_element_accolade/view_element_accolade")
local EndPartyView = class("EndPartyView", "BaseView")

EndPartyView.init = function (self, settings, context)
	self._player_panels = {}
	self._spawned_accolades_array = {}
	self._num_player_panels = 0
	self._viewport = nil
	self._camera = nil
	self._context = context
	self._debug_preview = context and context.debug_preview
	self._can_exit = context and context.can_exit
	self._presentation_data = context and context.presentation_data

	EndPartyView.super.init(self, Definitions, settings, context)

	self._pass_draw = true
	self._pass_input = true
end

EndPartyView.on_enter = function (self)
	EndPartyView.super.on_enter(self)
	self:_start_animation("on_enter", self._widgets_by_name, self)
end

EndPartyView._present_game_data_fields = function (self)
	local presentation_data = self._presentation_data
	local total_kills = self._debug_preview and 0 or presentation_data.total_kills
	local total_deaths = self._debug_preview and 0 or presentation_data.total_deaths
	local play_time_seconds = self._debug_preview and 0 or presentation_data.play_time_seconds
	local total_time_minutes = math.floor(play_time_seconds / 60)
	local total_time_seconds = math.floor(play_time_seconds % 60)
	local no_cache = true
	local text_1 = self:_localize("loc_end_view_stat_title_total_kills", no_cache, {
		kills = total_kills,
	})
	local text_2 = self:_localize("loc_end_view_stat_title_total_deaths", no_cache, {
		deaths = total_deaths,
	})
	local text_3 = self:_localize("loc_end_view_stat_title_total_time", no_cache, {
		minutes = total_time_minutes,
		seconds = total_time_seconds,
	})

	self:_set_game_data_fields(text_1, text_2, text_3)
end

EndPartyView.on_exit = function (self)
	EndPartyView.super.on_exit(self)

	self._spawned_accolades_array = nil
end

EndPartyView._set_game_data_fields = function (self, text_1, text_2, text_3)
	local widget_1 = self._widgets_by_name.sub_title_text_1
	local widget_2 = self._widgets_by_name.sub_title_text_2
	local widget_3 = self._widgets_by_name.sub_title_text_3

	widget_1.content.text = text_1
	widget_2.content.text = text_2
	widget_3.content.text = text_3

	local widget_1_length = self:_get_text_widget_length(widget_1)
	local widget_2_length = self:_get_text_widget_length(widget_2)
	local widget_3_length = self:_get_text_widget_length(widget_3)
	local spacing = math.min(300, (1920 - (widget_1_length + widget_2_length + widget_3_length)) * 0.5)

	widget_1.offset[1] = -(widget_2_length + widget_1_length) * 0.5 - spacing
	widget_2.offset[1] = 0
	widget_3.offset[1] = (widget_2_length + widget_3_length) * 0.5 + spacing
end

EndPartyView._get_text_widget_length = function (self, widget)
	local scenegraph_size = {
		RESOLUTION_LOOKUP.width,
		RESOLUTION_LOOKUP.height,
	}
	local text_style = widget.style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_length = UIRenderer.text_size(self._ui_renderer, widget.content.text, text_style.font_type, text_style.font_size, scenegraph_size, text_options)

	return text_length
end

EndPartyView._register_end_of_round_camera = function (self, camera_unit)
	self._camera_unit = camera_unit
end

EndPartyView._convert_world_to_screen_position = function (self, camera, world_position)
	if camera then
		local world_to_screen, distance = Camera.world_to_screen(camera, world_position)

		return world_to_screen.x, world_to_screen.y, distance
	end
end

EndPartyView._get_viewport = function (self)
	local world_name = EndViewSettings.world_name
	local world = Managers.world:world(world_name)
	local viewport_name = EndViewSettings.viewport_name

	return ScriptWorld.viewport(world, viewport_name)
end

EndPartyView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	EndPartyView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local camera = self._camera
	local inverse_scale = ui_renderer.inverse_scale
	local player_panels = self._player_panels
	local num_widgets = #player_panels

	for i = 1, num_widgets do
		local panel = player_panels[i]
		local widget = panel.widget
		local boxed_position = panel.boxed_position
		local position = Vector3.from_array(boxed_position)
		local x, y = self:_convert_world_to_screen_position(camera, position)
		local offset = widget.offset

		offset[1] = x * inverse_scale
		offset[2] = y * inverse_scale

		UIWidget.draw(widget, ui_renderer)
	end
end

EndPartyView._on_panel_pressed = function (self, panel, index)
	local player = panel.player
	local unique_id = self._debug_preview and index or player:unique_id()
	local event_name = "end_of_round_play_character_animation"

	Managers.event:trigger(event_name, unique_id)
end

EndPartyView._update_player_accolade_positions = function (self, dt, t)
	local camera = self._camera
	local scale = self._ui_renderer.scale or RESOLUTION_LOOKUP.scale
	local inverse_scale = self._ui_renderer.inverse_scale or RESOLUTION_LOOKUP.inverse_scale
	local screen_height = RESOLUTION_LOOKUP.height
	local spawned_accolades_array = self._spawned_accolades_array

	for i = 1, #spawned_accolades_array do
		local entry = spawned_accolades_array[i]
		local view_element = entry.view_element
		local spawn_offset = entry.spawn_offset
		local boxed_position = entry.boxed_position
		local position = Vector3.from_array(boxed_position)
		local anim_y_offset = 0
		local alpha_multiplier = 1
		local spawn_delay = entry.spawn_delay

		if spawn_delay then
			alpha_multiplier = 0

			if spawn_delay > 0 then
				entry.spawn_delay = entry.spawn_delay - dt
			else
				entry.spawn_delay = nil
			end
		else
			local animation_duration = entry.animation_duration

			if animation_duration then
				if animation_duration > 0 then
					entry.animation_duration = entry.animation_duration - dt

					local progress = 1 - math.max(entry.animation_duration / EndPartyViewSettings.accolade_animation_duration, 0)
					local anim_progress = math.easeOutCubic(progress)

					alpha_multiplier = anim_progress

					local max_offset = 50

					anim_y_offset = max_offset - max_offset * anim_progress
				else
					entry.animation_duration = nil
				end
			end
		end

		local x, y = self:_convert_world_to_screen_position(camera, position)

		view_element:set_pivot_offset(x * inverse_scale + spawn_offset[1], y * inverse_scale - spawn_offset[2] + anim_y_offset)
		view_element:set_alpha_multiplier(alpha_multiplier)
	end
end

EndPartyView._spawn_player_accolade = function (self, player, spawn_position, spawn_delay)
	local draw_layer = 10
	local index = #self._spawned_accolades_array + 1
	local view_element = self:_add_element(ViewElementAccolade, "player_accolade_" .. index, draw_layer)
	local spawn_offset = {
		0,
		150,
	}
	local camera = self._camera
	local inverse_scale = self._ui_renderer.inverse_scale or RESOLUTION_LOOKUP.inverse_scale
	local x, y = self:_convert_world_to_screen_position(camera, spawn_position)

	view_element:set_pivot_offset(x * inverse_scale + spawn_offset[1], y * inverse_scale - spawn_offset[2])

	local entry = {
		spawn_delay = spawn_delay,
		animation_duration = EndPartyViewSettings.accolade_animation_duration,
		player = player,
		view_element = view_element,
		spawn_offset = spawn_offset,
		boxed_position = Vector3.to_array(spawn_position),
	}

	self._spawned_accolades_array[index] = entry
end

EndPartyView._spawn_player_panel = function (self, player, spawn_position)
	local panel_definition = self._definitions.panel_definition

	self._num_player_panels = self._num_player_panels + 1

	local widget_name = "panel_" .. self._num_player_panels
	local widget = self:_create_widget(widget_name, panel_definition)
	local panel = {
		player = player,
		boxed_position = Vector3.to_array(spawn_position),
		widget = widget,
	}

	widget.content.hotspot.pressed_callback = callback(self, "_on_panel_pressed", panel, self._num_player_panels)

	self:_set_player_name(panel)

	self._player_panels[self._num_player_panels] = panel
end

EndPartyView._setup_players_ui = function (self)
	local spawn_slots = self._spawn_slots
	local accolade_spawn_delay = EndPartyViewSettings.accolade_initial_spawn_delay

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied then
			local player = slot.player
			local boxed_position = slot.boxed_position
			local position = Vector3.from_array(boxed_position)

			self:_spawn_player_panel(player, position)

			local award_accolade = false

			if award_accolade then
				self:_spawn_player_accolade(player, position, accolade_spawn_delay)

				accolade_spawn_delay = accolade_spawn_delay + EndPartyViewSettings.accolade_extra_spawn_delay + EndPartyViewSettings.accolade_animation_duration
			end
		end
	end
end

EndPartyView._set_player_name = function (self, panel)
	local widget = panel.widget
	local player = panel.player
	local name = player:name()

	widget.content.player_name = name
end

EndPartyView.can_exit = function (self)
	return self._can_exit
end

EndPartyView.update = function (self, dt, t)
	if not self._initialized then
		if not self._spawn_slots or not self._camera_unit then
			local context = self._context

			if context then
				self._spawn_slots = context.spawn_slots
				self._camera_unit = context.camera_unit
			end
		else
			self._initialized = true
			self._viewport = self:_get_viewport()
			self._camera = ScriptViewport.camera(self._viewport)

			self:_setup_players_ui()
		end
	end

	self:_update_player_accolade_positions(dt, t)

	if not self._continue_called then
		if not self._time then
			self._time = t + EndPartyViewSettings.duration
		elseif t >= self._time then
			self:_continue()
		else
			local time = self._time - t + 1

			self:_set_timer_text(time)
		end
	end

	return EndPartyView.super.update(self, dt, t)
end

EndPartyView._on_entry_pressed_cb = function (self, widget, entry)
	local trigger_function = entry.trigger_function

	if trigger_function then
		trigger_function()
	end
end

EndPartyView._continue = function (self)
	local event_name = "event_state_game_score_continue"

	Managers.event:trigger(event_name)

	self._continue_called = true
end

EndPartyView._set_timer_text = function (self, time)
	local floor = math.floor
	local timer_text = string.format("%.2d:%.2d", floor(time / 60) % 60, floor(time) % 60)
	local widget = self._widgets_by_name.timer_text

	widget.content.text = tostring(timer_text)
end

return EndPartyView
