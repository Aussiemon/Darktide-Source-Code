-- chunkname: @scripts/components/utilities/shared_nav.lua

local SharedNav = {}

SharedNav.create_nav_info = function ()
	local component_nav_info = {}

	component_nav_info.nav_world = nil
	component_nav_info.nav_tag_cost_table = nil
	component_nav_info.traverse_logic = nil
	component_nav_info.nav_gen_guid = nil

	return component_nav_info
end

local function _clear_nav_info(nav_info)
	local nav_world = nav_info.nav_world

	if nav_world then
		GwNavWorld.destroy(nav_world)

		local nav_tag_cost_table = nav_info.nav_tag_cost_table

		if nav_tag_cost_table then
			GwNavTagLayerCostTable.destroy(nav_tag_cost_table)
		end

		local traverse_logic = nav_info.traverse_logic

		if traverse_logic then
			GwNavTraverseLogic.destroy(traverse_logic)
		end

		nav_info.nav_world = nil
		nav_info.nav_tag_cost_table = nil
		nav_info.traverse_logic = nil
	end
end

local function _editor_setup_shared_nav_world(nav_info, with_traverse_logic)
	_clear_nav_info(nav_info)

	local nav_data_paths = LevelEditor:get_active_navdata_paths()
	local num_nav_data_paths = #nav_data_paths

	if num_nav_data_paths == 0 then
		return false
	end

	local new_nav_world = GwNavWorld.create()

	for i = 1, num_nav_data_paths do
		local nav_data_path = nav_data_paths[i]

		GwNavGeneration.add_navdata_to_world(new_nav_world, nav_data_path)
	end

	if with_traverse_logic then
		local nav_tag_cost_table = GwNavTagLayerCostTable.create()
		local traverse_logic = GwNavTraverseLogic.create(new_nav_world)

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, nav_tag_cost_table)

		nav_info.nav_tag_cost_table = nav_tag_cost_table
		nav_info.traverse_logic = traverse_logic
	end

	nav_info.nav_world = new_nav_world

	return true
end

SharedNav.check_new_navmesh_generated = function (nav_info, component_nav_guid, with_traverse_logic)
	local nav_gen_guid = LevelEditor:nav_gen_guid()

	if nav_info.nav_gen_guid ~= nav_gen_guid or nav_info.nav_world == nil then
		_editor_setup_shared_nav_world(nav_info, with_traverse_logic)

		nav_info.nav_gen_guid = nav_gen_guid
	end

	if component_nav_guid ~= nav_info.nav_gen_guid and nav_info.nav_world then
		return nav_info.nav_gen_guid
	end

	return nil
end

return SharedNav
