-- chunkname: @scripts/ui/constant_elements/elements/onboarding_handler/onboarding_templates.lua

local UI_POPUP_INFO_DURATION = 10
local MissionObjectiveGoal = require("scripts/extension_systems/mission_objective/utilities/mission_objective_goal")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")

local function _get_interaction_units_by_type(interaction_type)
	local units = {}
	local interactee_system = Managers.state.extension:system("interactee_system")
	local component_system = Managers.state.extension:system("component_system")
	local unit_to_interactee_ext = interactee_system:unit_to_extension_map()

	for interactee_unit, extension in pairs(unit_to_interactee_ext) do
		if interaction_type == extension:interaction_type() then
			local target_components = component_system:get_components(interactee_unit, "OnboardingObjectiveTarget")

			for i = 1, #target_components do
				local component = target_components[i]

				if component:is_primary_marker() then
					units[#units + 1] = interactee_unit

					break
				end
			end
		end
	end

	return units
end

local function _is_in_hub()
	local game_mode_name = Managers.state.game_mode:game_mode_name()
	local is_in_hub = game_mode_name == "hub"

	return is_in_hub
end

local function _is_in_prologue_hub()
	local game_mode_name = Managers.state.game_mode:game_mode_name()
	local is_in_hub = game_mode_name == "prologue_hub"

	return is_in_hub
end

local function _get_player_character_level()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local player_level = 1

	return player_level
end

local function _get_player()
	local local_player_id = 1
	local player = Managers.player:local_player_safe(local_player_id)

	return player
end

local function _create_objective(objective_name, localization_key, marker_units, marker_type, is_side_mission, icon)
	local icon = is_side_mission and "content/ui/materials/icons/objectives/bonus" or "content/ui/materials/icons/objectives/main"
	local objective_data = {
		locally_added = true,
		name = objective_name,
		header = localization_key,
		is_side_mission = is_side_mission,
		icon = icon,
		marker_type = marker_type or "hub_objective"
	}
	local objective = MissionObjectiveGoal:new()

	objective:start_objective(objective_data)

	if marker_units then
		for i = 1, #marker_units do
			local unit = marker_units[i]

			objective:add_marker(unit)
		end
	end

	return objective
end

local function _get_view_input_text(input_action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(input_action, service_type)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	return input_text
end

local function _get_ingame_input_text(input_action)
	local service_type = "Ingame"
	local alias_key = Managers.ui:get_input_alias_key(input_action, service_type)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	return input_text
end

local function _is_on_story_chapter(story_name, chapter_name)
	local current_chapter = Managers.narrative:current_chapter(story_name)

	if current_chapter then
		local current_chapter_name = current_chapter.name

		return current_chapter_name == chapter_name
	end

	return false
end

local function _is_story_complete(story_name)
	return Managers.narrative:is_story_complete(story_name)
end

local function _complete_current_story_chapter(story_name)
	Managers.narrative:complete_current_chapter(story_name)
end

local templates = {
	{
		name = "Training Ground Objective - Morrow",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_prologue_hub() and _is_on_story_chapter("onboarding", "speak_to_morrow")
		end,
		on_activation = function (self)
			return
		end,
		on_event_triggered = function (self, interaction_unit)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_om_hub_01_goto_command_central_header"
			local marker_units = {
				interaction_unit
			}
			local objective = _create_objective(objective_name, localization_key, marker_units)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		sync_on_events = {
			"event_onboarding_step_speak_to_morrow"
		}
	},
	{
		name = "Training Ground Objective - visit training ground",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_prologue_hub() and _is_on_story_chapter("onboarding", "go_to_training")
		end,
		on_activation = function (self)
			return
		end,
		on_event_triggered = function (self, interaction_unit)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_onboarding_hub_training_grounds"
			local marker_units = {
				interaction_unit
			}
			local objective = _create_objective(objective_name, localization_key, marker_units)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		sync_on_events = {
			"event_onboarding_step_go_to_training"
		}
	},
	{
		name = "Training Ground Popup - Reward Popup",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_prologue_hub() and _is_on_story_chapter("onboarding", "training_reward")
		end,
		on_activation = function (self)
			local player = Managers.player:local_player(1)
			local profile = player:profile()
			local loadout = profile.loadout
			local new_items = {
				primary_item = loadout.slot_primary,
				secondary_item = loadout.slot_secondary
			}

			for _, item in pairs(new_items) do
				ItemUtils.mark_item_id_as_new(item)
			end

			Managers.narrative:complete_current_chapter("onboarding", "training_reward")
		end,
		on_deactivation = function (self)
			return
		end,
		sync_on_events = {}
	},
	{
		name = "Training Ground Popup - Inventory",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_prologue_hub() and _is_on_story_chapter("onboarding", "inventory_popup")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_inventory"
			local no_cache = true
			local param = {
				input_key = "{#color(226, 199, 126)}" .. _get_view_input_text("hotkey_inventory") .. "{#reset()}"
			}
			local localized_text = Localize(localization_key, no_cache, param)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				Managers.narrative:complete_current_chapter("onboarding", "inventory_popup")

				local level = Managers.state.mission:mission_level()

				if level then
					Level.trigger_event(level, "event_onboarding_step_inventory_popup_displayed")
				end
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		close_condition = function (self)
			local input_service = Managers.input:get_input_service("View")

			return input_service:get("hotkey_inventory")
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Training Ground Objective - Visit Chapel",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_prologue_hub() and _is_on_story_chapter("onboarding", "visit_chapel")
		end,
		on_activation = function (self)
			return
		end,
		on_event_triggered = function (self, interaction_unit)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_om_hub_01_goto_cathedral_header"
			local marker_units = {
				interaction_unit
			}
			local objective = _create_objective(objective_name, localization_key, marker_units)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		sync_on_events = {
			"event_onboarding_step_visit_chapel"
		}
	},
	{
		name = "Training Ground Objective - Chapel Video",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.state.mission and Managers.narrative:can_complete_event("onboarding_step_chapel_video_viewed")
		end,
		on_activation = function (self)
			local ui_manager = Managers.ui
			local view_name = "video_view"

			if ui_manager:view_active(view_name) then
				local force_close = true

				ui_manager:close_view(view_name, force_close)
			end

			local function close_callback_function()
				Managers.narrative:complete_event("onboarding_step_chapel_video_viewed")

				local level = Managers.state.mission and Managers.state.mission:mission_level()

				if level then
					Level.trigger_event(level, "event_onboarding_step_chapel_video_viewed")
				end

				local function instant_easing_function()
					return 1
				end

				local time = 0.1
				local local_player = Managers.player:local_player(1)
				local fade_out_at = Managers.time:time("main") + time

				Managers.event:trigger("event_cutscene_fade_in", local_player, time, instant_easing_function)
				Managers.event:trigger("event_cutscene_fade_out_at", local_player, time, instant_easing_function, fade_out_at)
			end

			local template_name = "cs06"
			local close_callback = callback(close_callback_function)
			local context = {
				allow_skip_input = true,
				template = template_name,
				close_callback = close_callback
			}

			ui_manager:open_view(view_name, nil, true, true, nil, context)
		end,
		on_deactivation = function (self)
			local ui_manager = Managers.ui
			local view_name = "video_view"

			if ui_manager:view_active(view_name) and not ui_manager:is_view_closing(view_name) then
				local force_close = true

				ui_manager:close_view(view_name, force_close)
			end
		end,
		sync_on_events = {}
	},
	{
		name = "Mission Terminal Objective - Access MT",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("onboarding_step_mission_board_introduction")
		end,
		on_activation = function (self)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_hub_mission_board_header"
			local interaction_type = "mission_board"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units, nil, true)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)

			local level = Managers.state.mission:mission_level()

			if level then
				Level.trigger_event(level, "event_onboarding_step_mission_board_introduction")
			end
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		sync_on_events = {}
	},
	{
		name = "Mission Terminal Popup - Access MT",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("onboarding_step_mission_board_introduction")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_mission_board_01"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 2 Unlocks Objective - Contracts Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("level_unlock_contract_store_visited")
		end,
		on_activation = function (self)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_hub_contracts"
			local interaction_type = "contracts"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units, nil, true)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		close_condition = function (self)
			return Managers.ui:view_active("contracts_background_view")
		end,
		sync_on_events = {}
	},
	{
		name = "Level 2 Unlocks Popup - Contracts Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and _is_on_story_chapter("level_unlock_popups", "level_unlock_contract_store_popup")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_contracts"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				_complete_current_story_chapter("level_unlock_popups")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 3 Unlocks Objective - Weapons Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("level_unlock_credits_store_visited")
		end,
		on_activation = function (self)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_hub_weapon_shop"
			local interaction_type = "vendor"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units, nil, true)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		close_condition = function (self)
			return Managers.ui:view_active("credits_view")
		end,
		sync_on_events = {}
	},
	{
		name = "Level 3 Unlocks Popup - Weapons Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and _is_on_story_chapter("level_unlock_popups", "level_unlock_credits_store_popup")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_weapon_shop"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				_complete_current_story_chapter("level_unlock_popups")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 3 Unlocks Objective - Cosmetics Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("level_unlock_cosmetic_store_visited")
		end,
		on_activation = function (self)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_hub_cosmetics_shop"
			local interaction_type = "cosmetics_vendor"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units, nil, true)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		close_condition = function (self)
			return Managers.ui:view_active("cosmetics_vendor_background_view")
		end,
		sync_on_events = {}
	},
	{
		name = "Level 3 Unlocks Popup - Cosmetics Shop",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("level_unlock_cosmetic_store_popup")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_cosmetics_shop"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				Managers.narrative:complete_event("level_unlock_cosmetic_store_popup")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 4 Unlocks Objective - Forge / Crafting",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("level_unlock_crafting_station_visited")
		end,
		on_activation = function (self)
			if self.objective then
				Log.warning("onboarding_templates", "[on_event_triggered] trying to start objective '%s' when it's already active", self.name)

				return
			end

			local objective_name = self.name
			local localization_key = "loc_objective_hub_crafting"
			local interaction_type = "crafting"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units, nil, true)

			self.objective = objective

			Managers.event:trigger("event_add_mission_objective", objective)
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		close_condition = function (self)
			return Managers.ui:view_active("crafting_view")
		end,
		sync_on_events = {}
	},
	{
		name = "Level 4 Unlocks Popup - Forge / Crafting",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and _is_on_story_chapter("level_unlock_popups", "level_unlock_crafting_station_popup")
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_crafting"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				_complete_current_story_chapter("level_unlock_popups")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 5 Unlocks Popup - Mission Board Tier Up",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and (_is_on_story_chapter("level_unlock_popups", "level_unlock_mission_board_popup_difficulty_increased_1") or _is_on_story_chapter("level_unlock_popups", "level_unlock_mission_board_popup_difficulty_increased_2") or _is_on_story_chapter("level_unlock_popups", "level_unlock_mission_board_popup_difficulty_increased_3"))
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_mission_board_02"
			local localized_text = Localize(localization_key)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				_complete_current_story_chapter("level_unlock_popups")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Level 8 / 15 / 23 Unlocks Popup - New Device Slot",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and (_is_on_story_chapter("level_unlock_popups", "level_unlock_gadget_slot_1") or _is_on_story_chapter("level_unlock_popups", "level_unlock_gadget_slot_2") or _is_on_story_chapter("level_unlock_popups", "level_unlock_gadget_slot_3"))
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_device_slot_01"
			local no_cache = true
			local param = {
				input_key = "{#color(226, 199, 126)}" .. _get_view_input_text("hotkey_inventory") .. "{#reset()}"
			}
			local localized_text = Localize(localization_key, no_cache, param)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				_complete_current_story_chapter("level_unlock_popups")
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		close_condition = function (self)
			local input_service = Managers.input:get_input_service("View")

			return input_service:get("hotkey_inventory")
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "Narrative main objective",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and not Managers.narrative:is_story_complete("path_of_trust")
		end,
		on_activation = function (self)
			if self.objective then
				local objective = self.objective
				local objective_name = objective:name()

				Managers.event:trigger("event_remove_mission_objective", objective_name)

				self.objective = nil

				objective:destroy()
			end

			local ignore_requirement = true
			local current_chapter = Managers.narrative:current_chapter("path_of_trust", ignore_requirement)

			if current_chapter then
				local chapter_data = current_chapter.data
				local objective_name = self.name
				local localization_key = chapter_data.localization_key
				local level = chapter_data.level_to_reach
				local text = Localize(localization_key, true, {
					level = level or 0
				})
				local objective = _create_objective(objective_name, localization_key)

				self.objective = objective

				Managers.event:trigger("event_add_mission_objective", objective)
			end
		end,
		on_deactivation = function (self)
			if not self.objective then
				return
			end

			local objective = self.objective
			local objective_name = objective:name()

			Managers.event:trigger("event_remove_mission_objective", objective_name)

			self.objective = nil

			objective:destroy()
		end,
		sync_on_events = {
			"event_on_path_of_trust_updated"
		}
	},
	{
		name = "Unspent Talent points available",
		once_per_state = true,
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			if _is_in_hub() then
				local player = _get_player()
				local profile = player and player:profile()

				if profile then
					local talent_points = profile.talent_points or 0
					local points_spent = 0

					for widget_name, points_spent_on_node in pairs(profile.selected_nodes) do
						points_spent = points_spent + points_spent_on_node
					end

					if points_spent < talent_points then
						return true
					end
				end

				return false
			end

			return false
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_talent_points_reminder"
			local no_cache = true
			local param = {
				input_key = "{#color(226, 199, 126)}" .. _get_view_input_text("hotkey_inventory") .. "{#reset()}"
			}
			local localized_text = Localize(localization_key, no_cache, param)
			local duration = UI_POPUP_INFO_DURATION

			local function close_callback_function()
				return
			end

			local close_callback = callback(close_callback_function)

			Managers.event:trigger("event_player_display_onboarding_message", player, localized_text, duration, close_callback)
		end,
		close_condition = function (self)
			local input_service = Managers.input:get_input_service("View")

			return input_service:get("hotkey_inventory")
		end,
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	},
	{
		name = "season_1_intro_popup",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("s1_intro_popup_viewed")
		end,
		on_activation = function (self)
			local slide_data = {
				starting_slide_index = 1,
				slides = {
					{
						id = "id_test",
						local_slide = true,
						local_image = "content/ui/textures/event_news/traitor_curse_side_art",
						content = {
							{
								widget_type = "header",
								text = Localize("loc_news_traitor_curse_header_1")
							},
							{
								widget_type = "sub_header",
								text = Localize("loc_news_traitor_curse_subheader_1")
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									500,
									20
								}
							},
							{
								widget_type = "body",
								text = Localize("loc_news_traitor_curse_text_1")
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									500,
									40
								}
							},
							{
								image = "content/ui/materials/event_news/traitor_curse_news_image_1",
								widget_type = "image",
								size = {
									700,
									130
								},
								color = {
									255,
									255,
									255,
									255
								}
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									500,
									10
								}
							},
							{
								widget_type = "sub_header",
								text = Localize("loc_news_traitor_curse_subheader_2")
							},
							{
								widget_type = "body",
								text = Localize("loc_news_traitor_curse_text_2")
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									700,
									40
								}
							},
							{
								image = "content/ui/materials/event_news/traitor_curse_news_image_4",
								widget_type = "image",
								size = {
									700,
									130
								},
								color = {
									255,
									255,
									255,
									255
								}
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									500,
									10
								}
							},
							{
								widget_type = "sub_header",
								text = Localize("loc_news_traitor_curse_subheader_5")
							},
							{
								widget_type = "body",
								text = Localize("loc_news_traitor_curse_text_5")
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									700,
									40
								}
							},
							{
								image = "content/ui/materials/event_news/traitor_curse_news_image_3",
								widget_type = "image",
								size = {
									700,
									130
								},
								color = {
									255,
									255,
									255,
									255
								}
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									500,
									10
								}
							},
							{
								widget_type = "sub_header",
								text = Localize("loc_news_traitor_curse_subheader_4")
							},
							{
								widget_type = "body",
								text = Localize("loc_news_traitor_curse_text_4")
							},
							{
								widget_type = "dynamic_spacing",
								size = {
									700,
									20
								}
							}
						}
					}
				}
			}

			Managers.ui:open_view("news_view", nil, nil, nil, nil, {
				on_startup = true,
				content_package = "packages/ui/event_news/event_news",
				slide_data = slide_data
			})
		end,
		on_deactivation = function (self)
			if Managers.narrative then
				Managers.narrative:complete_event("s1_intro_popup_viewed")
			end
		end
	}
}

return templates
