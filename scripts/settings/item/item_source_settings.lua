-- chunkname: @scripts/settings/item/item_source_settings.lua

local item_source_settings = {
	dlc_bishop_deluxe = {
		display_name = "loc_dlc_imperial_edition",
	},
	dlc_adamant = {
		display_name = "loc_dlc_adamant_name",
		dlc_name = "adamant",
	},
	dlc_adamant_deluxe = {
		display_name = "loc_dlc_adamant_name_deluxe",
		dlc_name = "adamant_deluxe",
	},
	dlc_broker = {
		display_name = "loc_dlc_broker_name",
		dlc_name = "broker",
	},
	dlc_broker_deluxe = {
		display_name = "loc_dlc_broker_name_deluxe",
		dlc_name = "broker_deluxe",
	},
	dlc_broker_cosmetic = {
		display_name = "loc_dlc_broker_name_cosmetic_upgrade",
		dlc_name = "broker_cosmetic",
	},
	dlc_cryptic = {
		display_name = "loc_dlc_cryptic_name",
		dlc_name = "cryptic",
	},
	dlc_cryptic_deluxe = {
		display_name = "loc_dlc_cryptic_name_deluxe",
		dlc_name = "cryptic_deluxe",
	},
	dlc_cryptic_cosmetic = {
		display_name = "loc_dlc_cryptic_name_cosmetic_upgrade",
		dlc_name = "cryptic_cosmetic",
	},
	credits_store = {
		display_name = "loc_item_source_credits_cosmetics",
	},
	premium_store = {
		display_name = "loc_item_source_premium_store",
	},
	live_event = {
		display_name = "loc_item_source_live_event",
		is_live_event = true,
	},
	penance = {
		display_name = "loc_item_source_achievement",
		is_achievement = true,
	},
	penance_track = {
		display_name = "loc_item_source_penance_track",
	},
	preorder_beta = {
		display_name = "loc_item_source_beta_playtest",
	},
	promotional = {
		display_name = "loc_item_source_promotional",
	},
	twitch_drop = {
		display_name = "loc_item_source_twitch_drop",
	},
	vermintide_ownership = {
		display_name = "loc_item_source_vermintide_crossover",
	},
	xbox_retail = {
		display_name = "loc_item_source_xbox_retail",
	},
	warhammer_fest_2023 = {
		display_name = "loc_item_source_warhammer_fest_2023",
	},
	warhammer_skulls_2023 = {
		display_name = "loc_item_source_warhammer_skulls_2023",
	},
	warhammer_plus_subscription = {
		display_name = "loc_item_source_warhammer_plus_subscription",
	},
	owlcat_dark_heresy_crossover = {
		display_name = "loc_item_source_owlcat_dark_heresy_crossover",
	},
	xbox_redemption = {
		display_name = "loc_item_source_xbox_redemption",
	},
}

return settings("ItemSourceSettings", item_source_settings)
