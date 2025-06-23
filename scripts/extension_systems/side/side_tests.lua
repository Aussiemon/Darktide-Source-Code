-- chunkname: @scripts/extension_systems/side/side_tests.lua

local function init_and_run_tests(Side)
	local side_extension_dummy = {
		breed_tags = {},
		side = {}
	}
	local player_side_extension_dummy = {
		is_player_unit = true,
		breed_tags = {},
		side = {}
	}
	local side1 = Side:new({
		name = "test1"
	}, 1)
	local side2 = Side:new({
		name = "test2"
	}, 2)

	side1:set_relation("enemy", {
		side2
	})
	side2:set_relation("enemy", {
		side1
	})
	side1:set_relation("allied", {
		side1
	})
	side2:set_relation("allied", {
		side2
	})

	local side_one_allies = side1:relation_sides("allied")
	local side_two_allies = side2:relation_sides("allied")

	side1:add_unit("unit_test_1", side_extension_dummy)
	side1:remove_unit("unit_test_1", side_extension_dummy)
	side1:add_unit("unit_test_1", side_extension_dummy)
	side1:add_unit("unit_test_2", side_extension_dummy)
	side1:add_unit("unit_test_3", side_extension_dummy)
	side1:add_unit("unit_test_4", side_extension_dummy)
	side1:remove_unit("unit_test_2", side_extension_dummy)
	side1:remove_unit("unit_test_4", side_extension_dummy)
	side1:remove_unit("unit_test_3", side_extension_dummy)
	side1:remove_unit("unit_test_1", side_extension_dummy)
	side1:add_relation_unit("unit_test_1", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_2", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_3", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_4", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_2", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_1", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_3", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_4", side_extension_dummy, "enemy")
	side1:add_unit("player_unit_1", player_side_extension_dummy)
	side1:add_unit("player_unit_2", player_side_extension_dummy)
	side1:add_unit("player_unit_3", player_side_extension_dummy)
	side1:add_unit("player_unit_4", player_side_extension_dummy)
	side1:remove_unit("player_unit_2", player_side_extension_dummy)
	side1:remove_unit("player_unit_1", player_side_extension_dummy)
	side1:remove_unit("player_unit_3", player_side_extension_dummy)
	side1:remove_unit("player_unit_4", player_side_extension_dummy)
	side1:add_relation_unit("player_unit_1", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_2", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_3", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_4", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_2", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_3", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_4", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_1", player_side_extension_dummy, "enemy")
end

return init_and_run_tests
