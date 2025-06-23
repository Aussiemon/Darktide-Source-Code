-- chunkname: @scripts/settings/item/rank_settings.lua

local RankSettings = {
	[0] = {
		display_name = "n/a",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_00_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = {
			weapon = 0,
			gadget = 0
		},
		trait_rating = {
			weapon = 0,
			gadget = 0
		}
	},
	{
		display_name = "I",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_01_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = {
			weapon = 10,
			gadget = 10
		},
		trait_rating = {
			weapon = 25,
			gadget = 25
		}
	},
	{
		display_name = "II",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_02_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_02",
		perk_rating = {
			weapon = 15,
			gadget = 15
		},
		trait_rating = {
			weapon = 35,
			gadget = 35
		}
	},
	{
		display_name = "III",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_03_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_03",
		perk_rating = {
			weapon = 20,
			gadget = 20
		},
		trait_rating = {
			weapon = 45,
			gadget = 45
		}
	},
	{
		display_name = "IV",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_04_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_04",
		perk_rating = {
			weapon = 25,
			gadget = 30
		},
		trait_rating = {
			weapon = 60,
			gadget = 60
		}
	},
	{
		display_name = "VV",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_05_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_05",
		perk_rating = {
			weapon = -999,
			gadget = -999
		},
		trait_rating = {
			weapon = -999,
			gadget = -999
		}
	}
}

RankSettings.max_trait_rank = 4
RankSettings.max_perk_rank = 4

return settings("RankSettings", RankSettings)
