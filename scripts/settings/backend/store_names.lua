-- chunkname: @scripts/settings/backend/store_names.lua

local StoreNames = {}

StoreNames.by_archetype = {
	credit = {
		ogryn = "get_ogryn_credits_store",
		psyker = "get_psyker_credits_store",
		veteran = "get_veteran_credits_store",
		zealot = "get_zealot_credits_store",
	},
	credit_goods = {
		ogryn = "get_ogryn_credits_goods_store",
		psyker = "get_psyker_credits_goods_store",
		veteran = "get_veteran_credits_goods_store",
		zealot = "get_zealot_credits_goods_store",
	},
	credit_cosmetics = {
		ogryn = "get_ogryn_credits_cosmetics_store",
		psyker = "get_psyker_credits_cosmetics_store",
		veteran = "get_veteran_credits_cosmetics_store",
		zealot = "get_zealot_credits_cosmetics_store",
	},
	credit_weapon_cosmetics = {
		ogryn = "get_ogryn_credits_weapon_cosmetics_store",
		psyker = "get_psyker_credits_weapon_cosmetics_store",
		veteran = "get_veteran_credits_weapon_cosmetics_store",
		zealot = "get_zealot_credits_weapon_cosmetics_store",
	},
	mark = {
		ogryn = "get_ogryn_marks_store",
		psyker = "get_psyker_marks_store",
		veteran = "get_veteran_marks_store",
		zealot = "get_zealot_marks_store",
	},
	premium = {
		ogryn = "premium_store_skins_ogryn",
		psyker = "premium_store_skins_psyker",
		veteran = "premium_store_skins_veteran",
		zealot = "premium_store_skins_zealot",
	},
}

return settings("StoreNames", StoreNames)
