local default_debug_input_filters = {
	pixeldistance = {
		filter_type = "and",
		input_mappings = {
			source2 = "pixeldistance_2",
			source1 = "pixeldistance_1"
		}
	}
}

return settings("DefaultDebugInputFilters", default_debug_input_filters)
