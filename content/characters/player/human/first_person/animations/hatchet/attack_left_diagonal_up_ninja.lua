local spline_matrices = {
	[0] = {
		0.614823,
		-0.726205,
		-0.307602,
		0,
		-0.762365,
		-0.447368,
		-0.467613,
		0,
		0.201972,
		0.522004,
		-0.828685,
		0,
		-0.103246,
		-0.013932,
		-0.654177,
		1
	},
	{
		0.727059,
		-0.636021,
		-0.258578,
		0,
		-0.68657,
		-0.672077,
		-0.277369,
		0,
		0.002628,
		0.379195,
		-0.925313,
		0,
		-0.107886,
		-0.045235,
		-0.637328,
		1
	},
	[0.0166666666667] = {
		0.744472,
		-0.550101,
		-0.378351,
		0,
		-0.666543,
		-0.645045,
		-0.373682,
		0,
		-0.03849,
		0.530383,
		-0.846884,
		0,
		-0.072056,
		0.003469,
		-0.608724,
		1
	},
	[0.0333333333333] = {
		0.805934,
		-0.294499,
		-0.513556,
		0,
		-0.478968,
		-0.834213,
		-0.273275,
		0,
		-0.347936,
		0.466218,
		-0.813376,
		0,
		-0.027551,
		0.020217,
		-0.567734,
		1
	},
	[0.05] = {
		0.737684,
		-0.001962,
		-0.675143,
		0,
		-0.191549,
		-0.959513,
		-0.206504,
		0,
		-0.647403,
		0.281658,
		-0.708194,
		0,
		0.026086,
		0.046397,
		-0.534037,
		1
	},
	[0.0666666666667] = {
		0.532383,
		0.249507,
		-0.808897,
		0,
		0.14564,
		-0.968323,
		-0.202829,
		0,
		-0.833881,
		-0.009826,
		-0.551857,
		0,
		0.078254,
		0.088767,
		-0.507557,
		1
	},
	[0.0833333333333] = {
		0.254101,
		0.400758,
		-0.880242,
		0,
		0.455264,
		-0.852542,
		-0.256725,
		0,
		-0.853327,
		-0.335508,
		-0.399083,
		0,
		0.118202,
		0.147005,
		-0.483373,
		1
	},
	[0.116666666667] = {
		-0.232002,
		0.426998,
		-0.873984,
		0,
		0.842601,
		-0.360701,
		-0.399898,
		0,
		-0.486002,
		-0.829197,
		-0.276105,
		0,
		0.148131,
		0.296666,
		-0.414078,
		1
	},
	[0.133333333333] = {
		-0.378636,
		0.372349,
		-0.847343,
		0,
		0.912095,
		-0.005399,
		-0.409943,
		0,
		-0.157217,
		-0.928077,
		-0.337573,
		0,
		0.13828,
		0.385959,
		-0.35728,
		1
	},
	[0.15] = {
		-0.473492,
		0.289283,
		-0.831938,
		0,
		0.771391,
		0.592115,
		-0.233141,
		0,
		0.425159,
		-0.75214,
		-0.503512,
		0,
		0.096112,
		0.520877,
		-0.257909,
		1
	},
	[0.166666666667] = {
		-0.48568,
		0.186484,
		-0.854013,
		0,
		0.027096,
		0.979721,
		0.198525,
		0,
		0.873717,
		0.07328,
		-0.480884,
		0,
		0.015351,
		0.620151,
		-0.141053,
		1
	},
	[0.183333333333] = {
		-0.457284,
		0.166055,
		-0.87368,
		0,
		-0.632039,
		0.630441,
		0.450634,
		0,
		0.625634,
		0.758267,
		-0.183337,
		0,
		-0.034344,
		0.604255,
		-0.08256,
		1
	},
	[0.1] = {
		-0.016451,
		0.448895,
		-0.893433,
		0,
		0.689963,
		-0.641618,
		-0.335078,
		0,
		-0.723658,
		-0.621948,
		-0.299165,
		0,
		0.141382,
		0.217092,
		-0.454312,
		1
	},
	[0.216666666667] = {
		-0.551996,
		0.261118,
		-0.791908,
		0,
		-0.819169,
		-0.347219,
		0.456509,
		0,
		-0.155763,
		0.900698,
		0.405564,
		0,
		-0.125243,
		0.292204,
		-0.150298,
		1
	},
	[0.233333333333] = {
		-0.589364,
		0.255861,
		-0.76628,
		0,
		-0.709783,
		-0.616991,
		0.339898,
		0,
		-0.385821,
		0.744216,
		0.545238,
		0,
		-0.161991,
		0.179202,
		-0.233807,
		1
	},
	[0.25] = {
		-0.659091,
		0.159152,
		-0.73503,
		0,
		-0.43052,
		-0.881212,
		0.195237,
		0,
		-0.616645,
		0.445124,
		0.649317,
		0,
		-0.165262,
		0.084641,
		-0.342412,
		1
	},
	[0.266666666667] = {
		-0.688399,
		0.056114,
		-0.723158,
		0,
		-0.151683,
		-0.986096,
		0.067875,
		0,
		-0.709294,
		0.156416,
		0.687339,
		0,
		-0.175495,
		-0.016355,
		-0.431527,
		1
	},
	[0.283333333333] = {
		-0.697945,
		0.063268,
		-0.713351,
		0,
		-0.114316,
		-0.99316,
		0.023762,
		0,
		-0.706969,
		0.098133,
		0.700404,
		0,
		-0.232788,
		-0.208677,
		-0.44868,
		1
	},
	[0.2] = {
		-0.518408,
		0.235928,
		-0.821943,
		0,
		-0.842298,
		0.025032,
		0.538431,
		0,
		0.147606,
		0.971448,
		0.185744,
		0,
		-0.081116,
		0.42147,
		-0.097397,
		1
	},
	[0.316666666667] = {
		-0.679151,
		0.158839,
		-0.716606,
		0,
		-0.265736,
		-0.963283,
		0.038331,
		0,
		-0.684206,
		0.216461,
		0.696425,
		0,
		-0.340138,
		-0.535657,
		-0.41727,
		1
	},
	[0.333333333333] = {
		-0.637375,
		0.163718,
		-0.752961,
		0,
		-0.286914,
		-0.957327,
		0.034716,
		0,
		-0.715146,
		0.238162,
		0.657149,
		0,
		-0.337613,
		-0.533811,
		-0.416593,
		1
	},
	[0.35] = {
		-0.581481,
		0.160988,
		-0.797473,
		0,
		-0.305192,
		-0.951806,
		0.030389,
		0,
		-0.754147,
		0.261053,
		0.602589,
		0,
		-0.328737,
		-0.526737,
		-0.41944,
		1
	},
	[0.366666666667] = {
		-0.509936,
		0.15039,
		-0.846964,
		0,
		-0.320998,
		-0.946746,
		0.025158,
		0,
		-0.798076,
		0.284703,
		0.531055,
		0,
		-0.314553,
		-0.514873,
		-0.425221,
		1
	},
	[0.383333333333] = {
		-0.421237,
		0.131528,
		-0.897363,
		0,
		-0.334462,
		-0.94222,
		0.0189,
		0,
		-0.843027,
		0.308095,
		0.440889,
		0,
		-0.295969,
		-0.498688,
		-0.433424,
		1
	},
	[0.3] = {
		-0.700645,
		0.119399,
		-0.703449,
		0,
		-0.195597,
		-0.980272,
		0.028433,
		0,
		-0.686176,
		0.157514,
		0.710177,
		0,
		-0.304291,
		-0.429757,
		-0.432313,
		1
	},
	[0.416666666667] = {
		-0.190477,
		0.068629,
		-0.97929,
		0,
		-0.35448,
		-0.935057,
		0.003419,
		0,
		-0.915457,
		0.34779,
		0.202434,
		0,
		-0.249425,
		-0.455103,
		-0.455393,
		1
	},
	[0.433333333333] = {
		-0.051535,
		0.025747,
		-0.998339,
		0,
		-0.361033,
		-0.932537,
		-0.005413,
		0,
		-0.931128,
		0.360154,
		0.057353,
		0,
		-0.223385,
		-0.428555,
		-0.468598,
		1
	},
	[0.45] = {
		0.097329,
		-0.022688,
		-0.994994,
		0,
		-0.365363,
		-0.930752,
		-0.014516,
		0,
		-0.925763,
		0.364947,
		-0.098878,
		0,
		-0.196675,
		-0.399432,
		-0.483142,
		1
	},
	[0.466666666667] = {
		0.249072,
		-0.074132,
		-0.965644,
		0,
		-0.367687,
		-0.929654,
		-0.02347,
		0,
		-0.895974,
		0.3609,
		-0.258808,
		0,
		-0.169996,
		-0.368244,
		-0.499053,
		1
	},
	[0.483333333333] = {
		0.395539,
		-0.125591,
		-0.909822,
		0,
		-0.368374,
		-0.929131,
		-0.031891,
		0,
		-0.841338,
		0.347769,
		-0.413772,
		0,
		-0.14385,
		-0.335572,
		-0.51638,
		1
	},
	[0.4] = {
		-0.314567,
		0.104196,
		-0.943499,
		0,
		-0.345625,
		-0.938301,
		0.011611,
		0,
		-0.884076,
		0.329749,
		0.331171,
		0,
		-0.273936,
		-0.478623,
		-0.443597,
		1
	},
	[0.516666666667] = {
		0.643482,
		-0.21754,
		-0.733898,
		0,
		-0.366913,
		-0.929102,
		-0.046308,
		0,
		-0.671792,
		0.299075,
		-0.677679,
		0,
		-0.094277,
		-0.268443,
		-0.55496,
		1
	},
	[0.533333333333] = {
		0.735995,
		-0.254449,
		-0.627349,
		0,
		-0.365876,
		-0.929189,
		-0.052365,
		0,
		-0.569601,
		0.268072,
		-0.776976,
		0,
		-0.071186,
		-0.23542,
		-0.575598,
		1
	},
	[0.55] = {
		0.806258,
		-0.284623,
		-0.518593,
		0,
		-0.365277,
		-0.929092,
		-0.057977,
		0,
		-0.465318,
		0.236175,
		-0.853053,
		0,
		-0.04948,
		-0.203717,
		-0.596411,
		1
	},
	[0.566666666667] = {
		0.856243,
		-0.308642,
		-0.414232,
		0,
		-0.365471,
		-0.928653,
		-0.063515,
		0,
		-0.365075,
		0.205774,
		-0.907953,
		0,
		-0.029471,
		-0.174018,
		-0.616696,
		1
	},
	[0.583333333333] = {
		0.889236,
		-0.327615,
		-0.319261,
		0,
		-0.36671,
		-0.927745,
		-0.069374,
		0,
		-0.273465,
		0.178766,
		-0.945124,
		0,
		-0.011593,
		-0.14697,
		-0.635702,
		1
	},
	[0.5] = {
		0.528967,
		-0.174154,
		-0.830581,
		0,
		-0.367928,
		-0.929014,
		-0.039526,
		0,
		-0.764737,
		0.326502,
		-0.555494,
		0,
		-0.118549,
		-0.302069,
		-0.535085,
		1
	},
	[0.616666666667] = {
		0.919053,
		-0.355716,
		-0.169726,
		0,
		-0.373073,
		-0.924032,
		-0.083554,
		0,
		-0.127111,
		0.140111,
		-0.981943,
		0,
		0.015555,
		-0.103264,
		-0.66693,
		1
	},
	[0.633333333333] = {
		0.922516,
		-0.367313,
		-0.118512,
		0,
		-0.37857,
		-0.920936,
		-0.09253,
		0,
		-0.075154,
		0.130226,
		-0.988632,
		0,
		0.023567,
		-0.087779,
		-0.677786,
		1
	},
	[0.65] = {
		0.922132,
		-0.378584,
		-0.079662,
		0,
		-0.385351,
		-0.917076,
		-0.102357,
		0,
		-0.034305,
		0.125084,
		-0.991553,
		0,
		0.028481,
		-0.075493,
		-0.685938,
		1
	},
	[0.666666666667] = {
		0.919571,
		-0.389939,
		-0.048335,
		0,
		-0.392923,
		-0.912683,
		-0.112341,
		0,
		-0.000309,
		0.122297,
		-0.992493,
		0,
		0.031623,
		-0.064721,
		-0.692525,
		1
	},
	[0.683333333333] = {
		0.915537,
		-0.401526,
		-0.02384,
		0,
		-0.40129,
		-0.907726,
		-0.122473,
		0,
		0.027536,
		0.121695,
		-0.992186,
		0,
		0.033079,
		-0.055381,
		-0.697613,
		1
	},
	[0.6] = {
		0.908979,
		-0.342868,
		-0.237062,
		0,
		-0.369186,
		-0.926248,
		-0.075937,
		0,
		-0.193541,
		0.156545,
		-0.968522,
		0,
		0.003619,
		-0.123188,
		-0.652683,
		1
	},
	[0.716666666667] = {
		0.904829,
		-0.425716,
		0.007136,
		0,
		-0.420422,
		-0.895975,
		-0.143085,
		0,
		0.067307,
		0.126467,
		-0.989685,
		0,
		0.031315,
		-0.040679,
		-0.70362,
		1
	},
	[0.733333333333] = {
		0.898674,
		-0.438372,
		0.014695,
		0,
		-0.431195,
		-0.889107,
		-0.153493,
		0,
		0.080352,
		0.131604,
		-0.988041,
		0,
		0.028303,
		-0.035159,
		-0.70472,
		1
	},
	[0.75] = {
		0.892157,
		-0.451383,
		0.017589,
		0,
		-0.442772,
		-0.881526,
		-0.163905,
		0,
		0.089489,
		0.138441,
		-0.986319,
		0,
		0.024021,
		-0.030757,
		-0.70468,
		1
	},
	[0.766666666667] = {
		0.885317,
		-0.464706,
		0.016224,
		0,
		-0.45515,
		-0.873196,
		-0.174265,
		0,
		0.095149,
		0.146895,
		-0.984565,
		0,
		0.018584,
		-0.027396,
		-0.7036,
		1
	},
	[0.783333333333] = {
		0.87814,
		-0.478278,
		0.010968,
		0,
		-0.468316,
		-0.864082,
		-0.184507,
		0,
		0.097723,
		0.156887,
		-0.98277,
		0,
		0.012115,
		-0.024999,
		-0.701584,
		1
	},
	[0.7] = {
		0.910516,
		-0.413437,
		-0.00554,
		0,
		-0.410455,
		-0.902169,
		-0.132731,
		0,
		0.049878,
		0.123128,
		-0.991137,
		0,
		0.032943,
		-0.047394,
		-0.701282,
		1
	},
	[0.816666666667] = {
		0.862569,
		-0.505844,
		-0.009867,
		0,
		-0.496931,
		-0.843384,
		-0.204358,
		0,
		0.095052,
		0.181176,
		-0.978846,
		0,
		-0.003424,
		-0.022789,
		-0.695152,
		1
	},
	[0.833333333333] = {
		0.85402,
		-0.519648,
		-0.024802,
		0,
		-0.512311,
		-0.831757,
		-0.213816,
		0,
		0.09048,
		0.19531,
		-0.976559,
		0,
		-0.01224,
		-0.022821,
		-0.690945,
		1
	},
	[0.85] = {
		0.844849,
		-0.533329,
		-0.042326,
		0,
		-0.528341,
		-0.819261,
		-0.222861,
		0,
		0.084182,
		0.210646,
		-0.973931,
		0,
		-0.021583,
		-0.023506,
		-0.686217,
		1
	},
	[0.866666666667] = {
		0.834971,
		-0.546777,
		-0.062115,
		0,
		-0.544954,
		-0.805898,
		-0.231417,
		0,
		0.076476,
		0.227076,
		-0.97087,
		0,
		-0.031322,
		-0.024764,
		-0.681072,
		1
	},
	[0.883333333333] = {
		0.824316,
		-0.559888,
		-0.083831,
		0,
		-0.562069,
		-0.79168,
		-0.239418,
		0,
		0.06768,
		0.244475,
		-0.967291,
		0,
		-0.041328,
		-0.026516,
		-0.675614,
		1
	},
	[0.8] = {
		0.870581,
		-0.49202,
		0.002163,
		0,
		-0.482253,
		-0.854153,
		-0.194563,
		0,
		0.097576,
		0.16834,
		-0.980888,
		0,
		0.004737,
		-0.023489,
		-0.698733,
		1
	},
	[0.916666666667] = {
		0.800491,
		-0.584715,
		-0.131613,
		0,
		-0.597412,
		-0.76081,
		-0.253509,
		0,
		0.048098,
		0.281559,
		-0.958338,
		0,
		-0.061617,
		-0.031185,
		-0.664172,
		1
	},
	[0.933333333333] = {
		0.787295,
		-0.596269,
		-0.156938,
		0,
		-0.615407,
		-0.744252,
		-0.259544,
		0,
		0.037957,
		0.300918,
		-0.952894,
		0,
		-0.071639,
		-0.033921,
		-0.658396,
		1
	},
	[0.95] = {
		0.773283,
		-0.607168,
		-0.182702,
		0,
		-0.633442,
		-0.727033,
		-0.264905,
		0,
		0.028012,
		0.320578,
		-0.946808,
		0,
		-0.081405,
		-0.036796,
		-0.652721,
		1
	},
	[0.966666666667] = {
		0.758529,
		-0.617381,
		-0.208505,
		0,
		-0.651374,
		-0.709236,
		-0.269623,
		0,
		0.01858,
		0.340332,
		-0.940122,
		0,
		-0.090786,
		-0.039712,
		-0.647249,
		1
	},
	[0.983333333333] = {
		0.743083,
		-0.626979,
		-0.233936,
		0,
		-0.669125,
		-0.690893,
		-0.27375,
		0,
		0.010011,
		0.359951,
		-0.932918,
		0,
		-0.099655,
		-0.04256,
		-0.642084,
		1
	},
	[0.9] = {
		0.812832,
		-0.572564,
		-0.10712,
		0,
		-0.579592,
		-0.776637,
		-0.246796,
		0,
		0.058113,
		0.262689,
		-0.963129,
		0,
		-0.05147,
		-0.028684,
		-0.669946,
		1
	},
	[1.01666666667] = {
		0.71069,
		-0.644504,
		-0.282018,
		0,
		-0.703498,
		-0.652962,
		-0.280591,
		0,
		-0.003305,
		0.397812,
		-0.917461,
		0,
		-0.115344,
		-0.047645,
		-0.633085,
		1
	},
	[1.03333333333] = {
		0.694241,
		-0.652462,
		-0.303847,
		0,
		-0.719703,
		-0.633737,
		-0.283556,
		0,
		-0.00755,
		0.415536,
		-0.909545,
		0,
		-0.121895,
		-0.049699,
		-0.629456,
		1
	},
	[1.05] = {
		0.678002,
		-0.659964,
		-0.323667,
		0,
		-0.734993,
		-0.614609,
		-0.286428,
		0,
		-0.009896,
		0.432092,
		-0.901775,
		0,
		-0.127403,
		-0.051311,
		-0.626545,
		1
	},
	[1.06666666667] = {
		0.662284,
		-0.667111,
		-0.34109,
		0,
		-0.749184,
		-0.595795,
		-0.289398,
		0,
		-0.010159,
		0.447203,
		-0.894375,
		0,
		-0.131731,
		-0.052396,
		-0.624454,
		1
	},
	[1.08333333333] = {
		0.647401,
		-0.674032,
		-0.355744,
		0,
		-0.762106,
		-0.577527,
		-0.292672,
		0,
		-0.008181,
		0.460591,
		-0.887575,
		0,
		-0.134739,
		-0.05287,
		-0.623287,
		1
	},
	[1.1] = {
		0.633664,
		-0.680871,
		-0.367267,
		0,
		-0.773599,
		-0.560043,
		-0.296472,
		0,
		-0.003826,
		0.471981,
		-0.8816,
		0,
		-0.136288,
		-0.052649,
		-0.623146,
		1
	}
}

return spline_matrices
