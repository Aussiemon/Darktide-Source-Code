local Definitions = require("scripts/ui/views/training_grounds_view/training_grounds_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local TrainingGroundsView = class("TrainingGroundsView", "VendorInteractionViewBase")

TrainingGroundsView.init = function (self, settings, context)
	TrainingGroundsView.super.init(self, Definitions, settings, context)
end

TrainingGroundsView.on_enter = function (self)
	TrainingGroundsView.super.on_enter(self)

	local viewport_name = Definitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	if not Managers.narrative:is_chapter_complete("onboarding", "play_training") then
		for i = 2, #Definitions.button_options_definitions do
			local button = self._widgets_by_name["option_button_" .. i]
			local button_hotspot = button.content.hotspot
			button_hotspot.disabled = true
		end
	end

	local shooting_range_min_level = PlayerProgressionUnlocks.shooting_range
	local player = Managers.player:local_player(1)
	local profile = player:profile()
	local player_level = profile.current_level

	if player_level < shooting_range_min_level then
		local shooting_range_button = self._widgets_by_name.option_button_3
		local shooting_range_name = shooting_range_button.content.text
		shooting_range_button.content.text = string.format("%s (%s)", shooting_range_name, Localize("loc_requires_level", true, {
			level = shooting_range_min_level
		}))
		shooting_range_button.content.hotspot.disabled = true
	end

	self:play_vo_events({
		"hub_interact_training_ground_psyker"
	}, "training_ground_psyker_a", nil, 0.8, true)
end

TrainingGroundsView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	TrainingGroundsView.super.on_exit(self)
end

return TrainingGroundsView
