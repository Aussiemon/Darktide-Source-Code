﻿-- chunkname: @scripts/settings/minigame/minigame_classes.lua

local function _require_minigame_class(minigame)
	local base = "scripts/extension_systems/minigame/minigames/minigame_"
	local minigame_file_name = base .. minigame
	local class = require(minigame_file_name)

	return class
end

local minigame_classes = {
	none = _require_minigame_class("none"),
	balance = _require_minigame_class("balance"),
	decode_symbols = _require_minigame_class("decode_symbols"),
	defuse = _require_minigame_class("defuse"),
	drill = _require_minigame_class("drill"),
	scan = _require_minigame_class("scan"),
}

return minigame_classes
