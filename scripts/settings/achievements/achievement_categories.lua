-- chunkname: @scripts/settings/achievements/achievement_categories.lua

local AchievementCategoriesInterface = {
	"name",
	"display_name",
	"parent_name",
	"sort_index",
}
local AchievementCategories = {}
local sort_index = 0

local function _add_category(name, loc_key, optional_parent_name)
	sort_index = sort_index + 1
	AchievementCategories[name] = {
		name = name,
		display_name = loc_key,
		parent_name = optional_parent_name,
		sort_index = sort_index,
	}
end

_add_category("account", "loc_achievement_category_account_label")
_add_category("veteran_2", "loc_class_veteran_title")
_add_category("veteran_progression", "loc_class_progression_title", "veteran_2")
_add_category("veteran_abilites", "loc_class_abilities_title", "veteran_2")
_add_category("zealot_2", "loc_class_zealot_title")
_add_category("zealot_progression", "loc_class_progression_title", "zealot_2")
_add_category("zealot_abilites", "loc_class_abilities_title", "zealot_2")
_add_category("psyker_2", "loc_class_psyker_title")
_add_category("psyker_progression", "loc_class_progression_title", "psyker_2")
_add_category("psyker_abilites", "loc_class_abilities_title", "psyker_2")
_add_category("ogryn_2", "loc_class_ogryn_title")
_add_category("ogryn_progression", "loc_class_progression_title", "ogryn_2")
_add_category("ogryn_abilites", "loc_class_abilities_title", "ogryn_2")
_add_category("tactical", "loc_achievement_category_tactical_label")
_add_category("offensive", "loc_achievement_category_offensive_label", "tactical")
_add_category("defensive", "loc_achievement_category_defensive_label", "tactical")
_add_category("teamplay", "loc_achievement_category_teamplay_label", "tactical")
_add_category("heretics", "loc_achievement_category_heretics_label")
_add_category("missions", "loc_achievement_category_missions_label")
_add_category("missions_general", "loc_achievement_subcategory_missions_general_label", "missions")
_add_category("mission_auric", "loc_achievement_subcategory_missions_auric_label", "missions")
_add_category("exploration", "loc_achievement_category_exploration_label")
_add_category("exploration_transit", "loc_achievement_subcategory_missions_transit_label", "exploration")
_add_category("exploration_watertown", "loc_achievement_subcategory_missions_watertown_label", "exploration")
_add_category("exploration_foundry", "loc_achievement_subcategory_missions_tankfoundry_label", "exploration")
_add_category("exploration_dust", "loc_achievement_subcategory_missions_dust_label", "exploration")
_add_category("exploration_throneside", "loc_achievement_subcategory_missions_throneside_label", "exploration")
_add_category("exploration_entertainment", "loc_achievement_subcategory_missions_entertainment_label", "exploration")
_add_category("exploration_void", "loc_achievement_subcategory_missions_void_label", "exploration")
_add_category("exploration_twins_mission", "loc_achievement_subcategory_twins_mission_label", "exploration")
_add_category("endeavours", "loc_achievement_category_endeavours_label")
_add_category("endeavours_transit", "loc_achievement_subcategory_missions_transit_label", "endeavours")
_add_category("endeavours_watertown", "loc_achievement_subcategory_missions_watertown_label", "endeavours")
_add_category("endeavours_foundry", "loc_achievement_subcategory_missions_tankfoundry_label", "endeavours")
_add_category("endeavours_dust", "loc_achievement_subcategory_missions_dust_label", "endeavours")
_add_category("endeavours_throneside", "loc_achievement_subcategory_missions_throneside_label", "endeavours")
_add_category("endeavours_entertainment", "loc_achievement_subcategory_missions_entertainment_label", "endeavours")
_add_category("endeavours_twins_mission", "loc_achievement_subcategory_twins_mission_label", "endeavours")
_add_category("endeavours_void", "loc_achievement_subcategory_missions_void_label", "endeavours")
table.make_strict_with_interface(AchievementCategories, "AchievementCategories", AchievementCategoriesInterface)

return settings("AchievementCategories", AchievementCategories)
