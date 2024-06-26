﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/2h_axe/attack_stab.lua

local spline_matrices = {
	[0.0333333333333] = {
		-0.403055,
		0.156041,
		-0.901775,
		0,
		0.908504,
		-0.050538,
		-0.414808,
		0,
		-0.110301,
		-0.986457,
		-0.121394,
		0,
		0.216832,
		-0.070899,
		-0.48137,
		1,
	},
	[0.0666666666667] = {
		-0.370687,
		0.085556,
		-0.924809,
		0,
		0.927224,
		-0.023117,
		-0.373794,
		0,
		-0.053359,
		-0.996065,
		-0.070761,
		0,
		0.195991,
		0.051214,
		-0.405681,
		1,
	},
	[0] = {
		-0.416664,
		0.187841,
		-0.889442,
		0,
		0.898864,
		-0.061005,
		-0.433962,
		0,
		-0.135776,
		-0.980303,
		-0.143425,
		0,
		0.225805,
		-0.115826,
		-0.5126,
		1,
	},
	[0.133333333333] = {
		-0.318634,
		-0.017641,
		-0.947714,
		0,
		0.946155,
		0.05434,
		-0.319122,
		0,
		0.057128,
		-0.998367,
		-0.000624,
		0,
		0.155164,
		0.45098,
		-0.228945,
		1,
	},
	[0.166666666667] = {
		-0.319558,
		0.002479,
		-0.947563,
		0,
		0.940657,
		0.12137,
		-0.316912,
		0,
		0.11422,
		-0.992604,
		-0.041116,
		0,
		0.151357,
		0.801911,
		-0.157026,
		1,
	},
	[0.1] = {
		-0.335444,
		0.01464,
		-0.941946,
		0,
		0.94202,
		0.014435,
		-0.335246,
		0,
		0.008689,
		-0.999789,
		-0.018633,
		0,
		0.172397,
		0.231508,
		-0.312539,
		1,
	},
	[0.233333333333] = {
		-0.35128,
		0.017455,
		-0.936108,
		0,
		0.925514,
		0.157593,
		-0.344366,
		0,
		0.141514,
		-0.98735,
		-0.071514,
		0,
		0.123765,
		1.915283,
		-0.070995,
		1,
	},
	[0.266666666667] = {
		-0.413002,
		-0.010971,
		-0.910664,
		0,
		0.899529,
		0.15143,
		-0.409776,
		0,
		0.142398,
		-0.988407,
		-0.052673,
		0,
		0.1058,
		1.822298,
		-0.066188,
		1,
	},
	[0.2] = {
		-0.325597,
		0.022597,
		-0.945239,
		0,
		0.93315,
		0.168792,
		-0.317397,
		0,
		0.152377,
		-0.985393,
		-0.076044,
		0,
		0.147822,
		1.28053,
		-0.09369,
		1,
	},
	[0.333333333333] = {
		-0.476153,
		-0.031679,
		-0.878792,
		0,
		0.869578,
		0.1317,
		-0.475908,
		0,
		0.130813,
		-0.990783,
		-0.035162,
		0,
		0.150543,
		1.65996,
		-0.071849,
		1,
	},
	[0.366666666667] = {
		-0.487411,
		-0.031679,
		-0.872598,
		0,
		0.864928,
		0.11949,
		-0.487465,
		0,
		0.119709,
		-0.99233,
		-0.030841,
		0,
		0.168783,
		1.628797,
		-0.089589,
		1,
	},
	[0.3] = {
		-0.460242,
		-0.031679,
		-0.887228,
		0,
		0.876377,
		0.143539,
		-0.459738,
		0,
		0.141915,
		-0.989138,
		-0.0383,
		0,
		0.138362,
		1.703442,
		-0.065501,
		1,
	},
	[0.433333333333] = {
		-0.499226,
		-0.031679,
		-0.865893,
		0,
		0.861071,
		0.093268,
		-0.499858,
		0,
		0.096595,
		-0.995137,
		-0.019284,
		0,
		0.256891,
		1.578231,
		-0.151435,
		1,
	},
	[0.466666666667] = {
		-0.501317,
		-0.031679,
		-0.864683,
		0,
		0.861163,
		0.078912,
		-0.502167,
		0,
		0.084142,
		-0.996378,
		-0.01228,
		0,
		0.30281,
		1.546225,
		-0.191633,
		1,
	},
	[0.4] = {
		-0.494842,
		-0.031679,
		-0.868405,
		0,
		0.862198,
		0.106736,
		-0.495198,
		0,
		0.108377,
		-0.993783,
		-0.025504,
		0,
		0.208983,
		1.603655,
		-0.116769,
		1,
	},
	[0.533333333333] = {
		-0.499986,
		-0.044176,
		-0.864906,
		0,
		0.863811,
		0.046064,
		-0.501705,
		0,
		0.062004,
		-0.997961,
		0.015129,
		0,
		0.359197,
		1.427034,
		-0.288942,
		1,
	},
	[0.566666666667] = {
		-0.494491,
		-0.076042,
		-0.86585,
		0,
		0.867072,
		0.026229,
		-0.497492,
		0,
		0.06054,
		-0.99676,
		0.052964,
		0,
		0.375639,
		1.327122,
		-0.35507,
		1,
	},
	[0.5] = {
		-0.501852,
		-0.031679,
		-0.864373,
		0,
		0.86205,
		0.063497,
		-0.50283,
		0,
		0.070814,
		-0.997479,
		-0.004558,
		0,
		0.337044,
		1.501336,
		-0.235412,
		1,
	},
	[0.633333333333] = {
		-0.473614,
		-0.163898,
		-0.865348,
		0,
		0.878473,
		-0.017575,
		-0.477469,
		0,
		0.063048,
		-0.986321,
		0.152303,
		0,
		0.393199,
		1.147259,
		-0.497337,
		1,
	},
	[0.666666666667] = {
		-0.460061,
		-0.203031,
		-0.864363,
		0,
		0.885905,
		-0.039953,
		-0.462142,
		0,
		0.059296,
		-0.978357,
		0.198247,
		0,
		0.395224,
		1.115702,
		-0.559586,
		1,
	},
	[0.6] = {
		-0.485508,
		-0.118782,
		-0.866125,
		0,
		0.872013,
		0.004742,
		-0.489459,
		0,
		0.062246,
		-0.992909,
		0.101277,
		0,
		0.386821,
		1.225798,
		-0.42685,
		1,
	},
	[0.733333333333] = {
		-0.42916,
		-0.281335,
		-0.858296,
		0,
		0.901894,
		-0.081851,
		-0.424131,
		0,
		0.049071,
		-0.956112,
		0.288862,
		0,
		0.395224,
		1.115702,
		-0.685099,
		1,
	},
	[0.766666666667] = {
		-0.412393,
		-0.324212,
		-0.851363,
		0,
		0.909863,
		-0.099783,
		-0.402731,
		0,
		0.045618,
		-0.940707,
		0.336138,
		0,
		0.395224,
		1.115702,
		-0.752005,
		1,
	},
	[0.7] = {
		-0.445317,
		-0.239865,
		-0.862646,
		0,
		0.893781,
		-0.061663,
		-0.444244,
		0,
		0.053365,
		-0.968846,
		0.241846,
		0,
		0.395224,
		1.115702,
		-0.619568,
		1,
	},
	[0.833333333333] = {
		-0.381119,
		-0.401968,
		-0.832568,
		0,
		0.923669,
		-0.1268,
		-0.361603,
		0,
		0.039783,
		-0.906831,
		0.419612,
		0,
		0.395224,
		1.115702,
		-0.873238,
		1,
	},
	[0.866666666667] = {
		-0.368967,
		-0.431233,
		-0.823348,
		0,
		0.928688,
		-0.135352,
		-0.345281,
		0,
		0.037455,
		-0.89203,
		0.450421,
		0,
		0.395224,
		1.115702,
		-0.919213,
		1,
	},
	[0.8] = {
		-0.396002,
		-0.365393,
		-0.842419,
		0,
		0.917263,
		-0.114888,
		-0.381352,
		0,
		0.042559,
		-0.923736,
		0.380658,
		0,
		0.395224,
		1.115702,
		-0.81611,
		1,
	},
	[0.933333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[0.966666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[0.9] = {
		-0.36079,
		-0.450643,
		-0.816549,
		0,
		0.931957,
		-0.140517,
		-0.334233,
		0,
		0.035881,
		-0.881576,
		0.470677,
		0,
		0.395224,
		1.115702,
		-0.949861,
		1,
	},
	[1.03333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.06666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	{
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.13333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.16666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.1] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.23333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.26666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.2] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.33333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.36666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.3] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.43333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.46666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.4] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.53333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.56666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.5] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.63333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.66666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.6] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.73333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.76666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.7] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.83333333333] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.86666666667] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
	[1.8] = {
		-0.357805,
		-0.457689,
		-0.813939,
		0,
		0.933127,
		-0.142267,
		-0.330202,
		0,
		0.035333,
		-0.877656,
		0.477986,
		0,
		0.395224,
		1.115702,
		-0.961004,
		1,
	},
}

return spline_matrices
