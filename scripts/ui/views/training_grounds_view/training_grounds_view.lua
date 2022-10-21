local Definitions = require("scripts/ui/views/training_grounds_view/training_grounds_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local TrainingGroundsView = class("TrainingGroundsView", "VendorInteractionViewBase")

TrainingGroundsView.init = function (self, settings, context)
	TrainingGroundsView.super.init(self, Definitions, settings, context)
end

TrainingGroundsView.on_enter = function (self)
	TrainingGroundsView.super.on_enter(self)

	if not Managers.narrative:is_chapter_complete("onboarding", "play_training") then
		for i = 2, #Definitions.button_options_definitions do
			local button = self._widgets_by_name["option_button_" .. i]
			local button_hotspot = button.content.hotspot
			button_hotspot.disabled = true
		end
	end
end

TrainingGroundsView.on_exit = function (self)
	TrainingGroundsView.super.on_exit(self)
end

return TrainingGroundsView
