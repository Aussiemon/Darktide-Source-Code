﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/combat_blade/heavy_swing_left_charge.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.82013,
		0.036727,
		0.570998,
		0,
		0.180692,
		0.930246,
		-0.319363,
		0,
		-0.542898,
		0.365094,
		0.756286,
		0,
		0.672231,
		1.150459,
		-0.520893,
		1,
	},
	[0.0333333333333] = {
		0.801147,
		0.048383,
		0.596509,
		0,
		0.171367,
		0.936445,
		-0.30611,
		0,
		-0.573409,
		0.347461,
		0.741939,
		0,
		0.668213,
		1.157075,
		-0.524207,
		1,
	},
	[0.05] = {
		0.780911,
		0.059484,
		0.621804,
		0,
		0.160787,
		0.94277,
		-0.292118,
		0,
		-0.603594,
		0.328096,
		0.726655,
		0,
		0.663198,
		1.167813,
		-0.528351,
		1,
	},
	[0.0666666666667] = {
		0.759832,
		0.069915,
		0.646349,
		0,
		0.149246,
		0.94889,
		-0.27809,
		0,
		-0.632757,
		0.307767,
		0.710562,
		0,
		0.657525,
		1.181649,
		-0.533143,
		1,
	},
	[0.0833333333333] = {
		0.738404,
		0.079631,
		0.669641,
		0,
		0.137123,
		0.954528,
		-0.264713,
		0,
		-0.66027,
		0.287288,
		0.693908,
		0,
		0.651531,
		1.197562,
		-0.538395,
		1,
	},
	[0] = {
		0.83754,
		0.024699,
		0.545818,
		0,
		0.188552,
		0.924543,
		-0.331163,
		0,
		-0.512811,
		0.380277,
		0.769684,
		0,
		0.674909,
		1.148992,
		-0.518582,
		1,
	},
	[0.116666666667] = {
		0.696831,
		0.097094,
		0.710633,
		0,
		0.113052,
		0.963541,
		-0.242505,
		0,
		-0.70827,
		0.249323,
		0.660448,
		0,
		0.639913,
		1.231541,
		-0.54949,
		1,
	},
	[0.133333333333] = {
		0.677982,
		0.105077,
		0.727529,
		0,
		0.102222,
		0.966636,
		-0.234872,
		0,
		-0.727936,
		0.233608,
		0.644621,
		0,
		0.63495,
		1.247567,
		-0.554932,
		1,
	},
	[0.15] = {
		0.661345,
		0.112788,
		0.741554,
		0,
		0.093008,
		0.96867,
		-0.230279,
		0,
		-0.744293,
		0.221264,
		0.630134,
		0,
		0.630986,
		1.261586,
		-0.560035,
		1,
	},
	[0.166666666667] = {
		0.647624,
		0.120408,
		0.752386,
		0,
		0.086039,
		0.969564,
		-0.229223,
		0,
		-0.757087,
		0.213185,
		0.617553,
		0,
		0.628347,
		1.272568,
		-0.564605,
		1,
	},
	[0.183333333333] = {
		0.637014,
		0.128563,
		0.760056,
		0,
		0.081562,
		0.969218,
		-0.2323,
		0,
		-0.766525,
		0.20997,
		0.60692,
		0,
		0.626833,
		1.281229,
		-0.568893,
		1,
	},
	[0.1] = {
		0.717195,
		0.08866,
		0.69121,
		0,
		0.124881,
		0.959466,
		-0.252644,
		0,
		-0.685592,
		0.267514,
		0.677052,
		0,
		0.64555,
		1.214533,
		-0.543911,
		1,
	},
	[0.216666666667] = {
		0.623663,
		0.14699,
		0.767749,
		0,
		0.078961,
		0.965291,
		-0.248953,
		0,
		-0.777695,
		0.215885,
		0.59041,
		0,
		0.625774,
		1.295802,
		-0.577514,
		1,
	},
	[0.233333333333] = {
		0.620452,
		0.156484,
		0.768474,
		0,
		0.080314,
		0.96206,
		-0.260749,
		0,
		-0.780121,
		0.223501,
		0.584345,
		0,
		0.626131,
		1.301713,
		-0.581686,
		1,
	},
	[0.25] = {
		0.619197,
		0.165599,
		0.767575,
		0,
		0.083028,
		0.958222,
		-0.273708,
		0,
		-0.780834,
		0.23321,
		0.579579,
		0,
		0.627014,
		1.306714,
		-0.585661,
		1,
	},
	[0.266666666667] = {
		0.619603,
		0.173904,
		0.765408,
		0,
		0.086775,
		0.953993,
		-0.286997,
		0,
		-0.780104,
		0.244242,
		0.576007,
		0,
		0.628371,
		1.310822,
		-0.589356,
		1,
	},
	[0.283333333333] = {
		0.621355,
		0.180984,
		0.76234,
		0,
		0.091221,
		0.949631,
		-0.299798,
		0,
		-0.778201,
		0.255822,
		0.573549,
		0,
		0.630152,
		1.314061,
		-0.592685,
		1,
	},
	[0.2] = {
		0.629101,
		0.137546,
		0.765057,
		0,
		0.079282,
		0.967734,
		-0.239178,
		0,
		-0.77327,
		0.211122,
		0.597898,
		0,
		0.625991,
		1.288975,
		-0.573223,
		1,
	},
	[0.316666666667] = {
		0.62755,
		0.18994,
		0.755052,
		0,
		0.100888,
		0.941771,
		-0.320763,
		0,
		-0.772012,
		0.277471,
		0.571846,
		0,
		0.634786,
		1.318086,
		-0.597882,
		1,
	},
	[0.333333333333] = {
		0.62966,
		0.195145,
		0.751962,
		0,
		0.107163,
		0.936866,
		-0.332864,
		0,
		-0.769444,
		0.290173,
		0.568995,
		0,
		0.638475,
		1.318551,
		-0.596406,
		1,
	},
	[0.35] = {
		0.629306,
		0.205014,
		0.749628,
		0,
		0.116123,
		0.928943,
		-0.351539,
		0,
		-0.768433,
		0.308275,
		0.560783,
		0,
		0.644154,
		1.317401,
		-0.588236,
		1,
	},
	[0.366666666667] = {
		0.627388,
		0.218119,
		0.747535,
		0,
		0.127275,
		0.918338,
		-0.374776,
		0,
		-0.768236,
		0.330272,
		0.548393,
		0,
		0.651603,
		1.314547,
		-0.573793,
		1,
	},
	[0.383333333333] = {
		0.624767,
		0.233044,
		0.745223,
		0,
		0.140086,
		0.90548,
		-0.400602,
		0,
		-0.768142,
		0.354678,
		0.533067,
		0,
		0.66059,
		1.309927,
		-0.553496,
		1,
	},
	[0.3] = {
		0.62412,
		0.186448,
		0.758756,
		0,
		0.096033,
		0.945442,
		-0.311315,
		0,
		-0.775404,
		0.267164,
		0.572164,
		0,
		0.632308,
		1.316468,
		-0.595559,
		1,
	},
	[0.416666666667] = {
		0.62054,
		0.262903,
		0.738791,
		0,
		0.168334,
		0.875503,
		-0.452943,
		0,
		-0.765895,
		0.405433,
		0.499029,
		0,
		0.682192,
		1.295337,
		-0.497176,
		1,
	},
	[0.433333333333] = {
		0.620281,
		0.275294,
		0.734483,
		0,
		0.182522,
		0.860024,
		-0.476491,
		0,
		-0.762848,
		0.429617,
		0.483209,
		0,
		0.694284,
		1.285451,
		-0.462187,
		1,
	},
	[0.45] = {
		0.622006,
		0.284444,
		0.729521,
		0,
		0.195926,
		0.845508,
		-0.496719,
		0,
		-0.758104,
		0.451894,
		0.470181,
		0,
		0.706882,
		1.273948,
		-0.423419,
		1,
	},
	[0.466666666667] = {
		0.626177,
		0.28929,
		0.724026,
		0,
		0.207971,
		0.833001,
		-0.512697,
		0,
		-0.751432,
		0.471615,
		0.461441,
		0,
		0.719726,
		1.260939,
		-0.381507,
		1,
	},
	[0.483333333333] = {
		0.633201,
		0.288818,
		0.718081,
		0,
		0.218143,
		0.823563,
		-0.523601,
		0,
		-0.742611,
		0.488188,
		0.458477,
		0,
		0.732566,
		1.246546,
		-0.337105,
		1,
	},
	[0.4] = {
		0.622244,
		0.24841,
		0.742364,
		0,
		0.153978,
		0.890952,
		-0.427194,
		0,
		-0.76753,
		0.380127,
		0.51614,
		0,
		0.670873,
		1.303516,
		-0.527793,
		1,
	},
	[0.516666666667] = {
		0.657334,
		0.267786,
		0.704417,
		0,
		0.231198,
		0.818,
		-0.52671,
		0,
		-0.717258,
		0.509084,
		0.475788,
		0,
		0.757315,
		1.214101,
		-0.24338,
		1,
	},
	[0.533333333333] = {
		0.675231,
		0.244945,
		0.695748,
		0,
		0.2335,
		0.823757,
		-0.516626,
		0,
		-0.699672,
		0.511299,
		0.499032,
		0,
		0.768817,
		1.19627,
		-0.195186,
		1,
	},
	[0.55] = {
		0.697585,
		0.212117,
		0.684384,
		0,
		0.232835,
		0.836225,
		-0.496504,
		0,
		-0.677615,
		0.505702,
		0.53395,
		0,
		0.779522,
		1.177469,
		-0.146662,
		1,
	},
	[0.566666666667] = {
		0.724827,
		0.167772,
		0.66819,
		0,
		0.229394,
		0.855776,
		-0.463709,
		0,
		-0.649619,
		0.489387,
		0.581804,
		0,
		0.789339,
		1.157687,
		-0.097979,
		1,
	},
	[0.583333333333] = {
		0.757273,
		0.110352,
		0.643709,
		0,
		0.223821,
		0.882085,
		-0.414525,
		0,
		-0.613549,
		0.457984,
		0.643279,
		0,
		0.798293,
		1.136742,
		-0.049026,
		1,
	},
	[0.5] = {
		0.643459,
		0.28201,
		0.71164,
		0,
		0.226001,
		0.818234,
		-0.528599,
		0,
		-0.731358,
		0.500963,
		0.462766,
		0,
		0.745168,
		1.230894,
		-0.290859,
		1,
	},
	[0.616666666667] = {
		0.851629,
		-0.080405,
		0.517942,
		0,
		0.206172,
		0.959895,
		-0.189985,
		0,
		-0.481894,
		0.268582,
		0.834051,
		0,
		0.812604,
		1.049896,
		0.085952,
		1,
	},
	[0.633333333333] = {
		0.90239,
		-0.195952,
		0.383791,
		0,
		0.212666,
		0.977124,
		-0.001142,
		0,
		-0.374788,
		0.08265,
		0.923419,
		0,
		0.823349,
		0.975687,
		0.177076,
		1,
	},
	[0.65] = {
		0.936951,
		-0.288764,
		0.19682,
		0,
		0.246246,
		0.945178,
		0.214478,
		0,
		-0.247964,
		-0.15249,
		0.956693,
		0,
		0.841644,
		0.881708,
		0.275212,
		1,
	},
	[0.666666666667] = {
		0.942994,
		-0.332215,
		-0.01989,
		0,
		0.309901,
		0.854722,
		0.416426,
		0,
		-0.121342,
		-0.398851,
		0.908952,
		0,
		0.869005,
		0.772556,
		0.367974,
		1,
	},
	[0.683333333333] = {
		0.919357,
		-0.320617,
		-0.228008,
		0,
		0.39307,
		0.723939,
		0.566929,
		0,
		-0.016703,
		-0.610833,
		0.791583,
		0,
		0.903487,
		0.659834,
		0.443377,
		1,
	},
	[0.6] = {
		0.799611,
		0.028386,
		0.599848,
		0,
		0.214392,
		0.919562,
		-0.329305,
		0,
		-0.560945,
		0.391918,
		0.729206,
		0,
		0.805589,
		1.103824,
		0.009555,
		1,
	},
	[0.716666666667] = {
		0.827747,
		-0.216191,
		-0.517779,
		0,
		0.552398,
		0.475881,
		0.684393,
		0,
		0.098442,
		-0.852525,
		0.513333,
		0,
		0.979582,
		0.486862,
		0.524616,
		1,
	},
	[0.733333333333] = {
		0.783927,
		-0.175697,
		-0.595474,
		0,
		0.608655,
		0.40668,
		0.681286,
		0,
		0.122467,
		-0.896517,
		0.425746,
		0,
		1.017161,
		0.453804,
		0.533282,
		1,
	},
	[0.75] = {
		0.747077,
		-0.166507,
		-0.643546,
		0,
		0.650039,
		0.385453,
		0.654886,
		0,
		0.139014,
		-0.90758,
		0.396199,
		0,
		1.061612,
		0.481292,
		0.520601,
		1,
	},
	[0.766666666667] = {
		0.714374,
		-0.187741,
		-0.67411,
		0,
		0.682251,
		0.401038,
		0.611312,
		0,
		0.155576,
		-0.896617,
		0.414577,
		0,
		1.116592,
		0.567862,
		0.489374,
		1,
	},
	[0.783333333333] = {
		0.685502,
		-0.231694,
		-0.690221,
		0,
		0.706852,
		0.438991,
		0.554659,
		0,
		0.17449,
		-0.868104,
		0.464703,
		0,
		1.176016,
		0.690205,
		0.446044,
		1,
	},
	[0.7] = {
		0.876364,
		-0.272527,
		-0.397134,
		0,
		0.478448,
		0.587484,
		0.652649,
		0,
		0.055446,
		-0.761966,
		0.64524,
		0,
		0.941325,
		0.559542,
		0.495498,
		1,
	},
	[0.816666666667] = {
		0.639558,
		-0.348114,
		-0.685407,
		0,
		0.737248,
		0.53034,
		0.418574,
		0,
		0.217787,
		-0.773017,
		0.59583,
		0,
		1.283146,
		0.94976,
		0.349077,
		1,
	},
	[0.833333333333] = {
		0.622231,
		-0.39823,
		-0.673974,
		0,
		0.745815,
		0.563181,
		0.35579,
		0,
		0.237884,
		-0.724044,
		0.647435,
		0,
		1.318499,
		1.041633,
		0.3109,
		1,
	},
	[0.85] = {
		0.607538,
		-0.428806,
		-0.668597,
		0,
		0.75292,
		0.579021,
		0.312804,
		0,
		0.253,
		-0.693441,
		0.674634,
		0,
		1.333768,
		1.079158,
		0.291523,
		1,
	},
	[0.866666666667] = {
		0.596397,
		-0.442193,
		-0.669907,
		0,
		0.758597,
		0.583301,
		0.290328,
		0,
		0.262377,
		-0.681341,
		0.683325,
		0,
		1.336546,
		1.081794,
		0.286029,
		1,
	},
	[0.883333333333] = {
		0.590034,
		-0.448211,
		-0.67154,
		0,
		0.761682,
		0.584868,
		0.278872,
		0,
		0.267769,
		-0.676044,
		0.686487,
		0,
		1.33835,
		1.08325,
		0.282955,
		1,
	},
	[0.8] = {
		0.660531,
		-0.288829,
		-0.69302,
		0,
		0.724826,
		0.485996,
		0.488298,
		0,
		0.195771,
		-0.824855,
		0.530366,
		0,
		1.23362,
		0.825155,
		0.396899,
		1,
	},
	[0.916666666667] = {
		0.588001,
		-0.444312,
		-0.675901,
		0,
		0.762612,
		0.583032,
		0.280172,
		0,
		0.269589,
		-0.680191,
		0.681661,
		0,
		1.339832,
		1.083758,
		0.282309,
		1,
	},
	[0.933333333333] = {
		0.590499,
		-0.437435,
		-0.678205,
		0,
		0.761375,
		0.580624,
		0.288416,
		0,
		0.267619,
		-0.686677,
		0.67591,
		0,
		1.339838,
		1.08324,
		0.283781,
		1,
	},
	[0.95] = {
		0.5941,
		-0.429323,
		-0.68024,
		0,
		0.759558,
		0.577792,
		0.29871,
		0,
		0.264795,
		-0.694146,
		0.669362,
		0,
		1.339558,
		1.082468,
		0.285788,
		1,
	},
	[0.966666666667] = {
		0.597859,
		-0.421545,
		-0.68181,
		0,
		0.757617,
		0.575025,
		0.308809,
		0,
		0.261881,
		-0.701175,
		0.663153,
		0,
		1.339151,
		1.081642,
		0.287832,
		1,
	},
	[0.983333333333] = {
		0.600818,
		-0.415699,
		-0.682797,
		0,
		0.756055,
		0.5729,
		0.31649,
		0,
		0.25961,
		-0.706385,
		0.6585,
		0,
		1.338781,
		1.08098,
		0.289419,
		1,
	},
	[0.9] = {
		0.587539,
		-0.44841,
		-0.673592,
		0,
		0.762855,
		0.584591,
		0.276236,
		0,
		0.269909,
		-0.676152,
		0.685542,
		0,
		1.339388,
		1.083828,
		0.281872,
		1,
	},
	{
		0.602018,
		-0.413394,
		-0.68314,
		0,
		0.755415,
		0.57205,
		0.319541,
		0,
		0.258694,
		-0.708423,
		0.656669,
		0,
		1.338619,
		1.080708,
		0.290056,
		1,
	},
}

return spline_matrices
