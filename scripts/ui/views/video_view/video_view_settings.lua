-- chunkname: @scripts/ui/views/video_view/video_view_settings.lua

local VideoViewSettings = {
	level_name = "content/levels/ui/video_view/video_view",
	timer_name = "ui",
	viewport_layer = 1,
	viewport_name = "ui_video_view_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_video_view_world",
}
local cinematic_video_templates = {}

local function _extract_cinematic_video_templates(path)
	local cinematic_scene = require(path)

	for name, cinematic_video_data in pairs(cinematic_scene) do
		cinematic_video_templates[name] = cinematic_video_data
	end
end

_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/cs06")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/s1_intro")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/voxshot_rise")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_mission_board")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_crafting_station_underground")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_contracts")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_barbershop")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_gun_shop")
_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/hli_penances")

VideoViewSettings.templates = cinematic_video_templates

return settings("VideoViewSettings", VideoViewSettings)
