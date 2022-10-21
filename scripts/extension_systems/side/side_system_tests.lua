local SideSystem = nil

local function dummy_update_frame_tables(side)
	local human_units = side.valid_human_units
	local human_unit_positions = side.valid_human_units_positions
	local num_human_units = 0

	table.clear(human_units)
	table.clear(human_unit_positions)

	local human_and_bot_units = side.valid_player_units
	local human_and_bot_unit_positions = side.valid_player_units_positions
	local num_human_and_bot_units = 0

	table.clear(human_and_bot_units)
	table.clear(human_and_bot_unit_positions)

	local player_units = side:added_player_units()
	local num_player_units = #player_units

	for i = 1, num_player_units do
		local unit = player_units[i]
		local position = Vector3.zero()
		num_human_and_bot_units = num_human_and_bot_units + 1
		human_and_bot_units[num_human_and_bot_units] = unit
		human_and_bot_unit_positions[num_human_and_bot_units] = position
		human_and_bot_units[unit] = num_human_and_bot_units
		num_human_units = num_human_units + 1
		human_units[num_human_units] = unit
		human_unit_positions[num_human_units] = position
		human_units[unit] = num_human_units
	end
end

local function dummy_update_enemy_frame_tables(side)
	local human_units = side.valid_enemy_human_units
	local human_unit_positions = side.valid_enemy_human_units_positions
	local num_human_units = 0

	table.clear(human_units)
	table.clear(human_unit_positions)

	local human_and_bot_units = side.valid_enemy_player_units
	local human_and_bot_unit_positions = side.valid_enemy_player_units_positions
	local num_human_and_bot_units = 0

	table.clear(human_and_bot_units)
	table.clear(human_and_bot_unit_positions)

	local enemy_player_units = side:relation_player_units("enemy")
	local num_enemy_player_units = #enemy_player_units

	for i = 1, num_enemy_player_units do
		local unit = enemy_player_units[i]
		local position = Vector3.zero()
		num_human_and_bot_units = num_human_and_bot_units + 1
		human_and_bot_units[num_human_and_bot_units] = unit
		human_and_bot_unit_positions[num_human_and_bot_units] = position
		human_and_bot_units[unit] = num_human_and_bot_units
		num_human_units = num_human_units + 1
		human_units[num_human_units] = unit
		human_unit_positions[num_human_units] = position
		human_units[unit] = num_human_units
	end

	local ai_target_units = side.ai_target_units
	local num_ai_target_units = 0

	table.clear(ai_target_units)

	local enemy_units = side:relation_units("enemy")
	local num_enemy_units = #enemy_units

	for i = 1, num_enemy_units do
		local unit = enemy_units[i]
		num_ai_target_units = num_ai_target_units + 1
		ai_target_units[num_ai_target_units] = unit
		ai_target_units[unit] = num_ai_target_units
	end
end

local function dummy_create_side_system(side_compositions)
	local dummy_object = {}
	dummy_object._sides, dummy_object._side_lookup, dummy_object._side_names = SideSystem._create_sides(dummy_object, side_compositions)

	SideSystem._setup_relations(dummy_object, side_compositions, dummy_object._sides, dummy_object._side_lookup)

	dummy_object.side_by_unit = {}
	dummy_object._unit_extension_data = {}
	local class_table = CLASSES.SideSystem

	setmetatable(dummy_object, class_table)

	return dummy_object
end

local function init_and_run_tests(side_system_object)
	SideSystem = side_system_object
	local side_compositions = {
		{
			name = "test1",
			color_name = "red",
			relations = {
				enemy = {
					"test2",
					"test3"
				}
			}
		},
		{
			name = "test2",
			color_name = "blue",
			relations = {
				enemy = {
					"test1"
				}
			}
		},
		{
			name = "test3",
			color_name = "green",
			relations = {
				enemy = {
					"test1"
				}
			}
		}
	}
	local side_system = dummy_create_side_system(side_compositions)
	local unit_extension_data = side_system._unit_extension_data
	unit_extension_data.player_unit_1 = {
		is_player_unit = true,
		breed_tags = {}
	}
	unit_extension_data.player_unit_2 = {
		is_player_unit = true,
		breed_tags = {}
	}
	unit_extension_data.player_unit_3 = {
		is_player_unit = true,
		breed_tags = {}
	}
	unit_extension_data.minion_1 = {
		is_player_unit = false,
		breed_tags = {}
	}
	unit_extension_data.minion_2 = {
		is_player_unit = false,
		breed_tags = {}
	}
	unit_extension_data.minion_3 = {
		is_player_unit = false,
		breed_tags = {}
	}
	unit_extension_data.minion_4 = {
		is_player_unit = false,
		breed_tags = {}
	}
	unit_extension_data.minion_5 = {
		is_player_unit = false,
		breed_tags = {}
	}
	local sides = side_system._sides
	local side_1 = sides[1]
	local side_2 = sides[2]
	local side_3 = sides[3]

	fassert(side_2:relation_sides("enemy")[1] == side_1, "enemy relation failed!")
	fassert(side_3:relation_sides("enemy")[1] == side_1, "enemy relation failed!")
	side_system:_add_unit_to_side("player_unit_1", 1)
	fassert(side_1:added_player_units()[1] == "player_unit_1", "add_unit_to_side failed!")
	fassert(side_2:relation_player_units("enemy")[1] == "player_unit_1", "add_unit_to_side failed at adding enemies.")
	fassert(side_3:relation_player_units("enemy")[1] == "player_unit_1", "add_unit_to_side failed at adding enemies.")
	side_system:_add_unit_to_side("player_unit_2", 1)
	side_system:_add_unit_to_side("player_unit_3", 1)

	for i = 1, #side_compositions do
		local side = sides[i]

		dummy_update_frame_tables(side)
		dummy_update_enemy_frame_tables(side)
	end

	side_system:remove_unit_from_tag_units("player_unit_2")
	side_system:_remove_unit_from_side("player_unit_2")
	fassert(side_1:added_player_units()[2] == "player_unit_3", "remove unit failed!")
	fassert(side_2:relation_player_units("enemy")[2] == "player_unit_3", "remove unit failed at removing from enemies.")
	fassert(side_3:relation_player_units("enemy")[2] == "player_unit_3", "remove unit failed at removing from enemies.")

	for i = 1, #side_compositions do
		local side = sides[i]

		dummy_update_frame_tables(side)
		dummy_update_enemy_frame_tables(side)
	end

	fassert(#side_1.valid_human_units == 2, "failed to update frame table.")
	fassert(#side_1.valid_human_units_positions == 2, "failed to update frame table.")
	fassert(#side_1.valid_player_units == 2, "failed to update frame table.")
	fassert(#side_1.valid_player_units_positions == 2, "failed to update frame table.")
	fassert(#side_1.ai_target_units == 0, "failed to update enemy frame table.")
	fassert(#side_2.ai_target_units == 2, "failed to update enemy frame table.")
	fassert(#side_3.ai_target_units == 2, "failed to update enemy frame table.")
	fassert(#side_2.valid_enemy_human_units == 2, "failed to update enemy frame table.")
	fassert(#side_2.valid_enemy_human_units_positions == 2, "failed to update enemy frame table.")
	fassert(#side_2.valid_enemy_player_units == 2, "failed to update enemy frame table.")
	fassert(#side_2.valid_enemy_player_units_positions == 2, "failed to update enemy frame table.")
	fassert(#side_3.valid_enemy_human_units == 2, "failed to update enemy frame table.")
	fassert(#side_3.valid_enemy_human_units_positions == 2, "failed to update enemy frame table.")
	fassert(#side_3.valid_enemy_player_units == 2, "failed to update enemy frame table.")
	fassert(#side_3.valid_enemy_player_units_positions == 2, "failed to update enemy frame table.")
	fassert(side_2.ai_target_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_2.ai_target_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_2.valid_enemy_player_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_2.valid_enemy_player_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_2.valid_enemy_human_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_2.valid_enemy_human_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_3.ai_target_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_3.ai_target_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_3.valid_enemy_player_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_3.valid_enemy_player_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_3.valid_enemy_human_units[2] == "player_unit_3", "failed to update enemy frame table.")
	fassert(side_3.valid_enemy_human_units.player_unit_3 == 2, "failed to update enemy frame table.")
	fassert(side_1.valid_human_units[2] == "player_unit_3", "failed to update frame table.")
	fassert(side_1.valid_human_units.player_unit_3 == 2, "failed to update frame table.")
	fassert(side_1.valid_player_units[2] == "player_unit_3", "failed to update frame table.")
	fassert(side_1.valid_player_units.player_unit_3 == 2, "failed to update frame table.")
	side_system:remove_unit_from_tag_units("player_unit_1")
	side_system:_remove_unit_from_side("player_unit_1")
	side_system:remove_unit_from_tag_units("player_unit_3")
	side_system:_remove_unit_from_side("player_unit_3")

	for i = 1, #side_compositions do
		local side = sides[i]

		dummy_update_frame_tables(side)
		dummy_update_enemy_frame_tables(side)
	end

	fassert(#side_1._added_player_units == 0, "remove unit failed!")
	fassert(#side_2._relation_player_units.enemy == 0, "remove unit failed at removing")
	fassert(#side_3._relation_player_units.enemy == 0, "remove unit failed at removing")
	fassert(#side_1.valid_human_units == 0, "failed to update frame table.")
	fassert(#side_1.valid_human_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_1.valid_human_units), "failed to update frame table.")
	fassert(#side_1.valid_player_units == 0, "failed to update frame table.")
	fassert(#side_1.valid_player_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_1.valid_player_units), "failed to update frame table.")
	fassert(#side_2.ai_target_units == 0, "failed to update frame table.")
	fassert(not next(side_2.ai_target_units), "failed to update frame table.")
	fassert(#side_2.valid_enemy_human_units == 0, "failed to update frame table.")
	fassert(#side_2.valid_enemy_human_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_2.valid_enemy_human_units), "failed to update frame table.")
	fassert(#side_2.valid_enemy_player_units == 0, "failed to update frame table.")
	fassert(#side_2.valid_enemy_player_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_2.valid_enemy_player_units), "failed to update frame table.")
	fassert(#side_3.ai_target_units == 0, "failed to update frame table.")
	fassert(not next(side_3.ai_target_units), "failed to update frame table.")
	fassert(#side_3.valid_enemy_human_units == 0, "failed to update frame table.")
	fassert(#side_3.valid_enemy_human_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_3.valid_enemy_human_units), "failed to update frame table.")
	fassert(#side_3.valid_enemy_player_units == 0, "failed to update frame table.")
	fassert(#side_3.valid_enemy_player_units_positions == 0, "failed to update frame table.")
	fassert(not next(side_3.valid_enemy_player_units), "failed to update frame table.")
	side_system:_add_unit_to_side("minion_1", 1)
	side_system:_add_unit_to_side("minion_2", 2)
	side_system:_add_unit_to_side("minion_3", 2)
	side_system:_add_unit_to_side("minion_4", 3)
	side_system:_add_unit_to_side("minion_5", 3)
	side_system:add_aggroed_minion("minion_1")
	fassert(#side_1.aggroed_minion_target_units == 0, "Failed adding aggroed minion.")
	fassert(#side_2.aggroed_minion_target_units == 1, "Failed adding aggroed minion.")
	fassert(#side_3.aggroed_minion_target_units == 1, "Failed adding aggroed minion.")
	side_system:remove_aggroed_minion("minion_1")
	fassert(#side_1.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	fassert(#side_2.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	fassert(#side_3.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	side_system:add_aggroed_minion("minion_1")
	side_system:add_aggroed_minion("minion_2")
	side_system:add_aggroed_minion("minion_3")
	side_system:add_aggroed_minion("minion_4")
	side_system:add_aggroed_minion("minion_5")
	fassert(#side_1.aggroed_minion_target_units == 4, "Failed adding aggroed minion.")
	fassert(#side_2.aggroed_minion_target_units == 1, "Failed adding aggroed minion.")
	fassert(#side_3.aggroed_minion_target_units == 1, "Failed adding aggroed minion.")
	side_system:remove_aggroed_minion("minion_1")
	side_system:remove_aggroed_minion("minion_2")
	side_system:remove_aggroed_minion("minion_3")
	side_system:remove_aggroed_minion("minion_4")
	side_system:remove_aggroed_minion("minion_5")
	fassert(#side_1.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	fassert(#side_2.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	fassert(#side_3.aggroed_minion_target_units == 0, "Failed removing aggroed minion.")
	side_system:remove_unit_from_tag_units("minion_1")
	side_system:remove_unit_from_tag_units("minion_2")
	side_system:remove_unit_from_tag_units("minion_3")
	side_system:remove_unit_from_tag_units("minion_4")
	side_system:remove_unit_from_tag_units("minion_5")
	side_system:_remove_unit_from_side("minion_1")
	side_system:_remove_unit_from_side("minion_2")
	side_system:_remove_unit_from_side("minion_3")
	side_system:_remove_unit_from_side("minion_4")
	side_system:_remove_unit_from_side("minion_5")
	side_system:destroy()
end

return init_and_run_tests
