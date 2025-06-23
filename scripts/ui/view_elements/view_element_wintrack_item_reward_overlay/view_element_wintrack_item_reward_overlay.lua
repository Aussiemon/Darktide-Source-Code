-- chunkname: @scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay.lua

local InputUtils = require("scripts/managers/input/input_utils")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementWintrackItemRewardOverlaySettings = require("scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay_settings")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local WorldRenderUtils = require("scripts/utilities/world_render")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UISettings = require("scripts/settings/ui/ui_settings")
local ItemUtils = require("scripts/utilities/items")
local Definitions = require("scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay_definitions")
local BLUR_TIME = 0.3
local WORLD_LAYER_BACKGROUND = 300
local WORLD_LAYER_TOP_GUI = 400
local ViewElementWintrackItemRewardOverlay = class("ViewElementWintrackItemRewardOverlay", "ViewElementBase")

ViewElementWintrackItemRewardOverlay.init = function (self, parent, draw_layer, start_scale)
	self._time = nil
	self._reference_name = "ViewElementWintrackItemRewardOverlay_" .. tostring(self)

	ViewElementWintrackItemRewardOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._pass_draw = true
	self._pass_input = true

	self:_setup_background_world()
	self:_setup_default_gui()

	local background_widget_definition = self._definitions.background_widget_definition

	self._background_widget = self:_create_widget("background_widget", background_widget_definition)
end

ViewElementWintrackItemRewardOverlay._setup_default_gui = function (self)
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

ViewElementWintrackItemRewardOverlay._setup_background_world = function (self)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_register_event("event_register_title_screen_camera")

	local world_name = ViewElementWintrackItemRewardOverlaySettings.world_name
	local world_layer = ViewElementWintrackItemRewardOverlaySettings.world_layer
	local world_timer_name = ViewElementWintrackItemRewardOverlaySettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = ViewElementWintrackItemRewardOverlaySettings.level_name
	local ignore_level_background = ViewElementWintrackItemRewardOverlaySettings.ignore_level_background

	self._world_spawner:spawn_level(level_name, nil, nil, nil, ignore_level_background)
end

ViewElementWintrackItemRewardOverlay.event_register_title_screen_camera = function (self, camera_unit)
	self:_unregister_event("event_register_title_screen_camera")

	local viewport_name = ViewElementWintrackItemRewardOverlaySettings.viewport_name
	local viewport_type = ViewElementWintrackItemRewardOverlaySettings.viewport_type
	local viewport_layer = ViewElementWintrackItemRewardOverlaySettings.viewport_layer
	local shading_environment = ViewElementWintrackItemRewardOverlaySettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

ViewElementWintrackItemRewardOverlay._setup_background_gui = function (self)
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
	self._blur_duration = BLUR_TIME
end

ViewElementWintrackItemRewardOverlay.cb_background_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ViewElementWintrackItemRewardOverlay.on_resolution_modified = function (self, scale)
	ViewElementWintrackItemRewardOverlay.super.on_resolution_modified(self, scale)
	self:_update_weapon_stats_position()

	if self._world_spawner then
		self:_update_viewport_resolution()
	end
end

ViewElementWintrackItemRewardOverlay._update_viewport_resolution = function (self)
	self:_force_update_scenegraph()

	if self._world_spawner then
		local scale = self._render_scale or 1
		local scenegraph = self._ui_scenegraph
		local id = "canvas"
		local x_scale, y_scale, w_scale, h_scale = UIScenegraph.get_scenegraph_id_screen_scale(scenegraph, id, scale)

		self._world_spawner:set_viewport_size(w_scale, h_scale)
		self._world_spawner:set_viewport_position(x_scale, y_scale)
	end
end

ViewElementWintrackItemRewardOverlay.start = function (self, presentation_data)
	self._presentation_data = presentation_data

	local widgets_by_name = self._widgets_by_name

	self:_setup_background_gui()

	self._duration = presentation_data.duration or 0
	self._time = 0
	self._started = true

	local sound_event = ViewElementWintrackItemRewardOverlaySettings.sound_events_by_item_rarity[1]
	local item = presentation_data.item

	if item then
		self:_load_item_icon(item)
		self:_update_weapon_stats_position()

		local item_rarity = item.rarity
		local effect_textures_by_rarity = ViewElementWintrackItemRewardOverlaySettings.effect_textures_by_rarity
		local rarity_glow_textures = effect_textures_by_rarity[item_rarity]

		sound_event = ViewElementWintrackItemRewardOverlaySettings.sound_events_by_item_rarity[item_rarity]

		if rarity_glow_textures then
			local rarity_glow_widget = widgets_by_name.rarity_glow
			local rarity_glow_widget_content = rarity_glow_widget.content
		end

		local display_name = ItemUtils.display_name(item)
		local sub_display_name = ItemUtils.sub_display_name(item)
		local rarity_color = ItemUtils.rarity_color(item)
		local widgets_by_name = self._widgets_by_name

		widgets_by_name.sub_display_name.content.text = sub_display_name
		widgets_by_name.display_name.content.text = display_name
		self._widgets_by_name.element.style.background_gradient.color = table.clone(rarity_color)
	end

	self:_start_animation("on_enter", self._widgets_by_name, self)
	self:_start_animation("present_element", self._widgets_by_name, self, nil)

	if sound_event then
		self:_play_sound(sound_event)
	end

	widgets_by_name.input_text.content.text = Localize("loc_item_result_overlay_input_description")
end

local function _apply_package_item_icon_cb_func(widget, item)
	local icon_style = widget.style.icon
	local widget_content = widget.content

	widget_content.icon = "content/ui/materials/icons/items/containers/item_container_square_masked_circle"

	local item_slot = ItemUtils.item_slot(item)
	local item_icon_size = item_slot and table.clone(item_slot.item_icon_size)
	local material_values = icon_style.material_values

	if item_icon_size then
		widget.style.icon_original_size = icon_style.size and table.clone(icon_style.size) or {}
		icon_style.size = item_icon_size
		material_values.icon_size = item_icon_size
	end

	if item.icon_material and item.icon_material ~= "" then
		widget.content.icon = item.icon_material
		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
	else
		if widget.style.icon_original_size then
			icon_style.size = widget.style.icon_original_size
			widget.style.icon_original_size = nil
		end

		material_values.texture_icon = item.icon
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values

	material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1

	local icon_style = widget.style.icon

	icon_style.size = widget.style.icon_original_size or icon_style.size
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture

	if widget.style.icon_original_size then
		icon_style.size = widget.style.icon_original_size
		widget.style.icon_original_size = nil
	end
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local widget_style = widget.style
	local widget_content = widget.content

	widget_content.icon = "content/ui/materials/icons/items/containers/item_container_landscape_masked_circle"

	local icon_style = widget_style.icon
	local material_values = icon_style.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 1
	material_values.render_target = nil
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

ViewElementWintrackItemRewardOverlay._load_item_icon = function (self, item)
	local ui_renderer = self._ui_default_renderer
	local item_type = item.item_type
	local item_type_group_lookup = UISettings.item_type_group_lookup
	local item_group = item_type_group_lookup[item_type]
	local widget = self._widgets_by_name.element

	if not self._icon_load_id and item then
		local slot_name = ItemUtils.slot_name(item)
		local item_state_machine = item.state_machine
		local item_animation_event = item.animation_event
		local render_context = {
			camera_focus_slot_name = slot_name,
			state_machine = item_state_machine,
			animation_event = item_animation_event,
			size = {
				1024,
				1024
			}
		}
		local cb, unload_cb

		if item_group == "nameplates" or item_group == "emotes" or item_group == "titles" then
			cb = callback(_apply_package_item_icon_cb_func, widget, item)
			unload_cb = callback(_remove_package_item_icon_cb_func, widget, ui_renderer)
		elseif item_group == "weapon_skin" then
			item = ItemUtils.weapon_skin_preview_item(item)
			cb = callback(_apply_live_item_icon_cb_func, widget)
			unload_cb = callback(_remove_live_item_icon_cb_func, widget, ui_renderer)
		else
			cb = callback(_apply_live_item_icon_cb_func, widget)
			unload_cb = callback(_remove_live_item_icon_cb_func, widget, ui_renderer)
		end

		self._icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, nil, nil, unload_cb)
	end
end

ViewElementWintrackItemRewardOverlay.unload_item_icon = function (self)
	if self._icon_load_id then
		Managers.ui:unload_item_icon(self._icon_load_id)

		self._icon_load_id = nil
	end
end

ViewElementWintrackItemRewardOverlay.cb_start_reward_presentation = function (self)
	return
end

ViewElementWintrackItemRewardOverlay.destroy = function (self, ui_renderer)
	self:unload_item_icon()

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ui_renderer = self._ui_default_renderer or ui_renderer

	if self._weapon_stats then
		self._weapon_stats:destroy(ui_renderer)

		self._weapon_stats = nil
	end

	ViewElementWintrackItemRewardOverlay.super.destroy(self, ui_renderer)

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
end

ViewElementWintrackItemRewardOverlay.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._started then
		return
	end

	ui_renderer = self._ui_default_renderer

	local previous_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 0

	render_settings.alpha_multiplier = alpha_multiplier

	ViewElementWintrackItemRewardOverlay.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	local ui_scenegraph = self._ui_scenegraph
	local ui_popup_background_renderer = self._ui_popup_background_renderer

	if ui_popup_background_renderer then
		UIRenderer.begin_pass(ui_popup_background_renderer, ui_scenegraph, input_service, dt, render_settings)
		UIWidget.draw(self._background_widget, ui_popup_background_renderer)
		UIRenderer.end_pass(ui_popup_background_renderer)
	end

	local previous_scale = render_settings.scale

	if self._weapon_stats then
		self._weapon_stats:set_render_scale(previous_scale)
		self._weapon_stats:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier
	render_settings.scale = previous_scale
end

ViewElementWintrackItemRewardOverlay.update = function (self, dt, t, input_service)
	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._blur_duration then
		if self._blur_duration < 0 then
			self._blur_duration = nil
		else
			local progress = 1 - self._blur_duration / BLUR_TIME
			local anim_progress = math.easeOutCubic(progress)

			self:_set_background_blur(anim_progress)

			self._blur_duration = self._blur_duration - dt
			self._alpha_multiplier = anim_progress
		end
	end

	if self._time and self._duration > 0 then
		if self._time >= self._duration then
			self._done = true
		else
			self._time = self._time + dt
		end
	end

	if self._weapon_stats then
		self._weapon_stats:update(dt, t, input_service)
		self:_update_weapon_stats_position()
	end

	return ViewElementWintrackItemRewardOverlay.super.update(self, dt, t, input_service)
end

ViewElementWintrackItemRewardOverlay._set_background_blur = function (self, fraction)
	local max_value = 0.55
	local reference_name = self._reference_name
	local world_name = reference_name .. "_ui_background_world"
	local viewport_name = reference_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

ViewElementWintrackItemRewardOverlay.presentation_complete = function (self)
	return self._done
end

ViewElementWintrackItemRewardOverlay._setup_weapon_stats = function (self)
	if not self._weapon_stats then
		local layer = WORLD_LAYER_BACKGROUND + self._draw_layer + 50
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
	end
end

ViewElementWintrackItemRewardOverlay._update_weapon_stats_position = function (self)
	local weapon_stats = self._weapon_stats

	if not weapon_stats then
		return
	end

	local scale = self:render_scale() or 1
	local render_scale = weapon_stats:render_scale() or 1
	local scale_difference = math.round_with_precision(render_scale - scale, 3)
	local position = self:scenegraph_world_position("weapon_stats_pivot")
	local length = weapon_stats:grid_length() or 0
	local menu_settings = weapon_stats:menu_settings()
	local grid_size = menu_settings.grid_size
	local edge_padding = menu_settings.edge_padding
	local grid_width = grid_size[1]

	weapon_stats:set_pivot_offset(position[1], position[2] - length * 0.5)
	self:_set_scenegraph_size("rarity_glow", grid_width + edge_padding, length)
end

ViewElementWintrackItemRewardOverlay.set_title_text = function (self, localized_text)
	self._widgets_by_name.title_text.content.text = localized_text
end

return ViewElementWintrackItemRewardOverlay
