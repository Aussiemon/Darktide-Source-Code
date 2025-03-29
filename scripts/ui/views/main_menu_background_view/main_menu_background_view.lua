-- chunkname: @scripts/ui/views/main_menu_background_view/main_menu_background_view.lua

local definition_path = "scripts/ui/views/main_menu_background_view/main_menu_background_view_definitions"
local MainMenuBackgroundViewSettings = require("scripts/ui/views/main_menu_background_view/main_menu_background_view_settings")
local MasterItems = require("scripts/backend/master_items")
local UICharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local WorldRender = require("scripts/utilities/world_render")
local MainMenuBackgroundView = class("MainMenuBackgroundView", "BaseView")

MainMenuBackgroundView.init = function (self, settings, context)
	local definitions = require(definition_path)

	self._context = context or {}
	self._loading_profile_queue = {}
	self._profiles_loading_data = {}

	MainMenuBackgroundView.super.init(self, definitions, settings, context)

	self._pass_draw = false
	self._can_exit = false
end

MainMenuBackgroundView.on_enter = function (self)
	MainMenuBackgroundView.super.on_enter(self)
	self:_setup_background_world()
	self:_register_event("event_main_menu_load_profile")
	self:_register_event("event_main_menu_set_presentation_profile")
	self:_register_event("event_main_menu_set_new_profile")
	self:_register_event("event_main_menu_set_camera_axis_offset")

	self._item_definitions = MasterItems.get_cached()

	Managers.ui:open_view("main_menu_view", nil, nil, nil, nil, self._context)
end

MainMenuBackgroundView._setup_background_world = function (self)
	self:_register_event("event_register_main_menu_camera")
	self:_register_event("event_register_main_menu_spawn_point")
	self:_register_event("event_register_main_menu_new_character_dummy")

	local world_name = MainMenuBackgroundViewSettings.world_name
	local world_layer = MainMenuBackgroundViewSettings.world_layer
	local world_timer_name = MainMenuBackgroundViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = MainMenuBackgroundViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

MainMenuBackgroundView.event_register_main_menu_camera = function (self, camera_unit)
	self:_unregister_event("event_register_main_menu_camera")

	local viewport_name = MainMenuBackgroundViewSettings.viewport_name
	local viewport_type = MainMenuBackgroundViewSettings.viewport_type
	local viewport_layer = MainMenuBackgroundViewSettings.viewport_layer
	local shading_environment = MainMenuBackgroundViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

MainMenuBackgroundView.event_register_main_menu_new_character_dummy = function (self, dummy_unit)
	self:_unregister_event("event_register_main_menu_new_character_dummy")
	Unit.set_unit_visibility(dummy_unit, false, true)

	self._dummy_unit = dummy_unit
end

MainMenuBackgroundView.event_register_main_menu_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_main_menu_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.background_spawn_point_unit = spawn_point_unit
	end
end

MainMenuBackgroundView.event_main_menu_load_profile = function (self, profile, prioritized)
	self:_set_profile_in_loading_queue(profile, prioritized)
end

MainMenuBackgroundView.event_main_menu_set_presentation_profile = function (self, profile)
	self._presentation_profile = profile

	local loaded = false
	local loading = false
	local profiles_loading_data = self._profiles_loading_data

	for i = 1, #profiles_loading_data do
		local loading_data = profiles_loading_data[i]

		if loading_data.profile == profile then
			loading = true

			if loading_data.loaded then
				loaded = true

				break
			end
		end
	end

	if loaded then
		self:_spawn_profile(profile)
	elseif loading then
		local current_index = table.index_of(self._loading_profile_queue, profile)

		if current_index > 1 then
			table.remove(self._loading_profile_queue, current_index)
			table.insert(self._loading_profile_queue, 1, profile)
		end
	else
		local prioritized = true

		self:_set_profile_in_loading_queue(profile, prioritized)
	end
end

MainMenuBackgroundView.event_main_menu_set_new_profile = function (self)
	self:_show_dummy_unit()
end

MainMenuBackgroundView.event_main_menu_set_camera_axis_offset = function (self, axis, value, animation_duration, func_ptr)
	if self._world_spawner then
		self._world_spawner:set_camera_position_axis_offset(axis, value, animation_duration, func_ptr)
	end
end

MainMenuBackgroundView._can_spawn_profile = function (self, profile)
	return self._spawn_point_unit ~= nil and self._spawned_profile ~= profile and self._item_definitions
end

MainMenuBackgroundView._spawn_profile = function (self, profile)
	if self._profile_spawner then
		self._profile_spawner:reset()
	else
		local world = self._world_spawner:world()
		local camera = self._world_spawner:camera()
		local unit_spawner = self._world_spawner:unit_spawner()

		self._profile_spawner = UIProfileSpawner:new("MainMenuBackgroundView", world, camera, unit_spawner)
	end

	Unit.set_unit_visibility(self._dummy_unit, false, true)

	local ignored_slots = MainMenuBackgroundViewSettings.ignored_slots

	for i = 1, #ignored_slots do
		local slot_name = ignored_slots[i]

		self._profile_spawner:ignore_slot(slot_name)
	end

	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	local selected_archetype = profile.archetype
	local archetype_name = selected_archetype.name
	local is_ogryn = archetype_name == "ogryn"

	self:_move_camera(is_ogryn)

	self._spawned_profile = profile
end

MainMenuBackgroundView._move_camera = function (self, is_ogryn)
	local animation_duration = 0.01
	local world_spawner = self._world_spawner

	if is_ogryn == true then
		world_spawner:set_camera_position_axis_offset("x", -0.15, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("y", -2.8, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("z", 0.4, animation_duration, math.easeOutCubic)
	else
		world_spawner:set_camera_position_axis_offset("x", 0, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("y", 0, animation_duration, math.easeOutCubic)
		world_spawner:set_camera_position_axis_offset("z", 0, animation_duration, math.easeOutCubic)
	end
end

MainMenuBackgroundView._show_dummy_unit = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	self:_move_camera()
	Unit.set_unit_visibility(self._dummy_unit, true, true)
end

MainMenuBackgroundView._set_profile_in_loading_queue = function (self, profile, prioritized)
	if prioritized then
		table.insert(self._loading_profile_queue, 1, profile)
	else
		self._loading_profile_queue[#self._loading_profile_queue + 1] = profile
	end
end

MainMenuBackgroundView._load_profile = function (self, profile)
	self._profile_loader_index = (self._profile_loader_index or 0) + 1

	local reference_name = self.__class_name .. "characters_profile_loader_" .. tostring(self._profile_loader_index)
	local profile_loader = UICharacterProfilePackageLoader:new(reference_name, self._item_definitions)

	profile_loader:load_profile(profile)

	self._profiles_loading_data[#self._profiles_loading_data + 1] = {
		profile = profile,
		loader = profile_loader,
		loader_index = self._profile_loader_index,
	}
end

MainMenuBackgroundView._unload_profile = function (self, profile)
	local loading_queue_index = table.index_of(self._loading_profile_queue, profile)

	if loading_queue_index then
		table.remove(self._loading_profile_queue, loading_queue_index)
	else
		local loading_data_index

		for i = 1, #self._profiles_loading_data do
			local loading_data = self._profiles_loading_data[i]

			if loading_data.profile == profile then
				loading_data_index = i

				local loader = loading_data.loader

				loader:destroy()

				break
			end
		end

		if loading_data_index then
			table.remove(self._profiles_loading_data, loading_data_index)
		end
	end
end

MainMenuBackgroundView.can_exit = function (self)
	return self._can_exit
end

MainMenuBackgroundView.on_exit = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	table.clear(self._loading_profile_queue)

	for i = 1, #self._profiles_loading_data do
		local loading_data = self._profiles_loading_data[i]
		local loader = loading_data.loader

		loader:destroy()
	end

	self._profiles_loading_data = nil

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	MainMenuBackgroundView.super.on_exit(self)
end

MainMenuBackgroundView._handle_background_blur = function (self)
	local ui_manager = Managers.ui
	local apply_blur, blur_amount = ui_manager:use_fullscreen_blur()

	if apply_blur ~= self._game_world_fullscreen_blur_enabled or self._game_world_fullscreen_blur_amount ~= blur_amount then
		local world_name = MainMenuBackgroundViewSettings.world_name
		local viewport_name = MainMenuBackgroundViewSettings.viewport_name

		self._game_world_fullscreen_blur_enabled = apply_blur
		self._game_world_fullscreen_blur_amount = blur_amount

		if apply_blur then
			WorldRender.enable_world_fullscreen_blur(world_name, viewport_name, blur_amount)
		else
			WorldRender.disable_world_fullscreen_blur(world_name, viewport_name)
		end
	end
end

MainMenuBackgroundView.update = function (self, dt, t, input_service)
	local world_spawner = self._world_spawner

	if world_spawner then
		local ui_manager = Managers.ui
		local apply_blur, blur_amount = ui_manager:use_fullscreen_blur()
		local blur_animation_duration = 0.2

		if apply_blur and not self._screen_blurred then
			self._screen_blurred = true

			world_spawner:set_camera_blur(blur_amount, blur_animation_duration)
		elseif not apply_blur and self._screen_blurred then
			self._screen_blurred = nil

			world_spawner:set_camera_blur(blur_amount, blur_animation_duration)
		end

		if self.closing_view and not self._is_closing then
			if Managers.ui:view_active("main_menu_view") and not Managers.ui:is_view_closing("main_menu_view") then
				Managers.ui:close_view("main_menu_view")
			end

			self._is_closing = true
		end

		world_spawner:update(dt, t)
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local loading_profile_queue = self._loading_profile_queue

	if #loading_profile_queue > 0 and self._item_definitions then
		local profile_to_load = table.remove(loading_profile_queue, 1)

		self:_load_profile(profile_to_load)
	end

	local profiles_loading_data = self._profiles_loading_data

	for i = 1, #profiles_loading_data do
		local loading_data = profiles_loading_data[i]
		local profile = loading_data.profile

		if not loading_data.loaded then
			local loader = loading_data.loader

			if loader:is_all_loaded() then
				loading_data.loaded = true
			end
		end

		if loading_data.loaded and profile == self._presentation_profile and self:_can_spawn_profile(profile) then
			self:_spawn_profile(profile)
		end
	end

	return MainMenuBackgroundView.super.update(self, dt, t, input_service)
end

return MainMenuBackgroundView
