local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local stagger_types = StaggerSettings.stagger_types
local optional_stagger_types = StaggerSettings.optional_stagger_types
local TEMP_SEEN_STAGGER_TYPES = {}
local TEMP_MISSING_STAGGER_TYPES = {}
local bt_node_test_functions = {
	BtStaggerAction = function (behavior_tree_name, node_name, action_data)
		local stagger_anims = action_data.stagger_anims

		for stagger_type, _ in pairs(stagger_anims) do
			if not rawget(stagger_types, stagger_type) then
				Log.warning("BreedActionsTest", "[BtStaggerAction] %q (%q) action_data stagger_anims has unknown stagger_type %q.", behavior_tree_name, node_name, stagger_type)
			end

			TEMP_SEEN_STAGGER_TYPES[stagger_type] = true
		end

		local num_missing_stagger_types = 0

		for stagger_type, _ in pairs(stagger_types) do
			if not TEMP_SEEN_STAGGER_TYPES[stagger_type] and not optional_stagger_types[stagger_type] then
				num_missing_stagger_types = num_missing_stagger_types + 1
				TEMP_MISSING_STAGGER_TYPES[num_missing_stagger_types] = stagger_type
			end
		end

		table.sort(TEMP_MISSING_STAGGER_TYPES)

		local missing_stagger_types_string = table.concat(TEMP_MISSING_STAGGER_TYPES, "\n\t")

		fassert(num_missing_stagger_types == 0, "[BreedActionsTest] [BtStaggerAction] %q (%q) action_data is missing stagger_anims entries for:\n\t%s", behavior_tree_name, node_name, missing_stagger_types_string)
		table.clear(TEMP_SEEN_STAGGER_TYPES)
		table.clear_array(TEMP_MISSING_STAGGER_TYPES, num_missing_stagger_types)
	end
}
local CLASS_NAME_INDEX = 1

local function _evaluate_node(behavior_tree_name, node)
	local class_name = node[CLASS_NAME_INDEX]
	local action_data = node.action_data
	local test_function = bt_node_test_functions[class_name]

	if action_data and test_function then
		test_function(behavior_tree_name, node.name, action_data)
	end

	for i = 2, #node, 1 do
		_evaluate_node(behavior_tree_name, node[i])
	end
end

local function _init_and_run_tests(behavior_trees)
	for bt_name, bt_node in pairs(behavior_trees) do
		_evaluate_node(bt_name, bt_node)
	end
end

return _init_and_run_tests
