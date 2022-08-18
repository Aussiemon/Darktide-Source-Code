local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = {
	enable_world_fullscreen_blur = function (world_name, viewport_name, blur_amount)
		local world_manager = Managers.world
		local world = world_manager:has_world(world_name) and world_manager:world(world_name)

		if world then
			local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

			if viewport then
				local shading_environment = Viewport.get_data(viewport, "shading_environment")

				if shading_environment then
					World.set_data(world, "fullscreen_blur", blur_amount or 0.75)
				end
			end
		end
	end,
	disable_world_fullscreen_blur = function (world_name, viewport_name)
		local world_manager = Managers.world
		local world = world_manager:has_world(world_name) and world_manager:world(world_name)

		if world then
			local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

			if viewport then
				local shading_environment = Viewport.get_data(viewport, "shading_environment")

				if shading_environment then
					World.set_data(world, "fullscreen_blur", 0)
				end
			end
		end
	end,
	activate_world = function (world_name, viewport_name)
		local world_manager = Managers.world
		local world = world_manager:has_world(world_name) and world_manager:world(world_name)

		if world then
			local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

			if viewport then
				ScriptWorld.activate_viewport(world, viewport)
				world_manager:enable_world(world_name, true)
			end
		end
	end,
	deactivate_world = function (world_name, viewport_name)
		local world_manager = Managers.world
		local world = world_manager:has_world(world_name) and world_manager:world(world_name)

		if world then
			local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

			if viewport then
				ScriptWorld.deactivate_viewport(world, viewport)
				world_manager:enable_world(world_name, false)
			end
		end
	end
}

return WorldRenderUtils
