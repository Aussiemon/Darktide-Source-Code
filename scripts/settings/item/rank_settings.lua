local RankSettings = {
	[0] = {
		trait_rating = 0,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = 0
	},
	{
		trait_rating = 25,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_01_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = 10
	},
	{
		trait_rating = 35,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_02_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_02",
		perk_rating = 15
	},
	{
		trait_rating = 45,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_03_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_03",
		perk_rating = 20
	},
	{
		trait_rating = 55,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_04_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_04",
		perk_rating = 25
	},
	{
		trait_rating = -999,
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_05_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_05",
		perk_rating = -999
	}
}

return settings("RankSettings", RankSettings)
