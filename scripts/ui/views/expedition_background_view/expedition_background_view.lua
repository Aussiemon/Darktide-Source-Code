-- chunkname: @scripts/ui/views/expedition_background_view/expedition_background_view.lua

local Definitions = require("scripts/ui/views/expedition_background_view/expedition_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ViewSettings = require("scripts/ui/views/expedition_background_view/expedition_background_view_settings")
local ExpeditionBackgroundView = class("ExpeditionBackgroundView", "VendorInteractionViewBase")

ExpeditionBackgroundView.init = function (self, settings, context)
	self._wallet_type = "credits"

	ExpeditionBackgroundView.super.init(self, Definitions, settings, context)
end

ExpeditionBackgroundView.on_enter = function (self)
	ExpeditionBackgroundView.super.on_enter(self)
	Managers.event:register(self, "event_select_story_mission_background_option", "event_select_story_mission_background_option")
end

ExpeditionBackgroundView.event_select_story_mission_background_option = function (self, index)
	local button_options_definitions = self._base_definitions.button_options_definitions

	if index then
		local option = button_options_definitions[index]

		if option then
			self:on_option_button_pressed(index, option)
		end
	end
end

ExpeditionBackgroundView.on_exit = function (self)
	Managers.event:unregister(self, "event_select_story_mission_background_option")
	ExpeditionBackgroundView.super.on_exit(self)
end

ExpeditionBackgroundView._set_wallet_background_width = function (self, width)
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

ExpeditionBackgroundView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local render_settings_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	ExpeditionBackgroundView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	render_settings.alpha_multiplier = render_settings_alpha_multiplier
end

return ExpeditionBackgroundView
