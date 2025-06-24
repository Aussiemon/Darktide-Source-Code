-- chunkname: @scripts/ui/hud/elements/interaction/hud_element_interaction.lua

local Definitions = require("scripts/ui/hud/elements/interaction/hud_element_interaction_definitions")
local HudElementInteractionSettings = require("scripts/ui/hud/elements/interaction/hud_element_interaction_settings")
local InputUtils = require("scripts/managers/input/input_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HudElementInteraction = class("HudElementInteraction", "HudElementBase")

HudElementInteraction.init = function (self, parent, draw_layer, start_scale)
	HudElementInteraction.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._parent = parent
	self._interaction_units = {}
	self._scan_delay = HudElementInteractionSettings.scan_delay
	self._scan_delay_duration = 0
	self._previous_interactee_unit = nil

	self:_set_event_popup_visibility(false)
end

HudElementInteraction._set_event_popup_visibility = function (self, visible)
	self._widgets_by_name.event_background.content.visible = visible
end

HudElementInteraction.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_interaction_extension_scan()

		self._scan_delay_duration = self._scan_delay
	end

	self:_update_can_interact_target()

	if self:_present_interaction_hud() then
		self:_update_interaction_hud_position(dt, t)
		self:_update_target_interaction_size(dt, t, ui_renderer)
		self:_update_target_interaction_animation(dt, t)
		self:_update_target_interaction_hold_progress(dt, t)
	end

	self:_update_progress_complete_anim(dt, t)
	HudElementInteraction.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementInteraction._interaction_extension_scan = function (self)
	local interactee_system = Managers.state.extension:system("interactee_system")
	local unit_to_interactee_ext = interactee_system:unit_to_extension_map()

	for interactee_unit, extension in pairs(unit_to_interactee_ext) do
		self:_update_interactee_data(interactee_unit, extension)
	end
end

HudElementInteraction._update_interactee_data = function (self, interactee_unit, extension)
	local parent = self._parent
	local player = parent:player()
	local player_unit = player.player_unit
	local camera = parent:player_camera()
	local camera_position = camera and Camera.local_position(camera)
	local render_marker = extension:active() and extension:show_marker(player_unit) and interactee_unit ~= player_unit
	local interaction_units = self._interaction_units

	if render_marker and camera_position then
		local interactee_position = Unit.world_position(interactee_unit, 1)
		local distance_sq = Vector3.distance_squared(interactee_position, camera_position)

		render_marker = distance_sq <= HudElementInteractionSettings.max_spawn_distance_sq
	end

	if render_marker then
		if not interaction_units[interactee_unit] then
			interaction_units[interactee_unit] = {
				requested = true,
				extension = extension,
			}

			local marker_callback = callback(self, "_on_interaction_marker_spawned", interactee_unit)
			local marker_type = "interaction"

			Managers.event:trigger("add_world_marker_unit", marker_type, interactee_unit, marker_callback, extension)
		end
	elseif interaction_units[interactee_unit] then
		local marker_id = interaction_units[interactee_unit].marker_id

		if marker_id then
			Managers.event:trigger("remove_world_marker", marker_id)

			interaction_units[interactee_unit] = nil
		end
	end
end

HudElementInteraction._on_interaction_marker_spawned = function (self, unit, id)
	self._interaction_units[unit].marker_id = id
end

HudElementInteraction.destroy = function (self, ui_renderer)
	local event_manager = Managers.event
	local interaction_units = self._interaction_units

	for _, data in pairs(interaction_units) do
		local marker_id = data.marker_id

		if marker_id then
			event_manager:trigger("remove_world_marker", marker_id)
		end
	end

	self._interaction_units = nil

	HudElementInteraction.super.destroy(self, ui_renderer)
end

HudElementInteraction._update_can_interact_target = function (self)
	local parent = self._parent
	local player = parent:player()
	local ALIVE = ALIVE
	local player_unit = player.player_unit

	if not ALIVE[player_unit] then
		self._show_interaction_hud = false

		return
	end

	local interactor_extension = ScriptUnit.has_extension(player_unit, "interactor_system")

	if not interactor_extension then
		self._show_interaction_hud = false

		return
	end

	local interactee_unit = interactor_extension:target_unit()
	local focus_target = interactor_extension:focus_unit()

	if not interactee_unit and ALIVE[focus_target] and interactor_extension:hud_block_text() then
		interactee_unit = focus_target
	end

	if ALIVE[interactee_unit] and ALIVE[player_unit] then
		local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

		if not interactee_extension:show_marker(player_unit) then
			self._show_interaction_hud = false

			return
		end
	end

	local previous_interactee_unit = self._previous_interactee_unit

	if interactee_unit == previous_interactee_unit then
		if ALIVE[interactee_unit] and not self:is_synchronized_with_interactee(interactee_unit, interactor_extension) then
			local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

			self:_setup_interaction_information(interactee_unit, interactee_extension, interactor_extension, self._use_minimal_presentation)
		end
	else
		if ALIVE[previous_interactee_unit] then
			local unit_position = Unit.world_position(previous_interactee_unit, 1)

			self:_play_3d_sound(UISoundEvents.interact_popup_exit, unit_position)
		end

		if ALIVE[interactee_unit] then
			local unit_position = Unit.world_position(interactee_unit, 1)

			self:_play_3d_sound(UISoundEvents.interact_popup_enter, unit_position)

			local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
			local interaction_units = self._interaction_units
			local interaction_data = interaction_units[interactee_unit]

			if not interaction_data then
				self:_update_interactee_data(interactee_unit, interactee_extension)

				interaction_data = interaction_units[interactee_unit]
			end

			local marker_id = interaction_data and interaction_data.marker_id
			local ui_interaction_type = interactee_extension.ui_interaction_type and interactee_extension:ui_interaction_type()
			local use_minimal_presentation = ui_interaction_type and ui_interaction_type == "player_interaction"

			self._active_presentation_data = {
				intro_anim_duration = 0.2,
				intro_anim_progress = 0,
				intro_anim_time = 0,
				interactee_extension = interactee_extension,
				interactor_extension = interactor_extension,
				interactee_unit = interactee_unit,
				player_unit = player_unit,
				marker_id = marker_id,
				use_minimal_presentation = use_minimal_presentation,
				background_size = use_minimal_presentation and HudElementInteractionSettings.background_size_small or HudElementInteractionSettings.background_size,
			}

			self:_setup_interaction_information(interactee_unit, interactee_extension, interactor_extension, use_minimal_presentation)

			local response_callback = callback(self, "_cb_world_markers_list_request")

			Managers.event:trigger("request_world_markers_list", response_callback)
		else
			self._active_presentation_data = nil
		end

		self._previous_interactee_unit = interactee_unit
	end

	local active_presentation_data = self._active_presentation_data

	if active_presentation_data then
		local marker = active_presentation_data.marker

		self._use_minimal_presentation = active_presentation_data.use_minimal_presentation

		local show_interaction_ui = interactor_extension:show_interaction_ui()
		local show_counter_ui = interactor_extension:show_counter_ui()
		local show_block_ui = interactor_extension:hud_block_text()

		self._widgets_by_name.background.content.use_minimal_presentation = self._use_minimal_presentation
		self._widgets_by_name.frame.content.use_minimal_presentation = self._use_minimal_presentation

		self:_update_tag_input_information(interactee_unit)

		if not show_block_ui then
			self:_update_interaction_input_text(active_presentation_data.interactee_extension)
		end

		self._show_interaction_hud = marker and (show_interaction_ui or show_counter_ui or show_block_ui)
	else
		self._show_interaction_hud = false
	end
end

local function _get_alias_key(action_name)
	local service_type = "Ingame"
	local input_service = Managers.input:get_input_service(service_type)

	return input_service:get_alias_key(action_name)
end

local function _get_input_text(alias_name, input_text_key, hold_required)
	local service_type = "Ingame"
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_name)
	local input_display_text = Localize(input_text_key)
	local input_action_localization_params = {
		input = input_text,
		action = input_display_text,
	}
	local input_type_string = hold_required and "loc_interaction_input_type_hold" or "loc_interaction_input_type"

	return Localize(input_type_string, true, input_action_localization_params)
end

HudElementInteraction._update_tag_input_information = function (self, interactee_unit)
	local parent = self._parent
	local player = parent:player()
	local player_unit = player.player_unit
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")
	local tag = smart_tag_system:unit_tag(interactee_unit)
	local input_text_tag = ""

	if tag then
		local tagger_player = tag:tagger_player()
		local is_my_tag = tagger_player and tagger_player:unique_id() == player:unique_id()

		if is_my_tag then
			if tag:is_cancelable() then
				input_text_tag = _get_input_text("smart_tag", "loc_untag_smart_tag")
			end
		else
			local default_reply = tag:default_reply()

			if default_reply then
				input_text_tag = _get_input_text("smart_tag", default_reply.description)
			end
		end
	else
		local smart_tag_extension = ScriptUnit.has_extension(interactee_unit, "smart_tag_system")

		if smart_tag_extension and smart_tag_extension:can_tag(player_unit) then
			input_text_tag = _get_input_text("smart_tag", "loc_tag_smart_tag")
		end
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.tag_text.content.text = input_text_tag
end

HudElementInteraction._update_interaction_input_text = function (self, interactee_extension)
	local hold_required = interactee_extension:hold_required()
	local input_action_text = interactee_extension:action_text()
	local interaction_input = interactee_extension:interaction_input() or "interact_pressed"
	local interaction_input_alias_key = _get_alias_key(interaction_input)
	local input_text_interact = _get_input_text(interaction_input_alias_key, input_action_text or "n/a", hold_required)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.interact_text.content.text = input_text_interact
end

HudElementInteraction._cb_world_markers_list_request = function (self, marker_list)
	local active_presentation_data = self._active_presentation_data

	if active_presentation_data then
		local marker_id = active_presentation_data.marker_id

		for i = 1, #marker_list do
			local marker = marker_list[i]

			if marker.id == marker_id then
				active_presentation_data.marker = marker

				break
			end
		end
	end
end

HudElementInteraction._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self:_present_interaction_hud() then
		return
	end

	HudElementInteraction.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementInteraction._update_progress_complete_anim = function (self, dt, t)
	local progress_complete_anim_time = self._progress_complete_anim_time

	if not progress_complete_anim_time then
		return
	end

	local total_time = HudElementInteractionSettings.progress_complete_anim_duration
	local progress = 1 - progress_complete_anim_time / total_time
	local widget = self._widgets_by_name.progress_highlight

	if progress < 1 then
		self._progress_complete_anim_time = progress_complete_anim_time - dt
	else
		self._progress_complete_anim_time = nil
	end

	widget.style.frame.color[1] = 255 * math.ease_sine(1 - progress)
end

HudElementInteraction._update_target_interaction_hold_progress = function (self, dt, t)
	local active_presentation_data = self._active_presentation_data
	local interactor_extension = active_presentation_data.interactor_extension
	local interactee_extension = active_presentation_data.interactee_extension
	local player_unit = active_presentation_data.player_unit
	local interactee_unit = active_presentation_data.interactee_unit
	local hold_progress = 0
	local can_interact = ALIVE[interactee_unit] and interactee_extension and interactee_extension:can_interact(player_unit)

	if can_interact then
		hold_progress = interactor_extension and interactor_extension:interaction_progress()
	end

	local background_size = active_presentation_data.background_size
	local widgets_by_name = self._widgets_by_name
	local background_widget = widgets_by_name.background
	local progress_width = hold_progress * background_size[1]

	background_widget.style.input_progress_background.size[1] = progress_width
	background_widget.style.input_progress_background_large.size[1] = progress_width + (hold_progress > 0 and 1 or 0)

	local progress_frame_style = background_widget.style.input_progress_frame

	progress_frame_style.size[1] = progress_width
	progress_frame_style.offset[1] = progress_frame_style.default_offset[1] - background_size[1] + progress_width
	progress_frame_style.color[1] = 255 * math.clamp(math.ease_out_exp(hold_progress * 2), 0, 1)

	if hold_progress >= 1 then
		self._progress_complete_anim_time = HudElementInteractionSettings.progress_complete_anim_duration
	end
end

HudElementInteraction._update_target_interaction_size = function (self, dt, t, ui_renderer)
	local widgets_by_name = self._widgets_by_name
	local tag_text = widgets_by_name.tag_text.content.text
	local interaction_text = widgets_by_name.interact_text.content.text
	local description_text = widgets_by_name.description_text.content.text
	local tag_style = widgets_by_name.tag_text.style.text
	local interaction_style = widgets_by_name.interact_text.style.text
	local description_style = widgets_by_name.description_text.style.text
	local input_box_height = HudElementInteractionSettings.input_box_height
	local use_minimal_presentation = self._active_presentation_data.use_minimal_presentation
	local background_size = use_minimal_presentation and HudElementInteractionSettings.background_size_small or HudElementInteractionSettings.background_size
	local edge_spacing = HudElementInteractionSettings.edge_spacing
	local max_text_width = background_size[1] - edge_spacing[1] * 2
	local tag_max_size = {
		interaction_style.size[1],
		1080,
	}
	local description_max_size = {
		max_text_width,
		1080,
	}
	local tag_text_width, tag_text_height = UIRenderer.text_size(ui_renderer, tag_text, tag_style.font_type, tag_style.font_size, tag_max_size, UIFonts.get_font_options_by_style(tag_style))

	tag_text_width = tag_text_width > 0 and tag_text_width + edge_spacing[1] or 0

	local interaction_max_size = {
		max_text_width - tag_text_width,
		1080,
	}
	local interaction_width, interaction_height = UIRenderer.text_size(ui_renderer, interaction_text, interaction_style.font_type, interaction_style.font_size, interaction_max_size, UIFonts.get_font_options_by_style(interaction_style))
	local description_width, description_height = UIRenderer.text_size(ui_renderer, description_text, description_style.font_type, description_style.font_size, description_max_size, UIFonts.get_font_options_by_style(description_style))

	interaction_height = interaction_height + (interaction_height > 0 and edge_spacing[2] * 2 or 0)
	description_height = description_height + (description_height > 0 and edge_spacing[2] * 4 or 0)

	local background_height = interaction_height + description_height

	self:_set_scenegraph_size("description_box", nil, description_height)
	self:_set_scenegraph_size("background", nil, background_height)

	self._active_presentation_data.background_size = {
		background_size[1],
		background_height,
	}
	interaction_style.size = {
		interaction_max_size[1],
		interaction_height,
	}
	widgets_by_name.background.style.input_background.size[2] = interaction_height
	widgets_by_name.background.style.input_background_slim.size[2] = interaction_height
end

HudElementInteraction._update_target_interaction_animation = function (self, dt, t)
	local active_presentation_data = self._active_presentation_data
	local intro_anim_progress = active_presentation_data.intro_anim_progress

	if intro_anim_progress ~= 1 then
		local intro_anim_time = active_presentation_data.intro_anim_time
		local intro_anim_duration = active_presentation_data.intro_anim_duration

		intro_anim_time = intro_anim_time + dt
		intro_anim_progress = math.min(intro_anim_time / intro_anim_duration, 1)
		active_presentation_data.intro_anim_time = intro_anim_time
		active_presentation_data.intro_anim_progress = intro_anim_progress
	end

	local widgets = self._widgets
	local size_progress = math.easeOutCubic(intro_anim_progress)
	local alpha_progress = math.easeInCubic(intro_anim_progress)
	local background_size = active_presentation_data.background_size

	self:_set_scenegraph_size("background", nil, background_size[2] * 0.3 + background_size[2] * 0.7 * size_progress)

	for i = 1, #widgets do
		local widget = widgets[i]

		widget.alpha_multiplier = alpha_progress
	end
end

HudElementInteraction._update_interaction_hud_position = function (self, dt, t)
	local active_presentation_data = self._active_presentation_data
	local marker = active_presentation_data.marker

	if not marker then
		return
	end

	local background_size = self:scenegraph_size("background")
	local marker_widget = marker.widget
	local marker_widget_offset = marker_widget.offset
	local x_spacing = 50
	local y_spacing = background_size[2] * 0.5

	self:set_scenegraph_position("pivot", marker_widget_offset[1] + x_spacing, marker_widget_offset[2] + y_spacing)
end

HudElementInteraction._present_interaction_hud = function (self)
	return self._show_interaction_hud
end

HudElementInteraction.is_synchronized_with_interactee = function (self, interactee_unit, interactor_extension)
	local previous_interactee_data = self._previous_interactee_data
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	if previous_interactee_data.hold_required ~= interactee_extension:hold_required() then
		return false
	end

	if previous_interactee_data.input_action_text ~= interactee_extension:action_text() then
		return false
	end

	if previous_interactee_data.input_block_text ~= interactor_extension:hud_block_text() then
		return false
	end

	local hud_description = interactor_extension:hud_description()

	if previous_interactee_data.hud_description ~= hud_description then
		return false
	end

	return true
end

HudElementInteraction._setup_interaction_information = function (self, interactee_unit, interactee_extension, interactor_extension, use_minimal_presentation)
	local hold_required = interactee_extension:hold_required()
	local input_action_text = interactee_extension:action_text()
	local input_block_text, hud_block_text_context = interactor_extension:hud_block_text()
	local interaction_input = interactee_extension:interaction_input() or "interact_pressed"
	local interaction_input_alias_key = _get_alias_key(interaction_input)
	local input_text_interact = _get_input_text(interaction_input_alias_key, input_action_text or "n/a", hold_required)
	local description_text, hud_description, hud_description_context

	if not use_minimal_presentation then
		local interactee_player = Managers.player:player_by_unit(interactee_unit)

		if interactee_player then
			local player_slot = interactee_player:slot()
			local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
			local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"

			description_text = color_string .. "{#size(30)} {#reset()}" .. interactee_player:name()
		else
			hud_description, hud_description_context = interactor_extension:hud_description()

			if hud_description_context then
				description_text = Localize(hud_description, true, hud_description_context)
			else
				description_text = Localize(hud_description)
			end
		end
	else
		description_text = ""
		hud_description = ""
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.interact_text.content.text = input_text_interact

	if input_block_text then
		if hud_block_text_context then
			widgets_by_name.interact_text.content.text = Localize(input_block_text, true, hud_block_text_context)
		else
			widgets_by_name.interact_text.content.text = Localize(input_block_text)
		end
	end

	widgets_by_name.description_text.content.text = description_text
	widgets_by_name.type_description_text.content.text = ""

	local is_event_interaction = interactee_extension.display_start_event and interactee_extension:display_start_event()

	self:_set_event_popup_visibility(is_event_interaction)

	self._previous_interactee_data = {
		hold_required = hold_required,
		input_action_text = input_action_text,
		input_block_text = input_block_text,
		hud_description = hud_description,
		is_event = is_event_interaction,
	}
end

HudElementInteraction._play_3d_sound = function (self, event_name, position)
	local ui_manager = Managers.ui

	ui_manager:play_3d_sound(event_name, position)
end

return HudElementInteraction
