﻿-- chunkname: @content/characters/player/human/first_person/animations/force_sword/attack_left_diagonal_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.890393,
		-0.211069,
		-0.403299,
		0,
		0.285007,
		0.949339,
		0.132389,
		0,
		0.354924,
		-0.232821,
		0.905441,
		0,
		0.470395,
		0.430972,
		0.115164,
		1
	},
	[0.0333333333333] = {
		0.752989,
		-0.131145,
		-0.644833,
		0,
		0.441907,
		0.826868,
		0.34786,
		0,
		0.487572,
		-0.546891,
		0.680576,
		0,
		0.558889,
		0.332814,
		0.217829,
		1
	},
	[0.05] = {
		0.661443,
		0.091352,
		-0.744412,
		0,
		0.519311,
		0.660339,
		0.542465,
		0,
		0.541119,
		-0.745391,
		0.389336,
		0,
		0.600952,
		0.251484,
		0.280464,
		1
	},
	[0.0666666666667] = {
		0.661746,
		0.260801,
		-0.702905,
		0,
		0.516222,
		0.521402,
		0.679451,
		0,
		0.543698,
		-0.812479,
		0.210405,
		0,
		0.591406,
		0.219447,
		0.293704,
		1
	},
	[0.0833333333333] = {
		0.667091,
		0.261222,
		-0.697677,
		0,
		0.482145,
		0.562537,
		0.671631,
		0,
		0.567914,
		-0.78442,
		0.249317,
		0,
		0.582059,
		0.276954,
		0.263714,
		1
	},
	[0] = {
		0.971412,
		-0.121334,
		-0.204052,
		0,
		0.106808,
		0.990992,
		-0.080795,
		0,
		0.212017,
		0.056691,
		0.97562,
		0,
		0.407829,
		0.506809,
		-0.01101,
		1
	},
	[0.116666666667] = {
		0.550416,
		0.30676,
		-0.776492,
		0,
		0.084878,
		0.904674,
		0.417564,
		0,
		0.830565,
		-0.295741,
		0.471911,
		0,
		0.515157,
		0.478143,
		0.188641,
		1
	},
	[0.133333333333] = {
		0.428267,
		0.388011,
		-0.816109,
		0,
		-0.284819,
		0.915051,
		0.285588,
		0,
		0.857593,
		0.110135,
		0.502399,
		0,
		0.429537,
		0.571197,
		0.15624,
		1
	},
	[0.15] = {
		0.411836,
		0.250193,
		-0.876239,
		0,
		-0.506723,
		0.862072,
		0.007986,
		0,
		0.757379,
		0.440721,
		0.481811,
		0,
		0.289104,
		0.6417,
		0.126459,
		1
	},
	[0.166666666667] = {
		0.58997,
		0.150071,
		-0.793356,
		0,
		-0.73131,
		0.515784,
		-0.446265,
		0,
		0.342229,
		0.843472,
		0.414046,
		0,
		0.123428,
		0.682857,
		0.060216,
		1
	},
	[0.183333333333] = {
		0.623356,
		0.093865,
		-0.776284,
		0,
		-0.770787,
		0.240821,
		-0.589824,
		0,
		0.131581,
		0.96602,
		0.222468,
		0,
		0.018781,
		0.679102,
		-0.045792,
		1
	},
	[0.1] = {
		0.634624,
		0.223873,
		-0.739684,
		0,
		0.388256,
		0.735209,
		0.55563,
		0,
		0.668213,
		-0.639803,
		0.379662,
		0,
		0.565746,
		0.378786,
		0.221568,
		1
	},
	[0.216666666667] = {
		0.682541,
		0.095682,
		-0.724557,
		0,
		-0.648269,
		-0.378515,
		-0.660662,
		0,
		-0.337469,
		0.920636,
		-0.196324,
		0,
		-0.137349,
		0.61584,
		-0.167953,
		1
	},
	[0.233333333333] = {
		0.734786,
		0.291592,
		-0.612425,
		0,
		-0.337179,
		-0.626408,
		-0.702797,
		0,
		-0.588558,
		0.722902,
		-0.361957,
		0,
		-0.25465,
		0.544724,
		-0.249262,
		1
	},
	[0.25] = {
		0.711278,
		0.16665,
		-0.68287,
		0,
		-0.392547,
		-0.711706,
		-0.582565,
		0,
		-0.583087,
		0.682424,
		-0.440803,
		0,
		-0.361914,
		0.356466,
		-0.346445,
		1
	},
	[0.266666666667] = {
		0.667118,
		0.045186,
		-0.74358,
		0,
		-0.367115,
		-0.848597,
		-0.380933,
		0,
		-0.648213,
		0.527107,
		-0.549526,
		0,
		-0.338057,
		0.28828,
		-0.407365,
		1
	},
	[0.283333333333] = {
		0.61157,
		-0.013895,
		-0.791069,
		0,
		-0.170469,
		-0.978676,
		-0.114599,
		0,
		-0.772608,
		0.204938,
		-0.600897,
		0,
		-0.354491,
		0.181671,
		-0.429739,
		1
	},
	[0.2] = {
		0.701702,
		0.064587,
		-0.709537,
		0,
		-0.704201,
		-0.08842,
		-0.704474,
		0,
		-0.108237,
		0.993987,
		-0.016562,
		0,
		-0.0599,
		0.655663,
		-0.105424,
		1
	},
	[0.316666666667] = {
		0.223753,
		0.121123,
		-0.96709,
		0,
		0.574574,
		-0.817884,
		0.030501,
		0,
		-0.787274,
		-0.562489,
		-0.252598,
		0,
		-0.357502,
		-0.050866,
		-0.414263,
		1
	},
	[0.333333333333] = {
		0.357208,
		0.216132,
		-0.908674,
		0,
		0.844083,
		-0.491233,
		0.214975,
		0,
		-0.399908,
		-0.843787,
		-0.357906,
		0,
		-0.277973,
		-0.143226,
		-0.442089,
		1
	},
	[0.35] = {
		0.488984,
		0.309564,
		-0.815515,
		0,
		0.852597,
		-0.367164,
		0.371845,
		0,
		-0.184318,
		-0.877132,
		-0.443471,
		0,
		-0.225353,
		-0.215007,
		-0.459763,
		1
	},
	[0.366666666667] = {
		0.56034,
		0.3396,
		-0.755441,
		0,
		0.822253,
		-0.337758,
		0.458061,
		0,
		-0.099599,
		-0.877833,
		-0.468497,
		0,
		-0.19573,
		-0.247373,
		-0.469999,
		1
	},
	[0.383333333333] = {
		0.621145,
		0.35506,
		-0.698649,
		0,
		0.782594,
		-0.328272,
		0.528947,
		0,
		-0.041539,
		-0.875311,
		-0.481772,
		0,
		-0.168472,
		-0.275109,
		-0.479012,
		1
	},
	[0.3] = {
		0.380577,
		0.082423,
		-0.921069,
		0,
		0.202937,
		-0.979185,
		-0.003772,
		0,
		-0.902207,
		-0.185483,
		-0.389382,
		0,
		-0.375653,
		0.061284,
		-0.413368,
		1
	},
	[0.416666666667] = {
		0.720712,
		0.355836,
		-0.594942,
		0,
		0.693176,
		-0.35874,
		0.62515,
		0,
		0.009021,
		-0.862952,
		-0.505205,
		0,
		-0.120344,
		-0.317954,
		-0.49821,
		1
	},
	[0.433333333333] = {
		0.761386,
		0.349674,
		-0.545911,
		0,
		0.648165,
		-0.393471,
		0.651968,
		0,
		0.013176,
		-0.85024,
		-0.52623,
		0,
		-0.098376,
		-0.333331,
		-0.510031,
		1
	},
	[0.45] = {
		0.796781,
		0.345126,
		-0.496011,
		0,
		0.604137,
		-0.437921,
		0.665765,
		0,
		0.012559,
		-0.830128,
		-0.557431,
		0,
		-0.076821,
		-0.344727,
		-0.523958,
		1
	},
	[0.466666666667] = {
		0.827641,
		0.346162,
		-0.441793,
		0,
		0.561067,
		-0.489798,
		0.667309,
		0,
		0.014608,
		-0.800169,
		-0.599597,
		0,
		-0.054874,
		-0.352118,
		-0.540174,
		1
	},
	[0.483333333333] = {
		0.854625,
		0.355655,
		-0.37832,
		0,
		0.518551,
		-0.54692,
		0.657255,
		0,
		0.026845,
		-0.757884,
		-0.651836,
		0,
		-0.030585,
		-0.354033,
		-0.556585,
		1
	},
	[0.4] = {
		0.674175,
		0.359126,
		-0.645381,
		0,
		0.738538,
		-0.336152,
		0.584434,
		0,
		-0.007061,
		-0.87065,
		-0.491853,
		0,
		-0.143491,
		-0.298573,
		-0.488093,
		1
	},
	[0.516666666667] = {
		0.898343,
		0.365691,
		-0.243412,
		0,
		0.435466,
		-0.668311,
		0.6031,
		0,
		0.057874,
		-0.647788,
		-0.759619,
		0,
		0.019853,
		-0.343548,
		-0.587458,
		1
	},
	[0.533333333333] = {
		0.916243,
		0.357411,
		-0.180988,
		0,
		0.394794,
		-0.728735,
		0.559538,
		0,
		0.068092,
		-0.584126,
		-0.808802,
		0,
		0.043704,
		-0.33302,
		-0.602693,
		1
	},
	[0.55] = {
		0.93205,
		0.340915,
		-0.122722,
		0,
		0.354295,
		-0.786574,
		0.505744,
		0,
		0.075885,
		-0.514858,
		-0.85391,
		0,
		0.066634,
		-0.319291,
		-0.617628,
		1
	},
	[0.566666666667] = {
		0.945958,
		0.316828,
		-0.069167,
		0,
		0.313727,
		-0.840093,
		0.442515,
		0,
		0.082095,
		-0.4403,
		-0.89409,
		0,
		0.088647,
		-0.302628,
		-0.632109,
		1
	},
	[0.583333333333] = {
		0.958035,
		0.285895,
		-0.020814,
		0,
		0.272952,
		-0.887662,
		0.370881,
		0,
		0.087558,
		-0.360998,
		-0.928447,
		0,
		0.109751,
		-0.283334,
		-0.645969,
		1
	},
	[0.5] = {
		0.877992,
		0.365244,
		-0.309399,
		0,
		0.476613,
		-0.607098,
		0.635824,
		0,
		0.044396,
		-0.705712,
		-0.707107,
		0,
		-0.004915,
		-0.350628,
		-0.572054,
		1
	},
	[0.616666666667] = {
		0.976558,
		0.207061,
		0.058819,
		0,
		0.19091,
		-0.959383,
		0.207695,
		0,
		0.099435,
		-0.191597,
		-0.976424,
		0,
		0.149305,
		-0.238251,
		-0.671142,
		1
	},
	[0.633333333333] = {
		0.982836,
		0.161192,
		0.089729,
		0,
		0.150072,
		-0.981449,
		0.119313,
		0,
		0.107297,
		-0.103799,
		-0.988794,
		0,
		0.167788,
		-0.213263,
		-0.682143,
		1
	},
	[0.65] = {
		0.987005,
		0.112474,
		0.114765,
		0,
		0.109874,
		-0.99353,
		0.028752,
		0,
		0.117257,
		-0.015769,
		-0.992976,
		0,
		0.185426,
		-0.187239,
		-0.691918,
		1
	},
	[0.666666666667] = {
		0.989009,
		0.061996,
		0.134233,
		0,
		0.070845,
		-0.995548,
		-0.062176,
		0,
		0.129781,
		0.071003,
		-0.988997,
		0,
		0.202222,
		-0.160661,
		-0.700384,
		1
	},
	[0.683333333333] = {
		0.988831,
		0.010786,
		0.14865,
		0,
		0.033586,
		-0.98785,
		-0.151735,
		0,
		0.145207,
		0.155033,
		-0.977179,
		0,
		0.218168,
		-0.134027,
		-0.707497,
		1
	},
	[0.6] = {
		0.96826,
		0.248981,
		0.021938,
		0,
		0.231966,
		-0.927827,
		0.29211,
		0,
		0.093084,
		-0.27775,
		-0.956133,
		0,
		0.129965,
		-0.261748,
		-0.659035,
		1
	},
	[0.716666666667] = {
		0.982093,
		-0.090347,
		0.165321,
		0,
		-0.033098,
		-0.946605,
		-0.320692,
		0,
		0.185467,
		0.309477,
		-0.932644,
		0,
		0.247403,
		-0.082581,
		-0.7177,
		1
	},
	[0.733333333333] = {
		0.975698,
		-0.138945,
		0.169435,
		0,
		-0.061303,
		-0.915462,
		-0.397707,
		0,
		0.210371,
		0.377655,
		-0.901732,
		0,
		0.260609,
		-0.05874,
		-0.720895,
		1
	},
	[0.75] = {
		0.967419,
		-0.185664,
		0.172135,
		0,
		-0.085354,
		-0.87925,
		-0.468651,
		0,
		0.238361,
		0.438689,
		-0.86645,
		0,
		0.272797,
		-0.036765,
		-0.722936,
		1
	},
	[0.766666666667] = {
		0.957338,
		-0.23031,
		0.174532,
		0,
		-0.104791,
		-0.839556,
		-0.533071,
		0,
		0.269301,
		0.49204,
		-0.827873,
		0,
		0.283904,
		-0.017082,
		-0.723929,
		1
	},
	[0.783333333333] = {
		0.945491,
		-0.272858,
		0.177749,
		0,
		-0.119226,
		-0.797982,
		-0.590771,
		0,
		0.303038,
		0.537376,
		-0.787017,
		0,
		0.29386,
		-9.4e-05,
		-0.723985,
		1
	},
	[0.7] = {
		0.986503,
		-0.040246,
		0.158723,
		0,
		-0.001272,
		-0.971178,
		-0.238352,
		0,
		0.163741,
		0.234933,
		-0.958121,
		0,
		0.23324,
		-0.107835,
		-0.713256,
		1
	},
	[0.816666666667] = {
		0.916185,
		-0.35225,
		0.191113,
		0,
		-0.131947,
		-0.715433,
		-0.686109,
		0,
		0.37841,
		0.603386,
		-0.701948,
		0,
		0.310058,
		0.024226,
		-0.721711,
		1
	},
	[0.833333333333] = {
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
	[0.8] = {
		0.931836,
		-0.313414,
		0.182902,
		0,
		-0.128341,
		-0.756096,
		-0.641754,
		0,
		0.339426,
		0.574536,
		-0.744781,
		0,
		0.302599,
		0.013824,
		-0.723213,
		1
	}
}

return spline_matrices
