﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_axe/heavy_attack_right_down.lua

local spline_matrices = {
	[0.0333333333333] = {
		0.575132,
		0.009332,
		0.818007,
		0,
		-0.815973,
		0.077933,
		0.572813,
		0,
		-0.058404,
		-0.996915,
		0.052436,
		0,
		-0.317753,
		-0.015374,
		0.077657,
		1,
	},
	[0.0666666666667] = {
		0.60149,
		-0.068768,
		0.795915,
		0,
		-0.793353,
		0.065573,
		0.605219,
		0,
		-0.093811,
		-0.995475,
		-0.015116,
		0,
		-0.330645,
		-0.007749,
		0.085195,
		1,
	},
	[0] = {
		0.543545,
		0.077146,
		0.835827,
		0,
		-0.839307,
		0.063129,
		0.539981,
		0,
		-0.011107,
		-0.995019,
		0.099063,
		0,
		-0.309445,
		-0.019352,
		0.074937,
		1,
	},
	[0.133333333333] = {
		0.659068,
		-0.113466,
		0.743474,
		0,
		-0.742493,
		0.059201,
		0.667233,
		0,
		-0.119723,
		-0.991777,
		-0.04523,
		0,
		-0.315944,
		0.048962,
		0.101391,
		1,
	},
	[0.166666666667] = {
		0.704722,
		-0.087461,
		0.704072,
		0,
		-0.694298,
		0.119204,
		0.709747,
		0,
		-0.146003,
		-0.98901,
		0.023281,
		0,
		-0.246541,
		0.101977,
		0.096107,
		1,
	},
	[0.1] = {
		0.616508,
		-0.143043,
		0.774245,
		0,
		-0.774316,
		0.068028,
		0.629132,
		0,
		-0.142664,
		-0.987376,
		-0.068821,
		0,
		-0.34471,
		0.015337,
		0.095169,
		1,
	},
	[0.233333333333] = {
		0.749626,
		-0.11623,
		0.651576,
		0,
		-0.342396,
		0.774389,
		0.532059,
		0,
		-0.566414,
		-0.621942,
		0.540706,
		0,
		-0.049793,
		0.517997,
		0.080322,
		1,
	},
	[0.266666666667] = {
		0.790454,
		-0.033741,
		0.611591,
		0,
		0.205845,
		0.955043,
		-0.213357,
		0,
		-0.576897,
		0.294542,
		0.761863,
		0,
		0.019658,
		0.711842,
		-0.031438,
		1,
	},
	[0.2] = {
		0.741919,
		-0.103029,
		0.662527,
		0,
		-0.593005,
		0.360291,
		0.720094,
		0,
		-0.312893,
		-0.927133,
		0.20621,
		0,
		-0.151942,
		0.259098,
		0.089418,
		1,
	},
	[0.333333333333] = {
		0.7393,
		0.004701,
		0.67336,
		0,
		0.658427,
		0.204493,
		-0.724332,
		0,
		-0.141103,
		0.978857,
		0.148086,
		0,
		0.231523,
		0.594726,
		-0.408443,
		1,
	},
	[0.366666666667] = {
		0.769934,
		-0.147975,
		0.620729,
		0,
		0.558073,
		-0.315564,
		-0.767446,
		0,
		0.309443,
		0.937295,
		-0.160383,
		0,
		0.418169,
		0.370382,
		-0.643985,
		1,
	},
	[0.3] = {
		0.860445,
		-0.020127,
		0.509146,
		0,
		0.439602,
		0.534583,
		-0.721783,
		0,
		-0.257654,
		0.844876,
		0.468827,
		0,
		0.125919,
		0.744634,
		-0.234453,
		1,
	},
	[0.433333333333] = {
		0.908506,
		-0.120535,
		0.400111,
		0,
		0.278758,
		-0.538497,
		-0.795182,
		0,
		0.311306,
		0.833962,
		-0.455628,
		0,
		0.329244,
		0.023361,
		-0.779966,
		1,
	},
	[0.466666666667] = {
		0.964293,
		-0.0835,
		0.25133,
		0,
		0.197139,
		-0.407388,
		-0.891724,
		0,
		0.176847,
		0.90943,
		-0.37638,
		0,
		0.213217,
		-0.103433,
		-0.725716,
		1,
	},
	[0.4] = {
		0.83699,
		-0.182139,
		0.516017,
		0,
		0.32503,
		-0.593145,
		-0.736569,
		0,
		0.440231,
		0.784222,
		-0.437256,
		0,
		0.422095,
		0.180596,
		-0.774255,
		1,
	},
	[0.533333333333] = {
		0.995209,
		0.089959,
		-0.038289,
		0,
		-0.032805,
		-0.061677,
		-0.997557,
		0,
		-0.0921,
		0.994034,
		-0.05843,
		0,
		0.055725,
		-0.205746,
		-0.569627,
		1,
	},
	[0.566666666667] = {
		0.972401,
		0.171601,
		-0.158077,
		0,
		-0.163962,
		0.02059,
		-0.986252,
		0,
		-0.165987,
		0.984951,
		0.048158,
		0,
		0.025302,
		-0.229041,
		-0.534286,
		1,
	},
	[0.5] = {
		0.995128,
		-0.007264,
		0.098321,
		0,
		0.093999,
		-0.230829,
		-0.968443,
		0,
		0.02973,
		0.972967,
		-0.229022,
		0,
		0.11875,
		-0.17081,
		-0.64003,
		1,
	},
	[0.633333333333] = {
		0.975886,
		0.18462,
		-0.116459,
		0,
		-0.126957,
		0.046058,
		-0.990838,
		0,
		-0.177565,
		0.98173,
		0.068386,
		0,
		0.024794,
		-0.26467,
		-0.526247,
		1,
	},
	[0.666666666667] = {
		0.976858,
		0.1917,
		-0.094867,
		0,
		-0.108437,
		0.061557,
		-0.992196,
		0,
		-0.184365,
		0.979521,
		0.08092,
		0,
		0.023612,
		-0.279832,
		-0.522435,
		1,
	},
	[0.6] = {
		0.974414,
		0.177631,
		-0.137712,
		0,
		-0.145571,
		0.031936,
		-0.988832,
		0,
		-0.171249,
		0.983579,
		0.056977,
		0,
		0.025619,
		-0.247522,
		-0.530287,
		1,
	},
	[0.733333333333] = {
		0.977467,
		0.203209,
		-0.057126,
		0,
		-0.076931,
		0.090934,
		-0.992881,
		0,
		-0.196568,
		0.974904,
		0.104518,
		0,
		0.021301,
		-0.301563,
		-0.51677,
		1,
	},
	[0.766666666667] = {
		0.977434,
		0.206451,
		-0.044739,
		0,
		-0.066979,
		0.102024,
		-0.992525,
		0,
		-0.200343,
		0.973123,
		0.113549,
		0,
		0.020553,
		-0.306735,
		-0.515621,
		1,
	},
	[0.7] = {
		0.977347,
		0.198111,
		-0.074467,
		0,
		-0.091254,
		0.076989,
		-0.992847,
		0,
		-0.190961,
		0.977151,
		0.093324,
		0,
		0.022387,
		-0.292356,
		-0.519161,
		1,
	},
	[0.833333333333] = {
		0.977503,
		0.207429,
		-0.038215,
		0,
		-0.062517,
		0.111896,
		-0.991752,
		0,
		-0.201442,
		0.97183,
		0.122346,
		0,
		0.020521,
		-0.305587,
		-0.516964,
		1,
	},
	[0.866666666667] = {
		0.977261,
		0.208742,
		-0.037249,
		0,
		-0.062305,
		0.114773,
		-0.991436,
		0,
		-0.202679,
		0.971213,
		0.125169,
		0,
		0.021078,
		-0.30402,
		-0.517865,
		1,
	},
	[0.8] = {
		0.977478,
		0.207331,
		-0.039371,
		0,
		-0.062932,
		0.108298,
		-0.992124,
		0,
		-0.201434,
		0.972258,
		0.118907,
		0,
		0.02032,
		-0.307457,
		-0.515862,
		1,
	},
	[0.933333333333] = {
		0.976318,
		0.213247,
		-0.036454,
		0,
		-0.062388,
		0.116177,
		-0.991267,
		0,
		-0.20715,
		0.970066,
		0.12673,
		0,
		0.02269,
		-0.303038,
		-0.518372,
		1,
	},
	[0.966666666667] = {
		0.976315,
		0.213262,
		-0.036434,
		0,
		-0.062373,
		0.116194,
		-0.991266,
		0,
		-0.207166,
		0.970061,
		0.126743,
		0,
		0.022703,
		-0.303029,
		-0.518377,
		1,
	},
	[0.9] = {
		0.97653,
		0.212238,
		-0.036676,
		0,
		-0.062415,
		0.115875,
		-0.991301,
		0,
		-0.206142,
		0.970324,
		0.126402,
		0,
		0.022305,
		-0.303253,
		-0.518263,
		1,
	},
}

return spline_matrices
