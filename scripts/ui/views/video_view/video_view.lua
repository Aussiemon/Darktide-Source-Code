-- chunkname: @scripts/ui/views/video_view/video_view.lua

local Definitions = require("scripts/ui/views/video_view/video_view_definitions")
local VideoViewSettings = require("scripts/ui/views/video_view/video_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local device_list = {
	Keyboard,
	Mouse,
	Pad1,
}
local DUMMY_VIDEO_TIME = 5
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
	self._show_skip = false
	self._skip_pressed = false
	self._hold_timer = 0
	self._legend_active = 0
	self._input_legend_element = nil
	self._wait_for_video = 0

	VideoView.super.init(self, Definitions, settings, context)
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

	self._video_name = template.video_name
	self._loop_video = template.loop_video or false

	local sound_name = template.start_sound_name
	local subtitles = template.subtitles
	local post_video_action = template.post_video_action
	local wwise_music_state = template.music

	if sound_name then
		self._current_sound_id = self:_play_sound(sound_name)
	end

	self._subtitles = subtitles
	self._post_video_action = post_video_action
	self._wwise_music_state = wwise_music_state
	self._current_subtitle_index = 1
end

VideoView.on_enter = function (self)
	if GameParameters.skip_cinematics then
		self:_on_skip_pressed()
	end

	VideoView.super.on_enter(self)

	if IS_PLAYSTATION then
		self:_play_dummy_video()

		return
	end

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

VideoView._play_dummy_video = function (self)
	self._dummy_video_timer = DUMMY_VIDEO_TIME

	local context = self._context
	local template_name = context.template
	local template = VideoViewSettings.templates[template_name]
	local video_name = template.video_name

	self._video_name = video_name

	local post_video_action = template.post_video_action

	self._post_video_action = post_video_action
end

VideoView._update_dummy_video = function (self, dt)
	if self._player_skipped then
		return
	end

	local timer = self._dummy_video_timer - dt

	if timer > 0 then
		self._widgets_by_name.playstation_dummy_text.content.text = string.format("Playstation Video Placeholder Now Playing\n[%s]\n%.1f", self._video_name, timer)
		self._dummy_video_timer = timer
	else
		self:_on_skip_pressed()
	end
end

VideoView._set_background_visibility = function (self, visible)
	self._widgets_by_name.background.content.visible = visible
end

VideoView.on_exit = function (self)
	local template_name = self._context.template
	local template = VideoViewSettings.templates[template_name]
	local stop_sound_name = template.stop_sound_name

	if not template.stop_only_player_skip or self._player_skipped or not self._widgets_by_name.video.content.video_completed then
		if stop_sound_name then
			self:_play_sound(stop_sound_name)
		elseif self._current_sound_id then
			self:_stop_sound(self._current_sound_id)
		end
	end

	self:_remove_subtitles()
	self:_remove_input_legend()
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

	if self._post_video_action and (self._widgets_by_name.video.content.video_completed or self._player_skipped) then
		local action = self._post_video_action

		if action.action_type == "open_hub_view" then
			local hub_view_context = {
				hub_interaction = true,
			}

			Managers.ui:open_view(action.view_name, nil, nil, nil, nil, hub_view_context)
		elseif action.action_type == "set_narrative_stat" then
			Managers.narrative:complete_event(action.event_name)
		else
			ferror("Unsupported action type %q", action.action_type)
		end
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
	local input_device_list = InputUtils.platform_device_list()

	for i = 1, #input_device_list do
		local device = input_device_list[i]

		if device.active() and device.any_pressed() and not self._show_skip then
			self._show_skip = true

			break
		end
	end
end

VideoView.update = function (self, dt, t, input_service)
	if self._dummy_video_timer then
		self:_update_dummy_video(dt)
	elseif self._loading_packages then
		self:_update_package_loading()
	elseif not self._sound_ready then
		local playing_elapsed = self:_get_sound_playing_elapsed()

		if playing_elapsed and playing_elapsed > 0 then
			self._sound_ready = true
			self._video_start_time = t

			self:_setup_video(self._video_name, self._loop_video, self._size, self._position)
		end
	else
		local context = self._context
		local allow_skip_input = context.allow_skip_input

		if allow_skip_input then
			self:_update_input()
		end

		if self._show_skip and not self._input_legend_element then
			self:_setup_input_legend()
		elseif not self._show_skip and self._input_legend_element then
			self:_remove_input_legend()
		end

		if self._input_legend_element then
			if input_service:get("skip_cinematic_hold") or input_service:get("left_hold") and self._skip_pressed == true then
				self._hold_timer = self._hold_timer + dt
				self._legend_active = 0
			elseif self._skip_pressed == true then
				self._skip_pressed = false
				self._legend_active = 0
				self._hold_timer = 0
			elseif self._show_skip then
				self._legend_active = self._legend_active + dt
			end
		end

		if self._hold_timer > UISettings.cutscenes_skip.hold_time then
			self._legend_active = 0
			self._hold_timer = 0

			self:_on_skip_pressed()

			self._show_skip = false
		elseif self._legend_active > UISettings.cutscenes_skip.fade_inactivity_time then
			self._show_skip = false
			self._legend_active = 0
			self._hold_timer = 0
		end
	end

	local pass_input, pass_draw = VideoView.super.update(self, dt, t, input_service)

	if self._widgets_by_name.video.content.video_completed and not Managers.ui:is_view_closing("video_view") then
		Managers.ui:close_view("video_view")
	end

	self:_update_subtitles(dt, t)

	return pass_input, pass_draw
end

VideoView.on_skip_pressed = function (self)
	self._skip_pressed = true
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

VideoView._get_sound_playing_elapsed = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()

	if world then
		local wwise_world = Managers.world:wwise_world(world)
		local sound_id = self._current_sound_id
		local get_playing_elapsed = WwiseWorld.get_playing_elapsed(wwise_world, sound_id)

		return get_playing_elapsed
	end
end

VideoView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueExtension")

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

VideoView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 100)

	local legend_inputs = Definitions.legend_inputs
	local input_legends_by_key = {}

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)
		local id = self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
		local key = legend_input.key

		if key then
			input_legends_by_key[key] = {
				id = id,
				settings = legend_input,
			}
		end
	end

	self._input_legends_by_key = input_legends_by_key

	local id = self._input_legends_by_key.hold_skip.id
	local entry = self._input_legend_element:_get_entry_by_id(id)
	local entry_widget = entry.widget
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = Color.ui_grey_medium(255, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "fill",
			style = {
				color = Color.ui_terminal(255, true),
				size = {
					0,
				},
			},
		},
	}, entry_widget.scenegraph_id)

	self._skip_bar_widget = self:_create_widget("skip", widget_definition)
end

VideoView._remove_input_legend = function (self)
	if self._input_legend_element then
		self:_remove_element("input_legend")

		self._input_legend_element = nil
	end

	if self._skip_bar_widget then
		self:_unregister_widget_name(self._skip_bar_widget.name)

		self._skip_bar_widget = nil
	end
end

VideoView.draw = function (self, dt, t, input_service, layer)
	VideoView.super.draw(self, dt, t, input_service, layer)

	if self._input_legend_element then
		local render_scale = self._render_scale
		local render_settings = self._render_settings
		local id = self._input_legends_by_key.hold_skip.id
		local entry = self._input_legend_element:_get_entry_by_id(id)
		local entry_widget = entry.widget
		local ui_renderer = self._ui_renderer
		local ui_scenegraph = self._input_legend_element._ui_scenegraph
		local bar_margin = 10
		local position = self._input_legend_element:scenegraph_position(entry_widget.scenegraph_id)
		local width = 100
		local z_offset = render_settings.draw_layer or 0

		z_offset = z_offset + self._input_legend_element._draw_layer + 1
		self._skip_bar_widget.offset = {
			position[1] + entry_widget.offset[1] + (entry_widget.content.size[1] - width) * 0.5,
			position[2] + entry_widget.offset[2] + entry_widget.content.size[2] - bar_margin,
			z_offset,
		}
		self._skip_bar_widget.content.size = {
			width,
			5,
		}

		local progress = UISettings.cutscenes_skip.hold_time and math.min(self._hold_timer / UISettings.cutscenes_skip.hold_time, 1) or 1

		self._skip_bar_widget.style.fill.size[1] = width * progress

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		if self._skip_bar_widget then
			UIWidget.draw(self._skip_bar_widget, ui_renderer)
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

VideoView.wwise_music_state = function (self)
	return self._wwise_music_state
end

return VideoView
