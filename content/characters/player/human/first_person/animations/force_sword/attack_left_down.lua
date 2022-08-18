local spline_matrices = {
	[0] = {
		0.851668,
		-0.522206,
		0.044305,
		0,
		-0.281935,
		-0.527787,
		-0.80122,
		0,
		0.441786,
		0.669882,
		-0.596727,
		0,
		0.435494,
		-0.21914,
		-0.33016,
		1
	},
	{
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.0166666666667] = {
		0.758433,
		-0.391938,
		0.520733,
		0,
		-0.02893,
		-0.818434,
		-0.573872,
		0,
		0.651108,
		0.420179,
		-0.632066,
		0,
		0.464375,
		-0.244005,
		-0.330269,
		1
	},
	[0.0333333333333] = {
		0.655379,
		-0.199909,
		0.728365,
		0,
		0.047316,
		-0.951577,
		-0.303747,
		0,
		0.753817,
		0.233533,
		-0.614184,
		0,
		0.4772,
		-0.241053,
		-0.30343,
		1
	},
	[0.05] = {
		0.608888,
		-0.019462,
		0.793018,
		0,
		0.044035,
		-0.997328,
		-0.058287,
		0,
		0.792033,
		0.070411,
		-0.606404,
		0,
		0.478536,
		-0.217187,
		-0.263703,
		1
	},
	[0.0666666666667] = {
		0.61774,
		0.138903,
		0.774017,
		0,
		0.008896,
		-0.985448,
		0.169746,
		0,
		0.786332,
		-0.097973,
		-0.609986,
		0,
		0.47154,
		-0.178888,
		-0.215035,
		1
	},
	[0.0833333333333] = {
		0.66953,
		0.269801,
		0.692053,
		0,
		-0.032839,
		-0.920037,
		0.390453,
		0,
		0.742059,
		-0.284146,
		-0.607132,
		0,
		0.457724,
		-0.130622,
		-0.158529,
		1
	},
	[0.116666666667] = {
		0.823592,
		0.404818,
		0.397264,
		0,
		-0.068493,
		-0.624305,
		0.778172,
		0,
		0.563032,
		-0.668106,
		-0.486446,
		0,
		0.415317,
		-0.015802,
		-0.027019,
		1
	},
	[0.133333333333] = {
		0.878141,
		0.4091,
		0.248004,
		0,
		-0.055497,
		-0.427789,
		0.902173,
		0,
		0.475173,
		-0.805998,
		-0.352955,
		0,
		0.390479,
		0.044116,
		0.04108,
		1
	},
	[0.15] = {
		0.897927,
		0.412047,
		0.154739,
		0,
		-0.051018,
		-0.251759,
		0.966444,
		0,
		0.437177,
		-0.875691,
		-0.205039,
		0,
		0.364513,
		0.097712,
		0.103984,
		1
	},
	[0.166666666667] = {
		0.907453,
		0.403036,
		0.118705,
		0,
		-0.071352,
		-0.130595,
		0.988865,
		0,
		0.41405,
		-0.905818,
		-0.089752,
		0,
		0.314,
		0.138685,
		0.186536,
		1
	},
	[0.183333333333] = {
		0.925897,
		0.361799,
		0.108706,
		0,
		-0.099736,
		-0.043438,
		0.994065,
		0,
		0.364374,
		-0.931244,
		-0.004134,
		0,
		0.234937,
		0.170911,
		0.292764,
		1
	},
	[0.1] = {
		0.746198,
		0.361891,
		0.558769,
		0,
		-0.062538,
		-0.797524,
		0.600037,
		0,
		0.66278,
		-0.482691,
		-0.572479,
		0,
		0.43838,
		-0.075356,
		-0.09506,
		1
	},
	[0.216666666667] = {
		0.952277,
		0.29208,
		0.088644,
		0,
		-0.143766,
		0.173013,
		0.97437,
		0,
		0.269257,
		-0.940615,
		0.206748,
		0,
		0.104212,
		0.240922,
		0.430253,
		1
	},
	[0.233333333333] = {
		0.955492,
		0.291699,
		0.044126,
		0,
		-0.144515,
		0.332391,
		0.932004,
		0,
		0.257198,
		-0.896899,
		0.359752,
		0,
		0.082599,
		0.295478,
		0.409339,
		1
	},
	[0.25] = {
		0.955719,
		0.293861,
		-0.015734,
		0,
		-0.137074,
		0.49184,
		0.859828,
		0,
		0.260409,
		-0.819597,
		0.510341,
		0,
		0.071023,
		0.35992,
		0.348045,
		1
	},
	[0.266666666667] = {
		0.953105,
		0.291467,
		-0.081478,
		0,
		-0.134668,
		0.64955,
		0.748297,
		0,
		0.271028,
		-0.702233,
		0.658341,
		0,
		0.065516,
		0.425153,
		0.265353,
		1
	},
	[0.283333333333] = {
		0.949351,
		0.279,
		-0.14454,
		0,
		-0.147445,
		0.801761,
		0.579172,
		0,
		0.277475,
		-0.528525,
		0.80229,
		0,
		0.061529,
		0.481001,
		0.180953,
		1
	},
	[0.2] = {
		0.942816,
		0.316133,
		0.105629,
		0,
		-0.126635,
		0.046599,
		0.990854,
		0,
		0.308319,
		-0.94757,
		0.083968,
		0,
		0.155598,
		0.20223,
		0.386348,
		1
	},
	[0.316666666667] = {
		0.952686,
		0.190845,
		-0.236575,
		0,
		-0.238001,
		0.952488,
		-0.190057,
		0,
		0.189064,
		0.23737,
		0.952843,
		0,
		0.039763,
		0.553144,
		0.064634,
		1
	},
	[0.333333333333] = {
		0.966607,
		0.108758,
		-0.232041,
		0,
		-0.249921,
		0.600295,
		-0.759727,
		0,
		0.056667,
		0.792349,
		0.60743,
		0,
		0.023963,
		0.577779,
		0.009198,
		1
	},
	[0.35] = {
		0.978149,
		0.070366,
		-0.195634,
		0,
		-0.203917,
		0.141299,
		-0.968738,
		0,
		-0.040524,
		0.987463,
		0.15256,
		0,
		0.013513,
		0.569144,
		-0.049456,
		1
	},
	[0.366666666667] = {
		0.982898,
		0.080491,
		-0.165628,
		0,
		-0.155542,
		-0.118603,
		-0.980683,
		0,
		-0.09858,
		0.989674,
		-0.104055,
		0,
		0.007892,
		0.550818,
		-0.112228,
		1
	},
	[0.383333333333] = {
		0.98255,
		0.115522,
		-0.145773,
		0,
		-0.108677,
		-0.279472,
		-0.953984,
		0,
		-0.150946,
		0.953179,
		-0.262041,
		0,
		0.00401,
		0.53309,
		-0.177071,
		1
	},
	[0.3] = {
		0.947737,
		0.250887,
		-0.197107,
		0,
		-0.181203,
		0.931738,
		0.314689,
		0,
		0.262603,
		-0.262526,
		0.928504,
		0,
		0.054092,
		0.517478,
		0.112541,
		1
	},
	[0.416666666667] = {
		0.965328,
		0.174712,
		-0.193951,
		0,
		-0.068412,
		-0.547701,
		-0.833873,
		0,
		-0.251915,
		0.81823,
		-0.516759,
		0,
		-0.018365,
		0.502868,
		-0.306065,
		1
	},
	[0.433333333333] = {
		0.942457,
		0.143235,
		-0.30209,
		0,
		-0.110689,
		-0.718935,
		-0.686207,
		0,
		-0.315472,
		0.680159,
		-0.661711,
		0,
		-0.056029,
		0.431653,
		-0.381335,
		1
	},
	[0.45] = {
		0.89997,
		0.061489,
		-0.431594,
		0,
		-0.171301,
		-0.860496,
		-0.479795,
		0,
		-0.400887,
		0.505733,
		-0.763888,
		0,
		-0.104374,
		0.313678,
		-0.456331,
		1
	},
	[0.466666666667] = {
		0.860914,
		-0.014338,
		-0.508549,
		0,
		-0.200797,
		-0.928027,
		-0.313762,
		0,
		-0.467448,
		0.372237,
		-0.80183,
		0,
		-0.128887,
		0.250563,
		-0.486201,
		1
	},
	[0.483333333333] = {
		0.839546,
		-0.049108,
		-0.541064,
		0,
		-0.207944,
		-0.949115,
		-0.236515,
		0,
		-0.501917,
		0.311076,
		-0.807038,
		0,
		-0.130159,
		0.248504,
		-0.480324,
		1
	},
	[0.4] = {
		0.976339,
		0.155239,
		-0.150541,
		0,
		-0.075717,
		-0.406673,
		-0.910431,
		0,
		-0.202555,
		0.900288,
		-0.385296,
		0,
		-0.003194,
		0.517123,
		-0.243097,
		1
	},
	[0.516666666667] = {
		0.810759,
		-0.066254,
		-0.581619,
		0,
		-0.225429,
		-0.952283,
		-0.205764,
		0,
		-0.540233,
		0.297939,
		-0.787007,
		0,
		-0.131867,
		0.248555,
		-0.475859,
		1
	},
	[0.533333333333] = {
		0.805209,
		-0.056198,
		-0.590323,
		0,
		-0.233467,
		-0.945141,
		-0.228476,
		0,
		-0.545098,
		0.321792,
		-0.774156,
		0,
		-0.132331,
		0.249242,
		-0.476488,
		1
	},
	[0.55] = {
		0.806775,
		-0.040233,
		-0.589488,
		0,
		-0.236503,
		-0.936259,
		-0.259778,
		0,
		-0.541462,
		0.348998,
		-0.764866,
		0,
		-0.132613,
		0.248918,
		-0.478775,
		1
	},
	[0.566666666667] = {
		0.815889,
		-0.023686,
		-0.577723,
		0,
		-0.230604,
		-0.929587,
		-0.287558,
		0,
		-0.530232,
		0.367841,
		-0.763902,
		0,
		-0.132679,
		0.246586,
		-0.482542,
		1
	},
	[0.583333333333] = {
		0.832454,
		-0.011212,
		-0.553981,
		0,
		-0.21287,
		-0.929543,
		-0.30106,
		0,
		-0.511574,
		0.368544,
		-0.776188,
		0,
		-0.132235,
		0.242113,
		-0.487201,
		1
	},
	[0.5] = {
		0.822531,
		-0.065308,
		-0.564958,
		0,
		-0.216248,
		-0.954685,
		-0.20448,
		0,
		-0.526003,
		0.290363,
		-0.799381,
		0,
		-0.131132,
		0.248118,
		-0.476983,
		1
	},
	[0.616666666667] = {
		0.892578,
		-0.005558,
		-0.450859,
		0,
		-0.124228,
		-0.964255,
		-0.234051,
		0,
		-0.433442,
		0.264918,
		-0.861363,
		0,
		-0.093314,
		0.196967,
		-0.483094,
		1
	},
	[0.633333333333] = {
		0.937224,
		0.005268,
		-0.348687,
		0,
		-0.046799,
		-0.988941,
		-0.140732,
		0,
		-0.345572,
		0.148216,
		-0.926613,
		0,
		-0.001117,
		0.112439,
		-0.451582,
		1
	},
	[0.65] = {
		0.973358,
		0.034891,
		-0.226622,
		0,
		0.029183,
		-0.999168,
		-0.028493,
		0,
		-0.227428,
		0.02112,
		-0.973566,
		0,
		0.119356,
		0.001989,
		-0.406546,
		1
	},
	[0.666666666667] = {
		0.991243,
		0.079894,
		-0.10514,
		0,
		0.087844,
		-0.993435,
		0.073283,
		0,
		-0.098595,
		-0.081877,
		-0.991754,
		0,
		0.240607,
		-0.115473,
		-0.3595,
		1
	},
	[0.683333333333] = {
		0.991866,
		0.127276,
		-0.001575,
		0,
		0.126314,
		-0.982697,
		0.135463,
		0,
		0.015694,
		-0.134561,
		-0.990781,
		0,
		0.334893,
		-0.222804,
		-0.323657,
		1
	},
	[0.6] = {
		0.855994,
		-0.006267,
		-0.516948,
		0,
		-0.181054,
		-0.940236,
		-0.288401,
		0,
		-0.484246,
		0.340466,
		-0.805971,
		0,
		-0.130934,
		0.235294,
		-0.492086,
		1
	},
	[0.716666666667] = {
		0.976462,
		0.175044,
		0.126021,
		0,
		0.171217,
		-0.984394,
		0.040667,
		0,
		0.131173,
		-0.018132,
		-0.991194,
		0,
		0.369272,
		-0.3613,
		-0.320837,
		1
	},
	[0.733333333333] = {
		0.971137,
		0.169585,
		0.167731,
		0,
		0.191908,
		-0.973131,
		-0.127231,
		0,
		0.141648,
		0.155747,
		-0.977588,
		0,
		0.346861,
		-0.414054,
		-0.335154,
		1
	},
	[0.75] = {
		0.969277,
		0.147505,
		0.196835,
		0,
		0.209015,
		-0.915797,
		-0.342969,
		0,
		0.129671,
		0.373573,
		-0.918492,
		0,
		0.313933,
		-0.457584,
		-0.350651,
		1
	},
	[0.766666666667] = {
		0.970689,
		0.115617,
		0.210703,
		0,
		0.217027,
		-0.798321,
		-0.561767,
		0,
		0.103259,
		0.591029,
		-0.800014,
		0,
		0.2766,
		-0.490349,
		-0.362934,
		1
	},
	[0.783333333333] = {
		0.973934,
		0.08326,
		0.210999,
		0,
		0.214645,
		-0.639081,
		-0.738581,
		0,
		0.073352,
		0.764619,
		-0.640294,
		0,
		0.241415,
		-0.512628,
		-0.369538,
		1
	},
	[0.7] = {
		0.984115,
		0.161584,
		0.073538,
		0,
		0.151011,
		-0.979706,
		0.131802,
		0,
		0.093342,
		-0.118603,
		-0.988545,
		0,
		0.375199,
		-0.302738,
		-0.312051,
		1
	},
	[0.816666666667] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.833333333333] = {
		0.978573,
		0.032087,
		0.203386,
		0,
		0.203137,
		-0.311778,
		-0.928186,
		0,
		0.033628,
		0.949613,
		-0.311616,
		0,
		0.204631,
		-0.520347,
		-0.366945,
		1
	},
	[0.85] = {
		0.978601,
		0.029703,
		0.20361,
		0,
		0.203168,
		-0.29622,
		-0.933261,
		0,
		0.032592,
		0.954658,
		-0.295916,
		0,
		0.204573,
		-0.519126,
		-0.366352,
		1
	},
	[0.866666666667] = {
		0.978581,
		0.031405,
		0.203454,
		0,
		0.203147,
		-0.307331,
		-0.929666,
		0,
		0.033332,
		0.951084,
		-0.307128,
		0,
		0.204614,
		-0.519996,
		-0.366778,
		1
	},
	[0.883333333333] = {
		0.978539,
		0.035168,
		0.203037,
		0,
		0.203071,
		-0.331795,
		-0.921235,
		0,
		0.034969,
		0.942696,
		-0.331816,
		0,
		0.204703,
		-0.521942,
		-0.367683,
		1
	},
	[0.8] = {
		0.977077,
		0.057498,
		0.204973,
		0,
		0.207029,
		-0.480912,
		-0.851976,
		0,
		0.049587,
		0.874882,
		-0.481792,
		0,
		0.215226,
		-0.52461,
		-0.370862,
		1
	},
	[0.916666666667] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.933333333333] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.95] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.966666666667] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.983333333333] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[0.9] = {
		0.978504,
		0.038954,
		0.202517,
		0,
		0.202952,
		-0.356261,
		-0.912079,
		0,
		0.03662,
		0.933574,
		-0.356508,
		0,
		0.20479,
		-0.523929,
		-0.368546,
		1
	},
	[1.01666666667] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[1.03333333333] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[1.05] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[1.06666666667] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	},
	[1.08333333333] = {
		0.97849,
		0.040682,
		0.202245,
		0,
		0.202882,
		-0.367375,
		-0.907675,
		0,
		0.037374,
		0.929183,
		-0.367726,
		0,
		0.204829,
		-0.524846,
		-0.368923,
		1
	}
}

return spline_matrices
