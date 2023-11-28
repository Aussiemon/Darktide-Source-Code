﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_axe/attack_left.lua

local spline_matrices = {
	[0.0333333333333] = {
		0.559722,
		-0.37539,
		-0.738779,
		0,
		-0.353467,
		0.698194,
		-0.622564,
		0,
		0.749515,
		0.609596,
		0.258107,
		0,
		0.29303,
		-0.223034,
		-0.227697,
		1
	},
	[0.0666666666667] = {
		0.161186,
		-0.161469,
		-0.973626,
		0,
		0.623717,
		0.781207,
		-0.0263,
		0,
		0.76485,
		-0.603028,
		0.226631,
		0,
		0.641651,
		0.00479,
		-0.086299,
		1
	},
	[0] = {
		0.645723,
		0.110459,
		-0.75554,
		0,
		-0.758509,
		-0.02096,
		-0.651325,
		0,
		-0.087781,
		0.99366,
		0.07025,
		0,
		0.040336,
		-0.400153,
		-0.319481,
		1
	},
	[0.133333333333] = {
		0.207772,
		0.183663,
		-0.96078,
		0,
		0.695848,
		0.662564,
		0.277135,
		0,
		0.687478,
		-0.726138,
		0.009861,
		0,
		0.615762,
		0.248771,
		-0.134415,
		1
	},
	[0.166666666667] = {
		0.182121,
		0.179013,
		-0.966843,
		0,
		0.480303,
		0.841801,
		0.246334,
		0,
		0.857987,
		-0.50924,
		0.06733,
		0,
		0.552464,
		0.343471,
		-0.142613,
		1
	},
	[0.1] = {
		0.186318,
		0.134131,
		-0.973291,
		0,
		0.775347,
		0.588356,
		0.229508,
		0,
		0.603425,
		-0.7974,
		0.005623,
		0,
		0.66748,
		0.16754,
		-0.116209,
		1
	},
	[0.233333333333] = {
		0.191407,
		0.12419,
		-0.973622,
		0,
		0.044745,
		0.989828,
		0.135053,
		0,
		0.98049,
		-0.069415,
		0.183903,
		0,
		0.41598,
		0.500547,
		-0.143475,
		1
	},
	[0.266666666667] = {
		0.233456,
		0.115626,
		-0.965468,
		0,
		-0.043803,
		0.993147,
		0.108349,
		0,
		0.97138,
		0.016995,
		0.236921,
		0,
		0.346242,
		0.551454,
		-0.143426,
		1
	},
	[0.2] = {
		0.160091,
		0.144357,
		-0.97649,
		0,
		0.197546,
		0.964551,
		0.174979,
		0,
		0.967133,
		-0.220914,
		0.125898,
		0,
		0.480998,
		0.433079,
		-0.143799,
		1
	},
	[0.333333333333] = {
		0.097854,
		0.239552,
		-0.96594,
		0,
		-0.872143,
		0.488156,
		0.03271,
		0,
		0.479365,
		0.839237,
		0.256692,
		0,
		-0.083256,
		0.697698,
		-0.135417,
		1
	},
	[0.366666666667] = {
		0.085381,
		0.224926,
		-0.970628,
		0,
		-0.99226,
		-0.068964,
		-0.103265,
		0,
		-0.090165,
		0.971932,
		0.217297,
		0,
		-0.32205,
		0.543698,
		-0.150325,
		1
	},
	[0.3] = {
		0.239899,
		0.179858,
		-0.953991,
		0,
		-0.376469,
		0.923025,
		0.079349,
		0,
		0.894829,
		0.340112,
		0.289144,
		0,
		0.201076,
		0.623442,
		-0.142875,
		1
	},
	[0.433333333333] = {
		-0.10353,
		0.406557,
		-0.907741,
		0,
		-0.318039,
		-0.878262,
		-0.357081,
		0,
		-0.942408,
		0.251728,
		0.220227,
		0,
		-0.412695,
		0.183398,
		-0.173248,
		1
	},
	[0.466666666667] = {
		-0.141659,
		0.414897,
		-0.898773,
		0,
		-0.216399,
		-0.898949,
		-0.380871,
		0,
		-0.965973,
		0.140539,
		0.217128,
		0,
		-0.397434,
		0.133046,
		-0.196686,
		1
	},
	[0.4] = {
		0.070105,
		0.203433,
		-0.976576,
		0,
		-0.764919,
		-0.617427,
		-0.183529,
		0,
		-0.6403,
		0.759868,
		0.112324,
		0,
		-0.434991,
		0.354836,
		-0.160426,
		1
	},
	[0.533333333333] = {
		-0.106635,
		0.366062,
		-0.924461,
		0,
		-0.214955,
		-0.916262,
		-0.338021,
		0,
		-0.970785,
		0.162672,
		0.176393,
		0,
		-0.299796,
		0.023676,
		-0.298957,
		1
	},
	[0.566666666667] = {
		-0.025779,
		0.316297,
		-0.94831,
		0,
		-0.304194,
		-0.906121,
		-0.293957,
		0,
		-0.952261,
		0.280892,
		0.119575,
		0,
		-0.231781,
		-0.023605,
		-0.363209,
		1
	},
	[0.5] = {
		-0.145848,
		0.398215,
		-0.905623,
		0,
		-0.182163,
		-0.910569,
		-0.371053,
		0,
		-0.972391,
		0.110854,
		0.205345,
		0,
		-0.35763,
		0.077132,
		-0.24107,
		1
	},
	[0.633333333333] = {
		0.19487,
		0.200108,
		-0.960199,
		0,
		-0.751151,
		-0.599068,
		-0.277291,
		0,
		-0.630712,
		0.77529,
		0.033571,
		0,
		0.028775,
		-0.272186,
		-0.444213,
		1
	},
	[0.666666666667] = {
		0.316979,
		0.141439,
		-0.937827,
		0,
		-0.88832,
		-0.302158,
		-0.345816,
		0,
		-0.332284,
		0.942707,
		0.029865,
		0,
		0.169704,
		-0.370898,
		-0.435566,
		1
	},
	[0.6] = {
		0.078791,
		0.256093,
		-0.963436,
		0,
		-0.501923,
		-0.824816,
		-0.260294,
		0,
		-0.861316,
		0.504079,
		0.063551,
		0,
		-0.123464,
		-0.119867,
		-0.414255,
		1
	},
	[0.733333333333] = {
		0.428504,
		0.09361,
		-0.898678,
		0,
		-0.90223,
		-0.009202,
		-0.431156,
		0,
		-0.04863,
		0.995566,
		0.080515,
		0,
		0.229218,
		-0.360982,
		-0.410281,
		1
	},
	[0.766666666667] = {
		0.43257,
		0.105634,
		-0.895391,
		0,
		-0.901591,
		0.055146,
		-0.429059,
		0,
		0.004054,
		0.992875,
		0.119094,
		0,
		0.233122,
		-0.356148,
		-0.408251,
		1
	},
	[0.7] = {
		0.423306,
		0.075095,
		-0.902869,
		0,
		-0.895981,
		-0.113003,
		-0.429475,
		0,
		-0.134278,
		0.990753,
		0.019449,
		0,
		0.224619,
		-0.36842,
		-0.413025,
		1
	},
	[0.833333333333] = {
		0.435761,
		0.115665,
		-0.892599,
		0,
		-0.899367,
		0.094917,
		-0.426766,
		0,
		0.035361,
		0.988743,
		0.145387,
		0,
		0.238032,
		-0.351857,
		-0.406451,
		1
	},
	[0.866666666667] = {
		0.435274,
		0.115188,
		-0.892899,
		0,
		-0.899953,
		0.083127,
		-0.427989,
		0,
		0.024925,
		0.989859,
		0.139847,
		0,
		0.238871,
		-0.35185,
		-0.406481,
		1
	},
	[0.8] = {
		0.434953,
		0.112747,
		-0.893367,
		0,
		-0.899956,
		0.08741,
		-0.427129,
		0,
		0.029932,
		0.989771,
		0.139487,
		0,
		0.23616,
		-0.35319,
		-0.406998,
		1
	},
	[0.933333333333] = {
		0.431903,
		0.106405,
		-0.895621,
		0,
		-0.901485,
		0.020085,
		-0.432344,
		0,
		-0.028015,
		0.99412,
		0.104597,
		0,
		0.238385,
		-0.354998,
		-0.407465,
		1
	},
	[0.966666666667] = {
		0.429778,
		0.099355,
		-0.897452,
		0,
		-0.900749,
		-0.021934,
		-0.433785,
		0,
		-0.062784,
		0.99481,
		0.080067,
		0,
		0.237533,
		-0.35771,
		-0.408039,
		1
	},
	[0.9] = {
		0.433857,
		0.111968,
		-0.893998,
		0,
		-0.900978,
		0.056708,
		-0.430142,
		0,
		0.002535,
		0.992092,
		0.125484,
		0,
		0.238909,
		-0.352936,
		-0.40691,
		1
	},
	[1.03333333333] = {
		0.426159,
		0.084983,
		-0.900648,
		0,
		-0.895544,
		-0.101263,
		-0.433298,
		0,
		-0.128025,
		0.991223,
		0.032952,
		0,
		0.235673,
		-0.363404,
		-0.408969,
		1
	},
	[1.06666666667] = {
		0.425128,
		0.079989,
		-0.901592,
		0,
		-0.892684,
		-0.127582,
		-0.432247,
		0,
		-0.149602,
		0.988597,
		0.017166,
		0,
		0.235054,
		-0.36542,
		-0.40922,
		1
	},
	{
		0.427773,
		0.091839,
		-0.899209,
		0,
		-0.898603,
		-0.064194,
		-0.434041,
		0,
		-0.097586,
		0.993703,
		0.055066,
		0,
		0.236559,
		-0.360666,
		-0.408561,
		1
	},
	[1.1] = {
		0.42476,
		0.078078,
		-0.901933,
		0,
		-0.891443,
		-0.137613,
		-0.431732,
		0,
		-0.157826,
		0.987404,
		0.011149,
		0,
		0.234835,
		-0.366193,
		-0.409306,
		1
	}
}

return spline_matrices
