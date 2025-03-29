-- chunkname: @scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view.lua

local Definitions = require("scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ViewSettings = require("scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local CosmeticsVendorBackgroundView = class("CosmeticsVendorBackgroundView", "VendorInteractionViewBase")

CosmeticsVendorBackgroundView.init = function (self, settings, context)
	self._wallet_type = "credits"

	CosmeticsVendorBackgroundView.super.init(self, Definitions, settings, context)

	self._button_input_actions = {
		"navigate_right_continuous",
		"navigate_left_continuous",
	}
end

CosmeticsVendorBackgroundView.on_enter = function (self)
	CosmeticsVendorBackgroundView.super.on_enter(self)

	local viewport_name = Definitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_cosmetic_store_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	local story_name = "path_of_trust"
	local pot_completed = narrative_manager:is_story_complete(story_name)

	if pot_completed then
		self:play_vo_events(ViewSettings.vo_event_vendor_greeting, "reject_npc_servitor_a", nil, 0)
	else
		self:play_vo_events(ViewSettings.vo_event_vendor_greeting, "reject_npc_a", nil, 1)
	end
end

CosmeticsVendorBackgroundView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	CosmeticsVendorBackgroundView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_cosmetic_store_closed")
	end
end

CosmeticsVendorBackgroundView._set_wallet_background_width = function (self, width)
	width = 150 + width

	local scenegraph_id = "corner_top_right"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local original_width = default_scenegraph.size[1]
	local uv_fractions = width / original_width
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name[scenegraph_id]

	if widget then
		widget.content.visible = true
		widget.style.texture.uvs[2][1] = math.min(uv_fractions, 1)
	end

	self:_set_scenegraph_size(scenegraph_id, width, nil)
end

CosmeticsVendorBackgroundView.event_register_character_spawn_point = function (self, spawn_point_unit)
	CosmeticsVendorBackgroundView.super.event_register_character_spawn_point(self, spawn_point_unit)
end

CosmeticsVendorBackgroundView.update = function (self, dt, t, input_service)
	return CosmeticsVendorBackgroundView.super.update(self, dt, t, input_service)
end

CosmeticsVendorBackgroundView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	self:draw_passes(dt, t, ui_renderer, input_service, render_settings)
end

CosmeticsVendorBackgroundView.draw_passes = function (self, dt, t, ui_renderer, input_service, render_settings)
	local ui_scenegraph = self._ui_scenegraph
	local situational_input_service = self._presenting_options and input_service or input_service:null_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, situational_input_service, dt, render_settings)
	self:_draw_widgets(dt, t, situational_input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

CosmeticsVendorBackgroundView.cb_on_camera_zoom_toggled = function (self)
	local view_instance = self._active_view and Managers.ui:view_instance(self._active_view)

	if not view_instance or not view_instance.cb_on_camera_zoom_toggled then
		return
	end

	view_instance:cb_on_camera_zoom_toggled()
end

return CosmeticsVendorBackgroundView
