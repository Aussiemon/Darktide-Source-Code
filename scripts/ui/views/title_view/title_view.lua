-- chunkname: @scripts/ui/views/title_view/title_view.lua

local definition_path = "scripts/ui/views/title_view/title_view_definitions"
local TitleViewSettings = require("scripts/ui/views/title_view/title_view_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local InputUtils = require("scripts/managers/input/input_utils")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local device_list = {
	Keyboard,
	Mouse,
	Pad1,
}
local TitleView = class("TitleView", "BaseView")

TitleView.init = function (self, settings, context)
	local definitions = require(definition_path)

	TitleView.super.init(self, definitions, settings, context)

	self._pass_draw = false
	self._parent = context.parent
end

TitleView.on_enter = function (self)
	TitleView.super.on_enter(self)

	self._continue_input_name = "title_screen_start"

	self:_apply_title_text()
	self:_setup_background_world()
	self:_register_event("event_state_title_reset", "event_state_title_reset")
end

TitleView._setup_background_world = function (self)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_register_event("event_register_title_screen_camera")

	local world_name = TitleViewSettings.world_name
	local world_layer = TitleViewSettings.world_layer
	local world_timer_name = TitleViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = TitleViewSettings.level_name
	local ignore_level_background = TitleViewSettings.ignore_level_background

	self._world_spawner:spawn_level(level_name, nil, nil, nil, ignore_level_background)
end

TitleView.event_register_title_screen_camera = function (self, camera_unit)
	self:_unregister_event("event_register_title_screen_camera")

	local viewport_name = TitleViewSettings.viewport_name
	local viewport_type = TitleViewSettings.viewport_type
	local viewport_layer = TitleViewSettings.viewport_layer
	local shading_environment = TitleViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

TitleView.event_state_title_reset = function (self)
	self._continue_triggered = false
	self._loading_reason = nil
	self._widgets_by_name.title_text.content.ready_to_continue = false

	self:_apply_title_text()
end

TitleView._apply_title_text = function (self)
	if self._continue_triggered then
		return
	end

	local input_alias_name = self._continue_input_name
	local service_type = "View"
	local color_tint_text = true
	local input_key = InputUtils.input_text_for_current_input_device(service_type, input_alias_name, color_tint_text)
	local context = {
		input = input_key,
	}
	local text = Localize("loc_title_view_input_description", true, context)

	self._widgets_by_name.title_text.content.text = text
end

TitleView._on_navigation_input_changed = function (self)
	TitleView.super._on_navigation_input_changed(self)
	self:_apply_title_text()
end

TitleView.update = function (self, dt, t, input_service)
	TitleView.super.update(self, dt, t, input_service)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self.closing_view then
		return
	end

	if not self._continue_triggered and input_service and not input_service:is_null_service() then
		local continue_input_name = self._continue_input_name

		if IS_XBS then
			local input_device_list = InputUtils.input_device_list
			local xbox_controllers = input_device_list.xbox_controller

			for i = 1, #xbox_controllers do
				local xbox_controller = xbox_controllers[i]

				if xbox_controller.active() and (Managers.account:do_re_signin() or xbox_controller.pressed(xbox_controller.button_index("a"))) then
					self:_continue(nil, xbox_controller)
				end
			end
		else
			for i = 1, #device_list do
				local device = device_list[i]

				if device and device.active() and input_service:get(continue_input_name) then
					self:_continue()
				end
			end
		end
	end

	if self._continue_triggered then
		local parent = self._parent
		local loading, force_refresh, loading_reason, no_cache, context = parent:is_loading()

		if loading and (force_refresh or loading_reason ~= self._loading_reason) then
			self._loading_reason = loading_reason
			self._widgets_by_name.title_text.content.text = Localize(loading_reason, no_cache, context)
		end
	end
end

TitleView._on_ignore_pressed = function (self)
	ParameterResolver.set_dev_parameter("ui_skip_title_screen", true)

	local ignore_sound = false

	self:_continue(ignore_sound)
end

TitleView._continue = function (self, ignore_sound, optional_input_device)
	self._continue_triggered = true

	if not ignore_sound then
		self:_play_sound(UISoundEvents.title_screen_continue)
	end

	self._widgets_by_name.title_text.content.ready_to_continue = true

	local event_name = "event_state_title_continue"

	Managers.event:trigger(event_name, optional_input_device)
end

TitleView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self.super.on_exit(self)
end

TitleView.on_resolution_modified = function (self)
	TitleView.super.on_resolution_modified(self)

	if self._world_spawner then
		self:_update_viewport_resolution()
	end
end

TitleView._update_viewport_resolution = function (self)
	self:_force_update_scenegraph()

	if self._world_spawner then
		local scale = self._render_scale or 1
		local scenegraph = self._ui_scenegraph
		local id = "canvas"
		local x_scale, y_scale, w_scale, h_scale = UIScenegraph.get_scenegraph_id_screen_scale(scenegraph, id, scale)

		self._world_spawner:set_viewport_size(w_scale, h_scale)
		self._world_spawner:set_viewport_position(x_scale, y_scale)
	end
end

return TitleView
