local path_markers = {
	{
		kind = "good",
		name = "path_marker_001",
		main_path_segment_index = 1,
		crossroads = "",
		marker_type = "normal",
		order = 1,
		position = {
			-7.8037848472595215,
			0.11667200177907944,
			0.38999998569488525
		}
	},
	{
		kind = "good",
		name = "path_marker_002",
		main_path_segment_index = 1,
		crossroads = "",
		marker_type = "break",
		order = 2,
		position = {
			18.600006103515625,
			-3.7999998312443495e-05,
			0.43454399704933167
		}
	},
	{
		kind = "good",
		name = "path_marker_003",
		main_path_segment_index = 2,
		crossroads = "",
		marker_type = "normal",
		order = 3,
		position = {
			10.20001220703125,
			400.20001220703125,
			0.39101099967956543
		}
	},
	{
		kind = "good",
		name = "path_marker_004",
		main_path_segment_index = 2,
		crossroads = "",
		marker_type = "normal",
		order = 4,
		position = {
			24.614215850830078,
			400.2098388671875,
			0.3970159888267517
		}
	}
}
local main_path_segments = {
	{
		path_length = 26.404048919677734,
		nodes = {
			{
				-7.8037848472595215,
				0.11667200177907944,
				0.41774889826774597
			},
			{
				18.600006103515625,
				-3.7999998312443495e-05,
				0.42114630341529846
			}
		}
	},
	{
		path_length = 14.824810028076172,
		nodes = {
			{
				10.20001220703125,
				400.20001220703125,
				0.40871983766555786
			},
			{
				12.860603332519531,
				401.56500244140625,
				0.4176293611526489
			},
			{
				13.252500534057617,
				401.56500244140625,
				0.41775578260421753
			},
			{
				15.959999084472656,
				401.2799987792969,
				0.4185745120048523
			},
			{
				24.614215850830078,
				400.2098388671875,
				0.42121681571006775
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
