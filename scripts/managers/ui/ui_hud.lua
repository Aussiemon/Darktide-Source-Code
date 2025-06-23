-- chunkname: @scripts/managers/ui/ui_hud.lua

require("scripts/ui/hud/elements/hud_element_base")

local Hud = require("scripts/utilities/ui/hud")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local WorldRenderUtils = require("scripts/utilities/world_render")
local resolution_modified_key = "modified"

local function sort_elements_by_hud_scale(a, b)
	return b.use_hud_scale and not a.use_hud_scale
end

local UIHud = class("UIHud")

UIHud.init = function (self, elements, visibility_groups, params)
	self._params = params
	self._currently_visible_elements = {}
	self._visibility_groups = visibility_groups
	self._world_name = "level_world"
	self._player_viewport_name = "player1"

	local world = Managers.world:world(self._world_name)

	if params.enable_world_bloom then
		WorldRenderUtils.enable_world_ui_bloom(self._world_name, self._player_viewport_name, UIHudSettings.offset_falloffs, UIHudSettings.ui_bloom_tints)
	end

	local uniq_id = tostring(self)

	self._unique_id = self.__class_name .. "_" .. uniq_id:gsub("[%p%c%s]", "") .. "_"
	self._render_settings = {
		force_retained_mode = false
	}
	self._ui_renderer_name = self._unique_id .. (params.renderer_name or self.__class_name .. "_ui_renderer")
	self._ui_renderer = Managers.ui:create_renderer(self._ui_renderer_name, world)
	self._elements = {}
	self._elements_array = {}
	self._elements_hud_scale_lookup = {}
	self._elements_hud_retained_mode_lookup = {}

	local peer_id = params.peer_id
	local local_player_id = params.local_player_id or 1
	local player = Managers.player:player(peer_id, local_player_id)

	self._player = player
	self._world_viewport_name = params.world_viewport_name or player.viewport_name
	self._element_definitions = table.clone(elements)

	table.sort(self._element_definitions, sort_elements_by_hud_scale)
	self:_verify_elements(self._element_definitions)
	self:_setup_elements(self._element_definitions)
	Managers.event:register(self, "event_set_emote_wheel_state", "event_set_emote_wheel_state")
	Managers.event:register(self, "event_set_tactical_overlay_state", "event_set_tactical_overlay_state")
	Managers.event:register(self, "event_set_communication_wheel_state", "event_set_communication_wheel_state")
	Managers.event:register(self, "event_update_hud_scale", "event_update_hud_scale")

	self._refresh_retained = true

	Managers.event:trigger("event_on_hud_created")
end

UIHud.get_player_extension = function (self, player, extension_name)
	if player:unit_is_alive() then
		local player_unit = player.player_unit

		return ScriptUnit.has_extension(player_unit, extension_name)
	end
end

UIHud.get_all_player_extensions = function (self, player, output)
	if player:unit_is_alive() then
		local player_unit = player.player_unit

		output.health = ScriptUnit.has_extension(player_unit, "health_system")
		output.toughness = ScriptUnit.has_extension(player_unit, "toughness_system")
		output.interactor = ScriptUnit.has_extension(player_unit, "interactor_system")
		output.unit_data = ScriptUnit.has_extension(player_unit, "unit_data_system")
		output.ability = ScriptUnit.has_extension(player_unit, "ability_system")
		output.visual_loadout = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
		output.buff = ScriptUnit.has_extension(player_unit, "buff_system")
		output.dialogue = ScriptUnit.has_extension(player_unit, "dialogue_system")
		output.weapon = ScriptUnit.has_extension(player_unit, "weapon_system")
		output.coherency = ScriptUnit.has_extension(player_unit, "coherency_system")
		output.first_person = ScriptUnit.has_extension(player_unit, "first_person_system")
		output.unit = player_unit

		return output
	end
end

UIHud.using_input = function (self)
	return self._using_cursor or self._element_using_input
end

UIHud.player = function (self)
	return self._player
end

UIHud.player_unit = function (self)
	local player = self._player

	if player and player:unit_is_alive() then
		local player_unit = player.player_unit

		return player_unit
	end

	return nil
end

UIHud.player_camera = function (self)
	if not self._camera then
		local camera_manager = Managers.state.camera
		local camera = camera_manager:camera(self._world_viewport_name)

		self._camera = camera
	end

	return self._camera
end

UIHud.player_extensions = function (self)
	return self._extensions
end

UIHud._peer_id = function (self)
	local params = self._params

	return params.peer_id
end

UIHud._verify_elements = function (self, element_definitions)
	local visibility_groups_lookup = {}

	for _, settings in ipairs(self._visibility_groups) do
		local name = settings.name

		visibility_groups_lookup[name] = settings
	end

	for _, definition in ipairs(element_definitions) do
		local class_name = definition.class_name
		local visibility_groups = definition.visibility_groups

		for _, group_name in ipairs(visibility_groups) do
			local visibility_group = visibility_groups_lookup[group_name]
			local validation_function = visibility_group.validation_function

			if not visibility_group.visible_elements then
				visibility_group.visible_elements = {}
			end

			local visible_elements = visibility_group.visible_elements

			visible_elements[class_name] = true
		end
	end
end

UIHud._setup_elements = function (self, element_definitions)
	for _, definition in ipairs(element_definitions) do
		self:_setup_element(definition)
	end
end

UIHud._unload_element_packages = function (self, element_definitions)
	local package_manager = Managers.package

	for _, definition in ipairs(element_definitions) do
		local class_name = definition.class_name
		local package = definition.package

		if package then
			local reference_name = "UIHud_" .. class_name

			package_manager:unload(package, reference_name)
		end
	end
end

UIHud._setup_element = function (self, definition)
	local elements = self._elements
	local elements_array = self._elements_array
	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local elements_hud_retained_mode_lookup = self._elements_hud_retained_mode_lookup
	local class_name = definition.class_name

	if definition.use_hud_scale then
		elements_hud_scale_lookup[class_name] = true
	end

	if definition.use_retained_mode then
		elements_hud_retained_mode_lookup[class_name] = true
	end

	self:_add_element(definition, elements, elements_array)

	self._current_group_name = nil
end

UIHud._add_element = function (self, definition, elements, elements_array)
	local class_name = definition.class_name
	local params = self._params
	local validation_function = definition.validation_function

	if not validation_function or validation_function(params) then
		local filename = definition.filename
		local use_hud_scale = definition.use_hud_scale
		local class = require(filename)
		local optional_context = definition.context
		local draw_layer = UIHudSettings.element_draw_layers[class_name] or 0
		local hud_scale = use_hud_scale and Hud.hud_scale() or RESOLUTION_LOOKUP.scale
		local element = class:new(self, draw_layer, hud_scale, optional_context)

		elements[class_name] = element

		local id = #elements_array + 1

		elements_array[id] = element
	end
end

UIHud.element = function (self, element_name)
	local elements = self._elements
	local element = elements[element_name]

	return element
end

UIHud._update_element_visibility = function (self)
	local ui_renderer = self._ui_renderer
	local visibility_groups = self._visibility_groups
	local num_visibility_groups = #visibility_groups
	local elements_hud_retained_mode_lookup = self._elements_hud_retained_mode_lookup

	for i = 1, num_visibility_groups do
		local visibility_group = visibility_groups[i]
		local group_name = visibility_group.name
		local validation_function = visibility_group.validation_function
		local is_valid = not validation_function or validation_function(self)

		if is_valid then
			if group_name ~= self._current_group_name then
				local elements_array = self._elements_array
				local currently_visible_elements = self._currently_visible_elements
				local visible_elements = visibility_group.visible_elements

				for j = 1, #elements_array do
					local element = elements_array[j]
					local element_name = element.__class_name
					local status = visible_elements and visible_elements[element_name] or false
					local use_retained_mode = elements_hud_retained_mode_lookup[element_name]

					if element.set_visible then
						element:set_visible(status, ui_renderer, use_retained_mode)
					end

					currently_visible_elements[element_name] = status
				end

				self._current_group_name = group_name
			end

			break
		end
	end
end

UIHud._apply_hud_scale = function (self)
	local new_scale = Hud.hud_scale()
	local render_settings = self._render_settings

	render_settings.scale = new_scale
	render_settings.inverse_scale = 1 / new_scale
	render_settings.using_hud_scale = true
end

UIHud._abort_hud_scale = function (self)
	local render_settings = self._render_settings
	local scale = RESOLUTION_LOOKUP.scale

	render_settings.scale = scale
	render_settings.inverse_scale = 1 / scale
	render_settings.using_hud_scale = nil
end

UIHud.ui_renderer = function (self)
	return self._ui_renderer
end

UIHud.update = function (self, dt, t, input_service)
	local ui_renderer = self._ui_renderer
	local player_unit = self:player_unit()

	if player_unit then
		if not self._extensions then
			self._extensions = self:get_all_player_extensions(self._player, {})
		end
	elseif self._extensions then
		self._extensions = nil
	end

	self:_update_element_visibility()

	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local currently_visible_elements = self._currently_visible_elements
	local elements_array = self._elements_array
	local hud_scale_applied = false
	local render_settings = self._render_settings
	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key] or self._hud_scale_modified

	self._hud_scale_modified = nil
	self._refresh_retained = resolution_modified or self._refresh_retained

	if resolution_modified then
		local scale = RESOLUTION_LOOKUP.scale

		render_settings.scale = scale
		render_settings.inverse_scale = 1 / scale
		render_settings.using_hud_scale = nil
	end

	self._element_using_input = false

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name

		if elements_hud_scale_lookup[element_name] then
			hud_scale_applied = true

			self:_apply_hud_scale()
		end

		if resolution_modified and element.on_resolution_modified then
			element:on_resolution_modified()
		end

		if currently_visible_elements[element_name] and element.update then
			if element.begin_update then
				element:begin_update(dt, t, ui_renderer, render_settings, input_service)
			end

			element:update(dt, t, ui_renderer, render_settings, input_service)

			if element.end_update then
				element:end_update(dt, t, ui_renderer, render_settings, input_service)
			end
		end

		local element_using_input = element.using_input and element:using_input()

		if element_using_input then
			self._element_using_input = true
		end

		if hud_scale_applied then
			self:_abort_hud_scale()
		end
	end
end

UIHud.draw = function (self, dt, t, input_service)
	local is_world_enabled = Managers.world:is_world_enabled(self._world_name)

	if not is_world_enabled then
		return
	end

	local ui_renderer = self._ui_renderer
	local default_ui_renderer = ui_renderer
	local render_settings = self._render_settings
	local saved_start_layer = render_settings.start_layer
	local alpha_multiplier = render_settings.alpha_multiplier
	local currently_visible_elements = self._currently_visible_elements
	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local elements_array = self._elements_array
	local elements_hud_retained_mode_lookup = self._elements_hud_retained_mode_lookup
	local hud_scale_applied = false

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name

		if currently_visible_elements[element_name] and element.draw then
			if elements_hud_scale_lookup[element_name] then
				hud_scale_applied = true

				self:_apply_hud_scale()
			end

			if ui_renderer then
				local use_retained_mode = elements_hud_retained_mode_lookup[element_name]

				render_settings.force_retained_mode = use_retained_mode

				element:draw(dt, t, ui_renderer, render_settings, input_service)
			end

			render_settings.alpha_multiplier = alpha_multiplier

			if hud_scale_applied then
				self:_abort_hud_scale()
			end
		end
	end

	render_settings.start_layer = saved_start_layer
end

UIHud.destroy = function (self, disable_world_bloom)
	if disable_world_bloom then
		WorldRenderUtils.disable_world_ui_bloom(self._world_name, self._player_viewport_name)
	end

	Managers.event:unregister(self, "event_set_emote_wheel_state")
	Managers.event:unregister(self, "event_set_tactical_overlay_state")
	Managers.event:unregister(self, "event_set_communication_wheel_state")
	Managers.event:unregister(self, "event_update_hud_scale")

	local elements_array = self._elements_array

	for _, element in ipairs(elements_array) do
		if element.destroy then
			element:destroy(self._ui_renderer)
		end
	end

	self._elements = nil
	self._elements_array = nil
	self._ui_renderer = nil

	Managers.ui:destroy_renderer(self._ui_renderer_name)

	self._element_definitions = nil

	if self._using_cursor then
		self:_deactivate_mouse_cursor()
	end
end

UIHud._activate_mouse_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name

	input_manager:push_cursor(name)

	self._using_cursor = true
end

UIHud._deactivate_mouse_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name

	input_manager:pop_cursor(name)

	self._using_cursor = false
end

UIHud.tactical_overlay_active = function (self)
	return self._tactical_overlay_active or false
end

UIHud.event_set_tactical_overlay_state = function (self, active)
	self._tactical_overlay_active = active
end

UIHud.event_set_communication_wheel_state = function (self, state)
	self._communication_wheel_state = state
end

UIHud.communication_wheel_active = function (self)
	return self._communication_wheel_state == "active"
end

UIHud.communication_wheel_wants_camera_control = function (self)
	local state = self._communication_wheel_state

	return state == "active" or state == "camera_lock"
end

UIHud.emote_wheel_active = function (self)
	return self._emote_wheel_state == "active"
end

UIHud.emote_wheel_wants_camera_control = function (self)
	local state = self._emote_wheel_state

	return state == "active" or state == "camera_lock"
end

UIHud.event_set_emote_wheel_state = function (self, state)
	self._emote_wheel_state = state
end

UIHud.event_update_hud_scale = function (self, value)
	self._hud_scale_modified = true
end

UIHud.is_onboarding = function (self)
	local mechanism_manager = Managers.mechanism
	local mechanism_name = mechanism_manager:mechanism_name()

	if mechanism_name == "onboarding" then
		return true
	end

	return false
end

return UIHud
