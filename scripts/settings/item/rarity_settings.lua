local RaritySettings = {
	[0] = {
		display_name = "<undefined item_rarity>",
		color = {
			255,
			255,
			255,
			255
		},
		color_dark = {
			255,
			64,
			64,
			64
		},
		weapon = {
			num_traits = 0,
			num_perks = 0
		},
		gadget = {
			num_traits = 0,
			num_perks = 0
		}
	},
	{
		display_name = "loc_item_weapon_rarity_1",
		color = Color.item_rarity_1(255, true),
		color_dark = Color.item_rarity_dark_1(255, true),
		weapon = {
			num_traits = 0,
			num_perks = 0
		},
		gadget = {
			num_traits = 0,
			num_perks = 0
		}
	},
	{
		display_name = "loc_item_weapon_rarity_2",
		color = Color.item_rarity_2(255, true),
		color_dark = Color.item_rarity_dark_2(255, true),
		weapon = {
			num_traits = 0,
			num_perks = 1
		},
		gadget = {
			num_traits = 1,
			num_perks = 0
		}
	},
	{
		display_name = "loc_item_weapon_rarity_3",
		color = Color.item_rarity_3(255, true),
		color_dark = Color.item_rarity_dark_3(255, true),
		weapon = {
			num_traits = 1,
			num_perks = 1
		},
		gadget = {
			num_traits = 1,
			num_perks = 1
		}
	},
	{
		display_name = "loc_item_weapon_rarity_4",
		color = Color.item_rarity_4(255, true),
		color_dark = Color.item_rarity_dark_4(255, true),
		weapon = {
			num_traits = 1,
			num_perks = 2
		},
		gadget = {
			num_traits = 1,
			num_perks = 2
		}
	},
	{
		display_name = "loc_item_weapon_rarity_5",
		color = Color.item_rarity_5(255, true),
		color_dark = Color.item_rarity_dark_5(255, true),
		weapon = {
			num_traits = 2,
			num_perks = 2
		},
		gadget = {
			num_traits = 1,
			num_perks = 3
		}
	},
	{
		display_name = "loc_item_weapon_rarity_6",
		color = Color.item_rarity_6(255, true),
		color_dark = Color.item_rarity_dark_6(255, true),
		weapon = {
			num_traits = 2,
			num_perks = 2
		},
		gadget = {
			num_traits = 1,
			num_perks = 3
		}
	}
}

return settings("RaritySettings", RaritySettings)
