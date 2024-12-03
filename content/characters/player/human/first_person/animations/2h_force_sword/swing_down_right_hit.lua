﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_force_sword/swing_down_right_hit.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.828718,
		0.389817,
		0.401583,
		0,
		0.543445,
		0.38899,
		0.743878,
		0,
		0.133765,
		0.834703,
		-0.534207,
		0,
		0.010836,
		0.560637,
		-0.166539,
		1,
	},
	[0.0333333333333] = {
		-0.827395,
		0.440137,
		0.348851,
		0,
		0.533947,
		0.423895,
		0.731583,
		0,
		0.17412,
		0.791576,
		-0.585738,
		0,
		0.018654,
		0.560536,
		-0.185053,
		1,
	},
	[0.05] = {
		-0.914184,
		0.290911,
		0.282202,
		0,
		0.35307,
		0.229707,
		0.90696,
		0,
		0.199021,
		0.928765,
		-0.312707,
		0,
		0.029524,
		0.574084,
		-0.157932,
		1,
	},
	[0.0666666666667] = {
		-0.96503,
		0.177742,
		0.192676,
		0,
		0.20071,
		0.028211,
		0.979244,
		0,
		0.168618,
		0.983673,
		-0.0629,
		0,
		0.037754,
		0.583806,
		-0.129805,
		1,
	},
	[0.0833333333333] = {
		-0.975584,
		0.15405,
		0.15654,
		0,
		0.152917,
		-0.035163,
		0.987613,
		0,
		0.157646,
		0.987437,
		0.010747,
		0,
		0.041121,
		0.588765,
		-0.122983,
		1,
	},
	[0] = {
		-0.97607,
		-0.150478,
		0.156984,
		0,
		0.20174,
		-0.357149,
		0.912001,
		0,
		-0.08117,
		0.921847,
		0.37896,
		0,
		0.007424,
		0.574539,
		-0.023369,
		1,
	},
	[0.116666666667] = {
		-0.982964,
		0.129513,
		0.130417,
		0,
		0.116184,
		-0.111982,
		0.986895,
		0,
		0.14242,
		0.985234,
		0.095027,
		0,
		0.044346,
		0.593337,
		-0.117172,
		1,
	},
	[0.133333333333] = {
		-0.983051,
		0.123936,
		0.135097,
		0,
		0.118921,
		-0.129764,
		0.984388,
		0,
		0.139531,
		0.983769,
		0.112826,
		0,
		0.044479,
		0.594604,
		-0.11707,
		1,
	},
	[0.15] = {
		-0.981528,
		0.121142,
		0.148077,
		0,
		0.131279,
		-0.136554,
		0.981896,
		0,
		0.13917,
		0.983198,
		0.118128,
		0,
		0.043983,
		0.595319,
		-0.118119,
		1,
	},
	[0.166666666667] = {
		-0.97865,
		0.120445,
		0.166544,
		0,
		0.150168,
		-0.134245,
		0.979504,
		0,
		0.140334,
		0.983601,
		0.113292,
		0,
		0.043082,
		0.59552,
		-0.119826,
		1,
	},
	[0.183333333333] = {
		-0.974723,
		0.121344,
		0.187591,
		0,
		0.172529,
		-0.124646,
		0.977086,
		0,
		0.141946,
		0.984753,
		0.100559,
		0,
		0.041983,
		0.595245,
		-0.12175,
		1,
	},
	[0.1] = {
		-0.980812,
		0.138967,
		0.136731,
		0,
		0.126327,
		-0.081154,
		0.988663,
		0,
		0.148488,
		0.986966,
		0.062042,
		0,
		0.043331,
		0.591434,
		-0.118971,
		1,
	},
	[0.216666666667] = {
		-0.966136,
		0.125697,
		0.225348,
		0,
		0.215024,
		-0.090581,
		0.972399,
		0,
		0.14264,
		0.987925,
		0.060486,
		0,
		0.039875,
		0.59349,
		-0.124672,
		1,
	},
	[0.233333333333] = {
		-0.963384,
		0.127463,
		0.235891,
		0,
		0.228534,
		-0.069766,
		0.971033,
		0,
		0.140228,
		0.989387,
		0.038082,
		0,
		0.039156,
		0.592294,
		-0.12474,
		1,
	},
	[0.25] = {
		-0.880954,
		0.090229,
		0.46452,
		0,
		0.465806,
		-0.007526,
		0.884855,
		0,
		0.083336,
		0.995893,
		-0.035399,
		0,
		0.031489,
		0.581162,
		-0.115014,
		1,
	},
	[0.266666666667] = {
		-0.718882,
		0.065574,
		0.692032,
		0,
		0.695119,
		0.073833,
		0.715093,
		0,
		-0.004204,
		0.995112,
		-0.098659,
		0,
		0.038939,
		0.538224,
		-0.099697,
		1,
	},
	[0.283333333333] = {
		-0.532436,
		0.068086,
		0.843728,
		0,
		0.84116,
		0.154031,
		0.518386,
		0,
		-0.094665,
		0.985717,
		-0.139283,
		0,
		0.061749,
		0.474107,
		-0.079603,
		1,
	},
	[0.2] = {
		-0.970276,
		0.123331,
		0.208218,
		0,
		0.195233,
		-0.109502,
		0.974625,
		0,
		0.143002,
		0.986306,
		0.082169,
		0,
		0.040868,
		0.594537,
		-0.123503,
		1,
	},
	[0.316666666667] = {
		-0.438432,
		0.101951,
		0.892963,
		0,
		0.878688,
		0.257446,
		0.402031,
		0,
		-0.188902,
		0.960899,
		-0.202456,
		0,
		0.130261,
		0.325263,
		-0.048652,
		1,
	},
	[0.333333333333] = {
		-0.501972,
		0.099912,
		0.859093,
		0,
		0.841104,
		0.287713,
		0.458001,
		0,
		-0.201413,
		0.952491,
		-0.22846,
		0,
		0.166753,
		0.258943,
		-0.040078,
		1,
	},
	[0.35] = {
		-0.596888,
		0.082834,
		0.798037,
		0,
		0.776943,
		0.307878,
		0.549154,
		0,
		-0.200209,
		0.947813,
		-0.248126,
		0,
		0.197956,
		0.210137,
		-0.036566,
		1,
	},
	[0.366666666667] = {
		-0.69733,
		0.05969,
		0.714261,
		0,
		0.693269,
		0.309157,
		0.651,
		0,
		-0.18196,
		0.949136,
		-0.256965,
		0,
		0.217798,
		0.190724,
		-0.039527,
		1,
	},
	[0.383333333333] = {
		-0.79932,
		0.062426,
		0.597655,
		0,
		0.583272,
		0.31978,
		0.746683,
		0,
		-0.144506,
		0.945433,
		-0.292018,
		0,
		0.231173,
		0.190714,
		-0.048554,
		1,
	},
	[0.3] = {
		-0.429693,
		0.087214,
		0.898753,
		0,
		0.88913,
		0.214494,
		0.404278,
		0,
		-0.157519,
		0.972824,
		-0.169711,
		0,
		0.09415,
		0.399975,
		-0.061598,
		1,
	},
	[0.416666666667] = {
		-0.923827,
		0.042223,
		0.380475,
		0,
		0.372561,
		0.327622,
		0.868252,
		0,
		-0.087991,
		0.943865,
		-0.318397,
		0,
		0.257355,
		0.197311,
		-0.065115,
		1,
	},
	[0.433333333333] = {
		-0.944517,
		0.027643,
		0.327298,
		0,
		0.317787,
		0.328895,
		0.889292,
		0,
		-0.083064,
		0.943962,
		-0.319431,
		0,
		0.267366,
		0.203387,
		-0.071896,
		1,
	},
	[0.45] = {
		-0.950415,
		0.005967,
		0.310927,
		0,
		0.295372,
		0.330125,
		0.896534,
		0,
		-0.097295,
		0.943918,
		-0.315519,
		0,
		0.274745,
		0.210768,
		-0.078068,
		1,
	},
	[0.466666666667] = {
		-0.948665,
		-0.019884,
		0.315656,
		0,
		0.290421,
		0.340483,
		0.894274,
		0,
		-0.125257,
		0.94004,
		-0.317229,
		0,
		0.279975,
		0.218614,
		-0.08377,
		1,
	},
	[0.483333333333] = {
		-0.940603,
		-0.051264,
		0.335615,
		0,
		0.297363,
		0.352627,
		0.887259,
		0,
		-0.163831,
		0.934359,
		-0.316438,
		0,
		0.28351,
		0.227226,
		-0.089119,
		1,
	},
	[0.4] = {
		-0.876338,
		0.054851,
		0.478564,
		0,
		0.468773,
		0.325703,
		0.821078,
		0,
		-0.110833,
		0.94388,
		-0.311138,
		0,
		0.244786,
		0.192943,
		-0.0573,
		1,
	},
	[0.516666666667] = {
		-0.908956,
		-0.131201,
		0.395709,
		0,
		0.330544,
		0.351608,
		0.87585,
		0,
		-0.254047,
		0.926908,
		-0.276228,
		0,
		0.287289,
		0.248149,
		-0.099265,
		1,
	},
	[0.533333333333] = {
		-0.888497,
		-0.177884,
		0.423001,
		0,
		0.353573,
		0.322204,
		0.878163,
		0,
		-0.292504,
		0.929807,
		-0.223383,
		0,
		0.288194,
		0.261286,
		-0.104291,
		1,
	},
	[0.55] = {
		-0.866229,
		-0.226907,
		0.445152,
		0,
		0.381903,
		0.273798,
		0.882715,
		0,
		-0.322176,
		0.934638,
		-0.150515,
		0,
		0.288161,
		0.275935,
		-0.11037,
		1,
	},
	[0.566666666667] = {
		-0.841353,
		-0.277307,
		0.463924,
		0,
		0.415553,
		0.216959,
		0.883315,
		0,
		-0.345602,
		0.935964,
		-0.067303,
		0,
		0.286844,
		0.291037,
		-0.118172,
		1,
	},
	[0.583333333333] = {
		-0.814761,
		-0.327754,
		0.47827,
		0,
		0.453255,
		0.154346,
		0.877917,
		0,
		-0.36156,
		0.93207,
		0.022801,
		0,
		0.284478,
		0.306126,
		-0.127099,
		1,
	},
	[0.5] = {
		-0.926997,
		-0.088515,
		0.364475,
		0,
		0.311637,
		0.358965,
		0.879788,
		0,
		-0.208708,
		0.929144,
		-0.305175,
		0,
		0.28582,
		0.236938,
		-0.094238,
		1,
	},
	[0.616666666667] = {
		-0.760537,
		-0.423337,
		0.49231,
		0,
		0.534267,
		0.022855,
		0.845007,
		0,
		-0.368975,
		0.905684,
		0.208793,
		0,
		0.277506,
		0.334569,
		-0.146128,
		1,
	},
	[0.633333333333] = {
		-0.734939,
		-0.466031,
		0.492625,
		0,
		0.574098,
		-0.040934,
		0.817763,
		0,
		-0.360938,
		0.883821,
		0.297632,
		0,
		0.27331,
		0.347188,
		-0.155213,
		1,
	},
	[0.65] = {
		-0.711493,
		-0.504077,
		0.489576,
		0,
		0.611403,
		-0.10067,
		0.78489,
		0,
		-0.346359,
		0.857772,
		0.37982,
		0,
		0.268849,
		0.35836,
		-0.163367,
		1,
	},
	[0.666666666667] = {
		-0.690844,
		-0.536816,
		0.484317,
		0,
		0.645009,
		-0.154964,
		0.748298,
		0,
		-0.326646,
		0.829346,
		0.453307,
		0,
		0.264241,
		0.367868,
		-0.170113,
		1,
	},
	[0.683333333333] = {
		-0.673474,
		-0.563793,
		0.47809,
		0,
		0.674084,
		-0.202959,
		0.710224,
		0,
		-0.303387,
		0.80059,
		0.516731,
		0,
		0.259571,
		0.375546,
		-0.174962,
		1,
	},
	[0.6] = {
		-0.787472,
		-0.376862,
		0.487711,
		0,
		0.493415,
		0.088745,
		0.865255,
		0,
		-0.369364,
		0.922008,
		0.116066,
		0,
		0.281293,
		0.320768,
		-0.136592,
		1,
	},
	[0.716666666667] = {
		-0.649866,
		-0.599272,
		0.467491,
		0,
		0.717015,
		-0.279352,
		0.638633,
		0,
		-0.25212,
		0.750224,
		0.611228,
		0,
		0.250009,
		0.384963,
		-0.178077,
		1,
	},
	[0.733333333333] = {
		-0.643431,
		-0.608672,
		0.464235,
		0,
		0.732073,
		-0.312005,
		0.605576,
		0,
		-0.223753,
		0.7295,
		0.646346,
		0,
		0.244617,
		0.387988,
		-0.17804,
		1,
	},
	[0.75] = {
		-0.639583,
		-0.614364,
		0.46205,
		0,
		0.744465,
		-0.345226,
		0.571481,
		0,
		-0.191585,
		0.70949,
		0.678173,
		0,
		0.238814,
		0.391606,
		-0.177493,
		1,
	},
	[0.766666666667] = {
		-0.638037,
		-0.616842,
		0.460884,
		0,
		0.75396,
		-0.378921,
		0.536621,
		0,
		-0.156372,
		0.689873,
		0.70684,
		0,
		0.232683,
		0.395745,
		-0.176495,
		1,
	},
	[0.783333333333] = {
		-0.638588,
		-0.616485,
		0.460599,
		0,
		0.760318,
		-0.413009,
		0.501339,
		0,
		-0.118837,
		0.67035,
		0.732467,
		0,
		0.226336,
		0.400315,
		-0.175119,
		1,
	},
	[0.7] = {
		-0.659717,
		-0.584673,
		0.472155,
		0,
		0.698136,
		-0.244248,
		0.673015,
		0,
		-0.278171,
		0.773628,
		0.569316,
		0,
		0.254903,
		0.381259,
		-0.177418,
		1,
	},
	[0.816666666667] = {
		-0.645292,
		-0.608563,
		0.461789,
		0,
		0.762899,
		-0.481862,
		0.431039,
		0,
		-0.039795,
		0.630445,
		0.775213,
		0,
		0.213395,
		0.410372,
		-0.171568,
		1,
	},
	[0.833333333333] = {
		-0.651197,
		-0.601515,
		0.462734,
		0,
		0.758909,
		-0.516336,
		0.396806,
		0,
		0.000242,
		0.609571,
		0.792731,
		0,
		0.20701,
		0.415661,
		-0.169566,
		1,
	},
	[0.85] = {
		-0.658661,
		-0.592701,
		0.463542,
		0,
		0.751393,
		-0.550599,
		0.363661,
		0,
		0.039683,
		0.587831,
		0.80801,
		0,
		0.200805,
		0.420989,
		-0.167523,
		1,
	},
	[0.866666666667] = {
		-0.667578,
		-0.582313,
		0.463953,
		0,
		0.740456,
		-0.584439,
		0.331899,
		0,
		0.077883,
		0.565105,
		0.821335,
		0,
		0.194866,
		0.426262,
		-0.165511,
		1,
	},
	[0.883333333333] = {
		-0.677818,
		-0.570524,
		0.463751,
		0,
		0.726297,
		-0.617605,
		0.301755,
		0,
		0.114256,
		0.541356,
		0.832994,
		0,
		0.189259,
		0.431393,
		-0.163593,
		1,
	},
	[0.8] = {
		-0.641055,
		-0.61363,
		0.460985,
		0,
		0.763343,
		-0.447369,
		0.466013,
		0,
		-0.079729,
		0.65063,
		0.755198,
		0,
		0.219872,
		0.405223,
		-0.173448,
		1,
	},
	[0.916666666667] = {
		-0.701611,
		-0.543463,
		0.460857,
		0,
		0.689571,
		-0.680806,
		0.246971,
		0,
		0.179534,
		0.491072,
		0.852418,
		0,
		0.179248,
		0.440937,
		-0.160175,
		1,
	},
	[0.933333333333] = {
		-0.714769,
		-0.528568,
		0.457954,
		0,
		0.667825,
		-0.71027,
		0.222543,
		0,
		0.207642,
		0.4649,
		0.86067,
		0,
		0.174911,
		0.445231,
		-0.158717,
		1,
	},
	[0.95] = {
		-0.728464,
		-0.51305,
		0.454005,
		0,
		0.644489,
		-0.737943,
		0.200185,
		0,
		0.232325,
		0.438429,
		0.868219,
		0,
		0.171046,
		0.449157,
		-0.15743,
		1,
	},
	[0.966666666667] = {
		-0.742454,
		-0.497161,
		0.448991,
		0,
		0.620124,
		-0.763592,
		0.179926,
		0,
		0.253394,
		0.412017,
		0.875233,
		0,
		0.167664,
		0.452692,
		-0.156301,
		1,
	},
	[0.983333333333] = {
		-0.756499,
		-0.481184,
		0.442913,
		0,
		0.595323,
		-0.787031,
		0.16178,
		0,
		0.27074,
		0.386063,
		0.881848,
		0,
		0.16478,
		0.455824,
		-0.155316,
		1,
	},
	[0.9] = {
		-0.689225,
		-0.557514,
		0.46276,
		0,
		0.709211,
		-0.649823,
		0.273403,
		0,
		0.148286,
		0.516631,
		0.84327,
		0,
		0.184041,
		0.436306,
		-0.161803,
		1,
	},
	[1.01666666667] = {
		-0.783841,
		-0.45028,
		0.427599,
		0,
		0.54686,
		-0.826781,
		0.131826,
		0,
		0.294172,
		0.337167,
		0.894305,
		0,
		0.160559,
		0.46091,
		-0.153717,
		1,
	},
	[1.03333333333] = {
		-0.796723,
		-0.436081,
		0.418409,
		0,
		0.524399,
		-0.842979,
		0.119964,
		0,
		0.300396,
		0.314991,
		0.900301,
		0,
		0.159268,
		0.462892,
		-0.153074,
		1,
	},
	[1.05] = {
		-0.808834,
		-0.423257,
		0.408216,
		0,
		0.503894,
		-0.856716,
		0.110127,
		0,
		0.303114,
		0.294773,
		0.906218,
		0,
		0.158561,
		0.464524,
		-0.152517,
		1,
	},
	[1.06666666667] = {
		-0.819996,
		-0.412261,
		0.397049,
		0,
		0.485907,
		-0.86801,
		0.102241,
		0,
		0.302493,
		0.276766,
		0.912085,
		0,
		0.158469,
		0.465821,
		-0.152038,
		1,
	},
	[1.08333333333] = {
		-0.83006,
		-0.403541,
		0.38491,
		0,
		0.470938,
		-0.876902,
		0.096233,
		0,
		0.298694,
		0.261148,
		0.917924,
		0,
		0.159033,
		0.466791,
		-0.151628,
		1,
	},
	{
		-0.770365,
		-0.465443,
		0.435776,
		0,
		0.570702,
		-0.808119,
		0.145753,
		0,
		0.284319,
		0.360981,
		0.888175,
		0,
		0.162404,
		0.458561,
		-0.154462,
		1,
	},
}

return spline_matrices
