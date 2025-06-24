-- chunkname: @scripts/extension_systems/interaction/interactions/view_interaction.lua

require("scripts/extension_systems/interaction/interactions/ui_interaction")

local HubLocationIntroductionSettings = require("scripts/settings/cinematic_video/hub_location_introduction_settings")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ViewInteraction = class("ViewInteraction", "UIInteraction")
local ui_view_level_requirement = {
	havoc_background_view = PlayerProgressionUnlocks.havoc_missions,
}
local ui_view_progression_requirement = {
	credits_vendor_background_view = PlayerProgressionUnlocks.credits_vendor,
	crafting_view = PlayerProgressionUnlocks.crafting,
	contracts_background_view = PlayerProgressionUnlocks.contracts,
	cosmetics_vendor_background_view = PlayerProgressionUnlocks.cosmetics_vendor,
}

ViewInteraction._ui_interaction = function (self, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()

	return ui_interaction
end

local requirement_context = {}

ViewInteraction._is_blocked = function (self, interactor_unit, interactee_unit)
	local super_blocked, super_block_reason, super_block_context = ViewInteraction.super._is_blocked(self, interactor_unit, interactee_unit)

	if super_blocked then
		return super_blocked, super_block_reason, super_block_context
	end

	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local ui_interaction = self:_ui_interaction(interactee_unit)
	local player_profile = player:profile()
	local level_requirement = ui_view_level_requirement[ui_interaction]

	if level_requirement and level_requirement > player_profile.current_level then
		table.clear(requirement_context)

		requirement_context.level = level_requirement

		return true, "loc_requires_level", requirement_context
	end

	local progression_requirement = ui_view_progression_requirement[ui_interaction]

	if progression_requirement then
		local block_reason, block_context = Managers.data_service.mission_board:get_block_reason("hub_facility", progression_requirement)

		if block_reason then
			return true, block_reason, block_context
		end
	end

	return false
end

ViewInteraction._video_template = function (self, hli_settings)
	local player = Managers.player:local_player(1)
	local profile = player:profile()
	local archetype_name = profile.archetype.name
	local video_template_by_archetype = hli_settings.video_template_by_archetype

	if video_template_by_archetype and video_template_by_archetype[archetype_name] then
		return video_template_by_archetype[archetype_name]
	end

	return hli_settings.video_template
end

ViewInteraction._start = function (self, interactor_unit, interactee_unit)
	local ui_interaction = self:_ui_interaction(interactee_unit)
	local hli_settings = HubLocationIntroductionSettings[ui_interaction]
	local narrative_event = hli_settings and Managers.narrative.EVENTS[hli_settings.narrative_event_name]
	local hli_seen = hli_settings and Managers.narrative:is_event_complete(narrative_event)
	local context = {
		hub_interaction = true,
	}

	if hli_settings and not hli_seen then
		local video_template = self:_video_template(hli_settings)

		ui_interaction, context = "video_view", {
			allow_skip_input = true,
			template = video_template,
		}

		Managers.narrative:complete_event(narrative_event)
	end

	Managers.ui:open_view(ui_interaction, nil, nil, nil, nil, context)
end

return ViewInteraction
