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
	fassert(side1:relation_sides("enemy")[1] == side2, "set_relation not working properly.")
	fassert(side2:relation_sides("enemy")[1] == side1, "set_relation not working properly.")
	side1:set_relation("allied", {
		side1
	})
	side2:set_relation("allied", {
		side2
	})

	local side_one_allies = side1:relation_sides("allied")

	fassert(#side_one_allies == 1, "invalid num allied sides")
	fassert(side_one_allies[1] == side1, "side1 not allied with itself")

	local side_two_allies = side2:relation_sides("allied")

	fassert(#side_two_allies == 1, "invalid num allied sides")
	fassert(side_two_allies[1] == side2, "side2 not allied with itself")
	side1:add_unit("unit_test_1", side_extension_dummy)
	fassert(side1.units_lookup.unit_test_1 == 1, "add_unit failed.")
	fassert(side1._units[1] == "unit_test_1", "add_unit failed.")
	side1:remove_unit("unit_test_1", side_extension_dummy)
	fassert(side1.units_lookup.unit_test_1 == nil, "remove_unit failed.")
	fassert(side1._units[1] == nil, "remove_unit failed.")
	side1:add_unit("unit_test_1", side_extension_dummy)
	side1:add_unit("unit_test_2", side_extension_dummy)
	side1:add_unit("unit_test_3", side_extension_dummy)
	side1:add_unit("unit_test_4", side_extension_dummy)
	fassert(side1.units_lookup.unit_test_4 == 4, "add_unit failed after multiple adds.")
	side1:remove_unit("unit_test_2", side_extension_dummy)
	fassert(side1.units_lookup.unit_test_4 == 2, "remove_unit failed when multiple units added.")
	fassert(side1._units[2] == "unit_test_4", "remove_unit failed to move last unit to replace index.")
	side1:remove_unit("unit_test_4", side_extension_dummy)
	side1:remove_unit("unit_test_3", side_extension_dummy)
	side1:remove_unit("unit_test_1", side_extension_dummy)
	fassert(#side1._units == 0, "failed to remove all units after adding multiple.")
	fassert(not next(side1.units_lookup), "failed to remove all units after adding multiple.")
	side1:add_relation_unit("unit_test_1", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_2", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_3", side_extension_dummy, "enemy")
	side1:add_relation_unit("unit_test_4", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_2", side_extension_dummy, "enemy")
	fassert(side1.enemy_units_lookup.unit_test_4 == 2, "remove enemy unit failed to remove correctly.")
	fassert(#side1._relation_units.enemy == 3, "remove enemy unit failed.")
	side1:remove_relation_unit("unit_test_1", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_3", side_extension_dummy, "enemy")
	side1:remove_relation_unit("unit_test_4", side_extension_dummy, "enemy")
	fassert(#side1._relation_units.enemy == 0, "failed to remove all enemy units after adding multiple.")
	fassert(not next(side1.enemy_units_lookup), "failed to remove all enemy units after adding multiple.")
	side1:add_unit("player_unit_1", player_side_extension_dummy)
	side1:add_unit("player_unit_2", player_side_extension_dummy)
	side1:add_unit("player_unit_3", player_side_extension_dummy)
	side1:add_unit("player_unit_4", player_side_extension_dummy)
	fassert(#side1._added_player_units == 4, "add player unit failed to add correctly.")
	side1:remove_unit("player_unit_2", player_side_extension_dummy)
	fassert(side1._added_player_units[2] == "player_unit_4", "remove player unit failed.")
	side1:remove_unit("player_unit_1", player_side_extension_dummy)
	side1:remove_unit("player_unit_3", player_side_extension_dummy)
	side1:remove_unit("player_unit_4", player_side_extension_dummy)
	fassert(#side1._added_player_units == 0, "remove player unit did not correctly remove all player units.")
	fassert(#side1._units == 0, "remove player unit did not correctly remove all units.")
	side1:add_relation_unit("player_unit_1", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_2", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_3", player_side_extension_dummy, "enemy")
	side1:add_relation_unit("player_unit_4", player_side_extension_dummy, "enemy")
	fassert(#side1._relation_player_units.enemy == 4, "add enemy player unit did not add correctly.")
	side1:remove_relation_unit("player_unit_2", player_side_extension_dummy, "enemy")
	fassert(side1._relation_player_units.enemy[2] == "player_unit_4", "remove enemy player unit did not remove correctly.")
	side1:remove_relation_unit("player_unit_3", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_4", player_side_extension_dummy, "enemy")
	side1:remove_relation_unit("player_unit_1", player_side_extension_dummy, "enemy")
	fassert(#side1._relation_player_units.enemy == 0, "remove enemy player unit did not correctly remove all player units.")
	fassert(#side1._relation_units.enemy == 0, "remove enemy player unit did not correctly remove all units.")
end

return init_and_run_tests
