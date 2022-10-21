local ExperiencePresentation = require("scripts/utilities/experience_presentation")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementWeaponExperiencePresentationSettings = require("scripts/ui/view_elements/view_element_weapon_experience_presentation/view_element_weapon_experience_presentation_settings")
local definition_path = "scripts/ui/view_elements/view_element_weapon_experience_presentation/view_element_weapon_experience_presentation_definitions"
local MasterItems = require("scripts/backend/master_items")
local ViewElementWeaponExperiencePresentation = class("ViewElementWeaponExperiencePresentation", "ViewElementBase")

ViewElementWeaponExperiencePresentation.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)
	self._time = nil
	self._reference_name = "ViewElementWeaponExperiencePresentation_" .. tostring(self)

	ViewElementWeaponExperiencePresentation.super.init(self, parent, draw_layer, start_scale, definitions)

	self._pass_draw = true
	self._pass_input = true
end

ViewElementWeaponExperiencePresentation._initialize_preview_world = function (self)
	local world_name = self._reference_name .. "_world"
	local world_layer = 10
	local world_timer_name = "ui"
	local view_name = self._parent.view_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, view_name)
	local viewport_name = self._reference_name .. "_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1
	local shading_environment = ViewElementWeaponExperiencePresentationSettings.shading_environment
	local camera_unit = nil

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
	self:_update_viewport_resolution()
end

ViewElementWeaponExperiencePresentation._update_viewport_resolution = function (self)
	self:_force_update_scenegraph()

	local scale = self._render_scale
	local resolution_width = RESOLUTION_LOOKUP.width
	local resolution_height = RESOLUTION_LOOKUP.height
	local screen_scenegraph_id = "screen"
	local screen_width, screen_height = self:_scenegraph_size(screen_scenegraph_id, 1)
	local screen_world_position = self:scenegraph_world_position(screen_scenegraph_id, scale)
	local screen_size_width_scale = screen_width / resolution_width
	local screen_size_height_scale = screen_height / resolution_height

	self._world_spawner:set_viewport_size(screen_size_width_scale, screen_size_height_scale)

	local screen_position_x_scale = screen_world_position[1] / resolution_width
	local screen_position_y_scale = screen_world_position[2] / resolution_height

	self._world_spawner:set_viewport_position(screen_position_x_scale, screen_position_y_scale)
end

local function linear_to_clip_depth(linear_depth, camera_near, camera_far)
	if linear_depth == 0 then
		return 0
	end

	return camera_far * (linear_depth - camera_near) / (linear_depth * (camera_far - camera_near))
end

ViewElementWeaponExperiencePresentation._get_spawn_position = function (self)
	local world_spawner = self._world_spawner
	local camera = world_spawner:camera()
	local scale = self._render_scale
	local depth_multiplier = 1 + 1 - scale
	local weapon_spawn_depth = ViewElementWeaponExperiencePresentationSettings.weapon_spawn_depth * depth_multiplier
	local world_depth = linear_to_clip_depth(weapon_spawn_depth, Camera.near_range(camera), Camera.far_range(camera))
	local viewport_scenegraph_id = "viewport"
	local viewport_width, viewport_height = self:_scenegraph_size(viewport_scenegraph_id)
	local viewport_world_position = self:scenegraph_world_position(viewport_scenegraph_id, scale)
	local position = Vector3(viewport_world_position[1] + viewport_width * scale * 0.5, viewport_world_position[2] + viewport_height * scale * 0.5, 0)
	local world_position_offset = Camera.screen_to_world(camera, position, world_depth)

	return world_position_offset
end

ViewElementWeaponExperiencePresentation.on_resolution_modified = function (self, scale)
	ViewElementWeaponExperiencePresentation.super.on_resolution_modified(self, scale)

	if self._world_spawner then
		self:_update_viewport_resolution()

		if self._ui_weapon_spawner then
			local new_position = self:_get_spawn_position()

			self._ui_weapon_spawner:set_position(new_position)
		end
	end
end

ViewElementWeaponExperiencePresentation.skip = function (self)
	local experience_data = self._experience_data

	if self._on_enter_anim_id and self:_is_animation_active(self._on_enter_anim_id) then
		self:_complete_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	elseif ExperiencePresentation.presentation_started(experience_data) and not ExperiencePresentation.presentation_completed(experience_data) then
		ExperiencePresentation.skip_to_next_timestamp(experience_data)
	end
end

ViewElementWeaponExperiencePresentation.start = function (self, presentation_data, duration)
	self:_initialize_preview_world()

	local weapon_item_id = presentation_data.weapon_item_id
	local item = MasterItems.get_item(weapon_item_id)
	local starting_experience = presentation_data.starting_experience
	local experience_gained = presentation_data.experience_gained
	local experience_settings = presentation_data.experience_settings
	self._duration = duration

	self:_setup_experience_presentation_data(experience_settings, starting_experience, experience_gained, self._duration)

	local on_enter_animation_callback = callback(self, "cb_start_experience_presentation")
	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self, on_enter_animation_callback)
	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local spawn_position = self:_get_spawn_position()
	local spawn_rotation = nil
	local previewer_reference_name = self._reference_name
	self._ui_weapon_spawner = UIWeaponSpawner:new(previewer_reference_name, world, camera, unit_spawner)

	self._ui_weapon_spawner:activate_auto_spin()
	self._ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation)

	local weapon_name = item.name
	self._widgets_by_name.name_text.content.text = weapon_name or "n/a"
end

ViewElementWeaponExperiencePresentation._setup_experience_presentation_data = function (self, experience_settings, starting_experience, experience_gained, presentation_duration)
	local level_up_delay = ViewElementWeaponExperiencePresentationSettings.level_up_delay
	local experience_data = ExperiencePresentation.setup_presentation_data(experience_settings, starting_experience, experience_gained, presentation_duration, level_up_delay)
	self._experience_data = experience_data
	local start_level = experience_data.start_level
	local start_bar_progress = experience_data.start_bar_progress
	self._current_level = start_level

	self:_set_next_level(start_level + 1)
	self:_set_bar_progress(start_bar_progress)

	self._end_duration = experience_data.spare_time
end

ViewElementWeaponExperiencePresentation.cb_start_experience_presentation = function (self)
	ExperiencePresentation.start_presentation(self._experience_data)

	self._on_enter_anim_id = nil
end

ViewElementWeaponExperiencePresentation.canvas_size = function (self)
	return self:_scenegraph_size("canvas")
end

ViewElementWeaponExperiencePresentation.set_pivot_offset = function (self, x, y)
	self:_set_scenegraph_position("canvas", x, y)
	self:_force_update_scenegraph()
end

ViewElementWeaponExperiencePresentation.destroy = function (self)
	ViewElementWeaponExperiencePresentation.super.destroy(self)

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._playing_experience_sound then
		self:_play_sound(UISoundEvents.end_screen_summary_experience_stop)

		self._playing_experience_sound = false
	end
end

ViewElementWeaponExperiencePresentation.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local previous_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 0
	render_settings.alpha_multiplier = alpha_multiplier

	ViewElementWeaponExperiencePresentation.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

ViewElementWeaponExperiencePresentation.update = function (self, dt, t, input_service)
	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:update(dt, t, input_service)
	end

	local counting_experience = false
	local counting_experience_progress = nil
	local experience_data = self._experience_data

	if experience_data and not ExperiencePresentation.presentation_completed(experience_data) and ExperiencePresentation.presentation_started(experience_data) then
		local current_level, next_level, current_presentation_progress, presentation_experience = ExperiencePresentation.update_presentation(experience_data, dt, t)

		if current_level ~= self._current_level then
			self._current_level = current_level

			self:_play_sound(UISoundEvents.end_screen_summary_weapon_level_up)
		else
			counting_experience = true
		end

		if next_level then
			self:_set_next_level(next_level)
		end

		if current_presentation_progress then
			self:_set_bar_progress(current_presentation_progress)

			counting_experience_progress = current_presentation_progress
		end

		if presentation_experience then
			self:_set_experience_text("+" .. tostring(presentation_experience))
		end
	end

	if counting_experience then
		if not self._playing_experience_sound then
			self:_play_sound(UISoundEvents.end_screen_summary_experience_start)

			self._playing_experience_sound = true
		end

		if counting_experience_progress then
			self:_set_sound_parameter("ui_xp_progress", counting_experience_progress)
		end
	elseif self._playing_experience_sound then
		self:_play_sound(UISoundEvents.end_screen_summary_experience_stop)

		self._playing_experience_sound = false
	end

	return ViewElementWeaponExperiencePresentation.super.update(self, dt, t, input_service)
end

ViewElementWeaponExperiencePresentation._set_next_level = function (self, level)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.current_level_text.content.text = level > 1 and tostring(level - 1) or ""
	widgets_by_name.next_level_text.content.text = tostring(level)
end

ViewElementWeaponExperiencePresentation._set_experience_text = function (self, text)
	local widget = self._widgets_by_name.experience_text
	widget.content.text = text
end

ViewElementWeaponExperiencePresentation._set_bar_progress = function (self, progress)
	local default_scenegraph = self._definitions.scenegraph_definition.progress_bar
	local default_width = default_scenegraph.size[1]
	local widgets_by_name = self._widgets_by_name
	local progress_bar = widgets_by_name.progress_bar
	progress_bar.content.progress = progress
	progress_bar.content.bar_length = default_width
end

ViewElementWeaponExperiencePresentation.presentation_complete = function (self)
	local experience_data = self._experience_data

	if experience_data and ExperiencePresentation.presentation_completed(experience_data) then
		return true
	end
end

return ViewElementWeaponExperiencePresentation
