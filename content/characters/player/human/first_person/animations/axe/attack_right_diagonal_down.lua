﻿-- chunkname: @content/characters/player/human/first_person/animations/axe/attack_right_diagonal_down.lua

local spline_matrices = {
	[0.0333333333333] = {
		0.345536,
		-0.904718,
		0.249178,
		0,
		-0.808078,
		-0.151868,
		0.569162,
		0,
		-0.477089,
		-0.398022,
		-0.783559,
		0,
		-0.043026,
		-0.034098,
		-0.428311,
		1
	},
	[0.0666666666667] = {
		-0.070898,
		-0.575352,
		0.814827,
		0,
		-0.774642,
		0.546393,
		0.318408,
		0,
		-0.628413,
		-0.608625,
		-0.48443,
		0,
		-0.180597,
		-0.007457,
		-0.397283,
		1
	},
	[0] = {
		0.672484,
		-0.663485,
		-0.327952,
		0,
		-0.560415,
		-0.745919,
		0.359918,
		0,
		-0.483425,
		-0.05825,
		-0.873446,
		0,
		0.098982,
		-0.063357,
		-0.451815,
		1
	},
	[0.133333333333] = {
		-0.194735,
		0.069034,
		0.978424,
		0,
		-0.559562,
		0.811454,
		-0.168622,
		0,
		-0.805586,
		-0.580325,
		-0.11939,
		0,
		-0.36086,
		0.008183,
		-0.303777,
		1
	},
	[0.166666666667] = {
		-0.122629,
		0.163584,
		0.978878,
		0,
		-0.595026,
		0.777271,
		-0.204435,
		0,
		-0.794296,
		-0.607527,
		0.002021,
		0,
		-0.414042,
		-0.008036,
		-0.24284,
		1
	},
	[0.1] = {
		-0.212185,
		-0.122051,
		0.969578,
		0,
		-0.596568,
		0.802017,
		-0.029596,
		0,
		-0.774005,
		-0.584699,
		-0.242988,
		0,
		-0.288592,
		0.010444,
		-0.3555,
		1
	},
	[0.233333333333] = {
		0.141758,
		0.217663,
		0.965675,
		0,
		-0.751511,
		0.658618,
		-0.038133,
		0,
		-0.644311,
		-0.720309,
		0.25694,
		0,
		-0.470128,
		-0.058637,
		-0.103904,
		1
	},
	[0.266666666667] = {
		0.321858,
		0.221324,
		0.920556,
		0,
		-0.797075,
		0.588064,
		0.1373,
		0,
		-0.510958,
		-0.777943,
		0.365685,
		0,
		-0.476597,
		-0.080345,
		-0.032726,
		1
	},
	[0.2] = {
		-0.009923,
		0.204429,
		0.978831,
		0,
		-0.670819,
		0.724567,
		-0.158127,
		0,
		-0.741555,
		-0.658187,
		0.129945,
		0,
		-0.449937,
		-0.032343,
		-0.17524,
		1
	},
	[0.333333333333] = {
		0.762905,
		0.216823,
		0.609068,
		0,
		-0.643205,
		0.34969,
		0.681178,
		0,
		-0.06529,
		-0.91143,
		0.406242,
		0,
		-0.395553,
		-0.013812,
		0.102451,
		1
	},
	[0.366666666667] = {
		0.905382,
		0.122292,
		0.406606,
		0,
		-0.418435,
		0.419557,
		0.805534,
		0,
		-0.072084,
		-0.899454,
		0.43103,
		0,
		-0.291454,
		0.193392,
		0.14498,
		1
	},
	[0.3] = {
		0.50363,
		0.223283,
		0.834567,
		0,
		-0.779042,
		0.534942,
		0.327002,
		0,
		-0.373431,
		-0.81485,
		0.44336,
		0,
		-0.47296,
		-0.090255,
		0.034048,
		1
	},
	[0.433333333333] = {
		0.519228,
		-0.034651,
		0.853933,
		0,
		0.834492,
		0.236211,
		-0.497822,
		0,
		-0.184459,
		0.971084,
		0.151564,
		0,
		0.174112,
		0.745711,
		-0.151289,
		1
	},
	[0.466666666667] = {
		0.469909,
		0.03987,
		0.881814,
		0,
		0.766397,
		-0.514088,
		-0.385161,
		0,
		0.437974,
		0.85681,
		-0.272131,
		0,
		0.483949,
		0.561699,
		-0.320089,
		1
	},
	[0.4] = {
		0.530693,
		-0.135824,
		0.83661,
		0,
		0.238555,
		0.971108,
		0.006335,
		0,
		-0.8133,
		0.196215,
		0.547762,
		0,
		-0.225068,
		0.611169,
		0.087646,
		1
	},
	[0.533333333333] = {
		0.424605,
		-0.134461,
		0.895339,
		0,
		0.375817,
		-0.873514,
		-0.309411,
		0,
		0.823694,
		0.467861,
		-0.320365,
		0,
		0.685246,
		0.281964,
		-0.417126,
		1
	},
	[0.566666666667] = {
		0.407947,
		-0.09798,
		0.907733,
		0,
		0.218626,
		-0.954817,
		-0.201315,
		0,
		0.886443,
		0.28058,
		-0.368093,
		0,
		0.697817,
		0.218764,
		-0.442967,
		1
	},
	[0.5] = {
		0.4597,
		-0.112506,
		0.880919,
		0,
		0.55191,
		-0.740934,
		-0.382638,
		0,
		0.695752,
		0.662087,
		-0.278515,
		0,
		0.639603,
		0.39141,
		-0.379566,
		1
	},
	[0.633333333333] = {
		0.513037,
		0.022015,
		0.858084,
		0,
		-0.066867,
		-0.995608,
		0.065522,
		0,
		0.855758,
		-0.090993,
		-0.509312,
		0,
		0.683819,
		0.100768,
		-0.487996,
		1
	},
	[0.666666666667] = {
		0.655116,
		0.084194,
		0.750822,
		0,
		-0.204863,
		-0.936746,
		0.283793,
		0,
		0.727224,
		-0.339733,
		-0.596429,
		0,
		0.646973,
		0.022076,
		-0.515826,
		1
	},
	[0.6] = {
		0.432939,
		-0.035409,
		0.900727,
		0,
		0.075621,
		-0.994279,
		-0.075435,
		0,
		0.898246,
		0.100773,
		-0.427785,
		0,
		0.696379,
		0.166615,
		-0.464498,
		1
	},
	[0.733333333333] = {
		0.918898,
		0.030863,
		0.393286,
		0,
		-0.260419,
		-0.701391,
		0.6635,
		0,
		0.296325,
		-0.712108,
		-0.636469,
		0,
		0.5165,
		-0.138437,
		-0.556207,
		1
	},
	[0.766666666667] = {
		0.969701,
		-0.063613,
		0.235866,
		0,
		-0.214743,
		-0.682266,
		0.698855,
		0,
		0.116468,
		-0.728331,
		-0.675255,
		0,
		0.450007,
		-0.208759,
		-0.564445,
		1
	},
	[0.7] = {
		0.809314,
		0.092409,
		0.580062,
		0,
		-0.273435,
		-0.814744,
		0.511298,
		0,
		0.519851,
		-0.57241,
		-0.634115,
		0,
		0.587579,
		-0.059886,
		-0.539936,
		1
	},
	[0.833333333333] = {
		0.96667,
		-0.223384,
		-0.125095,
		0,
		-0.184036,
		-0.945946,
		0.267053,
		0,
		-0.177988,
		-0.235131,
		-0.955528,
		0,
		0.311444,
		-0.341645,
		-0.572859,
		1
	},
	[0.866666666667] = {
		0.916935,
		-0.17264,
		-0.359757,
		0,
		-0.266127,
		-0.936352,
		-0.228959,
		0,
		-0.297332,
		0.305681,
		-0.904518,
		0,
		0.21587,
		-0.374451,
		-0.514289,
		1
	},
	[0.8] = {
		0.983486,
		-0.161068,
		0.082542,
		0,
		-0.178727,
		-0.792472,
		0.583133,
		0,
		-0.028512,
		-0.588256,
		-0.808172,
		0,
		0.387945,
		-0.274959,
		-0.57175,
		1
	},
	[0.933333333333] = {
		0.82413,
		0.162773,
		-0.542507,
		0,
		-0.487863,
		-0.282598,
		-0.82591,
		0,
		-0.287748,
		0.945327,
		-0.153487,
		0,
		0.058104,
		-0.411192,
		-0.350023,
		1
	},
	[0.966666666667] = {
		0.804092,
		0.262583,
		-0.533373,
		0,
		-0.539329,
		-0.055268,
		-0.84028,
		0,
		-0.250122,
		0.963325,
		0.097178,
		0,
		0.00855,
		-0.433334,
		-0.29174,
		1
	},
	[0.9] = {
		0.859929,
		-0.005107,
		-0.510387,
		0,
		-0.392398,
		-0.646089,
		-0.65467,
		0,
		-0.326412,
		0.763245,
		-0.557595,
		0,
		0.128368,
		-0.391546,
		-0.432485,
		1
	},
	[1.03333333333] = {
		0.797572,
		0.284902,
		-0.531705,
		0,
		-0.553082,
		-0.006463,
		-0.833102,
		0,
		-0.240789,
		0.958535,
		0.15242,
		0,
		-0.006014,
		-0.441261,
		-0.276963,
		1
	},
	[1.06666666667] = {
		0.802907,
		0.265085,
		-0.533919,
		0,
		-0.542403,
		-0.046641,
		-0.838823,
		0,
		-0.247262,
		0.963096,
		0.106335,
		0,
		0.005325,
		-0.434778,
		-0.289088,
		1
	},
	{
		0.795206,
		0.29427,
		-0.530144,
		0,
		-0.557642,
		0.011625,
		-0.83,
		0,
		-0.238081,
		0.955652,
		0.173342,
		0,
		-0.011045,
		-0.444312,
		-0.271375,
		1
	},
	[1.1] = {
		0.804011,
		0.261034,
		-0.534254,
		0,
		-0.540191,
		-0.054863,
		-0.839752,
		0,
		-0.248514,
		0.963769,
		0.096898,
		0,
		0.007598,
		-0.433501,
		-0.291518,
		1
	}
}

return spline_matrices
