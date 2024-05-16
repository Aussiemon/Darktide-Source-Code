﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.277413,
		-0.480149,
		0.832165,
		0,
		0.696545,
		-0.496052,
		-0.518418,
		0,
		0.661716,
		0.723456,
		0.196834,
		0,
		0.545425,
		-0.162655,
		-1.101097,
		1,
	},
	[0.0333333333333] = {
		0.284683,
		-0.484243,
		0.827323,
		0,
		0.620094,
		-0.565134,
		-0.544156,
		0,
		0.731053,
		0.667931,
		0.139392,
		0,
		0.526698,
		-0.167663,
		-1.111787,
		1,
	},
	[0.05] = {
		0.291149,
		-0.489225,
		0.822126,
		0,
		0.530874,
		-0.632285,
		-0.56426,
		0,
		0.795868,
		0.600729,
		0.075628,
		0,
		0.498189,
		-0.169612,
		-1.125027,
		1,
	},
	[0.0666666666667] = {
		0.296786,
		-0.495186,
		0.816522,
		0,
		0.427698,
		-0.695566,
		-0.577289,
		0,
		0.85381,
		0.520557,
		0.005356,
		0,
		0.460646,
		-0.168469,
		-1.140319,
		1,
	},
	[0.0833333333333] = {
		0.301493,
		-0.502212,
		0.810485,
		0,
		0.309933,
		-0.752256,
		-0.581423,
		0,
		0.901689,
		0.426491,
		-0.071148,
		0,
		0.414834,
		-0.164093,
		-1.157096,
		1,
	},
	[0] = {
		0.269282,
		-0.476861,
		0.836714,
		0,
		0.761644,
		-0.426261,
		-0.488057,
		0,
		0.589394,
		0.768703,
		0.248414,
		0,
		0.553602,
		-0.154532,
		-1.093389,
		1,
	},
	[0.116666666667] = {
		0.307363,
		-0.519638,
		0.797185,
		0,
		0.033261,
		-0.83136,
		-0.554738,
		0,
		0.951011,
		0.197021,
		-0.238246,
		0,
		0.301815,
		-0.144442,
		-1.192521,
		1,
	},
	[0.133333333333] = {
		0.308036,
		-0.529964,
		0.790096,
		0,
		-0.120479,
		-0.845522,
		-0.520171,
		0,
		0.943715,
		0.065042,
		-0.3243,
		0,
		0.236699,
		-0.128267,
		-1.209782,
		1,
	},
	[0.15] = {
		0.306873,
		-0.541161,
		0.782926,
		0,
		-0.277973,
		-0.837711,
		-0.470075,
		0,
		0.910253,
		-0.073379,
		-0.407499,
		0,
		0.167629,
		-0.107144,
		-1.225847,
		1,
	},
	[0.166666666667] = {
		0.303712,
		-0.552944,
		0.775894,
		0,
		-0.43229,
		-0.805687,
		-0.404962,
		0,
		0.849049,
		-0.21242,
		-0.483729,
		0,
		0.09629,
		-0.080583,
		-1.240169,
		1,
	},
	[0.183333333333] = {
		0.298525,
		-0.564951,
		0.769229,
		0,
		-0.575778,
		-0.749396,
		-0.326934,
		0,
		0.761159,
		-0.345307,
		-0.549,
		0,
		0.0246,
		-0.048277,
		-1.252379,
		1,
	},
	[0.1] = {
		0.305096,
		-0.510361,
		0.80402,
		0,
		0.177887,
		-0.798872,
		-0.574595,
		0,
		0.93556,
		0.318331,
		-0.152947,
		0,
		0.361574,
		-0.156216,
		-1.174725,
		1,
	},
	[0.216666666667] = {
		0.282786,
		-0.588154,
		0.757698,
		0,
		-0.803664,
		-0.576498,
		-0.147558,
		0,
		0.523599,
		-0.567208,
		-0.635704,
		0,
		-0.111739,
		0.033326,
		-1.270042,
		1,
	},
	[0.233333333333] = {
		0.272938,
		-0.598793,
		0.752962,
		0,
		-0.880258,
		-0.471221,
		-0.055658,
		0,
		0.388139,
		-0.647609,
		-0.655706,
		0,
		-0.172633,
		0.081699,
		-1.275714,
		1,
	},
	[0.25] = {
		0.26235,
		-0.608639,
		0.74882,
		0,
		-0.931485,
		-0.362386,
		0.031801,
		0,
		0.252007,
		-0.705858,
		-0.66201,
		0,
		-0.226621,
		0.134109,
		-1.279555,
		1,
	},
	[0.266666666667] = {
		0.251437,
		-0.617757,
		0.745088,
		0,
		-0.960157,
		-0.256216,
		0.111583,
		0,
		0.121972,
		-0.743458,
		-0.657566,
		0,
		-0.272571,
		0.18968,
		-1.281733,
		1,
	},
	[0.283333333333] = {
		0.240532,
		-0.62633,
		0.741522,
		0,
		-0.970636,
		-0.15763,
		0.181709,
		0,
		0.003077,
		-0.763455,
		-0.645854,
		0,
		-0.309616,
		0.247587,
		-1.282312,
		1,
	},
	[0.2] = {
		0.291451,
		-0.576799,
		0.763125,
		0,
		-0.701325,
		-0.671369,
		-0.239597,
		0,
		0.650538,
		-0.465368,
		-0.600195,
		0,
		-0.045404,
		-0.010203,
		-1.262322,
		1,
	},
	[0.316666666667] = {
		0.219641,
		-0.642923,
		0.733763,
		0,
		-0.956884,
		0.004572,
		0.290434,
		0,
		-0.190081,
		-0.765917,
		-0.614199,
		0,
		-0.330629,
		0.356833,
		-1.247056,
		1,
	},
	[0.333333333333] = {
		0.209917,
		-0.651556,
		0.728979,
		0,
		-0.941902,
		0.065193,
		0.329499,
		0,
		-0.262212,
		-0.755794,
		-0.600017,
		0,
		-0.326676,
		0.410903,
		-1.228515,
		1,
	},
	[0.35] = {
		0.201923,
		-0.654755,
		0.72837,
		0,
		-0.924084,
		0.119032,
		0.363181,
		0,
		-0.324494,
		-0.74641,
		-0.581013,
		0,
		-0.313691,
		0.487213,
		-1.203435,
		1,
	},
	[0.366666666667] = {
		0.196545,
		-0.650511,
		0.733625,
		0,
		-0.902998,
		0.171456,
		0.393952,
		0,
		-0.382054,
		-0.739891,
		-0.553711,
		0,
		-0.289555,
		0.59493,
		-1.161242,
		1,
	},
	[0.383333333333] = {
		0.192685,
		-0.644388,
		0.740025,
		0,
		-0.880583,
		0.219194,
		0.420151,
		0,
		-0.432949,
		-0.73261,
		-0.525202,
		0,
		-0.25495,
		0.715056,
		-1.101511,
		1,
	},
	[0.3] = {
		0.22988,
		-0.634619,
		0.737844,
		0,
		-0.967913,
		-0.070028,
		0.241329,
		0,
		-0.101483,
		-0.769646,
		-0.630354,
		0,
		-0.327325,
		0.303257,
		-1.268184,
		1,
	},
	[0.416666666667] = {
		0.181426,
		-0.647771,
		0.739917,
		0,
		-0.841579,
		0.286976,
		0.45759,
		0,
		-0.508752,
		-0.705718,
		-0.493086,
		0,
		-0.170654,
		0.931052,
		-0.947336,
		1,
	},
	[0.433333333333] = {
		0.16884,
		-0.667686,
		0.725044,
		0,
		-0.830526,
		0.299751,
		0.469442,
		0,
		-0.530773,
		-0.681429,
		-0.50392,
		0,
		-0.132912,
		1.011787,
		-0.866556,
		1,
	},
	[0.45] = {
		0.147981,
		-0.706276,
		0.692298,
		0,
		-0.82908,
		0.293047,
		0.476183,
		0,
		-0.539192,
		-0.644436,
		-0.542194,
		0,
		-0.105481,
		1.073637,
		-0.79015,
		1,
	},
	[0.466666666667] = {
		0.117059,
		-0.766881,
		0.631023,
		0,
		-0.840372,
		0.2621,
		0.474424,
		0,
		-0.529219,
		-0.58583,
		-0.613784,
		0,
		-0.093407,
		1.118867,
		-0.719611,
		1,
	},
	[0.483333333333] = {
		0.103283,
		-0.861325,
		0.497445,
		0,
		-0.876064,
		0.158049,
		0.455556,
		0,
		-0.471003,
		-0.482845,
		-0.738253,
		0,
		-0.098624,
		1.155188,
		-0.63551,
		1,
	},
	[0.4] = {
		0.188456,
		-0.641726,
		0.743419,
		0,
		-0.85922,
		0.258877,
		0.441276,
		0,
		-0.475632,
		-0.721921,
		-0.502596,
		0,
		-0.213386,
		0.830763,
		-1.027942,
		1,
	},
	[0.516666666667] = {
		0.170335,
		-0.981282,
		-0.089844,
		0,
		-0.932043,
		-0.190035,
		0.308516,
		0,
		-0.319815,
		0.031187,
		-0.946967,
		0,
		-0.104364,
		1.221092,
		-0.374996,
		1,
	},
	[0.533333333333] = {
		0.219214,
		-0.887464,
		-0.405405,
		0,
		-0.927521,
		-0.31848,
		0.195642,
		0,
		-0.302739,
		0.333134,
		-0.892956,
		0,
		-0.047378,
		1.248193,
		-0.237636,
		1,
	},
	[0.55] = {
		0.197247,
		-0.726718,
		-0.658008,
		0,
		-0.925532,
		-0.359343,
		0.119426,
		0,
		-0.32324,
		0.585451,
		-0.74348,
		0,
		0.039062,
		1.264683,
		-0.104602,
		1,
	},
	[0.566666666667] = {
		0.032539,
		-0.51064,
		-0.859179,
		0,
		-0.936247,
		-0.316461,
		0.152626,
		0,
		-0.349834,
		0.799437,
		-0.488383,
		0,
		0.140683,
		1.2633,
		0.041545,
		1,
	},
	[0.583333333333] = {
		-0.407294,
		-0.068879,
		-0.910696,
		0,
		-0.90711,
		-0.085365,
		0.412147,
		0,
		-0.10613,
		0.993966,
		-0.027712,
		0,
		0.354963,
		1.141275,
		0.284678,
		1,
	},
	[0.5] = {
		0.136852,
		-0.9546,
		0.264596,
		0,
		-0.924807,
		-0.027405,
		0.379448,
		0,
		-0.35497,
		-0.296629,
		-0.886571,
		0,
		-0.115916,
		1.18467,
		-0.521885,
		1,
	},
	[0.616666666667] = {
		-0.964423,
		0.256121,
		-0.065498,
		0,
		-0.138419,
		-0.27814,
		0.950515,
		0,
		0.225229,
		0.925764,
		0.303697,
		0,
		1.230088,
		0.603446,
		0.826848,
		1,
	},
	[0.633333333333] = {
		-0.936947,
		0.107819,
		0.332423,
		0,
		0.230652,
		-0.52383,
		0.820001,
		0,
		0.262545,
		0.844972,
		0.465932,
		0,
		1.529329,
		0.149938,
		0.710711,
		1,
	},
	[0.65] = {
		-0.913359,
		-0.068627,
		0.40133,
		0,
		0.313248,
		-0.74812,
		0.584972,
		0,
		0.260097,
		0.660005,
		0.704799,
		0,
		1.658195,
		-0.15813,
		0.618128,
		1,
	},
	[0.666666666667] = {
		-0.849336,
		-0.165223,
		0.501328,
		0,
		0.420516,
		-0.785853,
		0.453434,
		0,
		0.319052,
		0.595934,
		0.736932,
		0,
		1.649475,
		-0.210346,
		0.542095,
		1,
	},
	[0.683333333333] = {
		-0.764411,
		-0.247948,
		0.595145,
		0,
		0.523666,
		-0.777253,
		0.348785,
		0,
		0.376098,
		0.578272,
		0.723983,
		0,
		1.608445,
		-0.239698,
		0.379205,
		1,
	},
	[0.6] = {
		-0.423511,
		0.067948,
		-0.903339,
		0,
		-0.903348,
		-0.106338,
		0.415517,
		0,
		-0.067825,
		0.992006,
		0.106416,
		0,
		0.604522,
		0.989783,
		0.620481,
		1,
	},
	[0.716666666667] = {
		-0.500015,
		-0.369749,
		0.783116,
		0,
		0.735032,
		-0.659369,
		0.157992,
		0,
		0.457945,
		0.654614,
		0.601471,
		0,
		1.451302,
		-0.242653,
		-0.123251,
		1,
	},
	[0.733333333333] = {
		-0.313129,
		-0.396103,
		0.863164,
		0,
		0.827243,
		-0.560194,
		0.043027,
		0,
		0.466497,
		0.72752,
		0.503087,
		0,
		1.342959,
		-0.223781,
		-0.418754,
		1,
	},
	[0.75] = {
		-0.097576,
		-0.389306,
		0.915926,
		0,
		0.890433,
		-0.445221,
		-0.094377,
		0,
		0.444531,
		0.806362,
		0.390094,
		0,
		1.221164,
		-0.197371,
		-0.711771,
		1,
	},
	[0.766666666667] = {
		0.129686,
		-0.348083,
		0.92845,
		0,
		0.910493,
		-0.328999,
		-0.250522,
		0,
		0.392662,
		0.877837,
		0.27426,
		0,
		1.093138,
		-0.167721,
		-0.976962,
		1,
	},
	[0.783333333333] = {
		0.347411,
		-0.280909,
		0.894648,
		0,
		0.881165,
		-0.228507,
		-0.413923,
		0,
		0.320708,
		0.932135,
		0.168142,
		0,
		0.96827,
		-0.13773,
		-1.189221,
		1,
	},
	[0.7] = {
		-0.650175,
		-0.317642,
		0.6902,
		0,
		0.629828,
		-0.733415,
		0.255773,
		0,
		0.424959,
		0.601004,
		0.676907,
		0,
		1.541099,
		-0.249335,
		0.150346,
		1,
	},
	[0.816666666667] = {
		0.690374,
		-0.145216,
		0.708728,
		0,
		0.697622,
		-0.125808,
		-0.705334,
		0,
		0.19159,
		0.981369,
		0.014451,
		0,
		0.769727,
		-0.078562,
		-1.362078,
		1,
	},
	[0.833333333333] = {
		0.697836,
		-0.136521,
		0.703126,
		0,
		0.694523,
		-0.111017,
		-0.710853,
		0,
		0.175105,
		0.984397,
		0.017345,
		0,
		0.736214,
		-0.046871,
		-1.347397,
		1,
	},
	[0.85] = {
		0.703169,
		-0.129859,
		0.699064,
		0,
		0.691845,
		-0.101849,
		-0.714827,
		0,
		0.164026,
		0.986288,
		0.018225,
		0,
		0.714066,
		-0.025933,
		-1.337811,
		1,
	},
	[0.866666666667] = {
		0.705143,
		-0.128111,
		0.697395,
		0,
		0.690672,
		-0.098467,
		-0.716433,
		0,
		0.160454,
		0.98686,
		0.019049,
		0,
		0.706063,
		-0.017632,
		-1.334391,
		1,
	},
	[0.883333333333] = {
		0.705028,
		-0.129722,
		0.697214,
		0,
		0.69059,
		-0.098045,
		-0.716571,
		0,
		0.161313,
		0.986691,
		0.02046,
		0,
		0.706055,
		-0.016339,
		-1.334412,
		1,
	},
	[0.8] = {
		0.537506,
		-0.205568,
		0.817819,
		0,
		0.806441,
		-0.158137,
		-0.569777,
		0,
		0.246456,
		0.965782,
		0.080779,
		0,
		0.857074,
		-0.108295,
		-1.324856,
		1,
	},
	[0.916666666667] = {
		0.704818,
		-0.13253,
		0.696898,
		0,
		0.69044,
		-0.097377,
		-0.716805,
		0,
		0.16286,
		0.986384,
		0.022871,
		0,
		0.706038,
		-0.014187,
		-1.334446,
		1,
	},
	[0.933333333333] = {
		0.704733,
		-0.133636,
		0.696773,
		0,
		0.690379,
		-0.097137,
		-0.716897,
		0,
		0.163485,
		0.986259,
		0.023804,
		0,
		0.706031,
		-0.013373,
		-1.334458,
		1,
	},
	[0.95] = {
		0.704667,
		-0.134482,
		0.696677,
		0,
		0.690332,
		-0.096962,
		-0.716966,
		0,
		0.16397,
		0.986161,
		0.024511,
		0,
		0.706025,
		-0.012763,
		-1.334467,
		1,
	},
	[0.966666666667] = {
		0.704624,
		-0.135023,
		0.696616,
		0,
		0.690301,
		-0.096856,
		-0.71701,
		0,
		0.164284,
		0.986097,
		0.02496,
		0,
		0.706021,
		-0.012381,
		-1.334473,
		1,
	},
	[0.983333333333] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[0.9] = {
		0.704918,
		-0.13121,
		0.697047,
		0,
		0.690511,
		-0.09768,
		-0.716696,
		0,
		0.162125,
		0.986531,
		0.021745,
		0,
		0.706046,
		-0.015183,
		-1.334431,
		1,
	},
	[1.01666666667] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.03333333333] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.05] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.06666666667] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.08333333333] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	{
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.11666666667] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.13333333333] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.15] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.16666666667] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
	[1.1] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.70602,
		-0.012248,
		-1.334475,
		1,
	},
}

return spline_matrices
