local cinematic_scene_templates = {}

local function _extract_cinematic_scene_templates(path)
	local cinematic_scene = require(path)

	for name, cinematic_scene_data in pairs(cinematic_scene) do
		fassert(cinematic_scene_templates[name] == nil, "Found cinematic scene with the same name %q", name)

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

for name, cinematic_scene_data in pairs(cinematic_scene_templates) do
	cinematic_scene_data.name = name
end

return settings("CinematicSceneTemplates", cinematic_scene_templates)
