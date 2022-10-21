local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local base_talents = {
	archetype = "none",
	specialization = "none",
	talents = {
		frag_grenade = {
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			name = "frag_grenade",
			display_name = "loc_ability_frag_grenade",
			icon = "content/ui/textures/icons/talents/menu/talent_default",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_ranger_frag_grenade
			}
		},
		fire_grenade = {
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			name = "fire_grenade",
			display_name = "loc_ability_fire_grenade",
			icon = "content/ui/textures/icons/talents/menu/talent_default",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.fire_grenade
			}
		},
		krak_grenade = {
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			name = "krak_grenade",
			display_name = "loc_ability_krak_grenade",
			icon = "content/ui/textures/icons/talents/menu/talent_default",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_squad_leader_krak_grenade
			}
		}
	}
}

return base_talents
