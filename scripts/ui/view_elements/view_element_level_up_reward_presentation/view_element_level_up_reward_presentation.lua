local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementLevelUpRewardPresentationSettings = require("scripts/ui/view_elements/view_element_level_up_reward_presentation/view_element_level_up_reward_presentation_settings")
local WorldRenderUtils = require("scripts/utilities/world_render")
local definition_path = "scripts/ui/view_elements/view_element_level_up_reward_presentation/view_element_level_up_reward_presentation_definitions"
local MasterItems = require("scripts/backend/master_items")
local BLUR_TIME = 0.3
local WORLD_LAYER_BACKGROUND = 30
local WORLD_LAYER_TOP_GUI = 40
local WORLD_LAYER_ITEM = 35
local ViewElementLevelUpRewardPresentation = class("ViewElementLevelUpRewardPresentation", "ViewElementBase")

ViewElementLevelUpRewardPresentation.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)
	self._time = nil
	self._reference_name = "ViewElementLevelUpRewardPresentation_" .. tostring(self)

	ViewElementLevelUpRewardPresentation.super.init(self, parent, draw_layer, start_scale, definitions)

	self._pass_draw = true
	self._pass_input = true

	self:_setup_default_gui()
end

ViewElementLevelUpRewardPresentation._setup_default_gui = function (self)
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

ViewElementLevelUpRewardPresentation._setup_background_gui = function (self)
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

ViewElementLevelUpRewardPresentation.cb_background_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ViewElementLevelUpRewardPresentation.prepare_reward = function (self, reward)
	self._presentation_data = reward
end

ViewElementLevelUpRewardPresentation._initialize_preview_world = function (self)
	local world_name = self._reference_name .. "_world"
	local world_layer = WORLD_LAYER_ITEM + self._draw_layer
	local world_timer_name = "ui"
	local view_name = self._parent.view_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, view_name)
	local viewport_name = self._reference_name .. "_viewport"
	local viewport_type = "default"
	local viewport_layer = 1
	local shading_environment = ViewElementLevelUpRewardPresentationSettings.shading_environment
	local camera_unit = nil

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

local function linear_to_clip_depth(linear_depth, camera_near, camera_far)
	if linear_depth == 0 then
		return 0
	end

	return camera_far * (linear_depth - camera_near) / (linear_depth * (camera_far - camera_near))
end

ViewElementLevelUpRewardPresentation._get_spawn_position = function (self)
	self:_force_update_scenegraph()

	local world_spawner = self._world_spawner
	local camera = world_spawner:camera()
	local scale = self._render_scale
	local depth_multiplier = 1 + 1 - scale
	local weapon_spawn_depth = ViewElementLevelUpRewardPresentationSettings.weapon_spawn_depth * depth_multiplier
	local world_depth = linear_to_clip_depth(weapon_spawn_depth, Camera.near_range(camera), Camera.far_range(camera))
	local viewport_scenegraph_id = "pivot"
	local viewport_width, viewport_height = self:_scenegraph_size(viewport_scenegraph_id)
	local viewport_world_position = self:scenegraph_world_position(viewport_scenegraph_id, scale)
	local position = Vector3(viewport_world_position[1] + viewport_width * scale * 0.5, viewport_world_position[2] + viewport_height * scale * 0.5, 0)
	local world_position_offset = Camera.screen_to_world(camera, position, world_depth)

	return world_position_offset
end

ViewElementLevelUpRewardPresentation.on_resolution_modified = function (self, scale)
	ViewElementLevelUpRewardPresentation.super.on_resolution_modified(self, scale)

	if self._world_spawner and self._ui_weapon_spawner then
		local new_position = self:_get_spawn_position()

		self._ui_weapon_spawner:set_position(new_position)
	end
end

ViewElementLevelUpRewardPresentation.start = function (self)
	self:_setup_background_gui()
	self:_initialize_preview_world()

	local presentation_data = self._presentation_data
	self._duration = presentation_data.duration or 0
	local on_enter_animation_callback = callback(self, "cb_start_reward_presentation")
	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self, on_enter_animation_callback)
	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local texture_visible = false
	local presentation_type = presentation_data.type

	if presentation_type == "item" then
		local reward_item_id = presentation_data.reward_item_id
		local item = MasterItems.get_item(reward_item_id)
		local item_name = item and item.name or "n/a"
		local weapon_template = item and item.weapon_template

		if weapon_template then
			local spawn_position = self:_get_spawn_position()
			local spawn_rotation = Quaternion.axis_angle(Vector3.up(), math.pi / 2)
			local previewer_reference_name = self._reference_name
			local ui_weapon_spawner = UIWeaponSpawner:new(previewer_reference_name, world, camera, unit_spawner)

			ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation)

			local ignore_spin_randomness = true

			ui_weapon_spawner:activate_auto_spin(ignore_spin_randomness)

			self._ui_weapon_spawner = ui_weapon_spawner
		end

		self._widgets_by_name.name_text.content.text = item_name
		self._widgets_by_name.title_text.content.text = Managers.localization:localize("loc_level_up_reward_title_item")

		Log.info("ViewElementLevelUpRewardPresentation", "item_reward: %s", item_name)
	elseif presentation_type == "unlock" then
		local text = presentation_data.text
		self._widgets_by_name.name_text.content.text = text
		self._widgets_by_name.title_text.content.text = Managers.localization:localize("loc_level_up_reward_title_unlock")
		self._widgets_by_name.texture.content.texture = "content/ui/materials/placeholders/eor_unlock"
		texture_visible = true
	elseif presentation_type == "acquired" then
		local text = presentation_data.text
		self._widgets_by_name.name_text.content.text = text
		self._widgets_by_name.title_text.content.text = Managers.localization:localize("loc_level_up_reward_title_acquired")
		self._widgets_by_name.texture.content.texture = "content/ui/materials/placeholders/eor_reward"
		texture_visible = true
	end

	self._widgets_by_name.texture.content.visible = texture_visible
	self._started = true
end

ViewElementLevelUpRewardPresentation.cb_start_reward_presentation = function (self)
	self._on_enter_anim_id = nil
	self._time = 0
end

ViewElementLevelUpRewardPresentation.destroy = function (self)
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

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ViewElementLevelUpRewardPresentation.super.destroy(self)
end

ViewElementLevelUpRewardPresentation.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._started then
		return
	end

	ui_renderer = self._ui_default_renderer
	local previous_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 0
	render_settings.alpha_multiplier = alpha_multiplier

	ViewElementLevelUpRewardPresentation.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local previous_layer = render_settings.start_layer
	render_settings.start_layer = (previous_layer or 0) + self._draw_layer
	local ui_scenegraph = self._ui_scenegraph
	local ui_popup_background_renderer = self._ui_popup_background_renderer

	if ui_popup_background_renderer then
		UIRenderer.begin_pass(ui_popup_background_renderer, ui_scenegraph, input_service, dt, render_settings)
		UIWidget.draw(self._background_widget, ui_popup_background_renderer)
		UIRenderer.end_pass(ui_popup_background_renderer)
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

ViewElementLevelUpRewardPresentation.update = function (self, dt, t, input_service)
	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:update(dt, t, input_service)
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

	if self._time then
		if self._duration <= self._time then
			self._done = true
		else
			self._time = self._time + dt
		end
	end

	return ViewElementLevelUpRewardPresentation.super.update(self, dt, t, input_service)
end

ViewElementLevelUpRewardPresentation._set_background_blur = function (self, fraction)
	local max_value = 0.55
	local reference_name = self._reference_name
	local world_name = reference_name .. "_ui_background_world"
	local viewport_name = reference_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

ViewElementLevelUpRewardPresentation.presentation_complete = function (self)
	return self._done
end

return ViewElementLevelUpRewardPresentation
