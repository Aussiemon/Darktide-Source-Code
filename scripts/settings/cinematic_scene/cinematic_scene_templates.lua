local cinematic_scene_templates = {}

local function _extract_cinematic_scene_templates(path)
	local cinematic_scene = require(path)

	for name, cinematic_scene_data in pairs(cinematic_scene) do
		cinematic_scene_data.ignored_slots = table.mirror_table(cinematic_scene_data.ignored_slots)
		cinematic_scene_templates[name] = cinematic_scene_data
	end
end

_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_1")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_2")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_3")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_4")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_5")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_5_hub")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_6")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_7")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_8")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_9")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/cutscene_10")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/intro_abc_template")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/outro_fail_template")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/outro_win_template")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_01")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_02")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_03")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_04")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_05")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_06")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_07")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_08")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/path_of_trust_09")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/traitor_captain_intro")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_barber")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_contracts")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_crafting")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_gun_shop")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_mission_board")
_extract_cinematic_scene_templates("scripts/settings/cinematic_scene/templates/hub_location_intro_training_grounds")

for name, cinematic_scene_data in pairs(cinematic_scene_templates) do
	cinematic_scene_data.name = name
end

return settings("CinematicSceneTemplates", cinematic_scene_templates)
