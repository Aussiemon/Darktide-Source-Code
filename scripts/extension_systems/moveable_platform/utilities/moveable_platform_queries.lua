-- chunkname: @scripts/extension_systems/moveable_platform/utilities/moveable_platform_queries.lua

local MoveablePlatformQueries = {}

MoveablePlatformQueries.interaction_hud_description = function (moveable_platform_extension, interactable_actor_node_index)
	local interactables = moveable_platform_extension:get_interactables()

	for _, interactable in pairs(interactables) do
		if interactable.node_id == interactable_actor_node_index then
			return interactable.hud_description
		end
	end

	return nil
end

MoveablePlatformQueries.activate_platform = function (moveable_platform_extension, interactable_actor_node_index)
	local interactables = moveable_platform_extension:get_interactables()

	for _, interactable in pairs(interactables) do
		if interactable.node_id == interactable_actor_node_index then
			if interactable.action == "forward" then
				moveable_platform_extension:move_forward()
			elseif interactable.action == "backward" then
				moveable_platform_extension:move_backward()
			end
		end
	end
end

MoveablePlatformQueries.interaction_offset = function (platform_unit, moveable_platform_extension, interactable_actor_node_index)
	local interactables = moveable_platform_extension:get_interactables()

	for _, interactable in pairs(interactables) do
		if interactable.node_id == interactable_actor_node_index and Unit.has_node(platform_unit, interactable.name) then
			local interactable_id = Unit.node(platform_unit, interactable.name)
			local offset = Unit.local_position(platform_unit, interactable_id)

			return offset
		end
	end

	return Vector3.zero()
end

return MoveablePlatformQueries
