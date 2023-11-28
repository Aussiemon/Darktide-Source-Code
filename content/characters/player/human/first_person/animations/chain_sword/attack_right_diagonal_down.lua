﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_sword/attack_right_diagonal_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.59032,
		-0.78777,
		-0.175901,
		0,
		-0.74907,
		-0.45348,
		-0.482961,
		0,
		0.300694,
		0.416864,
		-0.857792,
		0,
		0.101887,
		-0.139374,
		-0.455188,
		1
	},
	[0.0333333333333] = {
		0.435077,
		-0.894493,
		0.10291,
		0,
		-0.805479,
		-0.437741,
		-0.399482,
		0,
		0.402382,
		0.090913,
		-0.910946,
		0,
		0.030863,
		-0.120705,
		-0.443041,
		1
	},
	[0.05] = {
		0.222383,
		-0.874542,
		0.430954,
		0,
		-0.869502,
		-0.377857,
		-0.318105,
		0,
		0.441036,
		-0.303974,
		-0.844445,
		0,
		-0.040986,
		-0.101092,
		-0.431277,
		1
	},
	[0.0666666666667] = {
		-0.000255,
		-0.685142,
		0.728409,
		0,
		-0.924865,
		-0.276849,
		-0.260728,
		0,
		0.380295,
		-0.673747,
		-0.633593,
		0,
		-0.110795,
		-0.081979,
		-0.418904,
		1
	},
	[0.0833333333333] = {
		-0.162833,
		-0.380265,
		0.910431,
		0,
		-0.957168,
		-0.163016,
		-0.23928,
		0,
		0.239405,
		-0.910398,
		-0.337433,
		0,
		-0.175774,
		-0.064702,
		-0.404872,
		1
	},
	[0] = {
		0.683625,
		-0.622737,
		-0.3806,
		0,
		-0.7073,
		-0.436714,
		-0.555885,
		0,
		0.179957,
		0.649215,
		-0.73901,
		0,
		0.169115,
		-0.15562,
		-0.468573,
		1
	},
	[0.116666666667] = {
		-0.238206,
		0.127999,
		0.962743,
		0,
		-0.97104,
		-0.012592,
		-0.238584,
		0,
		-0.018416,
		-0.991694,
		0.127292,
		0,
		-0.279911,
		-0.041118,
		-0.367921,
		1
	},
	[0.133333333333] = {
		-0.221384,
		0.243864,
		0.944203,
		0,
		-0.973964,
		-0.006813,
		-0.226602,
		0,
		-0.048827,
		-0.969786,
		0.239023,
		0,
		-0.317435,
		-0.038525,
		-0.344601,
		1
	},
	[0.15] = {
		-0.189612,
		0.322618,
		0.927343,
		0,
		-0.981001,
		-0.022773,
		-0.192661,
		0,
		-0.041037,
		-0.946255,
		0.320807,
		0,
		-0.350275,
		-0.040759,
		-0.318015,
		1
	},
	[0.166666666667] = {
		-0.148686,
		0.375498,
		0.914819,
		0,
		-0.98888,
		-0.053787,
		-0.138646,
		0,
		-0.002856,
		-0.925261,
		0.37932,
		0,
		-0.378487,
		-0.047031,
		-0.288515,
		1
	},
	[0.183333333333] = {
		-0.099586,
		0.410291,
		0.906501,
		0,
		-0.993606,
		-0.089705,
		-0.068554,
		0,
		0.053191,
		-0.907532,
		0.416601,
		0,
		-0.401939,
		-0.056544,
		-0.25644,
		1
	},
	[0.1] = {
		-0.23485,
		-0.080278,
		0.968711,
		0,
		-0.968137,
		-0.069808,
		-0.240496,
		0,
		0.08693,
		-0.994325,
		-0.061325,
		0,
		-0.233105,
		-0.050575,
		-0.388196,
		1
	},
	[0.216666666667] = {
		0.026621,
		0.445749,
		0.894762,
		0,
		-0.983624,
		-0.147929,
		0.102959,
		0,
		0.178256,
		-0.882851,
		0.434511,
		0,
		-0.434625,
		-0.08094,
		-0.186218,
		1
	},
	[0.233333333333] = {
		0.103963,
		0.453158,
		0.885347,
		0,
		-0.966242,
		-0.164964,
		0.197897,
		0,
		0.235729,
		-0.876033,
		0.42071,
		0,
		-0.444272,
		-0.093699,
		-0.149292,
		1
	},
	[0.25] = {
		0.189425,
		0.456379,
		0.869389,
		0,
		-0.940806,
		-0.169097,
		0.293752,
		0,
		0.281073,
		-0.87357,
		0.397333,
		0,
		-0.450007,
		-0.105474,
		-0.112124,
		1
	},
	[0.266666666667] = {
		0.280586,
		0.455756,
		0.844724,
		0,
		-0.909295,
		-0.15558,
		0.385975,
		0,
		0.307333,
		-0.876403,
		0.370763,
		0,
		-0.452534,
		-0.115255,
		-0.075415,
		1
	},
	[0.283333333333] = {
		0.374168,
		0.449803,
		0.810972,
		0,
		-0.874755,
		-0.119158,
		0.469687,
		0,
		0.3079,
		-0.885143,
		0.348882,
		0,
		-0.452744,
		-0.122074,
		-0.039748,
		1
	},
	[0.2] = {
		-0.041322,
		0.432402,
		0.900734,
		0,
		-0.99246,
		-0.121882,
		0.012981,
		0,
		0.115396,
		-0.893406,
		0.434177,
		0,
		-0.420597,
		-0.068219,
		-0.222167,
		1
	},
	[0.316666666667] = {
		0.572399,
		0.382575,
		0.725256,
		0,
		-0.797375,
		0.053473,
		0.601111,
		0,
		0.191188,
		-0.922376,
		0.335663,
		0,
		-0.446028,
		-0.13723,
		0.032306,
		1
	},
	[0.333333333333] = {
		0.669448,
		0.298176,
		0.68039,
		0,
		-0.738684,
		0.170231,
		0.652202,
		0,
		0.078647,
		-0.939208,
		0.334219,
		0,
		-0.437206,
		-0.112667,
		0.082968,
		1
	},
	[0.35] = {
		0.727382,
		0.232687,
		0.645579,
		0,
		-0.686032,
		0.269343,
		0.67588,
		0,
		-0.016614,
		-0.934511,
		0.355546,
		0,
		-0.430599,
		-0.016032,
		0.160314,
		1
	},
	[0.366666666667] = {
		0.739557,
		0.226379,
		0.633883,
		0,
		-0.666453,
		0.378237,
		0.642477,
		0,
		-0.094315,
		-0.897602,
		0.430599,
		0,
		-0.41221,
		0.116651,
		0.189649,
		1
	},
	[0.383333333333] = {
		0.743312,
		0.214212,
		0.63372,
		0,
		-0.628629,
		0.547588,
		0.552244,
		0,
		-0.22872,
		-0.808864,
		0.541689,
		0,
		-0.385665,
		0.24302,
		0.201237,
		1
	},
	[0.3] = {
		0.466498,
		0.434916,
		0.770213,
		0,
		-0.840131,
		-0.054529,
		0.539636,
		0,
		0.276695,
		-0.898819,
		0.339949,
		0,
		-0.451601,
		-0.124992,
		-0.00558,
		1
	},
	[0.416666666667] = {
		0.698647,
		0.036743,
		0.714522,
		0,
		-0.034274,
		0.999253,
		-0.017873,
		0,
		-0.714645,
		-0.012003,
		0.699385,
		0,
		-0.286188,
		0.494727,
		0.140557,
		1
	},
	[0.433333333333] = {
		0.700934,
		0.012831,
		0.71311,
		0,
		0.430814,
		0.789211,
		-0.437658,
		0,
		-0.56841,
		0.613988,
		0.547658,
		0,
		-0.100585,
		0.624959,
		-0.020961,
		1
	},
	[0.45] = {
		0.584569,
		-0.120136,
		0.802401,
		0,
		0.708736,
		0.557009,
		-0.432936,
		0,
		-0.394933,
		0.821771,
		0.410755,
		0,
		0.113187,
		0.643527,
		-0.165006,
		1
	},
	[0.466666666667] = {
		0.546651,
		-0.104391,
		0.830828,
		0,
		0.837244,
		0.051553,
		-0.544394,
		0,
		0.013998,
		0.993199,
		0.115582,
		0,
		0.277517,
		0.545042,
		-0.258909,
		1
	},
	[0.483333333333] = {
		0.549175,
		-0.068699,
		0.832879,
		0,
		0.823203,
		-0.127288,
		-0.553294,
		0,
		0.144026,
		0.989484,
		-0.01335,
		0,
		0.38048,
		0.423638,
		-0.325702,
		1
	},
	[0.4] = {
		0.749727,
		0.062843,
		0.658757,
		0,
		-0.396339,
		0.839826,
		0.370955,
		0,
		-0.529929,
		-0.539206,
		0.654547,
		0,
		-0.365375,
		0.369005,
		0.195555,
		1
	},
	[0.516666666667] = {
		0.534822,
		-0.100403,
		0.838978,
		0,
		0.772566,
		-0.344024,
		-0.533657,
		0,
		0.34221,
		0.933577,
		-0.106424,
		0,
		0.523433,
		0.262534,
		-0.428313,
		1
	},
	[0.533333333333] = {
		0.504002,
		-0.122724,
		0.854939,
		0,
		0.721673,
		-0.483991,
		-0.494915,
		0,
		0.47452,
		0.866425,
		-0.155366,
		0,
		0.592075,
		0.223866,
		-0.471481,
		1
	},
	[0.55] = {
		0.464267,
		-0.153045,
		0.872372,
		0,
		0.649849,
		-0.610374,
		-0.452924,
		0,
		0.601791,
		0.777188,
		-0.18392,
		0,
		0.659629,
		0.199465,
		-0.511191,
		1
	},
	[0.566666666667] = {
		0.418697,
		-0.181121,
		0.889881,
		0,
		0.560675,
		-0.719289,
		-0.410203,
		0,
		0.714378,
		0.670685,
		-0.199614,
		0,
		0.710406,
		0.180755,
		-0.538756,
		1
	},
	[0.583333333333] = {
		0.372807,
		-0.200023,
		0.906094,
		0,
		0.458223,
		-0.809433,
		-0.367218,
		0,
		0.806875,
		0.552094,
		-0.210107,
		0,
		0.697685,
		0.147558,
		-0.519151,
		1
	},
	[0.5] = {
		0.553552,
		-0.062726,
		0.830449,
		0,
		0.806528,
		-0.208176,
		-0.553331,
		0,
		0.207587,
		0.976078,
		-0.064646,
		0,
		0.454917,
		0.323219,
		-0.382089,
		1
	},
	[0.616666666667] = {
		0.310459,
		-0.194794,
		0.930414,
		0,
		0.234159,
		-0.932947,
		-0.273458,
		0,
		0.921295,
		0.302762,
		-0.244029,
		0,
		0.667979,
		0.089588,
		-0.486293,
		1
	},
	[0.633333333333] = {
		0.310626,
		-0.168744,
		0.935434,
		0,
		0.123498,
		-0.96861,
		-0.215738,
		0,
		0.942475,
		0.182538,
		-0.280036,
		0,
		0.655943,
		0.059696,
		-0.481245,
		1
	},
	[0.65] = {
		0.339349,
		-0.126155,
		0.932163,
		0,
		0.011924,
		-0.990309,
		-0.138366,
		0,
		0.940585,
		0.058069,
		-0.334556,
		0,
		0.642872,
		0.026827,
		-0.485417,
		1
	},
	[0.666666666667] = {
		0.395638,
		-0.07458,
		0.915373,
		0,
		-0.10107,
		-0.994179,
		-0.037317,
		0,
		0.912828,
		-0.077753,
		-0.400873,
		0,
		0.623586,
		-0.008634,
		-0.49586,
		1
	},
	[0.683333333333] = {
		0.472519,
		-0.025227,
		0.880959,
		0,
		-0.205044,
		-0.975308,
		0.08205,
		0,
		0.857137,
		-0.219405,
		-0.466024,
		0,
		0.598847,
		-0.04581,
		-0.509882,
		1
	},
	[0.6] = {
		0.333961,
		-0.205255,
		0.919968,
		0,
		0.347531,
		-0.88043,
		-0.322592,
		0,
		0.87618,
		0.427451,
		-0.222697,
		0,
		0.682734,
		0.118045,
		-0.500223,
		1
	},
	[0.716666666667] = {
		0.648164,
		0.034818,
		0.760704,
		0,
		-0.34853,
		-0.874619,
		0.336999,
		0,
		0.67706,
		-0.483559,
		-0.554762,
		0,
		0.538153,
		-0.120308,
		-0.538852,
		1
	},
	[0.733333333333] = {
		0.729016,
		0.034639,
		0.683619,
		0,
		-0.380434,
		-0.809756,
		0.446728,
		0,
		0.569039,
		-0.585744,
		-0.577147,
		0,
		0.504268,
		-0.156696,
		-0.551415,
		1
	},
	[0.75] = {
		0.796401,
		0.014178,
		0.604602,
		0,
		-0.390267,
		-0.751656,
		0.531699,
		0,
		0.461992,
		-0.659402,
		-0.593087,
		0,
		0.469781,
		-0.191942,
		-0.561495,
		1
	},
	[0.766666666667] = {
		0.847646,
		-0.02334,
		0.530048,
		0,
		-0.386211,
		-0.712133,
		0.586265,
		0,
		0.363781,
		-0.701656,
		-0.612652,
		0,
		0.436395,
		-0.225463,
		-0.568507,
		1
	},
	[0.783333333333] = {
		0.88253,
		-0.074786,
		0.464272,
		0,
		-0.377838,
		-0.700532,
		0.605387,
		0,
		0.279963,
		-0.709691,
		-0.646498,
		0,
		0.406195,
		-0.256556,
		-0.572249,
		1
	},
	[0.7] = {
		0.559777,
		0.013798,
		0.828528,
		0,
		-0.2898,
		-0.933461,
		0.211343,
		0,
		0.776315,
		-0.358413,
		-0.518532,
		0,
		0.570065,
		-0.083207,
		-0.52465,
		1
	},
	[0.816666666667] = {
		0.922525,
		-0.21686,
		0.319247,
		0,
		-0.363138,
		-0.767848,
		0.527769,
		0,
		0.130682,
		-0.602811,
		-0.78711,
		0,
		0.346675,
		-0.317815,
		-0.575339,
		1
	},
	[0.833333333333] = {
		0.929977,
		-0.297176,
		0.216399,
		0,
		-0.363717,
		-0.829317,
		0.424196,
		0,
		0.053403,
		-0.473201,
		-0.879335,
		0,
		0.312716,
		-0.348385,
		-0.574213,
		1
	},
	[0.85] = {
		0.926014,
		-0.367903,
		0.084533,
		0,
		-0.376682,
		-0.88592,
		0.270661,
		0,
		-0.024687,
		-0.282478,
		-0.958956,
		0,
		0.275361,
		-0.376564,
		-0.569154,
		1
	},
	[0.866666666667] = {
		0.908643,
		-0.410842,
		-0.074677,
		0,
		-0.406008,
		-0.911032,
		0.071963,
		0,
		-0.097598,
		-0.035069,
		-0.994608,
		0,
		0.235018,
		-0.400278,
		-0.557883,
		1
	},
	[0.883333333333] = {
		0.878554,
		-0.408817,
		-0.247004,
		0,
		-0.4515,
		-0.879542,
		-0.150178,
		0,
		-0.155855,
		0.243462,
		-0.957306,
		0,
		0.192993,
		-0.418222,
		-0.538184,
		1
	},
	[0.8] = {
		0.90615,
		-0.140093,
		0.399081,
		0,
		-0.36961,
		-0.720994,
		0.586136,
		0,
		0.205622,
		-0.678632,
		-0.705109,
		0,
		0.377567,
		-0.286781,
		-0.574276,
		1
	},
	[0.916666666667] = {
		0.801498,
		-0.26589,
		-0.535633,
		0,
		-0.562807,
		-0.638135,
		-0.525387,
		0,
		-0.202111,
		0.722555,
		-0.661109,
		0,
		0.112134,
		-0.438626,
		-0.472746,
		1
	},
	[0.933333333333] = {
		0.767457,
		-0.159738,
		-0.620882,
		0,
		-0.610824,
		-0.476295,
		-0.632485,
		0,
		-0.194691,
		0.864654,
		-0.463107,
		0,
		0.0772,
		-0.443817,
		-0.432732,
		1
	},
	[0.95] = {
		0.740644,
		-0.059023,
		-0.669301,
		0,
		-0.647803,
		-0.327101,
		-0.688009,
		0,
		-0.17832,
		0.943144,
		-0.2805,
		0,
		0.047575,
		-0.447202,
		-0.39376,
		1
	},
	[0.966666666667] = {
		0.720381,
		0.023481,
		-0.693181,
		0,
		-0.674562,
		-0.208704,
		-0.708102,
		0,
		-0.161297,
		0.977697,
		-0.134507,
		0,
		0.02374,
		-0.449412,
		-0.359759,
		1
	},
	[0.983333333333] = {
		0.704635,
		0.082598,
		-0.704746,
		0,
		-0.693675,
		-0.128854,
		-0.708669,
		0,
		-0.149343,
		0.988218,
		-0.033499,
		0,
		0.005798,
		-0.450836,
		-0.333725,
		1
	},
	[0.9] = {
		0.840468,
		-0.35646,
		-0.408105,
		0,
		-0.50701,
		-0.783083,
		-0.36017,
		0,
		-0.191194,
		0.509625,
		-0.838885,
		0,
		0.151309,
		-0.430566,
		-0.50923,
		1
	},
	[1.01666666667] = {
		0.690641,
		0.129347,
		-0.711537,
		0,
		-0.709452,
		-0.069742,
		-0.701295,
		0,
		-0.140334,
		0.989144,
		0.043599,
		0,
		-0.009203,
		-0.451727,
		-0.312214,
		1
	},
	[1.03333333333] = {
		0.691175,
		0.127519,
		-0.711348,
		0,
		-0.708891,
		-0.071786,
		-0.701656,
		0,
		-0.140539,
		0.989235,
		0.04078,
		0,
		-0.008712,
		-0.451644,
		-0.313147,
		1
	},
	[1.05] = {
		0.694435,
		0.11646,
		-0.710069,
		0,
		-0.705285,
		-0.085391,
		-0.703762,
		0,
		-0.142594,
		0.989518,
		0.022839,
		0,
		-0.005285,
		-0.451406,
		-0.318372,
		1
	},
	[1.06666666667] = {
		0.698876,
		0.101527,
		-0.708,
		0,
		-0.700328,
		-0.10396,
		-0.70621,
		0,
		-0.145303,
		0.989386,
		-0.001553,
		0,
		-0.000608,
		-0.451067,
		-0.325338,
		1
	},
	[1.08333333333] = {
		0.702849,
		0.088292,
		-0.705838,
		0,
		-0.695862,
		-0.120517,
		-0.707991,
		0,
		-0.147575,
		0.988777,
		-0.023266,
		0,
		0.003555,
		-0.450728,
		-0.331459,
		1
	},
	{
		0.694452,
		0.116459,
		-0.710052,
		0,
		-0.705175,
		-0.086036,
		-0.703794,
		0,
		-0.143053,
		0.989462,
		0.022376,
		0,
		-0.005045,
		-0.451553,
		-0.318167,
		1
	},
	[1.1] = {
		0.704577,
		0.082574,
		-0.704807,
		0,
		-0.693912,
		-0.1277,
		-0.708646,
		0,
		-0.14852,
		0.988369,
		-0.032676,
		0,
		0.005359,
		-0.450571,
		-0.334089,
		1
	}
}

return spline_matrices
