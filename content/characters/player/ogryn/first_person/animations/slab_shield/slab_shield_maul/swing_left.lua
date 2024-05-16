﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_left.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.940402,
		-0.338915,
		0.027922,
		0,
		0.334455,
		0.90692,
		-0.256194,
		0,
		0.061505,
		0.250264,
		0.966222,
		0,
		0.809881,
		0.951582,
		-0.570303,
		1,
	},
	[0.0333333333333] = {
		0.901237,
		-0.433209,
		0.010052,
		0,
		0.419185,
		0.865716,
		-0.27353,
		0,
		0.109793,
		0.250729,
		0.961811,
		0,
		0.834449,
		0.943754,
		-0.563486,
		1,
	},
	[0.05] = {
		0.841078,
		-0.540897,
		-0.004307,
		0,
		0.51469,
		0.802726,
		-0.301207,
		0,
		0.166379,
		0.251121,
		0.953549,
		0,
		0.867049,
		0.92752,
		-0.55436,
		1,
	},
	[0.0666666666667] = {
		0.757603,
		-0.65257,
		-0.013798,
		0,
		0.610278,
		0.715685,
		-0.33964,
		0,
		0.231514,
		0.248892,
		0.940454,
		0,
		0.906541,
		0.904527,
		-0.542984,
		1,
	},
	[0.0833333333333] = {
		0.651699,
		-0.758302,
		-0.016318,
		0,
		0.694739,
		0.605429,
		-0.388321,
		0,
		0.304344,
		0.241732,
		0.92138,
		0,
		0.951682,
		0.876483,
		-0.52944,
		1,
	},
	[0] = {
		0.962734,
		-0.265964,
		0.049053,
		0,
		0.269682,
		0.930422,
		-0.248167,
		0,
		0.020364,
		0.252148,
		0.967474,
		0,
		0.794385,
		0.949395,
		-0.574786,
		1,
	},
	[0.116666666667] = {
		0.394922,
		-0.91868,
		0.007937,
		0,
		0.792801,
		0.336419,
		-0.508222,
		0,
		0.464223,
		0.207001,
		0.861189,
		0,
		1.053544,
		0.812583,
		-0.496183,
		1,
	},
	[0.133333333333] = {
		0.262248,
		-0.964309,
		0.036529,
		0,
		0.796387,
		0.194893,
		-0.572525,
		0,
		0.544972,
		0.179235,
		0.819073,
		0,
		1.107539,
		0.780677,
		-0.476581,
		1,
	},
	[0.15] = {
		0.139931,
		-0.98736,
		0.074427,
		0,
		0.770582,
		0.061389,
		-0.634378,
		0,
		0.62179,
		0.146121,
		0.769432,
		0,
		1.16185,
		0.751582,
		-0.455012,
		1,
	},
	[0.166666666667] = {
		0.035592,
		-0.992381,
		0.117956,
		0,
		0.721106,
		-0.056216,
		-0.69054,
		0,
		0.69191,
		0.109637,
		0.713611,
		0,
		1.21533,
		0.727423,
		-0.431453,
		1,
	},
	[0.183333333333] = {
		-0.046661,
		-0.985687,
		0.162002,
		0,
		0.655834,
		-0.152558,
		-0.73933,
		0,
		0.753462,
		0.071749,
		0.653565,
		0,
		1.266972,
		0.710295,
		-0.40587,
		1,
	},
	[0.1] = {
		0.528093,
		-0.849132,
		-0.009613,
		0,
		0.75797,
		0.476441,
		-0.445517,
		0,
		0.382883,
		0.227988,
		0.895222,
		0,
		1.00114,
		0.845195,
		-0.513816,
		1,
	},
	[0.216666666667] = {
		-0.146472,
		-0.962429,
		0.228642,
		0,
		0.508996,
		-0.271516,
		-0.816824,
		0,
		0.848215,
		-0.003264,
		0.529642,
		0,
		1.361314,
		0.705088,
		-0.348603,
		1,
	},
	[0.233333333333] = {
		-0.171376,
		-0.955458,
		0.240273,
		0,
		0.439083,
		-0.292393,
		-0.849537,
		0,
		0.88195,
		-0.04009,
		0.469634,
		0,
		1.402495,
		0.720726,
		-0.316983,
		1,
	},
	[0.25] = {
		-0.186741,
		-0.954894,
		0.23088,
		0,
		0.376103,
		-0.286598,
		-0.88114,
		0,
		0.907565,
		-0.07771,
		0.412658,
		0,
		1.438725,
		0.750827,
		-0.283467,
		1,
	},
	[0.266666666667] = {
		-0.198303,
		-0.960374,
		0.195853,
		0,
		0.321961,
		-0.252558,
		-0.912445,
		0,
		0.925752,
		-0.117883,
		0.359286,
		0,
		1.469283,
		0.79699,
		-0.248137,
		1,
	},
	[0.283333333333] = {
		-0.207876,
		-0.966204,
		0.152437,
		0,
		0.275222,
		-0.20732,
		-0.93876,
		0,
		0.938637,
		-0.153192,
		0.309018,
		0,
		1.490769,
		0.850941,
		-0.219105,
		1,
	},
	[0.2] = {
		-0.106453,
		-0.973831,
		0.200799,
		0,
		0.582859,
		-0.224728,
		-0.78088,
		0,
		0.80557,
		0.033911,
		0.591529,
		0,
		1.315895,
		0.702213,
		-0.378248,
		1,
	},
	[0.316666666667] = {
		-0.227485,
		-0.967919,
		0.10669,
		0,
		0.187528,
		-0.151056,
		-0.970575,
		0,
		0.955554,
		-0.200784,
		0.215875,
		0,
		1.481567,
		0.959762,
		-0.202809,
		1,
	},
	[0.333333333333] = {
		-0.256434,
		-0.960287,
		0.109954,
		0,
		0.133976,
		-0.147973,
		-0.979875,
		0,
		0.957232,
		-0.236542,
		0.1666,
		0,
		1.428552,
		1.025755,
		-0.20543,
		1,
	},
	[0.35] = {
		-0.281841,
		-0.951096,
		0.126423,
		0,
		0.080528,
		-0.154749,
		-0.984666,
		0,
		0.956076,
		-0.267339,
		0.120205,
		0,
		1.344841,
		1.098242,
		-0.211349,
		1,
	},
	[0.366666666667] = {
		-0.28827,
		-0.945715,
		0.150078,
		0,
		0.034464,
		-0.166877,
		-0.985375,
		0,
		0.956929,
		-0.278882,
		0.080699,
		0,
		1.235899,
		1.174942,
		-0.218541,
		1,
	},
	[0.383333333333] = {
		-0.262755,
		-0.948949,
		0.174516,
		0,
		0.002894,
		-0.181646,
		-0.98336,
		0,
		0.964858,
		-0.257878,
		0.050475,
		0,
		1.109433,
		1.252088,
		-0.22495,
		1,
	},
	[0.3] = {
		-0.212534,
		-0.969589,
		0.121357,
		0,
		0.23345,
		-0.170981,
		-0.957218,
		0,
		0.948858,
		-0.17511,
		0.262689,
		0,
		1.499238,
		0.90308,
		-0.205344,
		1,
	},
	[0.416666666667] = {
		-0.0454,
		-0.978205,
		0.202618,
		0,
		0.016822,
		-0.203547,
		-0.978921,
		0,
		0.998827,
		-0.041035,
		0.025696,
		0,
		0.826707,
		1.398222,
		-0.227535,
		1,
	},
	[0.433333333333] = {
		0.275083,
		-0.939415,
		0.204522,
		0,
		0.107929,
		-0.18121,
		-0.977504,
		0,
		0.955343,
		0.290969,
		0.051542,
		0,
		0.604088,
		1.458114,
		-0.213422,
		1,
	},
	[0.45] = {
		0.66899,
		-0.708381,
		0.225054,
		0,
		0.22849,
		-0.092126,
		-0.969178,
		0,
		0.70728,
		0.699793,
		0.100226,
		0,
		0.303344,
		1.472865,
		-0.194545,
		1,
	},
	[0.466666666667] = {
		0.873752,
		-0.408684,
		0.263694,
		0,
		0.294414,
		0.012875,
		-0.955591,
		0,
		0.387139,
		0.912585,
		0.131572,
		0,
		0.04381,
		1.444568,
		-0.189249,
		1,
	},
	[0.483333333333] = {
		0.922055,
		-0.236422,
		0.306463,
		0,
		0.331236,
		0.072356,
		-0.94077,
		0,
		0.200244,
		0.968953,
		0.145028,
		0,
		-0.138,
		1.399666,
		-0.196208,
		1,
	},
	[0.4] = {
		-0.189626,
		-0.962559,
		0.193709,
		0,
		-0.00624,
		-0.196103,
		-0.980564,
		0,
		0.981837,
		-0.187149,
		0.03118,
		0,
		0.972229,
		1.327109,
		-0.228588,
		1,
	},
	[0.516666666667] = {
		0.687426,
		0.637837,
		0.347289,
		0,
		0.225299,
		0.267308,
		-0.936903,
		0,
		-0.690425,
		0.722295,
		0.04005,
		0,
		-0.847845,
		0.52623,
		-0.217178,
		1,
	},
	[0.533333333333] = {
		0.481922,
		0.802929,
		0.350795,
		0,
		0.181526,
		0.300177,
		-0.936452,
		0,
		-0.857205,
		0.514975,
		-0.001091,
		0,
		-0.849636,
		0.193751,
		-0.240139,
		1,
	},
	[0.55] = {
		0.323753,
		0.875975,
		0.357563,
		0,
		0.154871,
		0.323755,
		-0.93338,
		0,
		-0.93338,
		0.357561,
		-0.030846,
		0,
		-0.699781,
		-0.116244,
		-0.27849,
		1,
	},
	[0.566666666667] = {
		0.212784,
		0.905595,
		0.366907,
		0,
		0.135055,
		0.344643,
		-0.928968,
		0,
		-0.967721,
		0.247222,
		-0.048971,
		0,
		-0.534085,
		-0.382659,
		-0.317389,
		1,
	},
	[0.583333333333] = {
		0.128814,
		0.918737,
		0.373269,
		0,
		0.112419,
		0.360449,
		-0.92598,
		0,
		-0.985276,
		0.161241,
		-0.056852,
		0,
		-0.484416,
		-0.582043,
		-0.341296,
		1,
	},
	[0.5] = {
		0.904638,
		0.254633,
		0.341749,
		0,
		0.298463,
		0.193891,
		-0.934519,
		0,
		-0.304222,
		0.947401,
		0.099402,
		0,
		-0.512572,
		1.021487,
		-0.207317,
		1,
	},
	[0.616666666667] = {
		0.138866,
		0.912808,
		0.384054,
		0,
		0.077529,
		0.376601,
		-0.923126,
		0,
		-0.987272,
		0.157966,
		-0.018472,
		0,
		-0.621844,
		-0.574521,
		-0.343766,
		1,
	},
	[0.633333333333] = {
		0.197556,
		0.902134,
		0.38357,
		0,
		0.066362,
		0.378076,
		-0.923393,
		0,
		-0.978043,
		0.207877,
		0.014824,
		0,
		-0.678485,
		-0.493581,
		-0.344324,
		1,
	},
	[0.65] = {
		0.237022,
		0.894742,
		0.378494,
		0,
		0.056038,
		0.376356,
		-0.924779,
		0,
		-0.969887,
		0.240403,
		0.039065,
		0,
		-0.714179,
		-0.423698,
		-0.345374,
		1,
	},
	[0.666666666667] = {
		0.224323,
		0.899849,
		0.3741,
		0,
		0.044744,
		0.373968,
		-0.926362,
		0,
		-0.973487,
		0.224543,
		0.043627,
		0,
		-0.722459,
		-0.397518,
		-0.346112,
		1,
	},
	[0.683333333333] = {
		0.189584,
		0.910362,
		0.367829,
		0,
		0.028937,
		0.36928,
		-0.928867,
		0,
		-0.981438,
		0.186742,
		0.043667,
		0,
		-0.716245,
		-0.402314,
		-0.345062,
		1,
	},
	[0.6] = {
		0.099816,
		0.920178,
		0.378561,
		0,
		0.091315,
		0.370384,
		-0.924379,
		0,
		-0.990807,
		0.126836,
		-0.047056,
		0,
		-0.551781,
		-0.633882,
		-0.344903,
		1,
	},
	[0.716666666667] = {
		0.184194,
		0.917494,
		0.352531,
		0,
		0.002848,
		0.358168,
		-0.933653,
		0,
		-0.982886,
		0.172977,
		0.06336,
		0,
		-0.712255,
		-0.405239,
		-0.341061,
		1,
	},
	[0.733333333333] = {
		0.199032,
		0.91302,
		0.356062,
		0,
		0.009428,
		0.36153,
		-0.932313,
		0,
		-0.979948,
		0.188917,
		0.063348,
		0,
		-0.714254,
		-0.404723,
		-0.341811,
		1,
	},
	[0.75] = {
		0.215946,
		0.901051,
		0.376131,
		0,
		0.041185,
		0.376471,
		-0.925512,
		0,
		-0.975536,
		0.215352,
		0.044187,
		0,
		-0.718745,
		-0.403454,
		-0.346976,
		1,
	},
	[0.766666666667] = {
		0.233512,
		0.879973,
		0.413667,
		0,
		0.099452,
		0.401583,
		-0.910407,
		0,
		-0.967255,
		0.253731,
		0.006259,
		0,
		-0.708403,
		-0.399139,
		-0.366669,
		1,
	},
	[0.783333333333] = {
		0.253514,
		0.848901,
		0.463786,
		0,
		0.177558,
		0.430466,
		-0.88497,
		0,
		-0.950896,
		0.306701,
		-0.0416,
		0,
		-0.668672,
		-0.389192,
		-0.407604,
		1,
	},
	[0.7] = {
		0.17867,
		0.916257,
		0.358538,
		0,
		0.012162,
		0.362317,
		-0.931975,
		0,
		-0.983834,
		0.170877,
		0.053592,
		0,
		-0.712876,
		-0.404633,
		-0.342748,
		1,
	},
	[0.816666666667] = {
		0.284274,
		0.751708,
		0.595083,
		0,
		0.382473,
		0.480245,
		-0.789354,
		0,
		-0.879149,
		0.451996,
		-0.150987,
		0,
		-0.515641,
		-0.351277,
		-0.541341,
		1,
	},
	[0.833333333333] = {
		0.285905,
		0.684911,
		0.67019,
		0,
		0.499677,
		0.490218,
		-0.714149,
		0,
		-0.817668,
		0.539058,
		-0.202079,
		0,
		-0.40922,
		-0.323288,
		-0.627461,
		1,
	},
	[0.85] = {
		0.273092,
		0.607748,
		0.745696,
		0,
		0.617459,
		0.483674,
		-0.620326,
		0,
		-0.737676,
		0.629843,
		-0.243172,
		0,
		-0.287495,
		-0.289954,
		-0.721366,
		1,
	},
	[0.866666666667] = {
		0.243726,
		0.523455,
		0.816451,
		0,
		0.727795,
		0.457701,
		-0.510709,
		0,
		-0.641024,
		0.718682,
		-0.269415,
		0,
		-0.15433,
		-0.252432,
		-0.818942,
		1,
	},
	[0.883333333333] = {
		0.197874,
		0.436362,
		0.877744,
		0,
		0.82337,
		0.411898,
		-0.390387,
		0,
		-0.531891,
		0.799955,
		-0.277783,
		0,
		-0.014143,
		-0.212346,
		-0.916079,
		1,
	},
	[0.8] = {
		0.271955,
		0.806439,
		0.525067,
		0,
		0.273188,
		0.458484,
		-0.845672,
		0,
		-0.922718,
		0.373427,
		-0.095623,
		0,
		-0.603255,
		-0.373295,
		-0.466882,
		1,
	},
	[0.916666666667] = {
		0.066945,
		0.271676,
		0.960058,
		0,
		0.951816,
		0.271223,
		-0.143121,
		0,
		-0.299273,
		0.92338,
		-0.240428,
		0,
		0.266705,
		-0.132021,
		-1.094028,
		1,
	},
	[0.933333333333] = {
		-0.0102,
		0.201006,
		0.979537,
		0,
		0.982307,
		0.185205,
		-0.027776,
		0,
		-0.186998,
		0.961923,
		-0.199339,
		0,
		0.396072,
		-0.095376,
		-1.168472,
		1,
	},
	[0.95] = {
		-0.089741,
		0.140604,
		0.985991,
		0,
		0.992511,
		0.095008,
		0.076786,
		0,
		-0.08288,
		0.985497,
		-0.148077,
		0,
		0.510338,
		-0.063036,
		-1.2297,
		1,
	},
	[0.966666666667] = {
		-0.168519,
		0.090808,
		0.981507,
		0,
		0.985637,
		0.004437,
		0.168818,
		0,
		0.010975,
		0.995859,
		-0.090251,
		0,
		0.603849,
		-0.036079,
		-1.275424,
		1,
	},
	[0.983333333333] = {
		-0.244398,
		0.051126,
		0.968326,
		0,
		0.965121,
		-0.083843,
		0.248016,
		0,
		0.093867,
		0.995167,
		-0.028851,
		0,
		0.671187,
		-0.015315,
		-1.303459,
		1,
	},
	[0.9] = {
		0.13772,
		0.351087,
		0.926159,
		0,
		0.898888,
		0.348402,
		-0.265737,
		0,
		-0.415972,
		0.869111,
		-0.267606,
		0,
		0.12804,
		-0.171577,
		-1.008915,
		1,
	},
	{
		-0.316211,
		0.020602,
		0.948465,
		0,
		0.934034,
		-0.168288,
		0.315055,
		0,
		0.166106,
		0.985523,
		0.033971,
		0,
		0.707186,
		-0.001354,
		-1.311614,
		1,
	},
}

return spline_matrices
