local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementItemResultOverlaySettings = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay_settings")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local WorldRenderUtils = require("scripts/utilities/world_render")
local definition_path = "scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay_definitions"
local MasterItems = require("scripts/backend/master_items")
local BLUR_TIME = 0.3
local WORLD_LAYER_BACKGROUND = 300
local WORLD_LAYER_TOP_GUI = 400
local ViewElementItemResultOverlay = class("ViewElementItemResultOverlay", "ViewElementBase")

ViewElementItemResultOverlay.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)
	self._time = nil
	self._reference_name = "ViewElementItemResultOverlay_" .. tostring(self)

	ViewElementItemResultOverlay.super.init(self, parent, draw_layer, start_scale, definitions)

	self._pass_draw = true
	self._pass_input = true
end

ViewElementItemResultOverlay._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = self._reference_name
	local timer_name = "ui"
	local world_layer = WORLD_LAYER_TOP_GUI + self._draw_layer
	local world_name = reference_name .. "_ui_default_world"
	local view_name = self._parent.view_name
	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = reference_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(reference_name .. "_ui_default_renderer", self._world)
end

ViewElementItemResultOverlay._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = self._reference_name
	local timer_name = "ui"
	local world_layer = WORLD_LAYER_BACKGROUND + self._draw_layer
	local world_name = reference_name .. "_ui_background_world"
	local view_name = self._parent.view_name
	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_background_shading_callback")
	local viewport_name = reference_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_popup_background_renderer = ui_manager:create_renderer(reference_name .. "_ui_popup_background_renderer", self._background_world)
	local background_widget_definition = self._definitions.background_widget_definition
	self._background_widget = self:_create_widget("background_widget", background_widget_definition)
	self._blur_duration = BLUR_TIME
end

ViewElementItemResultOverlay.cb_background_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

ViewElementItemResultOverlay.on_resolution_modified = function (self, scale)
	ViewElementItemResultOverlay.super.on_resolution_modified(self, scale)
end

ViewElementItemResultOverlay.start = function (self, presentation_data)
	self._presentation_data = presentation_data
	self._duration = presentation_data.duration or 0
	self._time = 0
	self._started = true
	local item = presentation_data.item

	if item then
		self:_setup_weapon_stats()
		self._weapon_stats:present_item(item)
	end
end

ViewElementItemResultOverlay.cb_start_reward_presentation = function (self)
	return
end

ViewElementItemResultOverlay.destroy = function (self)
	if self._weapon_stats then
		self._weapon_stats:destroy()

		self._weapon_stats = nil
	end

	if self._ui_popup_background_renderer then
		self._ui_popup_background_renderer = nil

		Managers.ui:destroy_renderer(self._reference_name .. "_ui_popup_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end

	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer(self._reference_name .. "_ui_default_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end

	ViewElementItemResultOverlay.super.destroy(self)
end

ViewElementItemResultOverlay.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._started then
		return
	end

	local previous_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 0
	render_settings.alpha_multiplier = alpha_multiplier

	ViewElementItemResultOverlay.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local previous_layer = render_settings.start_layer
	render_settings.start_layer = (previous_layer or 0) + self._draw_layer
	render_settings.alpha_multiplier = previous_alpha_multiplier

	if self._weapon_stats then
		self._weapon_stats:draw(dt, t, ui_renderer, render_settings, input_service)
	end
end

ViewElementItemResultOverlay.update = function (self, dt, t, input_service)
	if self._time then
		if self._duration <= self._time then
			self._done = true
		else
			self._time = self._time + dt
		end
	end

	if self._weapon_stats then
		self._weapon_stats:update(dt, t, input_service)
	end

	return ViewElementItemResultOverlay.super.update(self, dt, t, input_service)
end

ViewElementItemResultOverlay._set_background_blur = function (self, fraction)
	local max_value = 0.55
	local reference_name = self._reference_name
	local world_name = reference_name .. "_ui_background_world"
	local viewport_name = reference_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

ViewElementItemResultOverlay.presentation_complete = function (self)
	return self._done
end

ViewElementItemResultOverlay._setup_weapon_stats = function (self)
	if not self._weapon_stats then
		local layer = self._draw_layer + 50
		local title_height = 70
		local edge_padding = 12
		local grid_width = 530
		local grid_height = 840
		local grid_size = {
			grid_width - edge_padding,
			grid_height
		}
		local grid_spacing = {
			0,
			0
		}
		local mask_size = {
			grid_width + 40,
			grid_height
		}
		local context = {
			scrollbar_width = 7,
			ignore_blur = true,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			title_height = title_height,
			edge_padding = edge_padding
		}
		local scale = self:render_scale()
		self._weapon_stats = ViewElementWeaponStats:new(self, layer, scale, context)

		self:_update_weapon_stats_position()
	end
end

ViewElementItemResultOverlay._update_weapon_stats_position = function (self)
	if not self._weapon_stats then
		return
	end

	local position = self:scenegraph_world_position("weapon_stats_pivot")

	self._weapon_stats:set_pivot_offset(position[1], position[2])
end

return ViewElementItemResultOverlay
