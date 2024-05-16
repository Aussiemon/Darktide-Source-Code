-- chunkname: @scripts/utilities/world_render.lua

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = {}

WorldRenderUtils.enable_world_ui_bloom = function (world_name, viewport_name, offset_falloffs, ui_bloom_tints)
	local world_manager = Managers.world
	local world = world_manager:has_world(world_name) and world_manager:world(world_name)

	if world then
		local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

		if viewport then
			local shading_environment = Viewport.get_data(viewport, "shading_environment")

			if shading_environment then
				World.set_data(world, "ui_bloom_enabled", 1)
				World.set_data(world, "ui_bloom_threshold_offset_falloff_1", offset_falloffs and offset_falloffs[1] or 0)
				World.set_data(world, "ui_bloom_threshold_offset_falloff_2", offset_falloffs and offset_falloffs[2] or 0.9)
				World.set_data(world, "ui_bloom_threshold_offset_falloff_3", offset_falloffs and offset_falloffs[3] or 0.3)
				World.set_data(world, "ui_bloom_tint_1", ui_bloom_tints and ui_bloom_tints[1] or 0.617)
				World.set_data(world, "ui_bloom_tint_2", ui_bloom_tints and ui_bloom_tints[2] or 0.491)
				World.set_data(world, "ui_bloom_tint_3", ui_bloom_tints and ui_bloom_tints[3] or 0.238)
			end
		end
	end
end

WorldRenderUtils.disable_world_ui_bloom = function (world_name, viewport_name)
	local world_manager = Managers.world
	local world = world_manager:has_world(world_name) and world_manager:world(world_name)

	if world then
		local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

		if viewport then
			local shading_environment = Viewport.get_data(viewport, "shading_environment")

			if shading_environment then
				World.set_data(world, "ui_bloom_enabled", 0)
			end
		end
	end
end

WorldRenderUtils.enable_world_fullscreen_blur = function (world_name, viewport_name, blur_amount)
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
end

WorldRenderUtils.disable_world_fullscreen_blur = function (world_name, viewport_name)
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
end

WorldRenderUtils.activate_world = function (world_name, viewport_name)
	local world_manager = Managers.world
	local world = world_manager:has_world(world_name) and world_manager:world(world_name)

	if world then
		local viewport = ScriptWorld.has_viewport(world, viewport_name) and ScriptWorld.viewport(world, viewport_name)

		if viewport then
			ScriptWorld.activate_viewport(world, viewport)
			world_manager:enable_world(world_name, true)
		end
	end
end

WorldRenderUtils.deactivate_world = function (world_name, viewport_name)
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

return WorldRenderUtils
