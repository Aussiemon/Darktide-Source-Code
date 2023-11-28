﻿-- chunkname: @content/characters/player/human/first_person/animations/power_maul/attack_right.lua

local spline_matrices = {
	[0.0333333333333] = {
		-0.843625,
		0.515042,
		0.151754,
		0,
		0.534498,
		0.832446,
		0.146098,
		0,
		-0.05108,
		0.204364,
		-0.977561,
		0,
		-0.01019,
		-0.045914,
		-0.500882,
		1
	},
	[0.0666666666667] = {
		-0.771688,
		0.584783,
		-0.250053,
		0,
		0.635618,
		0.722752,
		-0.271328,
		0,
		0.022058,
		-0.368318,
		-0.929438,
		0,
		-0.079962,
		-0.05044,
		-0.374697,
		1
	},
	[0] = {
		-0.744553,
		0.600448,
		0.291725,
		0,
		0.591753,
		0.795909,
		-0.127897,
		0,
		-0.308982,
		0.077403,
		-0.947913,
		0,
		0.038538,
		-0.059519,
		-0.494783,
		1
	},
	[0.133333333333] = {
		-0.59217,
		0.1702,
		-0.787634,
		0,
		0.804336,
		0.06569,
		-0.590532,
		0,
		-0.048769,
		-0.983218,
		-0.175798,
		0,
		-0.203476,
		-0.017348,
		-0.194382,
		1
	},
	[0.166666666667] = {
		-0.563724,
		0.074316,
		-0.822613,
		0,
		0.825355,
		0.012472,
		-0.564476,
		0,
		-0.03169,
		-0.997157,
		-0.068368,
		0,
		-0.255297,
		-0.010237,
		-0.13368,
		1
	},
	[0.1] = {
		-0.666246,
		0.402634,
		-0.627695,
		0,
		0.745662,
		0.371151,
		-0.553384,
		0,
		0.010158,
		-0.836739,
		-0.547507,
		0,
		-0.147404,
		-0.035322,
		-0.268516,
		1
	},
	[0.233333333333] = {
		-0.517123,
		0.106399,
		-0.849272,
		0,
		0.855829,
		0.078044,
		-0.511338,
		0,
		0.011875,
		-0.991256,
		-0.131417,
		0,
		-0.333103,
		0.024578,
		-0.045673,
		1
	},
	[0.266666666667] = {
		-0.406047,
		0.152275,
		-0.901076,
		0,
		0.882628,
		-0.190195,
		-0.429876,
		0,
		-0.236839,
		-0.969865,
		-0.057175,
		0,
		-0.339482,
		0.11948,
		-0.036244,
		1
	},
	[0.2] = {
		-0.548543,
		0.065876,
		-0.833523,
		0,
		0.83557,
		0.079423,
		-0.543613,
		0,
		0.03039,
		-0.994662,
		-0.098611,
		0,
		-0.30311,
		-0.003672,
		-0.080726,
		1
	},
	[0.333333333333] = {
		-0.009032,
		0.044953,
		-0.998948,
		0,
		0.117732,
		-0.991993,
		-0.045704,
		0,
		-0.993004,
		-0.118021,
		0.003667,
		0,
		-0.175133,
		0.566753,
		-0.041337,
		1
	},
	[0.366666666667] = {
		0.03447,
		0.043532,
		-0.998457,
		0,
		-0.882995,
		-0.466622,
		-0.050828,
		0,
		-0.468115,
		0.883385,
		0.022354,
		0,
		0.242296,
		0.576579,
		-0.037437,
		1
	},
	[0.3] = {
		-0.170478,
		0.130455,
		-0.976688,
		0,
		0.705763,
		-0.675537,
		-0.213419,
		0,
		-0.68763,
		-0.725694,
		0.023094,
		0,
		-0.320273,
		0.353289,
		-0.04054,
		1
	},
	[0.433333333333] = {
		0.053193,
		-0.001353,
		-0.998583,
		0,
		-0.599363,
		0.799797,
		-0.033011,
		0,
		0.798708,
		0.600269,
		0.041732,
		0,
		0.668126,
		0.179717,
		-0.035325,
		1
	},
	[0.466666666667] = {
		0.028947,
		0.055531,
		-0.998037,
		0,
		-0.431202,
		0.90147,
		0.037651,
		0,
		0.901791,
		0.429266,
		0.050039,
		0,
		0.710291,
		0.04814,
		-0.064769,
		1
	},
	[0.4] = {
		0.030559,
		0.052812,
		-0.998137,
		0,
		-0.976649,
		0.214035,
		-0.018576,
		0,
		0.212655,
		0.975397,
		0.058119,
		0,
		0.535582,
		0.413558,
		-0.039735,
		1
	},
	[0.533333333333] = {
		-0.046563,
		0.28898,
		-0.956202,
		0,
		-0.500008,
		0.821947,
		0.272754,
		0,
		0.864768,
		0.490809,
		0.10622,
		0,
		0.726768,
		-0.154449,
		-0.241438,
		1
	},
	[0.566666666667] = {
		-0.131985,
		0.404156,
		-0.905117,
		0,
		-0.600889,
		0.693588,
		0.397326,
		0,
		0.788361,
		0.596316,
		0.15131,
		0,
		0.706685,
		-0.226654,
		-0.348419,
		1
	},
	[0.5] = {
		0.003115,
		0.16202,
		-0.986783,
		0,
		-0.419387,
		0.896024,
		0.145794,
		0,
		0.907802,
		0.41339,
		0.07074,
		0,
		0.728807,
		-0.062225,
		-0.140004,
		1
	},
	[0.633333333333] = {
		-0.353626,
		0.509851,
		-0.78422,
		0,
		-0.641048,
		0.478446,
		0.600122,
		0,
		0.68118,
		0.714942,
		0.157648,
		0,
		0.631081,
		-0.310712,
		-0.496401,
		1
	},
	[0.666666666667] = {
		-0.470926,
		0.506802,
		-0.722066,
		0,
		-0.545569,
		0.475897,
		0.689838,
		0,
		0.693241,
		0.7188,
		0.052384,
		0,
		0.575012,
		-0.320732,
		-0.526375,
		1
	},
	[0.6] = {
		-0.242787,
		0.479748,
		-0.843147,
		0,
		-0.660743,
		0.554585,
		0.50582,
		0,
		0.710263,
		0.67991,
		0.182344,
		0,
		0.672801,
		-0.277663,
		-0.439978,
		1
	},
	[0.733333333333] = {
		-0.745408,
		0.446157,
		-0.495289,
		0,
		-0.199455,
		0.559685,
		0.804345,
		0,
		0.63607,
		0.698353,
		-0.328205,
		0,
		0.406199,
		-0.269434,
		-0.567701,
		1
	},
	[0.766666666667] = {
		-0.85329,
		0.414066,
		-0.316932,
		0,
		0.017565,
		0.630284,
		0.776166,
		0,
		0.521141,
		0.656727,
		-0.545088,
		0,
		0.309287,
		-0.221372,
		-0.57587,
		1
	},
	[0.7] = {
		-0.608501,
		0.481676,
		-0.630646,
		0,
		-0.395925,
		0.504453,
		0.767314,
		0,
		0.687728,
		0.7166,
		-0.116252,
		0,
		0.497604,
		-0.30471,
		-0.550761,
		1
	},
	[0.833333333333] = {
		-0.915812,
		0.396485,
		0.063945,
		0,
		0.364096,
		0.752487,
		0.548815,
		0,
		0.169479,
		0.525893,
		-0.833495,
		0,
		0.13304,
		-0.112756,
		-0.571961,
		1
	},
	[0.866666666667] = {
		-0.889582,
		0.407537,
		0.206293,
		0,
		0.456689,
		0.784757,
		0.419038,
		0,
		0.008883,
		0.46698,
		-0.884223,
		0,
		0.066705,
		-0.066729,
		-0.566215,
		1
	},
	[0.8] = {
		-0.910229,
		0.396645,
		-0.118976,
		0,
		0.215662,
		0.699325,
		0.681495,
		0,
		0.353514,
		0.594658,
		-0.722087,
		0,
		0.215704,
		-0.166864,
		-0.576306,
		1
	},
	[0.933333333333] = {
		-0.834554,
		0.429097,
		0.345536,
		0,
		0.527659,
		0.8029,
		0.277359,
		0,
		-0.158416,
		0.413796,
		-0.89648,
		0,
		-0.003213,
		-0.023538,
		-0.558936,
		1
	},
	[0.966666666667] = {
		-0.826967,
		0.431694,
		0.360231,
		0,
		0.533649,
		0.804386,
		0.261116,
		0,
		-0.177043,
		0.408171,
		-0.895574,
		0,
		-0.01113,
		-0.019074,
		-0.558206,
		1
	},
	[0.9] = {
		-0.856537,
		0.420719,
		0.298898,
		0,
		0.505953,
		0.798751,
		0.32559,
		0,
		-0.101763,
		0.430108,
		-0.897024,
		0,
		0.020958,
		-0.037,
		-0.561483,
		1
	},
	[1.03333333333] = {
		-0.840061,
		0.425966,
		0.335933,
		0,
		0.52186,
		0.803683,
		0.285928,
		0,
		-0.148188,
		0.415507,
		-0.897437,
		0,
		0.001948,
		-0.026332,
		-0.55982,
		1
	},
	[1.06666666667] = {
		-0.850656,
		0.421481,
		0.314227,
		0,
		0.511289,
		0.802357,
		0.307906,
		0,
		-0.122346,
		0.422583,
		-0.898028,
		0,
		0.013302,
		-0.032584,
		-0.561104,
		1
	},
	{
		-0.830468,
		0.430019,
		0.354127,
		0,
		0.530489,
		0.804495,
		0.267152,
		0,
		-0.170013,
		0.409722,
		-0.896228,
		0,
		-0.007803,
		-0.020918,
		-0.55868,
		1
	},
	[1.13333333333] = {
		-0.858881,
		0.417946,
		0.296049,
		0,
		0.502129,
		0.801042,
		0.325881,
		0,
		-0.100947,
		0.428548,
		-0.897862,
		0,
		0.022598,
		-0.037661,
		-0.562142,
		1
	},
	[1.1] = {
		-0.857808,
		0.41841,
		0.298494,
		0,
		0.503377,
		0.801229,
		0.323486,
		0,
		-0.103813,
		0.427744,
		-0.897919,
		0,
		0.021358,
		-0.036986,
		-0.562005,
		1
	}
}

return spline_matrices
