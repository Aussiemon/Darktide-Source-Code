-- chunkname: @scripts/utilities/ui/popups.lua

local RenamePopup = require("scripts/utilities/ui/popups/rename_popup")
local SkipPlayerJourneyPopup = require("scripts/utilities/ui/popups/skip_player_journey_popup")
local Popups = {
	rename = RenamePopup,
	skip_player_journey = SkipPlayerJourneyPopup,
}

return settings("Popups", Popups)
