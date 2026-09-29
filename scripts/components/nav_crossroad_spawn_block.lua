-- chunkname: @scripts/components/nav_crossroad_spawn_block.lua

local NavCrossroadSpawnBlock = component("NavCrossroadSpawnBlock")

NavCrossroadSpawnBlock.init = function (self, unit, is_server)
	self._is_server = is_server

	local nav_crossroad_spawn_block_extension = ScriptUnit.fetch_component_extension(unit, "nav_spawn_block_system")

	if nav_crossroad_spawn_block_extension then
		local volume_name = self:get_data(unit, "volume_name")
		local main_path_crossroad_id = self:get_data(unit, "main_path_crossroad_id")
		local allowed_main_path_crossroad_road_id = self:get_data(unit, "allowed_main_path_crossroad_road_id")

		nav_crossroad_spawn_block_extension:setup_from_component(unit, volume_name, main_path_crossroad_id, allowed_main_path_crossroad_road_id)

		self._nav_crossroad_spawn_block_extension = nav_crossroad_spawn_block_extension
		self._volume_name = volume_name
	end
end

NavCrossroadSpawnBlock.editor_validate = function (self, unit)
	local success = true
	local error_message = ""
	local volume_name = self:get_data(unit, "volume_name")

	if volume_name == "" then
		success = false
		error_message = error_message .. "\nVolume Name can't be empty"
	elseif rawget(_G, "LevelEditor") and not Unit.has_volume(unit, volume_name) then
		success = false
		error_message = error_message .. "\nMissing volume '" .. volume_name .. "'"
	end

	return success, error_message
end

NavCrossroadSpawnBlock.editor_init = function (self, unit)
	return
end

NavCrossroadSpawnBlock.enable = function (self, unit)
	return
end

NavCrossroadSpawnBlock.disable = function (self, unit)
	return
end

NavCrossroadSpawnBlock.destroy = function (self, unit)
	return
end

NavCrossroadSpawnBlock.component_data = {
	volume_name = {
		ui_name = "Volume Name",
		ui_type = "text_box",
		value = "g_volume_block",
	},
	main_path_crossroad_id = {
		ui_name = "Main Path Crossroad ID",
		ui_type = "text_box",
		value = "A",
	},
	allowed_main_path_crossroad_road_id = {
		ui_name = "Allowed Crossroad Road ID",
		ui_type = "number",
		value = 1,
	},
	extensions = {
		"NavCrossroadSpawnBlockExtension",
	},
}

return NavCrossroadSpawnBlock
