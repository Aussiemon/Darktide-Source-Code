-- chunkname: @scripts/ui/views/mission_board_view_pj/mission_board_view.lua

local MissionBoardViewDefinitions = require("scripts/ui/views/mission_board_view_pj/mission_board_view_definitions")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view_pj/mission_board_view_settings")
local MissionBoardViewStyles = require("scripts/ui/views/mission_board_view_pj/mission_board_view_styles")
local MissionBoardViewLogic = require("scripts/ui/views/mission_board_view_pj/mission_board_view_logic")
local MissionBoardViewThemes = require("scripts/ui/views/mission_board_view_pj/mission_board_view_themes")
local Blueprints = require("scripts/ui/view_content_blueprints/mission_tile_blueprints/mission_tile_blueprints")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Danger = require("scripts/utilities/danger")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local CampaignSettings = require("scripts/settings/campaign/campaign_settings")
local InputDevice = require("scripts/managers/input/input_device")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local TextUtils = require("scripts/utilities/ui/text")
local InputUtils = require("scripts/managers/input/input_utils")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local Settings = MissionBoardViewSettings
local Styles = MissionBoardViewStyles
local Dimensions = Settings.dimensions
local ScreenEffectSettings = Settings.on_screen_effect_settings
local ViewElements = Settings.view_elements
local Elements = {}

for _, element in pairs(ViewElements) do
	local elem

	if element.file_path then
		elem = require(element.file_path)
	end

	Elements[element.name] = elem
end

local function _character_level()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local player_profile = player:profile()

	return player_profile.current_level
end

local function _text_height(ui_renderer, text, style, optional_size)
	local optional_size = optional_size or {
		0,
		2000,
	}
	local font_options = UIFonts.get_font_options_by_style(style)
	local _, height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, optional_size, font_options)

	return height
end

local MissionBoardView = class("MissionBoardView", "BaseView")

MissionBoardView.init = function (self, settings, context)
	MissionBoardView.super.init(self, MissionBoardViewDefinitions, settings, context)

	self._filtered_missions = {}
	self._mission_widgets = {}
	self._objectives_tabs = {}
	self._reward_widgets = {}
	self._used_slots = {}
	self._sidebar_blocks = {}
	self._sidebar_key_is_active = {}
	self._current_tab_name = nil
	self.can_start_mission = false
	self._gamepad_cursor_current_pos = Vector3Box(960, 540)
	self._gamepad_cursor_current_vel = Vector3Box()
	self._gamepad_cursor_target_pos = Vector3Box()
	self._gamepad_cursor_average_vel = Vector3Box()
	self._gamepad_cursor_snap_delay = 0
	self._issues = {}
	self._current_issue_key = nil
	self._camera_rotation = 0
	self._target_rotation = 0
	self._rotation_speed = 0
	self._camera_zoom = 0
	self._target_zoom = 0
	self._zoom_speed = 0
	self._element_layer = 10
end

MissionBoardView.on_enter = function (self)
	MissionBoardView.super.on_enter(self)
	Managers.event:register(self, "event_register_camera", "event_register_camera")
	Managers.event:register(self, "event_register_camera_02", "event_register_camera_02")
	Managers.event:register(self, "event_mission_board_mission_tile_pressed", "event_mission_board_mission_tile_pressed")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings

	self._world_spawner = UIWorldSpawner:new(world_spawner_settings.world_name, world_spawner_settings.world_layer, world_spawner_settings.world_timer_name, self.view_name)

	self._world_spawner:spawn_level(world_spawner_settings.level_name)

	for _, element in pairs(ViewElements) do
		local element_name = element.name
		local element_class = element.class
		local element_context = element.context or {}
		local load_on_enter = element.load_on_enter or false

		if load_on_enter then
			local elem = Elements[element_name]

			self:_add_element(elem, element_name, self._element_layer)

			self._element_layer = self._element_layer + 10
		end
	end

	local input_legend_element = self:_element("input_legend")
	local legend_inputs = ViewElements.input_legend.context.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end

	self:on_resolution_modified(self._render_scale)

	local player = self:_player()
	local mission_board_logic_context = {
		player = player,
		view_name = self.view_name,
	}

	self._mission_board_logic = MissionBoardViewLogic:new(mission_board_logic_context)

	local party_manager = Managers.party_immaterium

	self._party_manager = party_manager

	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	self:_update_play_button_game_mode_text()
	self:_mark_info_panel_dirty(true)

	self._hologram_unit = self:_get_hologram_unit()

	local on_screen_effect_id = World.create_particles(self._world_spawner._world, ScreenEffectSettings.on_screen_effect, Vector3(0, 0, 1))

	self._on_screen_effect_id = on_screen_effect_id
end

MissionBoardView._update_play_button_game_mode_text = function (self)
	local is_private_match = self._mission_board_logic:is_private_match()
	local public_game = not is_private_match
	local play_button_legend_content = self._widgets_by_name.play_button_legend.content

	if public_game then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	else
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

MissionBoardView._page_is_unlocked = function (self, page_index)
	local page_settings = self._page_settings[page_index]

	if not page_settings then
		return false
	end

	return page_settings.check_unlocked and page_settings.check_unlocked(self) or page_settings.is_unlocked
end

MissionBoardView._has_active_campaign_missions = function (self, filtered_missions)
	local has_active_campaign_mission = false
	local active_mission_id
	local filtered_missions = filtered_missions or self._filtered_missions
	local story_missions = self._mission_board_logic:_get_missions_per_category("story")

	for id, mission_data in pairs(filtered_missions) do
		local category = mission_data.category

		if category == "story" then
			local key = mission_data.map
			local progression_data = story_missions[key]

			if progression_data.unlocked and not progression_data.completed then
				has_active_campaign_mission = true
				active_mission_id = id

				return has_active_campaign_mission, active_mission_id
			end
		end
	end

	return has_active_campaign_mission, active_mission_id
end

MissionBoardView.get_selected_mission_id = function (self)
	return self._selected_mission_id
end

MissionBoardView.set_selected_mission_id = function (self, mission_id)
	self._selected_mission_id = mission_id
end

MissionBoardView._get_last_unlocked_page = function (self)
	local at = #self._page_settings

	while at >= 1 and not self:_page_is_unlocked(at) do
		at = at - 1
	end

	return at
end

MissionBoardView._request_next_page = function (self)
	self._mission_board_logic:request_next_page()
end

MissionBoardView._request_prev_page = function (self)
	self._mission_board_logic:request_prev_page()
end

MissionBoardView._request_page_at = function (self, index)
	self._mission_board_logic:request_page_at(index)
end

MissionBoardView._get_ui_theme = function (self, optional_name)
	local theme_name = optional_name or self._ui_theme
	local theme = MissionBoardViewThemes[theme_name]

	if not theme then
		Log.warning("MissionBoardView", "No theme with name '%s'. Using default.", theme_name)

		return MissionBoardViewThemes.default
	end

	return theme
end

MissionBoardView._change_ui_theme = function (self, new_theme_name)
	local curr_theme_name = self._ui_theme

	if curr_theme_name == new_theme_name then
		return
	end

	local widgets = self._widgets
	local widget_count = #widgets
	local old_theme_definitions = self:_get_ui_theme(curr_theme_name).widgets

	for i = widget_count, 1, -1 do
		local widget_name = widgets[i].name

		if old_theme_definitions[widget_name] then
			self:_unregister_widget_name(widget_name)

			widgets[i] = widgets[widget_count]
			widgets[widget_count] = nil
			widget_count = widget_count - 1
		end
	end

	local new_theme_definitions = self:_get_ui_theme(new_theme_name).widgets

	for widget_name, widget_definition in pairs(new_theme_definitions) do
		widget_count = widget_count + 1
		widgets[widget_count] = self:_create_widget(widget_name, widget_definition)
	end

	self._ui_theme = new_theme_name
end

MissionBoardView._open_current_page = function (self)
	if not self._page_settings or table.is_empty(self._page_settings) then
		return
	end

	local page_index = self._page_index
	local page_settings = self._mission_board_logic:get_current_page(page_index)

	self:_change_ui_theme(page_settings.ui_theme)

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.gamepad_cursor.visible = InputDevice.gamepad_active
	widgets_by_name.play_button.content.hotspot.pressed_callback = callback(self, "_callback_start_selected_mission")

	local quick_play_settings = page_settings.qp

	if quick_play_settings then
		self:_set_quickplay_widget()
	elseif widgets_by_name.qp_mission_widget then
		self:_remove_mission_widget(widgets_by_name.qp_mission_widget)
	end

	self._page_index = page_index

	self:_update_difficulty_stepper(page_index)
	self._mission_board_logic:refresh_filtered_missions()
	self:_refresh_issue()
end

MissionBoardView.on_exit = function (self)
	if self._on_screen_effect_id then
		World.destroy_particles(self._world_spawner._world, self._on_screen_effect_id)

		self._on_screen_effect_id = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:release_listener()
		world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._mission_board_logic then
		self._mission_board_logic:destroy()

		self._mission_board_logic = nil
	end

	Managers.event:unregister(self, "event_mission_board_mission_tile_pressed")
	MissionBoardView.super.on_exit(self)
end

MissionBoardView._claim_slot = function (self, slot_group, mission_category)
	local current_theme = self:_get_ui_theme()
	local _used_slots = self._used_slots

	_used_slots[slot_group] = _used_slots[slot_group] or {}

	local used_slots = _used_slots[slot_group]
	local theme_slots = current_theme.slots[slot_group]
	local slot_count = theme_slots and #theme_slots or 0

	if self._has_active_campaign_mission then
		if mission_category then
			for i = 1, 4 do
				if not used_slots[i] then
					local slot = theme_slots[i]

					if slot.category_priority and table.contains(slot.category_priority, mission_category) then
						used_slots[i] = true

						return slot
					end
				end
			end

			local start_offset = math.random(5, slot_count)

			for i = 1, slot_count do
				local at = 1 + (start_offset + i) % slot_count

				if at > 4 and not used_slots[at] then
					used_slots[at] = true

					return theme_slots[at]
				end
			end
		else
			local start_offset = math.random(slot_count)

			for i = 1, slot_count do
				local at = 1 + (start_offset + i) % slot_count

				if not used_slots[at] then
					used_slots[at] = true

					return theme_slots[at]
				end
			end
		end
	else
		local start_offset = math.random(slot_count)

		for i = 1, slot_count do
			local at = 1 + (start_offset + i) % slot_count

			if not used_slots[at] then
				used_slots[at] = true

				return theme_slots[at]
			end
		end
	end
end

MissionBoardView._release_slot = function (self, slot)
	local slot_group, slot_index = slot.group, slot.index
	local used_slots = self._used_slots

	used_slots[slot_group][slot_index] = false
end

MissionBoardView._widget_from_blueprint = function (self, widget_id, blueprint_setting_name, mission_data, creation_context, ...)
	local blueprint_settings = Settings.mission_tile_settings[blueprint_setting_name]

	if not blueprint_settings then
		Log.error("MissionBoardView", "No blueprint settings found for '%s'.", blueprint_setting_name)

		return
	end

	local blueprint_name = blueprint_settings.blueprint_name
	local blueprint = Blueprints[blueprint_name]

	if not blueprint then
		return
	end

	local size = blueprint_settings.size
	local scenegraph_id = blueprint_settings.scenegraph_id
	local definition = Blueprints.make_blueprint(blueprint, scenegraph_id, size)
	local widget = self:_create_widget(widget_id, definition)

	if not widget then
		return
	end

	local content = widget.content

	for i = 1, select("#", ...), 2 do
		local key, value = select(i, ...)

		content[key] = value
	end

	widget.content.blueprint_name = blueprint_setting_name
	widget.content.blueprint = definition

	local init = definition.init

	if init then
		local width, height = init(definition, widget, mission_data, creation_context)

		return widget, width, height
	end

	return widget
end

MissionBoardView._create_mission_widget_from_mission = function (self, mission, blueprint_name, slot)
	local ui_theme = self:_get_ui_theme()
	local creation_context = table.shallow_copy(ui_theme.view_data)
	local flags = mission.flags
	local is_flash = not not flags.flash

	creation_context.is_large = blueprint_name == "large_mission_definition"
	creation_context.is_locked = self._mission_board_logic:is_mission_locked(mission)
	creation_context.banner_text = is_flash and Localize("loc_mission_board_maelstrom_header") or nil
	creation_context.ui_renderer = self._ui_renderer
	creation_context.display_order = self._mission_board_logic:get_campaign_mission_display_order(mission.map, mission.category)

	local mission_id = mission.id
	local widget = self:_widget_from_blueprint(mission_id, blueprint_name, mission, creation_context, "mission_id", mission_id, "slot", slot, "mission", mission)

	if not widget then
		return
	end

	local position = slot.position

	widget.offset = {
		position[1],
		position[2],
		0,
	}

	local content = widget.content

	content.hotspot.pressed_callback = callback(self, "set_selected_mission", mission_id)

	return widget
end

MissionBoardView._set_static_mission_widget = function (self, id, optional_creation_context, optional_on_pressed_callback)
	local old_widget = self._widgets_by_name[id]

	if old_widget ~= nil then
		self:_remove_mission_widget(old_widget)
	end

	local slot = self:_claim_slot("static")

	if not slot then
		return
	end

	local ui_theme = self:_get_ui_theme()
	local creation_context = table.shallow_copy(ui_theme.view_data)

	creation_context.is_large = true

	if optional_creation_context then
		table.merge(creation_context, optional_creation_context)
	end

	local widget = self:_widget_from_blueprint(id, "static_tile", nil, creation_context, "mission_id", id, "slot", slot, "static", true)
	local on_pressed_callback = optional_on_pressed_callback or callback(self, "_set_selected", id)
	local position = slot.position

	widget.offset = {
		position[1],
		position[2],
		0,
	}
	widget.content.hotspot.pressed_callback = on_pressed_callback

	local mission_widgets = self._mission_widgets

	mission_widgets[#mission_widgets + 1] = widget

	local was_selected = self._selected_mission_id == id

	if was_selected then
		self:_clear_selected()
		on_pressed_callback()
	end
end

MissionBoardView._set_quickplay_widget = function (self)
	local bonus_text
	local bonus_low, bonus_high = self._mission_board_logic:get_bonus_range("quickplay")

	if bonus_low and bonus_high then
		local internal_bonus_text = bonus_low == bonus_high and tostring(bonus_low) or string.format("+%s%% - %s%%", bonus_low, bonus_high)

		bonus_text = Localize("loc_mission_board_card_bonus_text", true, {
			bonus_text = internal_bonus_text,
		})
	end

	local is_unlocked, unlock_prerequisite = self._mission_board_logic:get_quickplay_unlock_status()

	return self:_set_static_mission_widget("qp_mission_widget", {
		banner_icon = "content/ui/materials/icons/mission_types_pj/mission_type_quick",
		location_texture = "content/ui/textures/pj_missions/quickplay_small",
		is_locked = not is_unlocked,
		banner_text = Localize("loc_mission_board_quickplay_header"),
		header_text = bonus_text,
	}, callback(self, "_set_selected_quickplay"))
end

MissionBoardView._add_mission_widget = function (self, mission)
	local flags = mission.flags
	local is_flash = not not flags.flash
	local requires_large_slot = is_flash
	local slot_group = "small"
	local mission_category = mission and mission.category
	local slot = self:_claim_slot(slot_group, mission_category)

	if not slot then
		return
	end

	local blueprint_name = "mission_tile"
	local widget = self:_create_mission_widget_from_mission(mission, blueprint_name, slot)

	if not widget then
		self:_release_slot(slot)

		return
	end

	widget.visible = false
	widget.content.enter_anim_id = self:_start_animation("mission_enter", widget, self, nil, 1, math.random_range(0, 0.5))

	local mission_widgets = self._mission_widgets

	mission_widgets[#mission_widgets + 1] = widget
end

MissionBoardView._destroy_widget = function (self, widget)
	UIWidget.destroy(self._ui_renderer, widget)
	self:_unregister_widget_name(widget.name)
end

MissionBoardView._replace_mission_widget = function (self, old_widget, new_mission)
	local mission_widgets = self._mission_widgets
	local index = table.index_of(mission_widgets, old_widget)
	local old_content = old_widget.content
	local slot = old_content.slot
	local blueprint_name = old_content.blueprint_name or old_content.mission_type
	local old_mission_id = old_content.mission_id

	self:_destroy_widget(old_widget)

	local new_widget = self:_create_mission_widget_from_mission(new_mission, blueprint_name, slot)

	if not new_widget then
		return false
	end

	mission_widgets[index] = new_widget

	if self._selected_mission_id == old_mission_id then
		self:set_selected_mission(new_mission.id)
	end

	return true
end

MissionBoardView._remove_mission_widget = function (self, widget)
	local mission_widgets = self._mission_widgets
	local index = table.index_of(mission_widgets, widget)

	table.swap_delete(mission_widgets, index)

	local content = widget.content

	self:_release_slot(content.slot)
	self:_destroy_widget(widget)
end

MissionBoardView._missions_are_ui_equivalent = function (self, mission_a, mission_b)
	if mission_a.map ~= mission_b.map then
		return false
	end

	if mission_a.start_game_time > mission_b.expiry_game_time or mission_b.start_game_time > mission_a.expiry_game_time then
		return false
	end

	if mission_a.flags.flash ~= mission_b.flags.flash then
		return false
	end

	return true
end

MissionBoardView._ui_equivalent_mission = function (self, target, t)
	local missions = self._filtered_missions
	local widgets_by_name = self._widgets_by_name

	for _, mission in pairs(missions) do
		local id = mission.id
		local has_widget = widgets_by_name[id]
		local is_active = t >= mission.start_game_time and t <= mission.expiry_game_time

		if not has_widget and is_active and self:_missions_are_ui_equivalent(target, mission) then
			return mission
		end
	end
end

MissionBoardView._update_mission_widgets = function (self, t)
	local filtered_missions = self._filtered_missions
	local widgets_by_name = self._widgets_by_name
	local mission_widgets = self._mission_widgets

	if mission_widgets and #mission_widgets ~= 0 and self._selected_mission_id then
		local selected_widget = widgets_by_name[self._selected_mission_id]

		if selected_widget == nil then
			self:_clear_selected()
		end
	end

	local is_animating = false
	local widget_count = mission_widgets and #mission_widgets or 0

	for i = 1, widget_count do
		local widget = mission_widgets[i]
		local content = widget.content
		local mission_id = content.mission_id
		local mission = content.mission
		local is_alive = content.static or filtered_missions[mission_id] ~= nil and t <= mission.expiry_game_time
		local widget_is_animating = content.exit_anim_id ~= nil or content.enter_anim_id ~= nil

		if not is_alive and not widget_is_animating then
			local ui_equivalent_mission = self:_ui_equivalent_mission(mission, t)

			if ui_equivalent_mission then
				is_alive = self:_replace_mission_widget(widget, ui_equivalent_mission)
			end
		end

		if not is_alive and not widget_is_animating then
			content.exit_anim_id = self:_start_animation("mission_exit", widget, self, nil, 1, math.random_range(0, 0.4))
			widget_is_animating = true
		end

		is_animating = is_animating or widget_is_animating
	end

	if is_animating then
		return
	end

	for id, mission in pairs(filtered_missions) do
		local has_widget = widgets_by_name[id] ~= nil
		local is_active = t >= mission.start_game_time and t <= mission.expiry_game_time
		local needs_new_widget = not has_widget and is_active

		if needs_new_widget then
			self:_add_mission_widget(mission)
		end
	end

	if not self._selected_mission_id and self._has_synced_missions_data then
		local has_active_campaign_missions, active_story_mission_id = self:_has_active_campaign_missions(filtered_missions)

		if active_story_mission_id then
			self:set_selected_mission(active_story_mission_id, true, true)
		else
			self:_set_selected_quickplay(true, true)
		end
	end
end

MissionBoardView._set_info_text = function (self, level, text)
	local info_box = self._widgets_by_name.play_button

	if not info_box then
		return
	end

	if text then
		info_box.content.disabled_text = text
	end
end

MissionBoardView._has_issue = function (self, key)
	return self._issues[key] ~= nil
end

MissionBoardView._has_issue_mission_changed = function (self, issue_key)
	if not self:_has_issue(issue_key) then
		return false
	end

	local current_issue = self._issues[issue_key]
	local current_mission_id = self._selected_mission_id
	local issue_mission_id = current_issue.mission_id

	if issue_mission_id == nil then
		return false
	end

	return current_mission_id ~= issue_mission_id
end

MissionBoardView._refresh_issue = function (self)
	local current_issue_key = self._current_issue_key
	local can_start_mission

	if current_issue_key then
		local current_issue = self._issues[current_issue_key]
		local current_type = current_issue.type
		local current_text = current_issue.message

		if current_issue_key == "mission_locked" then
			current_text = self:_get_mission_locked_issue_message()
		end

		self:_set_info_text(current_type, current_text)

		can_start_mission = current_type == "info"
	else
		self:_set_info_text("info", nil)

		can_start_mission = true
	end

	local play_button = self._widgets_by_name.play_button

	play_button.content.hotspot.disabled = not can_start_mission
	self.can_start_mission = can_start_mission
end

MissionBoardView._set_issue = function (self, key, priority, type, message)
	local current_issue_key = self._current_issue_key

	if current_issue_key == key then
		current_issue_key = nil
	end

	local issues = self._issues

	if priority == nil then
		issues[key] = nil
	else
		issues[key] = {
			priority = priority,
			type = type,
			message = message,
			mission_id = self._selected_mission_id,
		}
	end

	if issues[key] and issues[current_issue_key] and issues[key].priority > issues[current_issue_key].priority then
		current_issue_key = key
	else
		local max_priority, max_priority_key = -1

		for curr_key, curr_config in pairs(issues) do
			local curr_priority = curr_config.priority

			if max_priority < curr_priority then
				max_priority, max_priority_key = curr_priority, curr_key
			end
		end

		current_issue_key = max_priority_key
	end

	self._current_issue_key = current_issue_key

	self:_refresh_issue()
end

MissionBoardView._poll_issue = function (self, issue_key, priority, should_add, issue_type, text_function, ...)
	local has_issue = self:_has_issue(issue_key)
	local has_issue_mission_changed = self:_has_issue_mission_changed(issue_key)

	if should_add and not has_issue then
		self:_set_issue(issue_key, priority, issue_type, text_function(...))
	elseif not should_add and has_issue then
		self:_set_issue(issue_key)
	elseif should_add and has_issue and has_issue_mission_changed then
		self:_set_issue(issue_key, priority, issue_type, text_function(...))
	end
end

MissionBoardView._poll_issue_localized = function (self, issue_key, priority, should_add, loc_key, optional_issue_type, ...)
	return self:_poll_issue(issue_key, priority, should_add, optional_issue_type or "warning", Localize, loc_key, ...)
end

MissionBoardView._get_mission_locked_issue_message = function (self)
	local current_text = ""
	local selected_mission_id = self._selected_mission_id
	local unlock_data = {}

	if selected_mission_id == "qp_mission_widget" then
		local game_modes_data = Managers.data_service.mission_board:get_game_modes_progression_data()

		unlock_data = game_modes_data and game_modes_data.quickplay or {}
	else
		local selected_mission_data = self:_mission(selected_mission_id)
		local category = selected_mission_data and selected_mission_data.category
		local mission_key = selected_mission_data and selected_mission_data.map

		unlock_data = self._mission_board_logic:get_mission_unlock_data(mission_key, category)
	end

	local required_data = {}

	if unlock_data then
		local requirements = unlock_data.prerequisites

		if requirements ~= nil then
			for _, requirement in ipairs(requirements) do
				local requirement_type = requirement.type

				if requirement_type ~= "mission" then
					Log.warning("MissionBoardView", "Requirement of type '%s' for mission '%s' ingnored", requirement_type, selected_mission_id)
				elseif requirement_type == "mission" then
					local requirement_key = requirement.key
					local requirement_category = requirement.category
					local required_campaign = requirement.campaign

					if required_campaign ~= nil and not required_data[required_campaign] then
						required_data[required_campaign] = {}
					end

					local requirement_data = required_data[required_campaign]

					requirement_data.chapters = requirement_data.chapters or {}

					local chapters = requirement_data.chapters
					local story_missions = self._mission_board_logic:_get_missions_per_category("story")
					local mission = story_missions[requirement_key]

					if not mission.completed or mission.completed == false then
						local requirement_display_order = self._mission_board_logic:get_campaign_mission_display_order(requirement_key, requirement_category)

						chapters[#chapters + 1] = requirement_display_order
					end
				end
			end
		end
	end

	local requirement_text = ""

	if not table.is_empty(required_data) then
		local count = 0

		for campaign_name, required_data in pairs(required_data) do
			count = count + 1

			local chapters = required_data.chapters
			local chapters_str = ""

			for i = 1, #chapters do
				local chapter = chapters[i]

				chapters_str = chapters_str .. TextUtils.convert_to_roman_numerals(chapter) .. (i < #chapters and ", " or "")
			end

			local campaign_display_name = CampaignSettings[campaign_name] and CampaignSettings[campaign_name].display_name or "loc_settings_option_unavailable"

			if not CampaignSettings[campaign_name] then
				Log.warning("MissionBoardView", "Unknown campaign '%s' in mission unlock requirements.", campaign_name)
			end

			requirement_text = requirement_text .. Localize("loc_mission_board_mission_locked_requirement", true, {
				campaign_name = Localize(campaign_display_name),
				chapters = chapters_str,
			}) .. (count < #required_data and "\n" or "")
		end
	end

	return requirement_text
end

MissionBoardView._update_info_state = function (self, t)
	local party_manager = self._party_manager

	do
		local members_can_start = party_manager:are_all_members_in_hub()

		self:_poll_issue_localized("members_not_in_hub", 3, not members_can_start, "loc_mission_board_team_mate_not_available")
	end

	do
		local is_private_game = self._mission_board_logic:is_private_match()
		local is_alone = party_manager:num_other_members() < 1

		self:_poll_issue_localized("private_error", 2, is_private_game and is_alone, "loc_mission_board_cannot_private_match")
	end

	local mission_id = self._selected_mission_id

	if mission_id == "qp_mission_widget" then
		local quickplay_unlocked = self._mission_board_logic:get_quickplay_unlock_status()

		self:_poll_issue_localized("mission_locked", 2, not quickplay_unlocked, "loc_mission_board_locked_issue")
	else
		local mission = self:_mission(mission_id)
		local is_locked = mission and self._mission_board_logic:is_mission_locked(mission)

		self:_poll_issue_localized("mission_locked", 2, is_locked, "loc_mission_board_locked_issue")
	end
end

MissionBoardView._update_page = function (self, t)
	if not self._page_settings or table.is_empty(self._page_settings) then
		return
	end

	local page_index = self._mission_board_logic:get_current_page_index()

	if page_index and self._page_index ~= page_index then
		self._page_index = page_index

		local page = self._page_settings[page_index]

		if page and page.is_unlocked then
			self:_open_current_page()

			local view_element_campaign_mission_list = self:_element("mission_list")

			if view_element_campaign_mission_list and view_element_campaign_mission_list:visible() then
				view_element_campaign_mission_list:refresh_mission_list()
			end
		end
	end
end

MissionBoardView._calculate_camera_properties = function (self)
	local world = self._world_spawner and self._world_spawner._world

	if not world then
		return
	end

	local unit = World.unit_by_name(world, Settings.hologram_unit_name)

	if not unit then
		return
	end

	local rotation = self._camera_rotation
	local quaternion = Quaternion.from_euler_angles_xyz(0, 0, rotation)

	Unit.set_local_rotation(unit, 1, quaternion)

	local zoom = self._camera_zoom

	self._world_spawner:interpolate_to_camera(self._near_camera_unit, zoom)
end

MissionBoardView._update_camera = function (self, dt, t)
	local camera_settings = Settings.camera_settings
	local target_rotation = self._target_rotation
	local current_rotation = self._camera_rotation
	local target_rotation_speed = camera_settings.speed_factor * math.normalize_modulus(target_rotation - current_rotation, 360)
	local rotation_speed = math.lerp(target_rotation_speed, self._rotation_speed, camera_settings.acceleration_factor^dt)

	if math.abs(rotation_speed) > math.abs(target_rotation_speed) then
		rotation_speed = target_rotation_speed
	end

	current_rotation = current_rotation + rotation_speed * dt

	if math.abs(target_rotation - current_rotation) < 1e-05 then
		current_rotation, rotation_speed = target_rotation, 0
	end

	local target_zoom = self._target_zoom
	local current_zoom = self._camera_zoom
	local target_zoom_speed = camera_settings.speed_factor * (target_zoom - current_zoom)
	local zoom_speed = math.lerp(target_zoom_speed, self._zoom_speed, camera_settings.acceleration_factor^dt)

	if math.abs(zoom_speed) > math.abs(target_zoom_speed) then
		zoom_speed = target_zoom_speed
	end

	current_zoom = current_zoom + zoom_speed * dt

	if math.abs(target_zoom - current_zoom) < 1e-05 then
		current_zoom, zoom_speed = target_zoom, 0
	end

	local rotation_is_different = current_rotation ~= self._camera_rotation or rotation_speed ~= self._rotation_speed
	local zoom_is_different = current_zoom ~= self._camera_zoom or zoom_speed ~= self._zoom_speed

	if rotation_is_different or zoom_is_different then
		self._camera_rotation, self._rotation_speed = current_rotation, rotation_speed
		self._camera_zoom, self._zoom_speed = current_zoom, zoom_speed

		self:_calculate_camera_properties()
	end
end

MissionBoardView.update = function (self, dt, t, input_service)
	local widgets_by_name = self._widgets_by_name
	local is_loading = self._mission_data == nil or self._page_settings == nil

	widgets_by_name.loading.content.visible = is_loading
	widgets_by_name.gamepad_cursor.content.visible = not is_loading
	widgets_by_name.difficulty_stepper.content.visible = not is_loading
	widgets_by_name.difficulty_progress_bar.content.visible = not is_loading
	widgets_by_name.difficulty_progress_tooltip.content.visible = not is_loading
	input_service = is_loading and input_service:null_service() or input_service
	self._stored_input_service = input_service

	local options_opened = self._mission_board_options ~= nil

	input_service = options_opened and input_service:null_service() or input_service

	MissionBoardView.super.update(self, dt, t, input_service)

	local has_synced_missions_data = self._mission_board_logic:has_synced_missions_data()

	if has_synced_missions_data and self._has_synced_missions_data ~= has_synced_missions_data then
		self._has_synced_missions_data = has_synced_missions_data
		self._mission_data = self._mission_board_logic:get_missions_data()
		self._page_settings = self._mission_board_logic:get_page_settings()
		self._filtered_missions = self._mission_board_logic:get_filtered_missions()
		self._page_index = self._mission_board_logic:get_current_page_index()

		self:_create_difficulty_stepper_indicators()
		self:_setup_difficulty_selector()
		self:_setup_threat_level_tooltip()
		self:_open_current_page()

		local has_active_campaign_missions = self:_has_active_campaign_missions(self._filtered_missions)

		self._has_active_campaign_mission = has_active_campaign_missions
	end

	self:_update_mission_info_panel()

	if self._mission_board_logic then
		self._mission_board_logic:update(dt, t)
	end

	self:_update_page(t)

	local view_element_campaign_mission_list = self:_element("mission_list")

	if not view_element_campaign_mission_list or view_element_campaign_mission_list and not view_element_campaign_mission_list:visible() then
		self:_update_mission_widgets(t)
	end

	self:_update_info_state(t)
	self:_update_camera(dt, t)
	self:_update_hologram_unit(dt, t)
	self:_update_threat_level_tooltip(dt, t)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end
end

MissionBoardView._mission = function (self, mission_id, ignore_filter)
	if ignore_filter then
		return self._mission_board_logic:get_mission_data_by_id(mission_id)
	end

	return self._filtered_missions[mission_id]
end

MissionBoardView._set_sidebar_key_active = function (self, key_name, active)
	local old_active = self._sidebar_key_is_active[key_name]

	self._sidebar_key_is_active[key_name] = active
	self._sidebar_dirty = self._sidebar_dirty or old_active ~= active
end

MissionBoardView._has_sidebar_tabs = function (self)
	local has_a_tab = false
	local sidebar_key_is_active = self._sidebar_key_is_active

	for _, name in ipairs(Settings.sidebar_tabs) do
		local has_entries = sidebar_key_is_active[name] ~= nil and #self._objectives_tabs > 1

		if has_entries and has_a_tab then
			return true
		end

		has_a_tab = has_a_tab or has_entries
	end

	return false
end

MissionBoardView._set_sidebar_tab = function (self, target_tab_name)
	local sidebar_key_is_active = self._sidebar_key_is_active

	for _, tab_name in ipairs(Settings.sidebar_tabs) do
		if sidebar_key_is_active[tab_name] ~= nil then
			self:_set_sidebar_key_active(tab_name, target_tab_name == tab_name)
		end
	end

	self._current_tab_name = target_tab_name

	self:_mark_info_panel_dirty(true)
end

MissionBoardView._set_next_sidebar_tab = function (self)
	local sidebar_tabs = Settings.sidebar_tabs
	local current_tab_name = self._current_tab_name
	local current_tab_index = table.index_of(sidebar_tabs, current_tab_name)

	if current_tab_index == -1 then
		current_tab_index = 0
	end

	local sidebar_tab_count = #sidebar_tabs
	local sidebar_key_is_active = self._sidebar_key_is_active

	for i = 1, sidebar_tab_count do
		local tab_index = current_tab_index + i

		if sidebar_tab_count < tab_index then
			tab_index = tab_index - sidebar_tab_count
		end

		local tab_name = sidebar_tabs[tab_index]

		if sidebar_key_is_active[tab_name] ~= nil then
			return self:_set_sidebar_tab(tab_name)
		end
	end

	self:_set_sidebar_tab()
end

MissionBoardView._update_mission_location = function (self, mission, palette_name)
	local mission_area_info = self._widgets_by_name.mission_area_info
	local mission_timer_bar = self._widgets_by_name.large_timer_bar
	local content = mission_area_info.content

	if not mission then
		if mission_area_info.visible then
			mission_area_info.visible = false
			mission_timer_bar.visible = false
			content.mission_id = nil
		end

		return
	end

	local title, sub_title, texture, is_locked, banner_text

	if mission == "qp_mission_widget" then
		if content.mission_id == mission then
			return
		end

		content.mission_id = mission
		title = Localize("loc_mission_board_quickplay_header")
		sub_title = Localize("loc_mission_board_view_header_tertium_hive")
		texture = "content/ui/textures/pj_missions/quickplay_medium"
		is_locked = false
	else
		if content.mission_id == mission.id then
			return
		end

		content.mission_id = mission.id

		local mission_template = MissionTemplates[mission.map]

		title = Localize(mission_template.mission_name)
		sub_title = Localize(Zones[mission_template.zone_id].name)
		texture = mission_template.texture_medium
		is_locked = self._mission_board_logic:is_mission_locked(mission)

		local flags = mission.flags
		local is_flash = not not flags.flash

		banner_text = is_flash and Localize("loc_mission_board_maelstrom_header") or nil
	end

	local style = mission_area_info.style

	content.mission_title = title
	content.mission_sub_title = sub_title
	content.is_locked = not not is_locked
	content.banner_text = banner_text
	style.image.material_values = {
		texture_map = texture,
		show_static = is_locked and 1 or 0,
	}

	if not mission_area_info.visible then
		mission_area_info.visible = true
	end

	local timer_bar_content = mission_timer_bar.content

	if mission_timer_bar and mission ~= "qp_mission_widget" then
		timer_bar_content.is_quickplay = false
		timer_bar_content.start_game_time = mission.start_game_time
		timer_bar_content.expiry_game_time = mission.expiry_game_time
	elseif mission_timer_bar and mission == "qp_mission_widget" then
		timer_bar_content.start_game_time = nil
		timer_bar_content.expiry_game_time = nil
		timer_bar_content.is_quickplay = true
		mission_timer_bar.style.timer_bar.material_values = {
			progress = 1,
		}
	end

	if not mission_timer_bar.visible then
		mission_timer_bar.visible = true
	end
end

MissionBoardView._update_location_circumstance = function (self, mission, palette_name)
	local circumstance_widget = self._widgets_by_name.circumstance_details
	local circumstance_visible = false

	if mission == "qp_mission_widget" then
		if circumstance_widget.visible then
			circumstance_widget.visible = circumstance_visible
		end

		return
	end

	if not mission then
		if circumstance_widget.visible then
			circumstance_widget.visible = circumstance_visible
		end

		return
	end

	if mission.circumstance == "default" then
		circumstance_widget.visible = circumstance_visible

		return
	end

	local content = circumstance_widget.content

	if mission.circumstance and content.circumstance_id == mission.circumstance then
		circumstance_visible = true
	elseif mission.circumstance and mission.circumstance ~= "default" then
		local line_spacing = 1.2

		circumstance_visible = true

		local circumstance = mission.circumstance

		content.circumstance_id = circumstance

		local circumstance_template = CircumstanceTemplates[circumstance]
		local circumstance_ui_data = circumstance_template and circumstance_template.ui

		if circumstance_ui_data then
			local category = mission.category
			local style = circumstance_widget.style
			local is_story = category == "story"

			if is_story then
				local icon_settings = Settings.mission_category_icons[category] or Settings.mission_category_icons.undefined

				content.mission_type_icon = icon_settings.mission_board_icon
				style.circumstance_icon.visible = false
				style.story_circumstance_icon.visible = true
			else
				content.circumstance_icon = circumstance_ui_data.mission_board_icon or circumstance_ui_data.icon
				style.circumstance_icon.visible = true
				style.story_circumstance_icon.visible = false
			end

			local text_box_size = {
				Dimensions.details_width - 80 - 6,
				2000,
			}
			local circumstance_title, circumstance_description = "", ""

			if is_story then
				local unlock_data = self._mission_board_logic:get_mission_unlock_data(mission.map, category)

				if unlock_data and unlock_data.unlocked then
					circumstance_title = Localize(circumstance_ui_data.display_name)
					circumstance_description = Localize(circumstance_ui_data.description)
				elseif unlock_data and unlock_data.unlocked == false then
					circumstance_title = Localize("loc_redacted_generic")
					circumstance_description = "???"
				end
			else
				circumstance_title = Localize(circumstance_ui_data.display_name)
				circumstance_description = Localize(circumstance_ui_data.description)
			end

			local title_style = style.circumstance_title
			local description_style = style.circumstance_description
			local title_text_height = _text_height(self._ui_renderer, circumstance_title, title_style, text_box_size)
			local description_height = _text_height(self._ui_renderer, circumstance_description, description_style, text_box_size)
			local height = 10 + title_text_height * line_spacing + description_height * line_spacing + 10

			if title_text_height > 28 then
				description_style.offset[2] = 10 + title_text_height + 14
			else
				description_style.offset[2] = 40
			end

			if height < 100 then
				height = 100
			end

			self:_set_scenegraph_size("mission_area_circumstance", Dimensions.details_width - 4, height)

			content.circumstance_title = circumstance_title
			content.circumstance_description = circumstance_description
			circumstance_widget.dirty = true
			style.circumstance_title.text_color = Styles.colors[palette_name].accent
			style.circumstance_description.text_color = Styles.colors[palette_name].accent
			style.circumstance_rect_detail.color = Styles.colors[palette_name].accent
		end
	end

	circumstance_widget.visible = circumstance_visible
end

MissionBoardView._update_mission_objectives_panel = function (self, mission, palette_name)
	if not mission then
		table.clear(self._objectives_tabs)
		table.clear(self._sidebar_key_is_active)

		return
	end

	local title, sub_title, icon

	self._objectives_tabs.palette_name = palette_name

	if mission == "qp_mission_widget" then
		if self._objectives_tabs.mission_id ~= mission then
			table.clear(self._objectives_tabs)
			table.clear(self._sidebar_key_is_active)

			self._objectives_tabs.palette_name = palette_name
			self._objectives_tabs.mission_id = mission
			icon = "content/ui/materials/icons/mission_types_pj/mission_type_quick"
			title = Localize("loc_mission_board_quickplay_header")
			sub_title = Localize("loc_misison_board_main_objective_title")

			local tab_size = {
				Settings.dimensions.details_width,
				68,
			}
			local widget_definition = MissionBoardViewDefinitions.create_objectives_panel_widget("mission_objectives_panel", title, sub_title, icon, tab_size)
			local widget = UIWidget.init("quickplay_objective_tab", widget_definition)

			widget.offset[1] = 0

			local content = widget.content
			local tab_id = "main_objective"

			self._sidebar_key_is_active[tab_id] = not not self._sidebar_key_is_active[tab_id]
			content.tab_id = tab_id
			content.tab_index = 1
			content.hotspot.pressed_callback = callback(self, "_set_sidebar_tab", tab_id)
			self._objectives_tabs[#self._objectives_tabs + 1] = widget
		end
	elseif self._objectives_tabs.mission_id ~= mission.id then
		table.clear(self._objectives_tabs)
		table.clear(self._sidebar_key_is_active)

		self._objectives_tabs.mission_id = mission.id
		self._objectives_tabs.palette_name = palette_name

		local has_side_mission = not not mission.sideMission
		local tabs = Settings.sidebar_tabs
		local num_tabs = has_side_mission and #tabs or 1
		local sidebar_width = Settings.dimensions.details_width
		local tab_width = sidebar_width / num_tabs
		local tab_size = {
			tab_width,
			68,
		}

		for i = 1, num_tabs do
			local tab_id = tabs[i]
			local objective_template

			if tab_id == "main_objective" then
				local mission_template = MissionTemplates[mission.map]

				objective_template = MissionTypes[mission_template.mission_type]
				title = Localize(objective_template.name)
				sub_title = Localize("loc_misison_board_main_objective_title")
				icon = objective_template.mission_board_icon or objective_template.icon
			else
				local side_mission_name = mission.sideMission

				objective_template = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]
				title = Localize(objective_template.header)
				sub_title = Localize("loc_mission_board_side_objective_title")
				icon = objective_template.mission_board_icon or objective_template.icon
			end

			self._sidebar_key_is_active[tab_id] = not not self._sidebar_key_is_active[tab_id]

			local widget_definition = MissionBoardViewDefinitions.create_objectives_panel_widget("mission_objectives_panel", title, sub_title, icon, tab_size)
			local widget = UIWidget.init("mission_objectives_tab_" .. i, widget_definition)

			widget.offset[1] = (i - 1) * tab_width

			local content = widget.content

			content.tab_id = tab_id
			content.tab_index = i
			content.hotspot.pressed_callback = callback(self, "_set_sidebar_tab", tab_id)
			self._objectives_tabs[#self._objectives_tabs + 1] = widget
		end
	end
end

MissionBoardView._update_mission_objectve_info = function (self, mission, palette_name)
	local info_widget = self._widgets_by_name.mission_objective_info

	if not mission then
		if info_widget.visible then
			info_widget.visible = false

			local content = info_widget.content

			content.active_tab = nil
			content.mission_id = nil

			table.clear(self._reward_widgets)
		end

		return
	end

	local tab_id = self._current_tab_name
	local content = info_widget.content

	if mission == "qp_mission_widget" then
		if mission ~= content.mission or tab_id ~= content.tab_id then
			table.clear(self._reward_widgets)

			content.mission_id = mission
			content.active_tab = tab_id

			local text = Localize("loc_mission_board_quickplay_description")

			content.objective_description = text
			content.is_quickplay_mission = true
			content.has_mission_giver = false

			local bonus_data = self._mission_board_logic:get_bonus_data("quickplay")

			if bonus_data then
				local offset_mod = 0
				local size_multiplier = 1 / #Settings.currency_order
				local size = {
					Dimensions.details_width * size_multiplier,
					Dimensions.rewards_height,
				}

				for _, currency_type in ipairs(Settings.currency_order) do
					local amount = bonus_data[currency_type]
					local amount_text = "+ " .. amount .. "%"
					local icon = Settings.currency_icons[currency_type]
					local reward_definition = MissionBoardViewDefinitions.create_reward_widget("mission_rewards_panel", amount_text, icon, size)
					local widget = UIWidget.init("reward_" .. currency_type, reward_definition)

					widget.offset[1] = size[1] * offset_mod
					offset_mod = offset_mod + 1
					self._reward_widgets[#self._reward_widgets + 1] = widget
				end
			end
		end
	elseif mission.id ~= content.mission_id or tab_id ~= content.active_tab then
		table.clear(self._reward_widgets)

		content.active_tab = tab_id
		content.mission_id = mission.id

		local xp, credits

		if tab_id then
			if tab_id == "main_objective" then
				local mission_template = MissionTemplates[mission.map]
				local objective_template = MissionTypes[mission_template.mission_type]
				local mission_description = Localize(mission_template.mission_description)

				content.objective_description = mission_description
				xp, credits = mission.xp, mission.credits

				local circumstance_rewards = mission.extraRewards.circumstance

				if circumstance_rewards then
					xp, credits = xp + circumstance_rewards.xp, credits + circumstance_rewards.credits
				end

				local vo_profile = mission.missionGiver or mission_template.mission_brief_vo.vo_profile
				local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
				local text = string.format(">  %s", Localize(speaker_settings.full_name))
				local speaker_image = speaker_settings.material_small

				content.mission_giver_icon = speaker_image
				content.mission_giver_name = text
				content.has_mission_giver = true
				content.is_quickplay_mission = false
			else
				content.has_mission_giver = false
				content.is_quickplay_mission = false

				local side_mission_name = mission.sideMission
				local objective_template = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]

				if not objective_template or not mission.flags.side then
					return
				end

				local text = Localize(objective_template.description)

				content.objective_description = text

				local side_rewards = mission.extraRewards.sideMission

				if side_rewards then
					xp, credits = side_rewards.xp, side_rewards.credits
				end
			end

			if xp or credits then
				local size = {
					Dimensions.details_width * 0.24,
					Dimensions.rewards_height,
				}
				local offset_mod = 0

				if credits then
					local amount = type(credits) == "number" and TextUtils.format_currency(credits) or credits
					local icon = Settings.currency_icons.credits
					local credits_definition = MissionBoardViewDefinitions.create_reward_widget("mission_rewards_panel", amount, icon, size)
					local widget = UIWidget.init("credits_reward", credits_definition)

					widget.offset[1] = size[1] * offset_mod
					offset_mod = offset_mod + 1
					self._reward_widgets[#self._reward_widgets + 1] = widget
				end

				if xp then
					local amount = type(xp) == "number" and TextUtils.format_currency(xp) or xp
					local icon = Settings.currency_icons.xp
					local xp_definition = MissionBoardViewDefinitions.create_reward_widget("mission_rewards_panel", amount, icon, size)
					local widget = UIWidget.init("xp_reward", xp_definition)

					widget.offset[1] = size[1] * offset_mod
					offset_mod = offset_mod + 1
					self._reward_widgets[#self._reward_widgets + 1] = widget
				end
			end
		end
	end

	info_widget.visible = true
end

MissionBoardView._mark_info_panel_dirty = function (self, value)
	self._info_panel_dirty = value
end

MissionBoardView._update_mission_info_panel = function (self)
	if self._info_panel_dirty then
		local ui_theme = self:_get_ui_theme()
		local palette_name = ui_theme.view_data.palette_name
		local mission

		mission = self._selected_mission_id == "qp_mission_widget" and "qp_mission_widget" or self:_mission(self._selected_mission_id, true)

		self:_update_mission_location(mission, palette_name)
		self:_update_location_circumstance(mission, palette_name)
		self:_update_mission_objectve_info(mission, palette_name)
		self:_update_mission_objectives_panel(mission, palette_name)

		local objectives_tabs = self._objectives_tabs

		if objectives_tabs then
			for i = 1, #objectives_tabs do
				local widget = objectives_tabs[i]
				local content = widget.content
				local hotspot = content.hotspot
				local is_selected = content.tab_id == self._current_tab_name

				hotspot.is_selected = is_selected
			end
		end

		self:_mark_info_panel_dirty(false)
	end
end

MissionBoardView._set_selected = function (self, id, sidebar_function_name, move_gamepad_cursor, force_reload, ...)
	move_gamepad_cursor = move_gamepad_cursor ~= false
	force_reload = force_reload == true

	local same_mission = self._selected_mission_id == id
	local is_redundant = not force_reload and same_mission

	if is_redundant then
		return
	end

	self._selected_mission_id = id
	self._target_zoom, self._target_rotation, self._rotation_speed, self._zoom_speed = 0, 0, 0, 0

	local mission_widgets = self._mission_widgets
	local mission_count = mission_widgets and #mission_widgets or 0

	for i = 1, mission_count do
		local widget = mission_widgets[i]
		local content = widget.content
		local widget_id = content.mission_id
		local is_selected = widget_id == id
		local hotspot = content.hotspot

		if hotspot ~= nil then
			hotspot.is_selected = is_selected
		end

		local slot = content.slot

		if is_selected and slot then
			self._target_zoom, self._target_rotation = slot.zoom or self._target_zoom, slot.rotation or self._target_rotation
		end

		if is_selected and move_gamepad_cursor then
			self:_set_gamepad_cursor(widget)
		end
	end

	local show_play_button = false

	if sidebar_function_name then
		show_play_button = self[sidebar_function_name](self, id, ...)
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.play_button.visible = show_play_button
	widgets_by_name.play_button_legend.visible = show_play_button

	self:_set_sidebar_tab("main_objective")

	local should_active_hologram = id ~= nil and id ~= "qp_mission_widget"

	self:_set_hologram_outline(should_active_hologram)
end

MissionBoardView._set_quickplay_sidebar = function (self)
	return true
end

MissionBoardView._set_selected_quickplay = function (self, move_gamepad_cursor, force_reload)
	return self:_set_selected("qp_mission_widget", "_set_quickplay_sidebar", move_gamepad_cursor, force_reload)
end

MissionBoardView._set_mission_sidebar = function (self, mission_id)
	local ignore_filter = self:_element("mission_list"):visible()
	local mission = self:_mission(mission_id, ignore_filter)

	if mission == nil then
		return false
	end

	return true
end

MissionBoardView.set_selected_mission = function (self, mission_id, move_gamepad_cursor, force_reload)
	return self:_set_selected(mission_id, "_set_mission_sidebar", move_gamepad_cursor, force_reload)
end

MissionBoardView._clear_selected = function (self)
	self:_set_selected(nil)
end

MissionBoardView._difficulty_stepper_input = function (self, input_service)
	if not self._gamepad_active then
		return
	end

	if input_service:get("navigate_primary_left_pressed") then
		self:_request_prev_page()
	end

	if input_service:get("navigate_primary_right_pressed") then
		self:_request_next_page()
	end
end

MissionBoardView._play_button_input = function (self, input_service)
	local using_gamepad = InputDevice.gamepad_active
	local play_button = self._widgets_by_name.play_button

	if not using_gamepad or not play_button then
		return
	end

	local hotspot = play_button and play_button.content.hotspot

	if hotspot.disabled then
		return
	end

	local gamepad_action = play_button and play_button.content.gamepad_action

	if gamepad_action and input_service:get(gamepad_action) then
		hotspot.pressed_callback()
	end
end

MissionBoardView._virtual_cursor_input = function (self, input_service, dt, t)
	local gamepad_cursor = self._widgets_by_name.gamepad_cursor
	local last_pressed_device = InputDevice.last_pressed_device
	local cursor_active = last_pressed_device and last_pressed_device:type() ~= "mouse"

	gamepad_cursor.visible = cursor_active

	if not cursor_active then
		return
	end

	local input = input_service:get("navigation_keys_virtual_axis") + input_service:get("navigate_controller")

	input[2] = -input[2]

	local input_len = Vector3.length(input)

	if input_len > 1 then
		input = input / input_len
		input_len = 1
	end

	local settings = MissionBoardViewSettings.gamepad_cursor_settings
	local scenegraph = self._ui_scenegraph
	local pos = Vector3Box.unbox(self._gamepad_cursor_current_pos)
	local vel = Vector3Box.unbox(self._gamepad_cursor_current_vel)
	local avg_vel = Vector3Box.unbox(self._gamepad_cursor_average_vel)
	local tar_pos = Vector3Box.unbox(self._gamepad_cursor_target_pos)
	local move_requested = input_len > settings.snap_input_length_threshold

	if move_requested then
		self._gamepad_cursor_snap_delay = t + settings.snap_delay
	end

	local should_snap = t > self._gamepad_cursor_snap_delay

	if should_snap then
		pos = Vector3.lerp(tar_pos, pos, settings.snap_movement_rate^dt)
	end

	local acceleration = settings.cursor_acceleration
	local cursor_size = Vector3.from_array_flat(scenegraph.gamepad_cursor.size)
	local wanted_size = Vector2(settings.default_size_x, settings.default_size_y)
	local norm_avg_vel, len_avg_vel = Vector3.direction_length(avg_vel)
	local best_pos
	local best_score = -math.huge
	local requested_mission_id, requested_callback
	local selected_mission_id = self._selected_mission_id
	local cursor_center = pos
	local cursor_pos = cursor_center - 0.5 * cursor_size
	local is_sticky = len_avg_vel < settings.stickiness_speed_threshold
	local mission_widgets = self._mission_widgets

	for _, widget in ipairs(mission_widgets) do
		local is_valid = widget and widget.visible

		if is_valid then
			local widget_pos = Vector2(widget.offset[1], widget.offset[2])
			local widget_size = Vector2(widget.content.size[1], widget.content.size[2])
			local widget_center = widget_pos + 0.5 * widget_size
			local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center)
			local dot = math.max(1e-06, Vector3.dot(norm_avg_vel, delta_dir))
			local score = math.sqrt(dot) / math.max(1, delta_len)

			if is_sticky then
				score = score + 10 * math.max(0, settings.stickiness_radius - delta_len)
			end

			local has_overlap = math.box_overlap_box(widget_pos, widget_size, cursor_pos, cursor_size)

			if has_overlap then
				acceleration = settings.cursor_acceleration * settings.widget_drag_coefficient

				local mission_id = widget.content.mission_id

				if mission_id and (requested_mission_id == nil or mission_id == selected_mission_id) then
					requested_callback = widget.content.hotspot.pressed_callback
					requested_mission_id = mission_id
				end

				if is_sticky then
					score = score + 1000
				end
			end

			if best_score < score then
				wanted_size = widget_size
				best_score = score
				best_pos = widget_center
			end
		end
	end

	if requested_mission_id and requested_mission_id ~= selected_mission_id and requested_callback then
		self:_play_sound(UISoundEvents.mission_board_node_hover)
		requested_callback(false)
	end

	if best_pos then
		tar_pos = best_pos
	end

	pos = pos + vel * dt
	vel = vel * settings.cursor_friction_coefficient^dt + input * acceleration * dt

	if Vector3.length(vel) < settings.cursor_minimum_speed then
		Vector3.set_xyz(vel, 0, 0, 0)
	end

	avg_vel = math.lerp(vel, avg_vel, settings.average_speeed_smoothing^dt)

	local width, height = Vector3.to_elements(math.lerp(wanted_size, cursor_size, settings.size_resize_rate^dt))

	self:_set_scenegraph_size("gamepad_cursor", width, height)

	local mission_area_width, mission_area_height = self:_scenegraph_size("mission_area")
	local _, page_selection_height = self:_scenegraph_size("page_selection_area")

	pos[1] = math.clamp(pos[1], width / 2, mission_area_width - width / 2)
	pos[2] = math.clamp(pos[2], page_selection_height + height / 2, mission_area_height - height / 2)

	Vector3Box.store(self._gamepad_cursor_current_pos, pos)
	Vector3Box.store(self._gamepad_cursor_current_vel, vel)
	Vector3Box.store(self._gamepad_cursor_average_vel, avg_vel)
	Vector3Box.store(self._gamepad_cursor_target_pos, tar_pos)

	local x, y = Vector3.to_elements(pos)

	self:_set_scenegraph_position("gamepad_cursor_pivot", x, y)

	local arrow_style = gamepad_cursor.style.arrow
	local target_angle = math.pi + math.atan2(tar_pos[2] - pos[2], pos[1] - tar_pos[1])

	arrow_style.angle = math.radian_lerp(target_angle, arrow_style.angle, settings.arrow_rotate_rate^dt)

	local time_since_snap = math.max(t - self._gamepad_cursor_snap_delay, 0)
	local alpha = 255 * (1 - math.min(time_since_snap / settings.time_until_invisible, 1))
	local style = gamepad_cursor.style

	style.glow.color[1] = alpha
	style.rect.color[1] = alpha * 0.12549019607843137
	style.arrow.color[1] = alpha
	style.frame.color[1] = alpha
	style.corner.color[1] = alpha
end

MissionBoardView._handle_input = function (self, input_service, dt, t)
	if self._mission_board_options then
		input_service = input_service:null_service()
	end

	MissionBoardView.super._handle_input(self, input_service, dt, t)
	self:_play_button_input(input_service)
	self:_difficulty_stepper_input(input_service)

	local view_element_campaign_mission_list = self:_element("mission_list")

	if (not view_element_campaign_mission_list or view_element_campaign_mission_list and not view_element_campaign_mission_list:visible()) and InputDevice.gamepad_active then
		self:_virtual_cursor_input(input_service, dt, t)
	end
end

MissionBoardView._set_gamepad_cursor = function (self, widget)
	local offset = widget.offset
	local size_x, size_y = widget.content.size[1], widget.content.size[2]
	local x, y = offset[1] + 0.5 * size_x, offset[2] + 0.5 * size_y

	self._gamepad_cursor_target_pos[1] = x
	self._gamepad_cursor_target_pos[2] = y
	self._gamepad_cursor_current_pos[1] = x
	self._gamepad_cursor_current_pos[2] = y

	self:_set_scenegraph_position("gamepad_cursor_pivot", x, y)
	self:_set_scenegraph_size("gamepad_cursor", size_x, size_y)
end

MissionBoardView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	MissionBoardView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

MissionBoardView._update_elements = function (self, dt, t, input_service)
	local elements_array = self._elements_array
	local stored_input_service = self._stored_input_service

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local is_options_element = element_name == "ViewElemenMissionBoardOptions"
				local used_input_service = is_options_element and stored_input_service or input_service

				element:update(dt, t, used_input_service)
			end
		end
	end
end

MissionBoardView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array
	local stored_input_service = self._stored_input_service

	for i = 1, #elements_array do
		local element = elements_array[i]
		local element_name = element.__class_name
		local is_options_element = element_name == "ViewElemenMissionBoardOptions"
		local used_input_service = is_options_element and stored_input_service or input_service

		element:draw(dt, t, ui_renderer, render_settings, used_input_service)
	end
end

MissionBoardView.draw = function (self, dt, t, input_service, layer)
	self._stored_input_service = input_service

	local options_opened = self._mission_board_options ~= nil

	input_service = options_opened and input_service:null_service() or input_service

	local ui_renderer = self._ui_renderer

	UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

	local view_element_campaign_mission_list = self:_element("mission_list")

	if not view_element_campaign_mission_list or view_element_campaign_mission_list and not view_element_campaign_mission_list:visible() then
		local mission_widgets = self._mission_widgets
		local mission_count = mission_widgets and #mission_widgets or 0

		for i = 1, mission_count do
			local widget = mission_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._objectives_tabs then
		for i = 1, #self._objectives_tabs do
			local widget = self._objectives_tabs[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._reward_widgets then
		for i = 1, #self._reward_widgets do
			local widget = self._reward_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._difficulty_indicator_widgets then
		for i = 1, #self._difficulty_indicator_widgets do
			local widget = self._difficulty_indicator_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
	MissionBoardView.super.draw(self, dt, t, input_service, layer)
end

MissionBoardView.on_resolution_modified = function (self, scale)
	MissionBoardView.super.on_resolution_modified(self, scale)

	for _, widget in pairs(self._widgets_by_name) do
		widget.dirty = true
	end
end

MissionBoardView._callback_toggle_private_matchmaking = function (self, value)
	self._mission_board_logic:set_private_matchmaking(value)
	self:_update_play_button_game_mode_text()
end

MissionBoardView._callback_open_options = function (self)
	local regions_latency = self._mission_board_logic:get_region_latencies()
	local element_setting = Elements.options

	self._mission_board_options = self:_add_element(element_setting, "options", 200, {
		on_destroy_callback = callback(self, "_destroy_options_element"),
	})

	local presentation_data = {}

	if regions_latency then
		presentation_data[#presentation_data + 1] = {
			display_name = "loc_mission_board_view_options_Matchmaking_Location",
			id = "region_matchmaking",
			tooltip_text = "loc_matchmaking_change_region_confirmation_desc",
			widget_type = "dropdown",
			on_activated = function (value, template)
				Managers.data_service.region_latency:set_prefered_mission_region(value)
			end,
			get_function = function (template)
				local options = template.options_function()
				local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

				for i = 1, #options do
					local option = options[i]

					if option.value == prefered_mission_region then
						return option.id
					end
				end

				return 1
			end,
			options_function = function (template)
				local options = {}

				for region_name, latency_data in pairs(regions_latency) do
					local loc_key = RegionLocalizationMappings[region_name]
					local ignore_localization = true
					local region_display_name = loc_key and Localize(loc_key) or region_name

					if math.abs(latency_data.min_latency - latency_data.max_latency) < 5 then
						region_display_name = string.format("%s %dms", region_display_name, latency_data.min_latency)
					else
						region_display_name = string.format("%s %d-%dms", region_display_name, latency_data.min_latency, latency_data.max_latency)
					end

					options[#options + 1] = {
						id = region_name,
						display_name = region_display_name,
						ignore_localization = ignore_localization,
						value = region_name,
						latency_order = latency_data.min_latency,
					}
				end

				table.sort(options, function (a, b)
					return a.latency_order < b.latency_order
				end)

				return options
			end,
			on_changed = function (value)
				Managers.data_service.region_latency:set_prefered_mission_region(value)
			end,
		}
	end

	presentation_data[#presentation_data + 1] = {
		display_name = "loc_private_tag_name",
		id = "private_match",
		tooltip_text = "loc_mission_board_view_options_private_game_desc",
		widget_type = "checkbox",
		start_value = self._mission_board_logic:is_private_match(),
		get_function = function ()
			return self._mission_board_logic:is_private_match()
		end,
		on_activated = callback(self, "_callback_toggle_private_matchmaking"),
	}
	presentation_data[#presentation_data + 1] = {
		display_name = "loc_narrative_quickplay_name",
		id = "quickplay_narrative",
		tooltip_text = "loc_mission_board_view_options_narrative_quickplay_desc",
		widget_type = "checkbox",
		start_value = self._mission_board_logic:get_quickplay_into_narrative(),
		get_function = function ()
			return self._mission_board_logic:get_quickplay_into_narrative()
		end,
		on_activated = callback(self._mission_board_logic, "set_quickplay_into_narrative"),
	}

	self._mission_board_options:present(presentation_data)
end

MissionBoardView._callback_open_replay_campaign_missions_view = function (self)
	local view_element_campaign_mission_list = self:_element("mission_list")

	view_element_campaign_mission_list:set_visibility(true)
	view_element_campaign_mission_list:refresh_mission_list()
end

MissionBoardView._callback_close_replay_campaign_missions_view = function (self)
	local view_element_campaign_mission_list = self:_element("mission_list")

	view_element_campaign_mission_list:set_visibility(false)
	self:_open_current_page()
end

MissionBoardView._destroy_options_element = function (self)
	self:_remove_element("options")

	self._mission_board_options = nil
end

MissionBoardView._on_back_pressed = function (self)
	local has_options = self._mission_board_options ~= nil

	if has_options then
		return
	end

	Managers.ui:close_view(self.view_name)
end

MissionBoardView._callback_start_selected_mission = function (self)
	local party_manager = self._party_manager
	local selected_mission_id = self._selected_mission_id
	local mission_list = self:_element("mission_list")
	local mission_list_visible = mission_list and mission_list:visible()
	local mission_is_selected = self:_mission(selected_mission_id, mission_list_visible) ~= nil
	local private_game = self._mission_board_logic:is_private_match()
	local should_close = false

	if mission_is_selected then
		should_close = self._mission_board_logic:start_mission_matchmaking(party_manager, selected_mission_id, private_game)
	elseif selected_mission_id == "qp_mission_widget" then
		local categories = {
			"common",
			"story",
		}

		should_close = self._mission_board_logic:start_quickplay_matchmaking(party_manager, categories)
	end

	if not should_close then
		return
	end

	if Managers.narrative:complete_event(Managers.narrative.EVENTS.mission_board) then
		PlayerVOStoryStage.refresh_hub_story_stage()
	end

	self:_play_sound(UISoundEvents.mission_board_start_mission)
	Managers.ui:close_view(self.view_name)
end

MissionBoardView._create_viewport = function (self, camera_unit)
	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings

	self._world_spawner:create_viewport(camera_unit, world_spawner_settings.viewport_name, world_spawner_settings.viewport_type, world_spawner_settings.viewport_layer, world_spawner_settings.viewport_shading_environment)
	self._world_spawner:set_listener(world_spawner_settings.viewport_name)
end

MissionBoardView.event_register_camera = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera")

	self._far_camera_unit = camera_unit

	self:_create_viewport(camera_unit)
end

MissionBoardView.event_register_camera_02 = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera_02")

	self._near_camera_unit = camera_unit
end

MissionBoardView.event_mission_board_mission_tile_pressed = function (self, mission_id)
	self:_set_selected_mission(mission_id, false, true)
end

MissionBoardView._get_difficulty_data_by_name = function (self, difficulty_name)
	for i = 1, #DangerSettings do
		local difficulty_data = DangerSettings[i]

		if difficulty_data.name == difficulty_name then
			return difficulty_data
		end
	end
end

MissionBoardView._update_threat_level_progress = function (self, difficulty_index, target_color)
	local widget = self._widgets_by_name.difficulty_progress_bar

	if not difficulty_index or not target_color then
		widgte.visible = false

		return
	end

	local content = widget.content
	local style = widget.style
	local difficulty_progress_data = self._mission_board_logic:get_threat_level_progress()

	if not difficulty_progress_data or table.is_empty(difficulty_progress_data) then
		widget.visible = false

		return
	end

	local progress = 0
	local selected_difficulty_data = DangerSettings[difficulty_index]
	local current_unlocked_difficulty = difficulty_progress_data.current_difficulty
	local current_unlocked_difficulty_data = current_unlocked_difficulty ~= "n/a" and self:_get_difficulty_data_by_name(difficulty_progress_data.current_difficulty)

	if current_unlocked_difficulty_data then
		local current_unlocked_difficulty_index = current_unlocked_difficulty_data.index

		progress = difficulty_index < current_unlocked_difficulty_index and 1 or difficulty_progress_data.progress or 0
	end

	content.progress = progress
	content.target_color = target_color
end

MissionBoardView._get_input_text = function (self, alias_name)
	local service_type = "View"
	local color_tint_text = true
	local input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)

	return input_key
end

MissionBoardView._setup_difficulty_selector = function (self)
	local difficulty_selector = self._widgets_by_name.difficulty_stepper

	if difficulty_selector then
		local content = difficulty_selector.content

		content.left_pressed_callback = callback(self, "_request_prev_page")
		content.right_pressed_callback = callback(self, "_request_next_page")
	end
end

MissionBoardView._create_difficulty_stepper_indicators = function (self)
	local page_settings = self._page_settings
	local num_settings = page_settings and #page_settings or 0
	local stepper_indicators = {}

	for i = 1, num_settings do
		local page_data = page_settings[i]
		local danger_settings = DangerSettings[i]
		local indicator_pass_templates = StepperPassTemplates.difficulty_stepper_indicator.passes
		local content_overrides = {
			icon = danger_settings.digital_icon,
			internal_selected_difficulty = i,
			current_selected_difficulty = self._page_index,
			is_unlocked = page_data and page_data.is_unlocked,
			active = i == self._page_index,
		}
		local indicator = UIWidget.create_definition(indicator_pass_templates, "difficulty_stepper_indicators", content_overrides)
		local widget = UIWidget.init("difficulty_indicator_" .. i, indicator)

		widget.offset[1] = 28 + (i - 1) * ((Dimensions.difficulty_stepper_width - 56) / num_settings)

		local content = widget.content

		content.hotspot.pressed_callback = callback(self, "_request_page_at", i)
		stepper_indicators[#stepper_indicators + 1] = widget
	end

	self._difficulty_indicator_widgets = stepper_indicators

	self:_update_difficulty_stepper(self._page_index)
end

MissionBoardView._update_difficulty_stepper = function (self, page_index)
	local page_settings = self._page_settings[page_index]

	if not page_settings then
		return
	end

	local difficulty_selector = self._widgets_by_name.difficulty_stepper
	local content = difficulty_selector.content

	content.danger = page_index
	content.difficulty_text = TextUtils.localize_to_upper(page_settings.loc_name)

	local target_color = DangerSettings[page_index].color

	content.target_color = target_color

	local current_difficulty_index = page_index
	local difficulty_indicators = self._difficulty_indicator_widgets

	if not difficulty_indicators then
		return
	end

	for i = 1, #difficulty_indicators do
		local indicator = difficulty_indicators[i]
		local indicator_content = indicator.content

		indicator_content.current_selected_difficulty = current_difficulty_index
		indicator_content.active = i == current_difficulty_index
		indicator_content.target_color = DangerSettings[page_index].color
	end

	local next_page = self._page_settings[page_index + 1]

	content.next_page_unlocked = next_page and next_page.is_unlocked or false

	self:_update_threat_level_progress(page_index, target_color)
end

MissionBoardView._setup_threat_level_tooltip = function (self)
	local difficulty_progress_tooltip = self._widgets_by_name.difficulty_progress_tooltip

	if not difficulty_progress_tooltip then
		return
	end

	local difficulty_progress_data = self._mission_board_logic:get_threat_level_progress()

	if not difficulty_progress_data or table.is_empty(difficulty_progress_data) then
		difficulty_progress_tooltip.visible = false

		return
	end

	local content = difficulty_progress_tooltip.content
	local current_difficulty = difficulty_progress_data.current_difficulty
	local next_difficulty = difficulty_progress_data.next_difficulty
	local current_exp = difficulty_progress_data.current or 0
	local next_exp = difficulty_progress_data.target or 0
	local current_difficulty_data = self:_get_difficulty_data_by_name(current_difficulty)
	local next_difficulty_data = self:_get_difficulty_data_by_name(next_difficulty)

	if not current_difficulty_data or not next_difficulty_data then
		difficulty_progress_tooltip.visible = false

		return
	end

	local formatted_tooltip_text = Localize("loc_mission_board_current_threat_level_progress_tooltip", true, {
		current_difficulty = Localize(current_difficulty_data.display_name),
		next_difficulty = Localize(next_difficulty_data.display_name),
		current = current_exp,
		target = next_exp,
	})

	content.text = formatted_tooltip_text
	difficulty_progress_tooltip.visible = true
end

MissionBoardView._update_threat_level_tooltip = function (self, dt, t)
	local stepper_widget = self._widgets_by_name.difficulty_stepper

	if not stepper_widget then
		return
	end

	local content = stepper_widget.content
	local hotspot = content.tooltip_hotspot

	if not hotspot then
		return
	end

	local difficulty_progress_tooltip = self._widgets_by_name.difficulty_progress_tooltip

	if not difficulty_progress_tooltip then
		return
	end

	local style = difficulty_progress_tooltip.style

	if InputDevice.gamepad_active then
		local gamepad_anim_progress = content.gamepad_anim_progress or 0

		if self._threat_level_tooltip_visible then
			gamepad_anim_progress = math.clamp(gamepad_anim_progress + dt * 2, 0, 1)
		else
			gamepad_anim_progress = math.clamp(gamepad_anim_progress - dt * 2, 0, 1)
		end

		difficulty_progress_tooltip.offset[1] = 400 - gamepad_anim_progress * 400
		style.text.text_color[1] = 255 * gamepad_anim_progress
		style.background.color[1] = 255 * gamepad_anim_progress
		style.frame.color[1] = 255 * gamepad_anim_progress
		content.gamepad_anim_progress = gamepad_anim_progress
	else
		local hover_progress = hotspot.anim_hover_progress or 0

		difficulty_progress_tooltip.offset[1] = 400 - hover_progress * 400
		style.text.text_color[1] = 255 * hover_progress
		style.background.color[1] = 255 * hover_progress
		style.frame.color[1] = 255 * hover_progress
	end
end

MissionBoardView._add_view_element = function (self, element_name)
	local element_setting = Elements[element_name]
	local element

	if element_setting then
		element = self:_add_element(element_setting, element_name, self._element_layer)
		self._element_layer = self._element_layer + 1
	end

	return element
end

MissionBoardView._callback_hide_threat_level_tooltip = function (self)
	self._threat_level_tooltip_visible = false
end

MissionBoardView._callback_show_threat_level_tooltip = function (self)
	self._threat_level_tooltip_visible = true
end

MissionBoardView._set_stepper_gamepad_input = function (self)
	local difficulty_selector = self._widgets_by_name.difficulty_stepper

	if difficulty_selector then
		local content = difficulty_selector.content

		content.gamepad_left_input_text = self:_get_input_text("navigate_primary_left")
		content.gamepad_right_input_text = self:_get_input_text("navigate_primary_right")
	end
end

MissionBoardView._on_group_finder_pressed = function (self)
	local view_name = "group_finder_view"
	local ui_manager = Managers.ui

	if ui_manager and not Managers.ui:view_active(view_name) then
		Managers.ui:open_view(view_name)
	end
end

MissionBoardView._set_hologram_outline = function (self, value)
	local is_screen_effect_enabled = ScreenEffectSettings.enabled

	if not is_screen_effect_enabled then
		return
	end

	if self._is_hologram_outline_active ~= value and self._hologram_unit then
		self._is_hologram_outline_active = value

		if value == true then
			self._needs_effect_materials = true
		else
			local default_materials = ScreenEffectSettings.default_materials

			for slot_name, material in pairs(default_materials) do
				Unit.set_material(self._hologram_unit, slot_name, material)
			end
		end
	end
end

MissionBoardView._update_hologram_unit = function (self, dt, t)
	local has_particle = self._on_screen_effect_id ~= 0

	if not has_particle then
		return
	end

	local active = self._is_hologram_outline_active
	local fade_speed = ScreenEffectSettings.fade_speed or 2
	local fade_progress = self._hologram_fade_progress or 0
	local noise_fade_progress = self._hologram_noise_fade_progress or 0

	if active then
		fade_progress = math.min(fade_progress + dt * fade_speed, 1)
		noise_fade_progress = math.min(noise_fade_progress + dt * fade_speed * 0.1, 1)
	else
		fade_progress = math.max(fade_progress - dt * fade_speed, 0)
		noise_fade_progress = math.max(noise_fade_progress - dt * fade_speed * 0.1, 0)
	end

	self._hologram_fade_progress = fade_progress
	self._hologram_noise_fade_progress = noise_fade_progress

	if fade_progress == 1 and self._needs_effect_materials == true then
		local effect_materials = ScreenEffectSettings.effect_materials

		for slot_name, material in pairs(effect_materials) do
			Unit.set_material(self._hologram_unit, slot_name, material)
		end

		self._needs_effect_materials = false
	end

	if World.has_particles_material(self._world_spawner._world, self._on_screen_effect_id, ScreenEffectSettings.cloud_name) then
		World.set_particles_material_scalar(self._world_spawner._world, self._on_screen_effect_id, ScreenEffectSettings.cloud_name, "opacity", math.easeInCubic(fade_progress))
		World.set_particles_material_scalar(self._world_spawner._world, self._on_screen_effect_id, ScreenEffectSettings.cloud_name, "depth_noise_alpha", math.easeInCubic(noise_fade_progress))
	end
end

MissionBoardView._get_hologram_unit = function (self, unit_name)
	local world = self._world_spawner and self._world_spawner._world

	if not world then
		return nil
	end

	local unit = World.unit_by_name(world, Settings.hologram_unit_name)

	if not unit then
		return nil
	end

	return unit
end

return MissionBoardView
