-- chunkname: @scripts/settings/input/default_debug_input_filters.lua

local default_debug_input_filters = {
	pixeldistance = {
		filter_type = "and",
		input_mappings = {
			source1 = "pixeldistance_1",
			source2 = "pixeldistance_2",
		},
	},
}

return settings("DefaultDebugInputFilters", default_debug_input_filters)
