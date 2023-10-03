require("scripts/extension_systems/interaction/interactions/base_interaction")

HubLocationIntroductionSettings = require("scripts/settings/cinematic_video/hub_location_introduction_settings")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ViewInteraction = class("ViewInteraction", "BaseInteraction")
local ui_view_level_requirement = {
	credits_vendor_background_view = PlayerProgressionUnlocks.credits_vendor,
	crafting_view = PlayerProgressionUnlocks.crafting,
	contracts_background_view = PlayerProgressionUnlocks.contracts,
	cosmetics_vendor_background_view = PlayerProgressionUnlocks.cosmetics_vendor
}

ViewInteraction.init = function (self, template)
	self._template = template
	self._view_story_chapter_requirement = {
		credits_vendor_background_view = {
			chapter = "pot_story_traitor_first",
			story = "path_of_trust"
		},
		crafting_view = {
			chapter = "pot_crafting",
			story = "path_of_trust"
		},
		contracts_background_view = {
			chapter = "pot_contracts",
			story = "path_of_trust"
		}
	}
end

ViewInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local is_local_player = not player.remote

	if is_local_player then
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local ui_interaction = interactee_extension:ui_interaction()
		local ui_manager = Managers.ui

		if not ui_manager:view_active(ui_interaction) and not ui_manager:is_view_closing(ui_interaction) and not ui_manager:has_active_view() then
			local hli_settings = HubLocationIntroductionSettings[ui_interaction]
			local narrative_event = hli_settings and Managers.narrative.EVENTS[hli_settings.narrative_event_name]

			if hli_settings and not Managers.narrative:is_event_complete(narrative_event) then
				local context = {
					allow_skip_input = true,
					template = hli_settings.video_template
				}

				ui_manager:open_view("video_view", nil, nil, nil, nil, context)
				Managers.narrative:complete_event(narrative_event)
			else
				local context = {
					hub_interaction = true
				}

				ui_manager:open_view(ui_interaction, nil, nil, nil, nil, context)
			end
		end
	end
end

local view_requirement_failure_context = {}

ViewInteraction._check_view_requirements = function (self, interactor_unit, ui_interaction)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local player_profile = player:profile()
	local level_requirement = ui_view_level_requirement[ui_interaction]

	if level_requirement and player_profile.current_level < level_requirement then
		table.clear(view_requirement_failure_context)

		view_requirement_failure_context.level = level_requirement

		return false, "loc_requires_level", view_requirement_failure_context
	end

	local story_data = self._view_story_chapter_requirement[ui_interaction]

	if player.remote then
		return true
	end

	if story_data then
		local story_name = story_data.story
		local chapter_name = story_data.chapter
		local story_requirement_met = Managers.narrative:is_chapter_complete(story_name, chapter_name, player)

		if not story_requirement_met then
			return false, "loc_requires_pot_access"
		end
	end

	return true
end

ViewInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local requirements_met, _, _ = self:_check_view_requirements(interactor_unit, ui_interaction)

	if not requirements_met then
		return false
	end

	return ViewInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

ViewInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local ui_manager = Managers.ui

	if not ui_manager or ui_manager:view_active(ui_interaction) or ui_manager:is_view_closing(ui_interaction) then
		return false
	end

	return ViewInteraction.super.interactee_show_marker_func(self, interactor_unit, interactee_unit)
end

ViewInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local requirements_met, failed_reason, block_context = self:_check_view_requirements(interactor_unit, ui_interaction)

	if not requirements_met then
		return failed_reason, block_context
	end

	return ViewInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

return ViewInteraction
