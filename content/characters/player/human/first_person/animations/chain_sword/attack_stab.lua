﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_sword/attack_stab.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.377246,
		-0.077785,
		0.922841,
		0,
		0.922667,
		0.11745,
		-0.367275,
		0,
		-0.079819,
		0.990028,
		0.116077,
		0,
		0.390762,
		-0.526327,
		-0.261502,
		1,
	},
	[0.0333333333333] = {
		0.376847,
		-0.077861,
		0.922997,
		0,
		0.922696,
		0.119075,
		-0.366679,
		0,
		-0.081356,
		0.989828,
		0.116715,
		0,
		0.391689,
		-0.525565,
		-0.261646,
		1,
	},
	[0.05] = {
		0.376262,
		-0.077973,
		0.923227,
		0,
		0.922734,
		0.121447,
		-0.365804,
		0,
		-0.0836,
		0.989531,
		0.117644,
		0,
		0.393043,
		-0.524449,
		-0.261854,
		1,
	},
	[0.0666666666667] = {
		0.375557,
		-0.078107,
		0.923502,
		0,
		0.922773,
		0.124291,
		-0.364748,
		0,
		-0.086293,
		0.989167,
		0.118754,
		0,
		0.394665,
		-0.523107,
		-0.262098,
		1,
	},
	[0.0833333333333] = {
		0.374798,
		-0.078252,
		0.923798,
		0,
		0.922807,
		0.127333,
		-0.363611,
		0,
		-0.089177,
		0.988768,
		0.119935,
		0,
		0.396399,
		-0.521667,
		-0.262353,
		1,
	},
	[0] = {
		0.377394,
		-0.077756,
		0.922783,
		0,
		0.922656,
		0.116847,
		-0.367496,
		0,
		-0.07925,
		0.990101,
		0.11584,
		0,
		0.390417,
		-0.526609,
		-0.261447,
		1,
	},
	[0.116666666667] = {
		0.373395,
		-0.078517,
		0.924344,
		0,
		0.922849,
		0.13292,
		-0.3615,
		0,
		-0.09448,
		0.988012,
		0.122091,
		0,
		0.399579,
		-0.519006,
		-0.262805,
		1,
	},
	[0.133333333333] = {
		0.372888,
		-0.078613,
		0.92454,
		0,
		0.922857,
		0.134924,
		-0.360737,
		0,
		-0.096384,
		0.987733,
		0.12286,
		0,
		0.400718,
		-0.518048,
		-0.262962,
		1,
	},
	[0.15] = {
		0.372522,
		-0.078682,
		0.924682,
		0,
		0.92286,
		0.136367,
		-0.360184,
		0,
		-0.097756,
		0.987529,
		0.123412,
		0,
		0.401539,
		-0.517355,
		-0.263074,
		1,
	},
	[0.166666666667] = {
		0.372233,
		-0.078736,
		0.924794,
		0,
		0.922862,
		0.137503,
		-0.359749,
		0,
		-0.098837,
		0.987367,
		0.123846,
		0,
		0.402184,
		-0.51681,
		-0.26316,
		1,
	},
	[0.183333333333] = {
		0.372017,
		-0.078777,
		0.924877,
		0,
		0.922862,
		0.138351,
		-0.359422,
		0,
		-0.099644,
		0.987245,
		0.124169,
		0,
		0.402666,
		-0.516402,
		-0.263224,
		1,
	},
	[0.1] = {
		0.374055,
		-0.078393,
		0.924087,
		0,
		0.922833,
		0.1303,
		-0.362493,
		0,
		-0.091992,
		0.988371,
		0.121083,
		0,
		0.398088,
		-0.520256,
		-0.262596,
		1,
	},
	[0.216666666667] = {
		0.371783,
		-0.078821,
		0.924967,
		0,
		0.922862,
		0.139266,
		-0.35907,
		0,
		-0.100514,
		0.987113,
		0.124518,
		0,
		0.403185,
		-0.515961,
		-0.263293,
		1,
	},
	[0.233333333333] = {
		0.371756,
		-0.078826,
		0.924978,
		0,
		0.922862,
		0.139373,
		-0.359028,
		0,
		-0.100616,
		0.987098,
		0.124558,
		0,
		0.403246,
		-0.51591,
		-0.263301,
		1,
	},
	[0.25] = {
		0.172829,
		-0.110946,
		0.978683,
		0,
		0.977076,
		0.144719,
		-0.156139,
		0,
		-0.124311,
		0.983233,
		0.133414,
		0,
		0.370835,
		-0.354252,
		-0.212668,
		1,
	},
	[0.266666666667] = {
		-0.124961,
		-0.138336,
		0.98247,
		0,
		0.978849,
		0.144478,
		0.144844,
		0,
		-0.161983,
		0.97979,
		0.117356,
		0,
		0.312287,
		-0.093154,
		-0.150952,
		1,
	},
	[0.283333333333] = {
		-0.320281,
		-0.13045,
		0.938298,
		0,
		0.933704,
		0.123875,
		0.335935,
		0,
		-0.160054,
		0.983686,
		0.082127,
		0,
		0.246937,
		0.140087,
		-0.13053,
		1,
	},
	[0.2] = {
		0.371869,
		-0.078805,
		0.924934,
		0,
		0.922862,
		0.138932,
		-0.359198,
		0,
		-0.100197,
		0.987161,
		0.124391,
		0,
		0.402996,
		-0.516122,
		-0.263268,
		1,
	},
	[0.316666666667] = {
		-0.631587,
		-0.120873,
		0.765824,
		0,
		0.764722,
		0.065521,
		0.64102,
		0,
		-0.12766,
		0.990503,
		0.051052,
		0,
		0.114741,
		0.604116,
		-0.098682,
		1,
	},
	[0.333333333333] = {
		-0.678441,
		-0.11987,
		0.72481,
		0,
		0.725026,
		0.049965,
		0.686907,
		0,
		-0.118554,
		0.991532,
		0.05301,
		0,
		0.090287,
		0.689363,
		-0.085124,
		1,
	},
	[0.35] = {
		-0.670095,
		-0.128967,
		0.730986,
		0,
		0.732194,
		0.046905,
		0.679479,
		0,
		-0.121917,
		0.990539,
		0.062998,
		0,
		0.092093,
		0.679187,
		-0.077636,
		1,
	},
	[0.366666666667] = {
		-0.660596,
		-0.146363,
		0.736336,
		0,
		0.739106,
		0.045224,
		0.672069,
		0,
		-0.131666,
		0.988197,
		0.078303,
		0,
		0.093554,
		0.669196,
		-0.076707,
		1,
	},
	[0.383333333333] = {
		-0.659165,
		-0.156286,
		0.735579,
		0,
		0.739352,
		0.04395,
		0.671883,
		0,
		-0.137334,
		0.986734,
		0.08658,
		0,
		0.09303,
		0.6697,
		-0.075781,
		1,
	},
	[0.3] = {
		-0.503593,
		-0.123523,
		0.855065,
		0,
		0.851871,
		0.093864,
		0.515272,
		0,
		-0.143908,
		0.987893,
		0.057956,
		0,
		0.174488,
		0.396695,
		-0.11392,
		1,
	},
	[0.416666666667] = {
		-0.660994,
		-0.144282,
		0.73639,
		0,
		0.738255,
		0.050742,
		0.67261,
		0,
		-0.134411,
		0.988235,
		0.072977,
		0,
		0.086558,
		0.66896,
		-0.059973,
		1,
	},
	[0.433333333333] = {
		-0.662333,
		-0.135609,
		0.736835,
		0,
		0.737287,
		0.056782,
		0.673189,
		0,
		-0.13313,
		0.989134,
		0.062374,
		0,
		0.082682,
		0.66859,
		-0.050864,
		1,
	},
	[0.45] = {
		-0.663119,
		-0.131676,
		0.736841,
		0,
		0.736513,
		0.060781,
		0.673687,
		0,
		-0.133494,
		0.989428,
		0.056676,
		0,
		0.080756,
		0.669184,
		-0.045685,
		1,
	},
	[0.466666666667] = {
		-0.663425,
		-0.132095,
		0.73649,
		0,
		0.735909,
		0.062787,
		0.674163,
		0,
		-0.135295,
		0.989247,
		0.055555,
		0,
		0.081119,
		0.670717,
		-0.043948,
		1,
	},
	[0.483333333333] = {
		-0.663683,
		-0.133127,
		0.736072,
		0,
		0.735274,
		0.064734,
		0.674671,
		0,
		-0.137466,
		0.988983,
		0.054922,
		0,
		0.082704,
		0.672624,
		-0.042735,
		1,
	},
	[0.4] = {
		-0.659701,
		-0.152799,
		0.735831,
		0,
		0.739086,
		0.04552,
		0.672071,
		0,
		-0.136186,
		0.987208,
		0.082902,
		0,
		0.090602,
		0.669569,
		-0.069461,
		1,
	},
	[0.516666666667] = {
		-0.664026,
		-0.13654,
		0.735137,
		0,
		0.734016,
		0.068266,
		0.675692,
		0,
		-0.142444,
		0.98828,
		0.054892,
		0,
		0.088233,
		0.677185,
		-0.041494,
		1,
	},
	[0.533333333333] = {
		-0.664096,
		-0.138674,
		0.734674,
		0,
		0.733448,
		0.069761,
		0.676156,
		0,
		-0.145017,
		0.987878,
		0.055382,
		0,
		0.091523,
		0.679648,
		-0.041271,
		1,
	},
	[0.55] = {
		-0.664092,
		-0.140929,
		0.734249,
		0,
		0.732959,
		0.071015,
		0.676556,
		0,
		-0.147489,
		0.987469,
		0.056134,
		0,
		0.094728,
		0.682103,
		-0.041184,
		1,
	},
	[0.566666666667] = {
		-0.664007,
		-0.14318,
		0.73389,
		0,
		0.732579,
		0.071984,
		0.676865,
		0,
		-0.149742,
		0.987075,
		0.057093,
		0,
		0.097523,
		0.68445,
		-0.041137,
		1,
	},
	[0.583333333333] = {
		-0.663838,
		-0.145304,
		0.733625,
		0,
		0.732339,
		0.072622,
		0.677057,
		0,
		-0.151657,
		0.986718,
		0.058203,
		0,
		0.099585,
		0.68659,
		-0.041033,
		1,
	},
	[0.5] = {
		-0.663886,
		-0.13465,
		0.735612,
		0,
		0.734634,
		0.066575,
		0.675189,
		0,
		-0.139888,
		0.988654,
		0.05472,
		0,
		0.085185,
		0.674812,
		-0.041949,
		1,
	},
	[0.616666666667] = {
		-0.663219,
		-0.147809,
		0.733685,
		0,
		0.732653,
		0.071977,
		0.676786,
		0,
		-0.152843,
		0.986393,
		0.060556,
		0,
		0.100604,
		0.689883,
		-0.041862,
		1,
	},
	[0.633333333333] = {
		-0.662393,
		-0.147722,
		0.734448,
		0,
		0.734115,
		0.067473,
		0.675664,
		0,
		-0.149366,
		0.986725,
		0.063751,
		0,
		0.100689,
		0.691005,
		-0.043715,
		1,
	},
	[0.65] = {
		-0.660982,
		-0.146483,
		0.735966,
		0,
		0.736628,
		0.06039,
		0.673597,
		0,
		-0.143115,
		0.987368,
		0.067987,
		0,
		0.101449,
		0.691749,
		-0.045982,
		1,
	},
	[0.666666666667] = {
		-0.654441,
		-0.146168,
		0.74185,
		0,
		0.742227,
		0.062978,
		0.667182,
		0,
		-0.144241,
		0.987253,
		0.067275,
		0,
		0.103569,
		0.692265,
		-0.045761,
		1,
	},
	[0.683333333333] = {
		-0.642051,
		-0.147511,
		0.752337,
		0,
		0.750584,
		0.078972,
		0.656039,
		0,
		-0.156187,
		0.985903,
		0.060016,
		0,
		0.107699,
		0.692617,
		-0.042393,
		1,
	},
	[0.6] = {
		-0.663581,
		-0.146897,
		0.73354,
		0,
		0.732267,
		0.073146,
		0.677078,
		0,
		-0.153116,
		0.986444,
		0.05903,
		0,
		0.100587,
		0.688407,
		-0.041038,
		1,
	},
	[0.716666666667] = {
		-0.624724,
		-0.149104,
		0.766478,
		0,
		0.760451,
		0.106701,
		0.640569,
		0,
		-0.177295,
		0.983048,
		0.046727,
		0,
		0.121374,
		0.692554,
		-0.036793,
		1,
	},
	[0.733333333333] = {
		-0.626292,
		-0.148679,
		0.765279,
		0,
		0.758999,
		0.107827,
		0.642101,
		0,
		-0.177985,
		0.982989,
		0.045316,
		0,
		0.127035,
		0.691779,
		-0.037974,
		1,
	},
	[0.75] = {
		-0.629816,
		-0.14938,
		0.762245,
		0,
		0.755755,
		0.108736,
		0.645763,
		0,
		-0.179348,
		0.982783,
		0.044411,
		0,
		0.13009,
		0.6879,
		-0.040387,
		1,
	},
	[0.766666666667] = {
		-0.634414,
		-0.150708,
		0.75816,
		0,
		0.75135,
		0.110247,
		0.65063,
		0,
		-0.18164,
		0.982412,
		0.043293,
		0,
		0.135052,
		0.677485,
		-0.042933,
		1,
	},
	[0.783333333333] = {
		-0.639116,
		-0.152551,
		0.75383,
		0,
		0.746359,
		0.113619,
		0.655774,
		0,
		-0.185688,
		0.981743,
		0.041243,
		0,
		0.146017,
		0.657188,
		-0.044451,
		1,
	},
	[0.7] = {
		-0.629998,
		-0.149011,
		0.762167,
		0,
		0.757707,
		0.097201,
		0.645315,
		0,
		-0.170242,
		0.984047,
		0.05167,
		0,
		0.113694,
		0.69274,
		-0.038528,
		1,
	},
	[0.816666666667] = {
		-0.59985,
		-0.140698,
		0.787644,
		0,
		0.775048,
		0.142287,
		0.615674,
		0,
		-0.198696,
		0.979775,
		0.023697,
		0,
		0.217524,
		0.549877,
		-0.035476,
		1,
	},
	[0.833333333333] = {
		-0.484206,
		-0.106835,
		0.868407,
		0,
		0.849413,
		0.180665,
		0.495841,
		0,
		-0.209863,
		0.977725,
		0.003268,
		0,
		0.298593,
		0.43067,
		-0.020033,
		1,
	},
	[0.85] = {
		-0.334835,
		-0.072904,
		0.939452,
		0,
		0.913867,
		0.217849,
		0.342622,
		0,
		-0.229637,
		0.973256,
		-0.006318,
		0,
		0.387112,
		0.295698,
		-0.004819,
		1,
	},
	[0.866666666667] = {
		-0.209462,
		-0.058706,
		0.976053,
		0,
		0.947181,
		0.235726,
		0.217444,
		0,
		-0.242846,
		0.970045,
		0.00623,
		0,
		0.45959,
		0.174396,
		0.002753,
		1,
	},
	[0.883333333333] = {
		-0.141763,
		-0.067089,
		0.987625,
		0,
		0.959393,
		0.236472,
		0.153774,
		0,
		-0.243862,
		0.969319,
		0.030842,
		0,
		0.516125,
		0.055448,
		0.003406,
		1,
	},
	[0.8] = {
		-0.642972,
		-0.1548,
		0.750083,
		0,
		0.741354,
		0.120112,
		0.660278,
		0,
		-0.192305,
		0.980617,
		0.037533,
		0,
		0.167073,
		0.623688,
		-0.043746,
		1,
	},
	[0.916666666667] = {
		-0.051309,
		-0.097395,
		0.993922,
		0,
		0.976908,
		0.201798,
		0.070205,
		0,
		-0.20741,
		0.974573,
		0.084792,
		0,
		0.604766,
		-0.171524,
		-0.009361,
		1,
	},
	[0.933333333333] = {
		0.038157,
		-0.103991,
		0.993846,
		0,
		0.988764,
		0.147785,
		-0.022498,
		0,
		-0.144536,
		0.983537,
		0.108461,
		0,
		0.619817,
		-0.215533,
		-0.02915,
		1,
	},
	[0.95] = {
		0.201743,
		-0.080512,
		0.976124,
		0,
		0.97942,
		0.022709,
		-0.200552,
		0,
		-0.00602,
		0.996495,
		0.083436,
		0,
		0.602224,
		-0.218304,
		-0.096375,
		1,
	},
	[0.966666666667] = {
		0.4096,
		-0.02434,
		0.91194,
		0,
		0.89665,
		-0.173422,
		-0.407361,
		0,
		0.168065,
		0.984547,
		-0.049209,
		0,
		0.5583,
		-0.218315,
		-0.219345,
		1,
	},
	[0.983333333333] = {
		0.598152,
		0.043033,
		0.800227,
		0,
		0.751747,
		-0.376098,
		-0.541689,
		0,
		0.277653,
		0.92558,
		-0.257314,
		0,
		0.503846,
		-0.217724,
		-0.357504,
		1,
	},
	[0.9] = {
		-0.100093,
		-0.082487,
		0.991553,
		0,
		0.966601,
		0.228244,
		0.116561,
		0,
		-0.235931,
		0.970103,
		0.056887,
		0,
		0.567296,
		-0.070544,
		0.000444,
		1,
	},
	[1.01666666667] = {
		0.764942,
		0.123335,
		0.632181,
		0,
		0.57253,
		-0.579853,
		-0.579638,
		0,
		0.295083,
		0.805331,
		-0.514167,
		0,
		0.42659,
		-0.222774,
		-0.517113,
		1,
	},
	[1.03333333333] = {
		0.748429,
		0.112797,
		0.653552,
		0,
		0.596169,
		-0.546175,
		-0.588451,
		0,
		0.290578,
		0.830042,
		-0.47602,
		0,
		0.416073,
		-0.24413,
		-0.503115,
		1,
	},
	[1.05] = {
		0.702313,
		0.084676,
		0.706814,
		0,
		0.658354,
		-0.454949,
		-0.599659,
		0,
		0.270788,
		0.886483,
		-0.375263,
		0,
		0.408522,
		-0.288744,
		-0.466503,
		1,
	},
	[1.06666666667] = {
		0.63226,
		0.04588,
		0.773397,
		0,
		0.742498,
		-0.320934,
		-0.587961,
		0,
		0.221234,
		0.94599,
		-0.236979,
		0,
		0.403388,
		-0.346952,
		-0.4163,
		1,
	},
	[1.08333333333] = {
		0.547832,
		0.003448,
		0.836581,
		0,
		0.825228,
		-0.166461,
		-0.539712,
		0,
		0.137397,
		0.986042,
		-0.094038,
		0,
		0.400085,
		-0.409117,
		-0.361538,
		1,
	},
	{
		0.72188,
		0.099474,
		0.684832,
		0,
		0.622952,
		-0.524375,
		-0.580485,
		0,
		0.301365,
		0.845657,
		-0.440503,
		0,
		0.454651,
		-0.218568,
		-0.470292,
		1,
	},
	[1.11666666667] = {
		0.399897,
		-0.063993,
		0.914323,
		0,
		0.915059,
		0.084931,
		-0.394275,
		0,
		-0.052424,
		0.99433,
		0.092521,
		0,
		0.396724,
		-0.506853,
		-0.274522,
		1,
	},
	[1.13333333333] = {
		0.37478,
		-0.075228,
		0.924057,
		0,
		0.922947,
		0.124658,
		-0.364182,
		0,
		-0.087795,
		0.989344,
		0.116151,
		0,
		0.39565,
		-0.523218,
		-0.260388,
		1,
	},
	[1.15] = {
		0.375385,
		-0.075652,
		0.923776,
		0,
		0.922868,
		0.123006,
		-0.364943,
		0,
		-0.086022,
		0.989518,
		0.115992,
		0,
		0.394554,
		-0.523949,
		-0.260581,
		1,
	},
	[1.16666666667] = {
		0.375938,
		-0.076102,
		0.923514,
		0,
		0.922803,
		0.121408,
		-0.365644,
		0,
		-0.084296,
		0.989681,
		0.11587,
		0,
		0.393493,
		-0.524651,
		-0.260772,
		1,
	},
	[1.18333333333] = {
		0.376423,
		-0.076563,
		0.923279,
		0,
		0.922749,
		0.119943,
		-0.366261,
		0,
		-0.082699,
		0.989824,
		0.115798,
		0,
		0.392516,
		-0.525289,
		-0.260962,
		1,
	},
	[1.1] = {
		0.464106,
		-0.03551,
		0.885067,
		0,
		0.885083,
		-0.021039,
		-0.464958,
		0,
		0.035132,
		0.999148,
		0.021665,
		0,
		0.398041,
		-0.46562,
		-0.311261,
		1,
	},
	[1.21666666667] = {
		0.377132,
		-0.077409,
		0.922919,
		0,
		0.922679,
		0.117717,
		-0.36716,
		0,
		-0.080222,
		0.990026,
		0.115818,
		0,
		0.391007,
		-0.52624,
		-0.261309,
		1,
	},
	[1.23333333333] = {
		0.377326,
		-0.077665,
		0.922818,
		0,
		0.922661,
		0.117077,
		-0.367408,
		0,
		-0.079506,
		0.990081,
		0.115834,
		0,
		0.390573,
		-0.526512,
		-0.261412,
		1,
	},
	[1.25] = {
		0.377394,
		-0.077756,
		0.922783,
		0,
		0.922656,
		0.116847,
		-0.367496,
		0,
		-0.07925,
		0.990101,
		0.11584,
		0,
		0.390417,
		-0.526609,
		-0.261447,
		1,
	},
	[1.2] = {
		0.376826,
		-0.077019,
		0.923077,
		0,
		0.922708,
		0.118692,
		-0.366772,
		0,
		-0.081313,
		0.98994,
		0.115792,
		0,
		0.391671,
		-0.525826,
		-0.261149,
		1,
	},
}

return spline_matrices
