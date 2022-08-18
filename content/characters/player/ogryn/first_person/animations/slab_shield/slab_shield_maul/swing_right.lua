local spline_matrices = {
	[0] = {
		0.704608,
		-0.135214,
		0.696595,
		0,
		0.690291,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.706026,
		-0.012248,
		-1.334477,
		1
	},
	{
		0.704608,
		-0.135214,
		0.696595,
		0,
		0.690291,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.706026,
		-0.012248,
		-1.334477,
		1
	},
	[0.0166666666667] = {
		0.693196,
		-0.119581,
		0.71076,
		0,
		0.686992,
		-0.188638,
		-0.701753,
		0,
		0.217993,
		0.974739,
		-0.048612,
		0,
		0.70243,
		-0.025241,
		-1.336554,
		1
	},
	[0.0333333333333] = {
		0.677781,
		-0.099627,
		0.728483,
		0,
		0.681894,
		-0.285413,
		-0.673468,
		0,
		0.275014,
		0.953212,
		-0.125513,
		0,
		0.683041,
		-0.040014,
		-1.33104,
		1
	},
	[0.05] = {
		0.65912,
		-0.074417,
		0.748347,
		0,
		0.673004,
		-0.385696,
		-0.631114,
		0,
		0.3356,
		0.91962,
		-0.204137,
		0,
		0.649186,
		-0.056495,
		-1.318049,
		1
	},
	[0.0666666666667] = {
		0.63808,
		-0.043194,
		0.768758,
		0,
		0.658252,
		-0.487365,
		-0.573741,
		0,
		0.399448,
		0.872129,
		-0.282545,
		0,
		0.602135,
		-0.074498,
		-1.297646,
		1
	},
	[0.0833333333333] = {
		0.61571,
		-0.005498,
		0.787954,
		0,
		0.635609,
		-0.587567,
		-0.500766,
		0,
		0.465729,
		0.809157,
		-0.358276,
		0,
		0.543097,
		-0.093692,
		-1.269869,
		1
	},
	[0.116666666667] = {
		0.572243,
		0.088849,
		0.815257,
		0,
		0.559801,
		-0.768798,
		-0.309148,
		0,
		0.599301,
		0.63329,
		-0.489677,
		0,
		0.393664,
		-0.133406,
		-1.1925,
		1
	},
	[0.133333333333] = {
		0.554211,
		0.14375,
		0.81987,
		0,
		0.504548,
		-0.841413,
		-0.193535,
		0,
		0.662028,
		0.520923,
		-0.538849,
		0,
		0.305544,
		-0.15231,
		-1.143326,
		1
	},
	[0.15] = {
		0.540776,
		0.20152,
		0.816671,
		0,
		0.43768,
		-0.89651,
		-0.068598,
		0,
		0.71833,
		0.394536,
		-0.573013,
		0,
		0.210089,
		-0.169213,
		-1.087745,
		1
	},
	[0.166666666667] = {
		0.533363,
		0.2597,
		0.805034,
		0,
		0.360376,
		-0.930777,
		0.061503,
		0,
		0.76528,
		0.257312,
		-0.590032,
		0,
		0.108645,
		-0.182973,
		-1.026502,
		1
	},
	[0.183333333333] = {
		0.533046,
		0.315465,
		0.785076,
		0,
		0.274768,
		-0.942142,
		0.192018,
		0,
		0.800228,
		0.113359,
		-0.588885,
		0,
		0.002736,
		-0.192471,
		-0.960604,
		1
	},
	[0.1] = {
		0.593275,
		0.038698,
		0.804069,
		0,
		0.603253,
		-0.682744,
		-0.412246,
		0,
		0.53302,
		0.729632,
		-0.428399,
		0,
		0.47323,
		-0.113565,
		-1.234775,
		1
	},
	[0.216666666667] = {
		0.555482,
		0.408331,
		0.724366,
		0,
		0.090515,
		-0.895642,
		0.435468,
		0,
		0.826588,
		-0.176328,
		-0.534473,
		0,
		-0.215413,
		-0.194942,
		-0.819885,
		1
	},
	[0.233333333333] = {
		0.577756,
		0.440495,
		0.687141,
		0,
		-0.001576,
		-0.841264,
		0.540622,
		0,
		0.816208,
		-0.313431,
		-0.485351,
		0,
		-0.3237,
		-0.186644,
		-0.747854,
		1
	},
	[0.25] = {
		0.606279,
		0.460728,
		0.648194,
		0,
		-0.089591,
		-0.770321,
		0.631332,
		0,
		0.79019,
		-0.440835,
		-0.425752,
		0,
		-0.428646,
		-0.171589,
		-0.676554,
		1
	},
	[0.266666666667] = {
		0.639775,
		0.467937,
		0.609691,
		0,
		-0.171122,
		-0.686646,
		0.706565,
		0,
		0.74927,
		-0.556374,
		-0.359225,
		0,
		-0.528091,
		-0.149765,
		-0.607245,
		1
	},
	[0.283333333333] = {
		0.676772,
		0.461498,
		0.573584,
		0,
		-0.244414,
		-0.594081,
		0.766374,
		0,
		0.694436,
		-0.658853,
		-0.289261,
		0,
		-0.619898,
		-0.121313,
		-0.541034,
		1
	},
	[0.2] = {
		0.540409,
		0.365906,
		0.757674,
		0,
		0.183725,
		-0.930077,
		0.318123,
		0,
		0.821099,
		-0.032713,
		-0.569848,
		0,
		-0.105919,
		-0.196717,
		-0.891275,
		1
	},
	[0.316666666667] = {
		0.754809,
		0.406589,
		0.514732,
		0,
		-0.36227,
		-0.395785,
		0.843869,
		0,
		0.546831,
		-0.823432,
		-0.151447,
		0,
		-0.772306,
		-0.045382,
		-0.421543,
		1
	},
	[0.333333333333] = {
		0.792344,
		0.357755,
		0.494168,
		0,
		-0.405979,
		-0.295423,
		0.864816,
		0,
		0.45538,
		-0.885854,
		-0.088836,
		0,
		-0.82889,
		0.001722,
		-0.369746,
		1
	},
	[0.35] = {
		0.826004,
		0.294896,
		0.480367,
		0,
		-0.439296,
		-0.197186,
		0.876434,
		0,
		0.353179,
		-0.934962,
		-0.03333,
		0,
		-0.869798,
		0.054162,
		-0.324064,
		1
	},
	[0.366666666667] = {
		0.853366,
		0.218007,
		0.473539,
		0,
		-0.462446,
		-0.102739,
		0.880675,
		0,
		0.240644,
		-0.970524,
		0.013142,
		0,
		-0.893211,
		0.111502,
		-0.285022,
		1
	},
	[0.383333333333] = {
		0.871369,
		0.110532,
		0.478016,
		0,
		-0.479903,
		-0.010586,
		0.877258,
		0,
		0.102026,
		-0.993816,
		0.04382,
		0,
		-0.894833,
		0.199174,
		-0.257011,
		1
	},
	[0.3] = {
		0.715678,
		0.441106,
		0.541507,
		0,
		-0.308334,
		-0.496134,
		0.811653,
		0,
		0.626685,
		-0.747848,
		-0.219064,
		0,
		-0.70198,
		-0.086447,
		-0.478866,
		1
	},
	[0.416666666667] = {
		0.832676,
		-0.205727,
		0.514127,
		0,
		-0.48394,
		0.180943,
		0.85619,
		0,
		-0.269169,
		-0.961736,
		0.051107,
		0,
		-0.823943,
		0.504147,
		-0.234483,
		1
	},
	[0.433333333333] = {
		0.754988,
		-0.382855,
		0.532367,
		0,
		-0.454272,
		0.280112,
		0.84568,
		0,
		-0.472895,
		-0.880318,
		0.037561,
		0,
		-0.752022,
		0.695049,
		-0.232005,
		1
	},
	[0.45] = {
		0.634132,
		-0.548649,
		0.54485,
		0,
		-0.394208,
		0.376795,
		0.838228,
		0,
		-0.665189,
		-0.746331,
		0.022657,
		0,
		-0.657042,
		0.892256,
		-0.230475,
		1
	},
	[0.466666666667] = {
		0.474188,
		-0.686365,
		0.551406,
		0,
		-0.297835,
		0.464318,
		0.834088,
		0,
		-0.828517,
		-0.559742,
		0.015751,
		0,
		-0.540721,
		1.080493,
		-0.226961,
		1
	},
	[0.483333333333] = {
		0.282895,
		-0.781729,
		0.555761,
		0,
		-0.15935,
		0.533072,
		0.830928,
		0,
		-0.945821,
		-0.323626,
		0.026235,
		0,
		-0.40503,
		1.244166,
		-0.219413,
		1
	},
	[0.4] = {
		0.868791,
		-0.035501,
		0.493904,
		0,
		-0.489907,
		0.083537,
		0.867763,
		0,
		-0.072066,
		-0.995872,
		0.055183,
		0,
		-0.8717,
		0.334271,
		-0.2415,
		1
	},
	[0.516666666667] = {
		-0.264483,
		-0.760881,
		0.592544,
		0,
		0.323117,
		0.508996,
		0.797821,
		0,
		-0.90865,
		0.402471,
		0.111232,
		0,
		0.092661,
		1.485114,
		-0.211486,
		1
	},
	[0.533333333333] = {
		-0.497658,
		-0.604172,
		0.622345,
		0,
		0.539552,
		0.346156,
		0.767502,
		0,
		-0.679132,
		0.717741,
		0.153715,
		0,
		0.397172,
		1.505913,
		-0.212202,
		1
	},
	[0.55] = {
		-0.639326,
		-0.418029,
		0.645379,
		0,
		0.666908,
		0.11633,
		0.736003,
		0,
		-0.382748,
		0.900955,
		0.204414,
		0,
		0.751764,
		1.470319,
		-0.21107,
		1
	},
	[0.566666666667] = {
		-0.669676,
		0.531007,
		0.519197,
		0,
		0.275243,
		-0.471859,
		0.83761,
		0,
		0.689765,
		0.703833,
		0.169837,
		0,
		1.702705,
		0.485345,
		-0.294762,
		1
	},
	[0.583333333333] = {
		-0.383927,
		0.770508,
		0.50884,
		0,
		0.037402,
		-0.537643,
		0.842343,
		0,
		0.922606,
		0.342429,
		0.177597,
		0,
		1.642042,
		0.334909,
		-0.350395,
		1
	},
	[0.5] = {
		0.030503,
		-0.822926,
		0.56733,
		0,
		0.05485,
		0.568117,
		0.821118,
		0,
		-0.998029,
		0.006072,
		0.062466,
		0,
		-0.198765,
		1.386139,
		-0.212563,
		1
	},
	[0.616666666667] = {
		-0.011028,
		0.836892,
		0.547256,
		0,
		-0.159218,
		-0.541777,
		0.825304,
		0,
		0.987182,
		-0.078032,
		0.139223,
		0,
		1.504707,
		0.149724,
		-0.490427,
		1
	},
	[0.633333333333] = {
		0.079475,
		0.810247,
		0.580675,
		0,
		-0.171811,
		-0.562666,
		0.808633,
		0,
		0.981919,
		-0.164032,
		0.094492,
		0,
		1.438263,
		0.081194,
		-0.569148,
		1
	},
	[0.65] = {
		0.1315,
		0.772321,
		0.621472,
		0,
		-0.148452,
		-0.604504,
		0.782647,
		0,
		0.980138,
		-0.195177,
		0.03516,
		0,
		1.372927,
		0.021585,
		-0.652144,
		1
	},
	[0.666666666667] = {
		0.158007,
		0.725332,
		0.670021,
		0,
		-0.093242,
		-0.664553,
		0.741401,
		0,
		0.983026,
		-0.179621,
		-0.037373,
		0,
		1.308505,
		-0.029818,
		-0.738913,
		1
	},
	[0.683333333333] = {
		0.168834,
		0.666232,
		0.726382,
		0,
		-0.005908,
		-0.736264,
		0.676669,
		0,
		0.985627,
		-0.118536,
		-0.12037,
		0,
		1.245283,
		-0.072005,
		-0.828995,
		1
	},
	[0.6] = {
		-0.15861,
		0.838108,
		0.521936,
		0,
		-0.098038,
		-0.539384,
		0.836333,
		0,
		0.982462,
		0.081481,
		0.167718,
		0,
		1.572703,
		0.230814,
		-0.416847,
		1
	},
	[0.716666666667] = {
		0.182602,
		0.490515,
		0.852087,
		0,
		0.265017,
		-0.859136,
		0.437779,
		0,
		0.946796,
		0.145878,
		-0.286875,
		0,
		1.122205,
		-0.119321,
		-1.014735,
		1
	},
	[0.733333333333] = {
		0.208567,
		0.368488,
		0.905934,
		0,
		0.432882,
		-0.86541,
		0.252346,
		0,
		0.876991,
		0.339531,
		-0.340008,
		0,
		1.059656,
		-0.119632,
		-1.10467,
		1
	},
	[0.75] = {
		0.261067,
		0.232496,
		0.936905,
		0,
		0.592964,
		-0.804494,
		0.034409,
		0,
		0.761734,
		0.546567,
		-0.347888,
		0,
		0.993396,
		-0.104591,
		-1.185437,
		1
	},
	[0.766666666667] = {
		0.341377,
		0.101073,
		0.934476,
		0,
		0.714515,
		-0.673849,
		-0.188139,
		0,
		0.61068,
		0.731923,
		-0.302254,
		0,
		0.922972,
		-0.079451,
		-1.250673,
		1
	},
	[0.783333333333] = {
		0.439642,
		-0.005712,
		0.898155,
		0,
		0.777342,
		-0.498531,
		-0.383675,
		0,
		0.449949,
		0.866853,
		-0.214735,
		0,
		0.85198,
		-0.052147,
		-1.296619,
		1
	},
	[0.7] = {
		0.173408,
		0.589629,
		0.788839,
		0,
		0.114521,
		-0.807612,
		0.578487,
		0,
		0.978169,
		-0.009976,
		-0.207571,
		0,
		1.183422,
		-0.102769,
		-0.921567,
		1
	},
	[0.816666666667] = {
		0.631015,
		-0.114732,
		0.76724,
		0,
		0.747347,
		-0.175357,
		-0.640876,
		0,
		0.20807,
		0.977797,
		-0.024908,
		0,
		0.736842,
		-0.013731,
		-1.33516,
		1
	},
	[0.833333333333] = {
		0.70592,
		-0.128187,
		0.696595,
		0,
		0.691221,
		-0.089938,
		-0.717025,
		0,
		0.154564,
		0.987664,
		0.025117,
		0,
		0.706113,
		-0.005213,
		-1.334477,
		1
	},
	[0.85] = {
		0.705739,
		-0.129182,
		0.696595,
		0,
		0.691093,
		-0.090912,
		-0.717025,
		0,
		0.155956,
		0.987445,
		0.025117,
		0,
		0.706105,
		-0.006209,
		-1.334477,
		1
	},
	[0.866666666667] = {
		0.705556,
		-0.13018,
		0.696595,
		0,
		0.690964,
		-0.091889,
		-0.717025,
		0,
		0.157352,
		0.987223,
		0.025117,
		0,
		0.706096,
		-0.007207,
		-1.334477,
		1
	},
	[0.883333333333] = {
		0.705375,
		-0.131154,
		0.696595,
		0,
		0.690837,
		-0.092843,
		-0.717025,
		0,
		0.158715,
		0.987005,
		0.025117,
		0,
		0.706085,
		-0.008182,
		-1.334477,
		1
	},
	[0.8] = {
		0.540367,
		-0.077047,
		0.837895,
		0,
		0.782588,
		-0.319821,
		-0.534108,
		0,
		0.309128,
		0.94434,
		-0.112524,
		0,
		0.787421,
		-0.0293,
		-1.323709,
		1
	},
	[0.916666666667] = {
		0.705042,
		-0.132933,
		0.696595,
		0,
		0.6906,
		-0.094586,
		-0.717025,
		0,
		0.161204,
		0.986601,
		0.025117,
		0,
		0.706062,
		-0.009963,
		-1.334477,
		1
	},
	[0.933333333333] = {
		0.7049,
		-0.133687,
		0.696595,
		0,
		0.690499,
		-0.095324,
		-0.717025,
		0,
		0.162259,
		0.986428,
		0.025117,
		0,
		0.706051,
		-0.010718,
		-1.334477,
		1
	},
	[0.95] = {
		0.70478,
		-0.134317,
		0.696595,
		0,
		0.690413,
		-0.095942,
		-0.717025,
		0,
		0.163141,
		0.986283,
		0.025117,
		0,
		0.706041,
		-0.01135,
		-1.334477,
		1
	},
	[0.966666666667] = {
		0.704688,
		-0.134799,
		0.696595,
		0,
		0.690348,
		-0.096413,
		-0.717025,
		0,
		0.163815,
		0.986171,
		0.025117,
		0,
		0.706033,
		-0.011832,
		-1.334477,
		1
	},
	[0.983333333333] = {
		0.704629,
		-0.135106,
		0.696595,
		0,
		0.690305,
		-0.096714,
		-0.717025,
		0,
		0.164245,
		0.9861,
		0.025117,
		0,
		0.706028,
		-0.01214,
		-1.334477,
		1
	},
	[0.9] = {
		0.705202,
		-0.13208,
		0.696595,
		0,
		0.690714,
		-0.09375,
		-0.717025,
		0,
		0.160011,
		0.986796,
		0.025117,
		0,
		0.706074,
		-0.009109,
		-1.334477,
		1
	}
}

return spline_matrices
