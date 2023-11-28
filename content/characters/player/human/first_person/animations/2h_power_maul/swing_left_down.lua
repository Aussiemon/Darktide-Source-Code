﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_power_maul/swing_left_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.454091,
		0.036282,
		-0.890216,
		0,
		0.768842,
		0.488928,
		0.412106,
		0,
		0.450204,
		-0.871569,
		0.194123,
		0,
		0.1476,
		0.501796,
		-0.152241,
		1
	},
	[0.0333333333333] = {
		0.517186,
		0.022719,
		-0.855572,
		0,
		0.741028,
		0.488301,
		0.460912,
		0,
		0.428248,
		-0.87238,
		0.235707,
		0,
		0.149033,
		0.497278,
		-0.141856,
		1
	},
	[0.05] = {
		0.571261,
		0.017939,
		-0.820573,
		0,
		0.718536,
		0.472275,
		0.510551,
		0,
		0.396695,
		-0.881269,
		0.256902,
		0,
		0.153095,
		0.491482,
		-0.125678,
		1
	},
	[0.0666666666667] = {
		0.617784,
		0.019019,
		-0.786117,
		0,
		0.69982,
		0.442602,
		0.560674,
		0,
		0.3586,
		-0.896517,
		0.260122,
		0,
		0.158864,
		0.484522,
		-0.10471,
		1
	},
	[0.0833333333333] = {
		0.658145,
		0.02365,
		-0.75252,
		0,
		0.683237,
		0.401116,
		0.610158,
		0,
		0.316278,
		-0.915722,
		0.247834,
		0,
		0.165607,
		0.476364,
		-0.080007,
		1
	},
	[0] = {
		0.38051,
		0.061754,
		-0.922713,
		0,
		0.803038,
		0.472765,
		0.362799,
		0,
		0.45863,
		-0.879022,
		0.130301,
		0,
		0.149835,
		0.501388,
		-0.15634,
		1
	},
	[0.116666666667] = {
		0.724851,
		0.036568,
		-0.687934,
		0,
		0.650654,
		0.291781,
		0.70108,
		0,
		0.226363,
		-0.955786,
		0.187705,
		0,
		0.179683,
		0.456308,
		-0.023853,
		1
	},
	[0.133333333333] = {
		0.752853,
		0.042169,
		-0.656836,
		0,
		0.632505,
		0.2297,
		0.739713,
		0,
		0.182068,
		-0.972348,
		0.146259,
		0,
		0.18605,
		0.444596,
		0.005271,
		1
	},
	[0.15] = {
		0.77806,
		0.045844,
		-0.626515,
		0,
		0.612337,
		0.167295,
		0.772694,
		0,
		0.140236,
		-0.98484,
		0.102093,
		0,
		0.191445,
		0.432161,
		0.03352,
		1
	},
	[0.166666666667] = {
		0.800834,
		0.046762,
		-0.597058,
		0,
		0.590166,
		0.107892,
		0.80004,
		0,
		0.101829,
		-0.993062,
		0.058806,
		0,
		0.195726,
		0.419439,
		0.059873,
		1
	},
	[0.183333333333] = {
		0.82152,
		0.044412,
		-0.568447,
		0,
		0.566087,
		0.055713,
		0.822461,
		0,
		0.068197,
		-0.997459,
		0.020629,
		0,
		0.198545,
		0.407156,
		0.083149,
		1
	},
	[0.1] = {
		0.693523,
		0.03,
		-0.719809,
		0,
		0.667264,
		0.349963,
		0.657483,
		0,
		0.271631,
		-0.936283,
		0.222689,
		0,
		0.172719,
		0.466953,
		-0.052673,
		1
	},
	[0.216666666667] = {
		0.857676,
		0.028796,
		-0.513383,
		0,
		0.51386,
		-0.012194,
		0.857788,
		0,
		0.018441,
		-0.999511,
		-0.025256,
		0,
		0.199191,
		0.38701,
		0.116559,
		1
	},
	[0.233333333333] = {
		0.873678,
		0.015301,
		-0.486264,
		0,
		0.486494,
		-0.020761,
		0.873437,
		0,
		0.003269,
		-0.999667,
		-0.025583,
		0,
		0.196836,
		0.380672,
		0.124785,
		1
	},
	[0.25] = {
		0.888686,
		-0.002246,
		-0.458511,
		0,
		0.458485,
		-0.007323,
		0.888672,
		0,
		-0.005354,
		-0.999971,
		-0.005478,
		0,
		0.192687,
		0.37765,
		0.125866,
		1
	},
	[0.266666666667] = {
		0.902993,
		-0.023718,
		-0.428999,
		0,
		0.429587,
		0.032143,
		0.902453,
		0,
		-0.007615,
		-0.999202,
		0.039213,
		0,
		0.186759,
		0.378229,
		0.118504,
		1
	},
	[0.283333333333] = {
		0.916014,
		-0.049983,
		-0.39802,
		0,
		0.401057,
		0.093213,
		0.911298,
		0,
		-0.008449,
		-0.994391,
		0.10543,
		0,
		0.177371,
		0.396971,
		0.102984,
		1
	},
	[0.2] = {
		0.840382,
		0.038481,
		-0.540627,
		0,
		0.540502,
		0.014485,
		0.841218,
		0,
		0.040202,
		-0.999154,
		-0.008626,
		0,
		0.199737,
		0.396083,
		0.10236,
		1
	},
	[0.316666666667] = {
		0.935711,
		-0.103558,
		-0.337224,
		0,
		0.352739,
		0.28654,
		0.890769,
		0,
		0.004382,
		-0.952455,
		0.304647,
		0,
		0.142787,
		0.500172,
		0.046826,
		1
	},
	[0.333333333333] = {
		0.944771,
		-0.121553,
		-0.304357,
		0,
		0.326051,
		0.442555,
		0.835366,
		0,
		0.033153,
		-0.888465,
		0.457745,
		0,
		0.116902,
		0.560302,
		0.001292,
		1
	},
	[0.35] = {
		0.955774,
		-0.125611,
		-0.265927,
		0,
		0.281193,
		0.655237,
		0.701138,
		0,
		0.086175,
		-0.744907,
		0.66158,
		0,
		0.08422,
		0.603498,
		-0.061156,
		1
	},
	[0.366666666667] = {
		0.970845,
		-0.095785,
		-0.21974,
		0,
		0.165058,
		0.931879,
		0.323045,
		0,
		0.173828,
		-0.349896,
		0.92052,
		0,
		0.039407,
		0.603921,
		-0.167197,
		1
	},
	[0.383333333333] = {
		0.97906,
		-0.027983,
		-0.201641,
		0,
		-0.035076,
		0.952506,
		-0.302492,
		0,
		0.200529,
		0.303231,
		0.931579,
		0,
		-0.000213,
		0.545724,
		-0.261714,
		1
	},
	[0.3] = {
		0.926668,
		-0.078256,
		-0.367645,
		0,
		0.375815,
		0.174568,
		0.910104,
		0,
		-0.007042,
		-0.98153,
		0.191176,
		0,
		0.16279,
		0.441365,
		0.079695,
		1
	},
	[0.416666666667] = {
		0.964364,
		0.03672,
		-0.26202,
		0,
		-0.262516,
		0.256274,
		-0.930274,
		0,
		0.032989,
		0.965907,
		0.256781,
		0,
		-0.035756,
		0.436872,
		-0.304714,
		1
	},
	[0.433333333333] = {
		0.953747,
		0.029657,
		-0.299145,
		0,
		-0.292847,
		-0.133042,
		-0.946858,
		0,
		-0.06788,
		0.990667,
		-0.118203,
		0,
		-0.055793,
		0.414951,
		-0.310284,
		1
	},
	[0.45] = {
		0.943152,
		0.015854,
		-0.331983,
		0,
		-0.289027,
		-0.454041,
		-0.842799,
		0,
		-0.164096,
		0.89084,
		-0.423648,
		0,
		-0.103988,
		0.359642,
		-0.343239,
		1
	},
	[0.466666666667] = {
		0.93244,
		-0.007263,
		-0.361252,
		0,
		-0.256708,
		-0.716909,
		-0.648184,
		0,
		-0.254277,
		0.697129,
		-0.670339,
		0,
		-0.171954,
		0.24326,
		-0.390005,
		1
	},
	[0.483333333333] = {
		0.924566,
		-0.035084,
		-0.379402,
		0,
		-0.207723,
		-0.881173,
		-0.424717,
		0,
		-0.319418,
		0.47149,
		-0.821991,
		0,
		-0.231733,
		0.142564,
		-0.434705,
		1
	},
	[0.4] = {
		0.974058,
		0.022875,
		-0.225141,
		0,
		-0.186641,
		0.643803,
		-0.74208,
		0,
		0.127972,
		0.764849,
		0.631371,
		0,
		-0.020331,
		0.495078,
		-0.292142,
		1
	},
	[0.516666666667] = {
		0.922808,
		-0.07241,
		-0.378395,
		0,
		-0.144687,
		-0.97542,
		-0.166196,
		0,
		-0.35706,
		0.208116,
		-0.910602,
		0,
		-0.249959,
		0.081557,
		-0.441716,
		1
	},
	[0.533333333333] = {
		0.924943,
		-0.083919,
		-0.370727,
		0,
		-0.129163,
		-0.986678,
		-0.098907,
		0,
		-0.357488,
		0.139367,
		-0.92346,
		0,
		-0.242908,
		0.06567,
		-0.436432,
		1
	},
	[0.55] = {
		0.927908,
		-0.092613,
		-0.361123,
		0,
		-0.120606,
		-0.991136,
		-0.055714,
		0,
		-0.352762,
		0.095251,
		-0.930852,
		0,
		-0.234081,
		0.046483,
		-0.432953,
		1
	},
	[0.566666666667] = {
		0.931467,
		-0.099057,
		-0.350081,
		0,
		-0.118235,
		-0.992411,
		-0.033783,
		0,
		-0.344077,
		0.07286,
		-0.93611,
		0,
		-0.223549,
		0.024405,
		-0.43051,
		1
	},
	[0.583333333333] = {
		0.935454,
		-0.10382,
		-0.337858,
		0,
		-0.121169,
		-0.99216,
		-0.03061,
		0,
		-0.332031,
		0.069572,
		-0.940699,
		0,
		-0.211501,
		-0.000108,
		-0.428727,
		1
	},
	[0.5] = {
		0.921841,
		-0.05761,
		-0.383263,
		0,
		-0.167622,
		-0.950882,
		-0.260241,
		0,
		-0.349445,
		0.304144,
		-0.886219,
		0,
		-0.255314,
		0.093943,
		-0.450116,
		1
	},
	[0.616666666667] = {
		0.944208,
		-0.110361,
		-0.310309,
		0,
		-0.139312,
		-0.987579,
		-0.072667,
		0,
		-0.298435,
		0.111843,
		-0.947854,
		0,
		-0.183954,
		-0.054617,
		-0.426927,
		1
	},
	[0.633333333333] = {
		0.948746,
		-0.113114,
		-0.295102,
		0,
		-0.152639,
		-0.981631,
		-0.114465,
		0,
		-0.276734,
		0.153642,
		-0.948584,
		0,
		-0.169098,
		-0.083723,
		-0.427199,
		1
	},
	[0.65] = {
		0.953229,
		-0.116111,
		-0.279055,
		0,
		-0.167469,
		-0.971485,
		-0.16784,
		0,
		-0.25161,
		0.206723,
		-0.945493,
		0,
		-0.153954,
		-0.113425,
		-0.428584,
		1
	},
	[0.666666666667] = {
		0.957522,
		-0.119736,
		-0.262328,
		0,
		-0.182738,
		-0.955687,
		-0.230801,
		0,
		-0.223068,
		0.268934,
		-0.936971,
		0,
		-0.138825,
		-0.143185,
		-0.431346,
		1
	},
	[0.683333333333] = {
		0.961481,
		-0.124305,
		-0.24516,
		0,
		-0.197364,
		-0.932985,
		-0.300976,
		0,
		-0.191317,
		0.337768,
		-0.92158,
		0,
		-0.12397,
		-0.172409,
		-0.435698,
		1
	},
	[0.6] = {
		0.939739,
		-0.107422,
		-0.324579,
		0,
		-0.128502,
		-0.990726,
		-0.044158,
		0,
		-0.316825,
		0.083206,
		-0.944827,
		0,
		-0.198198,
		-0.026596,
		-0.427504,
		1
	},
	[0.716666666667] = {
		0.967859,
		-0.136998,
		-0.210905,
		0,
		-0.220777,
		-0.864456,
		-0.451634,
		0,
		-0.120445,
		0.483681,
		-0.866917,
		0,
		-0.09589,
		-0.226715,
		-0.449424,
		1
	},
	[0.733333333333] = {
		0.970084,
		-0.145119,
		-0.19462,
		0,
		-0.228088,
		-0.819368,
		-0.525939,
		0,
		-0.083142,
		0.554596,
		-0.827956,
		0,
		-0.082963,
		-0.250579,
		-0.458518,
		1
	},
	[0.75] = {
		0.971614,
		-0.154195,
		-0.179419,
		0,
		-0.232031,
		-0.769039,
		-0.595601,
		0,
		-0.046141,
		0.620324,
		-0.782987,
		0,
		-0.070938,
		-0.271585,
		-0.468627,
		1
	},
	[0.766666666667] = {
		0.97248,
		-0.163863,
		-0.165622,
		0,
		-0.232737,
		-0.715962,
		-0.658203,
		0,
		-0.010724,
		0.678636,
		-0.734396,
		0,
		-0.059948,
		-0.289419,
		-0.479216,
		1
	},
	[0.783333333333] = {
		0.972776,
		-0.173676,
		-0.153441,
		0,
		-0.230711,
		-0.663182,
		-0.712013,
		0,
		0.0219,
		0.728029,
		-0.685196,
		0,
		-0.050163,
		-0.303944,
		-0.489674,
		1
	},
	[0.7] = {
		0.964965,
		-0.130029,
		-0.227894,
		0,
		-0.210332,
		-0.902595,
		-0.375611,
		0,
		-0.156855,
		0.410384,
		-0.898321,
		0,
		-0.109604,
		-0.200463,
		-0.441741,
		1
	},
	[0.816666666667] = {
		0.972226,
		-0.191775,
		-0.134163,
		0,
		-0.221778,
		-0.571724,
		-0.789903,
		0,
		0.074779,
		0.797718,
		-0.598376,
		0,
		-0.035127,
		-0.323308,
		-0.507701,
		1
	},
	[0.833333333333] = {
		0.971719,
		-0.199115,
		-0.126944,
		0,
		-0.216827,
		-0.539428,
		-0.813636,
		0,
		0.09353,
		0.818151,
		-0.567346,
		0,
		-0.030453,
		-0.328513,
		-0.514125,
		1
	},
	[0.85] = {
		0.971284,
		-0.204755,
		-0.121173,
		0,
		-0.212807,
		-0.519886,
		-0.827304,
		0,
		0.106399,
		0.829333,
		-0.54853,
		0,
		-0.028106,
		-0.331009,
		-0.518163,
		1
	},
	[0.866666666667] = {
		0.970977,
		-0.208736,
		-0.116763,
		0,
		-0.20986,
		-0.509363,
		-0.83457,
		0,
		0.11473,
		0.834852,
		-0.538385,
		0,
		-0.026807,
		-0.332116,
		-0.520436,
		1
	},
	[0.883333333333] = {
		0.970772,
		-0.21142,
		-0.11359,
		0,
		-0.207599,
		-0.502215,
		-0.839454,
		0,
		0.120431,
		0.8385,
		-0.531427,
		0,
		-0.025114,
		-0.333083,
		-0.521913,
		1
	},
	[0.8] = {
		0.972636,
		-0.183143,
		-0.142962,
		0,
		-0.226739,
		-0.614004,
		-0.756035,
		0,
		0.050683,
		0.767762,
		-0.638728,
		0,
		-0.041799,
		-0.315189,
		-0.49937,
		1
	},
	[0.916666666667] = {
		0.970719,
		-0.213402,
		-0.11029,
		0,
		-0.204991,
		-0.496548,
		-0.843456,
		0,
		0.125231,
		0.841368,
		-0.525754,
		0,
		-0.020847,
		-0.334709,
		-0.522849,
		1
	},
	[0.933333333333] = {
		0.970861,
		-0.21297,
		-0.109877,
		0,
		-0.204503,
		-0.497257,
		-0.843157,
		0,
		0.12493,
		0.841058,
		-0.526321,
		0,
		-0.018411,
		-0.335394,
		-0.522495,
		1
	},
	[0.95] = {
		0.971095,
		-0.211776,
		-0.110116,
		0,
		-0.204436,
		-0.4998,
		-0.841669,
		0,
		0.12321,
		0.839852,
		-0.528648,
		0,
		-0.015859,
		-0.336001,
		-0.521716,
		1
	},
	[0.966666666667] = {
		0.971402,
		-0.209965,
		-0.110872,
		0,
		-0.204679,
		-0.503793,
		-0.839225,
		0,
		0.120351,
		0.837918,
		-0.532361,
		0,
		-0.013252,
		-0.336534,
		-0.520609,
		1
	},
	[0.983333333333] = {
		0.971758,
		-0.207679,
		-0.112051,
		0,
		-0.205146,
		-0.50881,
		-0.836079,
		0,
		0.116624,
		0.835453,
		-0.537044,
		0,
		-0.010652,
		-0.33699,
		-0.519263,
		1
	},
	[0.9] = {
		0.970686,
		-0.212932,
		-0.111481,
		0,
		-0.205995,
		-0.498069,
		-0.842314,
		0,
		0.123831,
		0.840588,
		-0.527332,
		0,
		-0.023104,
		-0.333942,
		-0.522687,
		1
	},
	[1.01666666667] = {
		0.972549,
		-0.202251,
		-0.115082,
		0,
		-0.206281,
		-0.520449,
		-0.828602,
		0,
		0.107691,
		0.829595,
		-0.547882,
		0,
		-0.005719,
		-0.337697,
		-0.516249,
		1
	},
	[1.03333333333] = {
		0.972951,
		-0.19938,
		-0.116677,
		0,
		-0.206758,
		-0.526289,
		-0.824785,
		0,
		0.10304,
		0.8266,
		-0.553277,
		0,
		-0.003511,
		-0.337961,
		-0.514767,
		1
	},
	[1.05] = {
		0.973334,
		-0.196627,
		-0.118148,
		0,
		-0.207088,
		-0.531641,
		-0.821262,
		0,
		0.09867,
		0.82383,
		-0.558184,
		0,
		-0.001557,
		-0.338183,
		-0.513429,
		1
	},
	[1.06666666667] = {
		0.973698,
		-0.194077,
		-0.119354,
		0,
		-0.207167,
		-0.536107,
		-0.818334,
		0,
		0.094833,
		0.821537,
		-0.562213,
		0,
		7.3e-05,
		-0.338372,
		-0.512324,
		1
	},
	[1.08333333333] = {
		0.974046,
		-0.191857,
		-0.120103,
		0,
		-0.206881,
		-0.539315,
		-0.816296,
		0,
		0.091839,
		0.819957,
		-0.565009,
		0,
		0.001317,
		-0.338546,
		-0.511544,
		1
	},
	{
		0.972147,
		-0.20506,
		-0.113496,
		0,
		-0.205712,
		-0.514492,
		-0.832455,
		0,
		0.11231,
		0.832616,
		-0.542345,
		0,
		-0.008121,
		-0.337376,
		-0.517778,
		1
	},
	[1.1] = {
		0.974362,
		-0.190102,
		-0.120333,
		0,
		-0.206228,
		-0.540837,
		-0.815454,
		0,
		0.089939,
		0.819364,
		-0.566175,
		0,
		0.002104,
		-0.338715,
		-0.511174,
		1
	}
}

return spline_matrices
