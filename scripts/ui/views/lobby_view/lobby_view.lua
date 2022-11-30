local definition_path = "scripts/ui/views/lobby_view/lobby_view_definitions"
local ContentBlueprints = require("scripts/ui/views/lobby_view/lobby_view_content_blueprints")
local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local LobbyViewTestify = GameParameters.testify and require("scripts/ui/views/lobby_view/lobby_view_testify")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local Circumstances = require("scripts/settings/circumstance/circumstance_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local Zones = require("scripts/settings/zones/zones")
local ProfileUtils = require("scripts/utilities/profile_utils")
local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
local UISettings = require("scripts/settings/ui/ui_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local TextUtils = require("scripts/utilities/ui/text")
local Breeds = require("scripts/settings/breed/breeds")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local INVENTORY_VIEW_NAME = "inventory_background_view"
local LobbyView = class("LobbyView", "BaseView")

local function _generate_seed(player_id, mission_id)
	if not mission_id or not player_id then
		return 0
	end

	local seed = 1

	for i = 1, 3 do
		local num = string.byte(player_id, i) or 1
		seed = seed * num
	end

	for i = 1, 3 do
		local num = string.byte(mission_id, i) or 1
		seed = seed * num
	end

	return seed
end

LobbyView.init = function (self, settings, context)
	self._preview = context.preview
	self._context = context
	self._voting_id = context.voting_id
	self._mission_data = context.mission_data
	self._spawn_slots = {}
	self._show_loadout = false
	self._slot_changes = false
	local definitions = require(definition_path)

	LobbyView.super.init(self, definitions, settings)

	self._pass_draw = false
	self._can_exit = not context or context.can_exit

	self:_register_event("event_lobby_vote_started")
end

LobbyView.on_enter = function (self)
	LobbyView.super.on_enter(self)
	self:_setup_menu_list()
	self:_setup_input_legend()
	self:_setup_mission_descriptions()

	self._item_definitions = MasterItems.get_cached()

	Managers.frame_rate:request_full_frame_rate("lobby_view")
end

LobbyView._initialize_background_world = function (self)
	self:_register_event("event_register_lobby_camera")

	self._human_spawn_point_units = {}
	self._ogryn_spawn_point_units = {}
	local max_spawn_slots = 4

	for i = 1, max_spawn_slots do
		local event_name_human = "event_register_lobby_spawn_point_human_" .. i
		local event_name_ogryn = "event_register_lobby_spawn_point_ogryn_" .. i

		self[event_name_human] = function (self, spawn_unit)
			self._human_spawn_point_units[i] = spawn_unit

			self:_unregister_event(event_name_human)

			if table.size(self._human_spawn_point_units) == max_spawn_slots and table.size(self._ogryn_spawn_point_units) == max_spawn_slots then
				self:_setup_spawn_slots()
				self:_register_event("event_lobby_ready_vote_casted")
				self:_sync_votes()
			end
		end

		self[event_name_ogryn] = function (self, spawn_unit)
			self._ogryn_spawn_point_units[i] = spawn_unit

			self:_unregister_event(event_name_ogryn)

			if table.size(self._human_spawn_point_units) == max_spawn_slots and table.size(self._ogryn_spawn_point_units) == max_spawn_slots then
				self:_setup_spawn_slots()
				self:_register_event("event_lobby_ready_vote_casted")
				self:_sync_votes()
			end
		end

		self:_register_event(event_name_human)
		self:_register_event(event_name_ogryn)
	end

	local world_name = LobbyViewSettings.world_name
	local world_layer = LobbyViewSettings.world_layer
	local world_timer_name = LobbyViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = LobbyViewSettings.level_name

	self._world_spawner:spawn_level(level_name)

	self._world_initialized = true
end

LobbyView.event_register_lobby_camera = function (self, camera_unit)
	self:_unregister_event("event_register_lobby_camera")

	local viewport_name = LobbyViewSettings.viewport_name
	local viewport_type = LobbyViewSettings.viewport_type
	local viewport_layer = LobbyViewSettings.viewport_layer
	local shading_environment = LobbyViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

LobbyView.event_lobby_vote_started = function (self, context)
	self:_unregister_event("event_lobby_vote_started")

	self._preview = false
	self._context = context
	self._voting_id = context.voting_id
	self._mission_data = context.mission_data

	Log.info("LobbyView", "event_lobby_vote_started voting id: %s mission_name: %s", self._voting_id, self._mission_data.mission_name)
end

LobbyView._setup_mission_descriptions = function (self)
	local mission_data = self._mission_data
	local mission_settings = Missions[mission_data.mission_name]

	if mission_settings then
		local mission_display_name = mission_settings.mission_name
		local zone_name = mission_settings.zone_id
		local zone_info = Zones[zone_name]
		local zone_display_name = zone_info and zone_info.name
		local mission_type = MissionTypes[mission_settings.mission_type]
		local mission_type_name = mission_type and mission_type.name
		local circumstance_name = nil

		if mission_data.circumstance_name ~= "default" then
			circumstance_name = Circumstances[mission_data.circumstance_name].ui and self:_localize(Circumstances[mission_data.circumstance_name].ui.display_name) or mission_data.circumstance_name
		end

		local sub_title = mission_type_name and self:_localize(mission_type_name) or ""

		if zone_display_name then
			sub_title = sub_title .. " · " .. self:_localize(zone_display_name) or sub_title
		end

		if circumstance_name then
			sub_title = sub_title .. " · " .. circumstance_name or sub_title
		end

		local widgets_by_name = self._widgets_by_name
		widgets_by_name.mission_title.content.title = mission_display_name and self:_localize(mission_display_name) or "N/A"
		widgets_by_name.mission_title.content.sub_title = sub_title or "N/A"
		local title_width = self:_text_size(widgets_by_name.mission_title.content.title, widgets_by_name.mission_title.style.title.font_type, widgets_by_name.mission_title.style.title.font_size)
		local end_margin = 10
		widgets_by_name.mission_title.style.divider.size[1] = title_width + end_margin
	end
end

LobbyView._setup_menu_list = function (self)
	local menu_list_config = {}
	menu_list_config[#menu_list_config + 1] = {
		display_name = "loc_lobby_entry_ready",
		widget_type = "ready_button",
		update_function = function (parent, widget, entry)
			local current_ready_status = parent:_own_player_ready_status()
			local text = nil

			if current_ready_status then
				text = self:_localize("loc_lobby_entry_unready")
			else
				text = self:_localize("loc_lobby_entry_ready")
			end

			widget.content.text = text
			widget.content.active = current_ready_status
			local in_preview = parent:_in_preview()
			local hotspot = widget.content.hotspot
			hotspot.disabled = in_preview
		end,
		pressed_function = function (parent, widget, entry)
			local current_ready_status = parent:_own_player_ready_status()

			if current_ready_status == false then
				self:_play_sound(UISoundEvents.mission_lobby_ready_up)
			else
				self:_play_sound(UISoundEvents.mission_lobby_unready)
			end

			parent:_set_own_player_ready_status(not current_ready_status)
		end
	}

	self:_setup_menu_list_entries(menu_list_config)
end

LobbyView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

LobbyView.cb_on_close_pressed = function (self)
	Managers.ui:close_view("lobby_view")
end

LobbyView.cb_on_open_main_menu_pressed = function (self)
	Managers.ui:open_view("system_view")
end

LobbyView.cb_on_inventory_pressed = function (self)
	Managers.ui:open_view(INVENTORY_VIEW_NAME)
end

LobbyView.cb_on_loadout_pressed = function (self)
	self._show_loadout = not self._show_loadout
end

LobbyView._setup_menu_list_entries = function (self, config)
	if self._menu_list_widgets then
		for i = 1, #self._menu_list_widgets do
			local widget = self._menu_list_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	local entries = {}

	for i = 1, #config do
		local entry_config = config[i]
		local display_name = entry_config.display_name
		local entry = {
			display_name = display_name,
			widget_type = entry_config.widget_type,
			pressed_function = entry_config.pressed_function,
			update_function = entry_config.update_function
		}
		entries[#entries + 1] = entry
	end

	local scenegraph_id = "grid_content_pivot"
	local callback_name = "cb_on_list_entry_pressed"
	self._menu_list_widgets, self._menu_alignment_list = self:_setup_list_content_widgets(entries, scenegraph_id, callback_name)
	local grid_scenegraph_id = "grid_background"
	local grid_spacing = LobbyViewSettings.grid_spacing
	local grid_direction = "up"
	self._menu_list_grid = UIWidgetGrid:new(self._menu_list_widgets, self._menu_alignment_list, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, true)
end

LobbyView._setup_list_content_widgets = function (self, content, scenegraph_id, callback_name)
	local definitions = self._definitions
	local widget_definitions = {}
	local widgets = {}
	local alignment_list = {}
	local amount = #content

	for i = 1, amount do
		local entry = content[i]
		local widget_type = entry.widget_type
		local widget = nil
		local template = ContentBlueprints[widget_type]
		local size = template.size
		local pass_template = template.pass_template

		if pass_template and not widget_definitions[widget_type] then
			local scenegraph_definition = definitions.scenegraph_definition
			widget_definitions[widget_type] = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
		end

		local widget_definition = widget_definitions[widget_type]

		if widget_definition then
			local name = scenegraph_id .. "_widget_" .. i
			widget = self:_create_widget(name, widget_definition)
			local init = template.init

			if init then
				init(self, widget, entry, callback_name)
			end

			widget.entry = entry
			widgets[#widgets + 1] = widget
		end

		alignment_list[#alignment_list + 1] = widget or {
			size = size
		}
	end

	return widgets, alignment_list
end

LobbyView.cb_on_list_entry_pressed = function (self, widget, entry)
	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end
end

LobbyView.on_resolution_modified = function (self)
	LobbyView.super.on_resolution_modified(self)

	if self._menu_list_grid then
		self._menu_list_grid:on_resolution_modified()
	end
end

LobbyView._setup_spawn_slots = function (self)
	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	local ignored_slots = LobbyViewSettings.ignored_slots
	local definitions = self._definitions
	local panel_definition = definitions.panel_definition
	local loading_definition = definitions.loading_definition
	local player_index = 1
	local spawn_slots = {}
	local num_players = LobbyViewSettings.max_player_slots

	for i = 1, num_players do
		local profile_spawner = UIProfileSpawner:new("LobbyView_" .. i, world, camera, unit_spawner)

		for j = 1, #ignored_slots do
			local slot_name = ignored_slots[j]

			profile_spawner:ignore_slot(slot_name)
		end

		local panel_widget_name = "panel_" .. i
		local loading_widget_name = "loading_" .. i
		local default_spawn_point_unit = self._human_spawn_point_units[i]
		local initial_position = Unit.world_position(default_spawn_point_unit, 1)
		local spawn_slot = {
			occupied = false,
			ready = false,
			index = i,
			profile_spawner = profile_spawner,
			ogryn_spawn_point_unit = self._ogryn_spawn_point_units[i],
			human_spawn_point_unit = self._human_spawn_point_units[i],
			boxed_initial_position = Vector3.to_array(initial_position),
			panel_widget = self:_create_widget(panel_widget_name, panel_definition),
			loading_widget = self:_create_widget(loading_widget_name, loading_definition),
			loadout_widgets = {}
		}
		spawn_slots[i] = spawn_slot
	end

	self._spawn_slots = spawn_slots
end

LobbyView._destroy_spawn_slots = function (self)
	self:_unload_all_portrait_icon()

	local spawn_slots = self._spawn_slots

	if spawn_slots then
		for i = 1, #spawn_slots do
			local slot = spawn_slots[i]
			local profile_spawner = slot.profile_spawner

			profile_spawner:destroy()
		end

		self._spawn_slots = nil
	end
end

LobbyView.can_exit = function (self)
	return self._can_exit and self._navigation_state == "menu"
end

LobbyView.on_exit = function (self)
	self:_destroy_spawn_slots()

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	Managers.frame_rate:relinquish_request("lobby_view")
	LobbyView.super.on_exit(self)
end

LobbyView.update = function (self, dt, t, input_service)
	if self._world_initialized then
		local world_spawner = self._world_spawner

		if world_spawner then
			world_spawner:update(dt, t)
		end

		if self._preview then
			self:_sync_local_player()
		else
			self:_sync_players()
		end

		self:_update_player_slots(dt, t)

		if self._menu_list_widgets then
			self:_update_menu_list(dt, t)
			self._menu_list_grid:update(dt, t, input_service)
		end
	else
		self:_initialize_background_world()
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(LobbyViewTestify, self)
	end

	if self._slot_changes == true then
		Managers.event:trigger("event_lobby_ready_slot_sync", self._spawn_slots)

		self._slot_changes = false
	end

	self:_check_loadout_changes()
	self:_set_loadout_visibility()

	self._is_main_menu_open = Managers.ui:view_active("system_view")

	if self._is_animating_on_exit == true then
		self._is_animating_on_exit = self:_all_ready_countdown(dt)
	end

	return LobbyView.super.update(self, dt, t, input_service)
end

LobbyView._all_ready_countdown = function (self, dt)
	if not self._countdown then
		self._countdown = LobbyViewSettings.delay_ready_exit

		Managers.event:trigger("event_lobby_ready_started", function ()
			return self._countdown
		end)
	end

	self._countdown = self._countdown - dt

	if self._countdown < 0 then
		Managers.event:trigger("event_lobby_ready_completed")

		self._countdown = nil
	end

	return not not self._countdown
end

LobbyView._update_player_slots = function (self, dt, t, input_service)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied then
			local profile_spawner = slot.profile_spawner

			profile_spawner:update(dt, t, input_service)
		end
	end
end

LobbyView._update_menu_list = function (self, dt, t)
	local menu_list_widgets = self._menu_list_widgets

	for i = 1, #menu_list_widgets do
		local widget = menu_list_widgets[i]
		local entry = widget.entry
		local update_function = entry.update_function

		if update_function then
			update_function(self, widget, entry)
		end
	end
end

LobbyView._on_navigation_input_changed = function (self)
	LobbyView.super._on_navigation_input_changed(self)
	self:_setup_menu_list()

	local service_type = DefaultViewInputSettings.service_type
	local is_mouse = self._using_cursor_navigation
	local display_name = nil

	for i = 1, #self._spawn_slots do
		local spawn_slot = self._spawn_slots[i]
		local player = Managers.player:local_player(1)
		display_name = spawn_slot.player == player and not spawn_slot.ready and "loc_lobby_player_inventory_button" or "loc_lobby_player_inpect_button"

		if spawn_slot.panel_widget then
			if is_mouse then
				spawn_slot.panel_widget.content.character_inspect = Localize(display_name)
			else
				local action = "confirm_pressed"
				spawn_slot.panel_widget.content.character_inspect = TextUtils.localize_with_button_hint(action, display_name, nil, service_type, Localize("loc_input_legend_text_template"))
			end
		end
	end
end

LobbyView._get_previous_occupied_slot_index = function (self, from_index)
	local spawn_slots = self._spawn_slots
	from_index = from_index or #spawn_slots

	if from_index <= 1 then
		return
	end

	for i = from_index - 1, 1, -1 do
		local slot = spawn_slots[i]

		if slot.occupied then
			return i
		end
	end
end

LobbyView._get_next_occupied_slot_index = function (self, from_index)
	local spawn_slots = self._spawn_slots
	from_index = from_index or 1

	if from_index >= #spawn_slots then
		return
	end

	for i = from_index + 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied then
			return i
		end
	end
end

LobbyView._handle_input = function (self, input_service, dt, t)
	local is_mouse = self._using_cursor_navigation

	if self._world_initialized then
		if is_mouse then
			-- Nothing
		elseif not self._menu_list_grid:selected_grid_index() and not self:_is_slot_focused() then
			self._menu_list_grid:select_last_index(true)
		elseif (input_service:get("navigate_up_continuous") or input_service:get("navigate_down_continuous")) and self:_is_slot_focused() then
			self:_set_slot_focused_by_index()
		end
	end
end

LobbyView._reset_spawn_slot = function (self, slot)
	local profile_spawner = slot.profile_spawner

	if profile_spawner then
		profile_spawner:reset()
	end

	slot.player = nil
	slot.unique_id = nil
	slot.occupied = false
	slot.synced = false
	slot.boxed_position = nil
	slot.boxed_rotation = nil

	self:_set_slot_ready_status(slot, false)

	if self._slot_changes == false then
		self._slot_changes = true
	end

	self:_unload_portrait_icon(slot)
end

LobbyView._get_free_slot_id = function (self)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if not slot.occupied then
			return i
		end
	end
end

LobbyView._player_slot_id = function (self, unique_id)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied and slot.unique_id == unique_id then
			return i
		end
	end
end

LobbyView._assign_player_to_slot = function (self, player, slot)
	local unique_id = player:unique_id()
	local profile = player:profile()
	local archetype_settings = profile.archetype
	local breed_name = archetype_settings.breed
	local spawn_point_unit = nil

	if breed_name == "ogryn" then
		spawn_point_unit = slot.ogryn_spawn_point_unit
	else
		spawn_point_unit = slot.human_spawn_point_unit
	end

	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local profile_size = profile.personal and profile.personal.character_height
	local spawn_scale = profile_size and Vector3(profile_size, profile_size, profile_size)
	local profile_spawner = slot.profile_spawner
	local selected_archetype = profile.archetype
	local breed_name = selected_archetype and selected_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine
	local slot_name = slot.default_slot
	local slot_item = profile.loadout[slot_name]
	local item_inventory_animation_event = slot_item and slot_item.inventory_animation_event or "inventory_idle_default"

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, spawn_scale, inventory_state_machine, item_inventory_animation_event)
	profile_spawner:wield_slot(slot_name)

	local panel_widget = slot.panel_widget
	local panel_content = panel_widget.content
	local character_name = ProfileUtils.character_name(profile)
	local character_title = ProfileUtils.character_title(profile)
	local character_level = tostring(profile.current_level) .. " "
	panel_content.character_title = character_title
	panel_content.has_guild = false
	slot.loaded = false
	slot.occupied = true
	slot.synced = true
	slot.player = player
	slot.profile = profile
	slot.unique_id = unique_id
	slot.boxed_position = Vector3.to_array(spawn_position)
	slot.boxed_rotation = QuaternionBox(spawn_rotation)
	local weapon_slots = {
		"slot_primary",
		"slot_secondary"
	}
	local seed = _generate_seed(unique_id, self._mission_data.backend_mission_id)
	local _, random_slot = math.next_random(seed, 1, #weapon_slots)
	slot.default_slot = weapon_slots[random_slot]
	panel_content.character_name = string.format("%s %s", character_level, character_name)
	local loadout = profile.loadout
	local frame_item = loadout and loadout.slot_portrait_frame

	if frame_item then
		local cb = callback(self, "_cb_set_player_frame", panel_widget)
		slot.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
	end

	local insignia_item = loadout and loadout.slot_insignia

	if insignia_item then
		local cb = callback(self, "_cb_set_player_insignia", panel_widget)
		slot.insignia_load_id = Managers.ui:load_item_icon(insignia_item, cb)
	end

	self:_request_player_icon(slot)
end

LobbyView._cb_set_player_frame = function (self, widget, item)
	local material_values = widget.style.character_portrait.material_values
	material_values.portrait_frame_texture = item.icon
end

LobbyView._cb_set_player_insignia = function (self, widget, item)
	widget.style.character_insignia.material_values.texture_map = item.icon
end

LobbyView._request_player_icon = function (self, slot)
	local panel_widget = slot.panel_widget
	local panel_style = panel_widget.style
	local material_values = panel_style.character_portrait.material_values
	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon(slot)
end

LobbyView._load_portrait_icon = function (self, slot)
	local profile = slot.profile
	local cb = callback(self, "_cb_set_player_icon", slot)
	local icon_load_id = Managers.ui:load_profile_portrait(profile, cb)
	slot.icon_load_id = icon_load_id
end

LobbyView._unload_all_portrait_icon = function (self)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.icon_load_id then
			self:_unload_portrait_icon(slot)
		end
	end
end

LobbyView._unload_portrait_icon = function (self, slot)
	local ui_renderer = self._ui_renderer

	UIWidget.set_visible(slot.panel_widget, ui_renderer, false)

	local icon_load_id = slot.icon_load_id
	local frame_load_id = slot.frame_load_id
	local insignia_load_id = slot.insignia_load_id

	Managers.ui:unload_profile_portrait(icon_load_id)
	Managers.ui:unload_item_icon(frame_load_id)
	Managers.ui:unload_item_icon(insignia_load_id)

	slot.icon_load_id = nil
	slot.frame_load_id = nil
	slot.insignia_load_id = nil
end

LobbyView._sync_players = function (self)
	local player_manager = Managers.player
	local players = player_manager:players()

	for unique_id, player in pairs(players) do
		self:_sync_player(unique_id, player)
	end

	self:_update_synced_slots()
end

LobbyView._cb_set_player_icon = function (self, slot, grid_index, rows, columns, render_target)
	local widget = slot.panel_widget
	local material_values = widget.style.character_portrait.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

LobbyView._sync_local_player = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local unique_id = player:unique_id()

	self:_sync_player(unique_id, player)
	self:_update_synced_slots()
end

LobbyView._sync_player = function (self, unique_id, player)
	local spawn_slots = self._spawn_slots
	local slot_id = self:_player_slot_id(unique_id)
	local slot = spawn_slots[slot_id]

	if not slot_id then
		slot_id = self:_get_free_slot_id()
		slot = spawn_slots[slot_id]

		if slot then
			if self._first_player_added then
				self:_play_sound(UISoundEvents.mission_lobby_matchmade_players_join)
			else
				self._first_player_added = true
			end

			self:_assign_player_to_slot(player, slot)

			self._slot_changes = true
		end
	else
		slot.synced = true
	end
end

LobbyView._update_synced_slots = function (self)
	local spawn_slots = self._spawn_slots
	local num_slots = #spawn_slots

	for i = 1, num_slots do
		local slot = spawn_slots[i]

		if not slot.synced and slot.occupied then
			self:_reset_spawn_slot(slot)
		end

		slot.synced = false
	end
end

LobbyView.draw = function (self, dt, t, input_service, layer)
	self:_draw_menu_list_grid(dt, t, input_service)
	LobbyView.super.draw(self, dt, t, input_service, layer)
end

LobbyView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	LobbyView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	if self._world_initialized then
		local camera = self._world_spawner:camera()
		local inverse_scale = ui_renderer.inverse_scale
		local spawn_slots = self._spawn_slots
		local num_slots = #spawn_slots

		for i = 1, num_slots do
			local is_even = i % 2 == 0
			local slot = spawn_slots[i]
			local occupied = slot.occupied
			local boxed_initial_position = slot.boxed_initial_position
			local boxed_position = slot.boxed_position
			local position = occupied and Vector3.from_array(boxed_position) or Vector3.from_array(boxed_initial_position)
			local panel_widget = slot.panel_widget
			local loading_widget = slot.loading_widget
			local x, _ = self:_convert_world_to_screen_position(camera, position)
			local widget_offset_x = x * inverse_scale
			panel_widget.offset[1] = widget_offset_x
			loading_widget.offset[1] = widget_offset_x

			for f = 1, #slot.loadout_widgets do
				local loadout_widgets = slot.loadout_widgets[f]
				loadout_widgets.weapon_widget.offset[1] = widget_offset_x + 7
				loadout_widgets.text_widget.offset[1] = widget_offset_x
			end

			local profile_spawner = slot.profile_spawner

			if occupied and profile_spawner:spawned() then
				profile_spawner:set_position(position)
				UIWidget.draw(panel_widget, ui_renderer)

				for f = 1, #slot.loadout_widgets do
					local loadout_widgets = slot.loadout_widgets[f]

					UIWidget.draw(loadout_widgets.weapon_widget, ui_renderer)
					UIWidget.draw(loadout_widgets.text_widget, ui_renderer)

					loadout_widgets.text_widget.content.hotspot.is_focused = panel_widget.content.hotspot.is_focused
				end
			else
				UIWidget.draw(loading_widget, ui_renderer)
			end
		end
	end
end

LobbyView._draw_menu_list_grid = function (self, dt, t, input_service)
	local grid = self._menu_list_grid
	local widgets = self._menu_list_widgets
	local null_input_service = input_service:null_service()
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local draw = widget ~= self._focused_settings_widget

			if draw then
				if self._focused_settings_widget then
					ui_renderer.input_service = null_input_service
				end

				if grid:is_widget_visible(widget) then
					UIWidget.draw(widget, ui_renderer)
				end
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

LobbyView._convert_world_to_screen_position = function (self, camera, world_position)
	if camera then
		local world_to_screen, distance = Camera.world_to_screen(camera, world_position)

		return world_to_screen.x, world_to_screen.y, distance
	end
end

LobbyView._set_slot_focused_by_index = function (self, index)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]
		local is_hover = i == index
		slot.is_hover = is_hover
		slot.panel_widget.content.hotspot.is_focused = is_hover
	end

	self._focused_slot_index = index
end

LobbyView._is_slot_focused = function (self)
	return not not self._focused_slot_index
end

LobbyView._is_button_focused = function (self)
	return not not self._focused_button_index
end

LobbyView._get_slot_index_by_player = function (self, player)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.player == player then
			return i
		end
	end
end

LobbyView._slot_by_index = function (self, index)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		if i == index then
			return spawn_slots[i]
		end
	end
end

LobbyView._slot_by_unit = function (self, unit)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]
		local profile_spawner = slot.profile_spawner

		if profile_spawner then
			local character_unit = profile_spawner:spawned_character_unit()

			if character_unit and unit and character_unit == unit then
				return slot
			end
		end
	end
end

LobbyView._own_player_ready_status = function (self)
	local player = Managers.player:local_player(1)
	local slot_index = self:_get_slot_index_by_player(player)
	local slot = self:_slot_by_index(slot_index)

	return slot and slot.ready
end

LobbyView._in_preview = function (self)
	return self._preview
end

LobbyView._set_own_player_ready_status = function (self, is_ready)
	if self._preview then
		return
	end

	local vote_option = is_ready and "yes" or "no"

	Managers.voting:cast_vote(self._voting_id, vote_option)
end

LobbyView.event_lobby_ready_vote_casted = function (self)
	self:_sync_votes()
end

LobbyView._sync_votes = function (self)
	if self._preview then
		return
	end

	local votes = Managers.voting:votes(self._voting_id)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]
		local is_ready = false

		if slot.occupied then
			local player = slot.player
			local peer_id = player:peer_id()
			local vote = votes[peer_id]
			is_ready = vote ~= StrictNil and vote == "yes"
		end

		self:_set_slot_ready_status(slot, is_ready)
	end
end

LobbyView._set_slot_ready_status = function (self, slot, is_ready)
	if slot.ready ~= is_ready then
		self._slot_changes = true
	end

	slot.ready = is_ready
	local widget = slot.panel_widget
	widget.content.is_ready = is_ready
	local material_values = widget.style.character_portrait.material_values
	material_values.desaturation = is_ready and 1 or 0
	material_values.intensity = is_ready and 0.25 or 1

	if is_ready then
		local player = Managers.player:local_player(1)

		if slot.player ~= player then
			self:_play_sound(UISoundEvents.mission_lobby_player_ready)
		end

		self:_start_animation_ready(slot)
	else
		self:_start_animation_unready(slot)
	end
end

LobbyView._open_inventory_by_slot = function (self, slot)
	local player = slot.player
	local context = {
		parent = self,
		player = player,
		is_readonly = slot.ready
	}

	Managers.ui:open_view(INVENTORY_VIEW_NAME, nil, nil, nil, nil, context)
end

LobbyView.cb_on_slot_inspect_pressed = function (self, slot)
	local profile_spawner = slot.profile_spawner
	local unit = profile_spawner and profile_spawner:spawned_character_unit()

	if unit then
		self:_open_inventory_by_slot(slot)
	end
end

LobbyView.set_own_player_ready_status = function (self, is_ready)
	self:_set_own_player_ready_status(is_ready)
end

LobbyView._check_loadout_changes = function (self)
	local search_slot = {
		"slot_primary",
		"slot_secondary"
	}

	for i = 1, #self._spawn_slots do
		local spawn_slot = self._spawn_slots[i]

		if spawn_slot.occupied then
			local profile = spawn_slot.player:profile()
			local changed_items = false

			for i = 1, #search_slot do
				local slot_name = search_slot[i]

				if profile.loadout[slot_name] and spawn_slot[slot_name] ~= profile.loadout[slot_name] then
					changed_items = true

					break
				end
			end

			if changed_items then
				spawn_slot.profile = profile

				self:_setup_loadout_widgets(spawn_slot)
			end
		end
	end
end

LobbyView._setup_loadout_widgets = function (self, spawn_slot)
	local size = {
		370,
		0
	}
	local item_blueprints = generate_blueprints_function(size)
	local profile = spawn_slot.player:profile()
	local search_slot = {
		"slot_primary",
		"slot_secondary"
	}
	local initial_offset = 240
	local loadout_margin = 240
	local text_offset = 130
	local ui_renderer = self._ui_renderer
	local scenegraph_id = "loadout"

	for f = 1, #spawn_slot.loadout_widgets do
		local loadout_widgets = spawn_slot.loadout_widgets[f]
		local weapon_widget = loadout_widgets.weapon_widget
		local text_widget = loadout_widgets.text_widget

		self:_unregister_widget_name(weapon_widget.name)
		self:_unregister_widget_name(text_widget.name)
	end

	spawn_slot.loadout_widgets = {}

	for i = 1, #search_slot do
		local slot = search_slot[i]
		local loadout = profile.loadout[slot]
		local template = item_blueprints.item_icon
		local config = {
			item = loadout
		}
		local size = UISettings.weapon_icon_size
		local pass_template_function = template.pass_template_function
		local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
		local optional_style = template.style or {}
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

		if widget_definition then
			local name_weapon = string.format("loadout_%s_%s", spawn_slot.index, i)
			local weapon_widget = self:_create_widget(name_weapon, widget_definition)
			local name_text = string.format("loadout_text_%s_%s", spawn_slot.index, i)
			local text_widget = self:_create_widget(name_text, self._definitions.weapon_text_definition)
			local init = template.init

			if init then
				init(self, weapon_widget, config, nil, nil, ui_renderer)
			end

			weapon_widget.style.icon.uvs = {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}
			local offset_height = initial_offset + loadout_margin * (i - 1)
			weapon_widget.offset = {
				0,
				offset_height,
				0
			}
			weapon_widget.content.hotspot.disabled = true
			text_widget.offset = {
				0,
				offset_height + text_offset,
				0
			}
			text_widget.content.weapon_text = Localize(loadout.display_name)

			template.load_icon(self, weapon_widget, config)

			spawn_slot.loadout_widgets[#spawn_slot.loadout_widgets + 1] = {
				weapon_widget = weapon_widget,
				text_widget = text_widget
			}
			spawn_slot[slot] = loadout
		end
	end

	spawn_slot.profile_spawner:destroy()

	local archetype_settings = profile.archetype
	local breed_name = archetype_settings.breed
	local spawn_point_unit = nil

	if breed_name == "ogryn" then
		spawn_point_unit = spawn_slot.ogryn_spawn_point_unit
	else
		spawn_point_unit = spawn_slot.human_spawn_point_unit
	end

	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local profile_size = profile.personal and profile.personal.character_height
	local spawn_scale = profile_size and Vector3(profile_size, profile_size, profile_size)
	local profile_spawner = spawn_slot.profile_spawner
	local selected_archetype = profile.archetype
	local breed_name = selected_archetype and selected_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine
	local slot_name = spawn_slot.default_slot
	local slot_item = spawn_slot.profile.loadout[slot_name]
	local item_inventory_animation_event = slot_item and slot_item.inventory_animation_event or "inventory_idle_default"

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, spawn_scale, inventory_state_machine, item_inventory_animation_event)
	spawn_slot.profile_spawner:wield_slot(slot_name)
end

LobbyView._set_loadout_visibility = function (self)
	local is_active = self._show_loadout
	local loadout_size = LobbyViewSettings.loadout_size
	local panel_size = LobbyViewSettings.panel_size

	if is_active then
		self:_set_scenegraph_size("panel", loadout_size[1], loadout_size[2])
	else
		self:_set_scenegraph_size("panel", panel_size[1], panel_size[2])
	end

	for i = 1, #self._spawn_slots do
		local slot = self._spawn_slots[i]

		if slot.occupied then
			for f = 1, #slot.loadout_widgets do
				local loadout_widgets = slot.loadout_widgets[f]
				loadout_widgets.weapon_widget.content.visible = is_active
				loadout_widgets.text_widget.content.visible = is_active
			end
		end
	end
end

LobbyView.trigger_on_exit_animation = function (self)
	LobbyView.super.trigger_on_exit_animation(self)

	if self._preview or type(self._voting_id) ~= "string" then
		return
	end

	local finished, result = Managers.voting:voting_result(self._voting_id)

	if finished and result == "approved" then
		self._is_animating_on_exit = true
		local reference_name = "input_legend"

		self:_remove_element(reference_name)

		self._input_legend_element = nil

		if Managers.ui:view_active(INVENTORY_VIEW_NAME) then
			Managers.ui:close_view(INVENTORY_VIEW_NAME)
		end

		self._show_loadout = false

		for i = 1, #self._spawn_slots do
			local slot = self._spawn_slots[i]
			slot.panel_widget.content.hotspot.disabled = true
		end

		if self._menu_list_widgets then
			for i = 1, #self._menu_list_widgets do
				local widget = self._menu_list_widgets[i]

				self:_unregister_widget_name(widget.name)
			end

			self._menu_list_widgets = nil
			self._menu_list_grid = nil
		end

		self:_play_sound(UISoundEvents.mission_lobby_all_players_ready)
	end
end

LobbyView.on_exit_animation_done = function (self)
	return not self._is_animating_on_exit and self:triggered_on_exit_animation()
end

LobbyView._start_animation_ready = function (self, spawn_slot)
	if not spawn_slot.profile_spawner then
		return
	end

	spawn_slot.profile_spawner:assign_animation_event("ready")
end

LobbyView._start_animation_unready = function (self, spawn_slot)
	if not spawn_slot.profile_spawner then
		return
	end

	spawn_slot.profile_spawner:assign_animation_event("unready")
end

return LobbyView
