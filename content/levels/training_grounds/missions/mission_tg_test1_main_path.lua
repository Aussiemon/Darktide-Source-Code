local path_markers = {
	{
		crossroads = "",
		name = "path_marker_1",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 1,
		position = {
			-2.5,
			-62,
			0.03200000151991844
		}
	},
	{
		crossroads = "",
		name = "path_marker_100",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 100,
		position = {
			-38,
			-57.5,
			0.013000000268220901
		}
	}
}
local main_path_segments = {
	{
		path_length = 44.26532745361328,
		nodes = {
			{
				-2.5,
				-62,
				0.012617187574505806
			},
			{
				-8.22672176361084,
				-52.99778366088867,
				0.01261718850582838
			},
			{
				-12.312603950500488,
				-48.926631927490234,
				0.01261718850582838
			},
			{
				-15.545758247375488,
				-48.88576889038086,
				0.01261718850582838
			},
			{
				-23.82468605041504,
				-53.0189208984375,
				0.01261718850582838
			},
			{
				-26.2514591217041,
				-55.34382247924805,
				0.01261718850582838
			},
			{
				-26.889822006225586,
				-55.682952880859375,
				0.01261718850582838
			},
			{
				-38,
				-57.5,
				0.012617187574505806
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
