local RankSettings = {
	[0] = {
		trait_rating = 0,
		display_name = "n/a",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_00_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = 0
	},
	{
		trait_rating = 25,
		display_name = "I",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_01_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_01",
		perk_rating = 10
	},
	{
		trait_rating = 35,
		display_name = "II",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_02_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_02",
		perk_rating = 15
	},
	{
		trait_rating = 45,
		display_name = "III",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_03_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_03",
		perk_rating = 20
	},
	{
		trait_rating = 60,
		display_name = "IV",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_04_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_04",
		perk_rating = 25
	},
	{
		trait_rating = -999,
		display_name = "VV",
		trait_frame_texture = "content/ui/textures/icons/traits/trait_icon_frame_05_large",
		perk_icon = "content/ui/materials/icons/perks/perk_level_05",
		perk_rating = -999
	},
	max_trait_rank = 4
}

return settings("RankSettings", RankSettings)
