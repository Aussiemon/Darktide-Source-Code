local Definitions = require("scripts/ui/hud/elements/interaction/hud_element_interaction_definitions")
local HudElementInteractionSettings = require("scripts/ui/hud/elements/interaction/hud_element_interaction_settings")
local InputUtils = require("scripts/managers/input/input_utils")
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
		self:_update_target_interaction_animation(dt, t)
		self:_update_target_interaction_hold_progress(dt, t)
	end

	self:_update_progress_complete_anim(dt, t)
	HudElementInteraction.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementInteraction._interaction_extension_scan = function (self)
	local parent = self._parent
	local player = parent:player()
	local player_unit = player.player_unit
	local event_manager = Managers.event
	local interactee_system = Managers.state.extension:system("interactee_system")
	local unit_to_interactee_ext = interactee_system:unit_to_extension_map()
	local camera = parent:player_camera()
	local camera_position = camera and Camera.local_position(camera)
	local max_marker_distance_sq = HudElementInteractionSettings.max_spawn_distance_sq
	local marker_type = "interaction"
	local interaction_units = self._interaction_units

	for interactee_unit, extension in pairs(unit_to_interactee_ext) do
		local render_marker = extension:active() and extension:show_marker(player_unit) and interactee_unit ~= player_unit

		if render_marker and camera_position then
			local interactee_position = Unit.world_position(interactee_unit, 1)
			local distance_sq = Vector3.distance_squared(interactee_position, camera_position)
			render_marker = distance_sq <= max_marker_distance_sq
		end

		if render_marker then
			if not interaction_units[interactee_unit] then
				interaction_units[interactee_unit] = {
					requested = true,
					extension = extension
				}
				local marker_callback = callback(self, "_on_interaction_marker_spawned", interactee_unit)

				event_manager:trigger("add_world_marker_unit", marker_type, interactee_unit, marker_callback, extension)
			end
		elseif interaction_units[interactee_unit] then
			local marker_id = interaction_units[interactee_unit].marker_id

			if marker_id then
				event_manager:trigger("remove_world_marker", marker_id)

				interaction_units[interactee_unit] = nil
			end
		end
	end
end

HudElementInteraction._on_interaction_marker_spawned = function (self, unit, id)
	self._interaction_units[unit].marker_id = id
end

HudElementInteraction.destroy = function (self)
	local event_manager = Managers.event
	local interaction_units = self._interaction_units

	for _, data in pairs(interaction_units) do
		local marker_id = data.marker_id

		if marker_id then
			event_manager:trigger("remove_world_marker", marker_id)
		end
	end

	self._interaction_units = nil
end

HudElementInteraction._update_can_interact_target = function (self)
	local parent = self._parent
	local player = parent:player()
	local ALIVE = ALIVE
	local player_unit = player.player_unit

	if not ALIVE[player_unit] then
		return
	end

	local interactor_extension = ScriptUnit.has_extension(player_unit, "interactor_system")

	if not interactor_extension then
		return
	end

	local update_target = false
	local interactee_unit = interactor_extension:target_unit()

	if not interactee_unit then
		local focus_target = interactor_extension:focus_unit()

		if focus_target then
			local interactee_extension = ScriptUnit.extension(focus_target, "interactee_system")

			if interactee_extension:block_text() then
				interactee_unit = focus_target
				update_target = true
			end
		else
			update_target = true
		end
	else
		update_target = interactor_extension:can_interact(interactee_unit)
	end

	local previous_interactee_unit = self._previous_interactee_unit

	if update_target then
		if interactee_unit == self._previous_interactee_unit then
			if ALIVE[interactee_unit] and not self:is_synchronized_with_interactee(interactee_unit, interactor_extension) then
				local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

				self:_setup_interaction_information(interactee_unit, interactee_extension, interactor_extension)
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

				self:_setup_interaction_information(interactee_unit, interactee_extension, interactor_extension)

				local interaction_units = self._interaction_units
				local interaction_data = interaction_units[interactee_unit]
				local marker_id = interaction_data and interaction_data.marker_id
				local _, type_description = interactor_extension:hud_description()
				self._active_presentation_data = {
					intro_anim_duration = 0.2,
					intro_anim_time = 0,
					intro_anim_progress = 0,
					interactee_extension = interactee_extension,
					interactor_extension = interactor_extension,
					interactee_unit = interactee_unit,
					player_unit = player_unit,
					marker_id = marker_id,
					background_size = (type_description ~= nil and HudElementInteractionSettings.background_size) or HudElementInteractionSettings.background_size_small
				}
				local response_callback = callback(self, "_cb_world_markers_list_request")

				Managers.event:trigger("request_world_markers_list", response_callback)
			else
				self._active_presentation_data = nil
			end

			self._previous_interactee_unit = interactee_unit
		end
	end

	local active_presentation_data = self._active_presentation_data

	if active_presentation_data then
		self:_update_tag_input_information(interactee_unit)

		local marker = active_presentation_data.marker
		local show_interaction_ui = interactor_extension and interactor_extension:show_interaction_ui()
		local show_counter_ui = interactor_extension and interactor_extension:show_counter_ui()
		local show_block_ui = interactee_unit and active_presentation_data.interactee_extension:block_text()
		self._show_interaction_hud = marker and (show_interaction_ui or show_counter_ui or show_block_ui)
		self._show_interaction_counter_hud = self._show_interaction_hud and show_counter_ui
	elseif self._show_interaction_hud then
		self._show_interaction_hud = false
		self._show_interaction_counter_hud = false
	end
end

local function _get_input_text(alias_name, input_text_key, hold_required)
	local service_type = "Ingame"
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_name)
	local input_display_text = Localize(input_text_key)
	local input_action_localization_params = {
		input = input_text,
		action = input_display_text
	}
	local input_type_string = (hold_required and "loc_interaction_input_type_hold") or "loc_interaction_input_type"

	return Localize(input_type_string, true, input_action_localization_params)
end

HudElementInteraction._update_tag_input_information = function (self, interactee_unit)
	local parent = self._parent
	local player = parent:player()
	local player_unit = player.player_unit
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")
	local tag_id = smart_tag_system:unit_tag_id(interactee_unit)
	local tagger_player = tag_id and smart_tag_system:tagger_player_by_tag_id(tag_id)
	local is_my_tag = tagger_player and tagger_player:unique_id() == player:unique_id()
	local taggable = false
	local smart_tag_extension = ScriptUnit.has_extension(interactee_unit, "smart_tag_system")

	if smart_tag_extension and not tag_id and smart_tag_extension:can_tag(player_unit) then
		taggable = true
	end

	local input_text_tag = nil

	if taggable then
		if is_my_tag then
			if tag_id then
				input_text_tag = _get_input_text("smart_tag", "loc_untag_smart_tag")
			else
				input_text_tag = _get_input_text("smart_tag", "loc_tag_smart_tag")
			end
		elseif tag_id then
			input_text_tag = _get_input_text("smart_tag", "loc_untag_smart_tag")
		else
			input_text_tag = _get_input_text("smart_tag", "loc_tag_smart_tag")
		end
	else
		input_text_tag = ""
	end

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.tag_text.content.text = input_text_tag
end

HudElementInteraction._cb_world_markers_list_request = function (self, marker_list)
	local active_presentation_data = self._active_presentation_data

	if active_presentation_data then
		local marker_id = active_presentation_data.marker_id

		for i = 1, #marker_list, 1 do
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
	local hold_progress = 0
	local can_interact = interactee_extension:can_interact(player_unit)

	if can_interact and interactor_extension then
		hold_progress = interactor_extension:get_interaction_progress()
	end

	local background_size = HudElementInteractionSettings.background_size
	local widgets_by_name = self._widgets_by_name
	local background_widget = widgets_by_name.background
	local progress_width = hold_progress * background_size[1]
	background_widget.style.input_progress_background.size[1] = progress_width
	background_widget.style.input_progress_background_large.size[1] = progress_width + ((hold_progress > 0 and 1) or 0)
	local progress_frame_style = background_widget.style.input_progress_frame
	progress_frame_style.size[1] = progress_width
	progress_frame_style.offset[1] = progress_frame_style.default_offset[1] - background_size[1] + progress_width
	progress_frame_style.color[1] = 255 * math.clamp(math.ease_out_exp(hold_progress * 2), 0, 1)

	if hold_progress >= 1 then
		self._progress_complete_anim_time = HudElementInteractionSettings.progress_complete_anim_duration
	end
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

	for i = 1, #widgets, 1 do
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

	if previous_interactee_data.input_block_text ~= interactee_extension:block_text() then
		return false
	end

	local hud_description, _ = interactor_extension:hud_description()

	if previous_interactee_data.hud_description ~= hud_description then
		return false
	end

	return true
end

HudElementInteraction._setup_interaction_information = function (self, interactee_unit, interactee_extension, interactor_extension)
	local hold_required = interactee_extension:hold_required()
	local input_action_text = interactee_extension:action_text()
	local input_block_text = interactee_extension:block_text()
	local input_text_interact = _get_input_text("interact", input_action_text or "n/a", hold_required)
	local hud_description, type_description = interactor_extension:hud_description()
	local description_text = Localize(hud_description)
	local interactee_player = Managers.player:player_by_unit(interactee_unit)

	if interactee_player then
		local player_slot = interactee_player:slot()
		local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
		local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"
		description_text = color_string .. "{#size(30)}\ue005 {#reset()}" .. interactee_player:name()
	end

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.interact_text.content.text = input_text_interact

	if input_block_text then
		widgets_by_name.interact_text.content.text = Localize(input_block_text)
	end

	widgets_by_name.description_text.content.text = description_text

	if type_description then
		type_description = Localize(type_description)
		widgets_by_name.type_description_text.content.text = type_description
		widgets_by_name.description_text.offset[2] = -14
	else
		widgets_by_name.type_description_text.content.text = ""
		widgets_by_name.description_text.offset[2] = 10
	end

	local is_event_interaction = interactee_extension.display_start_event and interactee_extension:display_start_event()

	self:_set_event_popup_visibility(is_event_interaction)

	self._previous_interactee_data = {
		hold_required = hold_required,
		input_action_text = input_action_text,
		input_block_text = input_block_text,
		hud_description = hud_description,
		type_description = type_description,
		is_event = is_event_interaction
	}
end

HudElementInteraction._play_3d_sound = function (self, event_name, position)
	local ui_manager = Managers.ui

	ui_manager:play_3d_sound(event_name, position)
end

return HudElementInteraction
