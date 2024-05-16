﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_sword/heavy_attack_right.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.571816,
		-0.005459,
		0.820364,
		0,
		-0.818833,
		0.05762,
		0.571132,
		0,
		-0.050388,
		-0.998324,
		0.028478,
		0,
		-0.31883,
		0.032785,
		0.075192,
		1,
	},
	[0.0333333333333] = {
		0.58278,
		-0.007467,
		0.812595,
		0,
		-0.810636,
		0.064659,
		0.581969,
		0,
		-0.056887,
		-0.997879,
		0.031629,
		0,
		-0.325795,
		0.023086,
		0.079786,
		1,
	},
	[0.05] = {
		0.597409,
		-0.011822,
		0.801849,
		0,
		-0.798905,
		0.078079,
		0.596367,
		0,
		-0.069658,
		-0.996877,
		0.037201,
		0,
		-0.335059,
		0.011645,
		0.085277,
		1,
	},
	[0.0666666666667] = {
		0.612671,
		-0.019533,
		0.790097,
		0,
		-0.785157,
		0.099233,
		0.611294,
		0,
		-0.090344,
		-0.994872,
		0.045461,
		0,
		-0.344671,
		0.002309,
		0.089882,
		1,
	},
	[0.0833333333333] = {
		0.625476,
		-0.031572,
		0.779604,
		0,
		-0.770866,
		0.129438,
		0.623707,
		0,
		-0.120602,
		-0.991085,
		0.056623,
		0,
		-0.352621,
		-0.001111,
		0.091802,
		1,
	},
	[0] = {
		0.567509,
		-0.004943,
		0.823352,
		0,
		-0.821933,
		0.055584,
		0.566865,
		0,
		-0.048567,
		-0.998442,
		0.027482,
		0,
		-0.316082,
		0.036876,
		0.073267,
		1,
	},
	[0.116666666667] = {
		0.632958,
		-0.065813,
		0.771384,
		0,
		-0.753848,
		0.174487,
		0.633457,
		0,
		-0.176286,
		-0.982458,
		0.06083,
		0,
		-0.367986,
		0.01726,
		0.088861,
		1,
	},
	[0.133333333333] = {
		0.620649,
		-0.1059,
		0.776904,
		0,
		-0.754254,
		0.190085,
		0.628465,
		0,
		-0.214233,
		-0.976039,
		0.038101,
		0,
		-0.378704,
		0.045063,
		0.075167,
		1,
	},
	[0.15] = {
		0.588191,
		-0.174167,
		0.789745,
		0,
		-0.759769,
		0.21559,
		0.613411,
		0,
		-0.277097,
		-0.960826,
		-0.005519,
		0,
		-0.391545,
		0.089715,
		0.047356,
		1,
	},
	[0.166666666667] = {
		0.525578,
		-0.250964,
		0.812887,
		0,
		-0.760561,
		0.289534,
		0.581135,
		0,
		-0.381202,
		-0.923681,
		-0.038701,
		0,
		-0.401988,
		0.147765,
		0.015113,
		1,
	},
	[0.183333333333] = {
		0.441671,
		-0.304034,
		0.844092,
		0,
		-0.723149,
		0.436217,
		0.535509,
		0,
		-0.53102,
		-0.846923,
		-0.027197,
		0,
		-0.386238,
		0.225576,
		-0.017776,
		1,
	},
	[0.1] = {
		0.633107,
		-0.0472,
		0.772624,
		0,
		-0.759462,
		0.155082,
		0.631796,
		0,
		-0.149641,
		-0.986773,
		0.062337,
		0,
		-0.359899,
		0.003713,
		0.091262,
		1,
	},
	[0.216666666667] = {
		0.269052,
		-0.157444,
		0.95017,
		0,
		-0.446772,
		0.85358,
		0.267948,
		0,
		-0.853233,
		-0.496601,
		0.159316,
		0,
		-0.245667,
		0.401418,
		-0.057665,
		1,
	},
	[0.233333333333] = {
		0.243346,
		0.037035,
		0.969232,
		0,
		-0.171505,
		0.985168,
		0.005416,
		0,
		-0.954656,
		-0.167547,
		0.246089,
		0,
		-0.149518,
		0.46736,
		-0.061121,
		1,
	},
	[0.25] = {
		0.281896,
		0.002128,
		0.959443,
		0,
		0.331776,
		0.93809,
		-0.09956,
		0,
		-0.900255,
		0.346385,
		0.263738,
		0,
		-0.06403,
		0.505506,
		-0.06259,
		1,
	},
	[0.266666666667] = {
		0.200608,
		-0.0753,
		0.976773,
		0,
		0.797916,
		0.591043,
		-0.118311,
		0,
		-0.568406,
		0.803118,
		0.178652,
		0,
		0.03495,
		0.51496,
		-0.07169,
		1,
	},
	[0.283333333333] = {
		0.197115,
		-0.049212,
		0.979144,
		0,
		0.963149,
		0.196148,
		-0.184037,
		0,
		-0.183,
		0.979339,
		0.086062,
		0,
		0.17268,
		0.502686,
		-0.084412,
		1,
	},
	[0.2] = {
		0.358408,
		-0.295153,
		0.88568,
		0,
		-0.6184,
		0.63566,
		0.462081,
		0,
		-0.699375,
		-0.713317,
		0.045303,
		0,
		-0.330416,
		0.317538,
		-0.045898,
		1,
	},
	[0.316666666667] = {
		0.100717,
		-0.086991,
		0.991105,
		0,
		0.947721,
		-0.294784,
		-0.122182,
		0,
		0.30279,
		0.951596,
		0.052753,
		0,
		0.387217,
		0.49491,
		-0.129253,
		1,
	},
	[0.333333333333] = {
		0.114426,
		-0.052314,
		0.992053,
		0,
		0.881656,
		-0.454849,
		-0.125677,
		0,
		0.457809,
		0.889031,
		-0.005924,
		0,
		0.431887,
		0.417005,
		-0.130574,
		1,
	},
	[0.35] = {
		0.105302,
		0.024198,
		0.994146,
		0,
		0.740196,
		-0.669517,
		-0.062107,
		0,
		0.664095,
		0.742402,
		-0.088413,
		0,
		0.540827,
		0.32169,
		-0.177517,
		1,
	},
	[0.366666666667] = {
		0.092231,
		0.051725,
		0.994393,
		0,
		0.598377,
		-0.801095,
		-0.01383,
		0,
		0.795888,
		0.596298,
		-0.104837,
		0,
		0.617329,
		0.240589,
		-0.198924,
		1,
	},
	[0.383333333333] = {
		0.101649,
		0.040579,
		0.993992,
		0,
		0.512265,
		-0.858652,
		-0.017332,
		0,
		0.852791,
		0.51095,
		-0.108069,
		0,
		0.645231,
		0.171633,
		-0.201442,
		1,
	},
	[0.3] = {
		0.131202,
		-0.067639,
		0.989046,
		0,
		0.990138,
		-0.040486,
		-0.134115,
		0,
		0.049114,
		0.996888,
		0.06166,
		0,
		0.290282,
		0.518162,
		-0.103301,
		1,
	},
	[0.416666666667] = {
		0.247053,
		0.041342,
		0.96812,
		0,
		0.52878,
		-0.842973,
		-0.098941,
		0,
		0.812008,
		0.536366,
		-0.23012,
		0,
		0.582789,
		0.014222,
		-0.208864,
		1,
	},
	[0.433333333333] = {
		0.354077,
		0.045175,
		0.934125,
		0,
		0.563658,
		-0.807342,
		-0.174609,
		0,
		0.74627,
		0.588352,
		-0.311325,
		0,
		0.521451,
		-0.069938,
		-0.214495,
		1,
	},
	[0.45] = {
		0.468718,
		0.050697,
		0.881892,
		0,
		0.588599,
		-0.762355,
		-0.26901,
		0,
		0.658677,
		0.64517,
		-0.387169,
		0,
		0.451362,
		-0.154272,
		-0.221623,
		1,
	},
	[0.466666666667] = {
		0.58162,
		0.059129,
		0.811309,
		0,
		0.596563,
		-0.709042,
		-0.375995,
		0,
		0.55302,
		0.702683,
		-0.447667,
		0,
		0.376655,
		-0.236036,
		-0.230038,
		1,
	},
	[0.483333333333] = {
		0.684299,
		0.071296,
		0.725707,
		0,
		0.584126,
		-0.649325,
		-0.487005,
		0,
		0.436498,
		0.757162,
		-0.485979,
		0,
		0.301459,
		-0.312535,
		-0.23966,
		1,
	},
	[0.4] = {
		0.156399,
		0.037782,
		0.986971,
		0,
		0.492978,
		-0.868885,
		-0.044857,
		0,
		0.855869,
		0.493571,
		-0.154518,
		0,
		0.63132,
		0.095466,
		-0.204923,
		1,
	},
	[0.516666666667] = {
		0.836537,
		0.107708,
		0.53722,
		0,
		0.507258,
		-0.522876,
		-0.685048,
		0,
		0.207114,
		0.845577,
		-0.49204,
		0,
		0.165933,
		-0.439194,
		-0.262228,
		1,
	},
	[0.533333333333] = {
		0.88217,
		0.131071,
		0.452324,
		0,
		0.457821,
		-0.46375,
		-0.758509,
		0,
		0.110347,
		0.876217,
		-0.469113,
		0,
		0.113835,
		-0.484077,
		-0.274888,
		1,
	},
	[0.55] = {
		0.909244,
		0.156589,
		0.385688,
		0,
		0.415005,
		-0.413007,
		-0.810676,
		0,
		0.032349,
		0.897165,
		-0.44051,
		0,
		0.077708,
		-0.513182,
		-0.288222,
		1,
	},
	[0.566666666667] = {
		0.920696,
		0.182944,
		0.344746,
		0,
		0.389504,
		-0.375046,
		-0.841206,
		0,
		-0.024597,
		0.908775,
		-0.416561,
		0,
		0.061725,
		-0.523944,
		-0.30202,
		1,
	},
	[0.583333333333] = {
		0.924842,
		0.208909,
		0.317842,
		0,
		0.373797,
		-0.344757,
		-0.861057,
		0,
		-0.070304,
		0.91515,
		-0.396935,
		0,
		0.057153,
		-0.524703,
		-0.316045,
		1,
	},
	[0.5] = {
		0.770431,
		0.08755,
		0.631484,
		0,
		0.552433,
		-0.586077,
		-0.592732,
		0,
		0.318204,
		0.805512,
		-0.499897,
		0,
		0.22985,
		-0.381134,
		-0.250433,
		1,
	},
	[0.616666666667] = {
		0.930562,
		0.257583,
		0.260203,
		0,
		0.330506,
		-0.285164,
		-0.899693,
		0,
		-0.157545,
		0.923219,
		-0.350495,
		0,
		0.047737,
		-0.526239,
		-0.343701,
		1,
	},
	[0.633333333333] = {
		0.932066,
		0.279429,
		0.230591,
		0,
		0.304044,
		-0.257214,
		-0.917278,
		0,
		-0.197002,
		0.925073,
		-0.324699,
		0,
		0.043048,
		-0.526976,
		-0.356795,
		1,
	},
	[0.65] = {
		0.932687,
		0.299105,
		0.201572,
		0,
		0.275826,
		-0.231366,
		-0.932947,
		0,
		-0.232412,
		0.925746,
		-0.298293,
		0,
		0.038608,
		-0.527662,
		-0.369029,
		1,
	},
	[0.666666666667] = {
		0.932618,
		0.316281,
		0.173752,
		0,
		0.246935,
		-0.208228,
		-0.946395,
		0,
		-0.263147,
		0.925531,
		-0.272298,
		0,
		0.034512,
		-0.528275,
		-0.380141,
		1,
	},
	[0.683333333333] = {
		0.932119,
		0.330653,
		0.147728,
		0,
		0.218567,
		-0.188372,
		-0.957468,
		0,
		-0.288762,
		0.924762,
		-0.247855,
		0,
		0.030859,
		-0.528788,
		-0.389869,
		1,
	},
	[0.6] = {
		0.928139,
		0.233939,
		0.289534,
		0,
		0.354036,
		-0.314569,
		-0.880741,
		0,
		-0.114961,
		0.919956,
		-0.374786,
		0,
		0.052484,
		-0.525474,
		-0.330025,
		1,
	},
	[0.716666666667] = {
		0.931083,
		0.34986,
		0.103359,
		0,
		0.168335,
		-0.160671,
		-0.972547,
		0,
		-0.323648,
		0.922921,
		-0.208492,
		0,
		0.025274,
		-0.529424,
		-0.404125,
		1,
	},
	[0.733333333333] = {
		0.931221,
		0.354135,
		0.086117,
		0,
		0.148832,
		-0.153825,
		-0.976825,
		0,
		-0.332681,
		0.922457,
		-0.195951,
		0,
		0.023542,
		-0.529482,
		-0.408161,
		1,
	},
	[0.75] = {
		0.932226,
		0.354465,
		0.072861,
		0,
		0.134452,
		-0.152338,
		-0.97914,
		0,
		-0.335972,
		0.922576,
		-0.189672,
		0,
		0.022651,
		-0.529333,
		-0.409801,
		1,
	},
	[0.766666666667] = {
		0.934026,
		0.351631,
		0.062864,
		0,
		0.123778,
		-0.153521,
		-0.980362,
		0,
		-0.335075,
		0.923465,
		-0.186916,
		0,
		0.022267,
		-0.52901,
		-0.410239,
		1,
	},
	[0.783333333333] = {
		0.936281,
		0.346928,
		0.054951,
		0,
		0.11476,
		-0.154274,
		-0.981341,
		0,
		-0.331977,
		0.925116,
		-0.184257,
		0,
		0.022005,
		-0.528545,
		-0.410852,
		1,
	},
	[0.7] = {
		0.931495,
		0.341938,
		0.124079,
		0,
		0.19196,
		-0.172345,
		-0.966151,
		0,
		-0.308979,
		0.923783,
		-0.226177,
		0,
		0.027746,
		-0.529178,
		-0.397951,
		1,
	},
	[0.816666666667] = {
		0.941624,
		0.333725,
		0.044414,
		0,
		0.101146,
		-0.154595,
		-0.982787,
		0,
		-0.321114,
		0.929908,
		-0.179325,
		0,
		0.021874,
		-0.527254,
		-0.412515,
		1,
	},
	[0.833333333333] = {
		0.944425,
		0.32612,
		0.041325,
		0,
		0.096278,
		-0.15421,
		-0.983336,
		0,
		-0.314313,
		0.932665,
		-0.177038,
		0,
		0.022021,
		-0.52646,
		-0.41352,
		1,
	},
	[0.85] = {
		0.947122,
		0.318458,
		0.039291,
		0,
		0.092535,
		-0.153832,
		-0.983755,
		0,
		-0.30724,
		0.935372,
		-0.175166,
		0,
		0.02233,
		-0.525733,
		-0.414428,
		1,
	},
	[0.866666666667] = {
		0.949584,
		0.311197,
		0.038027,
		0,
		0.089791,
		-0.153745,
		-0.984022,
		0,
		-0.300379,
		0.937827,
		-0.173937,
		0,
		0.022814,
		-0.525198,
		-0.415078,
		1,
	},
	[0.883333333333] = {
		0.951557,
		0.305193,
		0.03738,
		0,
		0.087995,
		-0.153818,
		-0.984173,
		0,
		-0.294613,
		0.939786,
		-0.173222,
		0,
		0.023713,
		-0.524816,
		-0.415511,
		1,
	},
	[0.8] = {
		0.938861,
		0.34081,
		0.048883,
		0,
		0.107265,
		-0.154624,
		-0.982133,
		0,
		-0.327162,
		0.92733,
		-0.181728,
		0,
		0.021873,
		-0.527954,
		-0.411618,
		1,
	},
	[0.916666666667] = {
		0.954417,
		0.296142,
		0.037248,
		0,
		0.086279,
		-0.154266,
		-0.984255,
		0,
		-0.285733,
		0.942604,
		-0.172785,
		0,
		0.025343,
		-0.524426,
		-0.415907,
		1,
	},
	[0.933333333333] = {
		0.955466,
		0.292722,
		0.037407,
		0,
		0.08588,
		-0.154544,
		-0.984246,
		0,
		-0.28233,
		0.943626,
		-0.1728,
		0,
		0.025386,
		-0.524381,
		-0.415961,
		1,
	},
	[0.95] = {
		0.955839,
		0.291487,
		0.037498,
		0,
		0.085776,
		-0.154657,
		-0.984238,
		0,
		-0.281094,
		0.943989,
		-0.17283,
		0,
		0.0254,
		-0.524374,
		-0.41597,
		1,
	},
	[0.9] = {
		0.953072,
		0.300451,
		0.037182,
		0,
		0.086943,
		-0.15399,
		-0.98424,
		0,
		-0.28999,
		0.941284,
		-0.172886,
		0,
		0.02479,
		-0.52456,
		-0.415771,
		1,
	},
}

return spline_matrices
