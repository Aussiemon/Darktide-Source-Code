-- chunkname: @scripts/utilities/ui/popups.lua

local RenamePopup = require("scripts/utilities/ui/popups/rename_popup")
local Popups = {
	rename = RenamePopup,
}

return settings("Popups", Popups)
