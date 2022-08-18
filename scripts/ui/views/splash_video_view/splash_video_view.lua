local Definitions = require("scripts/ui/views/splash_video_view/splash_video_view_definitions")
local SplashVideoViewSettings = require("scripts/ui/views/splash_video_view/splash_video_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local SplashVideoView = class("SplashVideoView", "BaseView")

SplashVideoView.init = function (self, settings, context)
	self._context = context

	SplashVideoView.super.init(self, Definitions, settings)
end

SplashVideoView.on_enter = function (self)
	SplashVideoView.super.on_enter(self)
	self:_set_background_visibility(false)

	local context = self._context

	if context then
		local video_name = context.video_name

		if video_name then
			local loop_video = context.loop_video or false

			self:_setup_video(video_name, loop_video)
		end

		local sound_name = context.sound_name

		if sound_name then
			self._current_sound_id = self:_play_sound(sound_name)
		end

		self._pass_input = context.pass_input
		self._pass_draw = context.pass_draw
	end

	self._can_exit = not context or context.can_exit
end

SplashVideoView._set_background_visibility = function (self, visible)
	self._widgets_by_name.background.content.visible = visible
end

SplashVideoView.on_exit = function (self)
	local context = self._context
	local exit_sound_name = context and context.exit_sound_name

	if exit_sound_name then
		self:_play_sound(exit_sound_name)
	elseif self._current_sound_id then
		self:_stop_sound(self._current_sound_id)
	end

	self._current_sound_id = nil

	SplashVideoView.super.on_exit(self)
end

SplashVideoView.update = function (self, dt, t, input_service)
	return SplashVideoView.super.update(self, dt, t, input_service)
end

SplashVideoView.can_exit = function (self)
	return self._can_exit
end

SplashVideoView._destroy_current_video = function (self)
	local widget = self._widgets_by_name.video
	local widget_content = widget.content
	local video_player = widget_content.video_player

	if video_player then
		local ui_renderer = self._ui_renderer
		local video_player_reference = self.__class_name

		UIRenderer.destroy_video_player(ui_renderer, video_player_reference)

		widget_content.video_player = nil
	end

	self:_set_background_visibility(false)
end

SplashVideoView._setup_video = function (self, video_name, loop_video)
	self:_destroy_current_video()

	local ui_renderer = self._ui_renderer
	local video_player_reference = self.__class_name

	UIRenderer.create_video_player(ui_renderer, video_player_reference, nil, video_name, loop_video)

	local widget = self._widgets_by_name.video
	local widget_content = widget.content
	widget_content.video_path = video_name
	widget_content.video_player_reference = video_player_reference

	self:_set_background_visibility(true)
end

return SplashVideoView
