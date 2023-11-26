-- chunkname: @scripts/components/utilities/minion_multi_teleporter_queries.lua

local NavQueries = require("scripts/utilities/nav_queries")
local SmartObject = require("scripts/extension_systems/nav_graph/utilities/smart_object")
local MinionMultiTeleporterQueries = {}
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 0.4, 0.4
local LAYER_TYPE, IS_BIDIRECTIONAL = "teleporters", false

MinionMultiTeleporterQueries.generate_smart_object = function (unit, nav_world, destination_teleporter_unit)
	local unit_position = Unit.world_position(unit, 1)
	local entrance_position = NavQueries.position_on_mesh(nav_world, unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not entrance_position then
		return nil, nil
	end

	local teleporter_unit_position = Unit.world_position(destination_teleporter_unit, 1)
	local exit_position = NavQueries.position_on_mesh(nav_world, teleporter_unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not exit_position then
		return nil, nil
	end

	local smart_object, smart_object_id = SmartObject:new()

	smart_object:set_entrance_exit_positions(entrance_position, exit_position)
	smart_object:set_is_bidirectional(IS_BIDIRECTIONAL)
	smart_object:set_layer_type(LAYER_TYPE)

	return smart_object, smart_object_id
end

local TEMP_SMART_OBJECTS, TEMP_SMART_OBJECT_ID_LOOKUP = {}, {}

MinionMultiTeleporterQueries.generate_smart_objects = function (unit, nav_world, teleporter_units)
	table.clear_array(TEMP_SMART_OBJECTS, #TEMP_SMART_OBJECTS)
	table.clear(TEMP_SMART_OBJECT_ID_LOOKUP)

	local unit_position = Unit.world_position(unit, 1)
	local entrance_position = NavQueries.position_on_mesh(nav_world, unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not entrance_position then
		return nil, nil
	end

	for teleporter_unit, _ in pairs(teleporter_units) do
		repeat
			if teleporter_unit == unit then
				break
			end

			local teleporter_unit_position = Unit.world_position(teleporter_unit, 1)
			local exit_position = NavQueries.position_on_mesh(nav_world, teleporter_unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

			if exit_position then
				local smart_object, smart_object_id = SmartObject:new()

				smart_object:set_entrance_exit_positions(entrance_position, exit_position)
				smart_object:set_is_bidirectional(IS_BIDIRECTIONAL)
				smart_object:set_layer_type(LAYER_TYPE)

				TEMP_SMART_OBJECTS[#TEMP_SMART_OBJECTS + 1] = smart_object
				TEMP_SMART_OBJECT_ID_LOOKUP[teleporter_unit] = smart_object_id
			end
		until true
	end

	return TEMP_SMART_OBJECTS, TEMP_SMART_OBJECT_ID_LOOKUP
end

return MinionMultiTeleporterQueries
