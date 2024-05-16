-- chunkname: @scripts/foundation/utilities/script_viewport.lua

local ScriptViewport = {}

ScriptViewport.active = function (viewport)
	return Viewport.get_data(viewport, "active")
end

ScriptViewport.camera = function (viewport)
	return Viewport.get_data(viewport, "camera")
end

ScriptViewport.set_camera = function (viewport, camera)
	Viewport.set_data(viewport, "camera", camera)
end

ScriptViewport.name = function (viewport)
	return Viewport.get_data(viewport, "name")
end

ScriptViewport.shadow_cull_camera = function (viewport)
	return Viewport.get_data(viewport, "shadow_cull_camera")
end

return ScriptViewport
