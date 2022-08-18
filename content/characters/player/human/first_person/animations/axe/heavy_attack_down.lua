local spline_matrices = {
	[0] = {
		0.999588,
		-0.014171,
		-0.02496,
		0,
		0.008346,
		-0.68854,
		0.725151,
		0,
		-0.027462,
		-0.72506,
		-0.688138,
		0,
		-0.001532,
		0.031417,
		0.3026,
		1
	},
	{
		0.866916,
		-0.250165,
		-0.431132,
		0,
		-0.479368,
		-0.181368,
		-0.858669,
		0,
		0.136615,
		0.951064,
		-0.277152,
		0,
		-0.00065,
		-0.077623,
		-0.767671,
		1
	},
	[0.0333333333333] = {
		0.999179,
		-0.037111,
		-0.016235,
		0,
		-0.013502,
		-0.683022,
		0.730273,
		0,
		-0.03819,
		-0.729454,
		-0.682963,
		0,
		0.006374,
		0.0412,
		0.37382,
		1
	},
	[0.0666666666667] = {
		0.999191,
		-0.02583,
		-0.030835,
		0,
		0.007808,
		-0.627449,
		0.778618,
		0,
		-0.039459,
		-0.778229,
		-0.62674,
		0,
		0.040757,
		0.058565,
		0.458077,
		1
	},
	[0.133333333333] = {
		0.998183,
		0.057895,
		0.016672,
		0,
		-0.049246,
		0.624629,
		0.779367,
		0,
		0.034708,
		-0.778772,
		0.626346,
		0,
		0.049367,
		0.354243,
		0.25845,
		1
	},
	[0.166666666667] = {
		0.993455,
		0.105022,
		-0.044924,
		0,
		-0.113304,
		0.955919,
		-0.270888,
		0,
		0.014494,
		0.274205,
		0.961562,
		0,
		0.012426,
		0.505491,
		-0.051195,
		1
	},
	[0.1] = {
		0.999439,
		-0.00733,
		-0.032693,
		0,
		0.02723,
		-0.390809,
		0.920069,
		0,
		-0.019521,
		-0.920443,
		-0.39039,
		0,
		0.068365,
		0.128704,
		0.475224,
		1
	},
	[0.233333333333] = {
		0.995403,
		-0.033795,
		-0.089613,
		0,
		-0.093139,
		-0.123601,
		-0.987951,
		0,
		0.022311,
		0.991756,
		-0.126181,
		0,
		0.003822,
		0.425911,
		-0.590221,
		1
	},
	[0.266666666667] = {
		0.990558,
		-0.042127,
		-0.130463,
		0,
		-0.136785,
		-0.367696,
		-0.919831,
		0,
		-0.009221,
		0.928991,
		-0.369987,
		0,
		-0.002286,
		0.237985,
		-0.730378,
		1
	},
	[0.2] = {
		0.993133,
		0.023013,
		-0.114704,
		0,
		-0.115874,
		0.328592,
		-0.937337,
		0,
		0.01612,
		0.944192,
		0.329002,
		0,
		-0.020253,
		0.562725,
		-0.370033,
		1
	},
	[0.333333333333] = {
		0.978462,
		-0.06841,
		-0.194761,
		0,
		-0.197611,
		-0.583189,
		-0.787934,
		0,
		-0.059681,
		0.809451,
		-0.584147,
		0,
		0.010226,
		0.026153,
		-0.786942,
		1
	},
	[0.366666666667] = {
		0.973554,
		-0.08391,
		-0.21249,
		0,
		-0.215769,
		-0.64337,
		-0.734519,
		0,
		-0.075076,
		0.760943,
		-0.644461,
		0,
		0.022899,
		-0.042083,
		-0.779136,
		1
	},
	[0.3] = {
		0.98325,
		-0.051318,
		-0.174886,
		0,
		-0.176776,
		-0.502124,
		-0.846535,
		0,
		-0.044372,
		0.863272,
		-0.502785,
		0,
		0.006255,
		0.107503,
		-0.790497,
		1
	},
	[0.433333333333] = {
		0.963256,
		-0.112917,
		-0.243696,
		0,
		-0.249082,
		-0.714998,
		-0.65325,
		0,
		-0.100479,
		0.689947,
		-0.716852,
		0,
		0.040903,
		-0.127628,
		-0.761483,
		1
	},
	[0.466666666667] = {
		0.957575,
		-0.128099,
		-0.258148,
		0,
		-0.26698,
		-0.731574,
		-0.627313,
		0,
		-0.108496,
		0.66962,
		-0.734737,
		0,
		0.044178,
		-0.153034,
		-0.754372,
		1
	},
	[0.4] = {
		0.968604,
		-0.098085,
		-0.22844,
		0,
		-0.232052,
		-0.686411,
		-0.689197,
		0,
		-0.089204,
		0.720569,
		-0.687621,
		0,
		0.033651,
		-0.092067,
		-0.769709,
		1
	},
	[0.533333333333] = {
		0.946004,
		-0.157061,
		-0.283564,
		0,
		-0.303647,
		-0.735572,
		-0.605584,
		0,
		-0.113468,
		0.658988,
		-0.743545,
		0,
		0.044585,
		-0.181474,
		-0.745202,
		1
	},
	[0.566666666667] = {
		0.940636,
		-0.170238,
		-0.293639,
		0,
		-0.32118,
		-0.726202,
		-0.607843,
		0,
		-0.109763,
		0.66607,
		-0.737769,
		0,
		0.043936,
		-0.187982,
		-0.742593,
		1
	},
	[0.5] = {
		0.951736,
		-0.143021,
		-0.271559,
		0,
		-0.285375,
		-0.738013,
		-0.611472,
		0,
		-0.11296,
		0.659456,
		-0.743208,
		0,
		0.044963,
		-0.170474,
		-0.748968,
		1
	},
	[0.633333333333] = {
		0.930608,
		-0.194335,
		-0.310164,
		0,
		-0.35437,
		-0.690445,
		-0.630641,
		0,
		-0.091596,
		0.696792,
		-0.7114,
		0,
		0.041262,
		-0.193223,
		-0.739727,
		1
	},
	[0.666666666667] = {
		0.92543,
		-0.205163,
		-0.318572,
		0,
		-0.37072,
		-0.664178,
		-0.64918,
		0,
		-0.078401,
		0.718872,
		-0.690708,
		0,
		0.038582,
		-0.192225,
		-0.739412,
		1
	},
	[0.6] = {
		0.935695,
		-0.182621,
		-0.301869,
		0,
		-0.337735,
		-0.711082,
		-0.616683,
		0,
		-0.102034,
		0.678979,
		-0.727033,
		0,
		0.043098,
		-0.19182,
		-0.740795,
		1
	},
	[0.733333333333] = {
		0.914752,
		-0.22355,
		-0.336531,
		0,
		-0.401575,
		-0.594496,
		-0.696643,
		0,
		-0.044332,
		0.772399,
		-0.633589,
		0,
		0.031112,
		-0.182785,
		-0.741207,
		1
	},
	[0.766666666667] = {
		0.909181,
		-0.230816,
		-0.346575,
		0,
		-0.41571,
		-0.55108,
		-0.72353,
		0,
		-0.023988,
		0.801894,
		-0.596984,
		0,
		0.026418,
		-0.174034,
		-0.74339,
		1
	},
	[0.7] = {
		0.920147,
		-0.214957,
		-0.327298,
		0,
		-0.386542,
		-0.632203,
		-0.671494,
		0,
		-0.062576,
		0.744387,
		-0.66481,
		0,
		0.035175,
		-0.188788,
		-0.739889,
		1
	},
	[0.833333333333] = {
		0.897865,
		-0.240335,
		-0.368887,
		0,
		-0.439741,
		-0.448405,
		-0.778178,
		0,
		0.021613,
		0.860914,
		-0.508292,
		0,
		0.015698,
		-0.147436,
		-0.750279,
		1
	},
	[0.866666666667] = {
		0.891992,
		-0.242956,
		-0.381212,
		0,
		-0.449729,
		-0.391571,
		-0.802755,
		0,
		0.045763,
		0.887493,
		-0.458542,
		0,
		0.009836,
		-0.130515,
		-0.754445,
		1
	},
	[0.8] = {
		0.903616,
		-0.236422,
		-0.357187,
		0,
		-0.42834,
		-0.502289,
		-0.751153,
		0,
		-0.001822,
		0.831752,
		-0.555145,
		0,
		0.021288,
		-0.162336,
		-0.746454,
		1
	},
	[0.933333333333] = {
		0.879874,
		-0.246674,
		-0.406169,
		0,
		-0.465903,
		-0.279491,
		-0.839535,
		0,
		0.093571,
		0.927921,
		-0.360843,
		0,
		0.000335,
		-0.101016,
		-0.758348,
		1
	},
	[0.966666666667] = {
		0.873533,
		-0.248292,
		-0.418679,
		0,
		-0.472745,
		-0.227789,
		-0.851249,
		0,
		0.115988,
		0.941522,
		-0.31636,
		0,
		0.00066,
		-0.088565,
		-0.765094,
		1
	},
	[0.9] = {
		0.886007,
		-0.244988,
		-0.393665,
		0,
		-0.458364,
		-0.334676,
		-0.823343,
		0,
		0.069959,
		0.90993,
		-0.408819,
		0,
		0.003901,
		-0.113234,
		-0.758493,
		1
	},
	[1.03333333333] = {
		0.859925,
		-0.252664,
		-0.443496,
		0,
		-0.486348,
		-0.141912,
		-0.862164,
		0,
		0.154901,
		0.95709,
		-0.244916,
		0,
		-0.001792,
		-0.069023,
		-0.769295,
		1
	},
	[1.06666666667] = {
		0.852445,
		-0.256195,
		-0.455743,
		0,
		-0.494303,
		-0.110992,
		-0.862175,
		0,
		0.170301,
		0.960232,
		-0.221253,
		0,
		-0.002628,
		-0.063621,
		-0.769769,
		1
	}
}

return spline_matrices
