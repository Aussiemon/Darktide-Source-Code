local horde_compositions = {}

local function _create_horde_composition_entry(path)
	local horde_composition = require(path)

	for name, composition in pairs(horde_composition) do
		horde_compositions[name] = composition
		composition.name = name
	end
end

_create_horde_composition_entry("scripts/managers/pacing/horde_pacing/compositions/cultist_horde_compositions")
_create_horde_composition_entry("scripts/managers/pacing/horde_pacing/compositions/renegade_horde_compositions")
_create_horde_composition_entry("scripts/managers/pacing/horde_pacing/compositions/mutator_horde_compositions")

return settings("HordeCompositions", horde_compositions)
