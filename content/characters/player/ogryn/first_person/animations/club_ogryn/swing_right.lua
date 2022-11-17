local spline_matrices = {
	[0] = {
		0.99016,
		0.04943,
		-0.130918,
		0,
		-0.108828,
		-0.316146,
		-0.942448,
		0,
		-0.087974,
		0.947422,
		-0.307656,
		0,
		0.709124,
		-0.115665,
		-1.269553,
		1
	},
	{
		0.993261,
		-0.072595,
		-0.090343,
		0,
		-0.112161,
		-0.405811,
		-0.907049,
		0,
		0.029185,
		0.911069,
		-0.411218,
		0,
		0.709124,
		-0.115665,
		-1.269553,
		1
	},
	[0.0333333333333] = {
		0.990569,
		-0.083253,
		-0.108823,
		0,
		-0.134781,
		-0.449177,
		-0.883218,
		0,
		0.02465,
		0.889555,
		-0.456162,
		0,
		0.674419,
		-0.139696,
		-1.250866,
		1
	},
	[0.0666666666667] = {
		0.973443,
		-0.225837,
		-0.037508,
		0,
		-0.167177,
		-0.589318,
		-0.790415,
		0,
		0.156401,
		0.775694,
		-0.611422,
		0,
		0.580121,
		-0.16542,
		-1.202529,
		1
	},
	[0.133333333333] = {
		0.850364,
		-0.464405,
		0.247404,
		0,
		-0.306455,
		-0.819302,
		-0.484591,
		0,
		0.427746,
		0.336261,
		-0.839025,
		0,
		0.255111,
		-0.204722,
		-1.027416,
		1
	},
	[0.166666666667] = {
		0.740201,
		-0.513705,
		0.433831,
		0,
		-0.425873,
		-0.857478,
		-0.288728,
		0,
		0.520322,
		0.02896,
		-0.853479,
		0,
		0.047197,
		-0.206064,
		-0.909816,
		1
	},
	[0.1] = {
		0.928872,
		-0.360809,
		0.083746,
		0,
		-0.220782,
		-0.72087,
		-0.656964,
		0,
		0.297409,
		0.591746,
		-0.749256,
		0,
		0.436749,
		-0.188977,
		-1.126885,
		1
	},
	[0.233333333333] = {
		0.484682,
		-0.425091,
		0.764448,
		0,
		-0.712891,
		-0.698381,
		0.063641,
		0,
		0.506823,
		-0.575814,
		-0.641536,
		0,
		-0.389514,
		-0.145928,
		-0.653575,
		1
	},
	[0.266666666667] = {
		0.376923,
		-0.318916,
		0.86961,
		0,
		-0.838279,
		-0.516795,
		0.173816,
		0,
		0.393977,
		-0.794491,
		-0.462133,
		0,
		-0.585691,
		-0.082168,
		-0.532184,
		1
	},
	[0.2] = {
		0.611685,
		-0.497855,
		0.614803,
		0,
		-0.568151,
		-0.817245,
		-0.096519,
		0,
		0.550497,
		-0.290261,
		-0.782753,
		0,
		-0.172985,
		-0.187381,
		-0.782163,
		1
	},
	[0.333333333333] = {
		0.246817,
		-0.113927,
		0.962342,
		0,
		-0.968877,
		-0.048419,
		0.242761,
		0,
		0.018938,
		-0.992309,
		-0.122332,
		0,
		-0.85273,
		0.103148,
		-0.332938,
		1
	},
	[0.366666666667] = {
		0.216487,
		-0.056462,
		0.974651,
		0,
		-0.951831,
		0.209837,
		0.223574,
		0,
		-0.217141,
		-0.976105,
		-0.008316,
		0,
		-0.892769,
		0.221857,
		-0.261867,
		1
	},
	[0.3] = {
		0.297683,
		-0.207258,
		0.931896,
		0,
		-0.927457,
		-0.294172,
		0.23084,
		0,
		0.226294,
		-0.93301,
		-0.279792,
		0,
		-0.745255,
		0.001608,
		-0.423968,
		1
	},
	[0.433333333333] = {
		0.08735,
		-0.127147,
		0.98803,
		0,
		-0.552337,
		0.819225,
		0.154255,
		0,
		-0.829032,
		-0.559199,
		0.001331,
		0,
		-0.66468,
		0.79218,
		-0.210247,
		1
	},
	[0.466666666667] = {
		-0.004759,
		-0.147411,
		0.989064,
		0,
		-0.10666,
		0.983508,
		0.146069,
		0,
		-0.994284,
		-0.104798,
		-0.020403,
		0,
		-0.413041,
		1.133938,
		-0.199592,
		1
	},
	[0.4] = {
		0.172169,
		-0.071862,
		0.982443,
		0,
		-0.837262,
		0.514778,
		0.184381,
		0,
		-0.518989,
		-0.854307,
		0.028462,
		0,
		-0.834192,
		0.447518,
		-0.223421,
		1
	},
	[0.533333333333] = {
		0.022975,
		-0.069611,
		0.99731,
		0,
		0.958377,
		0.285497,
		-0.002151,
		0,
		-0.284579,
		0.955848,
		0.073273,
		0,
		0.469636,
		1.418209,
		-0.189345,
		1
	},
	[0.566666666667] = {
		-0.057363,
		-0.108531,
		0.992437,
		0,
		0.92776,
		-0.372958,
		0.012839,
		0,
		0.368743,
		0.921479,
		0.122085,
		0,
		1.126576,
		1.082502,
		-0.209501,
		1
	},
	[0.5] = {
		-0.026477,
		-0.101666,
		0.994466,
		0,
		0.472277,
		0.87552,
		0.10208,
		0,
		-0.881053,
		0.472366,
		0.024834,
		0,
		-0.071269,
		1.37127,
		-0.185324,
		1
	},
	[0.633333333333] = {
		-0.040289,
		0.025051,
		0.998874,
		0,
		0.063244,
		-0.997617,
		0.02757,
		0,
		0.997185,
		0.064283,
		0.038608,
		0,
		1.542699,
		0.270022,
		-0.417479,
		1
	},
	[0.666666666667] = {
		0.147132,
		-0.080085,
		0.985869,
		0,
		0.003823,
		-0.996663,
		-0.081533,
		0,
		0.989109,
		0.015765,
		-0.146335,
		0,
		1.418761,
		0.134136,
		-0.598456,
		1
	},
	[0.6] = {
		-0.166878,
		0.042713,
		0.985052,
		0,
		0.307452,
		-0.946994,
		0.093148,
		0,
		0.936817,
		0.3184,
		0.1449,
		0,
		1.623455,
		0.433721,
		-0.270497,
		1
	},
	[0.733333333333] = {
		0.654003,
		-0.296176,
		0.696104,
		0,
		0.115636,
		-0.87022,
		-0.4789,
		0,
		0.747602,
		0.393697,
		-0.534878,
		0,
		1.097932,
		-0.049042,
		-0.988658,
		1
	},
	[0.766666666667] = {
		0.867732,
		-0.270586,
		0.416924,
		0,
		0.118235,
		-0.702372,
		-0.701922,
		0,
		0.482765,
		0.658375,
		-0.577478,
		0,
		0.928571,
		-0.088764,
		-1.147561,
		1
	},
	[0.7] = {
		0.388987,
		-0.213478,
		0.896167,
		0,
		0.050219,
		-0.96642,
		-0.252011,
		0,
		0.919873,
		0.143033,
		-0.365205,
		0,
		1.26653,
		0.025209,
		-0.796206,
		1
	},
	[0.833333333333] = {
		0.994075,
		-0.057564,
		-0.092199,
		0,
		-0.107681,
		-0.406012,
		-0.907501,
		0,
		0.014806,
		0.912053,
		-0.409805,
		0,
		0.708506,
		-0.103011,
		-1.279373,
		1
	},
	[0.866666666667] = {
		0.993871,
		-0.061733,
		-0.091702,
		0,
		-0.108938,
		-0.405993,
		-0.90736,
		0,
		0.018784,
		0.911789,
		-0.41023,
		0,
		0.708678,
		-0.106561,
		-1.276229,
		1
	},
	[0.8] = {
		0.976655,
		-0.163766,
		0.139015,
		0,
		0.033278,
		-0.523985,
		-0.851077,
		0,
		0.212219,
		0.835835,
		-0.506303,
		0,
		0.786421,
		-0.10439,
		-1.24884,
		1
	},
	[0.933333333333] = {
		0.993461,
		-0.069259,
		-0.090769,
		0,
		-0.111178,
		-0.405884,
		-0.907137,
		0,
		0.025986,
		0.911297,
		-0.41093,
		0,
		0.708989,
		-0.112887,
		-1.271418,
		1
	},
	[0.966666666667] = {
		0.993317,
		-0.071684,
		-0.09046,
		0,
		-0.111893,
		-0.405832,
		-0.907072,
		0,
		0.028311,
		0.911132,
		-0.411141,
		0,
		0.709087,
		-0.114908,
		-1.270043,
		1
	},
	[0.9] = {
		0.993657,
		-0.065787,
		-0.091204,
		0,
		-0.110148,
		-0.405944,
		-0.907236,
		0,
		0.022661,
		0.911527,
		-0.410615,
		0,
		0.708846,
		-0.109979,
		-1.273528,
		1
	}
}

return spline_matrices
