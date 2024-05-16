﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_sword/swing_up_left.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.202525,
		0.615996,
		-0.761271,
		0,
		0.874242,
		0.463993,
		0.142869,
		0,
		0.441231,
		-0.6366,
		-0.632499,
		0,
		0.430696,
		0.099433,
		-0.522293,
		1,
	},
	[0.0333333333333] = {
		-0.163415,
		0.653402,
		-0.739163,
		0,
		0.841754,
		0.483105,
		0.240957,
		0,
		0.514535,
		-0.582817,
		-0.62895,
		0,
		0.439492,
		0.150129,
		-0.52109,
		1,
	},
	[0.05] = {
		-0.180457,
		0.677479,
		-0.713062,
		0,
		0.78788,
		0.533545,
		0.307529,
		0,
		0.588795,
		-0.506312,
		-0.630054,
		0,
		0.429801,
		0.21635,
		-0.515807,
		1,
	},
	[0.0666666666667] = {
		-0.263639,
		0.673346,
		-0.690724,
		0,
		0.713299,
		0.618133,
		0.330326,
		0,
		0.649383,
		-0.405606,
		-0.643262,
		0,
		0.382223,
		0.300797,
		-0.50011,
		1,
	},
	[0.0833333333333] = {
		-0.417281,
		0.613998,
		-0.669987,
		0,
		0.605598,
		0.737564,
		0.298749,
		0,
		0.67759,
		-0.28108,
		-0.679608,
		0,
		0.293146,
		0.406296,
		-0.468456,
		1,
	},
	[0] = {
		-0.27188,
		0.574312,
		-0.77217,
		0,
		0.888828,
		0.45743,
		0.027265,
		0,
		0.368872,
		-0.678914,
		-0.63483,
		0,
		0.406723,
		0.059549,
		-0.525556,
		1,
	},
	[0.116666666667] = {
		-0.911674,
		0.053108,
		-0.407469,
		0,
		-0.267234,
		0.676646,
		0.686103,
		0,
		0.312149,
		0.734391,
		-0.602688,
		0,
		0.113241,
		0.660876,
		-0.293236,
		1,
	},
	[0.133333333333] = {
		-0.913877,
		0.108599,
		-0.391196,
		0,
		-0.269152,
		0.559321,
		0.784039,
		0,
		0.30395,
		0.821807,
		-0.481921,
		0,
		0.062672,
		0.716455,
		-0.193694,
		1,
	},
	[0.15] = {
		-0.910391,
		0.061623,
		-0.409135,
		0,
		-0.379774,
		0.267965,
		0.885419,
		0,
		0.164196,
		0.961456,
		-0.220549,
		0,
		-0.016388,
		0.730047,
		-0.057656,
		1,
	},
	[0.166666666667] = {
		-0.90518,
		-0.078957,
		-0.417629,
		0,
		-0.416413,
		-0.03208,
		0.908609,
		0,
		-0.085138,
		0.996362,
		-0.00384,
		0,
		-0.102158,
		0.686344,
		0.095626,
		1,
	},
	[0.183333333333] = {
		-0.953352,
		0.065331,
		-0.294705,
		0,
		-0.294701,
		-0.412797,
		0.861829,
		0,
		-0.065349,
		0.908477,
		0.412794,
		0,
		-0.174758,
		0.571185,
		0.219832,
		1,
	},
	[0.1] = {
		-0.766925,
		0.374879,
		-0.520856,
		0,
		0.095893,
		0.869468,
		0.484592,
		0,
		0.634532,
		0.321699,
		-0.702766,
		0,
		0.19087,
		0.554238,
		-0.394359,
		1,
	},
	[0.216666666667] = {
		-0.867106,
		-0.003029,
		-0.498115,
		0,
		-0.216246,
		-0.898549,
		0.381899,
		0,
		-0.448737,
		0.438862,
		0.778483,
		0,
		-0.306141,
		0.278804,
		0.37715,
		1,
	},
	[0.233333333333] = {
		-0.52542,
		0.164895,
		-0.834712,
		0,
		-0.209309,
		-0.975942,
		-0.061042,
		0,
		-0.824696,
		0.14264,
		0.547293,
		0,
		-0.336792,
		0.088832,
		0.410284,
		1,
	},
	[0.25] = {
		-0.721502,
		0.319711,
		-0.614183,
		0,
		-0.190707,
		-0.944466,
		-0.267609,
		0,
		-0.665632,
		-0.075952,
		0.742405,
		0,
		-0.309517,
		-0.124492,
		0.422971,
		1,
	},
	[0.266666666667] = {
		-0.655134,
		0.275047,
		-0.703668,
		0,
		-0.052191,
		-0.945629,
		-0.321033,
		0,
		-0.753708,
		-0.173595,
		0.633868,
		0,
		-0.27651,
		-0.331437,
		0.41305,
		1,
	},
	[0.283333333333] = {
		-0.591904,
		0.223946,
		-0.774273,
		0,
		0.086161,
		-0.937541,
		-0.337036,
		0,
		-0.80139,
		-0.266205,
		0.535638,
		0,
		-0.232392,
		-0.488219,
		0.347151,
		1,
	},
	[0.2] = {
		-0.930437,
		-0.023768,
		-0.365681,
		0,
		-0.180322,
		-0.839023,
		0.513346,
		0,
		-0.319016,
		0.543577,
		0.776372,
		0,
		-0.252671,
		0.414444,
		0.303137,
		1,
	},
	[0.316666666667] = {
		-0.690027,
		0.276683,
		-0.668812,
		0,
		0.054334,
		-0.90164,
		-0.42906,
		0,
		-0.721741,
		-0.332402,
		0.607123,
		0,
		-0.144141,
		-0.614983,
		0.136377,
		1,
	},
	[0.333333333333] = {
		-0.674522,
		0.33366,
		-0.658552,
		0,
		0.030936,
		-0.878481,
		-0.476774,
		0,
		-0.737606,
		-0.341968,
		0.582233,
		0,
		-0.11341,
		-0.630762,
		0.014272,
		1,
	},
	[0.35] = {
		-0.647921,
		0.387775,
		-0.655613,
		0,
		0.009992,
		-0.856315,
		-0.516358,
		0,
		-0.761642,
		-0.34111,
		0.55095,
		0,
		-0.088343,
		-0.6454,
		-0.098432,
		1,
	},
	[0.366666666667] = {
		-0.640993,
		0.428725,
		-0.63665,
		0,
		-0.016063,
		-0.836771,
		-0.547317,
		0,
		-0.767379,
		-0.3406,
		0.543251,
		0,
		-0.067348,
		-0.663094,
		-0.191972,
		1,
	},
	[0.383333333333] = {
		-0.617166,
		0.461098,
		-0.63757,
		0,
		-0.031368,
		-0.824073,
		-0.565615,
		0,
		-0.786207,
		-0.329079,
		0.523053,
		0,
		-0.057794,
		-0.658943,
		-0.261868,
		1,
	},
	[0.3] = {
		-0.87534,
		0.256451,
		-0.409894,
		0,
		-0.083152,
		-0.914964,
		-0.394876,
		0,
		-0.476304,
		-0.311567,
		0.822229,
		0,
		-0.176853,
		-0.575205,
		0.257399,
		1,
	},
	[0.416666666667] = {
		-0.537337,
		0.507024,
		-0.673941,
		0,
		-0.042369,
		-0.814326,
		-0.578859,
		0,
		-0.842303,
		-0.282488,
		0.45905,
		0,
		-0.066752,
		-0.599529,
		-0.329657,
		1,
	},
	[0.433333333333] = {
		-0.490717,
		0.523755,
		-0.696331,
		0,
		-0.044908,
		-0.81331,
		-0.580095,
		0,
		-0.870161,
		-0.253391,
		0.422626,
		0,
		-0.068247,
		-0.576355,
		-0.354068,
		1,
	},
	[0.45] = {
		-0.446973,
		0.539175,
		-0.713797,
		0,
		-0.049759,
		-0.811692,
		-0.581963,
		0,
		-0.893162,
		-0.224604,
		0.389633,
		0,
		-0.067336,
		-0.557342,
		-0.377541,
		1,
	},
	[0.466666666667] = {
		-0.406739,
		0.553015,
		-0.727144,
		0,
		-0.0605,
		-0.810517,
		-0.582582,
		0,
		-0.911539,
		-0.192967,
		0.363127,
		0,
		-0.065463,
		-0.539234,
		-0.399638,
		1,
	},
	[0.483333333333] = {
		-0.362522,
		0.56366,
		-0.742203,
		0,
		-0.070326,
		-0.81065,
		-0.581292,
		0,
		-0.929318,
		-0.158535,
		0.333518,
		0,
		-0.062674,
		-0.521027,
		-0.421539,
		1,
	},
	[0.4] = {
		-0.581162,
		0.486709,
		-0.6522,
		0,
		-0.039011,
		-0.817178,
		-0.575064,
		0,
		-0.812852,
		-0.308762,
		0.4939,
		0,
		-0.063342,
		-0.626539,
		-0.300403,
		1,
	},
	[0.516666666667] = {
		-0.262492,
		0.574352,
		-0.775382,
		0,
		-0.088128,
		-0.814471,
		-0.573472,
		0,
		-0.960901,
		-0.082199,
		0.264409,
		0,
		-0.055023,
		-0.484377,
		-0.469229,
		1,
	},
	[0.533333333333] = {
		-0.206991,
		0.573868,
		-0.792357,
		0,
		-0.096551,
		-0.817926,
		-0.567164,
		0,
		-0.973567,
		-0.040895,
		0.224711,
		0,
		-0.050678,
		-0.466251,
		-0.495352,
		1,
	},
	[0.55] = {
		-0.148155,
		0.569164,
		-0.808766,
		0,
		-0.104945,
		-0.822221,
		-0.559409,
		0,
		-0.98338,
		0.001997,
		0.181547,
		0,
		-0.045828,
		-0.449032,
		-0.52156,
		1,
	},
	[0.566666666667] = {
		-0.086225,
		0.559923,
		-0.824046,
		0,
		-0.11391,
		-0.827243,
		-0.550176,
		0,
		-0.989742,
		0.046428,
		0.13511,
		0,
		-0.040721,
		-0.43304,
		-0.547444,
		1,
	},
	[0.583333333333] = {
		-0.021749,
		0.546086,
		-0.837446,
		0,
		-0.123255,
		-0.832719,
		-0.539803,
		0,
		-0.992137,
		0.091479,
		0.085419,
		0,
		-0.035579,
		-0.418699,
		-0.572599,
		1,
	},
	[0.5] = {
		-0.314398,
		0.570861,
		-0.758466,
		0,
		-0.07946,
		-0.812004,
		-0.578218,
		0,
		-0.94596,
		-0.121523,
		0.300653,
		0,
		-0.059053,
		-0.50271,
		-0.444409,
		1,
	},
	[0.616666666667] = {
		0.112638,
		0.504407,
		-0.856088,
		0,
		-0.143694,
		-0.844245,
		-0.516335,
		0,
		-0.983191,
		0.181173,
		-0.022613,
		0,
		-0.024779,
		-0.391512,
		-0.621809,
		1,
	},
	[0.633333333333] = {
		0.181253,
		0.476686,
		-0.860185,
		0,
		-0.155012,
		-0.84989,
		-0.503644,
		0,
		-0.971143,
		0.224626,
		-0.080153,
		0,
		-0.019171,
		-0.37744,
		-0.646042,
		1,
	},
	[0.65] = {
		0.249858,
		0.444632,
		-0.860159,
		0,
		-0.167148,
		-0.855193,
		-0.490618,
		0,
		-0.953747,
		0.266359,
		-0.139358,
		0,
		-0.013701,
		-0.362891,
		-0.669696,
		1,
	},
	[0.666666666667] = {
		0.317574,
		0.408566,
		-0.855699,
		0,
		-0.180186,
		-0.85997,
		-0.477478,
		0,
		-0.930956,
		0.30582,
		-0.199486,
		0,
		-0.008675,
		-0.347715,
		-0.692476,
		1,
	},
	[0.683333333333] = {
		0.383505,
		0.368904,
		-0.846661,
		0,
		-0.194175,
		-0.864057,
		-0.464437,
		0,
		-0.902895,
		0.342515,
		-0.259738,
		0,
		-0.004403,
		-0.331758,
		-0.714063,
		1,
	},
	[0.6] = {
		0.044743,
		0.527577,
		-0.848328,
		0,
		-0.13314,
		-0.838454,
		-0.528459,
		0,
		-0.990087,
		0.136591,
		0.032727,
		0,
		-0.030312,
		-0.405232,
		-0.597254,
		1,
	},
	[0.716666666667] = {
		0.507101,
		0.280849,
		-0.814845,
		0,
		-0.224712,
		-0.869641,
		-0.439579,
		0,
		-0.832078,
		0.406016,
		-0.377886,
		0,
		0.001323,
		-0.297019,
		-0.752404,
		1,
	},
	[0.733333333333] = {
		0.563515,
		0.233618,
		-0.792385,
		0,
		-0.241021,
		-0.870956,
		-0.428188,
		0,
		-0.790164,
		0.432272,
		-0.43449,
		0,
		0.002598,
		-0.277812,
		-0.767928,
		1,
	},
	[0.75] = {
		0.615683,
		0.185069,
		-0.765953,
		0,
		-0.257819,
		-0.871218,
		-0.417741,
		0,
		-0.744623,
		0.454673,
		-0.48868,
		0,
		0.00231,
		-0.255173,
		-0.775431,
		1,
	},
	[0.766666666667] = {
		0.663265,
		0.135808,
		-0.735959,
		0,
		-0.274929,
		-0.870419,
		-0.408393,
		0,
		-0.696056,
		0.47321,
		-0.539981,
		0,
		0.001798,
		-0.232053,
		-0.780244,
		1,
	},
	[0.783333333333] = {
		0.706048,
		0.086412,
		-0.702872,
		0,
		-0.292167,
		-0.868574,
		-0.400272,
		0,
		-0.645085,
		0.487967,
		-0.588009,
		0,
		0.001292,
		-0.209123,
		-0.783547,
		1,
	},
	[0.7] = {
		0.446905,
		0.326144,
		-0.83301,
		0,
		-0.209051,
		-0.867316,
		-0.45173,
		0,
		-0.869812,
		0.376023,
		-0.319427,
		0,
		-0.001047,
		-0.314886,
		-0.734133,
		1,
	},
	[0.816666666667] = {
		0.776966,
		-0.010723,
		-0.629452,
		0,
		-0.326287,
		-0.861939,
		-0.38807,
		0,
		-0.538387,
		0.506899,
		-0.673195,
		0,
		0.000393,
		-0.164418,
		-0.78619,
		1,
	},
	[0.833333333333] = {
		0.804151,
		-0.057449,
		-0.591643,
		0,
		-0.34505,
		-0.855579,
		-0.385908,
		0,
		-0.484027,
		0.514475,
		-0.707837,
		0,
		-9.6e-05,
		-0.142588,
		-0.785526,
		1,
	},
	[0.85] = {
		0.826227,
		-0.100848,
		-0.554237,
		0,
		-0.362831,
		-0.847871,
		-0.386611,
		0,
		-0.430933,
		0.520523,
		-0.737125,
		0,
		-0.000564,
		-0.121293,
		-0.783543,
		1,
	},
	[0.866666666667] = {
		0.843914,
		-0.141343,
		-0.517525,
		0,
		-0.379546,
		-0.839068,
		-0.389755,
		0,
		-0.379149,
		0.525344,
		-0.761747,
		0,
		-0.000984,
		-0.100595,
		-0.779317,
		1,
	},
	[0.883333333333] = {
		0.857824,
		-0.1794,
		-0.481616,
		0,
		-0.39518,
		-0.829375,
		-0.394931,
		0,
		-0.328589,
		0.529106,
		-0.782353,
		0,
		-0.001319,
		-0.080572,
		-0.772241,
		1,
	},
	[0.8] = {
		0.743942,
		0.037412,
		-0.667196,
		0,
		-0.309346,
		-0.865727,
		-0.393474,
		0,
		-0.592331,
		0.499116,
		-0.632477,
		0,
		0.000822,
		-0.186548,
		-0.785519,
		1,
	},
	[0.916666666667] = {
		0.876194,
		-0.250146,
		-0.411961,
		0,
		-0.423364,
		-0.807949,
		-0.409856,
		0,
		-0.230319,
		0.533522,
		-0.813822,
		0,
		-0.001381,
		-0.042858,
		-0.750316,
		1,
	},
	[0.933333333333] = {
		0.881306,
		-0.283792,
		-0.377838,
		0,
		-0.43607,
		-0.796465,
		-0.418911,
		0,
		-0.182051,
		0.533953,
		-0.825683,
		0,
		-0.001293,
		-0.027678,
		-0.737912,
		1,
	},
	[0.95] = {
		0.883953,
		-0.316889,
		-0.343816,
		0,
		-0.447983,
		-0.784603,
		-0.428613,
		0,
		-0.133936,
		0.532898,
		-0.835512,
		0,
		-0.00099,
		-0.016938,
		-0.724655,
		1,
	},
	[0.966666666667] = {
		0.884187,
		-0.349842,
		-0.309555,
		0,
		-0.459215,
		-0.772449,
		-0.438685,
		0,
		-0.085645,
		0.530031,
		-0.843642,
		0,
		-0.000423,
		-0.009234,
		-0.711021,
		1,
	},
	[0.983333333333] = {
		0.881961,
		-0.383006,
		-0.274685,
		0,
		-0.469879,
		-0.760084,
		-0.448872,
		0,
		-0.036863,
		0.524956,
		-0.850331,
		0,
		0.000456,
		-0.003162,
		-0.697482,
		1,
	},
	[0.9] = {
		0.868456,
		-0.215505,
		-0.446476,
		0,
		-0.409764,
		-0.818956,
		-0.401751,
		0,
		-0.279065,
		0.531853,
		-0.799534,
		0,
		-0.001331,
		-0.0612,
		-0.761573,
		1,
	},
	[1.01666666667] = {
		0.869483,
		-0.450961,
		-0.201577,
		0,
		-0.489898,
		-0.735009,
		-0.468788,
		0,
		0.063245,
		0.506356,
		-0.860002,
		0,
		0.003349,
		0.009741,
		-0.672569,
		1,
	},
	{
		0.877128,
		-0.416669,
		-0.238818,
		0,
		-0.48009,
		-0.747584,
		-0.458947,
		0,
		0.012693,
		0.51721,
		-0.855765,
		0,
		0.001692,
		0.002677,
		-0.684509,
		1,
	},
}

return spline_matrices
