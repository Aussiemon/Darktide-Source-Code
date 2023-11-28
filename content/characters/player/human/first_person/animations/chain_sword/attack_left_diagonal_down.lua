﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_sword/attack_left_diagonal_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.82455,
		9.5e-05,
		-0.56579,
		0,
		-0.541915,
		0.287561,
		-0.789707,
		0,
		0.162624,
		0.957762,
		0.23716,
		0,
		0.172298,
		-0.536135,
		-0.364627,
		1
	},
	[0.0333333333333] = {
		0.78413,
		-0.472893,
		-0.401886,
		0,
		-0.17273,
		0.455688,
		-0.87322,
		0,
		0.596074,
		0.754136,
		0.275635,
		0,
		0.35846,
		-0.433318,
		-0.377363,
		1
	},
	[0.05] = {
		0.566087,
		-0.676427,
		-0.47116,
		0,
		0.138495,
		0.641473,
		-0.754541,
		0,
		0.812628,
		0.361883,
		0.456811,
		0,
		0.50675,
		-0.276919,
		-0.350329,
		1
	},
	[0.0666666666667] = {
		0.279639,
		-0.485014,
		-0.828591,
		0,
		0.367716,
		0.85132,
		-0.374219,
		0,
		0.886897,
		-0.200041,
		0.41641,
		0,
		0.634252,
		-0.103384,
		-0.310585,
		1
	},
	[0.0833333333333] = {
		0.050747,
		-0.015208,
		-0.998596,
		0,
		0.452098,
		0.891919,
		0.009391,
		0,
		0.890524,
		-0.451939,
		0.052138,
		0,
		0.68774,
		0.037838,
		-0.254968,
		1
	},
	[0] = {
		0.633074,
		0.210212,
		-0.745002,
		0,
		-0.712232,
		-0.218813,
		-0.666968,
		0,
		-0.303221,
		0.952855,
		0.011194,
		0,
		-0.013586,
		-0.573175,
		-0.374783,
		1
	},
	[0.116666666667] = {
		0.104752,
		0.152294,
		-0.982768,
		0,
		0.477748,
		0.859003,
		0.184037,
		0,
		0.872229,
		-0.488794,
		0.017224,
		0,
		0.672701,
		0.158887,
		-0.10167,
		1
	},
	[0.133333333333] = {
		0.203371,
		0.09737,
		-0.974248,
		0,
		0.467544,
		0.864606,
		0.18401,
		0,
		0.860257,
		-0.492926,
		0.130311,
		0,
		0.661722,
		0.199886,
		-0.043901,
		1
	},
	[0.15] = {
		0.247705,
		0.095173,
		-0.96415,
		0,
		0.449667,
		0.870188,
		0.201424,
		0,
		0.858162,
		-0.48344,
		0.172754,
		0,
		0.653083,
		0.235986,
		-0.00212,
		1
	},
	[0.166666666667] = {
		0.288963,
		0.08948,
		-0.953149,
		0,
		0.422296,
		0.881609,
		0.21079,
		0,
		0.859166,
		-0.463421,
		0.216965,
		0,
		0.6461,
		0.271403,
		0.033884,
		1
	},
	[0.183333333333] = {
		0.328349,
		0.081477,
		-0.941036,
		0,
		0.387787,
		0.896812,
		0.212955,
		0,
		0.861283,
		-0.434845,
		0.262872,
		0,
		0.639372,
		0.306146,
		0.064367,
		1
	},
	[0.1] = {
		0.000217,
		0.19562,
		-0.98068,
		0,
		0.466458,
		0.867434,
		0.173134,
		0,
		0.884543,
		-0.457483,
		-0.091061,
		0,
		0.682721,
		0.11587,
		-0.180009,
		1
	},
	[0.216666666667] = {
		0.405859,
		0.063039,
		-0.911759,
		0,
		0.305932,
		0.930695,
		0.200531,
		0,
		0.861211,
		-0.360324,
		0.358445,
		0,
		0.621149,
		0.373629,
		0.109767,
		1
	},
	[0.233333333333] = {
		0.445716,
		0.057729,
		-0.893311,
		0,
		0.259818,
		0.946618,
		0.19081,
		0,
		0.85664,
		-0.317145,
		0.406924,
		0,
		0.607433,
		0.406482,
		0.126708,
		1
	},
	[0.25] = {
		0.486769,
		0.059665,
		-0.871491,
		0,
		0.2095,
		0.960573,
		0.18278,
		0,
		0.848036,
		-0.271549,
		0.455077,
		0,
		0.589367,
		0.438859,
		0.141777,
		1
	},
	[0.266666666667] = {
		0.554713,
		0.068966,
		-0.829178,
		0,
		0.154003,
		0.97083,
		0.183774,
		0,
		0.817665,
		-0.229638,
		0.527911,
		0,
		0.537244,
		0.469194,
		0.154342,
		1
	},
	[0.283333333333] = {
		0.595788,
		0.0819,
		-0.798955,
		0,
		0.037165,
		0.99091,
		0.129292,
		0,
		0.802281,
		-0.106724,
		0.587329,
		0,
		0.463499,
		0.499175,
		0.16383,
		1
	},
	[0.2] = {
		0.366974,
		0.072342,
		-0.927414,
		0,
		0.348306,
		0.913761,
		0.2091,
		0,
		0.862562,
		-0.399758,
		0.31013,
		0,
		0.631514,
		0.340216,
		0.089597,
		1
	},
	[0.316666666667] = {
		0.500858,
		0.121698,
		-0.856931,
		0,
		-0.517102,
		0.83602,
		-0.183507,
		0,
		0.694079,
		0.535032,
		0.481658,
		0,
		0.332846,
		0.564461,
		0.10321,
		1
	},
	[0.333333333333] = {
		0.505502,
		0.119336,
		-0.854533,
		0,
		-0.715912,
		0.610811,
		-0.338201,
		0,
		0.481599,
		0.782731,
		0.394201,
		0,
		0.218672,
		0.637212,
		0.044668,
		1
	},
	[0.35] = {
		0.518895,
		0.104562,
		-0.848419,
		0,
		-0.82701,
		0.312578,
		-0.467278,
		0,
		0.216338,
		0.94412,
		0.248669,
		0,
		0.082858,
		0.685942,
		-0.029168,
		1
	},
	[0.366666666667] = {
		0.51229,
		0.088556,
		-0.854235,
		0,
		-0.853427,
		-0.058729,
		-0.517894,
		0,
		-0.096031,
		0.994338,
		0.04549,
		0,
		-0.086595,
		0.632033,
		-0.121599,
		1
	},
	[0.383333333333] = {
		0.500569,
		0.08325,
		-0.861684,
		0,
		-0.77547,
		-0.399325,
		-0.489066,
		0,
		-0.384807,
		0.913022,
		-0.135331,
		0,
		-0.241323,
		0.534112,
		-0.212308,
		1
	},
	[0.3] = {
		0.552413,
		0.103842,
		-0.827077,
		0,
		-0.220176,
		0.975149,
		-0.024624,
		0,
		0.803967,
		0.195705,
		0.561549,
		0,
		0.406243,
		0.528121,
		0.147434,
		1
	},
	[0.416666666667] = {
		0.433614,
		0.090501,
		-0.896543,
		0,
		-0.560329,
		-0.752113,
		-0.346925,
		0,
		-0.705698,
		0.652791,
		-0.275416,
		0,
		-0.340535,
		0.33092,
		-0.328966,
		1
	},
	[0.433333333333] = {
		0.435266,
		0.12436,
		-0.891671,
		0,
		-0.47798,
		-0.807383,
		-0.345929,
		0,
		-0.76294,
		0.576773,
		-0.291985,
		0,
		-0.331966,
		0.283488,
		-0.373001,
		1
	},
	[0.45] = {
		0.438502,
		0.166697,
		-0.883135,
		0,
		-0.38697,
		-0.851874,
		-0.352938,
		0,
		-0.811154,
		0.49651,
		-0.309042,
		0,
		-0.314309,
		0.235849,
		-0.421351,
		1
	},
	[0.466666666667] = {
		0.441342,
		0.215716,
		-0.871025,
		0,
		-0.289021,
		-0.884776,
		-0.365567,
		0,
		-0.84952,
		0.413084,
		-0.328142,
		0,
		-0.29114,
		0.188374,
		-0.470722,
		1
	},
	[0.483333333333] = {
		0.442732,
		0.266818,
		-0.856035,
		0,
		-0.191025,
		-0.904716,
		-0.380787,
		0,
		-0.87607,
		0.33211,
		-0.349578,
		0,
		-0.264117,
		0.14337,
		-0.518067,
		1
	},
	[0.4] = {
		0.462836,
		0.079797,
		-0.882845,
		0,
		-0.662337,
		-0.630788,
		-0.404248,
		0,
		-0.589146,
		0.771841,
		-0.239099,
		0,
		-0.319106,
		0.421604,
		-0.279159,
		1
	},
	[0.516666666667] = {
		0.442644,
		0.352663,
		-0.824436,
		0,
		-0.033606,
		-0.912244,
		-0.408267,
		0,
		-0.896067,
		0.208423,
		-0.391948,
		0,
		-0.205046,
		0.072481,
		-0.594365,
		1
	},
	[0.533333333333] = {
		0.441956,
		0.379159,
		-0.812966,
		0,
		0.01251,
		-0.908796,
		-0.417053,
		0,
		-0.896949,
		0.174149,
		-0.406392,
		0,
		-0.177625,
		0.050673,
		-0.617122,
		1
	},
	[0.55] = {
		0.441662,
		0.389564,
		-0.808192,
		0,
		0.029019,
		-0.906544,
		-0.421113,
		0,
		-0.896712,
		0.162537,
		-0.41169,
		0,
		-0.154739,
		0.040633,
		-0.62546,
		1
	},
	[0.566666666667] = {
		0.460589,
		0.356357,
		-0.812938,
		0,
		0.013425,
		-0.918561,
		-0.395051,
		0,
		-0.887512,
		0.171042,
		-0.427863,
		0,
		-0.133786,
		0.037439,
		-0.622383,
		1
	},
	[0.583333333333] = {
		0.486015,
		0.286378,
		-0.825698,
		0,
		-0.060457,
		-0.931508,
		-0.358662,
		0,
		-0.871857,
		0.224234,
		-0.435413,
		0,
		-0.10851,
		0.017726,
		-0.606181,
		1
	},
	[0.5] = {
		0.443087,
		0.313886,
		-0.839732,
		0,
		-0.103557,
		-0.912509,
		-0.395731,
		0,
		-0.890477,
		0.262303,
		-0.371816,
		0,
		-0.234652,
		0.104056,
		-0.560311,
		1
	},
	[0.616666666667] = {
		0.49564,
		0.142964,
		-0.856681,
		0,
		-0.387527,
		-0.846329,
		-0.365444,
		0,
		-0.77728,
		0.513116,
		-0.364072,
		0,
		-0.045386,
		-0.094927,
		-0.530106,
		1
	},
	[0.633333333333] = {
		0.493311,
		0.086886,
		-0.865503,
		0,
		-0.568886,
		-0.720483,
		-0.396576,
		0,
		-0.658037,
		0.688008,
		-0.305994,
		0,
		-0.01266,
		-0.169359,
		-0.481832,
		1
	},
	[0.65] = {
		0.492915,
		0.047519,
		-0.868779,
		0,
		-0.71128,
		-0.553076,
		-0.433807,
		0,
		-0.501115,
		0.831775,
		-0.23882,
		0,
		0.017427,
		-0.243462,
		-0.434374,
		1
	},
	[0.666666666667] = {
		0.495699,
		0.023541,
		-0.868175,
		0,
		-0.797963,
		-0.382259,
		-0.465976,
		0,
		-0.342838,
		0.923755,
		-0.170701,
		0,
		0.0423,
		-0.307915,
		-0.393418,
		1
	},
	[0.683333333333] = {
		0.499679,
		0.011362,
		-0.866136,
		0,
		-0.836657,
		-0.252632,
		-0.485986,
		0,
		-0.224335,
		0.967496,
		-0.116729,
		0,
		0.059362,
		-0.353397,
		-0.364636,
		1
	},
	[0.6] = {
		0.495337,
		0.21217,
		-0.842392,
		0,
		-0.20448,
		-0.913991,
		-0.350441,
		0,
		-0.844292,
		0.345839,
		-0.409349,
		0,
		-0.07819,
		-0.029473,
		-0.573478,
		1
	},
	[0.716666666667] = {
		0.501873,
		0.008401,
		-0.8649,
		0,
		-0.845871,
		-0.204053,
		-0.492813,
		0,
		-0.180626,
		0.978924,
		-0.095303,
		0,
		0.066506,
		-0.370591,
		-0.353638,
		1
	},
	[0.733333333333] = {
		0.50209,
		0.008769,
		-0.864771,
		0,
		-0.845458,
		-0.205405,
		-0.49296,
		0,
		-0.181951,
		0.978638,
		-0.095718,
		0,
		0.067111,
		-0.370632,
		-0.353482,
		1
	},
	[0.75] = {
		0.502317,
		0.009096,
		-0.864636,
		0,
		-0.844997,
		-0.206993,
		-0.493086,
		0,
		-0.183459,
		0.9783,
		-0.096291,
		0,
		0.067791,
		-0.370714,
		-0.353265,
		1
	},
	[0.766666666667] = {
		0.502551,
		0.009396,
		-0.864497,
		0,
		-0.844489,
		-0.208813,
		-0.493189,
		0,
		-0.185153,
		0.97791,
		-0.097005,
		0,
		0.068545,
		-0.370833,
		-0.352995,
		1
	},
	[0.783333333333] = {
		0.502788,
		0.009688,
		-0.864355,
		0,
		-0.843932,
		-0.210862,
		-0.493271,
		0,
		-0.187038,
		0.977468,
		-0.097843,
		0,
		0.069376,
		-0.370981,
		-0.352677,
		1
	},
	[0.7] = {
		0.50167,
		0.007973,
		-0.865022,
		0,
		-0.846236,
		-0.20294,
		-0.492645,
		0,
		-0.179476,
		0.979159,
		-0.095062,
		0,
		0.065974,
		-0.3706,
		-0.353729,
		1
	},
	[0.816666666667] = {
		0.503257,
		0.009933,
		-0.86408,
		0,
		-0.842839,
		-0.214994,
		-0.493357,
		0,
		-0.190672,
		0.976565,
		-0.099826,
		0,
		0.070985,
		-0.37139,
		-0.351925,
		1
	},
	[0.833333333333] = {
		0.503482,
		0.009826,
		-0.86395,
		0,
		-0.842345,
		-0.216916,
		-0.493358,
		0,
		-0.192252,
		0.976141,
		-0.100936,
		0,
		0.071695,
		-0.371654,
		-0.351503,
		1
	},
	[0.85] = {
		0.503698,
		0.00959,
		-0.863826,
		0,
		-0.841888,
		-0.218738,
		-0.493334,
		0,
		-0.193682,
		0.975737,
		-0.102104,
		0,
		0.072344,
		-0.371948,
		-0.351058,
		1
	},
	[0.866666666667] = {
		0.503903,
		0.009242,
		-0.863711,
		0,
		-0.841468,
		-0.220459,
		-0.493285,
		0,
		-0.194972,
		0.975352,
		-0.103313,
		0,
		0.072934,
		-0.372267,
		-0.350598,
		1
	},
	[0.883333333333] = {
		0.504093,
		0.008801,
		-0.863604,
		0,
		-0.841085,
		-0.222077,
		-0.493212,
		0,
		-0.196128,
		0.974989,
		-0.104546,
		0,
		0.073466,
		-0.372605,
		-0.350127,
		1
	},
	[0.8] = {
		0.503025,
		0.009892,
		-0.864216,
		0,
		-0.843368,
		-0.212976,
		-0.493328,
		0,
		-0.188937,
		0.977007,
		-0.098789,
		0,
		0.070213,
		-0.371164,
		-0.352319,
		1
	},
	[0.916666666667] = {
		0.504421,
		0.007707,
		-0.863423,
		0,
		-0.840433,
		-0.224997,
		-0.492999,
		0,
		-0.198068,
		0.974329,
		-0.107016,
		0,
		0.074365,
		-0.373313,
		-0.349182,
		1
	},
	[0.933333333333] = {
		0.504554,
		0.00709,
		-0.863351,
		0,
		-0.840165,
		-0.226295,
		-0.492862,
		0,
		-0.198867,
		0.974033,
		-0.108221,
		0,
		0.074733,
		-0.37367,
		-0.348721,
		1
	},
	[0.95] = {
		0.504661,
		0.00645,
		-0.863293,
		0,
		-0.839936,
		-0.227481,
		-0.492707,
		0,
		-0.199561,
		0.973761,
		-0.109383,
		0,
		0.075051,
		-0.374023,
		-0.348275,
		1
	},
	[0.966666666667] = {
		0.504741,
		0.005805,
		-0.863251,
		0,
		-0.839746,
		-0.228555,
		-0.492534,
		0,
		-0.200159,
		0.973514,
		-0.110486,
		0,
		0.075319,
		-0.374363,
		-0.347851,
		1
	},
	[0.983333333333] = {
		0.504791,
		0.005171,
		-0.863226,
		0,
		-0.839594,
		-0.229513,
		-0.492346,
		0,
		-0.200668,
		0.973292,
		-0.111514,
		0,
		0.075538,
		-0.374686,
		-0.347456,
		1
	},
	[0.9] = {
		0.504267,
		0.008283,
		-0.863508,
		0,
		-0.84074,
		-0.223591,
		-0.493116,
		0,
		-0.197157,
		0.974648,
		-0.105785,
		0,
		0.073943,
		-0.372956,
		-0.349653,
		1
	},
	[1.01666666667] = {
		0.504807,
		0.00401,
		-0.863223,
		0,
		-0.839399,
		-0.231076,
		-0.491948,
		0,
		-0.201443,
		0.972927,
		-0.113282,
		0,
		0.075846,
		-0.375254,
		-0.346774,
		1
	},
	[1.03333333333] = {
		0.504806,
		0.003519,
		-0.863226,
		0,
		-0.839333,
		-0.231676,
		-0.491778,
		0,
		-0.201719,
		0.972787,
		-0.113998,
		0,
		0.075952,
		-0.375488,
		-0.346498,
		1
	},
	[1.05] = {
		0.504806,
		0.003109,
		-0.863227,
		0,
		-0.839283,
		-0.232153,
		-0.491639,
		0,
		-0.20193,
		0.972674,
		-0.114583,
		0,
		0.076034,
		-0.37568,
		-0.346272,
		1
	},
	[1.06666666667] = {
		0.504805,
		0.0028,
		-0.863229,
		0,
		-0.839247,
		-0.232505,
		-0.491535,
		0,
		-0.202081,
		0.972591,
		-0.11502,
		0,
		0.076092,
		-0.375823,
		-0.346104,
		1
	},
	[1.08333333333] = {
		0.504805,
		0.002609,
		-0.863229,
		0,
		-0.839223,
		-0.232729,
		-0.491469,
		0,
		-0.202181,
		0.972538,
		-0.115294,
		0,
		0.076131,
		-0.375913,
		-0.345998,
		1
	},
	{
		0.504807,
		0.004567,
		-0.86322,
		0,
		-0.839482,
		-0.230354,
		-0.492145,
		0,
		-0.201094,
		0.973096,
		-0.11245,
		0,
		0.075711,
		-0.374985,
		-0.347095,
		1
	},
	[1.1] = {
		0.504805,
		0.002553,
		-0.86323,
		0,
		-0.83921,
		-0.232825,
		-0.491447,
		0,
		-0.202236,
		0.972515,
		-0.115388,
		0,
		0.076152,
		-0.375942,
		-0.345961,
		1
	}
}

return spline_matrices
