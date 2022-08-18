local BuffArgs = {}
local ARGS = {
	{
		block_prediction = true,
		name = "buff_lerp_value"
	},
	{
		block_prediction = true,
		name = "item_slot_name"
	},
	{
		name = "owner_unit"
	},
	{
		name = "source_item"
	}
}
local NUM_ARGS = #ARGS

for i = 1, NUM_ARGS do
	local argument = ARGS[i]
	local arg_name = argument.name
	ARGS[arg_name] = ARGS[i]
end

BuffArgs.add_args_to_context = function (context, ...)
	local num_args = select("#", ...)

	for i = 1, num_args, 2 do
		local arg, val = select(i, ...)
		context[arg] = val
	end
end

local EMPTY_TABLE = {}

BuffArgs.is_only_predictable_data = function (...)
	BuffArgs.add_args_to_context(EMPTY_TABLE, ...)

	local all_ok = true

	for i = 1, NUM_ARGS do
		all_ok = all_ok and (not ARGS[i].block_prediction or EMPTY_TABLE[ARGS[i].name] == nil)
		EMPTY_TABLE[ARGS[i].name] = nil
	end

	return all_ok
end

return BuffArgs
