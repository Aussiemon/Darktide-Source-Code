-- chunkname: @scripts/extension_systems/liquid_area/utilities/liquid_area.lua

local LiquidAreaSettings = require("scripts/settings/liquid_area/liquid_area_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local LiquidArea = {}
local NAV_MESH_ABOVE, NAV_MESH_BELOW = LiquidAreaSettings.nav_mesh_above, LiquidAreaSettings.nav_mesh_below
local NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH = LiquidAreaSettings.nav_mesh_lateral, LiquidAreaSettings.distance_from_nav_mesh
local UNIT_TEMPLATE_NAME = "liquid_area"

LiquidArea.try_create = function (position, flow_direction, nav_world, liquid_area_template, optional_source_unit, optional_max_liquid, optional_not_on_other_liquids, optional_source_item, optional_source_side)
	local liquid_area_system = Managers.state.extension:system("liquid_area_system")
	local traverse_logic = liquid_area_system:traverse_logic()
	local nav_mesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, position, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH)

	if nav_mesh_position == nil then
		return nil
	elseif optional_not_on_other_liquids then
		local is_position_in_liquid = liquid_area_system:is_position_in_liquid(nav_mesh_position)

		if is_position_in_liquid then
			return nil
		end
	end

	local liquid_unit = Managers.state.unit_spawner:spawn_network_unit(nil, UNIT_TEMPLATE_NAME, nav_mesh_position, nil, nil, liquid_area_template, flow_direction, optional_source_unit, optional_max_liquid, nil, optional_source_item, optional_source_side)

	return liquid_unit
end

LiquidArea.start_paint = function ()
	local liquid_area_system = Managers.state.extension:system("liquid_area_system")
	local liquid_paint_id = liquid_area_system:start_paint()

	return liquid_paint_id
end

LiquidArea.paint = function (liquid_paint_id, max_liquid_paint_distance, position, nav_world, liquid_area_template, allow_liquid_unit_creation, optional_brush_size, optional_not_on_other_liquids, optional_source_unit, optional_source_item, optional_source_side)
	local liquid_unit, created_new_liquid_unit = nil, false
	local liquid_area_system = Managers.state.extension:system("liquid_area_system")
	local traverse_logic = liquid_area_system:traverse_logic()
	local nav_mesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, position, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH)

	if nav_mesh_position == nil then
		return liquid_unit, created_new_liquid_unit
	elseif optional_not_on_other_liquids then
		local is_position_in_liquid = liquid_area_system:is_position_in_liquid(nav_mesh_position)

		if is_position_in_liquid then
			return liquid_unit, created_new_liquid_unit
		end
	end

	liquid_unit = liquid_area_system:paint(liquid_paint_id, max_liquid_paint_distance, nav_mesh_position, optional_brush_size)

	if not liquid_unit and allow_liquid_unit_creation then
		created_new_liquid_unit = true

		local flow_direction, max_liquid

		liquid_unit = Managers.state.unit_spawner:spawn_network_unit(nil, UNIT_TEMPLATE_NAME, nav_mesh_position, nil, nil, liquid_area_template, flow_direction, optional_source_unit, max_liquid, liquid_paint_id, optional_source_item, optional_source_side)
	end

	return liquid_unit, created_new_liquid_unit
end

LiquidArea.stop_paint = function (liquid_paint_id)
	local liquid_area_system = Managers.state.extension:system("liquid_area_system")

	liquid_area_system:stop_paint(liquid_paint_id)
end

return LiquidArea
