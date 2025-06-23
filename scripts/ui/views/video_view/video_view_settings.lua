-- chunkname: @scripts/ui/views/video_view/video_view_settings.lua

local VideoViewSettings = {
	viewport_layer = 1,
	level_name = "content/levels/ui/video_view/video_view",
	timer_name = "ui",
	world_layer = 1,
	viewport_type = "default",
	viewport_name = "ui_video_view_world_viewport",
	world_name = "ui_video_view_world"
}
local cinematic_video_templates = {}

local function _extract_cinematic_video_templates(path)
	local cinematic_scene = require(path)

	for name, cinematic_video_data in pairs(cinematic_scene) do
		cinematic_video_templates[name] = cinematic_video_data
	end
end

_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/adamant_intro")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/cs06")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_01")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_02")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_03")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_04")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_05")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_06")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_07")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_08")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_09")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_10")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_11")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_12")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_13")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_14")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_15")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_16")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/debriefing_17")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/cin_nox_alpha")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/s1_intro")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/core_research_intro")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/voxshot_rise")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_mission_board")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_mission_board_adamant")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_crafting_station_underground")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_contracts")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_barbershop")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_gun_shop")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_penances")

VideoViewSettings.templates = cinematic_video_templates

return settings("VideoViewSettings", VideoViewSettings)
