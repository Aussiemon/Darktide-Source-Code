-- chunkname: @scripts/settings/roamer/roamer_packs/expeditions_roamer_packs.lua

local roamer_packs = {}

local function _create_roamer_pack_entry(path)
	local roamer_pack = require(path)

	for name, packs in pairs(roamer_pack) do
		roamer_packs[name] = packs
		packs.name = name
	end
end

_create_roamer_pack_entry("scripts/settings/roamer/roamer_packs/expeditions/expeditions_renegade_roamer_packs")
_create_roamer_pack_entry("scripts/settings/roamer/roamer_packs/expeditions/expeditions_cultist_roamer_packs")

return roamer_packs
