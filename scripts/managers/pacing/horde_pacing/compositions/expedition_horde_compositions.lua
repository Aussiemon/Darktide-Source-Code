-- chunkname: @scripts/managers/pacing/horde_pacing/compositions/expedition_horde_compositions.lua

local horde_compositions = {}

local function _create_horde_composition_entry(path)
	local horde_composition = require(path)

	for name, composition in pairs(horde_composition) do
		horde_compositions[name] = composition
		composition.name = name
	end
end

_create_horde_composition_entry("scripts/managers/pacing/horde_pacing/compositions/expedition/expedition_cultist_horde_compositions")
_create_horde_composition_entry("scripts/managers/pacing/horde_pacing/compositions/expedition/expedition_renegade_horde_compositions")

return horde_compositions
