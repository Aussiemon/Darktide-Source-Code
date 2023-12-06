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
_add_category("veteran_2", "loc_class_veteran_title", "classes")
_add_category("zealot_2", "loc_class_zealot_title", "classes")
_add_category("psyker_2", "loc_class_psyker_title", "classes")
_add_category("ogryn_2", "loc_class_ogryn_title", "classes")
_add_category("enemies", "loc_achievement_category_enemies_label")
_add_category("missions", "loc_achievement_category_missions_label")
_add_category("missions_general", "loc_achievement_subcategory_missions_general_label", "missions")
_add_category("twins_mission", "loc_achievement_subcategory_twins_mission_label", "missions")
_add_category("offensive", "loc_achievement_category_offensive_label")
_add_category("defensive", "loc_achievement_category_defensive_label")
_add_category("teamplay", "loc_achievement_category_teamplay_label")
_add_category("class_challenges", "loc_achievement_category_class_challenges_label")
_add_category("ogryn_2_challenges", "loc_achievement_category_ogryn_2_label", "class_challenges")
_add_category("zealot_2_challenges", "loc_achievement_category_zealot_2_label", "class_challenges")
_add_category("psyker_2_challenges", "loc_achievement_category_psyker_2_label", "class_challenges")
_add_category("veteran_2_challenges", "loc_achievement_category_veteran_2_label", "class_challenges")
table.make_strict_with_interface(AchievementCategories, "AchievementCategories", AchievementCategoriesInterface)

return settings("AchievementCategories", AchievementCategories)
