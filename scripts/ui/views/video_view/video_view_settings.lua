local VideoViewSettings = {}
local cinematic_video_templates = {}

local function _extract_cinematic_video_templates(path)
	local cinematic_scene = require(path)

	for name, cinematic_video_data in pairs(cinematic_scene) do
		cinematic_video_templates[name] = cinematic_video_data
	end
end

_extract_cinematic_video_templates("scripts/settings/cinematic_video/templates/cs06")

VideoViewSettings.templates = cinematic_video_templates

return settings("VideoViewSettings", VideoViewSettings)
