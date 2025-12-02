-- chunkname: @scripts/extension_systems/buff/utility/buff_args.lua

local BuffArgs = {}
local NIL_VALUE = "__NIL_VALUE__"
local ARGS = {
	{
		block_prediction = true,
		name = "buff_lerp_value",
	},
	{
		block_prediction = true,
		name = "item_slot_name",
	},
	{
		block_prediction = true,
		name = "parent_buff_template",
	},
	{
		block_prediction = true,
		name = "skip_talent",
		default_value = NIL_VALUE,
	},
	{
		component_type = "Unit",
		name = "owner_unit",
		default_value = NIL_VALUE,
	},
	{
		default_value = "not_equipped",
		name = "source_item",
		component_type = {
			network_type = "player_item_name",
			use_network_lookup = "player_item_names",
		},
	},
	{
		default_value = "n/a",
		name = "from_talent",
		component_type = {
			network_type = "talent_name_id",
			use_network_lookup = "archetype_talent_names",
		},
	},
}
local NUM_ARGS = #ARGS

for i = 1, NUM_ARGS do
	local argument = ARGS[i]
	local arg_name = argument.name

	ARGS[arg_name] = ARGS[i]
end

BuffArgs.add_args_to_context = function (context, added_args, ...)
	local num_args = select("#", ...)

	for i = 1, num_args, 2 do
		local arg, val = select(i, ...)

		context[arg] = val
		added_args[arg] = val
	end

	local player = context.player
	local item_slot_name = context.item_slot_name

	if player and item_slot_name then
		local profile = player:profile()
		local equipped_item = profile.loadout[item_slot_name]

		context.item = equipped_item
	end
end

local EMPTY_TABLE = {}

BuffArgs.is_only_predictable_data = function (...)
	BuffArgs.add_args_to_context(EMPTY_TABLE, EMPTY_TABLE, ...)

	local all_ok = true

	for i = 1, NUM_ARGS do
		all_ok = all_ok and (not ARGS[i].block_prediction or EMPTY_TABLE[ARGS[i].name] == nil)
		EMPTY_TABLE[ARGS[i].name] = nil
	end

	return all_ok
end

local PREDICTABLE_ARGS = table.array_to_map(ARGS, function (_, v)
	if not v.block_prediction then
		return v.name, v.default_value
	end
end)

BuffArgs.predictable_default_values = function ()
	return PREDICTABLE_ARGS
end

local COMPONENT_TYPES = table.array_to_map(ARGS, function (_, v)
	if not v.block_prediction then
		return v.name, v.component_type
	end
end)

BuffArgs.predictable_component_types = function ()
	return COMPONENT_TYPES
end

BuffArgs.nil_value = function ()
	return NIL_VALUE
end

return BuffArgs
