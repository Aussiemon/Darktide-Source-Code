-- chunkname: @scripts/managers/ui/ui_manager.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local InputDevice = require("scripts/managers/input/input_device")
local InputHoldTracker = require("scripts/managers/input/input_hold_tracker")
local ItemIconLoaderUI = require("scripts/ui/item_icon_loader_ui")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local Items = require("scripts/utilities/items")
local LoadingReason = require("scripts/ui/loading_reason")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local PortraitUI = require("scripts/ui/portrait_ui")
local RenderTargetAtlasGenerator = require("scripts/ui/render_target_atlas_generator")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TaskbarFlash = require("scripts/utilities/taskbar_flash")
local UIConstantElements = require("scripts/managers/ui/ui_constant_elements")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIHud = require("scripts/managers/ui/ui_hud")
local UIManagerTestify = GameParameters.testify and require("scripts/managers/ui/ui_manager_testify")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIViewHandler = require("scripts/managers/ui/ui_view_handler")
local Views = require("scripts/ui/views/views")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local UIManager = class("UIManager")

UIManager.DEBUG_TAG = "UI Manager"

local DEBUG_RELOAD = false

UIManager.init = function (self)
	self._views_loading_data = {}
	self._package_unload_list = {}
	self._renderers = {}
	self._ui_extension_managers = {}
	self._ui_element_package_references = {}
	self._current_state_name = ""
	self._current_sub_state_name = ""
	self._popup_id_counter = 0
	self._active_popups = {}
	self._visible_widgets = {}
	self._prev_visible_widgets = {}
	self._ui_inputs_in_use = {}

	local timer_name = "ui"
	local parent_timer_name = "main"

	Managers.time:register_timer(timer_name, parent_timer_name, 0)

	self._timer_name = timer_name

	local world_layer = 20
	local world_name = "ui_world"

	self._world_name = world_name
	self._default_world_layer = world_layer
	self._world = self:create_world(world_name, world_layer, timer_name)

	local viewport_name = "ui_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	local shading_environment

	self._viewport = self:create_viewport(self._world, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._viewport_name = viewport_name
	self._single_icon_renderers = {}
	self._single_icon_renderers_marked_for_destruction_array = {}
	self._render_target_atlas_generator = RenderTargetAtlasGenerator:new()

	self:_setup_icon_renderers()

	self._ui_loading_icon_renderer = self:create_renderer("ui_loading_icon_renderer")

	local input_service_name = "View"

	self._input_service_name = input_service_name
	self._view_handler = UIViewHandler:new(Views, timer_name)
	self._close_view_input_action = "back"
	self._loading_state_data = LoadingStateData:new()
	self._loading_reason = LoadingReason:new()

	local constant_elements = require("scripts/ui/constant_elements/constant_elements")

	self._ui_constant_elements = UIConstantElements:new(self, constant_elements)

	self:_load_ui_element_packages(constant_elements, "constant_elements")

	DEBUG_RELOAD = false

	Managers.event:register(self, "event_show_ui_popup", "event_show_ui_popup")
	Managers.event:register(self, "event_remove_ui_popup", "event_remove_ui_popup")
	Managers.event:register(self, "event_remove_ui_popups_by_priority", "event_remove_ui_popups_by_priority")
	Managers.event:register(self, "event_player_profile_updated", "event_player_profile_updated")
	Managers.event:register(self, "event_on_render_settings_applied", "event_on_render_settings_applied")
	Managers.event:register(self, "event_cinematic_skip_state", "event_cinematic_skip_state")
	Managers.event:register(self, "event_portrait_render_change", "event_portrait_render_change")
	Managers.event:register(self, "event_crossplay_change", "event_crossplay_change")

	self._input_hold_tracker = InputHoldTracker:new(input_service_name)
	self._client_waiting_loadout = false
	self._packages_to_remove = {}
end

UIManager.update_client_loadout_waiting_state = function (self, state)
	self._client_waiting_loadout = state
end

UIManager.get_client_loadout_waiting_state = function (self)
	return self._client_waiting_loadout
end

UIManager.get_delta_time = function (self)
	local timer_name = self._timer_name
	local time_manager = Managers.time
	local dt = time_manager:delta_time(timer_name)

	return dt
end

UIManager._setup_icon_renderers = function (self)
	local item_icon_size = UISettings.item_icon_size
	local cosmetics_icon_size = UISettings.item_icon_size
	local portrait_render_settings = {
		height = 160,
		level_name = "content/levels/ui/portrait/portrait",
		shading_environment = "content/shading_environments/ui/portrait",
		timer_name = "ui",
		viewport_layer = 1,
		viewport_name = "portrait_viewport",
		viewport_type = "default_with_alpha",
		width = 140,
		world_layer = 1,
		world_name = "portrait_world",
		render_target_atlas_generator = self._render_target_atlas_generator,
	}
	local cosmetics_render_settings = {
		always_render = true,
		level_name = "content/levels/ui/portrait/portrait",
		shading_environment = "content/shading_environments/ui/portrait",
		timer_name = "ui",
		viewport_layer = 900,
		viewport_name = "cosmetics_portrait_viewport",
		viewport_type = "default_with_alpha",
		world_layer = 900,
		world_name = "cosmetics_portrait_world",
		width = cosmetics_icon_size[1],
		height = cosmetics_icon_size[2],
		render_target_atlas_generator = self._render_target_atlas_generator,
	}
	local weapon_skins_render_settings = {
		height = 128,
		level_name = "content/levels/ui/weapon_icon/weapon_icon",
		shading_environment = "content/shading_environments/ui/weapon_icons",
		timer_name = "ui",
		viewport_layer = 900,
		viewport_name = "weapon_viewport",
		viewport_type = "default_with_alpha",
		width = 128,
		world_layer = 800,
		world_name = "weapon_skins_icon_world",
		render_target_atlas_generator = self._render_target_atlas_generator,
	}
	local companion_render_settings = {
		height = 128,
		level_name = "content/levels/ui/weapon_icon/weapon_icon",
		shading_environment = "content/shading_environments/ui/weapon_icons",
		timer_name = "ui",
		viewport_layer = 900,
		viewport_name = "weapon_viewport",
		viewport_type = "default_with_alpha",
		width = 128,
		world_layer = 800,
		world_name = "companion_icon_world",
		render_target_atlas_generator = self._render_target_atlas_generator,
	}
	local back_buffer_render_handlers = {}

	back_buffer_render_handlers.portraits = self:create_single_icon_renderer("portrait", "portraits", portrait_render_settings)
	back_buffer_render_handlers.cosmetics = self:create_single_icon_renderer("portrait", "cosmetics", cosmetics_render_settings)
	back_buffer_render_handlers.weapons = self:create_single_icon_renderer("weapon", "weapons")
	back_buffer_render_handlers.weapon_skin = self:create_single_icon_renderer("weapon", "weapon_skin", weapon_skins_render_settings)
	back_buffer_render_handlers.companion = self:create_single_icon_renderer("weapon", "companion", companion_render_settings)
	back_buffer_render_handlers.icon = self:create_single_icon_renderer("icon", "icon")
	self._back_buffer_render_handlers = back_buffer_render_handlers
end

UIManager.create_single_icon_renderer = function (self, render_type, id, settings)
	local single_icon_renderers = self._single_icon_renderers
	local instance

	if render_type == "weapon" then
		instance = WeaponIconUI:new(settings)
	elseif render_type == "icon" then
		instance = ItemIconLoaderUI:new(settings)
	else
		instance = PortraitUI:new(settings)
	end

	single_icon_renderers[id] = instance

	return instance
end

UIManager.destroy_single_icon_renderer = function (self, id)
	local single_icon_renderers = self._single_icon_renderers
	local instance = single_icon_renderers[id]
	local single_icon_renderers_marked_for_destruction_array = self._single_icon_renderers_marked_for_destruction_array

	single_icon_renderers_marked_for_destruction_array[#single_icon_renderers_marked_for_destruction_array + 1] = instance
	self._single_icon_renderers_destruction_frame_counter = 2

	instance:prepare_for_destruction()

	single_icon_renderers[id] = nil
end

UIManager._handle_single_icon_renderer_destruction = function (self, dt)
	if not self._single_icon_renderers_destruction_frame_counter then
		return
	elseif self._single_icon_renderers_destruction_frame_counter > 0 then
		self._single_icon_renderers_destruction_frame_counter = self._single_icon_renderers_destruction_frame_counter - 1

		return
	end

	local single_icon_renderers_marked_for_destruction_array = self._single_icon_renderers_marked_for_destruction_array

	for i = #single_icon_renderers_marked_for_destruction_array, 1, -1 do
		local instance = single_icon_renderers_marked_for_destruction_array[i]

		single_icon_renderers_marked_for_destruction_array[i] = nil

		instance:destroy()
	end

	self._single_icon_renderers_destruction_frame_counter = nil
end

UIManager.renderer_by_name = function (self, name)
	local data = self._renderers[name]

	return data.renderer
end

UIManager.destroy_renderer = function (self, name)
	local data = self._renderers[name]

	UIRenderer.destroy(data.renderer)

	self._renderers[name] = nil
end

UIManager.get_time = function (self)
	local timer_name = self._timer_name
	local time_manager = Managers.time
	local t = time_manager:time(timer_name)

	return t
end

UIManager.create_renderer = function (self, name, world, create_resource_target, gui, gui_retained, material_name, optional_width, optional_height, ignore_back_buffer)
	world = world or self._world

	local renderer

	if create_resource_target then
		renderer = UIRenderer.create_resource_renderer(world, gui, gui_retained, name, material_name, optional_width, optional_height, ignore_back_buffer)
	elseif optional_width and optional_height then
		renderer = UIRenderer.create_viewport_renderer(world, "custom_size", optional_width, optional_height)
	else
		renderer = UIRenderer.create_viewport_renderer(world)
	end

	self._renderers[name] = {
		renderer = renderer,
		world = world,
	}

	return renderer
end

UIManager.load_hud_packages = function (self, element_definitions, complete_callback)
	self:_load_ui_element_packages(element_definitions, "hud", complete_callback)
end

UIManager._load_ui_element_packages = function (self, element_definitions, reference_key, on_loaded_callback)
	local ui_element_packages_data = {}

	ui_element_packages_data.on_loaded_callback = on_loaded_callback

	local package_references = {}
	local is_loading = false

	for _, definition in ipairs(element_definitions) do
		local class_name = definition.class_name
		local reference_name = reference_key .. "_packages_" .. class_name
		local package = definition.package

		if package then
			package_references[reference_name] = {
				loaded = false,
				package = package,
			}
			is_loading = true
		end
	end

	ui_element_packages_data.package_references = package_references
	ui_element_packages_data.is_loading = is_loading
	self._ui_element_package_references[reference_key] = ui_element_packages_data

	if is_loading then
		local package_manager = Managers.package

		for _, definition in ipairs(element_definitions) do
			local package = definition.package

			if package then
				local class_name = definition.class_name
				local reference_name = reference_key .. "_packages_" .. class_name
				local on_load_callback = callback(self, "_on_ui_element_package_loaded", reference_key, reference_name)

				package_references[reference_name].id = package_manager:load(package, reference_name, on_load_callback)
			end
		end
	else
		ui_element_packages_data.is_loaded = true
		ui_element_packages_data.is_loading = nil

		if on_loaded_callback then
			on_loaded_callback()

			ui_element_packages_data.on_loaded_callback = nil
		end
	end
end

UIManager.hud_loaded = function (self)
	return self._ui_element_package_references.hud and self._ui_element_package_references.hud.is_loaded
end

UIManager.hud_loading = function (self)
	return self._ui_element_package_references.hud and self._ui_element_package_references.hud.is_loading
end

UIManager._on_ui_element_package_loaded = function (self, reference_key, reference_name, package_id)
	local package_references_data = self._ui_element_package_references[reference_key]

	if not package_references_data then
		return
	end

	local package_references = package_references_data.package_references
	local data = package_references[reference_name]

	if not data or data.id ~= package_id then
		return
	end

	data.is_loaded = true

	for _, package_data in pairs(package_references) do
		if not package_data.is_loaded then
			return
		end
	end

	package_references_data.is_loaded = true
	package_references_data.is_loading = nil

	if package_references_data.on_loaded_callback then
		package_references_data.on_loaded_callback()

		package_references_data.on_loaded_callback = nil
	end
end

UIManager.unload_hud = function (self)
	self:_unload_ui_element_packages("hud")
end

UIManager._unload_ui_element_packages = function (self, reference_key)
	local package_references_data = self._ui_element_package_references[reference_key]

	if package_references_data.is_loading or package_references_data.is_loaded then
		local package_manager = Managers.package
		local package_references = package_references_data.package_references

		for reference_name, package_data in pairs(package_references) do
			local package_id = package_data.id

			self._packages_to_remove[#self._packages_to_remove + 1] = package_id
		end
	end

	self._ui_element_package_references[reference_key] = nil
end

UIManager.create_player_hud = function (self, peer_id, local_player_id, elements, visibility_groups)
	visibility_groups = visibility_groups or require("scripts/ui/hud/hud_visibility_groups")

	local enable_world_bloom = not self._spectator_hud
	local params = {
		peer_id = peer_id,
		local_player_id = local_player_id or 1,
		enable_world_bloom = enable_world_bloom,
	}

	self._hud = UIHud:new(elements, visibility_groups, params)

	Managers.event:trigger("event_player_hud_created")
end

UIManager.create_spectator_hud = function (self, world_viewport_name, peer_id, local_player_id, elements, visibility_groups)
	visibility_groups = visibility_groups or require("scripts/ui/hud/hud_visibility_groups")

	local enable_world_bloom = not self._hud
	local params = {
		renderer_name = "spectator_hud_ui_renderer",
		peer_id = peer_id,
		local_player_id = local_player_id or 1,
		world_viewport_name = world_viewport_name,
		enable_world_bloom = enable_world_bloom,
	}

	self._spectator_hud = UIHud:new(elements, visibility_groups, params)

	Managers.event:trigger("event_player_hud_created")
end

UIManager.destroy_spectator_hud = function (self)
	if self._spectator_hud then
		local disable_world_bloom = not self._hud

		self._spectator_hud:destroy(disable_world_bloom)

		self._spectator_hud = nil
	end
end

UIManager.destroy_player_hud = function (self)
	if self._hud then
		local disable_world_bloom = not self._spectator_hud

		self._hud:destroy(disable_world_bloom)

		self._hud = nil
	end
end

UIManager.input_service = function (self, optional_service_name)
	local gamepad_active = false
	local input_service_name = optional_service_name or self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local null_service = input_service:null_service()
	local imgui = Managers.imgui

	if imgui and imgui:is_active() then
		input_service = null_service
	end

	if self._disable_input then
		input_service = null_service
	end

	return input_service, null_service, gamepad_active
end

UIManager.start_tracking_input_hold = function (self, action_name, time_completed, cb_completed)
	return self._input_hold_tracker:start_tracking(action_name, time_completed, cb_completed)
end

UIManager.stop_tracking_input_hold = function (self, tracking_id)
	self._input_hold_tracker:stop_tracking(tracking_id)
end

UIManager.get_input_alias_key = function (self, action, optional_service_name)
	local input_service_name = optional_service_name or self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local alias_key = input_service:get_alias_key(action)

	return alias_key
end

UIManager.get_action_type = function (self, action, optional_service_name)
	local input_service_name = optional_service_name or self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local action_type = input_service:get_action_type(action)

	return action_type
end

UIManager.handle_view_hotkeys = function (self, hotkey_settings)
	self._update_hotkeys = hotkey_settings
end

UIManager._update_view_hotkeys = function (self)
	if self._ui_constant_elements:using_input() then
		return
	end

	local view_handler = self._view_handler

	if view_handler:transitioning() then
		return
	end

	local views = view_handler:active_views()
	local input_service = self:input_service()
	local hotkey_settings = self._update_hotkeys
	local hotkeys = hotkey_settings.hotkeys
	local hotkey_lookup = hotkey_settings.lookup
	local gamepad_active = InputDevice.gamepad_active
	local num_views = #views

	if num_views > 0 then
		for i = num_views, 1, -1 do
			local active_view_name = views[i]

			if active_view_name then
				local settings = Views[active_view_name]
				local hotkey = hotkey_lookup[active_view_name]
				local close_on_hotkey = settings.close_on_hotkey_pressed
				local close_on_gamepad = settings.close_on_hotkey_gamepad
				local can_close_with_hotkey = close_on_hotkey and (not gamepad_active or close_on_gamepad)
				local close_by_hotkey = hotkey and can_close_with_hotkey and input_service:get(hotkey)
				local close_action = self._close_view_input_action
				local close_by_action = view_handler:allow_close_hotkey_for_view(active_view_name) and input_service:get(close_action)
				local should_close_view = close_by_hotkey or close_by_action
				local can_close_view = view_handler:can_close(active_view_name)

				if should_close_view and can_close_view then
					self:close_view(active_view_name)

					return
				end

				local allow_to_pass_input = view_handler:allow_to_pass_input_for_view(active_view_name)

				if not allow_to_pass_input then
					return
				end
			end
		end
	else
		for hotkey, view_name in pairs(hotkeys) do
			if input_service:get(hotkey) then
				self:open_view(view_name)

				return
			end
		end
	end
end

UIManager.open_view = function (self, view_name, transition_time, close_previous, close_all, close_transition_time, context, settings_override)
	local view_is_available = self:view_is_available(view_name)

	if not view_is_available then
		self:_show_error_popup(view_name)

		return false
	end

	local view_settings = Views[view_name]
	local validation_function = view_settings.validation_function
	local can_open_view = not validation_function or validation_function()

	if not can_open_view then
		return false
	end

	local view_handler = self._view_handler
	local view_is_active = view_handler:view_active(view_name)
	local view_is_closing = view_is_active and view_handler:is_view_closing(view_name)

	if view_is_closing then
		view_handler:close_view(view_name, true)

		view_is_active = false
	end

	view_handler:open_view(view_name, transition_time, close_previous, close_all, close_transition_time, context, settings_override)

	return true
end

UIManager._show_error_popup = function (self, view_name)
	local popup_params = {}
	local view_settings = Views[view_name]
	local header = view_settings.killswitch_unavailable_header
	local description = view_settings.killswitch_unavailable_description

	popup_params.title_text = header
	popup_params.description_text = description
	popup_params.options = {
		{
			close_on_pressed = true,
			hotkey = "back",
			template_type = "terminal_button_small",
			text = "loc_popup_unavailable_view_button_confirm",
		},
	}

	Managers.event:trigger("event_show_ui_popup", popup_params)
end

UIManager.close_view = function (self, view_name, force_close)
	self._view_handler:close_view(view_name, force_close)
end

UIManager.close_all_views = function (self, force_close, optional_excepted_views)
	self._view_handler:close_all_views(force_close, optional_excepted_views)
end

UIManager.view_active = function (self, view_name)
	return self._view_handler:view_active(view_name)
end

UIManager.is_view_closing = function (self, view_name)
	return self._view_handler:is_view_closing(view_name)
end

UIManager.view_render_scale = function (self)
	return self._view_handler:render_scale()
end

UIManager.has_active_view = function (self)
	return self._view_handler:active_top_view() ~= nil
end

UIManager.active_views = function (self)
	return self._view_handler:active_views()
end

UIManager.active_top_view = function (self)
	return self._view_handler:active_top_view()
end

UIManager.view_active_data = function (self, view_name)
	return self._view_handler:view_active_data(view_name)
end

UIManager.view_instance = function (self, view_name)
	return self._view_handler:view_instance(view_name)
end

UIManager.view_draw_top_layer = function (self)
	return self._view_handler:top_draw_layer() or 0
end

UIManager.has_hud = function (self)
	return self._hud and true or false
end

UIManager.allow_hud = function (self)
	local active_views = self._view_handler:active_views()

	for i = 1, #active_views do
		local active_view = active_views[i]
		local view_setting = self._view_handler:settings_by_view_name(active_view)
		local allow_hud = view_setting.allow_hud

		if not allow_hud then
			return false
		end
	end

	return true
end

UIManager.use_fullscreen_blur = function (self)
	return self._view_handler:use_fullscreen_blur()
end

UIManager.disable_game_world = function (self)
	return self._view_handler:disable_game_world()
end

UIManager.cb_on_game_state_change = function (self, previous_state_name, next_state_name)
	local view_handler = self._view_handler
	local active_views = view_handler:active_views()

	self._current_sub_state_name = ""
	self._current_state_name = next_state_name

	if active_views then
		for i = #active_views, 1, -1 do
			local active_view_name = active_views[i]
			local view_settings = view_handler:settings_by_view_name(active_view_name)
			local state_bound = view_settings.state_bound

			if state_bound and view_handler:view_active(active_view_name) and not view_handler:is_view_closing(active_view_name) then
				self:close_view(active_view_name)
			end
		end
	end
end

UIManager.cb_on_game_sub_state_change = function (self, previous_state_name, next_state_name)
	self._current_sub_state_name = next_state_name
end

UIManager.create_viewport = function (self, world, viewport_name, viewport_type, viewport_layer, shading_environment_name, shading_callback, optional_render_targets)
	shading_environment_name = shading_environment_name or GameParameters.default_ui_shading_environment

	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, viewport_layer, nil, nil, nil, nil, shading_environment_name, shading_callback, nil, optional_render_targets)

	return viewport
end

UIManager.create_world = function (self, world_name, optional_layer, optional_timer_name, optional_view_connection_name, optional_flags)
	local layer = optional_layer or 1
	local parameters = {
		layer = layer,
		timer_name = optional_timer_name or self._timer_name,
	}
	local flags = optional_flags or {
		Application.DISABLE_PHYSICS,
		Application.ENABLE_VOLUMETRICS,
		Application.ENABLE_RAY_TRACING,
	}
	local world_manager = Managers.world
	local world = world_manager:create_world(world_name, parameters, unpack(flags))

	if optional_view_connection_name then
		self._view_handler:register_view_world(optional_view_connection_name, world_name, layer)
	end

	return world
end

UIManager.destroy_world = function (self, world)
	local world_manager = Managers.world
	local world_name = world_manager:world_name(world)
	local view_handler = self._view_handler

	if view_handler then
		view_handler:unregister_world(world_name)
	end

	world_manager:destroy_world(world_name)
end

UIManager.world = function (self)
	return self._world
end

UIManager.using_cursor_navigation = function (self)
	return not InputDevice.gamepad_active
end

UIManager.using_input = function (self, ignore_hud, ignore_views, ignore_constant_elements)
	if self._ui_constant_elements and self._ui_constant_elements:using_input() and not ignore_constant_elements then
		return true
	elseif self._view_handler:using_input() and not ignore_views then
		return true
	elseif self._hud and not ignore_hud then
		return self._hud:using_input()
	end

	if self._interaction_using_input then
		return true
	end

	return false
end

UIManager.set_interaction_using_input = function (self, is_using)
	self._interaction_using_input = is_using
end

UIManager.inputs_in_use = function (self)
	return self._ui_inputs_in_use
end

UIManager.add_inputs_in_use_by_ui = function (self, input_name, optional_service_name)
	local input_service_name = optional_service_name or self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local input_keys = input_service:get_keys_from_alias(input_name)

	for i = 1, #input_keys do
		local input_key = input_keys[i]

		self._ui_inputs_in_use[input_key] = true
	end
end

UIManager.remove_inputs_in_use_by_ui = function (self, input_name, optional_service_name)
	local input_service_name = optional_service_name or self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local input_keys = input_service:get_keys_from_alias(input_name)

	for i = 1, #input_keys do
		local input_key = input_keys[i]

		self._ui_inputs_in_use[input_key] = nil
	end
end

UIManager.chat_using_input = function (self)
	return self._ui_constant_elements and self._ui_constant_elements:chat_using_input()
end

UIManager.communication_wheel_active = function (self)
	local hud = self._hud

	return hud and hud:communication_wheel_active()
end

UIManager.communication_wheel_wants_camera_control = function (self)
	local hud = self._hud

	return hud and hud:communication_wheel_wants_camera_control()
end

UIManager.emote_wheel_active = function (self)
	local hud = self._hud

	return hud and hud:emote_wheel_active()
end

UIManager.emote_wheel_wants_camera_control = function (self)
	local hud = self._hud

	return hud and hud:emote_wheel_wants_camera_control()
end

UIManager.wwise_music_state = function (self, wwise_state_group_name)
	return self._view_handler:wwise_music_state(wwise_state_group_name)
end

UIManager.destroy = function (self)
	Managers.event:unregister(self, "event_show_ui_popup")
	Managers.event:unregister(self, "event_remove_ui_popup")
	Managers.event:unregister(self, "event_remove_ui_popups_by_priority")
	Managers.event:unregister(self, "event_player_profile_updated")
	Managers.event:unregister(self, "event_on_render_settings_applied")
	Managers.event:unregister(self, "event_cinematic_skip_state")
	Managers.event:unregister(self, "event_portrait_render_change")
	Managers.event:unregister(self, "event_crossplay_change")
	self._view_handler:destroy()

	self._view_handler = nil

	self:destroy_spectator_hud()
	self:destroy_player_hud()

	if self._ui_constant_elements then
		self._ui_constant_elements:destroy()

		self._ui_constant_elements = nil
	end

	self:_unload_ui_element_packages("constant_elements")
	self._loading_state_data:delete()

	self._loading_state_data = nil

	if self._ui_loading_icon_renderer then
		self:destroy_renderer("ui_loading_icon_renderer")

		self._ui_loading_icon_renderer = nil
	end

	local world = self._world
	local viewport_name = self._viewport_name

	ScriptWorld.destroy_viewport(world, viewport_name)
	self:destroy_world(world)

	self._viewport_name = nil
	self._world = nil

	for id, instance in pairs(self._back_buffer_render_handlers) do
		self:destroy_single_icon_renderer(id)
	end

	self._back_buffer_render_handlers = nil

	if self._single_icon_renderers_destruction_frame_counter then
		self._single_icon_renderers_destruction_frame_counter = 0

		self:_handle_single_icon_renderer_destruction()
	end

	self._render_target_atlas_generator:destroy()

	self._render_target_atlas_generator = nil

	Managers.time:unregister_timer(self._timer_name)

	self._timer_name = nil

	self._input_hold_tracker:delete()

	self._input_hold_tracker = nil

	self:release_packages()
end

UIManager.play_3d_sound = function (self, event_name, position)
	local world = self._world
	local wwise_world = Managers.world:wwise_world(world)

	return WwiseWorld.trigger_resource_event(wwise_world, event_name, position)
end

UIManager.play_unit_sound = function (self, event_name, unit, optional_node)
	local world = self._world
	local wwise_world = Managers.world:wwise_world(world)

	return WwiseWorld.trigger_resource_event(wwise_world, event_name, unit, optional_node)
end

UIManager.play_2d_sound = function (self, event_name)
	local world = self._world
	local wwise_world = Managers.world:wwise_world(world)

	return WwiseWorld.trigger_resource_event(wwise_world, event_name)
end

UIManager.stop_2d_sound = function (self, event_id)
	local world = self._world
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.stop_event(wwise_world, event_id)
end

UIManager.set_2d_sound_parameter = function (self, parameter_id, value)
	local world = self._world
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_global_parameter(wwise_world, parameter_id, value)
end

local resolution_modified_key = "modified"

UIManager._handle_resolution_modified = function (self)
	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key]

	if resolution_modified then
		local back_buffer_render_handlers = self._back_buffer_render_handlers
		local portraits_instance = back_buffer_render_handlers.portraits

		if portraits_instance and portraits_instance.update_all then
			portraits_instance:update_all()
		end
	end
end

UIManager.update = function (self, dt, t)
	self._render_target_atlas_generator:update(dt, t)
	self:_handle_single_icon_renderer_destruction()

	self._disable_input = self._input_hold_tracker:update(dt)

	if self._update_hotkeys then
		self:_update_view_hotkeys()

		self._update_hotkeys = nil
	end

	self:release_packages()
	self:_handle_resolution_modified()

	local allow_view_input = self._ui_constant_elements and not self._ui_constant_elements:using_input()

	self._view_handler:update(dt, t, allow_view_input)

	if self._handle_package_unload_delay then
		self:_update_package_unload_delay()
	end

	if DEBUG_RELOAD then
		if self._ui_constant_elements then
			self._ui_constant_elements:destroy()

			self._ui_constant_elements = nil
		end

		local constant_elements = require("scripts/ui/constant_elements/constant_elements")

		self._ui_constant_elements = UIConstantElements:new(self, constant_elements)
		DEBUG_RELOAD = false
	end

	local ui_constant_elements = self._ui_constant_elements

	if ui_constant_elements then
		ui_constant_elements:update(dt, t, self:input_service())
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(UIManagerTestify, self)
	end

	if self._back_buffer_render_handlers then
		for _, back_buffer_renderer in pairs(self._back_buffer_render_handlers) do
			back_buffer_renderer:update(dt, t)
		end
	end

	self._loading_state_data:update()
end

UIManager.render = function (self, dt, t)
	self._view_handler:draw(dt, t)

	local world = self._world

	if world then
		local top_draw_layer = self:view_draw_top_layer()

		top_draw_layer = top_draw_layer + self._default_world_layer

		if top_draw_layer ~= self._world_draw_layer then
			self._world_draw_layer = top_draw_layer

			Managers.world:set_world_layer(self._world_name, top_draw_layer)
		end
	end

	local ui_constant_elements = self._ui_constant_elements

	if ui_constant_elements then
		ui_constant_elements:draw(dt, t, self:input_service())
	end

	local hud = self._hud
	local spectator_hud = self._spectator_hud

	if hud then
		local input_service = (spectator_hud or self._ui_constant_elements:using_input()) and self:input_service():null_service() or self:input_service()

		hud:draw(dt, t, input_service)
	end

	if spectator_hud then
		spectator_hud:draw(dt, t, self:input_service())
	end
end

UIManager.post_update = function (self, dt, t)
	local hud = self._hud
	local spectator_hud = self._spectator_hud
	local constant_element_using_input = self._ui_constant_elements:using_input()

	if hud then
		local input_service = (spectator_hud or constant_element_using_input) and self:input_service():null_service() or self:input_service()

		hud:update(dt, t, input_service)
	end

	if spectator_hud then
		local input_service = constant_element_using_input and self:input_service():null_service() or self:input_service()

		spectator_hud:update(dt, t, input_service)
	end

	self._view_handler:post_update(dt, t)

	local visible_widgets = self._visible_widgets
	local prev_visible_widgets = self._prev_visible_widgets

	for widget, ui_renderer in pairs(prev_visible_widgets) do
		if not visible_widgets[widget] then
			UIWidget.destroy_retained(widget, ui_renderer)
		end
	end

	self._visible_widgets, self._prev_visible_widgets = prev_visible_widgets, visible_widgets

	table.clear(prev_visible_widgets)

	local ui_constant_elements = self._ui_constant_elements

	if ui_constant_elements then
		ui_constant_elements:post_update(dt, t)
	end

	self._loading_state_data:post_update()
end

UIManager.frame_capture = function (self)
	GuiDebug.start_frame_caputure = true
end

UIManager.load_view = function (self, view_name, reference_name, loaded_callback, dynamic_package)
	local settings = Views[view_name]
	local packages_to_load_data = {}

	if dynamic_package then
		if type(dynamic_package) == "table" then
			local package_reference_name = reference_name .. #packages_to_load_data

			packages_to_load_data[#packages_to_load_data + 1] = {
				package_name = dynamic_package.name,
				reference_name = package_reference_name,
				is_level_package = dynamic_package.is_level_package or nil,
			}
		else
			local package_reference_name = reference_name .. #packages_to_load_data

			packages_to_load_data[#packages_to_load_data + 1] = {
				package_name = dynamic_package,
				reference_name = package_reference_name,
			}
		end
	end

	local package_name = settings.package
	local levels = settings.levels

	if package_name then
		local package_reference_name = reference_name .. #packages_to_load_data

		packages_to_load_data[#packages_to_load_data + 1] = {
			package_name = package_name,
			reference_name = package_reference_name,
		}
	end

	if levels then
		for i = 1, #levels do
			local level_name = levels[i]
			local package_reference_name = reference_name .. #packages_to_load_data

			packages_to_load_data[#packages_to_load_data + 1] = {
				is_level_package = true,
				package_name = level_name,
				reference_name = package_reference_name,
			}
		end
	end

	if #packages_to_load_data <= 0 then
		if loaded_callback then
			loaded_callback()
		end

		return false
	else
		reference_name = "UIManager_" .. reference_name

		if not self._views_loading_data[view_name] then
			self._views_loading_data[view_name] = {}
		end

		local view_loading_data = {
			packages_load_data = packages_to_load_data,
			loaded_callback = loaded_callback,
			reference_name = reference_name,
		}

		self._views_loading_data[view_name][reference_name] = view_loading_data

		local function callback_fn(package_data, view_loading_data)
			package_data.loaded = true

			local packages_load_data = view_loading_data.packages_load_data

			if package_data.is_level_package then
				local level_name = package_data.package_name
				local item_definitions = MasterItems.get_cached()
				local level_dependency_packages = ItemPackage.level_resource_dependency_packages(item_definitions, level_name)
				local depenency_package_load_data = {}

				for dependency_package_name, _ in pairs(level_dependency_packages) do
					local package_reference_name = reference_name .. #packages_load_data

					depenency_package_load_data[#depenency_package_load_data + 1] = {
						package_name = dependency_package_name,
						reference_name = package_reference_name,
					}
				end

				table.append(packages_load_data, depenency_package_load_data)

				for _, dependency_package_data in pairs(depenency_package_load_data) do
					local function load_cb(package_id)
						callback_fn(dependency_package_data, view_loading_data)
					end

					dependency_package_data.package_id = Managers.package:load(dependency_package_data.package_name, dependency_package_data.reference_name, load_cb)
				end
			end

			local completed = true

			if packages_load_data then
				for i = 1, #packages_load_data do
					local package_data = packages_load_data[i]

					if not package_data.loaded then
						completed = false

						break
					end
				end
			end

			if completed and view_loading_data.loaded_callback then
				view_loading_data.loaded_callback()
			end
		end

		for i = #packages_to_load_data, 1, -1 do
			local package_data = packages_to_load_data[i]

			local function load_cb(package_id)
				callback_fn(package_data, view_loading_data)
			end

			package_data.package_id = Managers.package:load(package_data.package_name, package_data.reference_name, load_cb)
		end

		return true
	end
end

UIManager.unload_view = function (self, view_name, reference_name, frame_delay_count)
	reference_name = "UIManager_" .. reference_name

	local view_loading_data = self._views_loading_data[view_name]

	if not view_loading_data then
		return
	end

	local loading_data = view_loading_data[reference_name]
	local packages_load_data = loading_data.packages_load_data

	for i = 1, #packages_load_data do
		local package_data = packages_load_data[i]

		self:_unload_package(package_data.package_id, frame_delay_count)
	end

	loading_data.loaded_callback = nil
	self._views_loading_data[view_name][reference_name] = nil
end

UIManager._unload_package = function (self, package_id, frame_delay_count)
	if frame_delay_count then
		self._package_unload_list[#self._package_unload_list + 1] = {
			package_id = package_id,
			frame_delay = frame_delay_count,
		}
		self._handle_package_unload_delay = true
	else
		self._packages_to_remove[#self._packages_to_remove + 1] = package_id
	end
end

UIManager._update_package_unload_delay = function (self)
	local package_unload_list = self._package_unload_list
	local num_packages = #package_unload_list

	for i = num_packages, 1, -1 do
		local package_info = package_unload_list[i]
		local frame_delay = package_info.frame_delay

		frame_delay = frame_delay - 1

		if frame_delay < 0 then
			local package_id = package_info.package_id

			self._packages_to_remove[#self._packages_to_remove + 1] = package_id

			table.remove(package_unload_list, i)

			if #package_unload_list == 0 then
				self._handle_package_unload_delay = nil

				break
			end
		else
			package_info.frame_delay = frame_delay
		end
	end
end

UIManager.world_extension_manager = function (self, world)
	local world_name = World.get_data(world, "__world_name")
	local extension_manager = self._ui_extension_managers[world_name]

	return extension_manager
end

UIManager.unregister_world_extension_manager_lookup = function (self, world)
	local world_name = World.get_data(world, "__world_name")

	self._ui_extension_managers[world_name] = nil
end

UIManager.register_world_extension_manager_lookup = function (self, world, extension_manager)
	local world_name = World.get_data(world, "__world_name")

	self._ui_extension_managers[world_name] = extension_manager
end

UIManager.render_black_background = function (self)
	local gui = self._ui_loading_icon_renderer.gui

	Gui.rect(gui, Vector3.zero(), Vector3(RESOLUTION_LOOKUP.width, RESOLUTION_LOOKUP.height, 0), Color(255, 0, 0, 0))
end

UIManager.render_loading_icon = function (self)
	local gui = self._ui_loading_icon_renderer.gui

	self._loading_reason:render(gui, false)
end

UIManager.render_loading_info = function (self)
	local gui = self._ui_loading_icon_renderer.gui
	local wait_reason, wait_time, text_opacity = self._loading_state_data:current_wait_info()

	self._loading_reason:render(gui, wait_reason, wait_time, text_opacity)
end

UIManager.current_wait_info = function (self)
	return self._loading_state_data:current_wait_info()
end

UIManager.handling_popups = function (self)
	return #self._active_popups > 0
end

UIManager.active_popups = function (self)
	return self._active_popups
end

UIManager.event_show_ui_popup = function (self, data, callback)
	local priority_order = data.priority_order or 0
	local popup_type = data.type
	local popup_id = self._popup_id_counter
	local name = "popup_" .. popup_id
	local popup = {}

	popup.name = name
	popup.type = popup_type
	popup.data = data
	popup.id = popup_id
	popup.priority_order = priority_order

	local active_popups = self._active_popups
	local num_active_popups = #active_popups
	local start_index

	if num_active_popups > 0 then
		for i = 1, num_active_popups do
			if priority_order > active_popups[i].priority_order then
				start_index = i

				break
			elseif i == num_active_popups then
				start_index = i + 1
			end
		end
	end

	start_index = start_index or 1

	table.insert(active_popups, start_index, popup)

	self._popup_id_counter = popup_id + 1

	if callback then
		callback(popup_id)
	end

	TaskbarFlash.flash_window()
end

UIManager.event_pause_popup_input = function (self, popup_id, paused)
	local popup = self:_popup_by_id(popup_id, false)

	if popup then
		popup.paused = paused ~= false
	end
end

UIManager.event_remove_ui_popup = function (self, popup_id)
	local remove = true

	self:_popup_by_id(popup_id, remove)
end

UIManager.event_remove_ui_popups_by_priority = function (self, priority)
	local active_popups = self._active_popups

	for i = #active_popups, 1, -1 do
		local popup = active_popups[i]

		if priority > popup.priority_order then
			popup.closing = true

			table.remove(active_popups, i)
		end
	end
end

UIManager._popup_by_id = function (self, popup_id, remove)
	local active_popups = self._active_popups

	for i = 1, #active_popups do
		local popup = active_popups[i]

		if popup.id == popup_id then
			if remove then
				popup.closing = true

				return table.remove(active_popups, i)
			else
				return popup
			end
		end
	end
end

UIManager.get_current_state_name = function (self)
	return self._current_state_name
end

UIManager.get_current_sub_state_name = function (self)
	return self._current_sub_state_name
end

UIManager.load_profile_portrait = function (self, profile, cb, render_context, unload_cb)
	local instance = self._back_buffer_render_handlers.portraits

	return instance:load_profile_portrait(profile, cb, render_context, nil, unload_cb)
end

UIManager.unload_profile_portrait = function (self, id)
	local instance = self._back_buffer_render_handlers.portraits

	instance:unload_profile_portrait(id)
end

UIManager.event_player_profile_updated = function (self, peer_id, local_player_id, profile)
	local instance = self._back_buffer_render_handlers.portraits

	instance:profile_updated(profile)
	self:update_client_loadout_waiting_state(false)
end

UIManager.event_portrait_render_change = function (self, value)
	local instance = self._back_buffer_render_handlers.portraits

	instance:change_render_portrait_status(value)
end

UIManager._set_crossplay_and_return_to_title_screen = function (self, enabled, category, id)
	local restricted = not enabled

	Managers.account:set_crossplay_restriction(restricted)
	Managers.account:return_to_title_screen()
end

UIManager._unset_crossplay = function (self, enabled, category, id)
	local old_value = not enabled

	self._disable_crossplay_changed = true

	Managers.event:trigger("set_option_value", category, id, old_value)

	self._disable_crossplay_changed = false
end

UIManager.event_crossplay_change = function (self, enabled, category, id)
	if self._disable_crossplay_changed and self._disable_crossplay_changed == true then
		return
	end

	local context = {
		description_text = "loc_popup_description_crossplay_changed",
		priority_order = 1000,
		title_text = "loc_popup_header_crossplay_changed",
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_button_confirm",
				callback = callback(self, "_set_crossplay_and_return_to_title_screen", enabled),
			},
			{
				close_on_pressed = true,
				text = "loc_popup_button_close",
				callback = callback(self, "_unset_crossplay", enabled, category, id),
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

UIManager.portrait_has_request = function (self, id)
	local instance = self._back_buffer_render_handlers.portraits

	return instance:has_request(id)
end

UIManager.load_item_icon = function (self, real_item, cb, render_context, dummy_profile, prioritize, unload_cb)
	local item_name = real_item.name
	local gear_id = real_item.gear_id or item_name
	local item

	if real_item.gear then
		item = MasterItems.create_preview_item_instance(real_item)
	else
		item = table.clone_instance(real_item)
	end

	item.gear_id = gear_id

	local slots = item.slots or {}
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local instance = self._back_buffer_render_handlers.weapons

		return instance:load_weapon_icon(item, cb, render_context, prioritize, unload_cb)
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = Items.weapon_skin_preview_item(item)
		local instance = self._back_buffer_render_handlers.weapon_skin

		return instance:load_weapon_icon(visual_item, cb, render_context, prioritize, unload_cb)
	elseif item_type == "WEAPON_TRINKET" then
		local instance = self._back_buffer_render_handlers.weapon_skin
		local visual_item = Items.weapon_trinket_preview_item(item)

		return instance:load_weapon_icon(visual_item, cb, render_context, prioritize, unload_cb)
	elseif item_type == "COMPANION_GEAR_FULL" then
		local instance = self._back_buffer_render_handlers.companion

		return instance:load_weapon_icon(item, cb, render_context, prioritize, unload_cb)
	elseif table.find(slots, "slot_gear_head") or table.find(slots, "slot_gear_upperbody") or table.find(slots, "slot_gear_lowerbody") or table.find(slots, "slot_gear_extra_cosmetic") or table.find(slots, "slot_animation_end_of_round") then
		render_context = render_context or {}

		local player = Managers.player:local_player(1)
		local profile = dummy_profile or player:profile()
		local gender_name = profile and profile.gender
		local breed_name = profile and profile.archetype.breed
		local archetype = profile and profile.archetype
		local archetype_name = archetype and archetype.name

		dummy_profile = Items.create_mannequin_profile_by_item(real_item, gender_name, archetype_name, breed_name)

		local item_slot_name

		if real_item.slots and not table.is_empty(item.slots) then
			dummy_profile.loadout[item.slots[1]] = real_item
		end

		local prop_item_key = item.prop_item
		local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

		if prop_item then
			local prop_item_slot = prop_item.slots[1]

			dummy_profile.loadout[prop_item_slot] = prop_item
			render_context.wield_slot = prop_item_slot
		end

		local icon_camera_position_offset = item.icon_camera_position_offset

		if icon_camera_position_offset then
			render_context.icon_camera_position_offset = icon_camera_position_offset
		else
			render_context.icon_camera_position_offset = nil
		end

		local icon_camera_rotation_offset = item.icon_camera_rotation_offset

		if icon_camera_rotation_offset then
			render_context.icon_camera_rotation_offset = icon_camera_rotation_offset
		else
			render_context.icon_camera_rotation_offset = nil
		end

		render_context.ignore_companion = not render_context.companion_state_machine and (real_item.companion_state_machine == "" or real_item.companion_state_machine == nil)
		dummy_profile.character_id = string.format("%s_%s_%s", gear_id, dummy_profile.breed, dummy_profile.gender)

		local instance = self._back_buffer_render_handlers.cosmetics

		return instance:load_profile_portrait(dummy_profile, cb, render_context, prioritize, unload_cb)
	elseif table.find(slots, "slot_insignia") or table.find(slots, "slot_portrait_frame") or table.find(slots, "slot_character_title") or table.find(slots, "slot_animation_emote_1") or table.find(slots, "slot_animation_emote_2") or table.find(slots, "slot_animation_emote_3") or table.find(slots, "slot_animation_emote_4") or table.find(slots, "slot_animation_emote_5") then
		local instance = self._back_buffer_render_handlers.icon

		return instance:load_icon(item, cb, unload_cb)
	elseif item_type == "SET" then
		local instance = self._back_buffer_render_handlers.cosmetics
		local items = item.items

		if not items then
			items = {}

			for _, set_item_data in pairs(item.set_items) do
				items[#items + 1] = MasterItems.get_item(set_item_data.item)
			end
		end

		dummy_profile = Items.create_mannequin_profile_by_item(item)

		local gender_name = dummy_profile.gender
		local archetype = dummy_profile.archetype
		local breed_name = archetype.breed
		local loadout = dummy_profile.loadout
		local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name]
		local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]
		local required_items = required_gender_item_names_per_slot and required_gender_item_names_per_slot.default

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)

					dummy_profile.loadout[slot_name] = slot_item
				end
			end
		end

		for i = 1, #items do
			local set_item = items[i]
			local first_slot_name = set_item.slots[1]

			loadout[first_slot_name] = set_item
		end

		dummy_profile.character_id = string.format("%s_%s_%s", gear_id, dummy_profile.breed, dummy_profile.gender)

		return instance:load_profile_portrait(dummy_profile, cb, render_context, prioritize, unload_cb)
	end
end

UIManager.unload_item_icon = function (self, id)
	local weapons_instance = self._back_buffer_render_handlers.weapons
	local weapon_skin_instance = self._back_buffer_render_handlers.weapon_skin
	local companion_instance = self._back_buffer_render_handlers.companion
	local cosmetics_instance = self._back_buffer_render_handlers.cosmetics
	local icon_instance = self._back_buffer_render_handlers.icon

	if companion_instance:has_request(id) then
		companion_instance:unload_weapon_icon(id)
	elseif weapon_skin_instance:has_request(id) then
		weapon_skin_instance:unload_weapon_icon(id)
	elseif weapons_instance:has_request(id) then
		weapons_instance:unload_weapon_icon(id)
	elseif icon_instance:has_request(id) then
		icon_instance:unload_icon(id)
	elseif cosmetics_instance:has_request(id) then
		cosmetics_instance:unload_profile_portrait(id)
	end
end

UIManager.update_item_icon_priority = function (self, id)
	local weapons_instance = self._back_buffer_render_handlers.weapons
	local weapon_skin_instance = self._back_buffer_render_handlers.weapon_skin
	local companion_instance = self._back_buffer_render_handlers.companion
	local cosmetics_instance = self._back_buffer_render_handlers.cosmetics
	local icon_instance = self._back_buffer_render_handlers.icon

	if companion_instance:has_request(id) then
		companion_instance:prioritize_request(id)
	elseif weapon_skin_instance:has_request(id) then
		weapon_skin_instance:prioritize_request(id)
	elseif weapons_instance:has_request(id) then
		weapons_instance:prioritize_request(id)
	elseif icon_instance:has_request(id) then
		icon_instance:prioritize_request(id)
	elseif cosmetics_instance:has_request(id) then
		cosmetics_instance:prioritize_request(id)
	end
end

UIManager.increment_item_icon_load_by_existing_id = function (self, id)
	local weapons_instance = self._back_buffer_render_handlers.weapons
	local weapon_skin_instance = self._back_buffer_render_handlers.weapon_skin
	local companion_instance = self._back_buffer_render_handlers.companion
	local cosmetics_instance = self._back_buffer_render_handlers.cosmetics
	local icon_instance = self._back_buffer_render_handlers.icon

	if companion_instance:has_request(id) then
		return companion_instance:increment_icon_request_by_reference_id(id)
	elseif weapon_skin_instance:has_request(id) then
		return weapon_skin_instance:increment_icon_request_by_reference_id(id)
	elseif weapons_instance:has_request(id) then
		return weapons_instance:increment_icon_request_by_reference_id(id)
	elseif icon_instance:has_request(id) then
		return icon_instance:increment_icon_request_by_reference_id(id)
	elseif cosmetics_instance:has_request(id) then
		return cosmetics_instance:increment_icon_request_by_reference_id(id)
	end
end

UIManager.item_icon_updated = function (self, item)
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local instance = self._back_buffer_render_handlers.weapons

		instance:weapon_icon_updated(item)
	elseif item_type == "COMPANION_GEAR_FULL" then
		local instance = self._back_buffer_render_handlers.companion

		instance:weapon_icon_updated(item)
	elseif item_type == "WEAPON_TRINKET" or item_type == "WEAPON_SKIN" then
		local instance = self._back_buffer_render_handlers.weapon_skin

		instance:weapon_icon_updated(item)
	else
		local player = Managers.player:local_player(1)
		local profile = player:profile()
		local instance = self._back_buffer_render_handlers.cosmetics

		instance:profile_updated(profile)
	end
end

UIManager.event_on_render_settings_applied = function (self)
	for _, instance in pairs(self._single_icon_renderers) do
		if instance.update_all then
			instance:update_all()
		end
	end
end

UIManager.view_is_available = function (self, view_name)
	local view_settings = Views[view_name]
	local killswitch = view_settings.killswitch

	if not killswitch then
		return true
	end

	local view_is_available = GameParameters[killswitch]

	return view_is_available
end

UIManager.ui_constant_elements = function (self)
	return self._ui_constant_elements
end

UIManager.event_cinematic_skip_state = function (self, show_skip, can_skip)
	if not self._cinematic_skip_state then
		self._cinematic_skip_state = {}
	end

	local show_skip = show_skip ~= nil and show_skip
	local can_skip = can_skip ~= nil and can_skip

	if show_skip == nil then
		show_skip = self._cinematic_skip_state.show_skip
	end

	if can_skip == nil then
		can_skip = self._cinematic_skip_state.can_skip
	end

	self._cinematic_skip_state = {
		show_skip = show_skip,
		can_skip = can_skip,
	}
end

UIManager.cinematic_skip_state = function (self)
	if self._cinematic_skip_state then
		return self._cinematic_skip_state.show_skip, self._cinematic_skip_state.can_skip
	else
		return false, false
	end
end

UIManager.get_hud = function (self)
	return self._hud
end

UIManager.release_packages = function (self)
	local packages_to_remove = self._packages_to_remove
	local package_manager = Managers.package

	for i = 1, #packages_to_remove do
		package_manager:release(packages_to_remove[i])
	end

	table.clear(self._packages_to_remove)
end

return UIManager
