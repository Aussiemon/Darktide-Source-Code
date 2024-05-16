-- chunkname: @scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view.lua

local Definitions = require("scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ViewSettings = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_settings")
local CreditsVendorBackgroundView = class("CreditsVendorBackgroundView", "VendorInteractionViewBase")

CreditsVendorBackgroundView.init = function (self, settings, context)
	self._wallet_type = "credits"

	CreditsVendorBackgroundView.super.init(self, Definitions, settings, context)
end

CreditsVendorBackgroundView.on_enter = function (self)
	CreditsVendorBackgroundView.super.on_enter(self)

	local viewport_name = Definitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_credits_store_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	self:play_vo_events(ViewSettings.vo_event_vendor_greeting, "credit_store_servitor_b", nil, 1)
end

CreditsVendorBackgroundView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	CreditsVendorBackgroundView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_credit_store_closed")
	end
end

CreditsVendorBackgroundView._set_wallet_background_width = function (self, width)
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

return CreditsVendorBackgroundView
