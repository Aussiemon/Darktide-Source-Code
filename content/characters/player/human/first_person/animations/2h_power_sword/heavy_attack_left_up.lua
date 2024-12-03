﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_power_sword/heavy_attack_left_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.456499,
		-0.545668,
		0.702749,
		0,
		-0.880407,
		-0.163034,
		0.445312,
		0,
		-0.12842,
		-0.821989,
		-0.554835,
		0,
		0.292851,
		0.00124,
		-0.552309,
		1,
	},
	[0.0333333333333] = {
		0.431554,
		-0.529848,
		0.730084,
		0,
		-0.90167,
		-0.22876,
		0.366959,
		0,
		-0.027418,
		-0.816658,
		-0.57647,
		0,
		0.292841,
		0.043121,
		-0.53136,
		1,
	},
	[0.05] = {
		0.39975,
		-0.511558,
		0.760597,
		0,
		-0.910052,
		-0.320688,
		0.262612,
		0,
		0.109573,
		-0.797162,
		-0.593739,
		0,
		0.29107,
		0.100717,
		-0.501145,
		1,
	},
	[0.0666666666667] = {
		0.372069,
		-0.496474,
		0.784269,
		0,
		-0.893009,
		-0.421928,
		0.15656,
		0,
		0.253177,
		-0.75861,
		-0.600343,
		0,
		0.285679,
		0.163235,
		-0.466095,
		1,
	},
	[0.0833333333333] = {
		0.361763,
		-0.48967,
		0.793316,
		0,
		-0.854108,
		-0.515157,
		0.071507,
		0,
		0.373667,
		-0.703446,
		-0.604596,
		0,
		0.274825,
		0.2195,
		-0.431768,
		1,
	},
	[0] = {
		0.466274,
		-0.551231,
		0.691906,
		0,
		-0.868641,
		-0.137207,
		0.476065,
		0,
		-0.167487,
		-0.822994,
		-0.542797,
		0,
		0.292671,
		-0.01594,
		-0.560088,
		1,
	},
	[0.116666666667] = {
		0.580981,
		-0.492754,
		0.647808,
		0,
		-0.602248,
		-0.795651,
		-0.06509,
		0,
		0.547502,
		-0.352325,
		-0.759018,
		0,
		0.233738,
		0.348679,
		-0.393484,
		1,
	},
	[0.133333333333] = {
		0.688178,
		-0.49043,
		0.534687,
		0,
		-0.446588,
		-0.867127,
		-0.220565,
		0,
		0.571813,
		-0.086997,
		-0.815758,
		0,
		0.196331,
		0.429941,
		-0.376891,
		1,
	},
	[0.15] = {
		0.794271,
		-0.313784,
		0.520263,
		0,
		-0.102237,
		-0.913127,
		-0.394648,
		0,
		0.5989,
		0.260268,
		-0.75735,
		0,
		0.122793,
		0.580503,
		-0.300929,
		1,
	},
	[0.166666666667] = {
		0.806828,
		-0.122237,
		0.578002,
		0,
		0.288653,
		-0.772068,
		-0.566207,
		0,
		0.515468,
		0.623673,
		-0.587643,
		0,
		0.041738,
		0.701997,
		-0.202762,
		1,
	},
	[0.183333333333] = {
		0.82419,
		-0.084773,
		0.559932,
		0,
		0.476294,
		-0.431107,
		-0.766349,
		0,
		0.306357,
		0.89831,
		-0.314937,
		0,
		-0.023759,
		0.730679,
		-0.1146,
		1,
	},
	[0.1] = {
		0.450746,
		-0.491284,
		0.745297,
		0,
		-0.751654,
		-0.659253,
		0.020025,
		0,
		0.481502,
		-0.569232,
		-0.666432,
		0,
		0.257839,
		0.284431,
		-0.404232,
		1,
	},
	[0.216666666667] = {
		0.836596,
		-0.087151,
		0.540844,
		0,
		0.544964,
		0.031705,
		-0.83786,
		0,
		0.055873,
		0.99569,
		0.074018,
		0,
		-0.166258,
		0.660084,
		0.088393,
		1,
	},
	[0.233333333333] = {
		0.827909,
		-0.109642,
		0.550041,
		0,
		0.557203,
		0.272642,
		-0.784341,
		0,
		-0.063968,
		0.955848,
		0.286816,
		0,
		-0.213695,
		0.550395,
		0.165614,
		1,
	},
	[0.25] = {
		0.802627,
		-0.151318,
		0.576968,
		0,
		0.571819,
		0.470463,
		-0.672077,
		0,
		-0.169745,
		0.869349,
		0.464133,
		0,
		-0.24586,
		0.436285,
		0.210524,
		1,
	},
	[0.266666666667] = {
		0.836974,
		-0.13763,
		0.529653,
		0,
		0.49873,
		0.590236,
		-0.634736,
		0,
		-0.225262,
		0.795412,
		0.562652,
		0,
		-0.268247,
		0.309111,
		0.231553,
		1,
	},
	[0.283333333333] = {
		0.887924,
		-0.082048,
		0.452614,
		0,
		0.397793,
		0.631053,
		-0.665983,
		0,
		-0.23098,
		0.771389,
		0.592965,
		0,
		-0.278955,
		0.24492,
		0.232095,
		1,
	},
	[0.2] = {
		0.856229,
		-0.089433,
		0.508796,
		0,
		0.476251,
		-0.244916,
		-0.844512,
		0,
		0.20014,
		0.965411,
		-0.167112,
		0,
		-0.084004,
		0.733775,
		-0.025713,
		1,
	},
	[0.316666666667] = {
		0.923994,
		-0.0121,
		0.382216,
		0,
		0.286214,
		0.684739,
		-0.670235,
		0,
		-0.253608,
		0.728688,
		0.636157,
		0,
		-0.269466,
		0.121088,
		0.23524,
		1,
	},
	[0.333333333333] = {
		0.924204,
		-0.00306,
		0.381886,
		0,
		0.272049,
		0.707068,
		-0.65272,
		0,
		-0.268023,
		0.707139,
		0.654308,
		0,
		-0.259875,
		0.068701,
		0.234774,
		1,
	},
	[0.35] = {
		0.924325,
		0.003743,
		0.381589,
		0,
		0.259045,
		0.728109,
		-0.634628,
		0,
		-0.280214,
		0.685451,
		0.672039,
		0,
		-0.25011,
		0.023855,
		0.231954,
		1,
	},
	[0.366666666667] = {
		0.92438,
		0.007927,
		0.381389,
		0,
		0.249587,
		0.743528,
		-0.620382,
		0,
		-0.288491,
		0.668658,
		0.685324,
		0,
		-0.242756,
		-0.014467,
		0.226171,
		1,
	},
	[0.383333333333] = {
		0.924392,
		0.009016,
		0.381336,
		0,
		0.246192,
		0.749509,
		-0.614513,
		0,
		-0.291356,
		0.661933,
		0.690621,
		0,
		-0.240326,
		-0.044477,
		0.216747,
		1,
	},
	[0.3] = {
		0.922285,
		-0.022076,
		0.385879,
		0,
		0.302655,
		0.662199,
		-0.685487,
		0,
		-0.240396,
		0.749003,
		0.617417,
		0,
		-0.276522,
		0.180922,
		0.234051,
		1,
	},
	[0.416666666667] = {
		0.909742,
		-0.025445,
		0.414394,
		0,
		0.29376,
		0.744778,
		-0.599175,
		0,
		-0.293386,
		0.666827,
		0.68503,
		0,
		-0.248583,
		-0.087189,
		0.191246,
		1,
	},
	[0.433333333333] = {
		0.890751,
		-0.061764,
		0.450274,
		0,
		0.344357,
		0.738294,
		-0.579948,
		0,
		-0.296615,
		0.671645,
		0.678906,
		0,
		-0.256697,
		-0.103184,
		0.176476,
		1,
	},
	[0.45] = {
		0.863154,
		-0.105649,
		0.493765,
		0,
		0.405101,
		0.728632,
		-0.552257,
		0,
		-0.301428,
		0.676708,
		0.67172,
		0,
		-0.26668,
		-0.11608,
		0.160293,
		1,
	},
	[0.466666666667] = {
		0.827077,
		-0.153189,
		0.540811,
		0,
		0.470161,
		0.715835,
		-0.516264,
		0,
		-0.308046,
		0.681258,
		0.664074,
		0,
		-0.277951,
		-0.126219,
		0.142644,
		1,
	},
	[0.483333333333] = {
		0.783795,
		-0.200464,
		0.587775,
		0,
		0.534121,
		0.700468,
		-0.473349,
		0,
		-0.316828,
		0.684952,
		0.656095,
		0,
		-0.289929,
		-0.133941,
		0.123468,
		1,
	},
	[0.4] = {
		0.920741,
		-0.000569,
		0.390174,
		0,
		0.259178,
		0.748391,
		-0.610523,
		0,
		-0.291655,
		0.663258,
		0.689221,
		0,
		-0.242928,
		-0.067739,
		0.204651,
		1,
	},
	[0.516666666667] = {
		0.686341,
		-0.278866,
		0.671692,
		0,
		0.64176,
		0.666741,
		-0.378946,
		0,
		-0.342169,
		0.691152,
		0.636576,
		0,
		-0.313664,
		-0.143399,
		0.080261,
		1,
	},
	[0.533333333333] = {
		0.639333,
		-0.302431,
		0.706958,
		0,
		0.680063,
		0.651463,
		-0.336319,
		0,
		-0.358843,
		0.695795,
		0.622174,
		0,
		-0.324246,
		-0.145701,
		0.056113,
		1,
	},
	[0.55] = {
		0.598514,
		-0.310773,
		0.738378,
		0,
		0.706381,
		0.639502,
		-0.303419,
		0,
		-0.377899,
		0.703176,
		0.602275,
		0,
		-0.333177,
		-0.14679,
		0.030141,
		1,
	},
	[0.566666666667] = {
		0.567016,
		-0.288451,
		0.77155,
		0,
		0.717843,
		0.63242,
		-0.29111,
		0,
		-0.403973,
		0.718916,
		0.565655,
		0,
		-0.341477,
		-0.145081,
		0.000628,
		1,
	},
	[0.583333333333] = {
		0.541452,
		-0.227929,
		0.809245,
		0,
		0.716975,
		0.627866,
		-0.302873,
		0,
		-0.439063,
		0.7442,
		0.503379,
		0,
		-0.350317,
		-0.139449,
		-0.033354,
		1,
	},
	[0.5] = {
		0.735764,
		-0.243632,
		0.631898,
		0,
		0.592431,
		0.683631,
		-0.426232,
		0,
		-0.328142,
		0.687962,
		0.647326,
		0,
		-0.302028,
		-0.139574,
		0.102692,
		1,
	},
	[0.616666666667] = {
		0.483413,
		-0.026051,
		0.875005,
		0,
		0.703702,
		0.606105,
		-0.370729,
		0,
		-0.520687,
		0.794958,
		0.311331,
		0,
		-0.368175,
		-0.120651,
		-0.110396,
		1,
	},
	[0.633333333333] = {
		0.442951,
		0.095401,
		0.891456,
		0,
		0.701276,
		0.582624,
		-0.410804,
		0,
		-0.558575,
		0.807123,
		0.191171,
		0,
		-0.376448,
		-0.109605,
		-0.151192,
		1,
	},
	[0.65] = {
		0.393969,
		0.215433,
		0.893519,
		0,
		0.706054,
		0.551462,
		-0.444273,
		0,
		-0.588453,
		0.805902,
		0.065152,
		0,
		-0.383773,
		-0.098779,
		-0.191909,
		1,
	},
	[0.666666666667] = {
		0.338715,
		0.322973,
		0.88372,
		0,
		0.719128,
		0.516806,
		-0.464507,
		0,
		-0.606734,
		0.792843,
		-0.057209,
		0,
		-0.389792,
		-0.089039,
		-0.231313,
		1,
	},
	[0.683333333333] = {
		0.280357,
		0.408582,
		0.868597,
		0,
		0.739767,
		0.484652,
		-0.466752,
		0,
		-0.611673,
		0.773417,
		-0.16638,
		0,
		-0.394191,
		-0.081158,
		-0.26818,
		1,
	},
	[0.6] = {
		0.515328,
		-0.137392,
		0.845908,
		0,
		0.71041,
		0.620565,
		-0.33199,
		0,
		-0.479329,
		0.772025,
		0.417399,
		0,
		-0.359338,
		-0.130947,
		-0.070731,
		1,
	},
	[0.716666666667] = {
		0.16176,
		0.48507,
		0.859384,
		0,
		0.793653,
		0.453599,
		-0.405417,
		0,
		-0.586471,
		0.747633,
		-0.311603,
		0,
		-0.397174,
		-0.073817,
		-0.329568,
		1,
	},
	[0.733333333333] = {
		0.091343,
		0.482422,
		0.871163,
		0,
		0.82058,
		0.45917,
		-0.340312,
		0,
		-0.564186,
		0.745944,
		-0.353923,
		0,
		-0.393213,
		-0.075305,
		-0.35471,
		1,
	},
	[0.75] = {
		0.004316,
		0.475019,
		0.879965,
		0,
		0.842716,
		0.472002,
		-0.258928,
		0,
		-0.538341,
		0.742678,
		-0.398269,
		0,
		-0.383507,
		-0.079561,
		-0.379011,
		1,
	},
	[0.766666666667] = {
		-0.094047,
		0.463887,
		0.880888,
		0,
		0.855477,
		0.490232,
		-0.166828,
		0,
		-0.509229,
		0.73789,
		-0.442949,
		0,
		-0.36947,
		-0.08588,
		-0.402062,
		1,
	},
	[0.783333333333] = {
		-0.197529,
		0.450087,
		0.870864,
		0,
		0.856117,
		0.511963,
		-0.070412,
		0,
		-0.477542,
		0.731653,
		-0.486455,
		0,
		-0.352527,
		-0.093564,
		-0.423451,
		1,
	},
	[0.7] = {
		0.221326,
		0.464771,
		0.857323,
		0,
		0.765732,
		0.461561,
		-0.447902,
		0,
		-0.603879,
		0.755612,
		-0.253734,
		0,
		-0.396716,
		-0.075846,
		-0.301318,
		1,
	},
	[0.816666666667] = {
		-0.392976,
		0.419039,
		0.81852,
		0,
		0.822435,
		0.558312,
		0.109029,
		0,
		-0.411303,
		0.716026,
		-0.564036,
		0,
		-0.315693,
		-0.110246,
		-0.459565,
		1,
	},
	[0.833333333333] = {
		-0.472591,
		0.404228,
		0.783108,
		0,
		0.794889,
		0.579218,
		0.180718,
		0,
		-0.380538,
		0.707889,
		-0.595049,
		0,
		-0.298731,
		-0.117854,
		-0.473431,
		1,
	},
	[0.85] = {
		-0.533704,
		0.391599,
		0.74954,
		0,
		0.767605,
		0.596269,
		0.235045,
		0,
		-0.354884,
		0.700795,
		-0.618824,
		0,
		-0.284722,
		-0.124048,
		-0.483922,
		1,
	},
	[0.866666666667] = {
		-0.572868,
		0.382464,
		0.724944,
		0,
		0.746917,
		0.607828,
		0.269555,
		0,
		-0.337546,
		0.695892,
		-0.633874,
		0,
		-0.275173,
		-0.128137,
		-0.490598,
		1,
	},
	[0.883333333333] = {
		-0.58695,
		0.378126,
		0.715899,
		0,
		0.738562,
		0.612321,
		0.282114,
		0,
		-0.331686,
		0.694322,
		-0.638671,
		0,
		-0.271592,
		-0.129437,
		-0.493015,
		1,
	},
	[0.8] = {
		-0.299373,
		0.434742,
		0.849338,
		0,
		0.844341,
		0.535286,
		0.023621,
		0,
		-0.44437,
		0.724202,
		-0.52732,
		0,
		-0.334116,
		-0.101917,
		-0.442761,
		1,
	},
	[0.916666666667] = {
		-0.587642,
		0.375276,
		0.71683,
		0,
		0.7373,
		0.613263,
		0.283367,
		0,
		-0.333264,
		0.695037,
		-0.63707,
		0,
		-0.271393,
		-0.128915,
		-0.493261,
		1,
	},
	[0.933333333333] = {
		-0.587977,
		0.374011,
		0.717216,
		0,
		0.736691,
		0.613756,
		0.283884,
		0,
		-0.33402,
		0.695284,
		-0.636405,
		0,
		-0.271294,
		-0.128737,
		-0.493362,
		1,
	},
	[0.95] = {
		-0.588303,
		0.372859,
		0.717548,
		0,
		0.736099,
		0.614261,
		0.284325,
		0,
		-0.334749,
		0.695456,
		-0.635833,
		0,
		-0.271197,
		-0.128615,
		-0.493447,
		1,
	},
	[0.966666666667] = {
		-0.588621,
		0.371824,
		0.717825,
		0,
		0.735526,
		0.614779,
		0.284689,
		0,
		-0.33545,
		0.695553,
		-0.635358,
		0,
		-0.271101,
		-0.128551,
		-0.493517,
		1,
	},
	[0.983333333333] = {
		-0.588931,
		0.370908,
		0.718044,
		0,
		0.73497,
		0.615312,
		0.284972,
		0,
		-0.336123,
		0.695571,
		-0.634983,
		0,
		-0.271005,
		-0.128546,
		-0.493571,
		1,
	},
	[0.9] = {
		-0.587297,
		0.376653,
		0.71639,
		0,
		0.737928,
		0.61278,
		0.282776,
		0,
		-0.332482,
		0.694718,
		-0.637827,
		0,
		-0.271493,
		-0.129147,
		-0.493145,
		1,
	},
	[1.01666666667] = {
		-0.589528,
		0.369443,
		0.718309,
		0,
		0.733912,
		0.616427,
		0.285291,
		0,
		-0.337387,
		0.695362,
		-0.63454,
		0,
		-0.270815,
		-0.128724,
		-0.493629,
		1,
	},
	[1.03333333333] = {
		-0.589817,
		0.3689,
		0.718351,
		0,
		0.733408,
		0.617012,
		0.285321,
		0,
		-0.337976,
		0.695132,
		-0.634479,
		0,
		-0.27072,
		-0.12891,
		-0.493632,
		1,
	},
	[1.05] = {
		-0.5901,
		0.368467,
		0.718341,
		0,
		0.732921,
		0.61761,
		0.28528,
		0,
		-0.338538,
		0.694831,
		-0.634509,
		0,
		-0.270624,
		-0.12915,
		-0.493622,
		1,
	},
	[1.06666666667] = {
		-0.590377,
		0.368121,
		0.718291,
		0,
		0.732451,
		0.61821,
		0.285186,
		0,
		-0.339072,
		0.694481,
		-0.634608,
		0,
		-0.270528,
		-0.129428,
		-0.493602,
		1,
	},
	[1.08333333333] = {
		-0.590649,
		0.367856,
		0.718203,
		0,
		0.731998,
		0.618812,
		0.285045,
		0,
		-0.339577,
		0.694085,
		-0.634771,
		0,
		-0.270431,
		-0.129741,
		-0.493573,
		1,
	},
	{
		-0.589233,
		0.370113,
		0.718206,
		0,
		0.734432,
		0.615861,
		0.285174,
		0,
		-0.336769,
		0.695508,
		-0.634709,
		0,
		-0.27091,
		-0.128603,
		-0.493608,
		1,
	},
	[1.11666666667] = {
		-0.59117,
		0.367551,
		0.717931,
		0,
		0.731143,
		0.620012,
		0.284629,
		0,
		-0.34051,
		0.693175,
		-0.635265,
		0,
		-0.270241,
		-0.130456,
		-0.493488,
		1,
	},
	[1.13333333333] = {
		-0.591416,
		0.367499,
		0.717755,
		0,
		0.730743,
		0.620607,
		0.28436,
		0,
		-0.340942,
		0.69267,
		-0.635584,
		0,
		-0.27015,
		-0.130852,
		-0.493433,
		1,
	},
	[1.15] = {
		-0.591652,
		0.367507,
		0.717556,
		0,
		0.730361,
		0.621196,
		0.284056,
		0,
		-0.34135,
		0.692137,
		-0.635945,
		0,
		-0.270061,
		-0.131268,
		-0.493371,
		1,
	},
	[1.16666666667] = {
		-0.591879,
		0.36757,
		0.717337,
		0,
		0.729997,
		0.621776,
		0.283721,
		0,
		-0.341736,
		0.691583,
		-0.636341,
		0,
		-0.269975,
		-0.131701,
		-0.493303,
		1,
	},
	[1.18333333333] = {
		-0.592095,
		0.367682,
		0.717101,
		0,
		0.729652,
		0.622347,
		0.28336,
		0,
		-0.342099,
		0.69101,
		-0.636768,
		0,
		-0.269892,
		-0.132148,
		-0.493229,
		1,
	},
	[1.1] = {
		-0.590915,
		0.367668,
		0.718081,
		0,
		0.731562,
		0.619413,
		0.284859,
		0,
		-0.340055,
		0.693648,
		-0.634992,
		0,
		-0.270335,
		-0.130085,
		-0.493535,
		1,
	},
	[1.21666666667] = {
		-0.592498,
		0.368032,
		0.716588,
		0,
		0.729014,
		0.62345,
		0.282575,
		0,
		-0.34276,
		0.689828,
		-0.637693,
		0,
		-0.269736,
		-0.133067,
		-0.493067,
		1,
	},
	[1.23333333333] = {
		-0.592684,
		0.368259,
		0.716317,
		0,
		0.728722,
		0.623979,
		0.28216,
		0,
		-0.343059,
		0.689228,
		-0.638181,
		0,
		-0.269663,
		-0.133533,
		-0.492981,
		1,
	},
	[1.25] = {
		-0.59286,
		0.368514,
		0.716041,
		0,
		0.728448,
		0.62449,
		0.281736,
		0,
		-0.343336,
		0.688629,
		-0.638679,
		0,
		-0.269593,
		-0.133998,
		-0.492894,
		1,
	},
	[1.26666666667] = {
		-0.593025,
		0.368791,
		0.715761,
		0,
		0.728193,
		0.624981,
		0.281307,
		0,
		-0.343594,
		0.688034,
		-0.639181,
		0,
		-0.269527,
		-0.134458,
		-0.492804,
		1,
	},
	[1.28333333333] = {
		-0.59318,
		0.369085,
		0.715481,
		0,
		0.727955,
		0.625451,
		0.280878,
		0,
		-0.343831,
		0.687449,
		-0.639683,
		0,
		-0.269464,
		-0.134911,
		-0.492715,
		1,
	},
	[1.2] = {
		-0.592302,
		0.367838,
		0.71685,
		0,
		0.729324,
		0.622905,
		0.282977,
		0,
		-0.34244,
		0.690423,
		-0.637221,
		0,
		-0.269813,
		-0.132605,
		-0.49315,
		1,
	},
	[1.31666666667] = {
		-0.593457,
		0.369703,
		0.714932,
		0,
		0.727532,
		0.62632,
		0.280036,
		0,
		-0.344246,
		0.686326,
		-0.640665,
		0,
		-0.269351,
		-0.135778,
		-0.492538,
		1,
	},
	[1.33333333333] = {
		-0.59358,
		0.370016,
		0.714669,
		0,
		0.727348,
		0.626714,
		0.279633,
		0,
		-0.344424,
		0.685797,
		-0.641135,
		0,
		-0.2693,
		-0.136186,
		-0.492454,
		1,
	},
	[1.35] = {
		-0.593691,
		0.370324,
		0.714417,
		0,
		0.727181,
		0.62708,
		0.279246,
		0,
		-0.344585,
		0.685296,
		-0.641584,
		0,
		-0.269254,
		-0.136572,
		-0.492372,
		1,
	},
	[1.36666666667] = {
		-0.593791,
		0.370623,
		0.714179,
		0,
		0.727032,
		0.627414,
		0.278882,
		0,
		-0.344726,
		0.684829,
		-0.642008,
		0,
		-0.269212,
		-0.136932,
		-0.492295,
		1,
	},
	[1.38333333333] = {
		-0.59388,
		0.370906,
		0.713958,
		0,
		0.726901,
		0.627717,
		0.278543,
		0,
		-0.34485,
		0.684398,
		-0.6424,
		0,
		-0.269174,
		-0.137263,
		-0.492223,
		1,
	},
	[1.3] = {
		-0.593324,
		0.369391,
		0.715204,
		0,
		0.727735,
		0.625898,
		0.280453,
		0,
		-0.344048,
		0.686878,
		-0.640179,
		0,
		-0.269405,
		-0.135352,
		-0.492626,
		1,
	},
	[1.41666666667] = {
		-0.594023,
		0.371406,
		0.713579,
		0,
		0.726692,
		0.628216,
		0.277963,
		0,
		-0.345045,
		0.683668,
		-0.643072,
		0,
		-0.269113,
		-0.137823,
		-0.4921,
		1,
	},
	[1.43333333333] = {
		-0.594077,
		0.371611,
		0.713427,
		0,
		0.726613,
		0.62841,
		0.27773,
		0,
		-0.345117,
		0.683378,
		-0.643342,
		0,
		-0.26909,
		-0.138046,
		-0.492051,
		1,
	},
	[1.45] = {
		-0.594119,
		0.371781,
		0.713303,
		0,
		0.726553,
		0.628564,
		0.277541,
		0,
		-0.345172,
		0.683145,
		-0.64356,
		0,
		-0.269072,
		-0.138225,
		-0.49201,
		1,
	},
	[1.46666666667] = {
		-0.59415,
		0.371908,
		0.713211,
		0,
		0.726509,
		0.628676,
		0.277401,
		0,
		-0.345211,
		0.682972,
		-0.643722,
		0,
		-0.269058,
		-0.138357,
		-0.49198,
		1,
	},
	[1.48333333333] = {
		-0.594168,
		0.371989,
		0.713154,
		0,
		0.726483,
		0.628744,
		0.277313,
		0,
		-0.345234,
		0.682865,
		-0.643823,
		0,
		-0.26905,
		-0.138439,
		-0.491962,
		1,
	},
	[1.4] = {
		-0.593957,
		0.371169,
		0.713757,
		0,
		0.726788,
		0.627985,
		0.278236,
		0,
		-0.344956,
		0.68401,
		-0.642757,
		0,
		-0.269141,
		-0.137561,
		-0.492158,
		1,
	},
	[1.5] = {
		-0.594174,
		0.372017,
		0.713134,
		0,
		0.726475,
		0.628768,
		0.277283,
		0,
		-0.345242,
		0.682828,
		-0.643858,
		0,
		-0.269048,
		-0.138467,
		-0.491955,
		1,
	},
}

return spline_matrices
