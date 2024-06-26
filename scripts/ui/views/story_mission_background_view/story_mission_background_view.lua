-- chunkname: @scripts/ui/views/story_mission_background_view/story_mission_background_view.lua

local Definitions = require("scripts/ui/views/story_mission_background_view/story_mission_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ViewSettings = require("scripts/ui/views/story_mission_background_view/story_mission_background_view_settings")
local StoryMissionBackgroundView = class("StoryMissionBackgroundView", "VendorInteractionViewBase")

StoryMissionBackgroundView.init = function (self, settings, context)
	self._wallet_type = "credits"

	StoryMissionBackgroundView.super.init(self, Definitions, settings, context)
end

StoryMissionBackgroundView.on_enter = function (self)
	StoryMissionBackgroundView.super.on_enter(self)
	Managers.event:register(self, "event_select_story_mission_background_option", "event_select_story_mission_background_option")

	local narrative_manager = Managers.narrative
	local narrative_story = "s1_twins"
	local narrative_chapter = "s1_twins_epilogue_2"
	local current_chapter = Managers.narrative:current_chapter(narrative_story)
	local viewport_name = Definitions.background_world_params.viewport_name

	self._world_spawner:set_listener(viewport_name)

	local current_chapter_name = current_chapter and current_chapter.name

	if narrative_chapter == current_chapter_name then
		narrative_manager:complete_current_chapter(narrative_story, narrative_chapter)
		self:play_vo_events(ViewSettings.vo_event_twins_epilogue, "explicator_a", nil, 1)
	else
		self:play_vo_events(ViewSettings.vo_event_greeting, "explicator_a", nil, 1)
	end
end

StoryMissionBackgroundView.event_select_story_mission_background_option = function (self, index)
	local button_options_definitions = self._base_definitions.button_options_definitions

	if index then
		local option = button_options_definitions[index]

		if option then
			self:on_option_button_pressed(index, option)
		end
	end
end

StoryMissionBackgroundView.on_exit = function (self)
	Managers.event:unregister(self, "event_select_story_mission_background_option")
	StoryMissionBackgroundView.super.on_exit(self)
end

StoryMissionBackgroundView._set_wallet_background_width = function (self, width)
	width = 130 + width

	local scenegraph_id = "corner_top_right"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local original_width = default_scenegraph.size[1]
	local uv_fractions = width / original_width
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name[scenegraph_id]

	if widget then
		widget.style.texture.uvs[2][1] = math.min(uv_fractions, 1)
	end

	self:_set_scenegraph_size(scenegraph_id, width, nil)
end

StoryMissionBackgroundView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local render_settings_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	StoryMissionBackgroundView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	render_settings.alpha_multiplier = render_settings_alpha_multiplier
end

return StoryMissionBackgroundView
