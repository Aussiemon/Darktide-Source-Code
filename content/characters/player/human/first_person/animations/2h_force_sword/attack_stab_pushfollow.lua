﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_force_sword/attack_stab_pushfollow.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.937589,
		0.323844,
		0.126693,
		0,
		0.088513,
		0.130081,
		-0.987545,
		0,
		-0.336291,
		0.937125,
		0.093298,
		0,
		0.408082,
		-0.222811,
		-0.444303,
		1,
	},
	[0.0333333333333] = {
		0.94188,
		0.260219,
		0.21248,
		0,
		0.177029,
		0.153096,
		-0.972225,
		0,
		-0.285521,
		0.953335,
		0.098132,
		0,
		0.368235,
		-0.289848,
		-0.446094,
		1,
	},
	[0.05] = {
		0.918945,
		0.181694,
		0.350038,
		0,
		0.320232,
		0.174295,
		-0.931168,
		0,
		-0.230198,
		0.967785,
		0.101983,
		0,
		0.324071,
		-0.342308,
		-0.430511,
		1,
	},
	[0.0666666666667] = {
		0.886306,
		0.10565,
		0.450887,
		0,
		0.431516,
		0.164992,
		-0.886889,
		0,
		-0.168092,
		0.98062,
		0.100643,
		0,
		0.274708,
		-0.388128,
		-0.404628,
		1,
	},
	[0.0833333333333] = {
		0.869654,
		0.055548,
		0.490526,
		0,
		0.479895,
		0.137892,
		-0.866422,
		0,
		-0.115768,
		0.988888,
		0.093261,
		0,
		0.225766,
		-0.419789,
		-0.375553,
		1,
	},
	[0] = {
		0.885442,
		0.408541,
		0.221556,
		0,
		0.169585,
		0.159834,
		-0.972468,
		0,
		-0.432705,
		0.898637,
		0.072241,
		0,
		0.433965,
		-0.134264,
		-0.408975,
		1,
	},
	[0.116666666667] = {
		0.848013,
		0.006578,
		0.529934,
		0,
		0.52803,
		0.075112,
		-0.845898,
		0,
		-0.045369,
		0.997153,
		0.060222,
		0,
		0.147414,
		-0.414487,
		-0.303474,
		1,
	},
	[0.133333333333] = {
		0.904339,
		0.007886,
		0.426743,
		0,
		0.42569,
		0.055882,
		-0.903142,
		0,
		-0.03097,
		0.998406,
		0.047179,
		0,
		0.122906,
		-0.329074,
		-0.254921,
		1,
	},
	[0.15] = {
		0.998594,
		0.018527,
		0.049661,
		0,
		0.049028,
		0.033196,
		-0.998246,
		0,
		-0.020143,
		0.999277,
		0.032241,
		0,
		0.084759,
		-0.090686,
		-0.205623,
		1,
	},
	[0.166666666667] = {
		0.950832,
		0.034536,
		-0.307777,
		0,
		-0.308541,
		0.019415,
		-0.951013,
		0,
		-0.026869,
		0.999215,
		0.029116,
		0,
		0.053139,
		0.180416,
		-0.156372,
		1,
	},
	[0.183333333333] = {
		0.92017,
		0.045838,
		-0.388827,
		0,
		-0.389873,
		0.016308,
		-0.920724,
		0,
		-0.035863,
		0.998816,
		0.032877,
		0,
		0.045848,
		0.40212,
		-0.113264,
		1,
	},
	[0.1] = {
		0.85561,
		0.025347,
		0.516999,
		0,
		0.51229,
		0.1015,
		-0.852793,
		0,
		-0.074091,
		0.994513,
		0.073859,
		0,
		0.180424,
		-0.429158,
		-0.346793,
		1,
	},
	[0.216666666667] = {
		0.880628,
		0.078931,
		-0.467188,
		0,
		-0.470159,
		0.023424,
		-0.882271,
		0,
		-0.058696,
		0.996605,
		0.057738,
		0,
		0.054065,
		0.503832,
		-0.086886,
		1,
	},
	[0.233333333333] = {
		0.85859,
		0.093076,
		-0.504143,
		0,
		-0.508343,
		0.027177,
		-0.860725,
		0,
		-0.066411,
		0.995288,
		0.070649,
		0,
		0.059451,
		0.489825,
		-0.084835,
		1,
	},
	[0.25] = {
		0.84978,
		0.096243,
		-0.518278,
		0,
		-0.52271,
		0.026681,
		-0.852093,
		0,
		-0.06818,
		0.995,
		0.07298,
		0,
		0.056991,
		0.494973,
		-0.081013,
		1,
	},
	[0.266666666667] = {
		0.840888,
		0.096361,
		-0.532562,
		0,
		-0.536998,
		0.026033,
		-0.843182,
		0,
		-0.067386,
		0.995006,
		0.073637,
		0,
		0.054298,
		0.501455,
		-0.077162,
		1,
	},
	[0.283333333333] = {
		0.831958,
		0.093973,
		-0.546823,
		0,
		-0.551076,
		0.02536,
		-0.83407,
		0,
		-0.064513,
		0.995252,
		0.072885,
		0,
		0.051951,
		0.504554,
		-0.073553,
		1,
	},
	[0.2] = {
		0.909709,
		0.058108,
		-0.411161,
		0,
		-0.412701,
		0.017031,
		-0.910707,
		0,
		-0.045917,
		0.998165,
		0.039474,
		0,
		0.047811,
		0.518048,
		-0.090333,
		1,
	},
	[0.316666666667] = {
		0.813836,
		0.088064,
		-0.574383,
		0,
		-0.578177,
		0.023784,
		-0.815565,
		0,
		-0.058161,
		0.995831,
		0.070273,
		0,
		0.048343,
		0.510325,
		-0.067036,
		1,
	},
	[0.333333333333] = {
		0.804799,
		0.085503,
		-0.587357,
		0,
		-0.590951,
		0.022956,
		-0.806381,
		0,
		-0.055465,
		0.996073,
		0.069004,
		0,
		0.048146,
		0.512546,
		-0.064642,
		1,
	},
	[0.35] = {
		0.795934,
		0.083385,
		-0.599613,
		0,
		-0.60304,
		0.022145,
		-0.797403,
		0,
		-0.053212,
		0.996271,
		0.067911,
		0,
		0.048801,
		0.514008,
		-0.063165,
		1,
	},
	[0.366666666667] = {
		0.787399,
		0.081406,
		-0.611045,
		0,
		-0.614318,
		0.021376,
		-0.788769,
		0,
		-0.051149,
		0.996452,
		0.066841,
		0,
		0.049557,
		0.514471,
		-0.062858,
		1,
	},
	[0.383333333333] = {
		0.779334,
		0.079564,
		-0.621536,
		0,
		-0.624669,
		0.020668,
		-0.780616,
		0,
		-0.049263,
		0.996615,
		0.065808,
		0,
		0.05041,
		0.514287,
		-0.063253,
		1,
	},
	[0.3] = {
		0.822917,
		0.091048,
		-0.560819,
		0,
		-0.564844,
		0.024597,
		-0.824831,
		0,
		-0.061305,
		0.995543,
		0.071669,
		0,
		0.049788,
		0.507585,
		-0.070092,
		1,
	},
	[0.416666666667] = {
		0.765194,
		0.076271,
		-0.639266,
		0,
		-0.642155,
		0.019485,
		-0.766327,
		0,
		-0.045992,
		0.996897,
		0.063887,
		0,
		0.052396,
		0.512341,
		-0.06466,
		1,
	},
	[0.433333333333] = {
		0.759412,
		0.074806,
		-0.646295,
		0,
		-0.64908,
		0.019027,
		-0.760482,
		0,
		-0.044592,
		0.997017,
		0.063004,
		0,
		0.053524,
		0.509799,
		-0.065955,
		1,
	},
	[0.45] = {
		0.754684,
		0.073452,
		-0.651964,
		0,
		-0.654655,
		0.018664,
		-0.755697,
		0,
		-0.043339,
		0.997124,
		0.062171,
		0,
		0.054737,
		0.505691,
		-0.067833,
		1,
	},
	[0.466666666667] = {
		0.751153,
		0.072201,
		-0.656167,
		0,
		-0.658775,
		0.018399,
		-0.752115,
		0,
		-0.042231,
		0.99722,
		0.061384,
		0,
		0.056032,
		0.499626,
		-0.070434,
		1,
	},
	[0.483333333333] = {
		0.748958,
		0.071043,
		-0.658798,
		0,
		-0.661332,
		0.018235,
		-0.749872,
		0,
		-0.04126,
		0.997307,
		0.060641,
		0,
		0.057408,
		0.491215,
		-0.073902,
		1,
	},
	[0.4] = {
		0.771884,
		0.077854,
		-0.630979,
		0,
		-0.633983,
		0.020034,
		-0.773087,
		0,
		-0.047547,
		0.996763,
		0.064822,
		0,
		0.051357,
		0.513707,
		-0.063807,
		1,
	},
	[0.516666666667] = {
		0.76758,
		0.068826,
		-0.637247,
		0,
		-0.639686,
		0.019792,
		-0.768381,
		0,
		-0.040272,
		0.997432,
		0.059219,
		0,
		0.061736,
		0.463042,
		-0.084953,
		1,
	},
	[0.533333333333] = {
		0.816583,
		0.067391,
		-0.57328,
		0,
		-0.575764,
		0.024408,
		-0.817252,
		0,
		-0.041083,
		0.997428,
		0.058732,
		0,
		0.067063,
		0.43844,
		-0.09436,
		1,
	},
	[0.55] = {
		0.879031,
		0.065473,
		-0.472247,
		0,
		-0.474862,
		0.031828,
		-0.879485,
		0,
		-0.042552,
		0.997347,
		0.059069,
		0,
		0.074469,
		0.408095,
		-0.106251,
		1,
	},
	[0.566666666667] = {
		0.938102,
		0.062734,
		-0.340631,
		0,
		-0.343472,
		0.041762,
		-0.938234,
		0,
		-0.044633,
		0.997156,
		0.060724,
		0,
		0.083558,
		0.373832,
		-0.120256,
		1,
	},
	[0.583333333333] = {
		0.980154,
		0.058783,
		-0.189323,
		0,
		-0.192475,
		0.053576,
		-0.979838,
		0,
		-0.047455,
		0.996832,
		0.063827,
		0,
		0.093903,
		0.337455,
		-0.135962,
		1,
	},
	[0.5] = {
		0.748227,
		0.069971,
		-0.659742,
		0,
		-0.66221,
		0.01818,
		-0.749098,
		0,
		-0.040421,
		0.997383,
		0.059938,
		0,
		0.058869,
		0.480072,
		-0.078381,
		1,
	},
	[0.616666666667] = {
		0.992715,
		0.046753,
		0.111049,
		0,
		0.107183,
		0.078351,
		-0.991147,
		0,
		-0.05504,
		0.995829,
		0.072769,
		0,
		0.11642,
		0.265401,
		-0.170523,
		1,
	},
	[0.633333333333] = {
		0.972791,
		0.039465,
		0.228297,
		0,
		0.224172,
		0.088536,
		-0.970519,
		0,
		-0.058514,
		0.995291,
		0.077281,
		0,
		0.127501,
		0.233139,
		-0.188243,
		1,
	},
	[0.65] = {
		0.95144,
		0.032518,
		0.306111,
		0,
		0.301916,
		0.095475,
		-0.948542,
		0,
		-0.060071,
		0.994901,
		0.081021,
		0,
		0.137669,
		0.205593,
		-0.20541,
		1,
	},
	[0.666666666667] = {
		0.942089,
		0.026972,
		0.334276,
		0,
		0.330293,
		0.098031,
		-0.938774,
		0,
		-0.05809,
		0.994818,
		0.083445,
		0,
		0.146299,
		0.184377,
		-0.221357,
		1,
	},
	[0.683333333333] = {
		0.942232,
		0.022229,
		0.334222,
		0,
		0.331036,
		0.090507,
		-0.939268,
		0,
		-0.051128,
		0.995648,
		0.07792,
		0,
		0.154192,
		0.166871,
		-0.23719,
		1,
	},
	[0.6] = {
		0.998019,
		0.053402,
		-0.033248,
		0,
		-0.036762,
		0.066222,
		-0.997127,
		0,
		-0.051047,
		0.996375,
		0.068054,
		0,
		0.10503,
		0.300735,
		-0.152897,
		1,
	},
	[0.716666666667] = {
		0.942475,
		0.011754,
		0.33407,
		0,
		0.333506,
		0.034788,
		-0.942106,
		0,
		-0.022695,
		0.999326,
		0.028866,
		0,
		0.171118,
		0.132131,
		-0.272448,
		1,
	},
	[0.733333333333] = {
		0.94256,
		0.006151,
		0.333981,
		0,
		0.334029,
		-0.010355,
		-0.942506,
		0,
		-0.002339,
		0.999927,
		-0.011815,
		0,
		0.179957,
		0.115038,
		-0.291395,
		1,
	},
	[0.75] = {
		0.942612,
		0.000389,
		0.333889,
		0,
		0.333209,
		-0.064857,
		-0.94062,
		0,
		0.021289,
		0.997894,
		-0.061265,
		0,
		0.188921,
		0.098228,
		-0.310908,
		1,
	},
	[0.766666666667] = {
		0.942629,
		-0.005466,
		0.333798,
		0,
		0.330448,
		-0.126934,
		-0.935249,
		0,
		0.047483,
		0.991896,
		-0.117845,
		0,
		0.197916,
		0.081777,
		-0.330753,
		1,
	},
	[0.783333333333] = {
		0.942607,
		-0.011351,
		0.333712,
		0,
		0.325266,
		-0.194655,
		-0.925371,
		0,
		0.075463,
		0.980806,
		-0.179791,
		0,
		0.206852,
		0.065767,
		-0.350702,
		1,
	},
	[0.7] = {
		0.942363,
		0.017135,
		0.334153,
		0,
		0.332293,
		0.068924,
		-0.940654,
		0,
		-0.039149,
		0.997475,
		0.059257,
		0,
		0.162498,
		0.149432,
		-0.254301,
		1,
	},
	[0.816666666667] = {
		0.942447,
		-0.022952,
		0.333568,
		0,
		0.306581,
		-0.338789,
		-0.889511,
		0,
		0.133425,
		0.940582,
		-0.312254,
		0,
		0.224195,
		0.035419,
		-0.390007,
		1,
	},
	[0.833333333333] = {
		0.942313,
		-0.028539,
		0.333513,
		0,
		0.293075,
		-0.411023,
		-0.863231,
		0,
		0.161717,
		0.911178,
		-0.378949,
		0,
		0.23243,
		0.021267,
		-0.408917,
		1,
	},
	[0.85] = {
		0.942151,
		-0.033897,
		0.333471,
		0,
		0.277159,
		-0.480724,
		-0.831918,
		0,
		0.188507,
		0.876217,
		-0.443519,
		0,
		0.240261,
		0.007928,
		-0.42704,
		1,
	},
	[0.866666666667] = {
		0.941965,
		-0.038964,
		0.333442,
		0,
		0.259364,
		-0.546156,
		-0.796519,
		0,
		0.213147,
		0.836777,
		-0.504355,
		0,
		0.247607,
		-0.004492,
		-0.444159,
		1,
	},
	[0.883333333333] = {
		0.941765,
		-0.043674,
		0.333424,
		0,
		0.240395,
		-0.605883,
		-0.758364,
		0,
		0.235136,
		0.794354,
		-0.5601,
		0,
		0.254387,
		-0.015884,
		-0.460058,
		1,
	},
	[0.8] = {
		0.942545,
		-0.017201,
		0.333635,
		0,
		0.317348,
		-0.265975,
		-0.910246,
		0,
		0.104396,
		0.963826,
		-0.245235,
		0,
		0.215641,
		0.050284,
		-0.370528,
		1,
	},
	[0.916666666667] = {
		0.941357,
		-0.051767,
		0.333418,
		0,
		0.202325,
		-0.704195,
		-0.680569,
		0,
		0.270022,
		0.708117,
		-0.652425,
		0,
		0.265927,
		-0.035133,
		-0.487347,
		1,
	},
	[0.933333333333] = {
		0.94117,
		-0.055023,
		0.333425,
		0,
		0.185067,
		-0.741626,
		-0.64478,
		0,
		0.282754,
		0.668554,
		-0.687813,
		0,
		0.270529,
		-0.042756,
		-0.498313,
		1,
	},
	[0.95] = {
		0.941008,
		-0.057667,
		0.333434,
		0,
		0.17023,
		-0.770931,
		-0.613748,
		0,
		0.292448,
		0.634302,
		-0.715636,
		0,
		0.274247,
		-0.048887,
		-0.507213,
		1,
	},
	[0.966666666667] = {
		0.940882,
		-0.059634,
		0.333445,
		0,
		0.158693,
		-0.792072,
		-0.589439,
		0,
		0.299263,
		0.607508,
		-0.735783,
		0,
		0.277002,
		-0.053409,
		-0.513834,
		1,
	},
	[0.983333333333] = {
		0.940801,
		-0.060861,
		0.333452,
		0,
		0.15126,
		-0.804986,
		-0.573688,
		0,
		0.30334,
		0.590164,
		-0.748125,
		0,
		0.278715,
		-0.056204,
		-0.517964,
		1,
	},
	[0.9] = {
		0.941559,
		-0.047963,
		0.333417,
		0,
		0.22108,
		-0.658809,
		-0.719093,
		0,
		0.254147,
		0.75078,
		-0.609704,
		0,
		0.26052,
		-0.026136,
		-0.474525,
		1,
	},
	{
		0.940772,
		-0.061284,
		0.333455,
		0,
		0.148643,
		-0.809409,
		-0.568122,
		0,
		0.304718,
		0.584039,
		-0.75236,
		0,
		0.279305,
		-0.05716,
		-0.519388,
		1,
	},
}

return spline_matrices
