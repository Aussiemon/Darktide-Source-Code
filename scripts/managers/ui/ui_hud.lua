require("scripts/ui/hud/elements/hud_element_base")

local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIHudElementCoordinator = require("scripts/managers/ui/ui_hud_element_coordinator")
local resolution_modified_key = "modified"

local function sort_elements_by_hud_scale(a, b)
	return b.use_hud_scale and not a.use_hud_scale
end

local offscreen_target_definitions = {
	{
		viewport_type = "overlay_offscreen_2",
		name = "monitor_effect",
		material_name = "content/ui/meshes/hud_plane/hud_material_effect_no_curve",
		hdr = true
	}
}
local UIHud = class("UIHud")

UIHud.init = function (self, elements, visibility_groups, params)
	self._params = params
	self._currently_visible_elements = {}
	self._visibility_groups = visibility_groups
	local uniq_id = tostring(self)
	self._unique_id = self.__class_name .. "_" .. uniq_id:gsub("[%p%c%s]", "") .. "_"
	self._render_settings = {
		force_retained_mode = false
	}
	self._ui_renderer_name = params.renderer_name or self.__class_name .. "_ui_renderer"
	self._ui_renderer = Managers.ui:create_renderer(self._ui_renderer_name)
	self._offscreen_targets = {}

	for i = 1, #offscreen_target_definitions, 1 do
		local definition = offscreen_target_definitions[i]
		local target_reference_name = definition.name
		local viewport_type = definition.viewport_type
		local viewport_layer = i
		local material_name = definition.material_name
		local hdr = definition.hdr

		self:_add_offscreen_target(target_reference_name, viewport_type, viewport_layer, material_name, hdr)
	end

	self._elements = {}
	self._elements_array = {}
	self._elements_hud_scale_lookup = {}
	self._elements_hud_retained_mode_lookup = {}
	self._customizable_element_scenegraph_ids = {}
	self._offscreen_target_name_by_element_name = {}
	self._element_offscreen_target_functions_by_element_name = {}
	local peer_id = params.peer_id
	local local_player_id = params.local_player_id or 1
	local player = Managers.player:player(peer_id, local_player_id)
	self._player = player
	self._world_viewport_name = params.world_viewport_name or player.viewport_name
	self._element_definitions = table.clone(elements)

	table.sort(self._element_definitions, sort_elements_by_hud_scale)
	self:_verify_elements(self._element_definitions)
	self:_setup_elements(self._element_definitions)

	self._element_coordinator = UIHudElementCoordinator:new()

	Managers.event:register(self, "event_set_tactical_overlay_state", "event_set_tactical_overlay_state")
	Managers.event:register(self, "event_set_communication_wheel_state", "event_set_communication_wheel_state")

	self._refresh_retained = true
end

UIHud._setup_plane_unit = function (self)
	local game_world_name = "level_world"
	local world_manager = Managers.world
	local world = world_manager:has_world(game_world_name) and world_manager:world(game_world_name)
	local unit_name = "content/ui/meshes/hud_plane/hud_plane"
	local unit = World.spawn_unit_ex(world, unit_name)
	local player_camera = self:player_camera()
	local camera_unit = Camera.get_data(player_camera, "unit")
	local unit_node = "hud_plane_transform"
	local node = (unit_node and Unit.has_node(unit, unit_node) and Unit.node(unit, unit_node)) or 1

	World.link_unit(world, unit, node, camera_unit, 1)
	Unit.set_local_position(unit, node, Vector3(0, 0.15, 0))
	Unit.set_local_scale(unit, node, Vector3(0.15, 0.15, 0.15))
	Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(unit, "custom_fov", true)
end

UIHud._add_offscreen_target = function (self, reference_name, viewport_type, viewport_layer, material_name, hdr)
	assert(not self._offscreen_targets[reference_name], "[UIHud] - Already having a offscreen gui by this reference (%s)", reference_name)

	local ui_manager = Managers.ui
	local unique_id = self._unique_id
	local gui = self._ui_renderer.gui
	local gui_retained = self._ui_renderer.gui_retained
	local renderer_name = reference_name .. (self._params.renderer_name or "")
	local ui_renderer = ui_manager:create_renderer(renderer_name, nil, true, gui, gui_retained, material_name)
	self._offscreen_targets[reference_name] = {
		unique_id = unique_id,
		ui_renderer = ui_renderer,
		ui_renderer_name = renderer_name,
		hdr = hdr
	}
end

UIHud._destroy_offscreen_targets = function (self)
	local offscreen_targets = self._offscreen_targets

	for _, data in pairs(offscreen_targets) do
		local ui_renderer_name = data.ui_renderer_name

		Managers.ui:destroy_renderer(ui_renderer_name)
	end

	self._offscreen_targets = nil
end

UIHud.get_player_extension = function (self, player, extension_name)
	if player:unit_is_alive() then
		local player_unit = player.player_unit

		return ScriptUnit.has_extension(player_unit, extension_name)
	end
end

UIHud.get_player_extensions = function (self, player)
	if player:unit_is_alive() then
		local player_unit = player.player_unit
		local extensions = {
			health = ScriptUnit.has_extension(player_unit, "health_system"),
			toughness = ScriptUnit.has_extension(player_unit, "toughness_system"),
			interactor = ScriptUnit.has_extension(player_unit, "interactor_system"),
			unit_data = ScriptUnit.has_extension(player_unit, "unit_data_system"),
			ability = ScriptUnit.has_extension(player_unit, "ability_system"),
			visual_loadout = ScriptUnit.has_extension(player_unit, "visual_loadout_system"),
			buff = ScriptUnit.has_extension(player_unit, "buff_system"),
			dialogue = ScriptUnit.has_extension(player_unit, "dialogue_system"),
			weapon = ScriptUnit.has_extension(player_unit, "weapon_system"),
			coherency = ScriptUnit.has_extension(player_unit, "coherency_system"),
			first_person = ScriptUnit.has_extension(player_unit, "first_person_system"),
			unit = player_unit
		}

		return extensions
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

			fassert(visibility_group, "Could not find the visibility group: (%s) for element: (s%)", group_name, class_name)

			local validation_function = visibility_group.validation_function

			fassert(validation_function, "Could not find any validation_function for visibility group: (%s)", group_name)

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
	local customizable_element_scenegraph_ids = self._customizable_element_scenegraph_ids
	local class_name = definition.class_name

	fassert(elements[class_name] == nil, "Duplicate entries of element (%s)", class_name)

	if definition.use_hud_scale then
		elements_hud_scale_lookup[class_name] = true
	end

	if definition.use_retained_mode then
		elements_hud_retained_mode_lookup[class_name] = true
	end

	local customizable_scenegraph_id = definition.customizable_scenegraph_id

	if customizable_scenegraph_id then
		customizable_element_scenegraph_ids[class_name] = customizable_scenegraph_id
	end

	local offscreen_target = definition.offscreen_target

	if offscreen_target then
		self._offscreen_target_name_by_element_name[class_name] = offscreen_target
	end

	local offscreen_target_functions = definition.offscreen_target_functions

	if offscreen_target_functions then
		self._element_offscreen_target_functions_by_element_name[class_name] = table.clone(offscreen_target_functions)
	end

	self:_add_element(definition, elements, elements_array)

	self._current_group_name = nil
end

UIHud._add_element = function (self, definition, elements, elements_array)
	local class_name = definition.class_name

	fassert(elements[class_name] == nil, "element (%s) is already added", class_name)

	local params = self._params
	local validation_function = definition.validation_function

	if not validation_function or validation_function(params) then
		local filename = definition.filename
		local use_hud_scale = definition.use_hud_scale
		local class = require(filename)
		local draw_layer = 0
		local hud_scale = (use_hud_scale and self:_hud_scale()) or RESOLUTION_LOOKUP.scale
		local element = class:new(self, draw_layer, hud_scale)
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
	local default_ui_renderer = ui_renderer
	local visibility_groups = self._visibility_groups
	local num_visibility_groups = #visibility_groups
	local elements_hud_retained_mode_lookup = self._elements_hud_retained_mode_lookup
	local offscreen_target_name_by_element_name = self._offscreen_target_name_by_element_name
	local element_offscreen_target_functions_by_element_name = self._element_offscreen_target_functions_by_element_name
	local offscreen_targets = self._offscreen_targets

	for i = 1, num_visibility_groups, 1 do
		local visibility_group = visibility_groups[i]
		local group_name = visibility_group.name
		local validation_function = visibility_group.validation_function
		local is_valid = not validation_function or validation_function(self)

		if is_valid then
			if group_name ~= self._current_group_name then
				local elements_array = self._elements_array
				local currently_visible_elements = self._currently_visible_elements
				local visible_elements = visibility_group.visible_elements

				for j = 1, #elements_array, 1 do
					local element = elements_array[j]
					local element_name = element.__class_name
					local render_target = offscreen_target_name_by_element_name[element_name]
					local offscreen_target = offscreen_targets[render_target]

					if offscreen_target then
						ui_renderer = offscreen_target.ui_renderer
					else
						ui_renderer = default_ui_renderer
					end

					local status = (visible_elements and visible_elements[element_name]) or false
					local use_retained_mode = elements_hud_retained_mode_lookup[element_name]

					if element.set_visible then
						element:set_visible(status, ui_renderer, use_retained_mode)
					end

					local offscreen_target_element_functions = element_offscreen_target_functions_by_element_name[element_name]

					if offscreen_target_element_functions then
						for function_offscreen_target_key, offscreen_target_functions in pairs(offscreen_target_element_functions) do
							local offscreen_target_function_name = offscreen_target_functions.set_visible

							if offscreen_target_function_name then
								local function_ui_renderer = nil

								if function_offscreen_target_key == "default" then
									function_ui_renderer = default_ui_renderer
								elseif offscreen_targets[function_offscreen_target_key] then
									function_ui_renderer = offscreen_targets[function_offscreen_target_key].ui_renderer
								end

								if function_ui_renderer then
									element[offscreen_target_function_name](element, status, function_ui_renderer, use_retained_mode)
								end
							end
						end
					end

					currently_visible_elements[element_name] = status
				end

				self._current_group_name = group_name
			end

			break
		end
	end
end

UIHud._hud_scale = function (self)
	local default_value = 1
	local hud_scale_multiplier = self._hud_scale_multiplier or default_value
	local scale = RESOLUTION_LOOKUP.scale

	return scale * hud_scale_multiplier
end

UIHud._apply_hud_scale = function (self)
	local new_scale = self:_hud_scale()
	local render_settings = self._render_settings
	render_settings.scale = new_scale
	render_settings.inverse_scale = 1 / new_scale
end

UIHud._abort_hud_scale = function (self)
	local render_settings = self._render_settings
	local scale = RESOLUTION_LOOKUP.scale
	render_settings.scale = scale
	render_settings.inverse_scale = 1 / scale
end

UIHud.ui_renderer = function (self)
	return self._ui_renderer
end

UIHud.update = function (self, dt, t, input_service)
	local ui_renderer = self._ui_renderer
	local element_coordinator = self._element_coordinator
	local ui_hud_customize_coordinates = false

	if ui_hud_customize_coordinates then
		if not self._using_cursor then
			self:_activate_mouse_cursor()
		end

		element_coordinator:update(dt, t, ui_renderer, input_service)
	elseif self._using_cursor then
		self:_deactivate_mouse_cursor()
	end

	local player_unit = self:player_unit()

	if player_unit then
		if not self._extensions then
			self._extensions = self:get_player_extensions(self._player)
		end
	elseif self._extensions then
		self._extensions = nil
	end

	Profiler.start("[UIHud]- update")
	self:_update_element_visibility()

	local elements_hud_scale_lookup = self._elements_hud_scale_lookup
	local currently_visible_elements = self._currently_visible_elements
	local customizable_element_scenegraph_ids = self._customizable_element_scenegraph_ids
	local elements_array = self._elements_array
	local hud_scale_applied = false
	local render_settings = self._render_settings
	local resolution_modified = RESOLUTION_LOOKUP[resolution_modified_key]
	self._refresh_retained = resolution_modified or self._refresh_retained
	local dragging_element = false
	self._element_using_input = false

	for i = 1, #elements_array, 1 do
		local element = elements_array[i]
		local element_name = element.__class_name

		if not hud_scale_applied and elements_hud_scale_lookup[element_name] then
			hud_scale_applied = true

			self:_apply_hud_scale()
		end

		if resolution_modified and element.on_resolution_modified then
			local scenegraph_id = customizable_element_scenegraph_ids[element_name]

			if scenegraph_id then
				if type(scenegraph_id) == "table" then
					for j = 1, #scenegraph_id, 1 do
						element_coordinator:refresh_coordinates(element, scenegraph_id[j])
					end
				else
					element_coordinator:refresh_coordinates(element, scenegraph_id)
				end
			end

			element:on_resolution_modified()
		end

		if currently_visible_elements[element_name] and element.update then
			Profiler.start(element_name)

			if element.begin_update then
				element:begin_update(dt, t, ui_renderer, render_settings, input_service)
			end

			element:update(dt, t, ui_renderer, render_settings, input_service)

			if element.end_update then
				element:end_update(dt, t, ui_renderer, render_settings, input_service)
			end

			Profiler.stop(element_name)
		end

		if ui_hud_customize_coordinates and not dragging_element then
			local scenegraph_id = customizable_element_scenegraph_ids[element_name]

			if scenegraph_id then
				if type(scenegraph_id) == "table" then
					for j = 1, #scenegraph_id, 1 do
						dragging_element = dragging_element or element_coordinator:handle_scenegraph_coordinates(element, scenegraph_id[j], input_service, render_settings)
					end
				else
					dragging_element = element_coordinator:handle_scenegraph_coordinates(element, scenegraph_id, input_service, render_settings)
				end
			end
		end

		local element_using_input = element.using_input and element:using_input()

		if element_using_input then
			self._element_using_input = true
		end
	end

	if hud_scale_applied then
		self:_abort_hud_scale()
	end

	Profiler.stop("[UIHud]- update")
end

UIHud.draw = function (self, dt, t, input_service)
	local ui_renderer = self._ui_renderer
	local default_ui_renderer = ui_renderer

	Profiler.start("[UIHud] - draw")

	local render_settings = self._render_settings
	local saved_start_layer = render_settings.start_layer
	local alpha_multiplier = render_settings.alpha_multiplier
	local currently_visible_elements = self._currently_visible_elements
	local elements_array = self._elements_array
	local offscreen_target_name_by_element_name = self._offscreen_target_name_by_element_name
	local element_offscreen_target_functions_by_element_name = self._element_offscreen_target_functions_by_element_name
	local offscreen_targets = self._offscreen_targets
	local ui_renderer = self._ui_renderer
	local elements_hud_retained_mode_lookup = self._elements_hud_retained_mode_lookup
	local pass_number = 0

	for i = 1, #offscreen_target_definitions, 1 do
		local definition = offscreen_target_definitions[i]
		local name = definition.name
		local renderer = offscreen_targets[name].ui_renderer
		renderer.base_render_pass = renderer.name
		local render_target = renderer.render_target

		UIRenderer.add_render_pass(ui_renderer, pass_number, renderer.base_render_pass, true, render_target)

		pass_number = pass_number + 1

		if offscreen_targets[name].hdr then
			UIRenderer.add_resource_generator(ui_renderer, pass_number, "gui_bloom_render_pass", "hdr0_overlay", render_target)

			pass_number = pass_number + 2
		end
	end

	UIRenderer.add_render_pass(ui_renderer, pass_number, "to_screen", false)

	local num_elements_rendered = 0

	for i = 1, #elements_array, 1 do
		local element = elements_array[i]
		local element_name = element.__class_name

		if currently_visible_elements[element_name] and element.draw then
			local render_target = offscreen_target_name_by_element_name[element_name]
			local offscreen_target = offscreen_targets[render_target]

			if offscreen_target then
				ui_renderer = offscreen_target.ui_renderer
			else
				ui_renderer = default_ui_renderer
			end

			Profiler.start(element_name)

			if ui_renderer then
				local use_retained_mode = elements_hud_retained_mode_lookup[element_name]
				render_settings.force_retained_mode = use_retained_mode

				element:draw(dt, t, ui_renderer, render_settings, input_service)
			end

			local offscreen_target_element_functions = element_offscreen_target_functions_by_element_name[element_name]

			if offscreen_target_element_functions then
				for function_offscreen_target_key, offscreen_target_functions in pairs(offscreen_target_element_functions) do
					local offscreen_target_function_name = offscreen_target_functions.draw
					local function_ui_renderer = nil

					if function_offscreen_target_key == "default" then
						function_ui_renderer = default_ui_renderer
					elseif offscreen_targets[function_offscreen_target_key] then
						function_ui_renderer = offscreen_targets[function_offscreen_target_key].ui_renderer
					end

					if function_ui_renderer then
						element[offscreen_target_function_name](element, dt, t, function_ui_renderer, render_settings, input_service)
					end
				end
			end

			render_settings.alpha_multiplier = alpha_multiplier
			num_elements_rendered = num_elements_rendered + 1

			Profiler.stop(element_name)
		end
	end

	render_settings.start_layer = saved_start_layer

	Profiler.start("[UIHud] - draw to screen")

	if num_elements_rendered > 0 then
		local resolution_width = RESOLUTION_LOOKUP.width
		local resolution_height = RESOLUTION_LOOKUP.height
		local draw_scale = 1
		local draw_width = resolution_width * draw_scale
		local draw_height = resolution_height * draw_scale
		local offset_x = (resolution_width - draw_width) * 0.5
		local offset_y = (resolution_height - draw_height) * 0.5
		local gui = self._ui_renderer.gui
		local gui_retained = self._ui_renderer.gui_retained
		local position = Vector3(offset_x, offset_y, 0)
		local size = Vector3(draw_width, draw_height, 0)
		local offscreen_targets = self._offscreen_targets

		for i = 1, #offscreen_target_definitions, 1 do
			local definition_name = offscreen_target_definitions[i].name
			local name = offscreen_target_definitions[i].name
			local offscreen_target_data = offscreen_targets[name]
			local renderer = offscreen_target_data.ui_renderer
			local retained_id = offscreen_target_data.retained_id
			local material = renderer.render_target_material
			position[3] = i

			Gui.bitmap(gui, material, "render_pass", "to_screen", position, size)

			if self._refresh_retained then
				if not retained_id then
					retained_id = Gui.bitmap(gui_retained, material, "render_pass", "to_screen", position, size)
				else
					Gui.update_bitmap(gui_retained, retained_id, material, "render_pass", "to_screen", position, size)
				end

				offscreen_target_data.retained_id = retained_id
			end
		end

		self._refresh_retained = false
	end

	Profiler.stop("[UIHud] - draw to screen")
	Profiler.stop("[UIHud] - draw")
end

UIHud.destroy = function (self)
	Managers.event:unregister(self, "event_set_tactical_overlay_state")
	Managers.event:unregister(self, "event_set_communication_wheel_state")

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
	self:_destroy_offscreen_targets()

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

UIHud.communication_wheel_active = function (self)
	return self._communication_wheel_active or false
end

UIHud.event_set_communication_wheel_state = function (self, active)
	self._communication_wheel_active = active
end

UIHud.destroy_offscreen_widgets = function (self, element_name, element)
	local ui_renderer = self._ui_renderer
	local default_ui_renderer = ui_renderer
	local element_offscreen_target_functions_by_element_name = self._element_offscreen_target_functions_by_element_name
	local offscreen_targets = self._offscreen_targets
	local offscreen_target_element_functions = element_offscreen_target_functions_by_element_name[element_name]

	if offscreen_target_element_functions then
		for function_offscreen_target_key, offscreen_target_functions in pairs(offscreen_target_element_functions) do
			local offscreen_target_function_name = offscreen_target_functions.destroy
			local function_ui_renderer = nil

			if function_offscreen_target_key == "default" then
				function_ui_renderer = default_ui_renderer
			elseif offscreen_targets[function_offscreen_target_key] then
				function_ui_renderer = offscreen_targets[function_offscreen_target_key].ui_renderer
			end

			if function_ui_renderer then
				element[offscreen_target_function_name](element, function_ui_renderer)
			end
		end
	end
end

return UIHud
