-- chunkname: @scripts/settings/prologue_character_profile_override.lua

local Archetypes = require("scripts/settings/archetype/archetypes")

local function profile_overrides(item_definitions)
	return {
		[Archetypes.veteran] = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/lasgun_p1_m1"]
			}
		},
		[Archetypes.zealot] = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"]
			}
		},
		[Archetypes.psyker] = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"]
			}
		},
		[Archetypes.ogryn] = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/ogryn_club_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/ogryn_thumper_p1_m1"]
			}
		}
	}
end

return profile_overrides
