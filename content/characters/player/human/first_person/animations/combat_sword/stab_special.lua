local spline_matrices = {
	[0] = {
		0.428824,
		0.297689,
		0.852931,
		0,
		0.369347,
		-0.919405,
		0.135195,
		0,
		0.824435,
		0.257052,
		-0.504214,
		0,
		0.219526,
		0.335755,
		-0.295264,
		1
	},
	{
		0.810978,
		0.581906,
		0.060825,
		0,
		-0.541881,
		0.78624,
		-0.296971,
		0,
		-0.220632,
		0.207877,
		0.952947,
		0,
		0.31719,
		0.493088,
		-0.274403,
		1
	},
	[0.0166666666667] = {
		0.399071,
		0.249634,
		0.882284,
		0,
		0.473016,
		-0.880353,
		0.035136,
		0,
		0.785493,
		0.403313,
		-0.469404,
		0,
		0.249081,
		0.328572,
		-0.300027,
		1
	},
	[0.0333333333333] = {
		0.372225,
		0.198435,
		0.906682,
		0,
		0.572565,
		-0.817942,
		-0.056045,
		0,
		0.730492,
		0.539995,
		-0.418075,
		0,
		0.286153,
		0.300921,
		-0.306374,
		1
	},
	[0.05] = {
		0.35448,
		0.147041,
		0.92343,
		0,
		0.657504,
		-0.741377,
		-0.134346,
		0,
		0.664855,
		0.654781,
		-0.359484,
		0,
		0.323636,
		0.249028,
		-0.312641,
		1
	},
	[0.0666666666667] = {
		0.350637,
		0.101351,
		0.931011,
		0,
		0.719902,
		-0.665015,
		-0.198735,
		0,
		0.598994,
		0.739921,
		-0.306142,
		0,
		0.353916,
		0.188914,
		-0.317755,
		1
	},
	[0.0833333333333] = {
		0.42729,
		0.051168,
		0.902665,
		0,
		0.772203,
		-0.539932,
		-0.334927,
		0,
		0.470241,
		0.840152,
		-0.27022,
		0,
		0.368876,
		0.129743,
		-0.325372,
		1
	},
	[0.116666666667] = {
		0.676227,
		-0.036479,
		0.73579,
		0,
		0.708915,
		-0.239459,
		-0.6634,
		0,
		0.200392,
		0.970221,
		-0.136068,
		0,
		0.371487,
		-0.062268,
		-0.335568,
		1
	},
	[0.133333333333] = {
		0.787389,
		-0.043565,
		0.614916,
		0,
		0.610651,
		-0.081461,
		-0.787699,
		0,
		0.084408,
		0.995724,
		-0.037539,
		0,
		0.368762,
		-0.18012,
		-0.334519,
		1
	},
	[0.15] = {
		0.869454,
		-0.020484,
		0.493589,
		0,
		0.493817,
		0.064227,
		-0.867191,
		0,
		-0.013938,
		0.997725,
		0.065958,
		0,
		0.377919,
		-0.235167,
		-0.328455,
		1
	},
	[0.166666666667] = {
		0.894748,
		0.005522,
		0.446538,
		0,
		0.438993,
		0.172569,
		-0.881763,
		0,
		-0.081927,
		0.984982,
		0.151982,
		0,
		0.381672,
		-0.128954,
		-0.401003,
		1
	},
	[0.183333333333] = {
		0.781467,
		-0.017026,
		0.623715,
		0,
		0.616654,
		0.173465,
		-0.767885,
		0,
		-0.095119,
		0.984693,
		0.146056,
		0,
		0.373047,
		0.100009,
		-0.374155,
		1
	},
	[0.1] = {
		0.545646,
		-0.00162,
		0.838014,
		0,
		0.76885,
		-0.396848,
		-0.501379,
		0,
		0.333376,
		0.917883,
		-0.215293,
		0,
		0.374575,
		0.052209,
		-0.331958,
		1
	},
	[0.216666666667] = {
		0.394422,
		-0.037353,
		0.91817,
		0,
		0.918421,
		0.049252,
		-0.392527,
		0,
		-0.03056,
		0.998088,
		0.053732,
		0,
		0.21919,
		0.566503,
		-0.210589,
		1
	},
	[0.233333333333] = {
		0.463444,
		-0.018168,
		0.88594,
		0,
		0.884371,
		0.072378,
		-0.461139,
		0,
		-0.055745,
		0.997212,
		0.049611,
		0,
		0.116558,
		0.696555,
		-0.128699,
		1
	},
	[0.25] = {
		0.506193,
		-0.037738,
		0.861594,
		0,
		0.856006,
		0.143601,
		-0.49662,
		0,
		-0.104985,
		0.988916,
		0.104993,
		0,
		0.106283,
		0.580885,
		-0.107617,
		1
	},
	[0.266666666667] = {
		0.377443,
		-0.076907,
		0.922834,
		0,
		0.919673,
		0.147729,
		-0.363839,
		0,
		-0.108348,
		0.986033,
		0.126489,
		0,
		0.112257,
		0.464025,
		-0.098146,
		1
	},
	[0.283333333333] = {
		0.407204,
		-0.072027,
		0.910493,
		0,
		0.906292,
		0.155444,
		-0.393029,
		0,
		-0.113222,
		0.985215,
		0.128575,
		0,
		0.108797,
		0.481665,
		-0.096926,
		1
	},
	[0.2] = {
		0.577013,
		-0.04443,
		0.815525,
		0,
		0.813511,
		0.119898,
		-0.569056,
		0,
		-0.072497,
		0.991792,
		0.105327,
		0,
		0.335415,
		0.336271,
		-0.31734,
		1
	},
	[0.316666666667] = {
		0.586536,
		-0.028739,
		0.809413,
		0,
		0.801195,
		0.166912,
		-0.574654,
		0,
		-0.118586,
		0.985553,
		0.120926,
		0,
		0.088905,
		0.559836,
		-0.097687,
		1
	},
	[0.333333333333] = {
		0.638213,
		-0.011822,
		0.769769,
		0,
		0.760351,
		0.166343,
		-0.62785,
		0,
		-0.120623,
		0.985997,
		0.115151,
		0,
		0.082832,
		0.579907,
		-0.098294,
		1
	},
	[0.35] = {
		0.643152,
		-0.009525,
		0.765679,
		0,
		0.756174,
		0.165451,
		-0.633109,
		0,
		-0.120652,
		0.986172,
		0.113613,
		0,
		0.082955,
		0.581574,
		-0.098448,
		1
	},
	[0.366666666667] = {
		0.621784,
		-0.015702,
		0.783032,
		0,
		0.77415,
		0.163786,
		-0.611446,
		0,
		-0.118649,
		0.986371,
		0.113996,
		0,
		0.085643,
		0.578604,
		-0.09791,
		1
	},
	[0.383333333333] = {
		0.57958,
		-0.027659,
		0.814446,
		0,
		0.806695,
		0.161074,
		-0.568594,
		0,
		-0.11546,
		0.986555,
		0.115668,
		0,
		0.090042,
		0.572277,
		-0.096892,
		1
	},
	[0.3] = {
		0.494752,
		-0.053584,
		0.867381,
		0,
		0.861228,
		0.163713,
		-0.481129,
		0,
		-0.116221,
		0.985052,
		0.127146,
		0,
		0.099619,
		0.520438,
		-0.097049,
		1
	},
	[0.416666666667] = {
		0.45477,
		-0.057474,
		0.888752,
		0,
		0.883945,
		0.150976,
		-0.442547,
		0,
		-0.108746,
		0.986865,
		0.119464,
		0,
		0.100583,
		0.55637,
		-0.094852,
		1
	},
	[0.433333333333] = {
		0.386574,
		-0.07061,
		0.919551,
		0,
		0.916084,
		0.144578,
		-0.374015,
		0,
		-0.106538,
		0.986971,
		0.120575,
		0,
		0.105108,
		0.548395,
		-0.094309,
		1
	},
	[0.45] = {
		0.32642,
		-0.080332,
		0.941805,
		0,
		0.939392,
		0.138094,
		-0.313805,
		0,
		-0.104849,
		0.987156,
		0.12054,
		0,
		0.108649,
		0.541433,
		-0.094629,
		1
	},
	[0.466666666667] = {
		0.284067,
		-0.085448,
		0.954989,
		0,
		0.953279,
		0.131943,
		-0.271753,
		0,
		-0.102784,
		0.987568,
		0.118936,
		0,
		0.111246,
		0.536204,
		-0.096358,
		1
	},
	[0.483333333333] = {
		0.255741,
		-0.087119,
		0.962812,
		0,
		0.961237,
		0.12908,
		-0.243643,
		0,
		-0.103054,
		0.9878,
		0.116753,
		0,
		0.114284,
		0.532617,
		-0.098956,
		1
	},
	[0.4] = {
		0.521776,
		-0.042421,
		0.852027,
		0,
		0.84571,
		0.15675,
		-0.510103,
		0,
		-0.111916,
		0.986727,
		0.117664,
		0,
		0.095298,
		0.564604,
		-0.095813,
		1
	},
	[0.516666666667] = {
		0.218974,
		-0.08634,
		0.971903,
		0,
		0.968846,
		0.137355,
		-0.206083,
		0,
		-0.115702,
		0.986752,
		0.113728,
		0,
		0.125489,
		0.528133,
		-0.104409,
		1
	},
	[0.533333333333] = {
		0.21438,
		-0.083932,
		0.973138,
		0,
		0.968604,
		0.146674,
		-0.200731,
		0,
		-0.125886,
		0.985618,
		0.112741,
		0,
		0.133056,
		0.526999,
		-0.107672,
		1
	},
	[0.55] = {
		0.218089,
		-0.080632,
		0.972592,
		0,
		0.966249,
		0.157857,
		-0.20358,
		0,
		-0.137116,
		0.984164,
		0.112337,
		0,
		0.141667,
		0.526289,
		-0.111754,
		1
	},
	[0.566666666667] = {
		0.22968,
		-0.076824,
		0.970229,
		0,
		0.961916,
		0.169717,
		-0.214274,
		0,
		-0.148203,
		0.982494,
		0.112879,
		0,
		0.151126,
		0.525701,
		-0.116784,
		1
	},
	[0.583333333333] = {
		0.249025,
		-0.072818,
		0.965756,
		0,
		0.955509,
		0.181232,
		-0.232718,
		0,
		-0.15808,
		0.980741,
		0.114709,
		0,
		0.16107,
		0.525075,
		-0.122846,
		1
	},
	[0.5] = {
		0.233079,
		-0.087422,
		0.96852,
		0,
		0.966473,
		0.131154,
		-0.220748,
		0,
		-0.107727,
		0.9875,
		0.11506,
		0,
		0.119142,
		0.529964,
		-0.101608,
		1
	},
	[0.616666666667] = {
		0.313554,
		-0.064312,
		0.94739,
		0,
		0.933997,
		0.200841,
		-0.295488,
		0,
		-0.171271,
		0.977511,
		0.123042,
		0,
		0.180899,
		0.523083,
		-0.138521,
		1
	},
	[0.633333333333] = {
		0.360093,
		-0.05964,
		0.931008,
		0,
		0.916717,
		0.207788,
		-0.341255,
		0,
		-0.1731,
		0.976354,
		0.129497,
		0,
		0.190205,
		0.521399,
		-0.148434,
		1
	},
	[0.65] = {
		0.429676,
		-0.051888,
		0.901491,
		0,
		0.885696,
		0.218634,
		-0.409563,
		0,
		-0.175845,
		0.974426,
		0.139899,
		0,
		0.203103,
		0.518655,
		-0.166597,
		1
	},
	[0.666666666667] = {
		0.520089,
		-0.039609,
		0.853193,
		0,
		0.835066,
		0.233359,
		-0.498205,
		0,
		-0.179367,
		0.971583,
		0.154444,
		0,
		0.22099,
		0.514797,
		-0.194324,
		1
	},
	[0.683333333333] = {
		0.610786,
		-0.026221,
		0.791361,
		0,
		0.771771,
		0.243065,
		-0.587613,
		0,
		-0.176944,
		0.969656,
		0.168698,
		0,
		0.239487,
		0.510472,
		-0.223767,
		1
	},
	[0.6] = {
		0.276748,
		-0.068661,
		0.958487,
		0,
		0.946494,
		0.191792,
		-0.259546,
		0,
		-0.16601,
		0.979031,
		0.118065,
		0,
		0.17109,
		0.524255,
		-0.130041,
		1
	},
	[0.716666666667] = {
		0.742752,
		-0.028002,
		0.668981,
		0,
		0.657196,
		0.221654,
		-0.72039,
		0,
		-0.12811,
		0.974723,
		0.183037,
		0,
		0.267218,
		0.503131,
		-0.267139,
		1
	},
	[0.733333333333] = {
		0.80569,
		-0.026015,
		0.591765,
		0,
		0.581625,
		0.223878,
		-0.782043,
		0,
		-0.112138,
		0.97427,
		0.195508,
		0,
		0.281247,
		0.499429,
		-0.28899,
		1
	},
	[0.75] = {
		0.872123,
		-0.003598,
		0.489274,
		0,
		0.471559,
		0.272913,
		-0.838541,
		0,
		-0.130512,
		0.962032,
		0.23971,
		0,
		0.295019,
		0.495363,
		-0.311653,
		1
	},
	[0.766666666667] = {
		0.930137,
		0.030806,
		0.365919,
		0,
		0.33256,
		0.351903,
		-0.874968,
		0,
		-0.155723,
		0.935529,
		0.317073,
		0,
		0.307467,
		0.491022,
		-0.333581,
		1
	},
	[0.783333333333] = {
		0.970446,
		0.07001,
		0.23094,
		0,
		0.177082,
		0.443541,
		-0.878586,
		0,
		-0.163941,
		0.893516,
		0.418034,
		0,
		0.317597,
		0.486545,
		-0.353151,
		1
	},
	[0.7] = {
		0.687053,
		-0.017262,
		0.726402,
		0,
		0.707988,
		0.240768,
		-0.663915,
		0,
		-0.163434,
		0.970429,
		0.177642,
		0,
		0.254029,
		0.506429,
		-0.247513,
		1
	},
	[0.816666666667] = {
		0.986314,
		0.164427,
		0.012184,
		0,
		-0.089272,
		0.5947,
		-0.798976,
		0,
		-0.138619,
		0.786954,
		0.601239,
		0,
		0.335327,
		0.479342,
		-0.37901,
		1
	},
	[0.833333333333] = {
		0.975557,
		0.215204,
		-0.044444,
		0,
		-0.174052,
		0.63327,
		-0.754105,
		0,
		-0.134141,
		0.743409,
		0.655248,
		0,
		0.341319,
		0.47714,
		-0.381901,
		1
	},
	[0.85] = {
		0.963715,
		0.258202,
		-0.067718,
		0,
		-0.22384,
		0.64348,
		-0.732004,
		0,
		-0.14543,
		0.720601,
		0.677927,
		0,
		0.343494,
		0.47569,
		-0.37886,
		1
	},
	[0.866666666667] = {
		0.951479,
		0.29895,
		-0.072915,
		0,
		-0.257269,
		0.642842,
		-0.721503,
		0,
		-0.16882,
		0.705254,
		0.688561,
		0,
		0.343527,
		0.474899,
		-0.372735,
		1
	},
	[0.883333333333] = {
		0.936014,
		0.344348,
		-0.072817,
		0,
		-0.294244,
		0.652064,
		-0.698736,
		0,
		-0.193127,
		0.675453,
		0.711664,
		0,
		0.341839,
		0.474764,
		-0.36395,
		1
	},
	[0.8] = {
		0.98925,
		0.108801,
		0.097706,
		0,
		0.025059,
		0.532142,
		-0.846284,
		0,
		-0.144071,
		0.839635,
		0.523696,
		0,
		0.324524,
		0.482137,
		-0.36869,
		1
	},
	[0.916666666667] = {
		0.897755,
		0.43698,
		-0.055533,
		0,
		-0.374861,
		0.691687,
		-0.617291,
		0,
		-0.231332,
		0.574994,
		0.784772,
		0,
		0.335006,
		0.476135,
		-0.340276,
		1
	},
	[0.933333333333] = {
		0.877108,
		0.478761,
		-0.038337,
		0,
		-0.415501,
		0.716328,
		-0.560565,
		0,
		-0.240915,
		0.507605,
		0.827222,
		0,
		0.330733,
		0.477387,
		-0.326487,
		1
	},
	[0.95] = {
		0.857193,
		0.514734,
		-0.016403,
		0,
		-0.453921,
		0.740109,
		-0.496179,
		0,
		-0.24326,
		0.432767,
		0.868065,
		0,
		0.326459,
		0.478857,
		-0.312263,
		1
	},
	[0.966666666667] = {
		0.839155,
		0.543822,
		0.008734,
		0,
		-0.488428,
		0.76055,
		-0.427788,
		0,
		-0.239283,
		0.354714,
		0.903837,
		0,
		0.32257,
		0.480482,
		-0.298338,
		1
	},
	[0.983333333333] = {
		0.823702,
		0.565933,
		0.035144,
		0,
		-0.517875,
		0.7761,
		-0.359825,
		0,
		-0.230912,
		0.278189,
		0.932358,
		0,
		0.319395,
		0.485076,
		-0.285467,
		1
	},
	[0.9] = {
		0.917803,
		0.391326,
		-0.067102,
		0,
		-0.333876,
		0.669234,
		-0.663817,
		0,
		-0.214861,
		0.631656,
		0.744879,
		0,
		0.338854,
		0.475215,
		-0.352959,
		1
	},
	[1.01666666667] = {
		0.800589,
		0.593299,
		0.083983,
		0,
		-0.560833,
		0.791268,
		-0.243641,
		0,
		-0.211005,
		0.147956,
		0.966223,
		0,
		0.316155,
		0.500995,
		-0.265856,
		1
	},
	[1.03333333333] = {
		0.791736,
		0.602094,
		0.103132,
		0,
		-0.575686,
		0.791898,
		-0.203675,
		0,
		-0.204302,
		0.101885,
		0.973591,
		0,
		0.316463,
		0.505286,
		-0.260462,
		1
	},
	[1.05] = {
		0.790624,
		0.606969,
		0.080638,
		0,
		-0.587096,
		0.788872,
		-0.18166,
		0,
		-0.173874,
		0.096283,
		0.98005,
		0,
		0.310771,
		0.504503,
		-0.258492,
		1
	},
	[1.06666666667] = {
		0.791547,
		0.607198,
		0.069025,
		0,
		-0.58826,
		0.787673,
		-0.183089,
		0,
		-0.16554,
		0.104319,
		0.98067,
		0,
		0.308393,
		0.504228,
		-0.25863,
		1
	}
}

return spline_matrices
