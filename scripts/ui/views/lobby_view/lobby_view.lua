-- chunkname: @scripts/ui/views/lobby_view/lobby_view.lua

local definition_path = "scripts/ui/views/lobby_view/lobby_view_definitions"
local Breeds = require("scripts/settings/breed/breeds")
local CharacterSheet = require("scripts/utilities/character_sheet")
local Circumstances = require("scripts/settings/circumstance/circumstance_templates")
local ContentBlueprints = require("scripts/ui/views/lobby_view/lobby_view_content_blueprints")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local LobbyViewTestify = GameParameters.testify and require("scripts/ui/views/lobby_view/lobby_view_testify")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local ProfileUtils = require("scripts/utilities/profile_utils")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local TaskbarFlash = require("scripts/utilities/taskbar_flash")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local Zones = require("scripts/settings/zones/zones")
local INVENTORY_VIEW_NAME = "inventory_background_view"
local SOCIAL_VIEW_NAME = "social_menu_view"
local loadout_presentation_order = {
	"ability",
	"blitz",
	"aura",
}
local class_loadout = {
	ability = {},
	blitz = {},
	aura = {},
}
local loadout_to_type = {
	ability = "ability",
	aura = "aura",
	blitz = "tactical",
}
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
	self._show_weapons = false

	local _unparsed_havoc_data = Managers.mechanism._mechanism._mechanism_data.havoc_data

	if context.debug_preview and context.debug_unparsed_havoc_data then
		_unparsed_havoc_data = context.debug_unparsed_havoc_data
	end

	if _unparsed_havoc_data then
		self._havoc_data = self:_parsed_havoc_data(_unparsed_havoc_data)
	end

	self._slot_changes = false
	self._use_gamepad_tooltip_navigation = false

	local definitions = require(definition_path)
	local level, dynamic_level_package = self:select_target_level()

	self._level = level

	LobbyView.super.init(self, definitions, settings, context, dynamic_level_package)

	self._pass_draw = false
	self._can_exit = not context or context.can_exit
	self._allow_close_hotkey = self._debug_preview

	self:_register_event("event_lobby_vote_started")
end

LobbyView.on_enter = function (self)
	LobbyView.super.on_enter(self)
	self:_setup_menu_list()
	self:_setup_input_legend()
	self:_setup_mission_descriptions()
	self:_setup_havoc_info()

	self._item_definitions = MasterItems.get_cached()

	Managers.frame_rate:request_full_frame_rate("lobby_view")
	TaskbarFlash.flash_window()

	self._item_stats = self:_setup_item_stats("item_stats")
end

LobbyView._parsed_havoc_data = function (self, data)
	local parsed_data = {}
	local split1 = string.split(data, ";")
	local mission = split1[1]

	parsed_data.mission = mission

	local level = tonumber(split1[2])

	parsed_data.level = level

	local circumstances = split1[5]
	local split2 = string.split(circumstances, ":")
	local circumstances_entry = {}

	for i = 1, #split2 do
		circumstances_entry[#circumstances_entry + 1] = split2[i]
	end

	parsed_data.circumstances = circumstances_entry

	return parsed_data
end

LobbyView._setup_havoc_info = function (self)
	local havoc_data = self._havoc_data
	local widgets = self._widgets_by_name

	if not havoc_data then
		widgets.havoc_title.visible = false
		widgets.havoc_circumstance_01.visible = false
		widgets.havoc_circumstance_02.visible = false
		widgets.havoc_circumstance_03.visible = false
		widgets.havoc_circumstance_04.visible = false

		return
	end

	local havoc_title_content = widgets.havoc_title.content

	havoc_title_content.havoc_rank = Utf8.upper(havoc_data.level)

	local num_displayed_mutators = 0

	for i = 1, #havoc_data.circumstances do
		num_displayed_mutators = num_displayed_mutators + 1

		local circumstance_data = havoc_data.circumstances[i]
		local circumstance_template = Circumstances[circumstance_data]
		local circumstance_ui_settings = circumstance_template.ui
		local widget_name = "havoc_circumstance_0" .. i
		local widget = self._widgets_by_name[widget_name]
		local widget_content = widget.content

		widget.offset[2] = (i - 1) * 113
		widget_content.icon = circumstance_ui_settings.icon
		widget_content.circumstance_name = Localize(circumstance_ui_settings.display_name)
		widget_content.circumstance_description = Localize(circumstance_ui_settings.description)
	end

	if num_displayed_mutators ~= 4 then
		for i = num_displayed_mutators + 1, 4 do
			local widget_name = "havoc_circumstance_0" .. i
			local widget = self._widgets_by_name[widget_name]

			widget.visible = false
		end
	end
end

LobbyView.select_target_level = function (self)
	local level_name

	level_name = self._havoc_data and "havoc" or self._mission_data and self._mission_data.mission_name == "psykhanium" and "horde" or "default"

	local level = LobbyViewSettings.levels_by_id[level_name] or LobbyViewSettings.levels_by_id.default
	local level_packages = {
		is_level_package = true,
		name = level.level_name,
	}

	return level, level_packages
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

	local level_name
	local target_level = self._level

	level_name = self._level.level_name

	self._world_spawner:spawn_level(level_name)

	self._world_initialized = true
end

LobbyView.event_register_lobby_camera = function (self, camera_unit)
	self:_unregister_event("event_register_lobby_camera")

	local viewport_name = LobbyViewSettings.viewport_name
	local viewport_type = LobbyViewSettings.viewport_type
	local viewport_layer = LobbyViewSettings.viewport_layer
	local shading_environment = self._level.shading_environment

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
		local circumstance_name

		if mission_data.circumstance_name ~= "default" then
			local ui_settings = Circumstances[mission_data.circumstance_name].ui

			if ui_settings then
				circumstance_name = ui_settings and self:_localize(ui_settings.display_name) or mission_data.circumstance_name
			end
		end

		local sub_title = mission_type_name and self:_localize(mission_type_name) or ""

		sub_title = zone_display_name and sub_title .. " · " .. self:_localize(zone_display_name) or sub_title
		sub_title = circumstance_name and sub_title .. " · " .. circumstance_name or sub_title

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
			local text

			if current_ready_status then
				text = self:_localize("loc_lobby_entry_unready")
			else
				text = self:_localize("loc_lobby_entry_ready")
			end

			local widget_content = widget.content

			widget_content.original_text = text
			widget_content.active = current_ready_status
			widget_content.gamepad_action = "confirm_pressed"

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
		end,
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

LobbyView._remove_input_legend = function (self)
	local reference_name = "input_legend"

	if self._input_legend_element then
		self:_remove_element(reference_name)

		self._input_legend_element = nil
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

LobbyView._reset_loadout_widgets_navigation = function (self)
	if self._loadout_widgets_for_navigation then
		for i = 1, #self._loadout_widgets_for_navigation do
			local widget = self._loadout_widgets_for_navigation[i]

			if widget and widget ~= false then
				widget.content.hotspot.is_selected = false
			end
		end

		self._loadout_widget_navigation_index = nil
	end
end

LobbyView.cb_on_loadout_pressed = function (self)
	self._show_weapons = not self._show_weapons

	self:_reset_loadout_widgets_navigation()
	self:_update_loadout_widgets_for_navigation()
end

LobbyView.cb_on_trigger_gamepad_tooltip_navigation_pressed = function (self)
	self._use_gamepad_tooltip_navigation = not self._use_gamepad_tooltip_navigation

	self:_reset_loadout_widgets_navigation()
	self:_update_loadout_widgets_for_navigation()
end

LobbyView._update_loadout_widgets_for_navigation = function (self)
	local available_widgets = {}
	local weapon_count = 2
	local talent_count = 3

	for i = 1, #self._spawn_slots do
		local slot = self._spawn_slots[i]

		if self._show_weapons then
			for f = 1, weapon_count do
				local index = (i - 1) * weapon_count + f

				available_widgets[index] = false

				if slot.occupied and slot.weapon_widgets[f] and slot.weapon_widgets[f].content.slot then
					available_widgets[index] = slot.weapon_widgets[f]
				end
			end
		else
			for f = 1, talent_count do
				if slot.occupied then
					local index = (i - 1) * talent_count + f

					available_widgets[index] = false

					if slot.talent_widgets[f] and slot.talent_widgets[f].content.loadout_id then
						available_widgets[index] = slot.talent_widgets[f]
					end
				end
			end
		end
	end

	self._loadout_widgets_for_navigation = available_widgets

	if self._loadout_widget_navigation_index and not available_widgets[self._loadout_widget_navigation_index] then
		self._loadout_widget_navigation_index = nil
	end

	if not self._using_cursor_navigation and self._use_gamepad_tooltip_navigation and not self._loadout_widget_navigation_index then
		for i = 1, #self._loadout_widgets_for_navigation do
			local widget = self._loadout_widgets_for_navigation[i]

			if widget and widget ~= false then
				self._loadout_widget_navigation_index = i
				widget.content.hotspot.is_selected = true

				break
			end
		end
	end
end

LobbyView._next_loadout_widgets_for_navigation = function (self)
	if not self._loadout_widgets_for_navigation then
		return
	end

	local current_index = self._loadout_widget_navigation_index or 0
	local start_index = math.clamp(current_index + 1, 1, #self._loadout_widgets_for_navigation)

	for i = start_index, #self._loadout_widgets_for_navigation do
		local widget = self._loadout_widgets_for_navigation[i]

		if widget and widget ~= false then
			self._loadout_widget_navigation_index = i

			break
		end
	end

	if not self._using_cursor_navigation and self._use_gamepad_tooltip_navigation then
		for i = 1, #self._loadout_widgets_for_navigation do
			local widget = self._loadout_widgets_for_navigation[i]

			if widget and widget ~= false then
				widget.content.hotspot.is_selected = i == self._loadout_widget_navigation_index
			end
		end
	end
end

LobbyView._prev_loadout_widgets_for_navigation = function (self)
	if not self._loadout_widgets_for_navigation then
		return
	end

	local current_index = self._loadout_widget_navigation_index or 0
	local start_index = math.clamp(current_index - 1, 1, #self._loadout_widgets_for_navigation)

	for i = start_index, 1, -1 do
		local widget = self._loadout_widgets_for_navigation[i]

		if widget and widget ~= false then
			self._loadout_widget_navigation_index = i

			break
		end
	end

	if not self._using_cursor_navigation and self._use_gamepad_tooltip_navigation then
		for i = 1, #self._loadout_widgets_for_navigation do
			local widget = self._loadout_widgets_for_navigation[i]

			if widget and widget ~= false then
				widget.content.hotspot.is_selected = i == self._loadout_widget_navigation_index
			end
		end
	end
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
			update_function = entry_config.update_function,
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
		local widget
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
			size = size,
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

		profile_spawner:disable_rotation_input()

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
			weapon_widgets = {},
			talent_widgets = {},
		}

		spawn_slots[i] = spawn_slot

		local widget_offset_x = 300 + (i - 1) * 320

		spawn_slot.panel_widget.offset[1] = widget_offset_x
		spawn_slot.loading_widget.offset[1] = widget_offset_x
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
	return self._can_exit and self._navigation_state == "menu" or self._debug_preview
end

LobbyView.on_exit = function (self)
	self:_destroy_spawn_slots()

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._entered then
		Managers.frame_rate:relinquish_request("lobby_view")
	end

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

		self:_update_player_slots(dt, t, input_service)

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

		self:_update_loadout_widgets_for_navigation()
	end

	self:_check_loadout_changes()
	self:_set_weapons_visibility()

	self._is_main_menu_open = Managers.ui:view_active("system_view")

	if self._is_animating_on_exit == true then
		self._is_animating_on_exit = self:_all_ready_countdown(dt)
	end

	if self._tooltip_draw_delay and self._tooltip_draw_delay > 0 then
		self._tooltip_draw_delay = self._tooltip_draw_delay - dt

		if not self._show_weapons then
			self._tooltip_alpha_multiplier = math.clamp((self._tooltip_alpha_multiplier or 0) + dt * LobbyViewSettings.tooltip_fade_speed, 0, 1)
			self._widgets_by_name.talent_tooltip.alpha_multiplier = self._tooltip_alpha_multiplier
		end

		if self._tooltip_draw_delay <= 0 then
			self._tooltip_draw_delay = 0

			if self._show_weapons then
				self._item_stats:set_visibility(true)
			end
		end
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

	if self._loadout_widgets_for_navigation then
		if not self._using_cursor_navigation then
			self._use_gamepad_tooltip_navigation = false
			self._loadout_widget_navigation_index = nil
		else
			self:_reset_loadout_widgets_navigation()
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

	if self._world_initialized and not is_mouse then
		if self._use_gamepad_tooltip_navigation then
			if input_service:get("navigate_left_continuous") then
				self:_prev_loadout_widgets_for_navigation()
			elseif input_service:get("navigate_right_continuous") then
				self:_next_loadout_widgets_for_navigation()
			end
		end

		if not self._menu_list_grid:selected_grid_index() and not self:_is_slot_focused() then
			self._menu_list_grid:select_last_index(true)
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
	local breed_name = archetype_settings and archetype_settings.breed or profile.breed
	local spawn_point_unit

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

	local panel_widget = slot.panel_widget
	local panel_content = panel_widget.content
	local character_name = player:name()
	local character_archetype_title = ProfileUtils.character_archetype_title(profile)
	local character_level = tostring(profile.current_level) .. " "

	panel_content.character_archetype_title = character_archetype_title

	local player_title = ProfileUtils.character_title(profile)

	if player_title and player_title ~= "" then
		panel_content.character_title = player_title
		panel_widget.style.character_name.offset[2] = LobbyViewSettings.character_name_y_offset
		panel_widget.style.character_archetype_title.offset[2] = LobbyViewSettings.character_archetype_title_y_offset
	else
		panel_widget.style.character_name.offset[2] = LobbyViewSettings.character_name_y_offset_no_title
		panel_widget.style.character_archetype_title.offset[2] = LobbyViewSettings.character_archetype_title_y_offset_no_title
	end

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
		"slot_secondary",
	}
	local seed = _generate_seed(unique_id, self._mission_data.backend_mission_id)
	local _, random_slot = math.next_random(seed, 1, #weapon_slots)

	slot.default_slot = weapon_slots[random_slot]
	panel_content.character_name = string.format("%s %s", character_level, character_name)

	profile_spawner:wield_slot(slot_name)
	self:_request_player_icon(slot)
end

LobbyView._cb_set_player_frame = function (self, widget, item)
	local material_values = widget.style.character_portrait.material_values

	material_values.portrait_frame_texture = item.icon
end

LobbyView._cb_set_player_insignia = function (self, widget, item)
	local icon_style = widget.style.character_insignia
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		widget.content.old_character_insignia = widget.content.character_insignia
		widget.content.character_insignia = item.icon_material

		if material_values.texture_map then
			material_values.texture_map = nil
		end
	else
		if widget.content.old_character_insignia then
			widget.content.character_insignia = widget.content.old_character_insignia
			widget.content.old_character_insignia = nil
		end

		material_values.texture_map = item.icon
	end

	icon_style.color[1] = 255
end

LobbyView._request_player_icon = function (self, slot)
	if slot.icon_load_id then
		self:_unload_portrait_icon(slot)
	end

	local panel_widget = slot.panel_widget
	local panel_style = panel_widget.style
	local material_values = panel_style.character_portrait.material_values

	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon(slot)
end

LobbyView._load_portrait_icon = function (self, slot)
	local profile = slot.profile
	local load_cb = callback(self, "_cb_set_player_icon", slot)
	local unload_cb = callback(self, "_cb_unset_player_icon", slot)
	local icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)

	slot.icon_load_id = icon_load_id

	local loadout = slot.profile.loadout
	local panel_widget = slot.panel_widget
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

	local widget = slot.panel_widget

	widget.style.character_insignia.color[1] = 0

	if widget.content.old_character_insignia then
		widget.content.character_insignia = widget.content.old_character_insignia
		widget.content.old_character_insignia = nil
	end
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

	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base"

	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

LobbyView._cb_unset_player_icon = function (self, slot)
	local widget = slot.panel_widget
	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base_no_render"
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
		local hovered_slot, hovered_item, hovered_talent

		for i = 1, num_slots do
			local is_even = i % 2 == 0
			local slot = spawn_slots[i]
			local occupied = slot.occupied
			local still_alive = not not Managers.player:player_from_unique_id(slot.unique_id)
			local boxed_initial_position = slot.boxed_initial_position
			local boxed_position = slot.boxed_position
			local position = occupied and Vector3.from_array(boxed_position) or Vector3.from_array(boxed_initial_position)
			local panel_widget = slot.panel_widget
			local loading_widget = slot.loading_widget
			local widget_offset_x = slot.panel_widget.offset[1] - 30

			for f = 1, #slot.weapon_widgets do
				local weapon_widget = slot.weapon_widgets[f]

				weapon_widget.offset[1] = weapon_widget.original_offset[1] + widget_offset_x + 35
			end

			for f = 1, #slot.talent_widgets do
				local talent_widget = slot.talent_widgets[f]

				talent_widget.offset[1] = talent_widget.original_offset[1] + widget_offset_x + 35
			end

			local profile_spawner = slot.profile_spawner

			if occupied and profile_spawner:spawned() then
				profile_spawner:set_position(position)
				UIWidget.draw(panel_widget, ui_renderer)

				if self._show_weapons then
					for f = 1, #slot.weapon_widgets do
						local weapon_widget = slot.weapon_widgets[f]

						UIWidget.draw(weapon_widget, ui_renderer)

						local is_hover = not hovered_slot and weapon_widget.content.hotspot and (weapon_widget.content.hotspot.is_hover or weapon_widget.content.hotspot.is_selected)

						if is_hover then
							hovered_slot = slot

							local item = weapon_widget.content.item

							hovered_item = item
							self._hovered_tooltip_panel_widget = panel_widget
						end
					end
				else
					for f = 1, #slot.talent_widgets do
						local talent_widget = slot.talent_widgets[f]

						UIWidget.draw(talent_widget, ui_renderer)

						local is_hover = not hovered_slot and talent_widget.content.hotspot and (talent_widget.content.hotspot.is_hover or talent_widget.content.hotspot.is_selected)

						if is_hover and still_alive then
							hovered_slot = slot

							local profile = slot.player:profile()

							CharacterSheet.class_loadout(profile, class_loadout)

							local loadout_id = talent_widget.content.loadout_id
							local loadout = class_loadout[loadout_id]

							hovered_talent = {
								talent = loadout.talent,
								loadout_id = loadout_id,
								slot = i,
							}
							self._hovered_tooltip_panel_widget = panel_widget
						end
					end
				end
			else
				UIWidget.draw(loading_widget, ui_renderer)
			end
		end

		if hovered_item or hovered_talent then
			if self._show_weapons then
				if not self._currently_hovered_item or hovered_item.gear_id ~= self._currently_hovered_item.gear_id then
					self:_on_tooltip_hover_stop()
					self:_on_tooltip_hover_start(hovered_slot, hovered_item)
				end
			elseif not self._hovered_slot_talent_data or self._hovered_slot_talent_data and (hovered_talent.slot ~= self._hovered_slot_talent_data.slot or hovered_talent.loadout_id ~= self._hovered_slot_talent_data.loadout_id) then
				self:_on_tooltip_hover_stop()
				self:_on_tooltip_hover_start(hovered_slot, hovered_talent)
			end
		elseif self._currently_hovered_item or self._hovered_slot_talent_data then
			self._hovered_tooltip_panel_widget = nil

			self:_on_tooltip_hover_stop()
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
		is_readonly = slot.ready,
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
	local talents

	for i = 1, #self._spawn_slots do
		local spawn_slot = self._spawn_slots[i]

		if spawn_slot.occupied then
			local profile = spawn_slot.player:profile()
			local changed_weapons = false
			local changed_talents = false
			local changed_cosmetics = false
			local weapon_slots = {
				"slot_primary",
				"slot_secondary",
			}

			for f = 1, #weapon_slots do
				local slot_name = weapon_slots[f]

				if profile.loadout[slot_name] and spawn_slot[slot_name] ~= profile.loadout[slot_name] then
					changed_weapons = true

					break
				end
			end

			local cosmetic_slots = {
				"slot_insignia",
				"slot_gear_head",
				"slot_portrait_frame",
			}

			for f = 1, #cosmetic_slots do
				local slot_name = cosmetic_slots[f]

				if profile.loadout[slot_name] and spawn_slot.profile.loadout[slot_name] ~= profile.loadout[slot_name] then
					changed_cosmetics = true

					break
				end
			end

			CharacterSheet.class_loadout(profile, class_loadout)

			if not table.is_empty(spawn_slot.talent_widgets) then
				for f = 1, #spawn_slot.talent_widgets do
					local talent_widget = spawn_slot.talent_widgets[f]
					local loadout_id = talent_widget.content.loadout_id
					local icon = talent_widget.content.icon

					if class_loadout[loadout_id].icon ~= icon then
						changed_talents = true

						break
					end
				end
			else
				changed_talents = true
			end

			if changed_weapons or changed_talents or changed_cosmetics then
				spawn_slot.profile = profile

				if changed_weapons then
					self:_setup_weapon_widgets(spawn_slot)
				end

				if changed_talents then
					self:_setup_talents_widgets(spawn_slot)
				end

				if changed_cosmetics then
					self:_request_player_icon(spawn_slot)
				end

				self:_update_loadout_widgets_for_navigation()
			end
		end
	end
end

LobbyView._setup_talents_widgets = function (self, spawn_slot)
	local margin = 10
	local start_margin = 25
	local search_slot = {
		{
			id = "talent_1",
			offset_height = 0,
			size = ContentBlueprints.talent.size,
			offset_width = start_margin,
		},
		{
			id = "talent_2",
			offset_height = 0,
			size = ContentBlueprints.talent.size,
			offset_width = start_margin + ContentBlueprints.talent.size[1] + margin,
		},
		{
			id = "talent_3",
			offset_height = 0,
			size = ContentBlueprints.talent.size,
			offset_width = start_margin + (ContentBlueprints.talent.size[1] + margin) * 2,
		},
	}
	local ui_renderer = self._ui_renderer
	local scenegraph_id = "loadout"
	local profile = spawn_slot.player:profile()

	for i = 1, #spawn_slot.talent_widgets do
		local talent_widgets = spawn_slot.talent_widgets[i]

		self:_unregister_widget_name(talent_widgets.name)
	end

	CharacterSheet.class_loadout(profile, class_loadout)

	local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type

	for i = 1, #search_slot do
		local data = search_slot[i]
		local loadout_id = loadout_presentation_order[i]
		local loadout = class_loadout[loadout_id]
		local node_type = loadout_to_type[loadout_id]
		local template = ContentBlueprints.talent
		local node_type_settings = settings_by_node_type[node_type]
		local config = {
			loadout = loadout,
			node_type_settings = node_type_settings,
			loadout_id = loadout_id,
		}
		local size = template.size or data.size
		local pass_template_function = template.pass_template_function
		local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
		local optional_style = template.style or {}
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

		if widget_definition then
			local name_talent = string.format("slot_%s_%s", spawn_slot.index, data.id)
			local talent_widget = self:_create_widget(name_talent, widget_definition)
			local init = template.init

			if init then
				init(self, talent_widget, config)
			end

			local offset_height = data.offset_height
			local offset_width = data.offset_width

			talent_widget.original_offset = {
				offset_width,
				offset_height,
				0,
			}
			talent_widget.offset = {
				offset_width,
				offset_height,
				0,
			}
			spawn_slot.talent_widgets[i] = talent_widget
		end
	end
end

LobbyView._setup_weapon_widgets = function (self, spawn_slot)
	local profile = spawn_slot.player:profile()
	local size = {
		370,
		0,
	}
	local margin = 10
	local margin_large = (UISettings.weapon_icon_size[1] * 2 + margin - 450) * 0.5
	local gadget_size = UISettings.weapon_icon_size[1] / 3 - margin * 2 / 3
	local search_slot = {
		{
			id = "slot_primary",
			offset_height = 0,
			offset_width = 0,
			size = ContentBlueprints.item_icon.size,
		},
		{
			id = "slot_secondary",
			offset_height = 0,
			size = ContentBlueprints.item_icon.size,
			offset_width = ContentBlueprints.item_icon.size[1] + margin,
		},
	}
	local ui_renderer = self._ui_renderer
	local scenegraph_id = "loadout"

	for i = 1, #spawn_slot.weapon_widgets do
		local weapon_widget = spawn_slot.weapon_widgets[i]

		self:_unregister_widget_name(weapon_widget.name)
	end

	spawn_slot.weapon_widgets = {}

	for i = 1, #search_slot do
		local data = search_slot[i]
		local slot = data.id
		local loadout = profile.loadout[slot]
		local template = ContentBlueprints.item_icon
		local config = {
			item = loadout,
			slot = slot,
		}
		local size = data.size
		local pass_template_function = template.pass_template_function
		local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
		local optional_style = template.style or {}
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

		if widget_definition then
			local name_weapon = string.format("loadout_%s_%s", spawn_slot.index, slot)
			local weapon_widget = self:_create_widget(name_weapon, widget_definition)
			local init = template.init

			if init then
				init(self, weapon_widget, config)
			end

			local offset_height = data.offset_height
			local offset_width = data.offset_width

			weapon_widget.original_offset = {
				offset_width,
				offset_height,
				0,
			}
			weapon_widget.offset = {
				offset_width,
				offset_height,
				0,
			}
			spawn_slot.weapon_widgets[#spawn_slot.weapon_widgets + 1] = weapon_widget
			spawn_slot[slot] = loadout
		end
	end

	spawn_slot.profile_spawner:destroy()

	local archetype_settings = profile.archetype
	local breed_name = archetype_settings and archetype_settings.breed or profile.breed
	local spawn_point_unit

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
	self:_update_presentation_wield_item(spawn_slot)
	spawn_slot.profile_spawner:wield_slot(slot_name)
end

LobbyView._set_weapons_visibility = function (self)
	local is_active = self._show_weapons
	local loadout_size = LobbyViewSettings.loadout_size
	local panel_size = LobbyViewSettings.panel_size

	for ii = 1, #self._spawn_slots do
		local slot = self._spawn_slots[ii]

		if slot.occupied then
			for jj = 1, #slot.weapon_widgets do
				local weapon_widgets = slot.weapon_widgets[jj]

				weapon_widgets.content.visible = is_active
			end

			for jj = 1, #slot.talent_widgets do
				local talent_widget = slot.talent_widgets[jj]

				talent_widget.content.visible = not is_active
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

		self:_remove_input_legend()

		if Managers.ui:view_active(INVENTORY_VIEW_NAME) then
			Managers.ui:close_view(INVENTORY_VIEW_NAME)
		end

		if Managers.ui:view_active(SOCIAL_VIEW_NAME) then
			Managers.ui:close_view(SOCIAL_VIEW_NAME)
		end

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

LobbyView._update_presentation_wield_item = function (self, spawn_slot)
	if not spawn_slot.profile_spawner then
		return
	end

	local slot_name = spawn_slot.default_slot
	local slot_item = spawn_slot.profile.loadout[slot_name]

	spawn_slot.profile_spawner:wield_slot(slot_name)

	local item_inventory_animation_event = slot_item and slot_item.inventory_animation_event or "inventory_idle_default"

	if item_inventory_animation_event then
		spawn_slot.profile_spawner:assign_animation_event(item_inventory_animation_event)
	end
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

local dummy_tooltip_text_size = {
	400,
	20,
}

LobbyView._setup_tooltip_info = function (self, talent_hover_data)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.talent_tooltip
	local content = widget.content
	local style = widget.style

	content.title = "title"
	content.description = "<<UNASSIGNED TALENT NODE>>"

	local talent = talent_hover_data.talent

	if talent then
		local text_vertical_offset = 14
		local points_spent = 1
		local node_type = loadout_to_type[talent_hover_data.loadout_id]
		local node_settings = TalentBuilderViewSettings.settings_by_node_type[node_type]

		content.talent_type_title = Localize(node_settings.display_name) or ""

		local talent_type_title_height = self:_get_text_height(content.talent_type_title, style.talent_type_title, dummy_tooltip_text_size)

		style.talent_type_title.offset[2] = text_vertical_offset
		style.talent_type_title.size[2] = talent_type_title_height
		text_vertical_offset = text_vertical_offset + talent_type_title_height

		local description = TalentLayoutParser.talent_description(talent, points_spent, Color.ui_terminal(255, true))
		local localized_title = self:_localize(talent.display_name)

		content.title = localized_title
		content.description = description

		local widget_width, _ = self:_scenegraph_size(widget.scenegraph_id, self._ui_scenegraph)
		local text_size_addition = style.title.size_addition

		dummy_tooltip_text_size[1] = widget_width + text_size_addition[1]

		local title_height = self:_get_text_height(content.title, style.title, dummy_tooltip_text_size)

		style.title.offset[2] = text_vertical_offset
		style.title.size[2] = title_height
		text_vertical_offset = text_vertical_offset + title_height + 10

		local description_height = self:_get_text_height(content.description, style.description, dummy_tooltip_text_size)

		style.description.offset[2] = text_vertical_offset
		style.description.size[2] = description_height
		text_vertical_offset = text_vertical_offset + description_height
		content.exculsive_group_description = ""
		text_vertical_offset = text_vertical_offset + 20

		self:_set_scenegraph_size(widget.scenegraph_id, nil, text_vertical_offset, self._ui_scenegraph)
	end
end

LobbyView._get_text_height = function (self, text, text_style, optional_text_size)
	local ui_renderer = self._ui_renderer
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, optional_text_size or text_style.size, text_options)

	return text_height
end

LobbyView._update_talent_tooltip_position = function (self)
	local widgets_by_name = self._widgets_by_name
	local hovered_tooltip_panel_widget = self._hovered_tooltip_panel_widget

	if hovered_tooltip_panel_widget then
		local ui_scenegraph = self._ui_scenegraph
		local panel_scenegraph_id = hovered_tooltip_panel_widget.scenegraph_id
		local panel_scenegraph_world_position = self:_scenegraph_world_position(panel_scenegraph_id)
		local panel_offset = hovered_tooltip_panel_widget.offset
		local tooltip_widget = widgets_by_name.talent_tooltip
		local tooltip_offset = tooltip_widget.offset
		local panel_width, panel_height = self:_scenegraph_size(panel_scenegraph_id, ui_scenegraph)
		local tooltip_width, tooltip_height = self:_scenegraph_size(tooltip_widget.scenegraph_id, ui_scenegraph)

		tooltip_offset[1] = panel_scenegraph_world_position[1] + panel_offset[1] + panel_width * 0.5 - tooltip_width * 0.5
		tooltip_offset[2] = panel_scenegraph_world_position[2] + panel_height - tooltip_height - 40
	end
end

LobbyView._setup_item_stats = function (self, reference_name)
	local layer = 10
	local context = self._definitions.item_stats_grid_settings
	local item_stats = self:_add_element(ViewElementWeaponStats, reference_name, layer, context)

	return item_stats
end

LobbyView._update_item_stats_position = function (self, width, height)
	self:_set_scenegraph_position("item_stats_pivot", width, height)

	local position = self._ui_scenegraph.item_stats_pivot.position

	self._item_stats:set_pivot_offset(position[1], position[2])
end

LobbyView._on_tooltip_hover_start = function (self, slot, data)
	if self._show_weapons then
		local item = data

		self._currently_hovered_item = item

		if self._item_stats then
			self._item_stats:present_item(item)
		end

		local context = self._definitions.item_stats_grid_settings
		local total_width = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
		local margin_from_bottom = 160
		local default_width = 1920
		local margin_from_left = (total_width - default_width) * 0.5 * RESOLUTION_LOOKUP.scale
		local width = (margin_from_left + (slot.panel_widget.offset[1] - context.grid_size[1] * 0.5) * RESOLUTION_LOOKUP.scale) * RESOLUTION_LOOKUP.inverse_scale
		local height = (RESOLUTION_LOOKUP.height - (margin_from_bottom + self._item_stats:grid_height()) * RESOLUTION_LOOKUP.scale) * RESOLUTION_LOOKUP.inverse_scale

		self._item_stats:set_visibility(false)
		self:_update_item_stats_position(width, height)

		self._tooltip_draw_delay = 0.1
	else
		local loadout = data

		self._hovered_slot_talent_data = loadout

		self:_setup_tooltip_info(loadout)
		self:_update_talent_tooltip_position()

		local widgets_by_name = self._widgets_by_name

		widgets_by_name.talent_tooltip.content.visible = true
		widgets_by_name.talent_tooltip.alpha_multiplier = 0
		self._tooltip_alpha_multiplier = 0
		self._tooltip_draw_delay = LobbyViewSettings.tooltip_fade_delay
	end
end

LobbyView._on_tooltip_hover_stop = function (self)
	self._currently_hovered_item = nil
	self._hovered_slot_talent_data = nil

	if self._item_stats then
		self._item_stats:stop_presenting()
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.talent_tooltip.content.visible = false
	widgets_by_name.talent_tooltip.alpha_multiplier = 0
	self._tooltip_draw_delay = 0
	self._tooltip_alpha_multiplier = 0
end

return LobbyView
