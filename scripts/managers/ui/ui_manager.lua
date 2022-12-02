local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local LoadingIcon = require("scripts/ui/loading_icon")
local MasterItems = require("scripts/backend/master_items")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIConstantElements = require("scripts/managers/ui/ui_constant_elements")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIHud = require("scripts/managers/ui/ui_hud")
local UIManagerTestify = GameParameters.testify and require("scripts/managers/ui/ui_manager_testify")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIViewHandler = require("scripts/managers/ui/ui_view_handler")
local PortraitUI = require("scripts/ui/portrait_ui")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local ItemIconLoaderUI = require("scripts/ui/item_icon_loader_ui")
local Views = require("scripts/ui/views/views")
local InputDevice = require("scripts/managers/input/input_device")
local UISettings = require("scripts/settings/ui/ui_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local ItemUtils = require("scripts/utilities/items")
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
	local shading_environment = nil
	self._viewport = self:create_viewport(self._world, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._viewport_name = viewport_name
	self._single_icon_renderers = {}
	self._single_icon_renderers_marked_for_destruction_array = {}

	self:_setup_icon_renderers()

	self._ui_loading_icon_renderer = self:create_renderer("ui_loading_icon_renderer")
	local input_service_name = "View"
	self._input_service_name = input_service_name
	self._view_handler = UIViewHandler:new(Views, timer_name)
	self._close_view_input_action = "back"
	local constant_elements = require("scripts/ui/constant_elements/constant_elements")
	self._ui_constant_elements = UIConstantElements:new(self, constant_elements)

	self:_load_ui_element_packages(constant_elements, "constant_elements")

	DEBUG_RELOAD = false

	Managers.event:register(self, "event_show_ui_popup", "event_show_ui_popup")
	Managers.event:register(self, "event_remove_ui_popup", "event_remove_ui_popup")
	Managers.event:register(self, "event_player_profile_updated", "event_player_profile_updated")
	Managers.event:register(self, "event_player_appearance_updated", "event_player_appearance_updated")
	Managers.event:register(self, "event_on_render_settings_applied", "event_on_render_settings_applied")
end

UIManager.get_delta_time = function (self)
	local timer_name = self._timer_name
	local time_manager = Managers.time
	local dt = time_manager:delta_time(timer_name)

	return dt
end

UIManager._setup_icon_renderers = function (self)
	local back_buffer_render_handlers = {}
	local item_icon_size = UISettings.item_icon_size
	local cosmetics_icon_size = UISettings.item_icon_size
	local portrait_render_settings = {
		viewport_layer = 1,
		world_layer = 1,
		world_name = "portrait_world",
		target_resolution_height = 1600,
		viewport_type = "default_with_alpha",
		viewport_name = "portrait_viewport",
		portrait_width = 140,
		target_resolution_width = 1400,
		shading_environment = "content/shading_environments/ui/portrait",
		level_name = "content/levels/ui/portrait/portrait",
		portrait_height = 160,
		timer_name = "ui"
	}
	local cosmetics_render_settings = {
		viewport_layer = 900,
		world_layer = 900,
		world_name = "cosmetics_portrait_world",
		viewport_type = "default_with_alpha",
		viewport_name = "cosmetics_portrait_viewport",
		shading_environment = "content/shading_environments/ui/portrait",
		level_name = "content/levels/ui/portrait/portrait",
		timer_name = "ui",
		portrait_width = cosmetics_icon_size[1],
		portrait_height = cosmetics_icon_size[2],
		target_resolution_width = cosmetics_icon_size[1] * 10,
		target_resolution_height = cosmetics_icon_size[2] * 10
	}
	local appearance_render_settings = {
		viewport_layer = 900,
		world_layer = 900,
		world_name = "appearance_portrait_world",
		target_resolution_height = 1920,
		viewport_type = "default_with_alpha",
		viewport_name = "appearance_portrait_viewport",
		portrait_width = 128,
		target_resolution_width = 1280,
		shading_environment = "content/shading_environments/ui/portrait",
		level_name = "content/levels/ui/portrait/portrait",
		portrait_height = 192,
		timer_name = "ui"
	}
	back_buffer_render_handlers.portraits = PortraitUI:new(portrait_render_settings)
	back_buffer_render_handlers.appearance = PortraitUI:new(appearance_render_settings)
	back_buffer_render_handlers.cosmetics = PortraitUI:new(cosmetics_render_settings)
	back_buffer_render_handlers.weapons = WeaponIconUI:new()
	back_buffer_render_handlers.icon = ItemIconLoaderUI:new()
	self._back_buffer_render_handlers = back_buffer_render_handlers
end

UIManager.create_single_icon_renderer = function (self, render_type, id, settings)
	local single_icon_renderers = self._single_icon_renderers
	local instance = nil

	if render_type == "weapon" then
		instance = WeaponIconUI:new(settings)
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

UIManager.create_renderer = function (self, name, world, create_resource_target, gui, gui_retained, material_name)
	world = world or self._world
	local renderer = nil

	if create_resource_target then
		renderer = UIRenderer.create_resource_renderer(world, gui, gui_retained, name, material_name)
	else
		renderer = UIRenderer.create_viewport_renderer(world)
	end

	self._renderers[name] = {
		renderer = renderer,
		world = world
	}

	return renderer
end

UIManager.load_hud_packages = function (self, element_definitions, complete_callback)
	self:_load_ui_element_packages(element_definitions, "hud", complete_callback)
end

UIManager._load_ui_element_packages = function (self, element_definitions, reference_key, on_loaded_callback)
	local ui_element_packages_data = {
		on_loaded_callback = on_loaded_callback
	}
	local package_references = {}
	local is_loading = false

	for _, definition in ipairs(element_definitions) do
		local class_name = definition.class_name
		local reference_name = reference_key .. "_packages_" .. class_name
		local package = definition.package

		if package then
			package_references[reference_name] = {
				loaded = false,
				package = package
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

UIManager._on_ui_element_package_loaded = function (self, reference_key, reference_name)
	local package_references_data = self._ui_element_package_references[reference_key]
	local package_references = package_references_data.package_references
	local data = package_references[reference_name]
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

			package_manager:release(package_id)
		end
	end

	self._ui_element_package_references[reference_key] = {}
end

UIManager.create_player_hud = function (self, peer_id, local_player_id, elements, visibility_groups)
	visibility_groups = visibility_groups or require("scripts/ui/hud/hud_visibility_groups")
	local enable_world_bloom = not self._spectator_hud
	local params = {
		peer_id = peer_id,
		local_player_id = local_player_id or 1,
		enable_world_bloom = enable_world_bloom
	}
	self._hud = UIHud:new(elements, visibility_groups, params)
end

UIManager.create_spectator_hud = function (self, world_viewport_name, peer_id, local_player_id, elements, visibility_groups)
	visibility_groups = visibility_groups or require("scripts/ui/hud/hud_visibility_groups")
	local enable_world_bloom = not self._hud
	local params = {
		renderer_name = "spectator_hud_ui_renderer",
		peer_id = peer_id,
		local_player_id = local_player_id or 1,
		world_viewport_name = world_viewport_name,
		enable_world_bloom = enable_world_bloom
	}
	self._spectator_hud = UIHud:new(elements, visibility_groups, params)
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

UIManager.input_service = function (self)
	local gamepad_active = false
	local input_service_name = self._input_service_name
	local input_manager = Managers.input
	local input_service = input_manager:get_input_service(input_service_name)
	local null_service = input_service:null_service()
	local imgui = Managers.imgui

	if imgui and imgui:is_active() then
		input_service = null_service
	end

	return input_service, null_service, gamepad_active
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
	local num_views = #views

	if num_views > 0 then
		for i = num_views, 1, -1 do
			local active_view_name = views[i]

			if active_view_name then
				local close_action = self._close_view_input_action
				local settings = Views[active_view_name]
				local hotkey = hotkey_lookup[active_view_name]
				local close_on_hotkey_pressed = settings.close_on_hotkey_pressed
				local allow_to_pass_input = view_handler:allow_to_pass_input_for_view(active_view_name)

				if hotkey and input_service:get(hotkey) and close_on_hotkey_pressed or input_service:get(close_action) and view_handler:allow_close_hotkey_for_view(active_view_name) and view_handler:can_close(active_view_name) then
					self:close_view(active_view_name)

					return
				elseif not allow_to_pass_input then
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

	self._view_handler:open_view(view_name, transition_time, close_previous, close_all, close_transition_time, context, settings_override)

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
			text = "loc_popup_unavailable_view_button_confirm",
			template_type = "terminal_button_small",
			close_on_pressed = true,
			hotkey = "back"
		}
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

UIManager.create_viewport = function (self, world, viewport_name, viewport_type, viewport_layer, shading_environment_name, shading_callback)
	shading_environment_name = shading_environment_name or GameParameters.default_ui_shading_environment
	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, viewport_layer, nil, nil, nil, nil, shading_environment_name, shading_callback)

	return viewport
end

UIManager.create_world = function (self, world_name, optional_layer, optional_timer_name, optional_view_connection_name, optional_flags)
	local layer = optional_layer or 1
	local parameters = {
		layer = layer,
		timer_name = optional_timer_name or self._timer_name
	}

	if not optional_flags then
		local flags = {
			Application.DISABLE_APEX_CLOTH,
			Application.DISABLE_PHYSICS
		}
	end

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

UIManager.using_input = function (self)
	if self._ui_constant_elements and self._ui_constant_elements:using_input() then
		return true
	elseif self._view_handler:using_input() then
		return true
	elseif self._hud then
		return self._hud:using_input()
	end

	return false
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

UIManager.wwise_music_state = function (self, wwise_state_group_name)
	return self._view_handler:wwise_music_state(wwise_state_group_name)
end

UIManager.destroy = function (self)
	Managers.event:unregister(self, "event_show_ui_popup")
	Managers.event:unregister(self, "event_remove_ui_popup")
	Managers.event:unregister(self, "event_player_profile_updated")
	Managers.event:unregister(self, "event_player_appearance_updated")
	Managers.event:unregister(self, "event_on_render_settings_applied")
	self._view_handler:destroy()

	self._view_handler = nil

	self:destroy_spectator_hud()
	self:destroy_player_hud()

	if self._ui_constant_elements then
		self._ui_constant_elements:destroy()

		self._ui_constant_elements = nil
	end

	self:_unload_ui_element_packages("constant_elements")

	if self._ui_loading_icon_renderer then
		self:destroy_renderer("ui_loading_icon_renderer")

		self._ui_loading_icon_renderer = nil
	end

	if self._back_buffer_render_handlers then
		for _, back_buffer_renderer in pairs(self._back_buffer_render_handlers) do
			back_buffer_renderer:destroy()
		end

		self._back_buffer_render_handlers = nil
	end

	local world = self._world
	local viewport_name = self._viewport_name

	ScriptWorld.destroy_viewport(world, viewport_name)
	self:destroy_world(world)

	self._viewport_name = nil
	self._world = nil

	if self._single_icon_renderers_destruction_frame_counter then
		self._single_icon_renderers_destruction_frame_counter = 0

		self:_handle_single_icon_renderer_destruction()
	end

	Managers.time:unregister_timer(self._timer_name)

	self._timer_name = nil
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
	self:_handle_single_icon_renderer_destruction()

	if self._update_hotkeys then
		self:_update_view_hotkeys()

		self._update_hotkeys = nil
	end

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
		local input_service = spectator_hud and self:input_service():null_service() or self:input_service()

		hud:draw(dt, t, input_service)
	end

	if spectator_hud then
		spectator_hud:draw(dt, t, self:input_service())
	end
end

UIManager.post_update = function (self, dt, t)
	local hud = self._hud
	local spectator_hud = self._spectator_hud

	if hud then
		local input_service = spectator_hud and self:input_service():null_service() or self:input_service()

		hud:update(dt, t, input_service)
	end

	if spectator_hud then
		spectator_hud:update(dt, t, self:input_service())
	end

	self._view_handler:post_update(dt, t)

	local visible_widgets = self._visible_widgets
	local prev_visible_widgets = self._prev_visible_widgets

	for widget, ui_renderer in pairs(prev_visible_widgets) do
		if not visible_widgets[widget] then
			UIWidget.destroy_retained(widget, ui_renderer)
		end
	end

	self._prev_visible_widgets = visible_widgets
	self._visible_widgets = prev_visible_widgets

	table.clear(prev_visible_widgets)
end

UIManager.frame_capture = function (self)
	GuiDebug.start_frame_caputure = true
end

local temp_text_options = {}

UIManager._debug_draw_version_info = function (self, dt, t)
	local ui_renderer = self._ui_debug_renderer

	if not ui_renderer then
		return
	end

	local gui = ui_renderer.gui
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	ui_renderer.scale = scale
	ui_renderer.inverse_scale = inverse_scale
	local font_size = 24
	local font_type = "arial"
	local font_height, font_min_y, font_max_y = UIFonts.font_height(gui, font_type, font_size)
	local box_size = {
		1000,
		math.abs(font_max_y)
	}
	local text_color_table = {
		255,
		255,
		255,
		255
	}
	local text_options = {
		shadow = true,
		horizontal_alignment = Gui.HorizontalAlignRight,
		vertical_alignment = Gui.VerticalAlignBottom
	}
	local draw_layer = 999
	font_size = math.floor(16 * scale)
	local camera_position_string, camera_rotation_string, player_1p_position_string, player_3p_position_string = nil
	local camera_manager = Managers.state.camera
	local free_flight_manager = Managers.free_flight
	local player = nil

	if Managers.connection:is_initialized() then
		local peer_id = Network.peer_id()
		local local_player_id = 1
		player = Managers.player:player(peer_id, local_player_id)
	end

	local camera_pos, camera_rot = nil

	if free_flight_manager and free_flight_manager:is_in_free_flight() then
		camera_pos, camera_rot = free_flight_manager:camera_position_rotation("global")
	elseif camera_manager and player then
		local viewport_name = player.viewport_name
		local camera = camera_manager:has_camera(viewport_name)

		if camera then
			camera_pos = camera_manager:camera_position(viewport_name)
			camera_rot = camera_manager:camera_rotation(viewport_name)
		end
	end

	if camera_pos and camera_rot then
		camera_position_string = string.format("Camera Position(%.2f, %.2f, %.2f)", camera_pos.x, camera_pos.y, camera_pos.z)
		camera_rotation_string = string.format("Camera Rotation(%.4f, %.4f, %.4f, %.4f)", Quaternion.to_elements(camera_rot))
	end

	if player and player:unit_is_alive() then
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local first_person_read_component = unit_data_extension:read_component("first_person")
			local player_1p_position = first_person_read_component.position
			player_1p_position_string = string.format("Player 1p Position(%.2f, %.2f, %.2f)", player_1p_position.x, player_1p_position.y, player_1p_position.z)
			local locomotion_read_component = unit_data_extension:read_component("locomotion")
			local player_position = locomotion_read_component.position
			player_3p_position_string = string.format("Player 3p Position(%.2f, %.2f, %.2f)", player_position.x, player_position.y, player_position.z)
		end
	end

	local mission_name = "n/a"
	local side_mission_name = "n/a"
	local level_name = "n/a"
	local game_mode_name = "n/a"
	local main_objective_type = "n/a"
	local mission_manager = Managers.state.mission
	local mission = mission_manager and mission_manager:mission()
	local chunk_name_string = nil

	if Managers.state and Managers.state.chunk_lod then
		local chunk_name = Managers.state.chunk_lod:current_chunk_name() or "n/a"
		chunk_name_string = string.format("Chunk: %s", chunk_name)
	end

	if mission and mission.name then
		local side_mission = mission_manager:side_mission()

		if side_mission and side_mission.name then
			side_mission_name = side_mission.name
		end

		if mission and mission.objectives then
			main_objective_type = MissionObjectiveTemplates[mission.objectives].main_objective_type
		end

		mission_name = mission.name
		level_name = mission.level
		game_mode_name = mission.game_mode_name
	end

	local num_hub_players = nil
	local connection_manager = Managers.connection
	local host_type = connection_manager:host_type()

	if host_type and host_type == "hub_server" then
		local members = connection_manager:num_members()
		local max_members = GameParameters.max_players_hub
		num_hub_players = string.format("Hub Players: %d/%d", members, max_members)
	end

	local _unique_instance_id = Managers.connection:unique_instance_id()
	local unique_instance_id_with_prefix = nil

	if _unique_instance_id then
		unique_instance_id_with_prefix = string.format("Instance Id: %s", _unique_instance_id)
	end

	local _region = Managers.connection:region()
	local region_with_prefix = nil

	if _region then
		region_with_prefix = string.format("Region: %s", _region)
	end

	local _deployment_id = Managers.connection:deployment_id()
	local deployment_id_with_prefix = nil

	if _deployment_id then
		deployment_id_with_prefix = string.format("Deployment Id: %s", _deployment_id)
	end

	local mechanism_name = Managers.mechanism:mechanism_name()

	if mechanism_name then
		mechanism_name = string.format("Mechanism: %s", mechanism_name)
		local mechanism_state = Managers.mechanism:mechanism_state()

		if mechanism_state then
			mechanism_name = string.format("%s [%s]", mechanism_name, mechanism_state)
		end
	end

	local network_info = "Network: " .. connection_manager.platform

	if Managers.multiplayer_session:aws_matchmaking() then
		network_info = network_info .. "|AWS"
	end

	if host_type then
		network_info = network_info .. "|" .. host_type
	end

	if Managers.connection:accelerated_endpoint() then
		network_info = network_info .. "|accelerated"
	end

	local progression_info = nil

	if player then
		local profile = player:profile()
		local current_level = profile and profile.current_level or "n/a"
		progression_info = string.format("Level: %s", current_level)
	end

	local presence = Managers.presence:presence()
	local num_mission_members = "n/a"

	if GameParameters.prod_like_backend then
		local myself = Managers.presence:presence_entry_myself()
		num_mission_members = myself:num_mission_members()
	end

	local presence_info = string.format("Presence: %s, num_mission_members: %s", presence, num_mission_members)
	local difficulty_info = nil
	local difficulty_manager = Managers.state.difficulty

	if difficulty_manager then
		local challenge = difficulty_manager:get_challenge()
		local resistance = difficulty_manager:get_resistance()
		difficulty_info = string.format("Difficulty: %s-%s", challenge, resistance)
	end

	local circumstance_info = nil
	local circumstance_manager = Managers.state.circumstance

	if circumstance_manager then
		local name = circumstance_manager:circumstance_name() or "n/a"
		circumstance_info = string.format("Circumstance: %s", name)
	end

	local selected_unit_info = nil

	if Debug:exists() then
		local selected_unit = Debug.selected_unit and tostring(Debug.selected_unit) or "n/a"
		selected_unit_info = string.format("Selected Unit: %s", selected_unit)
	end

	local vo_story_stage_info = nil

	if player and player:unit_is_alive() then
		local player_unit = player.player_unit
		local dialogue_extension = ScriptUnit.has_extension(player_unit, "dialogue_system")

		if dialogue_extension then
			local context = dialogue_extension:get_context()
			local vo_story_stage = context.story_stage
			vo_story_stage_info = string.format("VO Story Stage: %s", vo_story_stage)
		end
	end

	local cinematic_active = Managers.state and Managers.state.cinematic and Managers.state.cinematic:active() and "active" or "inactive"
	local cutscene_view_active = Managers.ui and Managers.ui:view_active("cutscene_view") and "active" or "inactive"
	local cinematic_loading = Managers.state and Managers.state.cinematic and Managers.state.cinematic:is_loading_cinematic_levels() and "active" or "inactive"
	local text_order = {
		"show_build_info",
		"show_backend_url",
		"show_master_data_version",
		"show_engine_revision_info",
		"show_content_revision_info",
		"show_team_city_build_info",
		"show_backend_account_info",
		"show_lan_port_info",
		"show_network_hash_info",
		"show_screen_resolution_info",
		"show_mission_name",
		"show_level_name",
		"show_game_mode_name",
		"show_main_objective_type",
		"show_mechanism_name",
		"show_chunk_name",
		"show_camera_position_info",
		"show_camera_rotation_info",
		"show_player_1p_position_info",
		"show_player_3p_position_info",
		"show_num_hub_players",
		"show_unique_instance_id",
		"show_region",
		"show_deployment_id",
		"show_network_info",
		"show_progression_info",
		"show_presence_info",
		"show_difficulty",
		"show_circumstances",
		"show_selected_unit_info",
		"show_vo_story_stage_info",
		"show_cinematic_active"
	}
	local texts = {
		show_build_info = "Build: " .. (BUILD or "n/a"),
		show_backend_url = "Backend: " .. (Backend.get_title_url and Backend.get_title_url() or "n/a"):gsub(".fatsharkgames.se", ""):gsub("https://bsp.td.", ""),
		show_master_data_version = "Master data: " .. (MasterItems.get_cached_version() and MasterItems.get_cached_version() or "<not ready>"),
		show_engine_revision_info = "Engine Revision: " .. (BUILD_IDENTIFIER or "n/a"),
		show_content_revision_info = "Content Revision: " .. (APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION),
		show_team_city_build_info = "Teamcity Build ID: " .. (APPLICATION_SETTINGS.teamcity_build_id or "n/a"),
		show_backend_account_info = string.format("Authenticated: %s", Managers.backend:authenticated()),
		show_lan_port_info = "LAN port: " .. (GameParameters.lan_port or "n/a"),
		show_network_hash_info = "Network Hash: " .. (DevParameters.network_hash or "n/a"),
		show_screen_resolution_info = string.format("Resolution W:%i H:%i", w, h),
		show_mission_name = string.format("Mission: %s / %s", mission_name, side_mission_name),
		show_level_name = string.format("Level: %s", level_name),
		show_chunk_name = chunk_name_string,
		show_game_mode_name = string.format("Game Mode: %s", game_mode_name),
		show_main_objective_type = string.format("Main Objective: %s", main_objective_type),
		show_mechanism_name = mechanism_name,
		show_camera_position_info = camera_position_string,
		show_camera_rotation_info = camera_rotation_string,
		show_player_1p_position_info = player_1p_position_string,
		show_player_3p_position_info = player_3p_position_string,
		show_num_hub_players = num_hub_players,
		show_unique_instance_id = unique_instance_id_with_prefix,
		show_region = region_with_prefix,
		show_deployment_id = deployment_id_with_prefix,
		show_network_info = network_info,
		show_progression_info = progression_info,
		show_presence_info = presence_info,
		show_difficulty = difficulty_info,
		show_circumstances = circumstance_info,
		show_selected_unit_info = selected_unit_info,
		show_vo_story_stage_info = vo_story_stage_info,
		show_cinematic_active = "Cinematic: " .. cinematic_active .. " | Cutscene View: " .. cutscene_view_active .. " | Loading: " .. cinematic_loading
	}
	local position = Vector3(w * inverse_scale - box_size[1] - 10, h * inverse_scale - box_size[2] - 300, draw_layer)

	for i = #text_order, 1, -1 do
		local text_dev_flag = text_order[i]

		if DevParameters[text_dev_flag] then
			local text = texts[text_dev_flag]

			if text then
				UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, box_size, text_color_table, text_options)

				position[2] = position[2] - box_size[2]
			end
		end
	end

	ui_renderer.scale = nil
	ui_renderer.inverse_scale = nil
end

UIManager._debug_draw_feature_info = function (self, dt, t)
	local ui_renderer = self._ui_debug_renderer

	if not ui_renderer then
		return
	end

	local gui = ui_renderer.gui
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	local draw_layer = 999
	ui_renderer.scale = scale
	ui_renderer.inverse_scale = inverse_scale
	local feature_font_size = 18
	local feature_font_type = "arial"
	feature_font_size = math.floor(16 * scale)

	UIFonts.data_by_type(feature_font_type)

	local feature_font_height, feature_font_min_y, feature_font_max_y = UIFonts.font_height(gui, feature_font_type, feature_font_size)
	local feature_box_size = {
		1000,
		math.abs(feature_font_max_y)
	}
	local feature_text_options = {
		shadow = true,
		horizontal_alignment = Gui.HorizontalAlignLeft,
		vertical_alignment = Gui.VerticalAlignBottom
	}
	local features = {
		{
			"clustered",
			Application.render_config("settings", "clustered_shading_enabled", false)
		},
		{
			"conservative",
			Application.render_config("render_caps", "conservative_raster", false)
		},
		{
			"cluster_v2",
			Application.render_config("settings", "cluster_v2", false)
		},
		{
			"dxr",
			Application.render_config("render_caps", "dxr", false) and Application.render_config("settings", "dxr", false)
		},
		{
			"reflections",
			Application.render_config("settings", "rt_reflections_enabled", false)
		},
		{
			"rtxgi",
			Application.render_config("settings", "rtxgi_enabled", false)
		},
		{
			"dlss",
			Application.render_config("render_caps", "dlss_supported", false) and Application.render_config("settings", "upscaling_enabled", false) and Application.render_config("settings", "upscaling_mode", false) == "dlss"
		},
		{
			"fsr2",
			Application.render_config("settings", "upscaling_enabled", false) and Application.render_config("settings", "upscaling_mode", false) == "fsr2"
		},
		{
			"d3d_debug",
			Renderer.settings("d3d_debug")
		},
		{
			"gpu_validation",
			Renderer.settings("d3d_gpu_validation")
		},
		{
			"gpu_crashdump",
			Renderer.settings("gpu_crash_dumps")
		}
	}
	local feature_active_color = {
		180,
		0,
		255,
		0
	}
	local feature_notactive_color = {
		128,
		0,
		128,
		0
	}
	local feature_pos = Vector3(10, h * inverse_scale - feature_box_size[2], draw_layer)
	local space_width = UIRenderer.text_size(ui_renderer, " ", feature_font_type, feature_font_size)

	for i = 1, #features do
		local tuple = features[i]
		local text = tuple[1]
		local val = tuple[2]

		UIRenderer.draw_text(ui_renderer, text, feature_font_size, feature_font_type, feature_pos, feature_box_size, val and feature_active_color or feature_notactive_color, feature_text_options)

		local text_width, text_height, plupp, caret = UIRenderer.text_size(ui_renderer, text, feature_font_type, feature_font_size)
		feature_pos[1] = feature_pos[1] + text_width * inverse_scale + 10 * inverse_scale
	end

	ui_renderer.scale = nil
	ui_renderer.inverse_scale = nil
end

UIManager.load_view = function (self, view_name, reference_name, loaded_callback)
	local settings = Views[view_name]
	local package_name = settings.package
	local levels = settings.levels
	local packages_to_load_data = {}

	if package_name then
		local package_reference_name = reference_name .. #packages_to_load_data
		packages_to_load_data[#packages_to_load_data + 1] = {
			package_name = package_name,
			reference_name = package_reference_name
		}
	end

	if levels then
		for i = 1, #levels do
			local level_name = levels[i]
			local package_reference_name = reference_name .. #packages_to_load_data
			packages_to_load_data[#packages_to_load_data + 1] = {
				is_level_package = true,
				package_name = level_name,
				reference_name = package_reference_name
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
			reference_name = reference_name
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
						reference_name = package_reference_name
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

	self._views_loading_data[view_name][reference_name] = nil
end

UIManager._unload_package = function (self, package_id, frame_delay_count)
	if frame_delay_count then
		self._package_unload_list[#self._package_unload_list + 1] = {
			package_id = package_id,
			frame_delay = frame_delay_count
		}
		self._handle_package_unload_delay = true
	else
		Managers.package:release(package_id)
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

			Managers.package:release(package_id)
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

	LoadingIcon.render(gui)
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
	local popup = {
		name = name,
		type = popup_type,
		data = data,
		id = popup_id,
		priority_order = priority_order
	}
	local active_popups = self._active_popups
	local num_active_popups = #active_popups
	local start_index = nil

	if num_active_popups > 0 then
		for i = 1, num_active_popups do
			if active_popups[i].priority_order < priority_order then
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
end

UIManager.event_remove_ui_popup = function (self, popup_id)
	local remove = true

	self:_popup_by_id(popup_id, remove)
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

UIManager.load_profile_portrait = function (self, profile, cb, render_context)
	local instance = self._back_buffer_render_handlers.portraits

	return instance:load_profile_portrait(profile, cb, render_context)
end

UIManager.unload_profile_portrait = function (self, id)
	local instance = self._back_buffer_render_handlers.portraits

	instance:unload_profile_portrait(id)
end

UIManager.event_player_profile_updated = function (self, peer_id, local_player_id, profile)
	local instance = self._back_buffer_render_handlers.portraits

	instance:profile_updated(profile)
end

UIManager.load_appearance_portrait = function (self, profile, cb, render_context, prioritized)
	local instance = self._back_buffer_render_handlers.appearance

	return instance:load_profile_portrait(profile, cb, render_context, prioritized)
end

UIManager.unload_appearance_portrait = function (self, id)
	local instance = self._back_buffer_render_handlers.appearance

	instance:unload_profile_portrait(id)
end

UIManager.update_player_appearance = function (self, profile, prioritized)
	local instance = self._back_buffer_render_handlers.appearance

	instance:profile_updated(profile, prioritized)
end

UIManager.event_player_appearance_updated = function (self, profile)
	local instance = self._back_buffer_render_handlers.appearance

	instance:profile_updated(profile)
end

UIManager.load_item_icon = function (self, real_item, cb, render_context, dummy_profile)
	local item_name = real_item.name
	local gear_id = real_item.gear_id or item_name
	local item = nil

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

		return instance:load_weapon_icon(item, cb, render_context)
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = ItemUtils.weapon_skin_preview_item(item)
		local instance = self._back_buffer_render_handlers.weapons

		return instance:load_weapon_icon(visual_item, cb, render_context)
	elseif item_type == "WEAPON_TRINKET" then
		local instance = self._back_buffer_render_handlers.weapons
		local visual_item = ItemUtils.weapon_trinket_preview_item(item)

		return instance:load_weapon_icon(visual_item, cb, render_context)
	elseif table.find(slots, "slot_gear_head") or table.find(slots, "slot_gear_upperbody") or table.find(slots, "slot_gear_lowerbody") or table.find(slots, "slot_gear_extra_cosmetic") or table.find(slots, "slot_animation_end_of_round") then
		local instance = self._back_buffer_render_handlers.cosmetics
		local dummy_profile = dummy_profile

		if not dummy_profile then
			local player = Managers.player:local_player(1)
			local profile = player:profile()
			local item_gender, item_breed, item_archetype = nil

			if item.genders and not table.is_empty(item.genders) then
				for i = 1, #item.genders do
					local gender = item.genders[i]

					if gender == profile.gender then
						item_gender = profile.gender

						break
					end
				end
			else
				item_gender = profile.gender
			end

			if item.breeds and not table.is_empty(item.breeds) then
				for i = 1, #item.breeds do
					local breed = item.breeds[i]

					if breed == profile.breed then
						item_breed = profile.breed

						break
					end
				end
			else
				item_breed = profile.breed
			end

			if item.archetypes and not table.is_empty(item.archetypes) then
				for i = 1, #item.archetypes do
					local archetype = item.archetypes[i]

					if archetype == profile.archetype.name then
						item_archetype = profile.archetype

						break
					end
				end
			else
				item_archetype = profile.archetype
			end

			local compatible_profile = item_gender and item_breed and item_archetype

			if compatible_profile then
				dummy_profile = table.clone_instance(profile)
			else
				local breed = item_breed or item.breeds and item.breeds[1] or "human"
				local archetype = item_archetype or item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or breed == "ogryn" and Archetypes.ogryn or Archetypes.veteran
				local gender = breed ~= "ogryn" and (item_gender or item.genders and item.genders[1]) or "male"
				dummy_profile = {
					loadout = {},
					archetype = archetype,
					breed = breed,
					gender = gender
				}
			end
		end

		local gender_name = dummy_profile.gender
		local archetype = dummy_profile.archetype
		local breed_name = archetype.breed
		local first_slot_name = slots[1]
		local loadout = dummy_profile.loadout
		local required_slots_to_keep = UISettings.item_preview_required_slots_per_slot[first_slot_name]

		if required_slots_to_keep then
			for slot_name, slot_item in pairs(loadout) do
				if not table.contains(required_slots_to_keep, slot_name) then
					loadout[slot_name] = nil
				end
			end
		end

		for i = 1, #slots do
			local slot_name = slots[i]
			loadout[slot_name] = item
		end

		local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name]
		local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

		if required_gender_item_names_per_slot then
			local required_items = required_gender_item_names_per_slot[first_slot_name]

			if required_items then
				for slot_name, slot_item_name in pairs(required_items) do
					local item_definition = MasterItems.get_item(slot_item_name)

					if item_definition then
						local slot_item = table.clone(item_definition)
						dummy_profile.loadout[slot_name] = slot_item
					end
				end
			end
		end

		local slots_to_hide = UISettings.item_preview_hide_slots_per_slot[first_slot_name]

		if slots_to_hide then
			local hide_slots = table.clone(item.hide_slots or {})
			item.hide_slots = hide_slots

			for i = 1, #slots_to_hide do
				hide_slots[#hide_slots + 1] = slots_to_hide[i]
			end
		end

		dummy_profile.character_id = string.format("%s_%s_%s", gear_id, dummy_profile.breed, dummy_profile.gender)
		local prop_item_key = item.prop_item
		local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

		if prop_item then
			local prop_item_slot = prop_item.slots[1]
			dummy_profile.loadout[prop_item_slot] = prop_item
			render_context.wield_slot = prop_item_slot
		end

		return instance:load_profile_portrait(dummy_profile, cb, render_context)
	elseif table.find(slots, "slot_insignia") or table.find(slots, "slot_portrait_frame") or table.find(slots, "slot_animation_emote_1") or table.find(slots, "slot_animation_emote_2") or table.find(slots, "slot_animation_emote_3") or table.find(slots, "slot_animation_emote_4") or table.find(slots, "slot_animation_emote_5") then
		local instance = self._back_buffer_render_handlers.icon

		return instance:load_icon(item, cb, render_context, dummy_profile)
	elseif item_type == "SET" then
		local instance = self._back_buffer_render_handlers.cosmetics
		local dummy_profile = dummy_profile

		if not dummy_profile then
			local player = Managers.player:local_player(1)
			local profile = player:profile()
			dummy_profile = table.clone_instance(profile)
		end

		local gender_name = dummy_profile.gender
		local archetype = dummy_profile.archetype
		local breed_name = archetype.breed
		local loadout = dummy_profile.loadout
		local items = {}

		for _, set_item_data in pairs(item.set_items) do
			items[#items + 1] = MasterItems.get_item(set_item_data.item)
		end

		local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed_name]
		local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

		if required_gender_item_names_per_slot then
			local required_items = required_gender_item_names_per_slot

			if required_items then
				for slot_name, slot_item_name in pairs(required_items) do
					local item_definition = MasterItems.get_item(slot_item_name)

					if item_definition then
						local slot_item = table.clone(item_definition)
						dummy_profile.loadout[slot_name] = slot_item
					end
				end
			end
		end

		for i = 1, #items do
			local item = items[i]
			local first_slot_name = item.slots[1]
			loadout[first_slot_name] = item
			local prop_item_key = item.prop_item
			local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

			if prop_item then
				local prop_item_slot = prop_item.slots[1]
				dummy_profile.loadout[prop_item_slot] = prop_item
				render_context.wield_slot = prop_item_slot
			end
		end

		dummy_profile.character_id = string.format("%s_%s_%s", gear_id, dummy_profile.breed, dummy_profile.gender)

		return instance:load_profile_portrait(dummy_profile, cb, render_context)
	end
end

UIManager.unload_item_icon = function (self, id)
	local weapons_instance = self._back_buffer_render_handlers.weapons
	local cosmetics_instance = self._back_buffer_render_handlers.cosmetics
	local icon_instance = self._back_buffer_render_handlers.icon

	if weapons_instance:has_request(id) then
		weapons_instance:unload_weapon_icon(id)
	elseif icon_instance:has_request(id) then
		icon_instance:unload_icon(id)
	elseif cosmetics_instance:has_request(id) then
		cosmetics_instance:unload_profile_portrait(id)
	end
end

UIManager.item_icon_updated = function (self, item)
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" or item_type == "WEAPON_TRINKET" or item_type == "WEAPON_SKIN" then
		local instance = self._back_buffer_render_handlers.weapons

		instance:weapon_icon_updated(item)
	else
		local player = Managers.player:local_player(1)
		local profile = player:profile()
		local instance = self._back_buffer_render_handlers.cosmetics

		instance:profile_updated(profile)
	end
end

UIManager.event_on_render_settings_applied = function (self)
	for _, instance in pairs(self._back_buffer_render_handlers) do
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

UIManager.get_hud = function (self)
	return self._hud
end

return UIManager
