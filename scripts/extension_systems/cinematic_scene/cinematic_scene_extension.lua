-- chunkname: @scripts/extension_systems/cinematic_scene/cinematic_scene_extension.lua

local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CinematicSceneExtension = class("CinematicSceneExtension")

CinematicSceneExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._cinematic_category = nil
	self._cinematic_name = CinematicSceneSettings.CINEMATIC_NAMES.none
	self._origin_level_name = nil
end

CinematicSceneExtension.setup_from_component = function (self, cinematic_name, cinematic_category, origin_level_name)
	self._cinematic_category = cinematic_category
	self._cinematic_name = cinematic_name
	self._origin_level_name = origin_level_name
end

CinematicSceneExtension.origin_level_name = function (self)
	return self._origin_level_name
end

CinematicSceneExtension.play_cutscene = function (self)
	local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

	if self._is_server then
		cinematic_scene_system:play_cutscene(self._cinematic_name)
	else
		cinematic_scene_system:request_play_cutscene(self._cinematic_name)
	end
end

return CinematicSceneExtension
