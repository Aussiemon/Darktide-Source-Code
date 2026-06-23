-- chunkname: @scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup.lua

local definition_path = "scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup_definitions"
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = require("scripts/utilities/world_render")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local BLUR_TIME = 0.3
local reserved_keys = {}
local cancel_keys = {
	"keyboard_esc",
}
local ViewElementKeybindPopup = class("ViewElementKeybindPopup", "ViewElementBase")

ViewElementKeybindPopup.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	ViewElementKeybindPopup.super.init(self, parent, draw_layer, start_scale, definitions)
	self:_setup_default_gui()
	self:_setup_background_gui()

	local background_widget_definition = self._definitions.background_widget_definition

	self._background_widget = self:_create_widget("background_widget", background_widget_definition)
	self._blur_duration = BLUR_TIME

	self:_setup_text_grid()
end

ViewElementKeybindPopup.ui_renderer = function (self)
	return self._ui_default_renderer
end

ViewElementKeybindPopup._destroy_text_grid = function (self)
	if self._text_grid then
		self._text_grid:destroy()

		self._text_grid = nil
	end
end

ViewElementKeybindPopup._setup_text_grid = function (self)
	self:_destroy_text_grid()

	local grid_scenegraph_id = "text_box"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size
	local grid_settings = {
		edge_padding = 0,
		hide_background = true,
		hide_dividers = true,
		no_resource_rendering = true,
		scrollbar_width = 7,
		title_height = 0,
		use_is_focused_for_navigation = false,
		use_select_on_focused = false,
		use_terminal_background = false,
		widget_icon_load_margin = 0,
		grid_spacing = {
			0,
			0,
		},
		grid_size = grid_size,
		mask_size = {
			grid_size[1],
			grid_size[2],
		},
	}
	local layer = self._draw_layer + 1
	local scale = self._render_scale or RESOLUTION_LOOKUP.scale
	local grid = ViewElementGrid:new(self, layer, scale, grid_settings)

	self._text_grid = grid

	self:_update_text_grid_position()
end

ViewElementKeybindPopup.setup_popup = function (self, keys_list, key_index, complete_callback)
	local keys_in_use = {}
	local active_key = keys_list[key_index]
	local header = active_key.display_name
	local active_devices = active_key.devices
	local active_alias = active_key.alias
	local active_alias_name = active_key.alias_name
	local active_value = active_alias:get_keys_for_alias(active_alias_name, active_devices)

	for i = 1, #keys_list do
		local key = keys_list[i]
		local alias = key.alias
		local alias_name = key.alias_name
		local devices = key.devices
		local key_info = alias:get_keys_for_alias(alias_name, devices)

		keys_in_use[key_info.main] = keys_in_use[key_info.main] or {}
		keys_in_use[key_info.main][#keys_in_use[key_info.main] + 1] = key
	end

	self:_generate_grid(header, active_value)

	self._active_popup_data = {
		devices = active_devices,
		complete_callback = complete_callback,
		keys_in_use = keys_in_use,
		cancel_keys = cancel_keys,
		reserved_keys = reserved_keys,
		current_key = active_key,
		keys_list = keys_list,
	}

	Managers.input:start_key_watch(active_devices)
end

ViewElementKeybindPopup._update_popup = function (self, new_key)
	local keys_in_use = self._active_popup_data.keys_in_use
	local new_active_alias_name = new_key.alias_name
	local new_alias = new_key.alias
	local devices = self._active_popup_data.devices
	local new_value = new_alias:get_keys_for_alias(new_active_alias_name, devices)
	local alias_used_by_key = keys_in_use[new_value.main]
	local current_header = self._active_popup_data.current_key.display_name

	self:_generate_grid(current_header, new_value, alias_used_by_key)
end

ViewElementKeybindPopup._generate_grid = function (self, header, value, alias_used_by_key)
	local layout = {}
	local grid_scenegraph_id = "text_box"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size

	layout[#layout + 1] = {
		widget_type = "header",
		text = self:_localize(header or "loc_settings_option_unavailable"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			15,
		},
	}

	if cancel_keys then
		local cancel_key = cancel_keys[1]
		local string_id = alias_used_by_key and "loc_setting_keybinding_press_new_button_conflict" or "loc_setting_keybinding_press_new_button"
		local description_text = Localize(string_id, true, {
			cancel_input = InputUtils.key_axis_locale(cancel_key),
		})

		layout[#layout + 1] = {
			widget_type = "description",
			text = description_text,
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
	end

	layout[#layout + 1] = {
		widget_type = "value",
		text = value and InputUtils.localized_string_from_key_info(value) or self:_localize("loc_keybind_unassigned"),
	}

	if alias_used_by_key then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
		layout[#layout + 1] = {
			widget_type = "conflict_title",
			text = Localize("loc_setting_keybinding_press_new_button_conflict_error"),
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}

		for i = 1, #alias_used_by_key do
			local key_alias = alias_used_by_key[i]

			if i > 1 then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						5,
					},
				}
			end

			local localized_alias = key_alias.display_name

			layout[#layout + 1] = {
				widget_type = "description",
				text = Localize(localized_alias),
			}
		end
	end

	local definitions = self._definitions
	local grid_blueprints = definitions.grid_blueprints
	local grid = self._text_grid

	grid:present_grid_layout(layout, grid_blueprints, nil, nil, nil, nil, callback(self, "cb_on_grid_layout_changed"), nil)
end

ViewElementKeybindPopup.cb_on_grid_layout_changed = function (self)
	local grid = self._text_grid
	local grid_length = grid:grid_length()
	local menu_settings = grid:menu_settings()
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length + 10, 0, 1900)

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:_set_scenegraph_size("text_box", nil, new_grid_height)
	grid:force_update_list_size()
	self:_set_scenegraph_size("text_box_background", nil, new_grid_height + 40)
	self:_update_text_grid_position()
end

ViewElementKeybindPopup._update_text_grid_position = function (self)
	if not self._text_grid then
		return
	end

	self:_force_update_scenegraph()

	local position = self:scenegraph_world_position("text_box", 1)

	self._text_grid:set_pivot_offset(position[1], position[2])
end

ViewElementKeybindPopup.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ViewElementKeybindPopup._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer + 10
	local world_name = class_name .. "_ui_default_world"
	local view_name = self._parent.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

ViewElementKeybindPopup._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer + 9
	local world_name = class_name .. "_ui_background_world"
	local view_name = self._parent.view_name

	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_popup_background_renderer = ui_manager:create_renderer(class_name .. "_ui_popup_background_renderer", self._background_world)
end

ViewElementKeybindPopup.destroy = function (self, ui_renderer)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end

	if self._ui_popup_background_renderer then
		self._ui_popup_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_popup_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end

	ViewElementKeybindPopup.super.destroy(self, ui_renderer)
end

ViewElementKeybindPopup._set_background_blur = function (self, fraction)
	local max_value = 0.55
	local class_name = self.__class_name
	local world_name = class_name .. "_ui_background_world"
	local viewport_name = class_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

ViewElementKeybindPopup._is_change_valid = function (self, new_value_key, current_value_key, previous_keybind_key, keys_in_use)
	if new_value_key == current_value_key and not previous_keybind_key then
		return true
	end

	for i = 1, #reserved_keys do
		local reserved_key = reserved_keys[i]

		if reserved_key == new_value_key then
			return false, "reserved"
		end
	end

	for i = 1, #cancel_keys do
		local cancel_key = cancel_keys[i]

		if cancel_key == new_value_key then
			return false, "cancel"
		end
	end

	if keys_in_use[new_value_key] or previous_keybind_key then
		if not previous_keybind_key then
			return false, "duplicate"
		elseif previous_keybind_key and previous_keybind_key ~= new_value_key then
			return false
		end
	end

	return true
end

ViewElementKeybindPopup.update = function (self, dt, t, input_service)
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

	local grid = self._text_grid

	if grid then
		grid:update(dt, t, input_service)
	end

	if self._active_popup_data then
		local input_manager = Managers.input
		local new_key = input_manager:key_watch_result()

		if new_key then
			local current_key = self._active_popup_data.current_key
			local current_value_key = current_key.alias:get_keys_for_alias(current_key.alias_name, current_key.devices)
			local stored_key = self._active_popup_data.stored_key
			local stored_value_key = stored_key and stored_key.alias:get_keys_for_alias(stored_key.alias_name, stored_key.devices)
			local keys_in_use = self._active_popup_data.keys_in_use
			local is_valid, reason = self:_is_change_valid(new_key.main, current_value_key.main, stored_value_key and stored_value_key.main, keys_in_use)

			if is_valid or not is_valid and reason == "cancel" then
				local complete_callback = self._active_popup_data.complete_callback

				if complete_callback then
					complete_callback(reason ~= "cancel" and new_key or nil)
				end

				self._active_popup_data = nil

				self:_destroy_text_grid()
			else
				Managers.input:stop_key_watch()

				local devices = self._active_popup_data.devices

				Managers.input:start_key_watch(devices)

				if reason == "duplicate" then
					local new_key_data = keys_in_use[new_key.main][1]

					self._active_popup_data.stored_key = new_key_data

					self:_update_popup(new_key_data)
				end
			end
		end
	end

	return ViewElementKeybindPopup.super.update(self, dt, t, input_service)
end

ViewElementKeybindPopup.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	ui_renderer = self._ui_default_renderer

	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	ViewElementKeybindPopup.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local grid = self._text_grid

	if grid then
		grid:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	local ui_scenegraph = self._ui_scenegraph
	local ui_popup_background_renderer = self._ui_popup_background_renderer

	UIRenderer.begin_pass(ui_popup_background_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._background_widget, ui_popup_background_renderer)
	UIRenderer.end_pass(ui_popup_background_renderer)

	render_settings.start_layer = previous_layer
end

return ViewElementKeybindPopup
