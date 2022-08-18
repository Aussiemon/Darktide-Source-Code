require("scripts/ui/view_elements/view_element_base")
require("scripts/ui/views/base_view")

local ViewTransitionUI = require("scripts/ui/view_transition_ui")
local UIViewHandler = class("UIViewHandler")
UIViewHandler.DEBUG_TAG = "UI View Handler"
UIViewHandler.MIN_LAYER = 1
UIViewHandler.MAX_LAYER = 999
UIViewHandler.LAYERS_PER_VIEW = 50
UIViewHandler.TRANSITION_SPEED = 4
local DO_RELOAD = false
local TEMP_DRAWN_VIEWS = {}

UIViewHandler.init = function (self, view_list, timer_name)
	self._view_list = view_list
	self._active_views_array = {}
	self._active_views_data = {}
	self._num_active_views = 0
	self._timer_name = timer_name
	self._any_view_using_input = false
	self._game_world_disabled = false
	self._game_world_fullscreen_blur_enabled = false
	self._game_world_fullscreen_blur_amount = 0
	self._registered_view_worlds = {}
	self._curent_frame_view_layers = {}
	self._transition_ui = ViewTransitionUI:new()
	DO_RELOAD = false

	Managers.event:register(self, "trigger_view_widget_pressed", "cb_trigger_view_widget_pressed")
end

UIViewHandler.cb_trigger_view_widget_pressed = function (self, view_name, widget_name, optional_content_id)
	local view_data = self._active_views_data[view_name]

	fassert(view_data, "[UIViewHandler] - Cannot trigger widget pressed. View with name: %s is not active.", view_name)

	local instance = view_data.instance

	instance:trigger_widget_pressed(widget_name)
end

UIViewHandler.open_view = function (self, view_name, transition_time, close_previous, close_all, close_transition_time, context)
	local num_active_views = self._num_active_views
	local has_active_views = num_active_views > 0

	self:_open(view_name, transition_time, context)

	if not has_active_views then
		return
	end

	local active_views_array = self._active_views_array

	if close_all then
		for _, name in ipairs(active_views_array) do
			if name ~= view_name then
				self:close_view(name)
			end
		end
	elseif close_previous then
		local previous_top_view = active_views_array[num_active_views]

		self:close_view(previous_top_view)
	end
end

UIViewHandler.can_close = function (self, view_name)
	local time = self:_get_time()
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]

	if time <= view_data.opening_time then
		return false
	end

	if view_data.closing then
		return false
	end

	local view_instance = view_data.instance

	return view_instance:can_exit()
end

UIViewHandler.allow_to_pass_input_for_view = function (self, view_name)
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]

	return view_data.allow_next_input
end

UIViewHandler.allow_close_hotkey_for_view = function (self, view_name)
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]
	local view_instance = view_data.instance

	return view_instance:allow_close_hotkey()
end

UIViewHandler.close_all_views = function (self)
	local active_views_array = self._active_views_array
	local num_active_views = #active_views_array

	for i = num_active_views, 1, -1 do
		local view = active_views_array[i]
		local is_view_active = self:view_active(view)

		if is_view_active and not self:is_view_closing(view) then
			self:close_view(view)
		end
	end
end

UIViewHandler.close_view = function (self, view_name, force_close)
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]

	fassert(view_data, "[UIViewHandler] - View with name: %s is not active", view_name)

	if view_data.closing then
		Log.error("UIViewHandler", "View with name: %s has already been marked for destruction", view_name)

		return
	end

	view_data.closing = true
	local instance = view_data.instance
	instance.closing_view = true

	instance:trigger_on_exit_animation()

	local view_settings = self:settings_by_view_name(view_name)
	local use_transition_ui = view_settings.use_transition_ui

	if force_close then
		self:_force_close(view_name)
	elseif use_transition_ui then
		view_data.use_transition_ui_on_animation_on_exit_done = true
		view_data.fade_in = nil
		view_data.fade_out = nil
	elseif instance:on_exit_animation_done() and not self._updating_views and not self._drawing_views then
		self:_force_close(view_name)
	end
end

UIViewHandler.wwise_music_state = function (self, wwise_state_group_name)
	local active_views_array = self._active_views_array

	for i = #active_views_array, 1, -1 do
		local view_name = active_views_array[i]

		if not TEMP_DRAWN_VIEWS[view_name] then
			return nil
		end

		local view_settings = self:settings_by_view_name(view_name)
		local wwise_state = view_settings.wwise_states and view_settings.wwise_states[wwise_state_group_name]

		if wwise_state then
			return wwise_state
		end
	end
end

UIViewHandler.destroy = function (self)
	self._transition_ui:destroy()

	self._transition_ui = nil
	local active_views_array = self._active_views_array
	local num_active_views = #active_views_array

	for i = num_active_views, 1, -1 do
		local view_name = active_views_array[i]

		self:_force_close(view_name)
	end

	self._active_views_data = nil
	self._active_views_array = nil

	Managers.event:unregister(self, "trigger_view_widget_pressed")
end

UIViewHandler._update_transition_progress = function (self, dt, transition_progress)
	local views_want_to_fade_in = false
	local views_want_to_fade_out = false
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data
	local num_active_views = self._num_active_views

	for i = num_active_views, 1, -1 do
		local view_name = active_views_array[i]
		local view_data = active_views_data[view_name]
		local instance = view_data.instance
		local is_loading_view = self:is_view_loading(view_name)

		if not is_loading_view then
			if view_data.fade_in then
				views_want_to_fade_in = true

				if transition_progress == 1 then
					view_data.fade_in = nil
					view_data.fade_out = true
					local fade_in_callback = view_data.fade_in_callback
					view_data.fade_in_callback = nil

					if fade_in_callback then
						fade_in_callback()
					end

					if not view_data.closing and not instance:triggered_on_enter_animation() then
						instance:trigger_on_enter_animation()
					end
				end
			elseif not view_data.closing and not instance:triggered_on_enter_animation() then
				instance:trigger_on_enter_animation()
			end
		end

		if view_data.fade_out then
			views_want_to_fade_out = true

			if transition_progress == 0 then
				view_data.fade_out = nil
				local fade_out_callback = view_data.fade_out_callback
				view_data.fade_out_callback = nil

				if fade_out_callback then
					fade_out_callback()
				end
			end
		end
	end

	local should_transition = views_want_to_fade_in or views_want_to_fade_out or transition_progress ~= 0

	if should_transition then
		local transition_speed = UIViewHandler.TRANSITION_SPEED

		if views_want_to_fade_in then
			transition_progress = math.min(transition_progress + dt * transition_speed, 1)
		else
			transition_progress = math.max(transition_progress - dt * transition_speed, 0)
		end
	else
		transition_progress = 0
	end

	return should_transition, transition_progress, views_want_to_fade_in, views_want_to_fade_out
end

local _TEMP_TRANSITION_DATA = {}

UIViewHandler.update = function (self, dt, t, allow_input)
	self._top_draw_layer = nil
	self._any_view_using_input = false
	self._transitioning = false
	self._allow_input = false

	table.clear(_TEMP_TRANSITION_DATA)

	local transition_ui = self._transition_ui
	local previous_transition_progress = transition_ui:progress()
	local transitioning, new_transition_progress, transitioning_in, transitioning_out = self:_update_transition_progress(dt, previous_transition_progress)

	if transitioning then
		allow_input = false
	end

	_TEMP_TRANSITION_DATA.transitioning = transitioning
	_TEMP_TRANSITION_DATA.new_transition_progress = new_transition_progress
	_TEMP_TRANSITION_DATA.transitioning_in = transitioning_in
	_TEMP_TRANSITION_DATA.transitioning_out = transitioning_out

	transition_ui:update(dt, t, transitioning, new_transition_progress)

	local num_active_views = self._num_active_views

	if num_active_views <= 0 then
		return
	end

	self._updating_views = true

	self:_update_views(dt, t, allow_input)

	self._updating_views = false
	self._allow_input = allow_input
end

UIViewHandler.draw = function (self, dt, t)
	table.clear(TEMP_DRAWN_VIEWS)

	local num_active_views = self._num_active_views

	if num_active_views <= 0 then
		return
	end

	local allow_input = self._allow_input
	local transitioning = _TEMP_TRANSITION_DATA.transitioning
	local transitioning_in = _TEMP_TRANSITION_DATA.transitioning_in
	local transitioning_out = _TEMP_TRANSITION_DATA.transitioning_out
	self._drawing_views = true

	self:_draw_views(dt, t, allow_input, transitioning_in, transitioning_out)

	self._drawing_views = false
	self._transitioning = transitioning
end

UIViewHandler.transitioning = function (self)
	return self._transitioning
end

UIViewHandler.is_view_loading = function (self, view_name)
	local instance = self:view_instance(view_name)

	return instance and instance:loading()
end

UIViewHandler.post_update = function (self, dt, t)
	self:_post_update_views(dt, t)
end

UIViewHandler.view_active = function (self, view_name)
	local active_views_data = self._active_views_data

	return active_views_data[view_name] ~= nil
end

UIViewHandler.is_view_closing = function (self, view_name)
	local view_data = self._active_views_data[view_name]

	return view_data and view_data.closing
end

UIViewHandler.settings_by_view_name = function (self, view_name)
	local view_list = self._view_list
	local view_settings = view_list[view_name]

	fassert(view_settings, "[UIViewHandler] - View list does not include View with name: %s.", view_name)

	return view_settings
end

UIViewHandler.view_instance = function (self, view_name)
	local view_data = self._active_views_data[view_name]
	local view_instance = view_data and view_data.instance

	return view_instance
end

UIViewHandler.active_top_view = function (self)
	local active_views_array = self._active_views_array
	local active_view = active_views_array[#active_views_array]

	return active_view
end

UIViewHandler.active_views = function (self)
	local active_views_array = self._active_views_array

	return active_views_array
end

UIViewHandler.using_input = function (self)
	local active_views_array = self._active_views_array

	return #active_views_array > 0 and self._any_view_using_input
end

UIViewHandler.render_scale = function (self)
	local view_scale_multiplier = 1
	local render_settings = self._render_settings
	local scale = RESOLUTION_LOOKUP.scale
	local new_scale = scale * view_scale_multiplier

	return new_scale
end

local resolution_modified_key = "modified"

UIViewHandler._update_views = function (self, dt, t, allow_input)
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data
	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key]
	local destroy_views = false
	local input_service, null_service, gamepad_active = self:_get_input()
	local allow_next_input = allow_input
	local allow_next_draw = true
	local num_active_views = self._num_active_views
	local highest_game_world_blur = 0
	local draw_game_world = true
	local render_scale = self:render_scale()

	if render_scale ~= self._render_scale then
		self._render_scale = render_scale
	else
		render_scale = nil
	end

	local any_view_using_input = false

	for i = num_active_views, 1, -1 do
		local view_name = active_views_array[i]
		local view_data = active_views_data[view_name]

		if view_data then
			local can_draw_view = self:_can_draw_view(view_name)
			local drawing_view = allow_next_draw and can_draw_view
			local is_closing = view_data.closing
			local instance = view_data.instance

			if is_closing then
				if instance:on_exit_animation_done() then
					if view_data.use_transition_ui then
						if view_data.use_transition_ui_on_animation_on_exit_done then
							view_data.use_transition_ui_on_animation_on_exit_done = nil
							view_data.fade_in = true
							view_data.hide_while_fade_in = false

							view_data.fade_in_callback = function ()
								view_data.marked_for_destruction = true
							end
						end
					else
						view_data.marked_for_destruction = true
					end
				end

				if view_data.marked_for_destruction then
					destroy_views = true
				end
			end

			local game_world_blur = view_data.game_world_blur
			local disable_game_world = view_data.disable_game_world

			if drawing_view then
				if game_world_blur and highest_game_world_blur < game_world_blur then
					highest_game_world_blur = game_world_blur
				end

				if disable_game_world then
					draw_game_world = false
				end
			end

			local view_using_input = false
			local view_instance = view_data.instance

			if view_instance and not view_instance:loading() then
				if render_scale then
					view_instance:set_render_scale(render_scale)
				end

				if resolution_modified then
					view_instance:trigger_resolution_update()
				end

				view_using_input = view_instance:is_using_input()
				local use_real_input = allow_next_input and not is_closing and view_using_input
				local input = (use_real_input and input_service) or null_service
				local pass_on_input, pass_on_draw = view_instance:update(dt, t, input, view_data)

				if view_using_input then
					any_view_using_input = true
				end

				if not pass_on_input then
					allow_next_input = false
				end

				if drawing_view and not pass_on_draw then
					allow_next_draw = false
				end
			else
				allow_next_draw = true
				allow_next_input = false
			end

			view_data.allow_next_input = allow_next_input
			view_data.allow_next_draw = allow_next_draw
			view_data.drawing_view = drawing_view
			view_data.using_input = view_using_input
		end
	end

	self._any_view_using_input = any_view_using_input

	if destroy_views then
		for view_name, view_data in pairs(active_views_data) do
			if view_data.marked_for_destruction then
				self:_force_close(view_name)
			end
		end
	end

	local has_active_views = self._num_active_views > 0

	if has_active_views and draw_game_world and highest_game_world_blur > 0 then
		self:_set_game_world_blur(true, highest_game_world_blur)
	elseif self._game_world_fullscreen_blur_enabled then
		self:_set_game_world_blur(false)
	end

	if draw_game_world or not has_active_views then
		if self._game_world_disabled then
			self:_set_game_world_disabled(false)
		end
	elseif not self._game_world_disabled then
		self:_set_game_world_disabled(true)
	end
end

UIViewHandler._post_update_views = function (self, dt, t)
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data
	local num_active_views = self._num_active_views

	for i = num_active_views, 1, -1 do
		local view_name = active_views_array[i]
		local view_data = active_views_data[view_name]

		if view_data then
			local view_instance = view_data.instance

			if view_instance and not view_instance:loading() then
				view_instance:post_update(dt, t)
			end
		end
	end
end

UIViewHandler._can_draw_view = function (self, view_name)
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]

	if not view_data then
		return false
	end

	if view_data.fade_in and view_data.hide_while_fade_in then
		return false
	end

	local parent_transition_view = view_data.parent_transition_view

	if parent_transition_view then
		return self:_can_draw_view(parent_transition_view)
	end

	return true
end

UIViewHandler._draw_views = function (self, dt, t, allow_input, transitioning_in, transitioning_out)
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data
	local input_service, null_service, gamepad_active = self:_get_input()
	local allow_draw = true
	local layers_per_view = UIViewHandler.LAYERS_PER_VIEW
	local top_draw_layer = 0
	local num_active_views = self._num_active_views

	for i = num_active_views, 1, -1 do
		local view_name = active_views_array[i]
		local view_data = active_views_data[view_name]
		local can_draw_view = self:_can_draw_view(view_name)
		local draw_view = allow_draw and can_draw_view
		local view_instance = view_data.instance

		if view_instance then
			local draw_layer = 1

			if draw_view then
				draw_view = not view_instance:loading()
				draw_layer = math.max(1, layers_per_view * i - layers_per_view)
				local input = (allow_input and input_service) or null_service

				if draw_view then
					view_instance:draw(dt, t, input, draw_layer)

					TEMP_DRAWN_VIEWS[view_name] = true
				end
			end

			self:_set_view_worlds_layer(view_name, draw_layer)
			self:_set_view_worlds_enabled(view_name, draw_view)

			if top_draw_layer < draw_layer then
				top_draw_layer = draw_layer
			end
		end

		local allow_next_input = view_data.allow_next_input
		local allow_next_draw = view_data.allow_next_draw

		if can_draw_view then
			allow_draw = (allow_draw and allow_next_draw) or false
		end

		allow_input = (allow_input and allow_next_input) or false
	end

	self._top_draw_layer = top_draw_layer
end

UIViewHandler._get_time = function (self)
	local timer_name = self._timer_name
	local time_manager = Managers.time
	local t = time_manager:time(timer_name)

	return t
end

UIViewHandler._get_input = function (self)
	local ui_manager = Managers.ui

	return ui_manager:input_service()
end

UIViewHandler._force_close = function (self, view_name)
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data
	local view_data = active_views_data[view_name]

	fassert(view_data, "[UIViewHandler] - View with name: %s is not active", view_name)

	local instance = view_data.instance
	local on_exit = instance.on_exit

	if on_exit then
		instance:on_exit()
	end

	active_views_data[view_name] = nil

	for i = 1, self._num_active_views, 1 do
		if active_views_array[i] == view_name then
			table.remove(active_views_array, i)

			break
		end
	end

	self._num_active_views = self._num_active_views - 1

	if self._num_active_views == 0 then
		if self._game_world_fullscreen_blur_enabled then
			self:_set_game_world_blur(false)
		end

		if self._game_world_disabled then
			self:_set_game_world_disabled(false)
		end
	end
end

UIViewHandler._open = function (self, view_name, opening_duration, context)
	local active_views_array = self._active_views_array
	local active_views_data = self._active_views_data

	fassert(not active_views_data[view_name], "[UIViewHandler] - View with name: %s is already active.", view_name)

	local t = self:_get_time()
	local index = #active_views_array + 1
	local view_list = self._view_list
	local view_settings = view_list[view_name]

	fassert(view_settings, "[UIViewHandler] - View list does not include View with name: %s.", view_name)

	local view_data = {
		hide_while_fade_in = true,
		allow_next_input = true,
		allow_next_draw = true,
		name = view_name,
		opening_time = t,
		disable_game_world = view_settings.disable_game_world,
		game_world_blur = view_settings.game_world_blur,
		fade_in = view_settings.use_transition_ui,
		use_transition_ui = view_settings.use_transition_ui,
		parent_transition_view = view_settings.parent_transition_view
	}
	active_views_data[view_name] = view_data
	active_views_array[index] = view_name
	local path = view_settings.path
	local class = require(path)
	local instance = class:new(view_settings, context)
	view_data.instance = instance
	self._num_active_views = self._num_active_views + 1
end

UIViewHandler._set_game_world_blur = function (self, enabled, blur_intese_multiplier)
	self._game_world_fullscreen_blur_enabled = enabled
	self._game_world_fullscreen_blur_amount = (enabled and (blur_intese_multiplier or 1) * 0.75) or 0
end

UIViewHandler.top_draw_layer = function (self)
	return self._top_draw_layer
end

UIViewHandler._set_game_world_disabled = function (self, disabled)
	self._game_world_disabled = disabled
end

UIViewHandler.use_fullscreen_blur = function (self)
	return self._game_world_fullscreen_blur_enabled, self._game_world_fullscreen_blur_amount
end

UIViewHandler.disable_game_world = function (self)
	return self._game_world_disabled
end

UIViewHandler.register_view_world = function (self, view_name, world_name, layer)
	local registered_view_worlds = self._registered_view_worlds

	if not registered_view_worlds[view_name] then
		registered_view_worlds[view_name] = {}
	end

	fassert(not registered_view_worlds[view_name][world_name], "[UIViewHandler] - Trying to register layer connection to view (%s) with already registered world (%s).", view_name, world_name)

	registered_view_worlds[view_name][world_name] = {
		layer_offset = layer,
		current_layer = layer
	}
	local current_view_layer = self._curent_frame_view_layers[view_name]

	if current_view_layer and current_view_layer ~= layer then
		self:_set_view_worlds_layer(view_name, current_view_layer)
	end

	self:_set_view_worlds_enabled(view_name, false)
end

UIViewHandler.unregister_world = function (self, world_name)
	local registered_view_worlds = self._registered_view_worlds

	for view_name, worlds_table in pairs(registered_view_worlds) do
		if worlds_table[world_name] then
			worlds_table[world_name] = nil

			break
		end
	end
end

UIViewHandler._set_view_worlds_enabled = function (self, view_name, enabled)
	local registered_view_worlds = self._registered_view_worlds
	local worlds_table = registered_view_worlds[view_name]

	if worlds_table then
		local world_manager = Managers.world

		for world_name, world_data in pairs(worlds_table) do
			if world_data.enabled ~= enabled then
				world_data.enabled = enabled
				local world_enabled_state = world_manager:is_world_enabled(world_name)

				if (enabled and not world_enabled_state) or (world_enabled_state and not enabled) then
					world_manager:enable_world(world_name, enabled)
				end
			end
		end
	end
end

UIViewHandler._set_view_worlds_layer = function (self, view_name, layer)
	local registered_view_worlds = self._registered_view_worlds
	local worlds_table = registered_view_worlds[view_name]

	if worlds_table then
		local world_manager = Managers.world

		for world_name, world_data in pairs(worlds_table) do
			local current_layer = world_data.current_layer
			local layer_offset = world_data.layer_offset

			if current_layer - layer_offset ~= layer then
				local new_layer = layer + layer_offset
				world_data.current_layer = new_layer

				world_manager:set_world_layer(world_name, new_layer)
			end
		end
	end

	self._curent_frame_view_layers[view_name] = layer
end

return UIViewHandler
