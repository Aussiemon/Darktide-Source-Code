local Definitions = require("scripts/ui/views/splash_video_view/splash_video_view_definitions")
local SplashVideoViewSettings = require("scripts/ui/views/splash_video_view/splash_video_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local SplashVideoView = class("SplashVideoView", "BaseView")

SplashVideoView.init = function (self, settings, context)
	self._context = context
	self._current_subtitles = {}
	self._time_until_next_subtitle = nil
	self._active_subtitle_duration = nil

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
			local size = context.size or nil
			local position = context.position or nil
			local short_video_name = video_name:sub(16)
			local subtitles = SplashVideoViewSettings[short_video_name .. "_subtitles"]

			if subtitles then
				self._current_subtitles = subtitles
			end

			self:_setup_video(video_name, loop_video, size, position)
		end

		local sound_name = context.sound_name

		if sound_name then
			self._current_sound_id = self:_play_sound(sound_name)
		end

		self:_setup_background_world()

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

	self:_remove_subtitle()

	self._current_subtitles = nil

	SplashVideoView.super.on_exit(self)

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

SplashVideoView.update = function (self, dt, t, input_service)
	if self._current_subtitles[1] then
		self:_update_subtitles(dt, t)
	end

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

SplashVideoView._setup_video = function (self, video_name, loop_video, size, position)
	self:_destroy_current_video()

	local ui_renderer = self._ui_renderer
	local video_player_reference = self.__class_name

	UIRenderer.create_video_player(ui_renderer, video_player_reference, nil, video_name, loop_video)

	local widget = self._widgets_by_name.video
	local widget_content = widget.content
	local widget_style = widget.style.video
	widget_content.video_path = video_name
	widget_content.video_player_reference = video_player_reference

	if size then
		widget_style.size = size
	end

	if position then
		widget_style.offset = position
	end

	self:_set_background_visibility(true)
end

SplashVideoView._setup_background_world = function (self)
	local world_name = SplashVideoViewSettings.world_name
	local world_layer = SplashVideoViewSettings.world_layer
	local world_timer_name = SplashVideoViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = SplashVideoViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

SplashVideoView._update_subtitles = function (self, dt, t)
	local current_subtitle = self._current_subtitles[1]
	local current_subtitle_start = current_subtitle.subtitle_start

	if self._time_until_next_subtitle and self._time_until_next_subtitle <= 0 then
		self:_add_subtitle(current_subtitle)

		self._active_subtitle_duration = current_subtitle.subtitle_duration
		self._time_until_next_subtitle = nil
	elseif self._active_subtitle_duration and self._active_subtitle_duration > 0 then
		self._active_subtitle_duration = self._active_subtitle_duration - dt
	end

	if self._active_subtitle_duration and self._active_subtitle_duration <= 0 then
		self:_remove_subtitle()
		table.remove(self._current_subtitles, 1)

		local next_subtitle = self._current_subtitles[1]

		if next_subtitle then
			local next_subtitle_start = next_subtitle.subtitle_start
			local current_subtitle_finish = current_subtitle_start + current_subtitle.subtitle_duration
			self._time_until_next_subtitle = next_subtitle_start - current_subtitle_finish
		end
	end

	if self._time_until_next_subtitle and self._time_until_next_subtitle > 0 then
		self._time_until_next_subtitle = self._time_until_next_subtitle - dt
	elseif not self._active_subtitle_duration then
		self._time_until_next_subtitle = current_subtitle_start - dt
	end
end

SplashVideoView.dialogue_system_subtitle = function (self)
	local dialogue_system = self:dialogue_system()
	local dialogue_system_subtitle = dialogue_system:dialogue_system_subtitle()

	return dialogue_system_subtitle
end

SplashVideoView._setup_background_world = function (self)
	local world_name = SplashVideoViewSettings.world_name
	local world_layer = SplashVideoViewSettings.world_layer
	local world_timer_name = SplashVideoViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = SplashVideoViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

SplashVideoView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueActorExtension")

	return dialogue_system
end

SplashVideoView._add_subtitle = function (self, subtitle)
	local dialogue_system_subtitle = self:dialogue_system_subtitle()

	dialogue_system_subtitle:add_audible_playing_localized_dialogue(subtitle)
end

SplashVideoView._remove_subtitle = function (self)
	local dialogue_system_subtitle = self:dialogue_system_subtitle()
	local subtitle = self._current_subtitles[1]

	if subtitle then
		dialogue_system_subtitle:remove_silent_localized_dialogue(subtitle)

		self._active_subtitle_duration = nil
	end
end

return SplashVideoView
