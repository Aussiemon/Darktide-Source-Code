local path_markers = {
	{
		crossroads = "",
		name = "path_marker_001",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 1,
		position = {
			-9.084799766540527,
			0.5343999862670898,
			0.21199999749660492
		}
	},
	{
		crossroads = "",
		name = "path_marker_002",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "break",
		order = 2,
		position = {
			11.222399711608887,
			0.5343999862670898,
			0.21400000154972076
		}
	},
	{
		crossroads = "",
		name = "path_marker_003",
		main_path_segment_index = 2,
		kind = "good",
		marker_type = "normal",
		order = 3,
		position = {
			7.481658935546875,
			399.731201171875,
			0.2070000022649765
		}
	},
	{
		crossroads = "",
		name = "path_marker_004",
		main_path_segment_index = 2,
		kind = "good",
		marker_type = "normal",
		order = 4,
		position = {
			17.63520050048828,
			399.731201171875,
			0.20600000023841858
		}
	}
}
local main_path_segments = {
	{
		path_length = 20.307199478149414,
		nodes = {
			{
				-9.084799766540527,
				0.5343999862670898,
				0.2711624801158905
			},
			{
				11.222399711608887,
				0.5343999862670898,
				0.27238279581069946
			}
		}
	},
	{
		path_length = 10.475516319274902,
		nodes = {
			{
				7.481658935546875,
				399.731201171875,
				0.23656514286994934
			},
			{
				11.917506217956543,
				398.4906311035156,
				0.27238279581069946
			},
			{
				12.833351135253906,
				398.5164794921875,
				0.27238279581069946
			},
			{
				17.63520050048828,
				399.731201171875,
				0.27238279581069946
			}
		}
	}
}
local crossroads = {}
local main_path_version = "1.00"

return {
	version = main_path_version,
	path_markers = path_markers,
	main_path_segments = main_path_segments,
	crossroads = crossroads
}
