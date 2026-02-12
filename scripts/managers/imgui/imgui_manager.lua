-- chunkname: @scripts/managers/imgui/imgui_manager.lua

local InputDebug = require("scripts/managers/input/input_debug")
local ImguiSettings = require("scripts/managers/imgui/imgui_settings")
local Imgui = Imgui or {}
local ImguiManager = class("ImguiManager")

local function _check_is_available()
	if DEDICATED_SERVER then
		return false
	end

	local is_xbox_release = BUILD == "release" and PLATFORM == "xbs"

	if is_xbox_release then
		return false
	end

	if not rawget(_G, "Imgui") or Imgui.enable_imgui_input_systems == nil then
		return false
	end

	return true
end

local States = {
	Disabled = nil,
	MainView = 1,
	TempView = 2,
}

ImguiManager.init = function (self)
	self._guis = {}
	self._active_guis = {
		[States.MainView] = {},
		[States.TempView] = {},
	}
	self._persistent_guis = 0
	self._has_viewport_dock = false
	self._using_input = false
	self._active_view_groups = {}
	self._state = States.Disabled
	self._is_imgui_available = _check_is_available()

	if self._is_imgui_available then
		self:_load_active_guis()
		self:_setup_input()
	end

	self:enable_view_group("ImguiManager")
end

ImguiManager.destroy = function (self)
	self:disable_view_group("ImguiManager")

	if not table.is_empty(self._active_view_groups) then
		Log.info("ImguiManager", "Leaked view groups: %s", table.concat(table.keys(self._active_view_groups), ", "))
	end
end

ImguiManager.on_reload = function (self, refreshed_resources)
	for gui_name in pairs(self._guis) do
		self:remove_gui(gui_name)
	end

	for group_name, group_data in pairs(self._active_view_groups) do
		self._active_view_groups[group_name] = nil

		if ImguiSettings.view_groups[group_name] then
			self:enable_view_group(group_name, group_data.params)

			self._active_view_groups[group_name].reference_count = group_data.reference_count
		end
	end
end

ImguiManager._load_active_guis = function (self)
	local active_guis = self._active_guis[States.MainView]
	local saved_active_guis = Application.user_setting("imgui", "main_view_active_guis") or {}

	for _, gui_name in pairs(saved_active_guis) do
		active_guis[gui_name] = true
	end
end

ImguiManager._save_active_guis = function (self)
	local guis = self._guis
	local active_guis = self._active_guis[States.MainView]
	local save_data = {}

	for gui_name, _ in pairs(active_guis) do
		if guis[gui_name] then
			save_data[#save_data + 1] = gui_name
		end
	end

	Application.set_user_setting("imgui", "main_view_active_guis", save_data)
	Application.save_user_settings()
end

ImguiManager._setup_input = function (self)
	local input_manager = Managers.input

	self._input_manager = input_manager
	self._input = input_manager:get_input_service("Imgui")

	self:_enable_imgui_input()
end

ImguiManager._enable_imgui_input = function (self)
	if self._is_imgui_available then
		Imgui.enable_imgui_input_systems()
		Imgui.enable_text_cursor_blink()
	end

	self._using_input = true
end

ImguiManager._disable_imgui_input = function (self)
	if self._is_imgui_available then
		Imgui.disable_imgui_input_systems()
		Imgui.disable_text_cursor_blink()
	end

	self._using_input = false
end

ImguiManager.is_active = function (self)
	return self._state ~= States.Disabled
end

ImguiManager.using_input = function (self)
	return self:is_active() and self._using_input
end

ImguiManager.add_gui = function (self, name, hotkey_action, class_type, params, view_definition)
	local guis = self._guis
	local instance = class_type:new(params, view_definition)

	guis[name] = {
		instance = instance,
		hotkey_action = hotkey_action,
		view_definition = view_definition,
	}

	local state = self._state

	if state ~= States.Disabled and self._active_guis[state][name] then
		self:_gui_on_activated(name)
	end
end

ImguiManager.remove_gui = function (self, name)
	local guis = self._guis
	local gui = guis[name]

	gui.instance:delete()

	guis[name] = nil

	local state = self._state
	local active_guis = self._active_guis[state]

	if state == States.TempView and active_guis[name] and not self:_any_instantiated_active_gui(state) then
		self:_set_state(States.Disabled)
	end
end

ImguiManager._any_instantiated_active_gui = function (self, state)
	local guis, active_guis = self._guis, self._active_guis[state]

	for gui_name, _ in pairs(active_guis) do
		if guis[gui_name] then
			return true
		end
	end

	return false
end

ImguiManager.get_gui = function (self, name)
	return self._guis[name].instance
end

ImguiManager.resize_gui = function (self, gui_name, width, height)
	local gui = self._guis[gui_name]

	gui.resize = {
		width,
		height,
	}
end

ImguiManager.update = function (self, dt, t)
	if not self._is_imgui_available then
		return
	end

	self:_handle_input()

	self._prev_persistent_guis = self._persistent_guis
	self._persistent_guis = 0

	self:_render(dt, t)
end

ImguiManager.disable = function (self)
	if self._state ~= States.Disabled then
		self:_set_state(States.Disabled)
	end
end

ImguiManager._set_state = function (self, new_state)
	local state = self._state

	if state == States.TempView then
		table.clear(self._active_guis[States.TempView])
	elseif state == States.MainView then
		self:_save_active_guis()
	end

	if new_state == States.Disabled then
		if self._using_input then
			Managers.input:pop_cursor("ImguiManager")
		end
	elseif state == States.Disabled and self._using_input then
		Managers.input:push_cursor("ImguiManager")
	end

	self._state = new_state
end

ImguiManager._toggle_gui = function (self, state, gui_name)
	local active_guis = self._active_guis[state]

	if active_guis[gui_name] then
		self:_deactivate_gui(state, gui_name)

		return false
	else
		self:_activate_gui(state, gui_name)

		return true
	end
end

ImguiManager._activate_gui = function (self, state, gui_name)
	local active_guis = self._active_guis[state]

	active_guis[gui_name] = true

	self:_gui_on_activated(gui_name)
end

ImguiManager._deactivate_gui = function (self, state, gui_name)
	local active_guis = self._active_guis[state]

	active_guis[gui_name] = nil

	self:_gui_on_deactivated(gui_name)
end

ImguiManager._gui_on_activated = function (self, gui_name)
	local gui = self._guis[gui_name]

	if gui.instance.on_activated then
		gui.instance:on_activated()
	end
end

ImguiManager._gui_on_deactivated = function (self, gui_name)
	local gui = self._guis[gui_name]

	if gui.instance.on_deactivated then
		gui.instance:on_deactivated()
	end
end

ImguiManager._toggle_input = function (self)
	if self._using_input then
		self:_disable_imgui_input()

		if self:is_active() then
			Managers.input:pop_cursor("ImguiManager")
		end
	else
		self:_enable_imgui_input()

		if self:is_active() then
			Managers.input:push_cursor("ImguiManager")
		end
	end
end

ImguiManager._toggle_main_view = function (self)
	local guis = self._guis
	local state = self._state

	if state ~= States.Disabled then
		local active_guis = self._active_guis[state]

		for gui_name, _ in pairs(active_guis) do
			if guis[gui_name] then
				self:_gui_on_deactivated(gui_name)
			end
		end
	end

	if state == States.Disabled or state == States.TempView then
		state = States.MainView
	else
		state = States.Disabled
	end

	if state == States.MainView or state == States.TempView then
		local active_guis = self._active_guis[state]

		for gui_name, _ in pairs(active_guis) do
			if guis[gui_name] then
				self:_gui_on_activated(gui_name)
			end
		end
	end

	self:_set_state(state)
end

ImguiManager.disable_input_for_one_frame = function (self)
	self._disable_input_for_one_frame = true
end

ImguiManager._handle_input = function (self)
	if self._disable_input_for_one_frame then
		self._disable_input_for_one_frame = false

		return
	end

	local input, state = self._input, self._state
	local guis = self._guis

	if input:get("toggle_input") then
		self:_toggle_input()
	elseif input:get("toggle_main_view") then
		self:_toggle_main_view()
	end

	if Managers.ui:chat_using_input() then
		return
	end

	for gui_name, gui in pairs(guis) do
		local hotkey_action = gui.hotkey_action

		if hotkey_action and input:get(hotkey_action) then
			if state == States.Disabled then
				state = States.TempView

				self:_set_state(state)
			end

			local is_active = self:_toggle_gui(state, gui_name)

			if state == States.TempView and not is_active and not self:_any_instantiated_active_gui(state) then
				state = States.Disabled

				self:_set_state(state)
			end

			break
		end
	end
end

function _get_hotkey(input, hotkey_action)
	if not hotkey_action then
		return ""
	end

	local hotkeys = input:reverse_lookup(hotkey_action)

	return (string.format("[%s]", InputDebug.value_or_table_to_string(hotkeys, true)):gsub("KEYBOARD_", ""))
end

local TEMP_KEYS = {}

ImguiManager._render = function (self, dt, t)
	local num_pushed_style_colors
	local input_disabled = not self._using_input

	if input_disabled then
		num_pushed_style_colors = self:_push_disabled_style_colors()
	end

	if self._has_viewport_dock then
		local ImGuiDockNodeFlags_PassthruCentralNode = 8

		Imgui.dock_space_over_viewport(ImGuiDockNodeFlags_PassthruCentralNode)
	end

	local state = self._state
	local active_guis = self._active_guis[state] or self._active_guis[States.MainView]

	if state == States.MainView and Imgui.begin_main_menu_bar() then
		self._persistent_guis = self._persistent_guis + 1

		local input = self._input

		if Imgui.begin_menu("View") then
			for gui_name, gui in table.sorted(self._guis, TEMP_KEYS) do
				if not gui.no_menu_item then
					local is_active = not not active_guis[gui_name]

					if Imgui.menu_item(gui_name, _get_hotkey(input, gui.hotkey_action), is_active) then
						self:_toggle_gui(state, gui_name)
					end
				end
			end

			table.clear(TEMP_KEYS)
			Imgui.end_menu()
		end

		if Imgui.menu_item("Toggle viewport docking", nil, self._has_viewport_dock) then
			self._has_viewport_dock = not self._has_viewport_dock
		end

		if Imgui.menu_item("Toggle input " .. _get_hotkey(input, "toggle_input"), nil, self._using_input) then
			self:_toggle_input()
		end

		if Imgui.menu_item("Toggle main view " .. _get_hotkey(input, "toggle_main_view")) then
			self:_toggle_main_view()
		end

		Imgui.end_main_menu_bar()
	end

	self:_render_guis(dt, t, active_guis, "update")

	if num_pushed_style_colors then
		Imgui.pop_style_color(num_pushed_style_colors)
	end
end

local DISABLED_STYLE_COLORS = {
	Imgui.COLOR_BUTTON,
	120,
	120,
	120,
	100,
	Imgui.COLOR_BUTTON_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_BUTTON_HOVERED,
	120,
	120,
	120,
	100,
	Imgui.COLOR_CHECK_MARK,
	160,
	160,
	160,
	100,
	Imgui.COLOR_FRAME_BG,
	120,
	120,
	120,
	100,
	Imgui.COLOR_FRAME_BG_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_FRAME_BG_HOVERED,
	120,
	120,
	120,
	100,
	Imgui.COLOR_HEADER,
	120,
	120,
	120,
	100,
	Imgui.COLOR_HEADER_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_HEADER_HOVERED,
	120,
	120,
	120,
	100,
	Imgui.COLOR_MENU_BAR_BG,
	50,
	50,
	50,
	160,
	Imgui.COLOR_NAV_HIGHLIGHT,
	120,
	120,
	120,
	100,
	Imgui.COLOR_POPUP_BG,
	0,
	0,
	0,
	160,
	Imgui.COLOR_RESIZE_GRIP,
	120,
	120,
	120,
	100,
	Imgui.COLOR_RESIZE_GRIP_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_RESIZE_GRIP_HOVERED,
	120,
	120,
	120,
	100,
	Imgui.COLOR_SCROLLBAR_BG,
	0,
	0,
	0,
	50,
	Imgui.COLOR_SCROLLBAR_GRAB,
	120,
	120,
	120,
	100,
	Imgui.COLOR_SCROLLBAR_GRAB_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_SCROLLBAR_GRAB_HOVERED,
	120,
	120,
	120,
	100,
	Imgui.COLOR_SLIDER_GRAB,
	120,
	120,
	120,
	100,
	Imgui.COLOR_SLIDER_GRAB_ACTIVE,
	120,
	120,
	120,
	100,
	Imgui.COLOR_TEXT_SELECTED_BG,
	120,
	120,
	120,
	100,
	Imgui.COLOR_TITLE_BG,
	40,
	40,
	40,
	160,
	Imgui.COLOR_TITLE_BG_ACTIVE,
	40,
	40,
	40,
	160,
	Imgui.COLOR_TITLE_BG_COLLAPSED,
	40,
	40,
	40,
	160,
	Imgui.COLOR_WINDOW_BG,
	0,
	0,
	0,
	160,
}

ImguiManager._push_disabled_style_colors = function (self)
	local num_entries = 0

	for i = 1, #DISABLED_STYLE_COLORS, 5 do
		local style_id = DISABLED_STYLE_COLORS[i]
		local r = DISABLED_STYLE_COLORS[i + 1]
		local g = DISABLED_STYLE_COLORS[i + 2]
		local b = DISABLED_STYLE_COLORS[i + 3]
		local alpha = DISABLED_STYLE_COLORS[i + 4]

		Imgui.push_style_color(style_id, r, g, b, alpha)

		num_entries = num_entries + 1
	end

	return num_entries
end

ImguiManager.post_render = function (self, dt, t)
	if not self._is_imgui_available then
		return
	end

	local num_pushed_style_colors
	local input_disabled = not self._using_input

	if input_disabled then
		num_pushed_style_colors = self:_push_disabled_style_colors()
	end

	local guis_to_render = self._active_guis[self._state or States.MainView]

	self:_render_guis(dt, t, guis_to_render, "post_update")

	local is_open = self:is_active()

	if is_open and self._prev_persistent_guis <= 0 and self._persistent_guis > 0 then
		Imgui.open_imgui()
	elseif not is_open and self._prev_persistent_guis > 0 and self._persistent_guis <= 0 then
		Imgui.close_imgui()
	end

	if num_pushed_style_colors then
		Imgui.pop_style_color(num_pushed_style_colors)
	end
end

local _empty_flags = {}

ImguiManager._render_guis = function (self, dt, t, guis_to_render, update_function_name)
	local guis = self._guis
	local state = self._state
	local input = self._input
	local is_active = self:is_active()

	for gui_name, _ in pairs(guis_to_render) do
		local gui = guis[gui_name]
		local gui_instance = gui and gui.instance

		if gui_instance and (is_active or gui_instance.is_persistent and gui_instance:is_persistent()) then
			self._persistent_guis = self._persistent_guis + 1

			if gui_instance[update_function_name] then
				local hotkey_action = gui.hotkey_action
				local hotkeys_string

				if hotkey_action then
					local hotkeys = input:reverse_lookup(hotkey_action)

					hotkeys_string = string.format("[%s]", InputDebug.value_or_table_to_string(hotkeys, true))
				end

				local window_name = string.format("%s %s###%s", gui_name, hotkeys_string or "", gui_name)
				local resize = gui.resize

				if resize then
					Imgui.set_next_window_size(resize[1], resize[2])

					gui.resize = nil
				end

				local do_close

				if not gui.view_definition.custom_window then
					local flags = gui.view_definition.flags or _empty_flags
					local open

					open, do_close = Imgui.begin_window(window_name, unpack(flags))

					if open and gui_instance[update_function_name](gui_instance, dt, t) then
						do_close = true
					end

					Imgui.end_window()
				else
					do_close = gui_instance[update_function_name](gui_instance, dt, t)
				end

				if do_close then
					self:_deactivate_gui(state, gui_name)

					if state == States.TempView and not self:_any_instantiated_active_gui(state) then
						state = States.Disabled

						self:_set_state(state)
					end
				end
			end
		end
	end
end

ImguiManager.enable_view_group = function (self, view_group_name, params)
	if not self._is_imgui_available then
		return
	end

	if self._active_view_groups[view_group_name] then
		local group_data = self._active_view_groups[view_group_name]

		group_data.reference_count = group_data.reference_count + 1

		return
	end

	local w, h = Gui.resolution()
	local w_scale = math.max(math.floor(w / 1920), 1)
	local h_scale = math.max(math.floor(h / 1080), 1)
	local view_group = ImguiSettings.view_groups[view_group_name]

	for _, view_definition in pairs(view_group) do
		if not view_definition.disable then
			local class_type = require(view_definition.require)

			self:add_gui(view_definition.name, view_definition.hotkey, class_type, params, view_definition)

			local wanted_size = view_definition.size

			if wanted_size then
				self:resize_gui(view_definition.name, wanted_size[1] * w_scale, wanted_size[2] * h_scale)
			end
		end
	end

	self._active_view_groups[view_group_name] = {
		reference_count = 1,
		params = params,
	}
end

ImguiManager.disable_view_group = function (self, view_group_name)
	if not self._is_imgui_available then
		return
	end

	if self._active_view_groups[view_group_name] then
		local group_data = self._active_view_groups[view_group_name]

		group_data.reference_count = group_data.reference_count - 1

		if group_data.reference_count > 0 then
			return
		end
	else
		ferror("View group %q was not active", view_group_name)
	end

	local view_group = ImguiSettings.view_groups[view_group_name]

	for _, view_definition in pairs(view_group) do
		if not view_definition.disable then
			self:remove_gui(view_definition.name)
		end
	end

	self._active_view_groups[view_group_name] = nil
end

return ImguiManager
