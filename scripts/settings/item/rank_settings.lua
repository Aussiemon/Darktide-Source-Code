-- chunkname: @scripts/settings/item/rank_settings.lua

local RankSettings = {
	[0] = {
		display_name = "n/a",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_00_large",
		perk_rating = {
			gadget = 0,
			weapon = 0,
		},
		trait_rating = {
			gadget = 0,
			weapon = 0,
		},
	},
	{
		display_name = "I",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_01_large",
		perk_rating = {
			gadget = 10,
			weapon = 10,
		},
		trait_rating = {
			gadget = 25,
			weapon = 25,
		},
	},
	{
		display_name = "II",
		perk_icon = "content/ui/materials/icons/perks/perk_level_02",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_02_large",
		perk_rating = {
			gadget = 15,
			weapon = 15,
		},
		trait_rating = {
			gadget = 35,
			weapon = 35,
		},
	},
	{
		display_name = "III",
		perk_icon = "content/ui/materials/icons/perks/perk_level_03",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_03_large",
		perk_rating = {
			gadget = 20,
			weapon = 20,
		},
		trait_rating = {
			gadget = 45,
			weapon = 45,
		},
	},
	{
		display_name = "IV",
		perk_icon = "content/ui/materials/icons/perks/perk_level_04",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_04_large",
		perk_rating = {
			gadget = 30,
			weapon = 25,
		},
		trait_rating = {
			gadget = 60,
			weapon = 60,
		},
	},
	{
		display_name = "VV",
		perk_icon = "content/ui/materials/icons/perks/perk_level_05",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_05_large",
		perk_rating = {
			gadget = -999,
			weapon = -999,
		},
		trait_rating = {
			gadget = -999,
			weapon = -999,
		},
	},
}

RankSettings.max_trait_rank = 4
RankSettings.max_perk_rank = 4

return settings("RankSettings", RankSettings)
