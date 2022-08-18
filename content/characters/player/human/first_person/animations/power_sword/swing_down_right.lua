local spline_matrices = {
	[0] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	{
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.0166666666667] = {
		0.801285,
		-0.187232,
		-0.568231,
		0,
		-0.577371,
		-0.490909,
		-0.652419,
		0,
		-0.156797,
		0.850854,
		-0.501461,
		0,
		-0.05918,
		0.014222,
		-0.556894,
		1
	},
	[0.0333333333333] = {
		0.731281,
		0.276492,
		-0.623523,
		0,
		-0.518666,
		-0.368261,
		-0.771602,
		0,
		-0.442961,
		0.887657,
		-0.125895,
		0,
		-0.103169,
		0.012077,
		-0.533424,
		1
	},
	[0.05] = {
		0.466793,
		0.774408,
		-0.427079,
		0,
		-0.519872,
		-0.150385,
		-0.840903,
		0,
		-0.715428,
		0.614554,
		0.332394,
		0,
		-0.146185,
		0.010836,
		-0.511566,
		1
	},
	[0.0666666666667] = {
		0.079587,
		0.996585,
		0.022002,
		0,
		-0.622094,
		0.066902,
		-0.780079,
		0,
		-0.778887,
		0.048397,
		0.625294,
		0,
		-0.188136,
		0.011927,
		-0.487424,
		1
	},
	[0.0833333333333] = {
		-0.195702,
		0.871475,
		0.449701,
		0,
		-0.762687,
		0.153002,
		-0.628409,
		0,
		-0.616448,
		-0.465963,
		0.634721,
		0,
		-0.228587,
		0.013368,
		-0.456447,
		1
	},
	[0.116666666667] = {
		-0.279428,
		0.504658,
		0.816848,
		0,
		-0.947147,
		-0.005247,
		-0.320758,
		0,
		-0.157587,
		-0.863304,
		0.479451,
		0,
		-0.291138,
		0.005447,
		-0.359728,
		1
	},
	[0.133333333333] = {
		-0.185093,
		0.394683,
		0.899981,
		0,
		-0.979347,
		-0.149903,
		-0.135676,
		0,
		0.081361,
		-0.906506,
		0.414278,
		0,
		-0.310018,
		-0.003262,
		-0.289401,
		1
	},
	[0.15] = {
		-0.022819,
		0.312616,
		0.949605,
		0,
		-0.972822,
		-0.225873,
		0.050982,
		0,
		0.230428,
		-0.922633,
		0.309274,
		0,
		-0.334655,
		-0.013523,
		-0.206518,
		1
	},
	[0.166666666667] = {
		0.177836,
		0.253446,
		0.950863,
		0,
		-0.928094,
		-0.278021,
		0.247682,
		0,
		0.327133,
		-0.926536,
		0.18578,
		0,
		-0.360344,
		-0.026536,
		-0.113104,
		1
	},
	[0.183333333333] = {
		0.376557,
		0.213039,
		0.901565,
		0,
		-0.849165,
		-0.309635,
		0.427838,
		0,
		0.370302,
		-0.926683,
		0.06431,
		0,
		-0.378233,
		-0.031768,
		-0.02345,
		1
	},
	[0.1] = {
		-0.291203,
		0.657571,
		0.694839,
		0,
		-0.868973,
		0.121957,
		-0.479597,
		0,
		-0.400109,
		-0.743457,
		0.535897,
		0,
		-0.265098,
		0.012416,
		-0.416171,
		1
	},
	[0.216666666667] = {
		0.666177,
		0.162675,
		0.727836,
		0,
		-0.661169,
		-0.322707,
		0.677285,
		0,
		0.345055,
		-0.932415,
		-0.107424,
		0,
		-0.365695,
		0.016124,
		0.099966,
		1
	},
	[0.233333333333] = {
		0.773277,
		0.137971,
		0.618875,
		0,
		-0.559955,
		-0.309321,
		0.768616,
		0,
		0.297479,
		-0.940895,
		-0.161933,
		0,
		-0.338589,
		0.065446,
		0.141522,
		1
	},
	[0.25] = {
		0.855225,
		0.11204,
		0.506002,
		0,
		-0.462586,
		-0.275199,
		0.842781,
		0,
		0.233677,
		-0.954836,
		-0.183529,
		0,
		-0.303364,
		0.12607,
		0.1726,
		1
	},
	[0.266666666667] = {
		0.912081,
		0.083913,
		0.40133,
		0,
		-0.377353,
		-0.211012,
		0.901709,
		0,
		0.160351,
		-0.973875,
		-0.160795,
		0,
		-0.264044,
		0.194811,
		0.193348,
		1
	},
	[0.283333333333] = {
		0.946973,
		0.0528,
		0.316947,
		0,
		-0.310399,
		-0.10459,
		0.944835,
		0,
		0.083037,
		-0.993113,
		-0.082655,
		0,
		-0.224591,
		0.268773,
		0.203715,
		1
	},
	[0.2] = {
		0.538409,
		0.185965,
		0.821908,
		0,
		-0.756613,
		-0.322744,
		0.56866,
		0,
		0.371016,
		-0.928037,
		-0.033065,
		0,
		-0.380658,
		-0.018499,
		0.047865,
		1
	},
	[0.316666666667] = {
		0.973785,
		-0.061061,
		0.219123,
		0,
		-0.19386,
		0.281181,
		0.93987,
		0,
		-0.119002,
		-0.95771,
		0.261972,
		0,
		-0.138699,
		0.425041,
		0.163191,
		1
	},
	[0.333333333333] = {
		0.968379,
		-0.119414,
		0.219051,
		0,
		-0.129493,
		0.5099,
		0.850431,
		0,
		-0.213247,
		-0.851905,
		0.478313,
		0,
		-0.089667,
		0.497939,
		0.109565,
		1
	},
	[0.35] = {
		0.957434,
		-0.145021,
		0.249578,
		0,
		-0.069619,
		0.72309,
		0.687236,
		0,
		-0.280131,
		-0.675359,
		0.682215,
		0,
		-0.038787,
		0.559704,
		0.039318,
		1
	},
	[0.366666666667] = {
		0.948492,
		-0.114273,
		0.295473,
		0,
		-0.027059,
		0.900048,
		0.434951,
		0,
		-0.315642,
		-0.420543,
		0.850596,
		0,
		0.01151,
		0.605296,
		-0.043085,
		1
	},
	[0.383333333333] = {
		0.949453,
		0.116289,
		0.291574,
		0,
		0.006365,
		0.921527,
		-0.388262,
		0,
		-0.313844,
		0.370492,
		0.874207,
		0,
		0.068367,
		0.630777,
		-0.190824,
		1
	},
	[0.3] = {
		0.96706,
		0.004782,
		0.254505,
		0,
		-0.254279,
		0.064218,
		0.964996,
		0,
		-0.011729,
		-0.997924,
		0.063319,
		0,
		-0.183988,
		0.346636,
		0.195688,
		1
	},
	[0.416666666667] = {
		0.958631,
		-0.005299,
		0.284601,
		0,
		0.148399,
		-0.843899,
		-0.51557,
		0,
		0.242907,
		0.536476,
		-0.808201,
		0,
		0.21407,
		0.409761,
		-0.666825,
		1
	},
	[0.433333333333] = {
		0.897183,
		0.033696,
		0.440372,
		0,
		0.159321,
		-0.954643,
		-0.251544,
		0,
		0.411922,
		0.295841,
		-0.861858,
		0,
		0.287094,
		0.340338,
		-0.715654,
		1
	},
	[0.45] = {
		0.770044,
		0.054988,
		0.635616,
		0,
		0.25278,
		-0.941039,
		-0.22483,
		0,
		0.585776,
		0.3338,
		-0.738541,
		0,
		0.37161,
		0.292912,
		-0.753186,
		1
	},
	[0.466666666667] = {
		0.579828,
		0.007865,
		0.814701,
		0,
		0.414999,
		-0.863362,
		-0.287023,
		0,
		0.701124,
		0.504524,
		-0.503865,
		0,
		0.459741,
		0.25903,
		-0.774803,
		1
	},
	[0.483333333333] = {
		0.395572,
		-0.090412,
		0.913974,
		0,
		0.569965,
		-0.756167,
		-0.321485,
		0,
		0.720183,
		0.648103,
		-0.247586,
		0,
		0.537541,
		0.229936,
		-0.778376,
		1
	},
	[0.4] = {
		0.981108,
		-0.024133,
		0.19195,
		0,
		0.193153,
		0.066223,
		-0.978931,
		0,
		0.010913,
		0.997513,
		0.069633,
		0,
		0.147801,
		0.561401,
		-0.40881,
		1
	},
	[0.516666666667] = {
		0.333455,
		-0.074427,
		0.939824,
		0,
		0.534452,
		-0.806294,
		-0.253479,
		0,
		0.77664,
		0.586814,
		-0.229085,
		0,
		0.619771,
		0.116849,
		-0.759075,
		1
	},
	[0.533333333333] = {
		0.466033,
		0.016905,
		0.884606,
		0,
		0.371811,
		-0.910991,
		-0.17847,
		0,
		0.802851,
		0.412079,
		-0.430837,
		0,
		0.631229,
		0.013934,
		-0.735833,
		1
	},
	[0.55] = {
		0.645157,
		0.072926,
		0.760562,
		0,
		0.179105,
		-0.982133,
		-0.057757,
		0,
		0.742761,
		0.173483,
		-0.646691,
		0,
		0.626995,
		-0.092882,
		-0.703353,
		1
	},
	[0.566666666667] = {
		0.795315,
		0.059905,
		0.60323,
		0,
		0.020114,
		-0.997165,
		0.072506,
		0,
		0.605863,
		-0.045532,
		-0.794265,
		0,
		0.611691,
		-0.180514,
		-0.668609,
		1
	},
	[0.583333333333] = {
		0.877374,
		0.002889,
		0.479798,
		0,
		-0.076402,
		-0.986382,
		0.14565,
		0,
		0.473684,
		-0.164447,
		-0.865205,
		0,
		0.587539,
		-0.23154,
		-0.643012,
		1
	},
	[0.5] = {
		0.30182,
		-0.13404,
		0.943895,
		0,
		0.617902,
		-0.726464,
		-0.300744,
		0,
		0.726018,
		0.674005,
		-0.136438,
		0,
		0.590938,
		0.190204,
		-0.771891,
		1
	},
	[0.616666666667] = {
		0.938166,
		-0.167905,
		0.302743,
		0,
		-0.204071,
		-0.974638,
		0.091846,
		0,
		0.279644,
		-0.147948,
		-0.948636,
		0,
		0.488252,
		-0.243784,
		-0.617243,
		1
	},
	[0.633333333333] = {
		0.942056,
		-0.26679,
		0.203356,
		0,
		-0.273515,
		-0.961854,
		0.005183,
		0,
		0.194216,
		-0.060504,
		-0.979091,
		0,
		0.415129,
		-0.223436,
		-0.609481,
		1
	},
	[0.65] = {
		0.928909,
		-0.358536,
		0.092628,
		0,
		-0.348923,
		-0.931215,
		-0.105317,
		0,
		0.124016,
		0.06551,
		-0.990115,
		0,
		0.333526,
		-0.190411,
		-0.603865,
		1
	},
	[0.666666666667] = {
		0.901508,
		-0.431985,
		-0.02591,
		0,
		-0.426352,
		-0.876295,
		-0.224346,
		0,
		0.074209,
		0.213297,
		-0.974165,
		0,
		0.24918,
		-0.148785,
		-0.599397,
		1
	},
	[0.683333333333] = {
		0.865352,
		-0.480233,
		-0.143327,
		0,
		-0.498978,
		-0.798901,
		-0.335825,
		0,
		0.04677,
		0.362124,
		-0.930956,
		0,
		0.167912,
		-0.103208,
		-0.59529,
		1
	},
	[0.6] = {
		0.916585,
		-0.074016,
		0.392929,
		0,
		-0.140107,
		-0.979865,
		0.142251,
		0,
		0.374488,
		-0.185437,
		-0.9085,
		0,
		0.547428,
		-0.247742,
		-0.628124,
		1
	},
	[0.716666666667] = {
		0.795349,
		-0.508145,
		-0.330468,
		0,
		-0.604603,
		-0.626096,
		-0.4924,
		0,
		0.043306,
		0.591432,
		-0.805191,
		0,
		0.037165,
		-0.020866,
		-0.587574,
		1
	},
	[0.733333333333] = {
		0.773627,
		-0.504626,
		-0.383216,
		0,
		-0.631544,
		-0.564896,
		-0.531079,
		0,
		0.051519,
		0.652874,
		-0.755712,
		0,
		-0.001616,
		0.005499,
		-0.584906,
		1
	},
	[0.75] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.766666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.783333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.7] = {
		0.827653,
		-0.50337,
		-0.248213,
		0,
		-0.559897,
		-0.709946,
		-0.427192,
		0,
		0.038817,
		0.49254,
		-0.869424,
		0,
		0.095423,
		-0.05881,
		-0.591255,
		1
	},
	[0.816666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.833333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.85] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.866666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.883333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.8] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.916666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.933333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.95] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.966666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.983333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[0.9] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.01666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.03333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.05] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.06666666667] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.08333333333] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	},
	[1.1] = {
		0.765835,
		-0.502038,
		-0.401815,
		0,
		-0.640628,
		-0.541627,
		-0.544275,
		0,
		0.055613,
		0.674239,
		-0.736416,
		0,
		-0.015717,
		0.015363,
		-0.583919,
		1
	}
}

return spline_matrices
