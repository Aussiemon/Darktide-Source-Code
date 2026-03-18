-- chunkname: @scripts/ui/constant_elements/elements/expedition_continue/constant_element_expedition_continue.lua

local ConstantElementExpeditionContinueDefinitions = require("scripts/ui/constant_elements/elements/expedition_continue/constant_element_expedition_continue_definitions")
local ConstantElementExpeditionContinueBlueprints = require("scripts/ui/constant_elements/elements/expedition_continue/constant_element_expedition_continue_blueprints")
local Text = require("scripts/utilities/ui/text")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ConstantElementExpeditionContinue = class("ConstantElementExpeditionContinue", "ConstantElementBase")

ConstantElementExpeditionContinue.init = function (self, parent, draw_layer, start_scale)
	ConstantElementExpeditionContinue.super.init(self, parent, draw_layer, start_scale, ConstantElementExpeditionContinueDefinitions)

	self._context = {}
	self._view_state = "inactive"

	self:_register_event("event_show_expedition_continue_popup")
	self:_register_event("event_hide_expedition_continue_popup")
	self:_register_event("event_cutscene_fade_in", "_cutscene_start")
	self:_register_event("event_cutscene_fade_out", "_cutscene_end")
end

ConstantElementExpeditionContinue._setup_background_gui = function (self)
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

ConstantElementExpeditionContinue._destroy_background = function (self)
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

ConstantElementExpeditionContinue.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ConstantElementExpeditionContinue._generate_option_widgets = function (self, layout, ui_renderer)
	self:_destroy_option_widgets(ui_renderer)

	local left_click_callback_name = "_cb_on_option_clicked"

	self._option_widgets = {}

	local card_width_margin = 50
	local total_width = 0

	for i = 1, #layout do
		local layout_element = layout[i]
		local widget_type = layout_element.widget_type
		local blueprint = ConstantElementExpeditionContinueBlueprints[widget_type]
		local size = blueprint.size
		local ui_passes = blueprint.pass_template
		local scenegraph_name = "options_area"
		local definition = UIWidget.create_definition(ui_passes, scenegraph_name, nil, size)
		local widget = self:_create_widget("option_" .. i, definition)

		blueprint.init(self, widget, layout_element, left_click_callback_name, nil, ui_renderer)

		local x_offset = (size[1] + card_width_margin) * (i - 1)

		widget.offset[1] = x_offset
		total_width = x_offset + size[1]
		self._option_widgets[#self._option_widgets + 1] = widget
	end

	local card_size = {
		450,
		335,
	}
	local grid_size = {
		total_width,
		card_size[2],
	}

	self:_set_scenegraph_size("options_area", grid_size[1], grid_size[2])
end

ConstantElementExpeditionContinue._update_option_widgets = function (self, ui_renderer, voting_id)
	local option_widgets = self._option_widgets

	for i = 1, #option_widgets do
		local widget = option_widgets[i]
		local content = widget.content
		local element = content.element
		local widget_type = element.widget_type
		local blueprint = ConstantElementExpeditionContinueBlueprints[widget_type]

		blueprint.update(self, widget, voting_id, ui_renderer)
	end
end

ConstantElementExpeditionContinue._destroy_option_widgets = function (self, ui_renderer)
	if self._option_widgets then
		for i = 1, #self._option_widgets do
			local widget = self._option_widgets[i]

			self:_unregister_widget_name(widget.name)
			UIWidget.destroy(ui_renderer, widget)
		end

		self._option_widgets = nil
	end
end

ConstantElementExpeditionContinue._set_background_blur = function (self, blur_amount)
	self._using_blur = blur_amount > 0 and true or false

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

ConstantElementExpeditionContinue._cb_on_option_clicked = function (self, widget, element)
	if self._delay_before_can_select_option then
		return
	end

	local vote_value = element.vote_value

	self._option_chosen = true

	local local_player = Managers.player:local_player(1)
	local local_player_fx_extension = local_player and ScriptUnit.has_extension(local_player.player_unit, "fx_system")

	if local_player_fx_extension then
		local_player_fx_extension:trigger_wwise_event("wwise/events/ui/play_ui_expeditions_menu_keep_exploring", false)
	end

	local voting_id = self._voting_id

	Managers.voting:cast_vote(voting_id, vote_value)
end

ConstantElementExpeditionContinue._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 1

	ConstantElementExpeditionContinue.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if self._option_widgets then
		for i = 1, #self._option_widgets do
			local widget = self._option_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

ConstantElementExpeditionContinue.on_resolution_modified = function (self, scale)
	ConstantElementExpeditionContinue.super.on_resolution_modified(self, scale)
end

ConstantElementExpeditionContinue._cutscene_start = function (self)
	self._cutscene_fade = true
end

ConstantElementExpeditionContinue._cutscene_end = function (self)
	self._cutscene_fade = nil
end

ConstantElementExpeditionContinue._are_animations_running = function (self)
	local enter_option_anim = self._on_option_enter_anim_id and not self:_is_animation_completed(self._on_option_enter_anim_id)
	local exit_option_anim = self._on_option_exit_anim_id and not self:_is_animation_completed(self._on_option_exit_anim_id)
	local enter_text_anim = self._on_text_enter_anim_id and not self:_is_animation_completed(self._on_text_enter_anim_id)
	local exit_text_anim = self._on_text_exit_anim_id and not self:_is_animation_completed(self._on_text_exit_anim_id)

	return enter_option_anim or exit_option_anim or enter_text_anim or exit_text_anim
end

ConstantElementExpeditionContinue._should_inactivate = function (self)
	local is_inactive = self._view_state == "inactive"

	if not is_inactive then
		return false
	end

	local game_mode_manager = Managers.state.game_mode
	local game_mode_name = game_mode_manager and game_mode_manager:game_mode_name()
	local in_mission = game_mode_name and game_mode_name == "expedition"
	local animations_running = self:_are_animations_running()
	local voting_exists = self._voting_id and Managers.voting:voting_exists(self._voting_id)

	return not in_mission or not voting_exists and not animations_running
end

ConstantElementExpeditionContinue.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._close_popup then
		self._close_popup = nil
		self._voting_id = nil
		self._blur_duration = 0
		self._blur_amount = 0
		self._allow_close_hotkey = false
		self._using_input = false

		if self._cursor_pushed then
			self:_pop_cursor()
		end

		self:_reset_option_animations()
		self:_reset_text_animations()

		self._widgets_by_name.title.content.text = ""
		self._widgets_by_name.sub_title.content.text = ""
		self._widgets_by_name.sub_title.content.original_text = ""

		self:_change_state("inactive", ui_renderer)
	end

	if self._start_popup then
		self._start_popup = nil

		self:_change_state("active", ui_renderer)

		local layout = {
			{
				description = "A tempting opportunity at the risk losing everything if you fail.\n\nThe next location will be more challenging.",
				sub_title = "Explore another location",
				title = "KEEP EXPLORING",
				vote_value = "yes",
				widget_type = "option_card",
			},
			{
				description = "Return to the Mourningstar bringing all you have found.\n\nRations and a chair will be provided.",
				sub_title = "End the expedition now",
				title = "EXTRACT",
				vote_value = "no",
				widget_type = "option_card",
			},
		}

		self:_generate_option_widgets(layout, ui_renderer)

		self._on_option_enter_anim_id = self:_start_animation("on_option_enter", self._widgets_by_name, {
			option_widgets = self._option_widgets,
		})
	end

	if self._view_state == "active" then
		local voting_id = self._voting_id
		local voting_manager = Managers.voting
		local voting_exists = voting_id and voting_manager:voting_exists(voting_id)

		if voting_exists then
			local voting_template = voting_manager:voting_template(voting_id)
			local time_left = voting_manager:time_left(voting_id)
			local votes = voting_manager:votes(voting_id)

			self:_update_option_widgets(ui_renderer, voting_id)

			local time_left_text = Text.format_time_span_localized(time_left, false, true)

			self._widgets_by_name.title.content.text = "title_text"
			self._widgets_by_name.sub_title.content.text = "sub_title_text"
			self._widgets_by_name.sub_title.content.original_text = "original_sub_title_text"

			if not self._on_text_enter_anim_id then
				self._on_text_enter_anim_id = self:_start_animation("on_text_enter", self._widgets_by_name)
			end

			if not self._cursor_pushed and self._using_input then
				self:_push_cursor()
			end

			if self._delay_before_can_select_option then
				self._delay_before_can_select_option = self._delay_before_can_select_option > 0 and self._delay_before_can_select_option - dt or nil
			end

			self._widgets_by_name.title.content.text = "ARE YOU READY TO LEAVE? OR WOULD YOU TAKE THE RISK TO CONTINUE?"
			self._widgets_by_name.sub_title.content.text = time_left_text
		end
	end

	if self._blur_duration then
		if not self._total_blur_duration then
			self._total_blur_duration = self._blur_duration
		end

		if self._blur_duration <= 0 then
			self._blur_duration = nil
			self._total_blur_duration = nil
			self._alpha_multiplier = 1

			self:_set_background_blur(self._blur_amount)

			self._blur_amount = nil
		else
			local progress = 1 - self._blur_duration / self._total_blur_duration
			local anim_progress = math.easeOutCubic(progress)
			local blur = self._blur_amount * anim_progress

			self:_set_background_blur(blur)

			self._blur_duration = self._blur_duration - dt
			self._alpha_multiplier = anim_progress
		end
	end

	self:_handle_input(input_service, dt, t)

	return ConstantElementExpeditionContinue.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementExpeditionContinue._handle_input = function (self, input_service, dt, t)
	local is_input_blocked = Managers.ui:using_input(nil, nil, true)

	if self._view_state ~= "active" or is_input_blocked then
		if self._using_input then
			self._using_input = false
			self._blur_duration = 0
			self._blur_amount = 0
		end

		return
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

		if not self._using_cursor_navigation then
			local next_index

			if input_service:get("navigate_left_continuous") then
				next_index = self._selected_index and self._selected_index - 1 or 1
			elseif input_service:get("navigate_right_continuous") then
				next_index = self._selected_index and self._selected_index + 1 or 1
			end

			if next_index then
				self:_select_option_by_index(next_index)
			end
		end
	end
end

ConstantElementExpeditionContinue._select_option_by_index = function (self, wanted_index)
	if self._option_widgets and #self._option_widgets > 1 then
		local new_index = math.clamp(wanted_index, 1, #self._option_widgets)

		if new_index ~= self._selected_index then
			self._selected_index = new_index

			for i = 1, #self._option_widgets do
				local widget = self._option_widgets[i]

				widget.content.hotspot.is_selected = i == self._selected_index
			end
		end
	end
end

ConstantElementExpeditionContinue._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		ConstantElementExpeditionContinue:_select_option_by_index()
	else
		ConstantElementExpeditionContinue:_select_option_by_index(1)
	end
end

ConstantElementExpeditionContinue.event_show_expedition_continue_popup = function (self, context)
	self._voting_id = context.voting_id
	self._blur_duration = 1
	self._blur_amount = 0.6
	self._allow_close_hotkey = true
	self._using_input = true
	self._start_popup = true
end

ConstantElementExpeditionContinue.event_hide_expedition_continue_popup = function (self)
	self._close_popup = true
end

ConstantElementExpeditionContinue.using_input = function (self)
	return self._using_input
end

ConstantElementExpeditionContinue._push_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name

	input_manager:push_cursor(name)

	self._cursor_pushed = true
end

ConstantElementExpeditionContinue._pop_cursor = function (self)
	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end
end

ConstantElementExpeditionContinue._reset_view = function (self, ui_renderer)
	self:_destroy_background()

	if self._cursor_pushed then
		self:_pop_cursor()
	end

	self._allow_close_hotkey = false
	self._using_input = false
	self._cutscene_fade = nil
	self._context = {}

	self:_reset_animations()

	if ui_renderer then
		self:_destroy_option_widgets(ui_renderer)
	end

	self._widgets_by_name.title.content.text = ""
	self._widgets_by_name.sub_title.content.text = ""
	self._widgets_by_name.sub_title.content.original_text = ""
end

ConstantElementExpeditionContinue.destroy = function (self, ui_renderer)
	self:_reset_view(ui_renderer)
	self:_unregister_event("event_show_expedition_continue_popup")
	self:_unregister_event("event_hide_expedition_continue_popup")
	self:_unregister_event("event_cutscene_fade_in")
	self:_unregister_event("event_cutscene_fade_out")
	ConstantElementExpeditionContinue.super.destroy(self)
end

ConstantElementExpeditionContinue._reset_animations = function (self)
	self:_reset_option_animations()
	self:_reset_text_animations()
end

ConstantElementExpeditionContinue._reset_option_animations = function (self)
	if self._on_option_enter_anim_id then
		if not self:_is_animation_completed(self._on_option_enter_anim_id) then
			self:_complete_animation(self._on_option_enter_anim_id)
		end

		self._on_option_enter_anim_id = nil
	end

	if self._on_option_exit_anim_id then
		if not self:_is_animation_completed(self._on_option_exit_anim_id) then
			self:_complete_animation(self._on_option_exit_anim_id)
		end

		self._on_option_exit_anim_id = nil
	end
end

ConstantElementExpeditionContinue._reset_text_animations = function (self)
	if self._on_text_enter_anim_id then
		if not self:_is_animation_completed(self._on_text_enter_anim_id) then
			self:_complete_animation(self._on_text_enter_anim_id)
		end

		self._on_text_enter_anim_id = nil
	end

	if self._on_text_exit_anim_id then
		if not self:_is_animation_completed(self._on_text_exit_anim_id) then
			self:_complete_animation(self._on_text_exit_anim_id)
		end

		self._on_text_exit_anim_id = nil
	end
end

ConstantElementExpeditionContinue._change_state = function (self, state_name, ui_renderer)
	if self._view_state ~= state_name then
		if state_name == "active" then
			-- Nothing
		elseif state_name == "inactive" then
			self:_reset_view(ui_renderer)

			self._blur_duration = 0
			self._blur_amount = 0
		else
			return
		end

		self._previous_view_state = self._view_state
		self._view_state = state_name
	end
end

ConstantElementExpeditionContinue.should_update = function (self)
	return not self._cutscene_fade
end

ConstantElementExpeditionContinue.should_draw = function (self)
	return not self._cutscene_fade and self._is_visible and self._view_state ~= "inactive"
end

return ConstantElementExpeditionContinue
