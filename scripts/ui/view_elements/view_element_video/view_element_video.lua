-- chunkname: @scripts/ui/view_elements/view_element_video/view_element_video.lua

local Definitions = require("scripts/ui/view_elements/view_element_video/view_element_video_definitions")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementVideo = class("ViewElementVideo", "ViewElementBase")

ViewElementVideo.init = function (self, parent, draw_layer, start_scale)
	ViewElementVideo.super.init(self, parent, draw_layer, start_scale, Definitions)

	local class_name = self.__class_name

	self._video_player_reference = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
end

ViewElementVideo.destroy = function (self, ui_renderer)
	self:_destroy_current_video()
	ViewElementVideo.super.destroy(self, ui_renderer)
end

ViewElementVideo.set_pivot_offset = function (self, x, y)
	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementVideo.update = function (self, dt, t, input_service)
	if self._playing then
		local video_completed = self._widgets_by_name.video.content.video_completed

		if video_completed then
			self._playing = false
			self._video_completed = video_completed
		end
	end

	return ViewElementVideo.super.update(self, dt, t, input_service)
end

ViewElementVideo.draw = function (self, dt, t, _, render_settings, input_service)
	local video_ui_renderer = self._video_ui_renderer

	if not video_ui_renderer then
		return
	end

	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	ViewElementVideo.super.draw(self, dt, t, video_ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = previous_alpha_multiplier

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(video_ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._widgets_by_name.video, video_ui_renderer)
	UIRenderer.end_pass(video_ui_renderer)

	render_settings.start_layer = previous_layer
end

ViewElementVideo._destroy_current_video = function (self)
	self._playing = false
	self._video_completed = nil

	local widget = self._widgets_by_name.video
	local widget_content = widget.content
	local video_player_reference = widget_content.video_player_reference

	if video_player_reference then
		local ui_renderer = self._video_ui_renderer

		UIRenderer.destroy_video_player(ui_renderer, video_player_reference)

		widget_content.video_player_reference = nil
		widget_content.video_path = nil
		self._video_ui_renderer = nil
	end
end

ViewElementVideo.setup_video = function (self, video_name, loop_video, video_ui_renderer)
	self:_destroy_current_video()

	self._video_ui_renderer = video_ui_renderer

	local video_player_reference = self._video_player_reference

	UIRenderer.create_video_player(self._video_ui_renderer, video_player_reference, nil, video_name, loop_video)

	local widget = self._widgets_by_name.video
	local widget_content = widget.content

	widget_content.video_path = video_name
	widget_content.video_player_reference = video_player_reference
	self._video_speed = self._video_speed or 1

	self:pause_video()
end

ViewElementVideo.set_playback_speed = function (self, speed)
	local video_player = self:_video_player()

	self._video_speed = speed or 1

	if self._playing then
		video_player:set_playback_speed(self._video_speed)
	end
end

ViewElementVideo.play_video = function (self)
	local video_player = self:_video_player()
	local restart = false

	if self._video_completed then
		restart = true
	end

	if restart then
		video_player:reset()
	end

	self._video_completed = nil
	self._playing = true

	video_player:set_playback_speed(self._video_speed)
end

ViewElementVideo.is_playing = function (self)
	return not self._video_completed and self._video_speed ~= 0 and self._playing
end

ViewElementVideo.stop_video = function (self)
	self:_destroy_current_video()
end

ViewElementVideo.pause_video = function (self)
	local video_player = self:_video_player()

	video_player:set_playback_speed(0)

	self._playing = false
end

ViewElementVideo._video_player = function (self)
	local video_player_reference = self._video_player_reference
	local video_player = UIRenderer.video_player(self._video_ui_renderer, video_player_reference)

	return video_player
end

return ViewElementVideo
