local Definitions = require("scripts/ui/views/video_view/video_view_definitions")
local VideoViewSettings = require("scripts/ui/views/video_view/video_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local InputUtils = require("scripts/managers/input/input_utils")
local device_list = {
	Keyboard,
	Mouse,
	Pad1
}
local VideoView = class("VideoView", "BaseView")

VideoView.init = function (self, settings, context)
	self._context = context
	self._packages_loaded = {}
	self._current_sound_id = nil
	self._loading = false
	self._can_exit = false
	self._player_skipped = false
	self._subtitles = nil
	self._current_subtitle_index = 0
	self._time_for_next_subtitle = nil
	self._active_subtitle_end_time = nil
	self._video_start_time = nil

	VideoView.super.init(self, Definitions, settings)
end

VideoView._unload_packages = function (self)
	local package_manager = Managers.package

	for id, _ in pairs(self._packages_loaded) do
		package_manager:release(id)
	end
end

VideoView._package_load_callback = function (self, package_name)
	self._packages_loaded[package_name] = true
end

VideoView._load_template = function (self, template)
	if not template then
		local template_name = self._context.template
		template = VideoViewSettings.templates[template_name]
	end

	local video_name = template.video_name
	local loop_video = template.loop_video or false
	local sound_name = template.start_sound_name
	local subtitles = template.subtitles

	self:_setup_video(video_name, loop_video)

	if sound_name then
		self._current_sound_id = self:_play_sound(sound_name)
	end

	self._subtitles = subtitles
	self._current_subtitle_index = 1
end

VideoView.on_enter = function (self)
	VideoView.super.on_enter(self)
	self:_set_background_visibility(false)
	table.clear(self._packages_loaded)

	self._packages_loaded = {}
	self._current_sound_id = nil
	self._loading = false
	local context = self._context
	local template_name = context.template
	local template = VideoViewSettings.templates[template_name]
	local packages = template.packages

	if packages then
		local function callback(_pkg_name)
			self:_package_load_callback(_pkg_name)
		end

		local package_manager = Managers.package

		for i = 1, #packages do
			local package_id = package_manager:load(packages[i], "VideoView", callback, true)
			self._packages_loaded[package_id] = false
		end

		self._loading_packages = true
	else
		self:_load_template(template)
	end

	self:_setup_background_world()

	self._pass_input = context.pass_input
	self._pass_draw = context.pass_draw
	self._can_exit = not context or context.can_exit
end

VideoView._set_background_visibility = function (self, visible)
	self._widgets_by_name.background.content.visible = visible
end

VideoView.on_exit = function (self)
	local template_name = self._context.template
	local template = VideoViewSettings.templates[template_name]
	local stop_sound_name = template.stop_sound_name

	if not template.stop_only_player_skip or self._player_skipped then
		if stop_sound_name then
			self:_play_sound(stop_sound_name)
		elseif self._current_sound_id then
			self:_stop_sound(self._current_sound_id)
		end
	end

	self:_remove_subtitles()
	VideoView.super.on_exit(self)
	self:_unload_packages()

	local context = self._context
	local close_callback = context and context.close_callback

	if close_callback then
		close_callback()
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

VideoView._on_skip_pressed = function (self)
	self._player_skipped = true
	self._widgets_by_name.video.content.video_completed = true
end

VideoView._update_package_loading = function (self)
	for _, loaded in pairs(self._packages_loaded) do
		if not loaded then
			return
		end
	end

	self:_load_template()

	self._loading_packages = false
end

VideoView._update_input = function (self)
	if IS_XBS then
		local input_device_list = InputUtils.input_device_list
		local xbox_controllers = input_device_list.xbox_controller

		for i = 1, #xbox_controllers do
			local xbox_controller = xbox_controllers[i]

			if xbox_controller.active() and xbox_controller.any_pressed() then
				self:_on_skip_pressed()
			end
		end
	else
		for i = 1, #device_list do
			local device = device_list[i]

			if device and device.active and device.any_pressed() then
				self:_on_skip_pressed()
			end
		end
	end
end

VideoView.update = function (self, dt, t, input_service)
	if self._loading_packages then
		self:_update_package_loading()
	else
		local context = self._context
		local allow_skip_input = context.allow_skip_input

		if allow_skip_input then
			self:_update_input()
		end
	end

	local pass_input, pass_draw = VideoView.super.update(self, dt, t, input_service)

	if self._widgets_by_name.video.content.video_completed and not Managers.ui:is_view_closing("video_view") then
		Managers.ui:close_view("video_view")
	end

	self:_update_subtitles(dt, t)

	return pass_input, pass_draw
end

VideoView.can_exit = function (self)
	return self._can_exit
end

VideoView._destroy_current_video = function (self)
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

VideoView._setup_video = function (self, video_name, loop_video)
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

VideoView._update_subtitles = function (self, dt, t)
	local subtitles = self._subtitles
	local subtitle_index = self._current_subtitle_index
	local current_subtitle = subtitles and subtitles[subtitle_index]

	if not current_subtitle then
		return
	end

	local video_start_time = self._video_start_time
	local time_for_next_subtitle = self._time_for_next_subtitle
	local active_subtitle_end_time = self._active_subtitle_end_time

	if time_for_next_subtitle and time_for_next_subtitle <= t then
		local dialogue_system_subtitle = self:dialogue_system_subtitle()

		dialogue_system_subtitle:add_audible_playing_localized_dialogue(current_subtitle)

		self._time_for_next_subtitle = nil
		self._active_subtitle_end_time = t + current_subtitle.subtitle_duration
	elseif active_subtitle_end_time and active_subtitle_end_time <= t then
		local dialogue_system_subtitle = self:dialogue_system_subtitle()

		dialogue_system_subtitle:remove_silent_localized_dialogue(current_subtitle)

		subtitle_index = subtitle_index + 1
		self._current_subtitle_index = subtitle_index
		self._active_subtitle_end_time = nil
	elseif not time_for_next_subtitle and not active_subtitle_end_time then
		if not video_start_time then
			video_start_time = t
			self._video_start_time = video_start_time
		end

		local current_subtitle_start = current_subtitle.subtitle_start
		self._time_for_next_subtitle = video_start_time + current_subtitle_start
	end
end

VideoView.dialogue_system_subtitle = function (self)
	local dialogue_system = self:dialogue_system()
	local dialogue_system_subtitle = dialogue_system:dialogue_system_subtitle()

	return dialogue_system_subtitle
end

VideoView._setup_background_world = function (self)
	local world_name = VideoViewSettings.world_name
	local world_layer = VideoViewSettings.world_layer
	local world_timer_name = VideoViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = VideoViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

VideoView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueActorExtension")

	return dialogue_system
end

VideoView._remove_subtitles = function (self)
	local subtitles = self._subtitles
	local current_subtitle = subtitles and subtitles[self._current_subtitle_index]

	if current_subtitle then
		local dialogue_system_subtitle = self:dialogue_system_subtitle()

		dialogue_system_subtitle:remove_silent_localized_dialogue(current_subtitle)
	end

	self._subtitles = nil
	self._current_subtitle_index = 0
end

return VideoView
