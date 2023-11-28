﻿-- chunkname: @content/characters/player/human/first_person/animations/power_maul/heavy_attack_right_diagonal_down.lua

local spline_matrices = {
	[0.0333333333333] = {
		-0.340605,
		-0.093719,
		-0.935524,
		0,
		0.903266,
		-0.308788,
		-0.297927,
		0,
		-0.260957,
		-0.946502,
		0.189828,
		0,
		-0.287629,
		0.095496,
		0.063679,
		1
	},
	[0.0666666666667] = {
		-0.431319,
		-0.315231,
		-0.845336,
		0,
		0.836674,
		-0.490319,
		-0.244056,
		0,
		-0.33755,
		-0.812537,
		0.47523,
		0,
		-0.289465,
		0.217425,
		0.059307,
		1
	},
	[0] = {
		-0.275694,
		0.19089,
		-0.942101,
		0,
		0.940578,
		-0.14857,
		-0.305352,
		0,
		-0.198257,
		-0.970303,
		-0.138587,
		0,
		-0.284908,
		0.015863,
		0.066838,
		1
	},
	[0.133333333333] = {
		-0.38895,
		-0.250746,
		-0.886479,
		0,
		0.634052,
		-0.770949,
		-0.060129,
		0,
		-0.668353,
		-0.585461,
		0.458847,
		0,
		-0.168506,
		0.449501,
		0.027436,
		1
	},
	[0.166666666667] = {
		-0.586857,
		-0.062244,
		-0.807295,
		0,
		-0.431701,
		-0.819453,
		0.377003,
		0,
		-0.685006,
		0.569757,
		0.45403,
		0,
		0.044109,
		0.525246,
		-0.060013,
		1
	},
	[0.1] = {
		-0.400093,
		-0.299317,
		-0.866218,
		0,
		0.812032,
		-0.553966,
		-0.183645,
		0,
		-0.424888,
		-0.776872,
		0.464693,
		0,
		-0.25741,
		0.32507,
		0.053675,
		1
	},
	[0.233333333333] = {
		-0.626072,
		0.00193,
		-0.779763,
		0,
		-0.754003,
		0.253425,
		0.606016,
		0,
		0.198781,
		0.967353,
		-0.157207,
		0,
		0.361774,
		0.375005,
		-0.363468,
		1
	},
	[0.266666666667] = {
		-0.700309,
		0.050803,
		-0.71203,
		0,
		-0.565731,
		0.568803,
		0.597002,
		0,
		0.435334,
		0.820904,
		-0.369597,
		0,
		0.446309,
		0.236001,
		-0.359655,
		1
	},
	[0.2] = {
		-0.601861,
		0.030524,
		-0.798017,
		0,
		-0.755085,
		-0.347106,
		0.556205,
		0,
		-0.260019,
		0.937329,
		0.231958,
		0,
		0.219892,
		0.504072,
		-0.203694,
		1
	},
	[0.333333333333] = {
		-0.580571,
		0.296375,
		-0.758353,
		0,
		-0.257095,
		0.817017,
		0.516126,
		0,
		0.772554,
		0.494616,
		-0.39814,
		0,
		0.632346,
		-0.172494,
		-0.239963,
		1
	},
	[0.366666666667] = {
		-0.599577,
		0.304504,
		-0.740125,
		0,
		-0.234214,
		0.81754,
		0.526092,
		0,
		0.765278,
		0.48878,
		-0.418859,
		0,
		0.628665,
		-0.173741,
		-0.252011,
		1
	},
	[0.3] = {
		-0.652274,
		0.229165,
		-0.722511,
		0,
		-0.360517,
		0.744685,
		0.561669,
		0,
		0.666757,
		0.62684,
		-0.403121,
		0,
		0.622219,
		-0.03088,
		-0.305685,
		1
	},
	[0.433333333333] = {
		-0.697855,
		0.363108,
		-0.617374,
		0,
		-0.085231,
		0.813742,
		0.574943,
		0,
		0.71115,
		0.453846,
		-0.536926,
		0,
		0.599659,
		-0.183986,
		-0.325005,
		1
	},
	[0.466666666667] = {
		-0.747356,
		0.403178,
		-0.528116,
		0,
		0.014484,
		0.804545,
		0.593715,
		0,
		0.664266,
		0.436067,
		-0.607121,
		0,
		0.574521,
		-0.190262,
		-0.372612,
		1
	},
	[0.4] = {
		-0.643917,
		0.328319,
		-0.69107,
		0,
		-0.172883,
		0.817448,
		0.549445,
		0,
		0.745307,
		0.473271,
		-0.469608,
		0,
		0.617412,
		-0.177883,
		-0.282277,
		1
	},
	[0.533333333333] = {
		-0.805806,
		0.472443,
		-0.357035,
		0,
		0.186452,
		0.774666,
		0.604258,
		0,
		0.562061,
		0.420345,
		-0.712319,
		0,
		0.521069,
		-0.200527,
		-0.448373,
		1
	},
	[0.566666666667] = {
		-0.818725,
		0.49625,
		-0.288833,
		0,
		0.246923,
		0.758438,
		0.603159,
		0,
		0.51838,
		0.422502,
		-0.743488,
		0,
		0.489059,
		-0.200629,
		-0.46396,
		1
	},
	[0.5] = {
		-0.783858,
		0.441868,
		-0.436257,
		0,
		0.110232,
		0.790438,
		0.602541,
		0,
		0.611078,
		0.424217,
		-0.668299,
		0,
		0.54591,
		-0.195778,
		-0.416619,
		1
	},
	[0.633333333333] = {
		-0.829101,
		0.538571,
		-0.150108,
		0,
		0.360942,
		0.720637,
		0.591949,
		0,
		0.42698,
		0.436605,
		-0.791874,
		0,
		0.419098,
		-0.199227,
		-0.493363,
		1
	},
	[0.666666666667] = {
		-0.8269,
		0.556592,
		-0.080265,
		0,
		0.414371,
		0.699561,
		0.582161,
		0,
		0.380176,
		0.448129,
		-0.809102,
		0,
		0.382396,
		-0.197793,
		-0.507241,
		1
	},
	[0.6] = {
		-0.826433,
		0.518379,
		-0.219755,
		0,
		0.305101,
		0.740344,
		0.599002,
		0,
		0.473204,
		0.427988,
		-0.770003,
		0,
		0.454832,
		-0.200171,
		-0.478914,
		1
	},
	[0.733333333333] = {
		-0.808683,
		0.585314,
		0.058647,
		0,
		0.513799,
		0.654274,
		0.55492,
		0,
		0.286432,
		0.478887,
		-0.829834,
		0,
		0.308234,
		-0.193466,
		-0.53301,
		1
	},
	[0.766666666667] = {
		-0.793104,
		0.595681,
		0.127085,
		0,
		0.559742,
		0.630542,
		0.537686,
		0,
		0.240157,
		0.497575,
		-0.833513,
		0,
		0.271843,
		-0.190593,
		-0.544757,
		1
	},
	[0.7] = {
		-0.820023,
		0.572234,
		-0.010571,
		0,
		0.465335,
		0.67736,
		0.569778,
		0,
		0.333207,
		0.462311,
		-0.821731,
		0,
		0.345263,
		-0.195871,
		-0.52048,
		1
	},
	[0.833333333333] = {
		-0.750098,
		0.607858,
		0.260501,
		0,
		0.644068,
		0.582057,
		0.496374,
		0,
		0.150099,
		0.540109,
		-0.828101,
		0,
		0.203093,
		-0.183558,
		-0.565595,
		1
	},
	[0.866666666667] = {
		-0.722861,
		0.609759,
		0.325063,
		0,
		0.682673,
		0.557414,
		0.472491,
		0,
		0.106911,
		0.563457,
		-0.819199,
		0,
		0.171722,
		-0.179433,
		-0.57455,
		1
	},
	[0.8] = {
		-0.773513,
		0.60321,
		0.194459,
		0,
		0.603154,
		0.606403,
		0.518151,
		0,
		0.194634,
		0.518086,
		-0.83289,
		0,
		0.236623,
		-0.187276,
		-0.555646,
		1
	},
	[0.933333333333] = {
		-0.6579,
		0.605282,
		0.448108,
		0,
		0.752692,
		0.50878,
		0.417848,
		0,
		0.024928,
		0.61219,
		-0.790318,
		0,
		0.117639,
		-0.170629,
		-0.588917,
		1
	},
	[0.966666666667] = {
		-0.620704,
		0.599346,
		0.505481,
		0,
		0.783922,
		0.485819,
		0.386582,
		0,
		-0.013876,
		0.636211,
		-0.771391,
		0,
		0.096031,
		-0.166657,
		-0.593965,
		1
	},
	[0.9] = {
		-0.692038,
		0.608855,
		0.387787,
		0,
		0.718912,
		0.53281,
		0.446406,
		0,
		0.06518,
		0.587715,
		-0.806438,
		0,
		0.143053,
		-0.175011,
		-0.582386,
		1
	},
	[1.03333333333] = {
		-0.537825,
		0.582206,
		0.609738,
		0,
		0.838531,
		0.444258,
		0.315435,
		0,
		-0.087233,
		0.680934,
		-0.727131,
		0,
		0.066372,
		-0.161137,
		-0.599023,
		1
	},
	[1.06666666667] = {
		-0.492036,
		0.571636,
		0.656607,
		0,
		0.862063,
		0.425134,
		0.275879,
		0,
		-0.121444,
		0.701779,
		-0.701967,
		0,
		0.059274,
		-0.159441,
		-0.598945,
		1
	},
	{
		-0.580683,
		0.591514,
		0.55939,
		0,
		0.812511,
		0.464364,
		0.352408,
		0,
		-0.051306,
		0.659148,
		-0.750261,
		0,
		0.078781,
		-0.163483,
		-0.597355,
		1
	},
	[1.1] = {
		-0.468073,
		0.565965,
		0.678668,
		0,
		0.872863,
		0.415959,
		0.255126,
		0,
		-0.137906,
		0.711802,
		-0.688709,
		0,
		0.057884,
		-0.158864,
		-0.598218,
		1
	}
}

return spline_matrices
