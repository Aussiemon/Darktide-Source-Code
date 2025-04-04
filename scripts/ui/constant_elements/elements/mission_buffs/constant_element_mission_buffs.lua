-- chunkname: @scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs.lua

local MissionBuffsDefinitions = require("scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs_definitions")
local MissionBuffsSettings = require("scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs_settings")
local MissionBuffsBlueprints = require("scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs_blueprints")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local MissionBuffsParser = require("scripts/ui/constant_elements/elements/mission_buffs/utilities/mission_buffs_parser")
local MissionBuffsAllowedBuffs = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local MissionBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local TextUtils = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local TextUtilities = require("scripts/utilities/ui/text")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local MissionBuffs = class("ConstantElementMissionBuffs", "ConstantElementBase")
local DEFAULT_TIMER = 5
local HOLD_TIMER = 2

local function _calculate_text_size(widget, text_and_style_id, size, ui_renderer)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)

	return UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

MissionBuffs.init = function (self, parent, draw_layer, start_scale)
	MissionBuffs.super.init(self, parent, draw_layer, start_scale, MissionBuffsDefinitions)

	self._context = {}
	self._queue_context = {}
	self._is_cutscene_active = false
	self._states = {
		blur = "inactive",
		buffs = "inactive",
		text = "inactive",
		view = "inactive",
	}
	self._tactical_overlay_active = false

	self:_register_event("event_mission_buffs_update_presentation", "_presentation_changed")
	self:_register_event("event_cutscene_fade_in", "_cutscene_start")
	self:_register_event("event_cutscene_fade_out", "_cutscene_end")
end

MissionBuffs._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 199
	local world_name = class_name .. "_ui_background_world"

	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name)
	self._background_world_name = world_name
	self._background_world_draw_layer = world_layer
	self._background_world_default_layer = world_layer

	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_popup_background_renderer = ui_manager:create_renderer(class_name .. "_ui_popup_background_renderer", self._background_world)
end

MissionBuffs._destroy_background = function (self)
	if self._ui_popup_background_renderer then
		self._ui_popup_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_popup_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end
end

MissionBuffs.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

MissionBuffs._present_buffs = function (self, ui_renderer)
	local buffs_size = self._context.buffs and #self._context.buffs

	if buffs_size and buffs_size > 0 then
		local layout = {}

		for i = 1, buffs_size do
			local buff = self._context.buffs[i]
			local buff_name = buff.buff_name
			local sub_buff_name, title, icon, gradient
			local use_gradient = true
			local description
			local sub_title = ""
			local sub_buff

			if self._context.is_buff_family then
				local family_id = "hordes_family_" .. buff_name
				local buff_family_data = HordesBuffsData[family_id]

				title = Localize(buff_family_data.title)
				description = Localize(buff_family_data.description)
				icon = buff_family_data.icon
				gradient = buff_family_data.gradient
				use_gradient = false
				sub_buff_name = MissionBuffsAllowedBuffs.buff_families[buff_name] and MissionBuffsAllowedBuffs.buff_families[buff_name].priority_buffs and MissionBuffsAllowedBuffs.buff_families[buff_name].priority_buffs[1]
			else
				local buff_data = MissionBuffsData[buff_name]

				if buff_data then
					title = buff_data.title == "" and buff_name or Localize(buff_data.title)
					description = MissionBuffsParser.get_formated_buff_description(buff_data, Color.ui_terminal(255, true))
					icon = buff_data.icon

					local is_family_buff = buff_data.is_family_buff

					if is_family_buff then
						sub_title = Localize("loc_tactical_overlay_build_lesser")
					else
						sub_title = Localize("loc_tactical_overlay_build_major")
					end

					gradient = buff_data.gradient
				end
			end

			if sub_buff_name then
				local sub_buff_data = MissionBuffsData[sub_buff_name]

				if sub_buff_data then
					local title = sub_buff_data.title == "" and sub_buff_name or Localize(sub_buff_data.title)
					local description = MissionBuffsParser.get_formated_buff_description(sub_buff_data, Color.ui_terminal(255, true))
					local icon = sub_buff_data.icon
					local gradient = sub_buff_data.gradient
					local sub_title
					local is_family_buff = sub_buff_data.is_family_buff

					if is_family_buff then
						sub_title = Localize("loc_tactical_overlay_build_lesser")
					else
						sub_title = Localize("loc_tactical_overlay_build_major")
					end

					sub_buff = {
						title = title,
						sub_title = sub_title,
						description = description,
						buff_icon_texture = icon,
						buff_icon_gradient_map = gradient,
					}
				end
			end

			local layout_index = #layout + 1

			layout[layout_index] = {
				widget_type = "buff_card",
				buff_icon_texture = icon,
				buff_icon_gradient_map = gradient,
				buff_icon_use_gradient = use_gradient,
				title = title,
				sub_title = sub_title,
				description = description,
				buff_index = layout_index,
				is_choice = buffs_size > 1,
				is_family = self._context.is_buff_family,
				is_first = i == 1,
				is_last = i == buffs_size,
				sub_buff = sub_buff,
			}

			Log.info("ConstantElementMissionBuffs", "Present Buff Card: BuffName[%s]", buff_name)
		end

		self:_generate_buffs_widgets(layout, ui_renderer)
	end
end

MissionBuffs._generate_buffs_widgets = function (self, layout, ui_renderer)
	local buffs_size = layout and #layout

	if not buffs_size then
		return
	end

	local left_click_callback_name

	if buffs_size > 1 then
		left_click_callback_name = "_cb_on_buff_clicked"
	end

	self:_destroy_buff_widgets(ui_renderer)

	self._buff_widgets = {}

	local card_width_margin = 50
	local total_width = 0

	for i = 1, #layout do
		local layout_element = layout[i]
		local widget_type = layout_element.widget_type
		local blueprint = MissionBuffsBlueprints[widget_type]
		local size = blueprint.size
		local ui_passes = blueprint.pass_template
		local scenegraph_name = "buffs_area"
		local definition = UIWidget.create_definition(ui_passes, scenegraph_name, nil, size)
		local widget = self:_create_widget("buff_" .. i, definition)

		blueprint.init(self, widget, layout_element, left_click_callback_name, nil, self._ui_renderer)

		local x_offset = (size[1] + card_width_margin) * (i - 1)

		widget.offset[1] = x_offset
		total_width = x_offset + size[1]
		self._buff_widgets[#self._buff_widgets + 1] = widget
	end

	local card_size = {
		450,
		335,
	}
	local grid_size = {
		total_width,
		card_size[2],
	}

	self:_set_scenegraph_size("buffs_area", grid_size[1], grid_size[2])

	if self._context.is_buff_family then
		self:set_scenegraph_position("buffs_area", nil, -50)
	else
		self:set_scenegraph_position("buffs_area", nil, 0)
	end
end

MissionBuffs._destroy_buff_widgets = function (self, ui_renderer)
	if self._buff_widgets then
		for i = 1, #self._buff_widgets do
			local widget = self._buff_widgets[i]

			self:_unregister_widget_name(widget.name)
			UIWidget.destroy(ui_renderer, widget)
		end

		self._buff_widgets = nil
	end
end

MissionBuffs._set_background_blur = function (self, blur_amount)
	self._using_blur = blur_amount > 0 and true or false
	self._active_blur_amount = blur_amount

	local class_name = self.__class_name
	local world_name = class_name .. "_ui_background_world"
	local viewport_name = class_name .. "_ui_background_world_viewport"

	if self._using_blur then
		if not self._ui_popup_background_renderer then
			self:_setup_background_gui()
		end

		WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, blur_amount)
	else
		self:_destroy_background()
	end
end

MissionBuffs._cb_on_buff_clicked = function (self, widget, element)
	local buff_index = element.buff_index

	self:_handle_choice_resolution(buff_index, false)
end

MissionBuffs._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local previous_alpha_multiplier = render_settings.alpha_multiplier

	MissionBuffs.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if self._buff_widgets then
		for i = 1, #self._buff_widgets do
			local widget = self._buff_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

MissionBuffs.on_resolution_modified = function (self, scale)
	MissionBuffs.super.on_resolution_modified(self, scale)
end

MissionBuffs._cutscene_start = function (self)
	self._cutscene_fade = true
end

MissionBuffs._cutscene_end = function (self)
	self._cutscene_fade = nil
end

MissionBuffs._are_timers_running = function (self)
	return self._texts_timer or self._buffs_timer or self._blur_timer
end

MissionBuffs._are_animations_running = function (self)
	local buff_anim = self._buff_anim_id and not self:_is_animation_completed(self._buff_anim_id)
	local text_anim = self._text_anim_id and not self:_is_animation_completed(self._text_anim_id)

	return buff_anim or text_anim
end

MissionBuffs._is_player_alive = function (self)
	local player

	if Managers.connection:is_initialized() then
		local peer_id = Network.peer_id()
		local local_player_id = 1

		player = Managers.player:player(peer_id, local_player_id)
	end

	local unit = player and player.player_unit
	local unit_data_extension = unit and ScriptUnit.extension(unit, "unit_data_system")
	local is_spectating = unit_data_extension and PlayerUnitStatus.is_hogtied(unit_data_extension:read_component("character_state"))
	local player_not_alive = not player or player and not player:unit_is_alive()

	return not player_not_alive and not is_spectating
end

MissionBuffs._is_player_in_mission = function (self)
	return self._current_game_mode == "survival"
end

MissionBuffs._should_force_inactivate = function (self)
	if self._states.view == "inactive" then
		return false
	end

	return not self:_is_player_in_mission() and not self:_is_player_alive()
end

MissionBuffs._check_cutscene_state = function (self)
	local cutscene_ended = false
	local game_mode_changed = false
	local cinematic_manager = Managers.state.cinematic

	if cinematic_manager then
		local is_cinematic_active = cinematic_manager:is_playing()

		if self._is_cutscene_active ~= is_cinematic_active then
			self._is_cutscene_active = is_cinematic_active
			cutscene_ended = is_cinematic_active == false
		end
	end

	local game_mode_manager = Managers.state.game_mode

	if game_mode_manager then
		local game_mode_name = game_mode_manager and game_mode_manager:game_mode_name()

		if self._current_game_mode ~= game_mode_name then
			self._current_game_mode = game_mode_name
			game_mode_changed = true
		end
	end

	if self._cutscene_fade and (cutscene_ended or game_mode_changed) then
		self:_cutscene_end()
	end
end

MissionBuffs._update_view_state = function (self, dt, ui_renderer)
	local view_state = self._states.view

	if self._update_view then
		if self._context.buffs then
			self:_present_buffs(ui_renderer)
		end

		self._widgets_by_name.title.content.show_background = self._context.is_wave_title
		self._update_view = nil
	end

	self:_check_cutscene_state()

	local timers_running = self:_are_timers_running()
	local animations_running = self:_are_animations_running()
	local texts_running = self:_has_text()
	local force_inactivate = self:_should_force_inactivate()

	if view_state == "inactive" then
		if animations_running or timers_running or texts_running then
			self._states.view = "active"
		end
	elseif view_state == "active" and (not animations_running and not timers_running and not texts_running or force_inactivate) then
		self:_reset_view(ui_renderer)

		if force_inactivate then
			self._queue_context = {}

			Log.info("ConstantElementMissionBuffs", "Force inactivate and empty queue context.")
		end

		self._states.view = "inactive"
	end

	self:_update_timers_state(dt, ui_renderer)
	self:_update_buffs_state(dt, ui_renderer)
	self:_update_texts_state(dt, ui_renderer)
	self:_update_blur_state(dt, ui_renderer)
end

MissionBuffs._update_timers_state = function (self, dt, ui_renderer)
	if self._texts_timer then
		self._previous_texts_timer = self._texts_timer
		self._texts_timer = self._texts_timer - dt

		if self._texts_timer < 0 then
			self._texts_timer = nil
			self._previous_texts_timer = nil
		end
	end

	if self._buffs_timer then
		self._buffs_timer = self._buffs_timer - dt

		if self._buffs_timer < 0 then
			self._buffs_timer = nil
		end
	end

	if self._blur_timer then
		self._blur_timer = self._blur_timer - dt

		if self._blur_timer < 0 then
			self._blur_timer = nil
		end
	end
end

MissionBuffs._update_texts_state = function (self, dt, ui_renderer)
	if self._states.text == "inactive" then
		if self._texts_timer and self:_has_text() then
			self:_reset_text_animations()

			self._text_anim_id = self:_start_animation("on_text_enter", self._widgets_by_name)
			self._widgets_by_name.title.content.show_background = self._context.is_wave_title
			self._states.text = "starting"
		end
	elseif self._states.text == "starting" then
		if self._text_anim_id and self:_is_animation_completed(self._text_anim_id) or not self._text_anim_id then
			self._states.text = "active"
		end
	elseif self._states.text == "active" then
		if not self._texts_timer or self._context.is_buff_family and not self._context.is_catchup and self._context.buff_chosen then
			self._texts_timer = nil

			self:_reset_text_animations()

			self._text_anim_id = self:_start_animation("on_text_exit", self._widgets_by_name)
			self._states.text = "closing"
		end
	elseif self._states.text == "closing" then
		if self._text_anim_id and self:_is_animation_completed(self._text_anim_id) or not self._text_anim_id then
			self:_reset_text_animations()

			self._context.title = nil
			self._context.sub_title = nil
			self._widgets_by_name.title.content.text = ""
			self._widgets_by_name.sub_title.content.text = ""
			self._widgets_by_name.sub_title.content.original_text = ""
			self._widgets_by_name.title.content.show_background = false
			self._states.text = "inactive"
		end
	elseif self._states.text == "force_inactive" then
		self:_reset_text_animations()

		self._context.title = nil
		self._context.sub_title = nil
		self._widgets_by_name.title.content.text = ""
		self._widgets_by_name.sub_title.content.text = ""
		self._widgets_by_name.sub_title.content.original_text = ""
		self._widgets_by_name.title.content.show_background = false
		self._states.text = "inactive"
	end

	if self._states.text == "starting" or self._states.text == "active" then
		local title_text = self._context.title or ""
		local original_sub_title_text = self._context.sub_title or ""
		local sub_title_text = self._context.use_timer and string.format("%s\n%s", original_sub_title_text, TextUtilities.format_time_span_localized(self._texts_timer, false, true)) or original_sub_title_text

		if title_text ~= self._widgets_by_name.title.content.text then
			self._widgets_by_name.title.content.text = title_text

			if title_text ~= "" then
				local text_width, text_height = _calculate_text_size(self._widgets_by_name.title, "text", {
					1920,
					200,
				}, ui_renderer)

				self._widgets_by_name.title.content.size = {
					text_width,
					text_height,
				}

				self:_set_scenegraph_size("title", text_width, text_height)

				self._widgets_by_name.title.style.text_background.size_addition = {
					text_width * 0.5,
					text_height * 0.5,
				}
			end
		end

		if sub_title_text ~= self._widgets_by_name.sub_title.content.text then
			self._widgets_by_name.sub_title.content.text = sub_title_text

			if sub_title_text ~= "" then
				local text_width, text_height = _calculate_text_size(self._widgets_by_name.sub_title, "text", {
					1920,
					200,
				}, ui_renderer)

				self._widgets_by_name.sub_title.content.size = {
					text_width,
					text_height,
				}

				self:_set_scenegraph_size("sub_title", text_width, text_height)

				self._widgets_by_name.sub_title.style.text_background.size_addition = {
					text_width * 0.5,
					text_height * 0.5,
				}
			end
		end

		self._widgets_by_name.sub_title.content.original_text = original_sub_title_text

		local current_timer

		if self._context.use_timer then
			if self._texts_timer and self._previous_texts_timer and math.floor(self._texts_timer) ~= math.floor(self._previous_texts_timer) then
				current_timer = math.floor(self._texts_timer)
			elseif not self._texts_timer and not self._previous_texts_timer then
				current_timer = 0
			end
		end

		if current_timer then
			if current_timer == 4 then
				Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_timer_4_secs_left)
			elseif current_timer == 3 then
				Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_timer_3_secs_left)
			elseif current_timer == 2 then
				Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_timer_2_secs_left)
			elseif current_timer == 1 then
				Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_timer_1_secs_left)
			elseif current_timer == 0 then
				Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_timer_end)
			end
		end
	end
end

MissionBuffs._update_buffs_state = function (self, dt, ui_renderer)
	local buffs_state = self._states.buffs

	if buffs_state == "inactive" then
		if self._buffs_timer and self._buff_widgets then
			self:_reset_buff_animations()

			self._buff_anim_id = self:_start_animation("on_buff_enter", self._widgets_by_name, {
				buff_widgets = self._buff_widgets,
			})
			self._states.buffs = "starting"
		end
	elseif buffs_state == "starting" then
		if self._buff_anim_id and self:_is_animation_completed(self._buff_anim_id) or not self._buff_anim_id then
			self:_reset_buff_animations()

			if self._context.is_choice then
				self._allow_close_hotkey = false
			else
				self._allow_close_hotkey = true
				self._using_input = false
			end

			self._states.buffs = "active"
		end
	elseif buffs_state == "active" then
		if not self._buffs_timer and self._buff_widgets then
			if self._context.is_choice and not self._context.buff_chosen then
				self:_force_choice_resolution()
			end

			self:_reset_buff_animations()

			self._buff_anim_id = self:_start_animation("on_buff_exit", self._widgets_by_name, {
				buff_widgets = self._buff_widgets,
			})
			self._states.buffs = "closing"
		elseif not self._buffs_timer then
			if self._context.is_choice and not self._context.buff_chosen then
				self:_force_choice_resolution()
			end

			self._states.buffs = "force_inactive"
		end
	elseif buffs_state == "closing" then
		if self._cursor_pushed then
			self:_pop_cursor()
		end

		self._allow_close_hotkey = false
		self._using_input = false

		if self._buff_anim_id and self:_is_animation_completed(self._buff_anim_id) or not self._buff_anim_id then
			self:_reset_buff_animations()

			self._states.buffs = "inactive"
		end
	elseif buffs_state == "force_inactive" then
		if self._context.is_choice and not self._context.buff_chosen then
			self:_force_choice_resolution()
		end

		self:_reset_text_animations()

		if self._cursor_pushed then
			self:_pop_cursor()
		end

		self._allow_close_hotkey = false
		self._using_input = false
		self._states.buffs = "inactive"
	end

	if buffs_state == "active" then
		if self._context.is_choice and self._is_visible and not self._tactical_overlay_active and not self._using_input then
			self._using_input = true

			if not self._cursor_pushed then
				self:_push_cursor()
			end
		elseif (not self._is_visible or self._tactical_overlay_active) and self._using_input then
			self._using_input = false

			if self._cursor_pushed then
				self:_pop_cursor()
			end
		end
	end
end

MissionBuffs._update_blur_state = function (self, dt, ui_renderer)
	local blur_state = self._states.blur

	if blur_state == "inactive" then
		if (self._states.buffs == "starting" or self._states.buffs == "active") and self._context.is_choice and not self._tactical_overlay_active and self._is_visible and not self._using_blur then
			self._blur_timer = 1
			self._blur_amount = 0.6
			self._states.blur = "animating"
		elseif (self._states.buffs == "closing" and self._context.is_choice and self._context.buff_chosen or not self._context.is_choice or self._states.buffs == "inactive" or self._tactical_overlay_active or not self._is_visible) and self._using_blur then
			self._blur_timer = 1
			self._blur_amount = 0
			self._states.blur = "animating"
		end
	elseif blur_state == "animating" then
		if not self._blur_timer then
			self._states.blur = "complete"
		end
	elseif blur_state == "complete" then
		self._total_blur_timer = nil

		self:_set_background_blur(self._blur_amount)

		self._blur_amount = nil
		self._states.blur = "inactive"
	elseif blur_state == "force_inactive" then
		self._total_blur_timer = nil

		self:_set_background_blur(0)

		self._blur_amount = nil
		self._states.blur = "inactive"
	end

	if blur_state == "animating" and self._blur_timer then
		if not self._total_blur_timer then
			self._total_blur_timer = self._blur_timer
		end

		local progress = 1 - self._blur_timer / self._total_blur_timer
		local anim_progress = math.easeOutCubic(progress)
		local blur = self._blur_amount * anim_progress

		self:_set_background_blur(blur)
	end
end

MissionBuffs.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._queue_context[1] and table.is_empty(self._context) then
		self._context = table.clone(self._queue_context[1])
		self._texts_timer = self._context.texts_timer
		self._buffs_timer = self._context.buffs_timer
		self._update_view = true

		table.remove(self._queue_context, 1)
		Log.info("ConstantElementMissionBuffs", "Update view with queued context. ItemsLeftInQueue[%d] | WaveNum[%d] | Buffs? %s | Is Choice? %s", self._queue_context and #self._queue_context or 0, self._context.wave_num or 0, self._context.is_choice and "Y" or "N", self._context.buffs and "Y" or "N")

		if self._context.buffs then
			Log.info("ConstantElementMissionBuffs", "Buffs in context: Buff1[%s] | Buff2[%s] | Buff2[%s]", self._context.buffs[1] and self._context.buffs[1].buff_name, self._context.buffs[2] and self._context.buffs[2].buff_name, self._context.buffs[3] and self._context.buffs[3].buff_name)
		end
	end

	self:_update_view_state(dt, ui_renderer)
	self:_handle_input(input_service, dt, t)

	return MissionBuffs.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

MissionBuffs._handle_input = function (self, input_service, dt, t)
	if self._context.is_choice and not self._context.buff_chosen and not self._await_input_release then
		if self._using_cursor_navigation and input_service:get("left_hold") then
			Managers.ui:add_inputs_in_use_by_ui("left")

			self._await_input_release = true
		elseif not self._using_cursor_navigation and input_service:get("confirm_hold") then
			Managers.ui:add_inputs_in_use_by_ui("confirm")

			self._await_input_release = true
		end
	end

	if self._await_input_release and (self._using_cursor_navigation and not input_service:get("left_hold") or not self._using_cursor_navigation and not input_service:get("confirm_hold")) then
		Managers.ui:remove_inputs_in_use_by_ui("left")
		Managers.ui:remove_inputs_in_use_by_ui("confirm")

		self._await_input_release = nil
	end

	local service_type = "Ingame"
	local ingame_input_service = Managers.input:get_input_service(service_type)

	if not ingame_input_service:is_null_service() and self._context.is_choice and not self._context.buff_chosen then
		local tactical_overlay_input_pressed = ingame_input_service:get("tactical_overlay_hold")

		if not not tactical_overlay_input_pressed ~= self._tactical_overlay_active then
			if not tactical_overlay_input_pressed then
				self._tactical_overlay_active = false

				Managers.event:trigger("event_tactical_overlay_change_using_input", false)
			else
				self._tactical_overlay_active = true

				Managers.event:trigger("event_tactical_overlay_change_using_input", true)
			end
		end
	end

	if not self._using_input then
		return
	end

	local service_type = "View"

	input_service = Managers.input:get_input_service(service_type)

	if not input_service:is_null_service() then
		local using_cursor_navigation = Managers.ui:using_cursor_navigation()

		if self._using_cursor_navigation ~= using_cursor_navigation or self._using_cursor_navigation == nil then
			self._using_cursor_navigation = using_cursor_navigation

			self:_on_navigation_input_changed()
		end

		if not self._using_cursor_navigation and self._context.buffs and #self._context.buffs > 1 then
			local next_index

			if input_service:get("navigate_left_continuous") then
				next_index = self._selected_index and self._selected_index - 1 or 1
			elseif input_service:get("navigate_right_continuous") then
				next_index = self._selected_index and self._selected_index + 1 or 1
			end

			if next_index then
				self:_select_buff_by_index(next_index)
			end
		end
	end
end

MissionBuffs._select_buff_by_index = function (self, wanted_index)
	if self._buff_widgets and #self._buff_widgets > 1 then
		local new_index = wanted_index and math.clamp(wanted_index, 1, #self._buff_widgets)

		if new_index ~= self._selected_index then
			self._selected_index = new_index

			for i = 1, #self._buff_widgets do
				local widget = self._buff_widgets[i]

				widget.content.hotspot.is_selected = i == self._selected_index
			end
		end
	end
end

MissionBuffs._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self:_select_buff_by_index()
	else
		self:_select_buff_by_index(1)
	end

	if self._buff_widgets then
		for i = 1, #self._buff_widgets do
			local widget = self._buff_widgets[i]
			local input_action = self._using_cursor_navigation and "left_hold" or "confirm_hold"

			widget.content.confirm_text = TextUtils.localize_with_button_hint(input_action, "loc_select", nil, nil, Localize("loc_input_legend_text_template"), true)
		end
	end
end

MissionBuffs._presentation_changed = function (self, context)
	self:_update_presentation(context)
end

MissionBuffs._update_presentation = function (self, context)
	if self._context.is_choice and not self._context.buff_chosen then
		self:_force_choice_resolution()
	end

	local buffs_data

	if context and context.buffs then
		buffs_data = {}

		for i = 1, #context.buffs do
			buffs_data[#buffs_data + 1] = {
				buff_name = context.buffs[i],
			}
		end
	end

	local timer = context and context.timer or DEFAULT_TIMER
	local num_waves_per_island = HordesModeSettings.waves_per_island
	local queue_context = {}

	if buffs_data and #buffs_data == 1 then
		queue_context.buffs_timer = DEFAULT_TIMER
	elseif buffs_data and #buffs_data > 1 then
		queue_context.buffs_timer = timer
	end

	local is_before_first_wave_start = context.wave_num == nil
	local is_after_last_wave_end = context.state == "completed" and num_waves_per_island <= context.wave_num
	local is_choice = context.buffs and #context.buffs > 1
	local is_catchup = context.state == "completed" and self._previous_context_revceived_state == context.state
	local is_wave_title
	local pre_queue_context = {}

	if context.wave_num and context.state == "completed" and buffs_data and #buffs_data > 1 then
		pre_queue_context.title = Localize("loc_horde_wave_completed", true, {
			wave = context.wave_num or 1,
		})
		is_wave_title = true

		if context.is_buff_family then
			queue_context.title = Localize("loc_horde_buff_family_pick")
		else
			queue_context.title = Localize("loc_horde_buff_big_pick")
		end
	elseif context.wave_num and context.state == "completed" then
		pre_queue_context.title = Localize("loc_horde_wave_completed", true, {
			wave = context.wave_num or 1,
		})
		is_wave_title = true
	elseif context.wave_num then
		queue_context.title = Localize("loc_horde_wave_start", true, {
			wave = context.wave_num,
		})
		is_wave_title = true
	elseif buffs_data and context.is_buff_family then
		queue_context.title = Localize("loc_horde_buff_family_pick")
	end

	if context and buffs_data and #buffs_data > 1 and is_before_first_wave_start then
		queue_context.sub_title = Localize("loc_horde_buff_family_time")
		queue_context.use_timer = true
	elseif not is_before_first_wave_start and not is_after_last_wave_end and timer > DEFAULT_TIMER or is_catchup then
		queue_context.sub_title = Localize("loc_horde_buff_big_time", true, {
			wave = context.wave_num and context.wave_num + 1 or 1,
		})
		queue_context.use_timer = true
	elseif context and buffs_data and #buffs_data == 1 then
		queue_context.sub_title = Localize("loc_horde_buff_small_granted")
	end

	local family_sfx
	local buff_family_source_id = context.buff_family_source_id

	if buff_family_source_id then
		family_sfx = HordesBuffsData[buff_family_source_id] and HordesBuffsData[buff_family_source_id].sfx
	end

	queue_context.buffs = buffs_data
	queue_context.buff_family_sfx = family_sfx
	queue_context.is_buff_family = context and context.is_buff_family
	queue_context.texts_timer = timer
	queue_context.wave_num = context.wave_num or 0
	queue_context.state = context.state
	queue_context.is_choice = is_choice
	queue_context.is_catchup = is_catchup

	local queues_to_add = {}
	local add_pre_queue = not table.is_empty(pre_queue_context) and self._previous_context_revceived_state ~= context.state and context.state == "completed"
	local add_queue = not table.is_empty(queue_context)

	if is_catchup then
		if context.is_buff_family or table.is_empty(self._context) then
			-- Nothing
		elseif not table.is_empty(self._context) then
			self._buffs_timer = nil
			self._texts_timer = nil
		end

		self._queue_context = {}

		if self._context.buffs then
			Log.info("ConstantElementMissionBuffs", "Buffs in context: Buff1[%s] | Buff2[%s] | Buff2[%s]", self._context.buffs[1] and self._context.buffs[1].buff_name, self._context.buffs[2] and self._context.buffs[2].buff_name, self._context.buffs[3] and self._context.buffs[3].buff_name)
		end
	elseif not table.is_empty(self._context) and not self._context.is_choice then
		self._buffs_timer = nil
		self._texts_timer = nil
	end

	if add_pre_queue then
		pre_queue_context.state = queue_context.state
		pre_queue_context.wave_num = queue_context.wave_num
		pre_queue_context.texts_timer = DEFAULT_TIMER
		pre_queue_context.is_wave_title = is_wave_title
		self._queue_context[#self._queue_context + 1] = pre_queue_context
		queue_context.texts_timer = queue_context.texts_timer - pre_queue_context.texts_timer
	else
		queue_context.is_wave_title = is_wave_title
	end

	if add_queue then
		self._queue_context[#self._queue_context + 1] = queue_context

		Log.info("ConstantElementMissionBuffs", "Add context to queue. WaveNum[%d] | Buffs[%d] | IsFamilyChoice[%s]", queue_context.wave_num or 0, queue_context.buffs and #queue_context.buffs or 0, queue_context.is_buff_family and "Y" or "N")
	end

	self._previous_context_revceived_state = context.state
end

MissionBuffs._force_choice_resolution = function (self)
	if self._context.is_choice and not self._context.buff_chosen then
		local random_buff_index = math.random(1, #self._context.buffs)

		self:_handle_choice_resolution(random_buff_index, true)
	end
end

MissionBuffs._play_buff_acquired_sounds = function (self)
	local family_sfx = self._context and self._context.buff_family_sfx
	local is_choice = self._context and self._context.is_choice

	if self._context.is_buff_family then
		Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_family_blessing_chosen)
	elseif family_sfx then
		Managers.ui:play_2d_sound(family_sfx)
	else
		Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_generic_blessing_chosen)
	end
end

MissionBuffs._handle_choice_resolution = function (self, choice_index, is_random_timeout_choice)
	if Managers.telemetry_events then
		local options = {}

		for _, buff_data in ipairs(self._context.buffs) do
			table.insert(options, {
				buff_name = buff_data.buff_name,
			})
		end

		Managers.telemetry_events:hordes_player_choice_completed(self._context.is_buff_family, options, choice_index, is_random_timeout_choice)
	end

	self:_play_buff_acquired_sounds()

	self._buffs_timer = nil
	self._context.buff_chosen = choice_index

	for i = 1, #self._buff_widgets do
		local widget = self._buff_widgets[i]

		widget.content.is_chosen_buff = i == choice_index
		widget.content.hotspot.disabled = true
	end

	self._context.title = nil

	Managers.event:trigger("event_surival_mode_buff_choice", choice_index)
end

MissionBuffs.using_input = function (self)
	return self._using_input
end

MissionBuffs._push_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name

	input_manager:push_cursor(name)

	self._cursor_pushed = true
end

MissionBuffs._pop_cursor = function (self)
	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end
end

MissionBuffs._reset_view = function (self, ui_renderer)
	self:_destroy_background()

	if self._cursor_pushed then
		self:_pop_cursor()
	end

	self._texts_timer = nil
	self._buffs_timer = nil
	self._blur_timer = nil
	self._cutscene_fade = nil
	self._update_view = nil
	self._states.buffs = "force_inactive"
	self._states.text = "force_inactive"
	self._states.blur = "force_inactive"
	self._context = {}

	self:_reset_buff_animations()
	self:_reset_text_animations()

	if ui_renderer then
		self:_destroy_buff_widgets(ui_renderer)
	end

	self._widgets_by_name.title.content.text = ""
	self._widgets_by_name.sub_title.content.text = ""
	self._widgets_by_name.sub_title.content.original_text = ""

	if self._tactical_overlay_active then
		Managers.event:trigger("event_tactical_overlay_change_using_input", false)

		self._tactical_overlay_active = false
	end
end

MissionBuffs.destroy = function (self, ui_renderer)
	self:_reset_view(ui_renderer)

	self._queue_context = {}

	MissionBuffs.super.destroy(self)
end

MissionBuffs._has_text = function (self)
	return self._context.title or self._context.sub_title
end

MissionBuffs._reset_buff_animations = function (self)
	if self._buff_anim_id then
		if not self:_is_animation_completed(self._buff_anim_id) then
			self:_complete_animation(self._buff_anim_id)
		end

		self._buff_anim_id = nil
	end
end

MissionBuffs._reset_text_animations = function (self)
	if self._text_anim_id then
		if not self:_is_animation_completed(self._text_anim_id) then
			self:_complete_animation(self._text_anim_id)
		end

		self._text_anim_id = nil
	end
end

MissionBuffs.should_update = function (self)
	return true
end

MissionBuffs.should_draw = function (self)
	return not self._cutscene_fade and self._is_visible and self._states.view ~= "inactive" and self:_is_player_in_mission() and self:_is_player_alive()
end

return MissionBuffs
