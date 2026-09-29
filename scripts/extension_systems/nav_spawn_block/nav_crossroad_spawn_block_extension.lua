-- chunkname: @scripts/extension_systems/nav_spawn_block/nav_crossroad_spawn_block_extension.lua

local NavCrossroadSpawnBlockExtension = class("NavCrossroadSpawnBlockExtension")

NavCrossroadSpawnBlockExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._nav_tag_volume = nil
end

NavCrossroadSpawnBlockExtension.destroy = function (self)
	if self._nav_tag_volume then
		Managers.state.nav_mesh:remove_nav_tag_volume(self._nav_tag_volume)
	end
end

NavCrossroadSpawnBlockExtension.setup_from_component = function (self, unit, volume_name, main_path_crossroad_id, allowed_main_path_crossroad_road_id)
	local main_path_manager = Managers.state.main_path
	local chosen_road_id = main_path_manager:crossroad_road_id(main_path_crossroad_id)

	if chosen_road_id and chosen_road_id ~= allowed_main_path_crossroad_road_id then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local layer_name = "nav_spawn_block_volume_static_" .. tostring(unit_level_index) .. "_" .. volume_name
		local volume_points = Unit.volume_points(unit, volume_name)
		local volume_height = Unit.volume_height(unit, volume_name)
		local volume_alt_min, volume_alt_max = self:_get_volume_alt_min_max(unit, volume_points, volume_height)

		self._nav_tag_volume = Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name, true, "content/volume_types/nav_tag_volumes/no_spawn")
	end
end

NavCrossroadSpawnBlockExtension._get_volume_alt_min_max = function (self, unit, volume_points, volume_height)
	local alt_min, alt_max

	for i = 1, #volume_points do
		local alt = volume_points[i].z

		if not alt_min or alt < alt_min then
			alt_min = alt
		end

		if not alt_max or alt_max < alt + volume_height then
			alt_max = alt + volume_height
		end
	end

	return alt_min, alt_max
end

return NavCrossroadSpawnBlockExtension
