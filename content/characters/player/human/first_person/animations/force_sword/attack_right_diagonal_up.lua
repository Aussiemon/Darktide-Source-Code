﻿-- chunkname: @content/characters/player/human/first_person/animations/force_sword/attack_right_diagonal_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.362721,
		-0.033187,
		0.931306,
		0,
		-0.8645,
		0.385131,
		-0.322978,
		0,
		-0.347956,
		-0.922265,
		-0.168385,
		0,
		-0.310554,
		-0.075743,
		-0.475302,
		1
	},
	[0.0333333333333] = {
		-0.24822,
		-0.180717,
		0.951698,
		0,
		-0.913804,
		0.369722,
		-0.168131,
		0,
		-0.321479,
		-0.911399,
		-0.256912,
		0,
		-0.317165,
		-0.030443,
		-0.448299,
		1
	},
	[0.05] = {
		-0.122872,
		-0.324725,
		0.937793,
		0,
		-0.944103,
		0.32951,
		-0.009601,
		0,
		-0.305894,
		-0.886553,
		-0.347062,
		0,
		-0.324582,
		0.029677,
		-0.408289,
		1
	},
	[0.0666666666667] = {
		-0.012002,
		-0.448523,
		0.893691,
		0,
		-0.952363,
		0.277501,
		0.126482,
		0,
		-0.304731,
		-0.8496,
		-0.430487,
		0,
		-0.330535,
		0.094984,
		-0.362309,
		1
	},
	[0.0833333333333] = {
		0.058706,
		-0.542708,
		0.837867,
		0,
		-0.946884,
		0.235554,
		0.218919,
		0,
		-0.316172,
		-0.806214,
		-0.500053,
		0,
		-0.332734,
		0.156122,
		-0.317793,
		1
	},
	[0] = {
		-0.448408,
		0.100076,
		0.888209,
		0,
		-0.810161,
		0.374271,
		-0.451176,
		0,
		-0.377583,
		-0.921903,
		-0.086749,
		0,
		-0.30687,
		-0.09645,
		-0.482645,
		1
	},
	[0.116666666667] = {
		-0.026805,
		-0.609757,
		0.792135,
		0,
		-0.948839,
		0.26492,
		0.171818,
		0,
		-0.31462,
		-0.747003,
		-0.585663,
		0,
		-0.316314,
		0.221338,
		-0.261288,
		1
	},
	[0.133333333333] = {
		-0.195137,
		-0.572198,
		0.796562,
		0,
		-0.935738,
		0.351908,
		0.023556,
		0,
		-0.293795,
		-0.740777,
		-0.604098,
		0,
		-0.294071,
		0.23008,
		-0.244599,
		1
	},
	[0.15] = {
		-0.355889,
		-0.535513,
		0.765878,
		0,
		-0.853252,
		0.520481,
		-0.032561,
		0,
		-0.381188,
		-0.665075,
		-0.642161,
		0,
		-0.261746,
		0.282259,
		-0.221502,
		1
	},
	[0.166666666667] = {
		-0.503368,
		-0.483723,
		0.715984,
		0,
		-0.602238,
		0.790599,
		0.110733,
		0,
		-0.61962,
		-0.375453,
		-0.689279,
		0,
		-0.213228,
		0.433893,
		-0.188562,
		1
	},
	[0.183333333333] = {
		-0.628152,
		-0.360733,
		0.689417,
		0,
		-0.126429,
		0.921582,
		0.367018,
		0,
		-0.76775,
		0.14338,
		-0.624501,
		0,
		-0.126688,
		0.633371,
		-0.136375,
		1
	},
	[0.1] = {
		0.067787,
		-0.604532,
		0.793691,
		0,
		-0.939877,
		0.228196,
		0.254083,
		0,
		-0.334719,
		-0.763195,
		-0.552717,
		0,
		-0.328838,
		0.203978,
		-0.282435,
		1
	},
	[0.216666666667] = {
		-0.687818,
		-0.083041,
		0.721118,
		0,
		0.673534,
		0.297416,
		0.67668,
		0,
		-0.270664,
		0.95113,
		-0.148637,
		0,
		0.164385,
		0.750424,
		0.057452,
		1
	},
	[0.233333333333] = {
		-0.722897,
		-0.067008,
		0.687698,
		0,
		0.690483,
		-0.03326,
		0.722584,
		0,
		-0.025546,
		0.997198,
		0.070311,
		0,
		0.277189,
		0.707196,
		0.129417,
		1
	},
	[0.25] = {
		-0.703105,
		-0.076664,
		0.706942,
		0,
		0.69476,
		-0.285878,
		0.659987,
		0,
		0.151502,
		0.955195,
		0.254265,
		0,
		0.374143,
		0.654053,
		0.179619,
		1
	},
	[0.266666666667] = {
		-0.701194,
		-0.070203,
		0.709506,
		0,
		0.661831,
		-0.434184,
		0.611117,
		0,
		0.265154,
		0.898084,
		0.35091,
		0,
		0.445321,
		0.606669,
		0.185883,
		1
	},
	[0.283333333333] = {
		-0.705417,
		-0.052216,
		0.706867,
		0,
		0.616949,
		-0.536202,
		0.576074,
		0,
		0.348944,
		0.842473,
		0.410461,
		0,
		0.512344,
		0.56193,
		0.183907,
		1
	},
	[0.2] = {
		-0.683529,
		-0.213427,
		0.698023,
		0,
		0.347621,
		0.745702,
		0.568408,
		0,
		-0.641831,
		0.631171,
		-0.435518,
		0,
		-0.001193,
		0.767123,
		-0.059782,
		1
	},
	[0.316666666667] = {
		-0.707675,
		0.025012,
		0.706095,
		0,
		0.470758,
		-0.728534,
		0.497619,
		0,
		0.526861,
		0.684552,
		0.503791,
		0,
		0.636405,
		0.468012,
		0.161113,
		1
	},
	[0.333333333333] = {
		-0.686936,
		0.094972,
		0.720485,
		0,
		0.323377,
		-0.847911,
		0.420088,
		0,
		0.650804,
		0.521562,
		0.551749,
		0,
		0.683392,
		0.413157,
		0.132752,
		1
	},
	[0.35] = {
		-0.654921,
		0.119063,
		0.746259,
		0,
		0.256167,
		-0.894066,
		0.367458,
		0,
		0.710955,
		0.431823,
		0.555042,
		0,
		0.701275,
		0.380924,
		0.105931,
		1
	},
	[0.366666666667] = {
		-0.619356,
		0.134843,
		0.773444,
		0,
		0.193439,
		-0.928561,
		0.316788,
		0,
		0.760907,
		0.345819,
		0.549026,
		0,
		0.715671,
		0.350598,
		0.078886,
		1
	},
	[0.383333333333] = {
		-0.581243,
		0.142793,
		0.801103,
		0,
		0.136329,
		-0.95348,
		0.268868,
		0,
		0.802229,
		0.265491,
		0.534737,
		0,
		0.726949,
		0.322287,
		0.051693,
		1
	},
	[0.3] = {
		-0.710121,
		-0.018978,
		0.703824,
		0,
		0.557306,
		-0.626049,
		0.545411,
		0,
		0.430278,
		0.779553,
		0.455147,
		0,
		0.57676,
		0.51667,
		0.174862,
		1
	},
	[0.416666666667] = {
		-0.500116,
		0.138011,
		0.85489,
		0,
		0.041065,
		-0.982328,
		0.182607,
		0,
		0.864984,
		0.126431,
		0.48561,
		0,
		0.741479,
		0.271725,
		-0.002763,
		1
	},
	[0.433333333333] = {
		-0.457923,
		0.126681,
		0.87992,
		0,
		0.003112,
		-0.98956,
		0.144085,
		0,
		0.888987,
		0.068718,
		0.452748,
		0,
		0.745251,
		0.249334,
		-0.02984,
		1
	},
	[0.45] = {
		-0.414904,
		0.110325,
		0.903152,
		0,
		-0.028616,
		-0.993713,
		0.108242,
		0,
		0.909415,
		0.019065,
		0.415452,
		0,
		0.746967,
		0.228745,
		-0.056736,
		1
	},
	[0.466666666667] = {
		-0.3711,
		0.089614,
		0.924259,
		0,
		-0.054442,
		-0.99572,
		0.074683,
		0,
		0.926996,
		-0.022603,
		0.37439,
		0,
		0.746789,
		0.209857,
		-0.083423,
		1
	},
	[0.483333333333] = {
		-0.326473,
		0.065173,
		0.942957,
		0,
		-0.074751,
		-0.996276,
		0.042978,
		0,
		0.942246,
		-0.056456,
		0.330129,
		0,
		0.74485,
		0.192577,
		-0.109882,
		1
	},
	[0.4] = {
		-0.541326,
		0.143608,
		0.828458,
		0,
		0.085459,
		-0.970807,
		0.224123,
		0,
		0.836458,
		0.192123,
		0.513251,
		0,
		0.735457,
		0.296014,
		0.024444,
		1
	},
	[0.516666666667] = {
		-0.234388,
		0.007431,
		0.972115,
		0,
		-0.100499,
		-0.994798,
		-0.016627,
		0,
		0.966934,
		-0.101594,
		0.233916,
		0,
		0.736113,
		0.162492,
		-0.162089,
		1
	},
	[0.533333333333] = {
		-0.186716,
		-0.024778,
		0.982101,
		0,
		-0.106803,
		-0.993245,
		-0.045364,
		0,
		0.976591,
		-0.113361,
		0.182808,
		0,
		0.729487,
		0.149534,
		-0.18783,
		1
	},
	[0.55] = {
		-0.137832,
		-0.05851,
		0.988726,
		0,
		-0.10931,
		-0.991257,
		-0.073898,
		0,
		0.984405,
		-0.118263,
		0.130231,
		0,
		0.721451,
		0.137872,
		-0.213326,
		1
	},
	[0.566666666667] = {
		-0.087683,
		-0.093247,
		0.991775,
		0,
		-0.108464,
		-0.988796,
		-0.102556,
		0,
		0.990226,
		-0.116564,
		0.076587,
		0,
		0.712067,
		0.127439,
		-0.238569,
		1
	},
	[0.583333333333] = {
		-0.036228,
		-0.128479,
		0.99105,
		0,
		-0.104494,
		-0.985778,
		-0.131616,
		0,
		0.993865,
		-0.108327,
		0.022287,
		0,
		0.701361,
		0.118329,
		-0.26355,
		1
	},
	[0.5] = {
		-0.280939,
		0.037593,
		0.958989,
		0,
		-0.08996,
		-0.995865,
		0.012685,
		0,
		0.9555,
		-0.082707,
		0.283159,
		0,
		0.74126,
		0.176815,
		-0.136105,
		1
	},
	[0.616666666667] = {
		0.070547,
		-0.198174,
		0.977625,
		0,
		-0.0885,
		-0.977445,
		-0.191751,
		0,
		0.993575,
		-0.072993,
		-0.086494,
		0,
		0.676165,
		0.10416,
		-0.312656,
		1
	},
	[0.633333333333] = {
		0.125634,
		-0.231484,
		0.964692,
		0,
		-0.07752,
		-0.971714,
		-0.223073,
		0,
		0.989043,
		-0.046758,
		-0.140025,
		0,
		0.661805,
		0.098871,
		-0.336731,
		1
	},
	[0.65] = {
		0.181569,
		-0.263035,
		0.947547,
		0,
		-0.065275,
		-0.964662,
		-0.255278,
		0,
		0.981209,
		-0.015501,
		-0.192322,
		0,
		0.64636,
		0.094612,
		-0.360448,
		1
	},
	[0.666666666667] = {
		0.238044,
		-0.292325,
		0.926219,
		0,
		-0.052321,
		-0.956106,
		-0.288311,
		0,
		0.969844,
		0.02017,
		-0.24289,
		0,
		0.629906,
		0.091248,
		-0.383773,
		1
	},
	[0.683333333333] = {
		0.294683,
		-0.318911,
		0.90081,
		0,
		-0.039216,
		-0.94591,
		-0.322049,
		0,
		0.95479,
		0.059576,
		-0.29125,
		0,
		0.612526,
		0.088633,
		-0.406677,
		1
	},
	[0.6] = {
		0.016541,
		-0.16365,
		0.98638,
		0,
		-0.097668,
		-0.982061,
		-0.161295,
		0,
		0.995082,
		-0.09367,
		-0.032228,
		0,
		0.689372,
		0.110607,
		-0.288254,
		1
	},
	[0.716666666667] = {
		0.406682,
		-0.362595,
		0.838531,
		0,
		-0.014739,
		-0.920347,
		-0.390825,
		0,
		0.913451,
		0.146583,
		-0.379633,
		0,
		0.57537,
		0.085041,
		-0.451109,
		1
	},
	[0.733333333333] = {
		0.461084,
		-0.379252,
		0.802228,
		0,
		-0.004399,
		-0.905031,
		-0.425324,
		0,
		0.887345,
		0.192581,
		-0.418964,
		0,
		0.55582,
		0.083745,
		-0.4726,
		1
	},
	[0.75] = {
		0.51377,
		-0.392345,
		0.762958,
		0,
		0.004054,
		-0.888184,
		-0.459471,
		0,
		0.857918,
		0.239155,
		-0.454732,
		0,
		0.535795,
		0.08257,
		-0.493598,
		1
	},
	[0.766666666667] = {
		0.564276,
		-0.401941,
		0.721135,
		0,
		0.010218,
		-0.870016,
		-0.492918,
		0,
		0.825523,
		0.28551,
		-0.486822,
		0,
		0.515438,
		0.08136,
		-0.514109,
		1
	},
	[0.783333333333] = {
		0.612178,
		-0.408224,
		0.677193,
		0,
		0.013754,
		-0.850799,
		-0.525311,
		0,
		0.7906,
		0.330898,
		-0.515226,
		0,
		0.494904,
		0.079963,
		-0.53415,
		1
	},
	[0.7] = {
		0.351052,
		-0.342425,
		0.871497,
		0,
		-0.026511,
		-0.933994,
		-0.356302,
		0,
		0.935981,
		0.101976,
		-0.336959,
		0,
		0.594311,
		0.086617,
		-0.429129,
		1
	},
	[0.816666666667] = {
		0.698765,
		-0.41213,
		0.584703,
		0,
		0.011908,
		-0.810549,
		-0.585549,
		0,
		0.715253,
		0.416124,
		-0.561476,
		0,
		0.453961,
		0.076057,
		-0.572956,
		1
	},
	[0.833333333333] = {
		0.736914,
		-0.410618,
		0.536984,
		0,
		0.006164,
		-0.790255,
		-0.612747,
		0,
		0.675959,
		0.454851,
		-0.579819,
		0,
		0.43389,
		0.073298,
		-0.591813,
		1
	},
	[0.85] = {
		0.771391,
		-0.407494,
		0.488778,
		0,
		-0.002942,
		-0.770359,
		-0.637604,
		0,
		0.636355,
		0.490404,
		-0.595447,
		0,
		0.414314,
		0.069857,
		-0.610382,
		1
	},
	[0.866666666667] = {
		0.802095,
		-0.403349,
		0.440402,
		0,
		-0.015468,
		-0.751232,
		-0.659857,
		0,
		0.596997,
		0.522455,
		-0.608798,
		0,
		0.3954,
		0.065639,
		-0.62873,
		1
	},
	[0.883333333333] = {
		0.828973,
		-0.398807,
		0.392119,
		0,
		-0.031441,
		-0.733224,
		-0.67926,
		0,
		0.558404,
		0.55076,
		-0.620361,
		0,
		0.377312,
		0.060564,
		-0.646925,
		1
	},
	[0.8] = {
		0.657109,
		-0.41149,
		0.631573,
		0,
		0.014388,
		-0.830857,
		-0.5563,
		0,
		0.753659,
		0.374636,
		-0.540043,
		0,
		0.474356,
		0.078239,
		-0.553752,
		1
	},
	[0.916666666667] = {
		0.871234,
		-0.391104,
		0.29663,
		0,
		-0.073729,
		-0.701705,
		-0.708642,
		0,
		0.485299,
		0.595523,
		-0.640185,
		0,
		0.344222,
		0.047614,
		-0.683143,
		1
	},
	[0.933333333333] = {
		0.886671,
		-0.389196,
		0.249682,
		0,
		-0.099988,
		-0.68857,
		-0.718243,
		0,
		0.451461,
		0.61188,
		-0.64945,
		0,
		0.329505,
		0.039748,
		-0.7013,
		1
	},
	[0.95] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[0.966666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[0.983333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[0.9] = {
		0.852011,
		-0.394513,
		0.344146,
		0,
		-0.05087,
		-0.716642,
		-0.695583,
		0,
		0.521046,
		0.575138,
		-0.630656,
		0,
		0.360204,
		0.054556,
		-0.66504,
		1
	},
	[1.01666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.03333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.05] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.06666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.08333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	{
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.11666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.13333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.15] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.16666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.18333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.1] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.21666666667] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.23333333333] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[1.2] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677372,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658989,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	}
}

return spline_matrices
