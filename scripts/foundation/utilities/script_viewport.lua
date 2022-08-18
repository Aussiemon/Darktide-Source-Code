local ScriptViewport = {
	active = function (viewport)
		return Viewport.get_data(viewport, "active")
	end,
	camera = function (viewport)
		return Viewport.get_data(viewport, "camera")
	end,
	set_camera = function (viewport, camera)
		Viewport.set_data(viewport, "camera", camera)
	end,
	name = function (viewport)
		return Viewport.get_data(viewport, "name")
	end,
	shadow_cull_camera = function (viewport)
		return Viewport.get_data(viewport, "shadow_cull_camera")
	end
}

return ScriptViewport
