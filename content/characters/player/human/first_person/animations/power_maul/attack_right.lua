﻿-- chunkname: @content/characters/player/human/first_person/animations/power_maul/attack_right.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.456483,
		0.685016,
		0.567782,
		0,
		0.878595,
		0.246399,
		0.409094,
		0,
		0.140335,
		0.685595,
		-0.714328,
		0,
		-0.104977,
		-0.059327,
		-0.687426,
		1,
	},
	[0.0333333333333] = {
		-0.684509,
		0.503035,
		0.527639,
		0,
		0.699738,
		0.25035,
		0.669098,
		0,
		0.204486,
		0.827212,
		-0.52336,
		0,
		-0.121306,
		-0.072629,
		-0.703123,
		1,
	},
	[0.05] = {
		-0.874606,
		0.117256,
		0.470442,
		0,
		0.483894,
		0.271539,
		0.831934,
		0,
		-0.030194,
		0.955258,
		-0.294228,
		0,
		-0.17252,
		-0.109439,
		-0.720841,
		1,
	},
	[0.0666666666667] = {
		-0.760003,
		-0.353031,
		0.545679,
		0,
		0.45378,
		0.312833,
		0.834398,
		0,
		-0.465274,
		0.881762,
		-0.077556,
		0,
		-0.237878,
		-0.160417,
		-0.730099,
		1,
	},
	[0.0833333333333] = {
		-0.37675,
		-0.646894,
		0.663014,
		0,
		0.542523,
		0.426055,
		0.723979,
		0,
		-0.750818,
		0.632459,
		0.190439,
		0,
		-0.279107,
		-0.214309,
		-0.72475,
		1,
	},
	[0] = {
		-0.456483,
		0.685016,
		0.567782,
		0,
		0.878595,
		0.246399,
		0.409094,
		0,
		0.140335,
		0.685595,
		-0.714328,
		0,
		-0.104977,
		-0.059327,
		-0.687426,
		1,
	},
	[0.116666666667] = {
		0.280342,
		-0.956404,
		0.081853,
		0,
		0.143665,
		0.126117,
		0.981557,
		0,
		-0.949088,
		-0.263412,
		0.172758,
		0,
		-0.270308,
		-0.270672,
		-0.683436,
		1,
	},
	[0.133333333333] = {
		0.500309,
		-0.708761,
		-0.497342,
		0,
		0.096448,
		-0.525205,
		0.845492,
		0,
		-0.860458,
		-0.470975,
		-0.194406,
		0,
		-0.259573,
		-0.221857,
		-0.619871,
		1,
	},
	[0.15] = {
		0.379053,
		-0.304006,
		-0.874013,
		0,
		0.451489,
		-0.763695,
		0.461441,
		0,
		-0.807761,
		-0.569518,
		-0.152225,
		0,
		-0.266132,
		-0.152942,
		-0.524677,
		1,
	},
	[0.166666666667] = {
		0.116714,
		-0.08923,
		-0.989149,
		0,
		0.735932,
		-0.661023,
		0.146466,
		0,
		-0.66692,
		-0.745041,
		-0.011483,
		0,
		-0.278537,
		-0.103024,
		-0.434912,
		1,
	},
	[0.183333333333] = {
		-0.027837,
		0.044861,
		-0.998605,
		0,
		0.879697,
		-0.473325,
		-0.045786,
		0,
		-0.474719,
		-0.879745,
		-0.026288,
		0,
		-0.298252,
		-0.065201,
		-0.35231,
		1,
	},
	[0.1] = {
		-0.019348,
		-0.849922,
		0.526553,
		0,
		0.462537,
		0.459296,
		0.758358,
		0,
		-0.886389,
		0.258223,
		0.384234,
		0,
		-0.284179,
		-0.257003,
		-0.707825,
		1,
	},
	[0.216666666667] = {
		-0.320489,
		0.180833,
		-0.929831,
		0,
		0.940706,
		-0.054443,
		-0.334825,
		0,
		-0.11117,
		-0.982006,
		-0.152662,
		0,
		-0.351698,
		0.005046,
		-0.193258,
		1,
	},
	[0.233333333333] = {
		-0.458729,
		0.149777,
		-0.875862,
		0,
		0.888255,
		0.103781,
		-0.447473,
		0,
		0.023876,
		-0.983258,
		-0.180648,
		0,
		-0.383617,
		0.014524,
		-0.137831,
		1,
	},
	[0.25] = {
		-0.481793,
		0.123162,
		-0.867586,
		0,
		0.869416,
		0.190912,
		-0.455707,
		0,
		0.109507,
		-0.97385,
		-0.199059,
		0,
		-0.415125,
		0.011715,
		-0.101807,
		1,
	},
	[0.266666666667] = {
		-0.404902,
		0.141421,
		-0.903357,
		0,
		0.913307,
		0.015151,
		-0.40699,
		0,
		-0.043871,
		-0.989834,
		-0.135295,
		0,
		-0.429646,
		0.071194,
		-0.090781,
		1,
	},
	[0.283333333333] = {
		-0.289815,
		0.139915,
		-0.9468,
		0,
		0.922757,
		-0.221712,
		-0.31522,
		0,
		-0.254021,
		-0.965022,
		-0.064852,
		0,
		-0.446744,
		0.175295,
		-0.079695,
		1,
	},
	[0.2] = {
		-0.168305,
		0.140024,
		-0.975739,
		0,
		0.944575,
		-0.260141,
		-0.200262,
		0,
		-0.281871,
		-0.955364,
		-0.08848,
		0,
		-0.322973,
		-0.025345,
		-0.268442,
		1,
	},
	[0.316666666667] = {
		-0.078602,
		0.077302,
		-0.993904,
		0,
		0.670066,
		-0.734093,
		-0.110086,
		0,
		-0.738128,
		-0.674635,
		0.005904,
		0,
		-0.381915,
		0.425971,
		-0.058633,
		1,
	},
	[0.333333333333] = {
		-0.017609,
		0.043991,
		-0.998877,
		0,
		0.31736,
		-0.947125,
		-0.047306,
		0,
		-0.948142,
		-0.317836,
		0.002717,
		0,
		-0.298063,
		0.53315,
		-0.047338,
		1,
	},
	[0.35] = {
		0.019694,
		0.046368,
		-0.99873,
		0,
		-0.494757,
		-0.86759,
		-0.050035,
		0,
		-0.868808,
		0.495114,
		0.005855,
		0,
		-0.079214,
		0.594495,
		-0.035511,
		1,
	},
	[0.366666666667] = {
		0.049251,
		0.042456,
		-0.997884,
		0,
		-0.976486,
		-0.207897,
		-0.05704,
		0,
		-0.209879,
		0.977229,
		0.031219,
		0,
		0.184089,
		0.584904,
		-0.029666,
		1,
	},
	[0.383333333333] = {
		0.054986,
		0.03577,
		-0.997846,
		0,
		-0.959824,
		0.277298,
		-0.04295,
		0,
		0.275164,
		0.960118,
		0.04958,
		0,
		0.382622,
		0.494546,
		-0.036411,
		1,
	},
	[0.3] = {
		-0.172745,
		0.114938,
		-0.978237,
		0,
		0.852273,
		-0.480419,
		-0.206948,
		0,
		-0.493751,
		-0.869475,
		-0.014969,
		0,
		-0.432228,
		0.301046,
		-0.070001,
		1,
	},
	[0.416666666667] = {
		0.063121,
		0.016786,
		-0.997865,
		0,
		-0.820867,
		0.569547,
		-0.042344,
		0,
		0.56762,
		0.821787,
		0.049729,
		0,
		0.638134,
		0.301769,
		-0.040883,
		1,
	},
	[0.433333333333] = {
		0.06012,
		0.00378,
		-0.998184,
		0,
		-0.749282,
		0.660877,
		-0.042626,
		0,
		0.659516,
		0.750484,
		0.042564,
		0,
		0.685973,
		0.230652,
		-0.039081,
		1,
	},
	[0.45] = {
		0.045493,
		0.028807,
		-0.998549,
		0,
		-0.731456,
		0.681752,
		-0.013657,
		0,
		0.680369,
		0.731016,
		0.052086,
		0,
		0.713836,
		0.175427,
		-0.045824,
		1,
	},
	[0.466666666667] = {
		0.029872,
		0.068387,
		-0.997212,
		0,
		-0.727285,
		0.685871,
		0.025249,
		0,
		0.685686,
		0.724502,
		0.070225,
		0,
		0.733299,
		0.121428,
		-0.065873,
		1,
	},
	[0.483333333333] = {
		0.011839,
		0.118939,
		-0.992831,
		0,
		-0.734064,
		0.675238,
		0.072139,
		0,
		0.678977,
		0.727947,
		0.095303,
		0,
		0.745324,
		0.068901,
		-0.096885,
		1,
	},
	[0.4] = {
		0.056345,
		0.037277,
		-0.997715,
		0,
		-0.87237,
		0.487859,
		-0.031039,
		0,
		0.485588,
		0.872126,
		0.060007,
		0,
		0.542176,
		0.383078,
		-0.042802,
		1,
	},
	[0.516666666667] = {
		-0.037182,
		0.238146,
		-0.970517,
		0,
		-0.766313,
		0.616547,
		0.180647,
		0,
		0.64139,
		0.750437,
		0.15957,
		0,
		0.750157,
		-0.030712,
		-0.182326,
		1,
	},
	[0.533333333333] = {
		-0.069799,
		0.299343,
		-0.951589,
		0,
		-0.784305,
		0.572998,
		0.237778,
		0,
		0.616436,
		0.762933,
		0.194782,
		0,
		0.744216,
		-0.077257,
		-0.232013,
		1,
	},
	[0.55] = {
		-0.107817,
		0.356962,
		-0.927876,
		0,
		-0.799506,
		0.523601,
		0.294335,
		0,
		0.590903,
		0.773576,
		0.22894,
		0,
		0.73356,
		-0.120628,
		-0.283078,
		1,
	},
	[0.566666666667] = {
		-0.15062,
		0.408077,
		-0.900437,
		0,
		-0.809764,
		0.471558,
		0.349163,
		0,
		0.567094,
		0.781733,
		0.25942,
		0,
		0.71906,
		-0.159734,
		-0.333022,
		1,
	},
	[0.583333333333] = {
		-0.197147,
		0.450548,
		-0.870712,
		0,
		-0.813087,
		0.421071,
		0.401981,
		0,
		0.547744,
		0.787214,
		0.283322,
		0,
		0.701585,
		-0.194002,
		-0.379484,
		1,
	},
	[0.5] = {
		-0.010129,
		0.176782,
		-0.984198,
		0,
		-0.748333,
		0.651492,
		0.124723,
		0,
		0.663246,
		0.737771,
		0.125693,
		0,
		0.750719,
		0.018099,
		-0.136493,
		1,
	},
	[0.616666666667] = {
		-0.296616,
		0.504896,
		-0.810617,
		0,
		-0.79309,
		0.342621,
		0.503606,
		0,
		0.532003,
		0.79227,
		0.298801,
		0,
		0.661317,
		-0.245685,
		-0.452652,
		1,
	},
	[0.633333333333] = {
		-0.347696,
		0.515974,
		-0.782865,
		0,
		-0.766913,
		0.323842,
		0.55405,
		0,
		0.5394,
		0.793031,
		0.283108,
		0,
		0.640538,
		-0.261981,
		-0.474888,
		1,
	},
	[0.65] = {
		-0.402849,
		0.517864,
		-0.754672,
		0,
		-0.728146,
		0.318236,
		0.607066,
		0,
		0.554541,
		0.794067,
		0.248879,
		0,
		0.616815,
		-0.270714,
		-0.490941,
		1,
	},
	[0.666666666667] = {
		-0.464893,
		0.512959,
		-0.721628,
		0,
		-0.6761,
		0.320555,
		0.663425,
		0,
		0.571632,
		0.796315,
		0.197787,
		0,
		0.587345,
		-0.27192,
		-0.50657,
		1,
	},
	[0.683333333333] = {
		-0.532196,
		0.502493,
		-0.681372,
		0,
		-0.609774,
		0.330809,
		0.720236,
		0,
		0.587318,
		0.79879,
		0.130352,
		0,
		0.552683,
		-0.266455,
		-0.521546,
		1,
	},
	[0.6] = {
		-0.24618,
		0.483034,
		-0.840282,
		0,
		-0.807965,
		0.376581,
		0.453188,
		0,
		0.535339,
		0.790484,
		0.297568,
		0,
		0.682034,
		-0.22285,
		-0.420133,
		1,
	},
	[0.716666666667] = {
		-0.672924,
		0.470452,
		-0.570831,
		0,
		-0.433494,
		0.374487,
		0.81966,
		0,
		0.59938,
		0.799021,
		-0.048063,
		0,
		0.470777,
		-0.239228,
		-0.548802,
		1,
	},
	[0.733333333333] = {
		-0.739879,
		0.452134,
		-0.498151,
		0,
		-0.326094,
		0.406641,
		0.853409,
		0,
		0.588424,
		0.793863,
		-0.153427,
		0,
		0.425147,
		-0.219288,
		-0.560394,
		1,
	},
	[0.75] = {
		-0.799624,
		0.434657,
		-0.414336,
		0,
		-0.21009,
		0.443887,
		0.871107,
		0,
		0.562551,
		0.783606,
		-0.263626,
		0,
		0.377601,
		-0.1963,
		-0.570274,
		1,
	},
	[0.766666666667] = {
		-0.848762,
		0.419681,
		-0.32167,
		0,
		-0.09042,
		0.484176,
		0.870286,
		0,
		0.520987,
		0.767751,
		-0.373003,
		0,
		0.329148,
		-0.171104,
		-0.578276,
		1,
	},
	[0.783333333333] = {
		-0.884903,
		0.408478,
		-0.223815,
		0,
		0.027267,
		0.525127,
		0.850587,
		0,
		0.464977,
		0.746584,
		-0.475824,
		0,
		0.280852,
		-0.144521,
		-0.584345,
		1,
	},
	[0.7] = {
		-0.602519,
		0.487813,
		-0.631672,
		0,
		-0.528717,
		0.348915,
		0.773768,
		0,
		0.597854,
		0.800185,
		0.047687,
		0,
		0.513568,
		-0.255251,
		-0.53573,
		1,
	},
	[0.816666666667] = {
		-0.916265,
		0.399412,
		-0.030467,
		0,
		0.236098,
		0.599926,
		0.764425,
		0,
		0.323599,
		0.693223,
		-0.643992,
		0,
		0.188985,
		-0.09048,
		-0.591123,
		1,
	},
	[0.833333333333] = {
		-0.914336,
		0.400964,
		0.056717,
		0,
		0.320318,
		0.630418,
		0.707085,
		0,
		0.24776,
		0.664681,
		-0.70485,
		0,
		0.147355,
		-0.064729,
		-0.592345,
		1,
	},
	[0.85] = {
		-0.90433,
		0.405384,
		0.13361,
		0,
		0.389344,
		0.655156,
		0.647442,
		0,
		0.174927,
		0.637521,
		-0.750311,
		0,
		0.109701,
		-0.041023,
		-0.592569,
		1,
	},
	[0.866666666667] = {
		-0.8895,
		0.411505,
		0.19863,
		0,
		0.443706,
		0.674023,
		0.590608,
		0,
		0.109158,
		0.613479,
		-0.78213,
		0,
		0.076761,
		-0.020308,
		-0.592122,
		1,
	},
	[0.883333333333] = {
		-0.87296,
		0.418172,
		0.251144,
		0,
		0.484839,
		0.687262,
		0.540927,
		0,
		0.053599,
		0.593972,
		-0.802698,
		0,
		0.049214,
		-0.003556,
		-0.5913,
		1,
	},
	[0.8] = {
		-0.907157,
		0.40172,
		-0.125244,
		0,
		0.137544,
		0.564373,
		0.813981,
		0,
		0.397677,
		0.721182,
		-0.567229,
		0,
		0.233788,
		-0.117367,
		-0.588558,
		1,
	},
	[0.916666666667] = {
		-0.844852,
		0.429259,
		0.319315,
		0,
		0.534624,
		0.699746,
		0.473849,
		0,
		-0.020036,
		0.571045,
		-0.820674,
		0,
		0.012212,
		0.015939,
		-0.589549,
		1,
	},
	[0.933333333333] = {
		-0.835921,
		0.432605,
		0.337769,
		0,
		0.547341,
		0.70265,
		0.454643,
		0,
		-0.040653,
		0.564921,
		-0.824143,
		0,
		0.001764,
		0.021153,
		-0.589019,
		1,
	},
	[0.95] = {
		-0.830582,
		0.434512,
		0.348327,
		0,
		0.554391,
		0.704392,
		0.443263,
		0,
		-0.052756,
		0.561276,
		-0.825946,
		0,
		-0.004338,
		0.024208,
		-0.588737,
		1,
	},
	[0.966666666667] = {
		-0.828496,
		0.435153,
		0.352473,
		0,
		0.557012,
		0.705255,
		0.438582,
		0,
		-0.057733,
		0.559695,
		-0.826685,
		0,
		-0.006769,
		0.025423,
		-0.588671,
		1,
	},
	[0.983333333333] = {
		-0.829148,
		0.434736,
		0.351451,
		0,
		0.556126,
		0.705426,
		0.439429,
		0,
		-0.056887,
		0.559803,
		-0.826671,
		0,
		-0.006187,
		0.025125,
		-0.588779,
		1,
	},
	[0.9] = {
		-0.857413,
		0.424368,
		0.291126,
		0,
		0.514519,
		0.695252,
		0.50189,
		0,
		0.01058,
		0.580117,
		-0.814464,
		0,
		0.02771,
		0.008256,
		-0.590352,
		1,
	},
	[1.01666666667] = {
		-0.836214,
		0.431662,
		0.338251,
		0,
		0.546739,
		0.704217,
		0.45294,
		0,
		-0.042685,
		0.56369,
		-0.824882,
		0,
		0.001431,
		0.021307,
		-0.589352,
		1,
	},
	[1.03333333333] = {
		-0.841339,
		0.429488,
		0.328159,
		0,
		0.539573,
		0.703063,
		0.46321,
		0,
		-0.031773,
		0.566782,
		-0.823255,
		0,
		0.007181,
		0.018445,
		-0.589732,
		1,
	},
	[1.05] = {
		-0.846694,
		0.427212,
		0.317173,
		0,
		0.531705,
		0.701711,
		0.474227,
		0,
		-0.019968,
		0.570168,
		-0.821285,
		0,
		0.013362,
		0.015385,
		-0.59012,
		1,
	},
	[1.06666666667] = {
		-0.85171,
		0.425065,
		0.306447,
		0,
		0.523944,
		0.700317,
		0.484809,
		0,
		-0.008535,
		0.573478,
		-0.819177,
		0,
		0.019322,
		0.012448,
		-0.59048,
		1,
	},
	[1.08333333333] = {
		-0.85587,
		0.423269,
		0.297203,
		0,
		0.51719,
		0.699063,
		0.493787,
		0,
		0.001241,
		0.576328,
		-0.817218,
		0,
		0.0244,
		0.009957,
		-0.590777,
		1,
	},
	{
		-0.831936,
		0.433492,
		0.346363,
		0,
		0.55248,
		0.705042,
		0.444614,
		0,
		-0.051464,
		0.561249,
		-0.826045,
		0,
		-0.00324,
		0.023643,
		-0.58902,
		1,
	},
	[1.11666666667] = {
		-0.85975,
		0.421581,
		0.28827,
		0,
		0.510605,
		0.697808,
		0.502341,
		0,
		0.01062,
		0.579079,
		-0.815202,
		0,
		0.02926,
		0.007581,
		-0.591053,
		1,
	},
	[1.13333333333] = {
		-0.85975,
		0.421581,
		0.28827,
		0,
		0.510605,
		0.697808,
		0.502341,
		0,
		0.01062,
		0.579079,
		-0.815202,
		0,
		0.02926,
		0.007581,
		-0.591053,
		1,
	},
	[1.1] = {
		-0.858702,
		0.422038,
		0.290715,
		0,
		0.512412,
		0.698156,
		0.500011,
		0,
		0.00806,
		0.578327,
		-0.815766,
		0,
		0.027934,
		0.008228,
		-0.590978,
		1,
	},
}

return spline_matrices
