-- chunkname: @scripts/components/utilities/shared_nav.lua

local SharedNav = {}

SharedNav.create_nav_info = function ()
	local component_nav_info = {}

	component_nav_info.nav_world_from_level_id = {}
	component_nav_info.nav_tag_cost_table_from_level_id = {}
	component_nav_info.traverse_logic_from_level_id = {}
	component_nav_info.nav_gen_guid = nil

	return component_nav_info
end

local function _clear_nav_info(nav_info)
	local nav_world_from_level_id = nav_info.nav_world_from_level_id

	for level_id, nav_world in pairs(nav_world_from_level_id) do
		GwNavWorld.destroy(nav_world)

		nav_world_from_level_id[level_id] = nil
	end

	local nav_tag_cost_table_from_level_id = nav_info.nav_tag_cost_table_from_level_id

	for level_id, nav_tag_cost_table in pairs(nav_tag_cost_table_from_level_id) do
		GwNavTagLayerCostTable.destroy(nav_tag_cost_table)

		nav_tag_cost_table_from_level_id[level_id] = nil
	end

	local traverse_logic_from_level_id = nav_info.traverse_logic_from_level_id

	for level_id, traverse_logic in pairs(traverse_logic_from_level_id) do
		GwNavTraverseLogic.destroy(traverse_logic)

		traverse_logic_from_level_id[level_id] = nil
	end
end

local function _editor_setup_shared_nav_worlds(nav_info, with_traverse_logic)
	_clear_nav_info(nav_info)

	local nav_data_paths_from_level_id = LevelEditor.navdata_paths

	if table.is_empty(nav_data_paths_from_level_id) then
		return
	end

	local nav_world_from_level_id = nav_info.nav_world_from_level_id
	local nav_tag_cost_table_from_level_id = nav_info.nav_tag_cost_table_from_level_id
	local traverse_logic_from_level_id = nav_info.traverse_logic_from_level_id

	for level_id, nav_data_paths in pairs(nav_data_paths_from_level_id) do
		local num_nav_data_paths = #nav_data_paths

		if num_nav_data_paths > 0 then
			local nav_world = GwNavWorld.create()

			for i = 1, num_nav_data_paths do
				local nav_data_path = nav_data_paths[i]

				GwNavGeneration.add_navdata_to_world(nav_world, nav_data_path)
			end

			nav_world_from_level_id[level_id] = nav_world

			if with_traverse_logic then
				local nav_tag_cost_table = GwNavTagLayerCostTable.create()
				local traverse_logic = GwNavTraverseLogic.create(nav_world)

				GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, nav_tag_cost_table)

				nav_tag_cost_table_from_level_id[level_id] = nav_tag_cost_table
				traverse_logic_from_level_id[level_id] = traverse_logic
			end
		end
	end
end

SharedNav.check_new_navmesh_generated = function (nav_info, component_nav_guid, with_traverse_logic)
	local nav_gen_guid = LevelEditor:nav_gen_guid()

	if nav_info.nav_gen_guid ~= nav_gen_guid or table.is_empty(nav_info.nav_world_from_level_id) then
		_editor_setup_shared_nav_worlds(nav_info, with_traverse_logic)

		nav_info.nav_gen_guid = nav_gen_guid
	end

	if component_nav_guid ~= nav_info.nav_gen_guid and not table.is_empty(nav_info.nav_world_from_level_id) then
		return nav_info.nav_gen_guid
	else
		return nil
	end
end

SharedNav.destroy = function (nav_info)
	_clear_nav_info(nav_info)
end

return SharedNav
