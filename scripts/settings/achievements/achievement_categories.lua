local AchievementCategoriesInterface = {
	"name",
	"display_name",
	"parent_name",
	"sort_index"
}
local AchievementCategories = {}
local sort_index = 0

local function _add_category(name, loc_key, optional_parent_name)
	sort_index = sort_index + 1
	AchievementCategories[name] = {
		name = name,
		display_name = loc_key,
		parent_name = optional_parent_name,
		sort_index = sort_index
	}
end

_add_category("account", "loc_achievement_category_account_label")
_add_category("classes", "loc_achievement_category_classes_label")
_add_category("ogryn_2", "loc_achievement_category_ogryn_2_label", "classes")
_add_category("zealot_2", "loc_achievement_category_zealot_2_label", "classes")
_add_category("psyker_2", "loc_achievement_category_psyker_2_label", "classes")
_add_category("veteran_2", "loc_achievement_category_veteran_2_label", "classes")
_add_category("enemies", "loc_achievement_category_enemies_label")
_add_category("missions", "loc_achievement_category_missions_label")
_add_category("offensive", "loc_achievement_category_offensive_label")
_add_category("defensive", "loc_achievement_category_defensive_label")
_add_category("teamplay", "loc_achievement_category_teamplay_label")
table.make_strict_with_interface(AchievementCategories, "AchievementCategories", AchievementCategoriesInterface)

return settings("AchievementCategories", AchievementCategories)
