-- chunkname: @scripts/settings/prologue_character_profile_override.lua

local function profile_overrides(item_definitions)
	local overrides = {
		adamant = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/powermaul_p2_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/shotgun_p1_m1"],
			},
		},
		broker = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combatknife_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"],
			},
		},
		ogryn = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/ogryn_club_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/ogryn_thumper_p1_m1"],
			},
		},
		psyker = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"],
			},
		},
		veteran = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/lasgun_p1_m1"],
			},
		},
		zealot = {
			loadout = {
				slot_primary = item_definitions["content/items/weapons/player/melee/combataxe_p3_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"],
			},
		},
	}

	return overrides
end

return profile_overrides
