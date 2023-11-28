﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_knife/heavy_swing_stab_01.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.007327,
		-0.237184,
		0.971437,
		0,
		0.999175,
		-0.037077,
		-0.016588,
		0,
		0.039952,
		0.970757,
		0.236716,
		0,
		-0.186275,
		0.314592,
		-0.147906,
		1
	},
	[0.0333333333333] = {
		0.043629,
		-0.216663,
		0.975271,
		0,
		0.994384,
		-0.084794,
		-0.063322,
		0,
		0.096417,
		0.972557,
		0.211746,
		0,
		-0.199542,
		0.284688,
		-0.150302,
		1
	},
	[0.05] = {
		0.079583,
		-0.198292,
		0.976907,
		0,
		0.984689,
		-0.136839,
		-0.107993,
		0,
		0.155093,
		0.970544,
		0.184366,
		0,
		-0.218399,
		0.250056,
		-0.154184,
		1
	},
	[0.0666666666667] = {
		0.118714,
		-0.183511,
		0.975823,
		0,
		0.971685,
		-0.180732,
		-0.152199,
		0,
		0.204293,
		0.966261,
		0.156859,
		0,
		-0.24009,
		0.213919,
		-0.155282,
		1
	},
	[0.0833333333333] = {
		0.164386,
		-0.177505,
		0.970293,
		0,
		0.958466,
		-0.203682,
		-0.199643,
		0,
		0.233069,
		0.962811,
		0.13665,
		0,
		-0.261734,
		0.180112,
		-0.147261,
		1
	},
	[0] = {
		-0.033609,
		-0.260991,
		0.964756,
		0,
		0.999432,
		-0.006556,
		0.033044,
		0,
		-0.002299,
		0.965319,
		0.261063,
		0,
		-0.181366,
		0.336843,
		-0.149624,
		1
	},
	[0.116666666667] = {
		0.31576,
		-0.205497,
		0.926319,
		0,
		0.934831,
		-0.099757,
		-0.340792,
		0,
		0.162439,
		0.97356,
		0.160606,
		0,
		-0.290135,
		0.131402,
		-0.104183,
		1
	},
	[0.133333333333] = {
		0.44217,
		-0.224231,
		0.868451,
		0,
		0.895883,
		0.063604,
		-0.439715,
		0,
		0.043361,
		0.972458,
		0.229008,
		0,
		-0.286984,
		0.123357,
		-0.076189,
		1
	},
	[0.15] = {
		0.545024,
		-0.223527,
		0.808074,
		0,
		0.836321,
		0.213109,
		-0.505126,
		0,
		-0.059299,
		0.951115,
		0.303089,
		0,
		-0.274516,
		0.128719,
		-0.051065,
		1
	},
	[0.166666666667] = {
		0.57953,
		-0.222827,
		0.783896,
		0,
		0.808897,
		0.274308,
		-0.52004,
		0,
		-0.09915,
		0.935469,
		0.339214,
		0,
		-0.260668,
		0.147658,
		-0.030295,
		1
	},
	[0.183333333333] = {
		0.485862,
		-0.253899,
		0.836345,
		0,
		0.874006,
		0.148963,
		-0.462519,
		0,
		-0.007151,
		0.955691,
		0.294285,
		0,
		-0.249816,
		0.194219,
		-0.01666,
		1
	},
	[0.1] = {
		0.220599,
		-0.183132,
		0.958018,
		0,
		0.947598,
		-0.192456,
		-0.254989,
		0,
		0.231073,
		0.964066,
		0.13108,
		0,
		-0.280097,
		0.152301,
		-0.129497,
		1
	},
	[0.216666666667] = {
		0.241379,
		-0.115896,
		0.963486,
		0,
		0.967435,
		-0.049224,
		-0.248289,
		0,
		0.076202,
		0.992041,
		0.10024,
		0,
		-0.130261,
		0.462388,
		-0.005382,
		1
	},
	[0.233333333333] = {
		0.153079,
		-0.006824,
		0.98819,
		0,
		0.987492,
		-0.037169,
		-0.153227,
		0,
		0.037776,
		0.999286,
		0.001049,
		0,
		-0.054249,
		0.619373,
		-0.007492,
		1
	},
	[0.25] = {
		0.10727,
		-0.005916,
		0.994212,
		0,
		0.992547,
		-0.057521,
		-0.107432,
		0,
		0.057824,
		0.998327,
		-0.000299,
		0,
		-0.035911,
		0.621638,
		-0.010262,
		1
	},
	[0.266666666667] = {
		0.075961,
		-0.035501,
		0.996479,
		0,
		0.993534,
		-0.081882,
		-0.078653,
		0,
		0.084386,
		0.996009,
		0.029052,
		0,
		-0.01716,
		0.617643,
		-0.010604,
		1
	},
	[0.283333333333] = {
		0.027688,
		-0.066459,
		0.997405,
		0,
		0.995002,
		-0.093928,
		-0.03388,
		0,
		0.095936,
		0.993358,
		0.063527,
		0,
		-0.035457,
		0.604596,
		-0.012879,
		1
	},
	[0.2] = {
		0.34117,
		-0.238214,
		0.909317,
		0,
		0.934204,
		-0.02135,
		-0.3561,
		0,
		0.104242,
		0.970978,
		0.215257,
		0,
		-0.22698,
		0.269923,
		-0.009805,
		1
	},
	[0.316666666667] = {
		0.030185,
		-0.088498,
		0.995619,
		0,
		0.994107,
		-0.101097,
		-0.039126,
		0,
		0.104117,
		0.990933,
		0.084925,
		0,
		-0.054291,
		0.59692,
		-0.018341,
		1
	},
	[0.333333333333] = {
		0.082631,
		-0.077717,
		0.993545,
		0,
		0.99083,
		-0.100534,
		-0.090269,
		0,
		0.1069,
		0.991894,
		0.068698,
		0,
		-0.053036,
		0.60187,
		-0.023239,
		1
	},
	[0.35] = {
		0.127588,
		-0.069814,
		0.989367,
		0,
		0.985838,
		-0.100531,
		-0.134227,
		0,
		0.108833,
		0.992481,
		0.055999,
		0,
		-0.051282,
		0.607145,
		-0.026043,
		1
	},
	[0.366666666667] = {
		0.141162,
		-0.06862,
		0.987605,
		0,
		0.984478,
		-0.095357,
		-0.147341,
		0,
		0.104286,
		0.993075,
		0.054094,
		0,
		-0.049948,
		0.611859,
		-0.027763,
		1
	},
	[0.383333333333] = {
		0.126773,
		-0.077515,
		0.988898,
		0,
		0.986896,
		-0.090472,
		-0.133608,
		0,
		0.099824,
		0.992878,
		0.06503,
		0,
		-0.048449,
		0.618479,
		-0.031929,
		1
	},
	[0.3] = {
		-0.000783,
		-0.094653,
		0.99551,
		0,
		0.994494,
		-0.104395,
		-0.009143,
		0,
		0.104791,
		0.990022,
		0.094213,
		0,
		-0.05388,
		0.593149,
		-0.015758,
		1
	},
	[0.416666666667] = {
		0.053875,
		-0.117152,
		0.991652,
		0,
		0.993849,
		-0.089933,
		-0.064619,
		0,
		0.096753,
		0.989034,
		0.111586,
		0,
		-0.045752,
		0.635041,
		-0.044537,
		1
	},
	[0.433333333333] = {
		-0.001156,
		-0.146028,
		0.98928,
		0,
		0.994813,
		-0.100787,
		-0.013715,
		0,
		0.101709,
		0.984133,
		0.145387,
		0,
		-0.046126,
		0.638801,
		-0.052617,
		1
	},
	[0.45] = {
		-0.052911,
		-0.173034,
		0.983494,
		0,
		0.993836,
		-0.105201,
		0.034959,
		0,
		0.097415,
		0.979281,
		0.177533,
		0,
		-0.052695,
		0.628015,
		-0.060863,
		1
	},
	[0.466666666667] = {
		-0.094581,
		-0.195097,
		0.976213,
		0,
		0.992237,
		-0.098011,
		0.076546,
		0,
		0.080745,
		0.975875,
		0.202852,
		0,
		-0.068035,
		0.598777,
		-0.068875,
		1
	},
	[0.483333333333] = {
		-0.126886,
		-0.214235,
		0.968506,
		0,
		0.990732,
		-0.075085,
		0.113189,
		0,
		0.048472,
		0.973892,
		0.221776,
		0,
		-0.089018,
		0.5563,
		-0.077335,
		1
	},
	[0.4] = {
		0.095243,
		-0.093676,
		0.991037,
		0,
		0.990675,
		-0.088515,
		-0.103575,
		0,
		0.097424,
		0.99166,
		0.084372,
		0,
		-0.046847,
		0.627315,
		-0.037704,
		1
	},
	[0.516666666667] = {
		-0.17401,
		-0.250084,
		0.952459,
		0,
		0.983365,
		0.007048,
		0.181506,
		0,
		-0.052104,
		0.968199,
		0.244697,
		0,
		-0.135533,
		0.454711,
		-0.09806,
		1
	},
	[0.533333333333] = {
		-0.187405,
		-0.262235,
		0.946632,
		0,
		0.97609,
		0.058332,
		0.209396,
		0,
		-0.11013,
		0.96324,
		0.245033,
		0,
		-0.154926,
		0.407459,
		-0.109856,
		1
	},
	[0.55] = {
		-0.194235,
		-0.266776,
		0.943983,
		0,
		0.966699,
		0.111409,
		0.230394,
		0,
		-0.166632,
		0.957298,
		0.236252,
		0,
		-0.167717,
		0.370454,
		-0.122312,
		1
	},
	[0.566666666667] = {
		-0.192391,
		-0.262082,
		0.945674,
		0,
		0.955056,
		0.171448,
		0.241814,
		0,
		-0.225509,
		0.949694,
		0.217318,
		0,
		-0.174784,
		0.340084,
		-0.134895,
		1
	},
	[0.583333333333] = {
		-0.182109,
		-0.248756,
		0.951292,
		0,
		0.939013,
		0.243018,
		0.243306,
		0,
		-0.291705,
		0.937583,
		0.18933,
		0,
		-0.179194,
		0.309731,
		-0.147197,
		1
	},
	[0.5] = {
		-0.153716,
		-0.23324,
		0.960193,
		0,
		0.988112,
		-0.038716,
		0.148781,
		0,
		0.002473,
		0.971648,
		0.236419,
		0,
		-0.112552,
		0.506299,
		-0.087142,
		1
	},
	[0.616666666667] = {
		-0.153768,
		-0.199356,
		0.967787,
		0,
		0.888653,
		0.400338,
		0.223661,
		0,
		-0.432031,
		0.89442,
		0.115599,
		0,
		-0.181507,
		0.254468,
		-0.171422,
		1
	},
	[0.633333333333] = {
		-0.144056,
		-0.16893,
		0.975044,
		0,
		0.855669,
		0.473672,
		0.208485,
		0,
		-0.497071,
		0.864348,
		0.076312,
		0,
		-0.180385,
		0.232194,
		-0.183874,
		1
	},
	[0.65] = {
		-0.141504,
		-0.138544,
		0.980195,
		0,
		0.820511,
		0.537549,
		0.19443,
		0,
		-0.55384,
		0.831773,
		0.037612,
		0,
		-0.178457,
		0.215004,
		-0.19685,
		1
	},
	[0.666666666667] = {
		-0.148399,
		-0.111202,
		0.982656,
		0,
		0.786454,
		0.589153,
		0.18544,
		0,
		-0.599556,
		0.800333,
		2.6e-05,
		0,
		-0.176275,
		0.203875,
		-0.210543,
		1
	},
	[0.683333333333] = {
		-0.166547,
		-0.089836,
		0.981933,
		0,
		0.756925,
		0.62656,
		0.185706,
		0,
		-0.631923,
		0.774178,
		-0.036353,
		0,
		-0.17438,
		0.199703,
		-0.22514,
		1
	},
	[0.6] = {
		-0.16773,
		-0.227104,
		0.959318,
		0,
		0.91695,
		0.321421,
		0.236414,
		0,
		-0.362035,
		0.9193,
		0.154331,
		0,
		-0.181287,
		0.280738,
		-0.15929,
		1
	},
	[0.716666666667] = {
		-0.226955,
		-0.058477,
		0.972148,
		0,
		0.710449,
		0.672822,
		0.206331,
		0,
		-0.666148,
		0.73749,
		-0.111155,
		0,
		-0.17141,
		0.203875,
		-0.260355,
		1
	},
	[0.733333333333] = {
		-0.26455,
		-0.04491,
		0.963326,
		0,
		0.691228,
		0.687728,
		0.221888,
		0,
		-0.672471,
		0.724578,
		-0.150895,
		0,
		-0.170056,
		0.208994,
		-0.281044,
		1
	},
	[0.75] = {
		-0.305845,
		-0.032504,
		0.951526,
		0,
		0.674044,
		0.69844,
		0.240514,
		0,
		-0.672402,
		0.71493,
		-0.191706,
		0,
		-0.168767,
		0.215616,
		-0.303134,
		1
	},
	[0.766666666667] = {
		-0.34996,
		-0.021234,
		0.936524,
		0,
		0.658288,
		0.705705,
		0.261989,
		0,
		-0.666472,
		0.708188,
		-0.23299,
		0,
		-0.167523,
		0.223439,
		-0.326089,
		1
	},
	[0.783333333333] = {
		-0.396029,
		-0.010784,
		0.918175,
		0,
		0.643319,
		0.710245,
		0.28582,
		0,
		-0.655211,
		0.703872,
		-0.274339,
		0,
		-0.166304,
		0.232089,
		-0.349433,
		1
	},
	[0.7] = {
		-0.193969,
		-0.073312,
		0.978264,
		0,
		0.732229,
		0.652812,
		0.194108,
		0,
		-0.652853,
		0.753964,
		-0.072944,
		0,
		-0.172848,
		0.20062,
		-0.241574,
		1
	},
	[0.816666666667] = {
		-0.490653,
		0.008708,
		0.871312,
		0,
		0.613306,
		0.713761,
		0.338232,
		0,
		-0.618963,
		0.700335,
		-0.355549,
		0,
		-0.16387,
		0.250406,
		-0.395351,
		1
	},
	[0.833333333333] = {
		-0.537591,
		0.018119,
		0.843011,
		0,
		0.597209,
		0.71397,
		0.365497,
		0,
		-0.595262,
		0.699942,
		-0.394645,
		0,
		-0.162635,
		0.259349,
		-0.416936,
		1
	},
	[0.85] = {
		-0.583285,
		0.027427,
		0.811804,
		0,
		0.579848,
		0.713945,
		0.392503,
		0,
		-0.568818,
		0.699665,
		-0.432337,
		0,
		-0.161388,
		0.267671,
		-0.43693,
		1
	},
	[0.866666666667] = {
		-0.627081,
		0.036616,
		0.778093,
		0,
		0.560966,
		0.714275,
		0.418482,
		0,
		-0.540449,
		0.698906,
		-0.468449,
		0,
		-0.160139,
		0.275015,
		-0.454816,
		1
	},
	[0.883333333333] = {
		-0.668426,
		0.04559,
		0.74238,
		0,
		0.540428,
		0.715542,
		0.442649,
		0,
		-0.511023,
		0.697081,
		-0.502925,
		0,
		-0.158912,
		0.28103,
		-0.470069,
		1
	},
	[0.8] = {
		-0.443202,
		-0.000877,
		0.896421,
		0,
		0.628515,
		0.712721,
		0.311443,
		0,
		-0.639172,
		0.701447,
		-0.315328,
		0,
		-0.165091,
		0.2412,
		-0.372684,
		1
	},
	[0.916666666667] = {
		-0.742125,
		0.062149,
		0.667374,
		0,
		0.494369,
		0.723109,
		0.482403,
		0,
		-0.452603,
		0.687932,
		-0.567362,
		0,
		-0.156664,
		0.287678,
		-0.490542,
		1
	},
	[0.933333333333] = {
		-0.773966,
		0.069211,
		0.629434,
		0,
		0.469048,
		0.730444,
		0.496434,
		0,
		-0.425407,
		0.679457,
		-0.597802,
		0,
		-0.155737,
		0.287631,
		-0.49468,
		1
	},
	[0.95] = {
		-0.775084,
		0.068759,
		0.628106,
		0,
		0.466848,
		0.732186,
		0.49594,
		0,
		-0.42579,
		0.677625,
		-0.599606,
		0,
		-0.155521,
		0.286498,
		-0.495406,
		1
	},
	[0.966666666667] = {
		-0.77615,
		0.068443,
		0.626822,
		0,
		0.464786,
		0.733874,
		0.495381,
		0,
		-0.426103,
		0.675828,
		-0.601408,
		0,
		-0.155289,
		0.285367,
		-0.49613,
		1
	},
	[0.983333333333] = {
		-0.777151,
		0.068281,
		0.625599,
		0,
		0.462898,
		0.735485,
		0.49476,
		0,
		-0.426336,
		0.674092,
		-0.60319,
		0,
		-0.155043,
		0.284252,
		-0.496847,
		1
	},
	[0.9] = {
		-0.70688,
		0.05418,
		0.705256,
		0,
		0.518206,
		0.718307,
		0.464217,
		0,
		-0.481439,
		0.693613,
		-0.535833,
		0,
		-0.15774,
		0.285365,
		-0.482157,
		1
	},
	[1.01666666667] = {
		-0.7789,
		0.06849,
		0.623397,
		0,
		0.459781,
		0.738384,
		0.493347,
		0,
		-0.426517,
		0.670894,
		-0.606617,
		0,
		-0.154507,
		0.282119,
		-0.498228,
		1
	},
	[1.03333333333] = {
		-0.779622,
		0.068896,
		0.622449,
		0,
		0.458622,
		0.739628,
		0.492561,
		0,
		-0.426445,
		0.669481,
		-0.608228,
		0,
		-0.154217,
		0.281127,
		-0.498878,
		1
	},
	[1.05] = {
		-0.780226,
		0.069528,
		0.621622,
		0,
		0.457777,
		0.740705,
		0.491729,
		0,
		-0.42625,
		0.668224,
		-0.609745,
		0,
		-0.153913,
		0.280202,
		-0.499492,
		1
	},
	[1.06666666667] = {
		-0.780696,
		0.070402,
		0.620932,
		0,
		0.457279,
		0.741592,
		0.490854,
		0,
		-0.425921,
		0.667147,
		-0.611151,
		0,
		-0.153596,
		0.279356,
		-0.500063,
		1
	},
	[1.08333333333] = {
		-0.781014,
		0.071601,
		0.620395,
		0,
		0.457226,
		0.742229,
		0.489939,
		0,
		-0.425395,
		0.66631,
		-0.612429,
		0,
		-0.153243,
		0.278615,
		-0.500584,
		1
	},
	{
		-0.778071,
		0.068291,
		0.624453,
		0,
		0.461218,
		0.736995,
		0.494081,
		0,
		-0.426477,
		0.672439,
		-0.604932,
		0,
		-0.154782,
		0.283165,
		-0.497548,
		1
	},
	[1.11666666667] = {
		-0.781149,
		0.0749,
		0.619836,
		0,
		0.458449,
		0.742746,
		0.488009,
		0,
		-0.423829,
		0.665371,
		-0.614533,
		0,
		-0.152479,
		0.277472,
		-0.501452,
		1
	},
	[1.13333333333] = {
		-0.7809,
		0.076812,
		0.619916,
		0,
		0.459625,
		0.742711,
		0.486956,
		0,
		-0.423014,
		0.665192,
		-0.615287,
		0,
		-0.152195,
		0.277049,
		-0.501771,
		1
	},
	[1.15] = {
		-0.780413,
		0.078774,
		0.620282,
		0,
		0.461095,
		0.742537,
		0.48583,
		0,
		-0.422311,
		0.665157,
		-0.615808,
		0,
		-0.152046,
		0.276713,
		-0.502002,
		1
	},
	[1.16666666667] = {
		-0.779772,
		0.080694,
		0.620841,
		0,
		0.462719,
		0.742267,
		0.484697,
		0,
		-0.421718,
		0.665228,
		-0.616138,
		0,
		-0.152001,
		0.276454,
		-0.502158,
		1
	},
	[1.18333333333] = {
		-0.779059,
		0.082476,
		0.621502,
		0,
		0.464359,
		0.741945,
		0.48362,
		0,
		-0.421233,
		0.665369,
		-0.616317,
		0,
		-0.152031,
		0.276263,
		-0.502255,
		1
	},
	[1.1] = {
		-0.781166,
		0.073131,
		0.620025,
		0,
		0.457641,
		0.7426,
		0.48899,
		0,
		-0.42467,
		0.665731,
		-0.613562,
		0,
		-0.152857,
		0.277991,
		-0.501049,
		1
	},
	[1.21666666667] = {
		-0.77775,
		0.085252,
		0.622765,
		0,
		0.46713,
		0.741324,
		0.481901,
		0,
		-0.420587,
		0.665711,
		-0.616389,
		0,
		-0.152195,
		0.276046,
		-0.502324,
		1
	},
	[1.23333333333] = {
		-0.777324,
		0.086057,
		0.623186,
		0,
		0.467984,
		0.741116,
		0.481393,
		0,
		-0.420426,
		0.665839,
		-0.61636,
		0,
		-0.152271,
		0.276003,
		-0.502325,
		1
	},
	[1.25] = {
		-0.777163,
		0.086346,
		0.623347,
		0,
		0.468299,
		0.741036,
		0.481208,
		0,
		-0.420372,
		0.66589,
		-0.616342,
		0,
		-0.152303,
		0.27599,
		-0.502322,
		1
	},
	[1.2] = {
		-0.778357,
		0.084027,
		0.622174,
		0,
		0.465876,
		0.741615,
		0.482666,
		0,
		-0.420856,
		0.665542,
		-0.616388,
		0,
		-0.152106,
		0.27613,
		-0.502305,
		1
	}
}

return spline_matrices
