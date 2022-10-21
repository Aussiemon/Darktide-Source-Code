local UI_POPUP_INFO_DURATION = 10
local MissionObjectiveGoal = require("scripts/extension_systems/mission_objective/utilities/mission_objective_goal")
local InputUtils = require("scripts/managers/input/input_utils")

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
			local context = {
				title_text = "loc_training_grounds_new_recruit_rewards_header",
				description_text = "loc_training_grounds_new_recruit_rewards_zola_quote",
				options = {
					{
						text = "loc_popup_button_confirm",
						close_on_pressed = true,
						callback = callback(function ()
							Managers.narrative:complete_current_chapter("onboarding", "training_reward")
						end)
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
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
		name = "Mission Terminal Objective - Access MT",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and Managers.narrative:can_complete_event("onboarding_step_mission_board_introduction")
		end,
		on_activation = function (self)
			local objective_name = self.name
			local localization_key = "loc_objective_hub_mission_board_header"
			local interaction_type = "mission_board"
			local marker_units = _get_interaction_units_by_type(interaction_type)
			local objective = _create_objective(objective_name, localization_key, marker_units)
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
		name = "Level 5 Unlocks Popup - Mission Board Tier Up",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and (_is_on_story_chapter("level_unlock_popups", "level_unlock_mission_board_popup_difficulty_increased_1") or _is_on_story_chapter("level_unlock_popups", "level_unlock_mission_board_popup_difficulty_increased_2"))
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
		name = "Level 5/10/15/20/25/30 Unlocks Popup - Talent Tier Up",
		valid_states = {
			"GameplayStateRun"
		},
		validation_func = function (self)
			return _is_in_hub() and (_is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_1") or _is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_2") or _is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_3") or _is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_4") or _is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_5") or _is_on_story_chapter("level_unlock_popups", "level_unlock_talent_tier_6"))
		end,
		on_activation = function (self)
			local player = _get_player()
			local localization_key = "loc_onboarding_popup_talents"
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
		on_deactivation = function (self)
			local player = _get_player()

			Managers.event:trigger("event_player_hide_onboarding_message", player)
		end,
		sync_on_events = {}
	}
}

return templates
