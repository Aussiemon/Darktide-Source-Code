﻿-- chunkname: @content/characters/player/human/first_person/animations/axe/special_attack_stab.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.858244,
		0.399097,
		-0.322704,
		0,
		-0.473636,
		0.858071,
		-0.198451,
		0,
		0.197702,
		0.323164,
		0.925461,
		0,
		0.277139,
		0.461715,
		-0.248571,
		1
	},
	[0.0333333333333] = {
		0.88086,
		0.371088,
		-0.293905,
		0,
		-0.449156,
		0.851244,
		-0.27137,
		0,
		0.149483,
		0.371048,
		0.916503,
		0,
		0.279188,
		0.454693,
		-0.280597,
		1
	},
	[0.05] = {
		0.904641,
		0.345321,
		-0.249757,
		0,
		-0.415833,
		0.843544,
		-0.339877,
		0,
		0.093314,
		0.411324,
		0.9067,
		0,
		0.284117,
		0.444317,
		-0.320559,
		1
	},
	[0.0666666666667] = {
		0.930916,
		0.323045,
		-0.170403,
		0,
		-0.364944,
		0.841292,
		-0.398802,
		0,
		0.014527,
		0.433439,
		0.901066,
		0,
		0.29345,
		0.432325,
		-0.35995,
		1
	},
	[0.0833333333333] = {
		0.95331,
		0.30047,
		-0.030295,
		0,
		-0.282295,
		0.850992,
		-0.442857,
		0,
		-0.107284,
		0.430732,
		0.89608,
		0,
		0.31039,
		0.420569,
		-0.390427,
		1
	},
	[0] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[0.116666666667] = {
		0.910847,
		0.243143,
		0.333525,
		0,
		-0.069105,
		0.886499,
		-0.457542,
		0,
		-0.406918,
		0.393703,
		0.824267,
		0,
		0.359976,
		0.403661,
		-0.401771,
		1
	},
	[0.133333333333] = {
		0.857677,
		0.220423,
		0.464547,
		0,
		0.008194,
		0.897482,
		-0.440974,
		0,
		-0.514124,
		0.38202,
		0.767944,
		0,
		0.383107,
		0.401081,
		-0.393709,
		1
	},
	[0.15] = {
		0.811768,
		0.209244,
		0.545206,
		0,
		0.054138,
		0.902619,
		-0.427022,
		0,
		-0.581465,
		0.376159,
		0.721389,
		0,
		0.399601,
		0.40263,
		-0.380833,
		1
	},
	[0.166666666667] = {
		0.77226,
		0.204638,
		0.601446,
		0,
		0.082595,
		0.906328,
		-0.414424,
		0,
		-0.629914,
		0.369719,
		0.683019,
		0,
		0.406263,
		0.406874,
		-0.363985,
		1
	},
	[0.183333333333] = {
		0.73933,
		0.204677,
		0.641482,
		0,
		0.099024,
		0.909272,
		-0.40425,
		0,
		-0.666023,
		0.362396,
		0.651984,
		0,
		0.406611,
		0.413348,
		-0.344113,
		1
	},
	[0.1] = {
		0.949646,
		0.272924,
		0.153897,
		0,
		-0.174629,
		0.868849,
		-0.463257,
		0,
		-0.260147,
		0.413056,
		0.872759,
		0,
		0.334141,
		0.410585,
		-0.403635,
		1
	},
	[0.216666666667] = {
		0.683492,
		0.210903,
		0.698827,
		0,
		0.115089,
		0.914243,
		-0.388478,
		0,
		-0.720828,
		0.345949,
		0.600605,
		0,
		0.406521,
		0.431079,
		-0.298752,
		1
	},
	[0.233333333333] = {
		0.653145,
		0.213088,
		0.726632,
		0,
		0.123455,
		0.916785,
		-0.379821,
		0,
		-0.747101,
		0.337785,
		0.572487,
		0,
		0.406519,
		0.441356,
		-0.274909,
		1
	},
	[0.25] = {
		0.615051,
		0.211859,
		0.759492,
		0,
		0.137411,
		0.919687,
		-0.367823,
		0,
		-0.776421,
		0.330593,
		0.536543,
		0,
		0.406833,
		0.451912,
		-0.251349,
		1
	},
	[0.266666666667] = {
		0.563649,
		0.205072,
		0.800153,
		0,
		0.160442,
		0.923062,
		-0.349592,
		0,
		-0.810283,
		0.325425,
		0.487381,
		0,
		0.407672,
		0.462246,
		-0.228822,
		1
	},
	[0.283333333333] = {
		0.486275,
		0.186605,
		0.853648,
		0,
		0.202329,
		0.926336,
		-0.317749,
		0,
		-0.850058,
		0.327231,
		0.412699,
		0,
		0.408853,
		0.471882,
		-0.207919,
		1
	},
	[0.2] = {
		0.710855,
		0.207421,
		0.672058,
		0,
		0.108354,
		0.911822,
		-0.396029,
		0,
		-0.694942,
		0.354339,
		0.625699,
		0,
		0.406624,
		0.421579,
		-0.32209,
		1
	},
	[0.316666666667] = {
		0.336436,
		0.181861,
		0.923979,
		0,
		0.240739,
		0.931963,
		-0.271089,
		0,
		-0.910415,
		0.313642,
		0.269765,
		0,
		0.395226,
		0.494185,
		-0.173776,
		1
	},
	[0.333333333333] = {
		0.275549,
		0.206302,
		0.938889,
		0,
		0.231038,
		0.933858,
		-0.273002,
		0,
		-0.93311,
		0.292145,
		0.20966,
		0,
		0.388867,
		0.510034,
		-0.164813,
		1
	},
	[0.35] = {
		0.22231,
		0.21701,
		0.950518,
		0,
		0.218737,
		0.938961,
		-0.26553,
		0,
		-0.950122,
		0.266943,
		0.161272,
		0,
		0.389881,
		0.516735,
		-0.167584,
		1
	},
	[0.366666666667] = {
		0.179745,
		0.187534,
		0.965672,
		0,
		0.212186,
		0.951161,
		-0.224211,
		0,
		-0.960557,
		0.245203,
		0.131174,
		0,
		0.3969,
		0.519105,
		-0.176322,
		1
	},
	[0.383333333333] = {
		0.171093,
		0.050717,
		0.983949,
		0,
		0.226872,
		0.969809,
		-0.089437,
		0,
		-0.958778,
		0.238533,
		0.154421,
		0,
		0.392134,
		0.521727,
		-0.184765,
		1
	},
	[0.3] = {
		0.402724,
		0.170845,
		0.899236,
		0,
		0.236909,
		0.929493,
		-0.282694,
		0,
		-0.884131,
		0.326885,
		0.333855,
		0,
		0.404825,
		0.480065,
		-0.189695,
		1
	},
	[0.416666666667] = {
		0.034245,
		0.022715,
		0.999155,
		0,
		0.12988,
		0.991162,
		-0.026985,
		0,
		-0.990938,
		0.130695,
		0.030992,
		0,
		0.424216,
		0.528713,
		-0.172818,
		1
	},
	[0.433333333333] = {
		-0.09823,
		0.117604,
		0.98819,
		0,
		0.043107,
		0.992564,
		-0.113839,
		0,
		-0.99423,
		0.031415,
		-0.102569,
		0,
		0.443156,
		0.537576,
		-0.145078,
		1
	},
	[0.45] = {
		-0.162733,
		0.069981,
		0.984185,
		0,
		0.003334,
		0.997515,
		-0.070378,
		0,
		-0.986665,
		-0.008172,
		-0.162562,
		0,
		0.450884,
		0.527605,
		-0.122638,
		1
	},
	[0.466666666667] = {
		-0.199504,
		0.007021,
		0.979872,
		0,
		-0.024379,
		0.999629,
		-0.012126,
		0,
		-0.979594,
		-0.026307,
		-0.199259,
		0,
		0.453585,
		0.506405,
		-0.101478,
		1
	},
	[0.483333333333] = {
		-0.236662,
		0.000805,
		0.971592,
		0,
		-0.050197,
		0.998654,
		-0.013055,
		0,
		-0.970295,
		-0.051861,
		-0.236303,
		0,
		0.450776,
		0.497774,
		-0.08702,
		1
	},
	[0.4] = {
		0.14679,
		-0.063715,
		0.987114,
		0,
		0.219869,
		0.975061,
		0.030242,
		0,
		-0.964422,
		0.212596,
		0.157138,
		0,
		0.39549,
		0.526843,
		-0.188603,
		1
	},
	[0.516666666667] = {
		-0.309788,
		0.047232,
		0.949632,
		0,
		-0.089547,
		0.992877,
		-0.078595,
		0,
		-0.94658,
		-0.109385,
		-0.303352,
		0,
		0.443321,
		0.479114,
		-0.06625,
		1
	},
	[0.533333333333] = {
		-0.34279,
		0.0825,
		0.935783,
		0,
		-0.103096,
		0.986816,
		-0.124765,
		0,
		-0.933738,
		-0.139244,
		-0.329765,
		0,
		0.439215,
		0.470484,
		-0.058602,
		1
	},
	[0.55] = {
		-0.370943,
		0.114592,
		0.921558,
		0,
		-0.114008,
		0.979232,
		-0.167653,
		0,
		-0.921631,
		-0.167255,
		-0.350175,
		0,
		0.435159,
		0.463137,
		-0.051716,
		1
	},
	[0.566666666667] = {
		-0.392327,
		0.1356,
		0.909776,
		0,
		-0.124296,
		0.972187,
		-0.198503,
		0,
		-0.911389,
		-0.19096,
		-0.364561,
		0,
		0.431318,
		0.4577,
		-0.044685,
		1
	},
	[0.583333333333] = {
		-0.404995,
		0.13932,
		0.903642,
		0,
		-0.136349,
		0.968069,
		-0.210362,
		0,
		-0.904095,
		-0.208406,
		-0.373067,
		0,
		0.427815,
		0.454775,
		-0.037251,
		1
	},
	[0.5] = {
		-0.273843,
		0.017128,
		0.961622,
		0,
		-0.072059,
		0.996666,
		-0.038272,
		0,
		-0.959071,
		-0.079774,
		-0.271695,
		0,
		0.447261,
		0.488424,
		-0.075483,
		1
	},
	[0.616666666667] = {
		-0.381533,
		0.057726,
		0.922551,
		0,
		-0.171464,
		0.976307,
		-0.132,
		0,
		-0.908313,
		-0.208547,
		-0.362595,
		0,
		0.418001,
		0.455242,
		-0.018436,
		1
	},
	[0.633333333333] = {
		-0.329911,
		-0.039724,
		0.943176,
		0,
		-0.188288,
		0.981808,
		-0.02451,
		0,
		-0.925044,
		-0.185675,
		-0.331389,
		0,
		0.404483,
		0.454376,
		-0.005998,
		1
	},
	[0.65] = {
		-0.275648,
		-0.146506,
		0.950028,
		0,
		-0.202281,
		0.975028,
		0.09167,
		0,
		-0.939734,
		-0.166904,
		-0.2984,
		0,
		0.38591,
		0.456135,
		0.007369,
		1
	},
	[0.666666666667] = {
		-0.243832,
		-0.233496,
		0.941289,
		0,
		-0.221828,
		0.958281,
		0.180248,
		0,
		-0.944107,
		-0.164854,
		-0.285456,
		0,
		0.363867,
		0.464131,
		0.021484,
		1
	},
	[0.683333333333] = {
		-0.256964,
		-0.303675,
		0.91747,
		0,
		-0.293105,
		0.929122,
		0.225439,
		0,
		-0.920901,
		-0.210985,
		-0.327759,
		0,
		0.335694,
		0.534539,
		0.040122,
		1
	},
	[0.6] = {
		-0.4067,
		0.118985,
		0.90578,
		0,
		-0.152421,
		0.968747,
		-0.195695,
		0,
		-0.900757,
		-0.217649,
		-0.375854,
		0,
		0.424764,
		0.455005,
		-0.028954,
		1
	},
	[0.716666666667] = {
		-0.258855,
		-0.27204,
		0.926816,
		0,
		-0.104994,
		0.96176,
		0.252972,
		0,
		-0.960193,
		-0.031827,
		-0.277518,
		0,
		0.335698,
		0.698529,
		0.053172,
		1
	},
	[0.733333333333] = {
		-0.231756,
		-0.200904,
		0.951802,
		0,
		0.098303,
		0.968595,
		0.228384,
		0,
		-0.967794,
		0.146494,
		-0.204728,
		0,
		0.349569,
		0.724277,
		0.052719,
		1
	},
	[0.75] = {
		-0.27776,
		-0.188072,
		0.942061,
		0,
		0.042856,
		0.977246,
		0.207732,
		0,
		-0.959694,
		0.098073,
		-0.26338,
		0,
		0.350853,
		0.720131,
		0.065503,
		1
	},
	[0.766666666667] = {
		-0.331584,
		-0.193468,
		0.923375,
		0,
		-0.063168,
		0.981104,
		0.18288,
		0,
		-0.941309,
		0.002312,
		-0.337539,
		0,
		0.347041,
		0.723638,
		0.094308,
		1
	},
	[0.783333333333] = {
		-0.318143,
		-0.171451,
		0.932411,
		0,
		0.003541,
		0.983289,
		0.182015,
		0,
		-0.948036,
		0.061208,
		-0.312219,
		0,
		0.353992,
		0.72723,
		0.085152,
		1
	},
	[0.7] = {
		-0.275986,
		-0.335123,
		0.900847,
		0,
		-0.312847,
		0.917531,
		0.245485,
		0,
		-0.908823,
		-0.214077,
		-0.358068,
		0,
		0.318585,
		0.631944,
		0.054656,
		1
	},
	[0.816666666667] = {
		-0.261982,
		-0.126511,
		0.956745,
		0,
		0.02661,
		0.990047,
		0.138201,
		0,
		-0.964706,
		0.061665,
		-0.256008,
		0,
		0.367988,
		0.724965,
		0.073793,
		1
	},
	[0.833333333333] = {
		-0.229512,
		-0.108982,
		0.967185,
		0,
		0.037208,
		0.992003,
		0.120607,
		0,
		-0.972594,
		0.063667,
		-0.223622,
		0,
		0.376571,
		0.722553,
		0.070689,
		1
	},
	[0.85] = {
		-0.198195,
		-0.091835,
		0.975851,
		0,
		0.04308,
		0.993823,
		0.102276,
		0,
		-0.979215,
		0.06231,
		-0.193015,
		0,
		0.383583,
		0.720922,
		0.06336,
		1
	},
	[0.866666666667] = {
		-0.171556,
		-0.084224,
		0.981567,
		0,
		0.043873,
		0.994697,
		0.093019,
		0,
		-0.984197,
		0.059022,
		-0.166952,
		0,
		0.388802,
		0.719631,
		0.056399,
		1
	},
	[0.883333333333] = {
		-0.150071,
		-0.089226,
		0.984641,
		0,
		0.037387,
		0.994695,
		0.095835,
		0,
		-0.987968,
		0.051195,
		-0.145939,
		0,
		0.392365,
		0.719372,
		0.050453,
		1
	},
	[0.8] = {
		-0.29244,
		-0.146192,
		0.945043,
		0,
		0.014241,
		0.98747,
		0.157162,
		0,
		-0.956178,
		0.059419,
		-0.286693,
		0,
		0.359754,
		0.726992,
		0.076686,
		1
	},
	[0.916666666667] = {
		-0.114535,
		-0.1274,
		0.985216,
		0,
		0.006369,
		0.991628,
		0.12897,
		0,
		-0.993399,
		0.021046,
		-0.112764,
		0,
		0.397373,
		0.721952,
		0.040795,
		1
	},
	[0.933333333333] = {
		-0.098532,
		-0.153747,
		0.983185,
		0,
		-0.013145,
		0.988108,
		0.153199,
		0,
		-0.995047,
		0.002171,
		-0.099381,
		0,
		0.399183,
		0.723851,
		0.036105,
		1
	},
	[0.95] = {
		-0.082549,
		-0.180615,
		0.980084,
		0,
		-0.032363,
		0.983407,
		0.178502,
		0,
		-0.996061,
		-0.016983,
		-0.087024,
		0,
		0.40069,
		0.725594,
		0.030806,
		1
	},
	[0.966666666667] = {
		-0.06593,
		-0.204993,
		0.97654,
		0,
		-0.049252,
		0.978145,
		0.202004,
		0,
		-0.996608,
		-0.034779,
		-0.074586,
		0,
		0.402022,
		0.726809,
		0.024335,
		1
	},
	[0.983333333333] = {
		-0.048185,
		-0.224038,
		0.973388,
		0,
		-0.061798,
		0.973322,
		0.220964,
		0,
		-0.996925,
		-0.049506,
		-0.060744,
		0,
		0.403408,
		0.727107,
		0.016097,
		1
	},
	[0.9] = {
		-0.131392,
		-0.104772,
		0.985778,
		0,
		0.024022,
		0.993771,
		0.108823,
		0,
		-0.991039,
		0.037979,
		-0.128057,
		0,
		0.39516,
		0.720302,
		0.04541,
		1
	},
	[1.01666666667] = {
		-0.007397,
		-0.235191,
		0.971921,
		0,
		-0.066311,
		0.969924,
		0.234203,
		0,
		-0.997772,
		-0.062716,
		-0.02277,
		0,
		0.407204,
		0.723429,
		-0.00819,
		1
	},
	[1.03333333333] = {
		0.017133,
		-0.221524,
		0.975004,
		0,
		-0.054562,
		0.973487,
		0.222138,
		0,
		-0.998363,
		-0.057004,
		0.004592,
		0,
		0.409979,
		0.718559,
		-0.025583,
		1
	},
	[1.05] = {
		0.0453,
		-0.195235,
		0.97971,
		0,
		-0.033922,
		0.97985,
		0.196832,
		0,
		-0.998397,
		-0.04215,
		0.037764,
		0,
		0.413309,
		0.711276,
		-0.04677,
		1
	},
	[1.06666666667] = {
		0.077223,
		-0.160032,
		0.984087,
		0,
		-0.007185,
		0.986919,
		0.161056,
		0,
		-0.996988,
		-0.019508,
		0.075063,
		0,
		0.416926,
		0.701717,
		-0.07112,
		1
	},
	[1.08333333333] = {
		0.113658,
		-0.11645,
		0.986672,
		0,
		0.024868,
		0.99313,
		0.114347,
		0,
		-0.993209,
		0.01154,
		0.115773,
		0,
		0.420625,
		0.689789,
		-0.098238,
		1
	},
	{
		-0.028862,
		-0.235025,
		0.971561,
		0,
		-0.0681,
		0.97017,
		0.232666,
		0,
		-0.997261,
		-0.059448,
		-0.044006,
		0,
		0.405068,
		0.726113,
		0.005473,
		1
	},
	[1.11666666667] = {
		0.203026,
		-0.007159,
		0.979147,
		0,
		0.100475,
		0.994847,
		-0.013559,
		0,
		-0.974005,
		0.101132,
		0.202699,
		0,
		0.427207,
		0.658338,
		-0.159116,
		1
	},
	[1.13333333333] = {
		0.257047,
		0.05609,
		0.96477,
		0,
		0.14086,
		0.985478,
		-0.094824,
		0,
		-0.956078,
		0.160272,
		0.245413,
		0,
		0.429448,
		0.638589,
		-0.191894,
		1
	},
	[1.15] = {
		0.317432,
		0.122419,
		0.940346,
		0,
		0.180131,
		0.965793,
		-0.186539,
		0,
		-0.931016,
		0.228599,
		0.284522,
		0,
		0.430524,
		0.616114,
		-0.225363,
		1
	},
	[1.16666666667] = {
		0.383593,
		0.188998,
		0.903956,
		0,
		0.215697,
		0.933426,
		-0.286691,
		0,
		-0.897959,
		0.304953,
		0.317289,
		0,
		0.430107,
		0.59104,
		-0.258715,
		1
	},
	[1.18333333333] = {
		0.454243,
		0.252458,
		0.854359,
		0,
		0.244828,
		0.886707,
		-0.392186,
		0,
		-0.856576,
		0.387319,
		0.340971,
		0,
		0.426498,
		0.564294,
		-0.29046,
		1
	},
	[1.1] = {
		0.15537,
		-0.065172,
		0.985704,
		0,
		0.061212,
		0.996539,
		0.05624,
		0,
		-0.985958,
		0.051599,
		0.158821,
		0,
		0.424152,
		0.675372,
		-0.127713,
		1
	},
	[1.21666666667] = {
		0.600496,
		0.356003,
		0.716007,
		0,
		0.274146,
		0.749499,
		-0.602574,
		0,
		-0.751165,
		0.558134,
		0.352474,
		0,
		0.407484,
		0.511988,
		-0.344061,
		1
	},
	[1.23333333333] = {
		0.67073,
		0.390386,
		0.63065,
		0,
		0.271209,
		0.662304,
		-0.698426,
		0,
		-0.690338,
		0.639494,
		0.338351,
		0,
		0.393945,
		0.489073,
		-0.365187,
		1
	},
	[1.25] = {
		0.735522,
		0.411023,
		0.538579,
		0,
		0.256338,
		0.567021,
		-0.782802,
		0,
		-0.627135,
		0.713826,
		0.311695,
		0,
		0.379189,
		0.469674,
		-0.382754,
		1
	},
	[1.26666666667] = {
		0.792858,
		0.417878,
		0.443569,
		0,
		0.230771,
		0.467786,
		-0.853183,
		0,
		-0.564022,
		0.778816,
		0.274454,
		0,
		0.364263,
		0.454315,
		-0.397344,
		1
	},
	[1.28333333333] = {
		0.841518,
		0.41202,
		0.34941,
		0,
		0.196553,
		0.368943,
		-0.908432,
		0,
		-0.503205,
		0.833139,
		0.229488,
		0,
		0.350014,
		0.443169,
		-0.409577,
		1
	},
	[1.2] = {
		0.527398,
		0.309213,
		0.791353,
		0,
		0.264991,
		0.825093,
		-0.499,
		0,
		-0.807237,
		0.472873,
		0.353213,
		0,
		0.418673,
		0.537486,
		-0.319104,
		1
	},
	[1.31666666667] = {
		0.911979,
		0.370661,
		0.175799,
		0,
		0.112081,
		0.187104,
		-0.975925,
		0,
		-0.39463,
		0.909727,
		0.129091,
		0,
		0.32565,
		0.43246,
		-0.429147,
		1
	},
	[1.33333333333] = {
		0.934957,
		0.340318,
		0.100194,
		0,
		0.066613,
		0.108993,
		-0.991808,
		0,
		-0.34845,
		0.933972,
		0.079234,
		0,
		0.315972,
		0.431712,
		-0.437199,
		1
	},
	[1.35] = {
		0.951189,
		0.306814,
		0.033246,
		0,
		0.02163,
		0.041186,
		-0.998917,
		0,
		-0.307851,
		0.950878,
		0.032539,
		0,
		0.307947,
		0.433108,
		-0.444161,
		1
	},
	[1.36666666667] = {
		0.961916,
		0.272204,
		-0.024946,
		0,
		-0.021431,
		-0.01588,
		-0.999644,
		0,
		-0.272503,
		0.962108,
		-0.009442,
		0,
		0.301424,
		0.435982,
		-0.449802,
		1
	},
	[1.38333333333] = {
		0.968355,
		0.238137,
		-0.074689,
		0,
		-0.061535,
		-0.062213,
		-0.996164,
		0,
		-0.24187,
		0.969237,
		-0.04559,
		0,
		0.296206,
		0.439747,
		-0.453725,
		1
	},
	[1.3] = {
		0.881114,
		0.395434,
		0.259365,
		0,
		0.156152,
		0.274409,
		-0.94885,
		0,
		-0.44638,
		0.876545,
		0.180038,
		0,
		0.337033,
		0.436057,
		-0.420018,
		1
	},
	[1.41666666667] = {
		0.972848,
		0.175314,
		-0.151101,
		0,
		-0.130194,
		-0.125241,
		-0.983547,
		0,
		-0.191354,
		0.976514,
		-0.099016,
		0,
		0.289,
		0.447478,
		-0.45577,
		1
	},
	[1.43333333333] = {
		0.972838,
		0.145897,
		-0.179724,
		0,
		-0.158516,
		-0.145937,
		-0.976512,
		0,
		-0.168698,
		0.978477,
		-0.118846,
		0,
		0.286916,
		0.449445,
		-0.455828,
		1
	},
	[1.45] = {
		0.971911,
		0.117951,
		-0.203658,
		0,
		-0.183694,
		-0.160769,
		-0.969747,
		0,
		-0.147125,
		0.979919,
		-0.134586,
		0,
		0.285634,
		0.449358,
		-0.455376,
		1
	},
	[1.46666666667] = {
		0.970259,
		0.091761,
		-0.224003,
		0,
		-0.206365,
		-0.170162,
		-0.963565,
		0,
		-0.126535,
		0.981134,
		-0.146165,
		0,
		0.284952,
		0.446797,
		-0.454218,
		1
	},
	[1.48333333333] = {
		0.967987,
		0.067609,
		-0.241722,
		0,
		-0.227082,
		-0.174378,
		-0.958137,
		0,
		-0.10693,
		0.982355,
		-0.153443,
		0,
		0.28449,
		0.443155,
		-0.452434,
		1
	},
	[1.4] = {
		0.971616,
		0.205881,
		-0.11651,
		0,
		-0.097978,
		-0.098055,
		-0.990346,
		0,
		-0.215318,
		0.973652,
		-0.0751,
		0,
		0.292081,
		0.443906,
		-0.455427,
		1
	},
	[1.51666666667] = {
		0.961751,
		0.026813,
		-0.27261,
		0,
		-0.264514,
		-0.167725,
		-0.949685,
		0,
		-0.071187,
		0.985469,
		-0.154217,
		0,
		0.283431,
		0.437582,
		-0.447604,
		1
	},
	[1.53333333333] = {
		0.95781,
		0.011155,
		-0.287186,
		0,
		-0.281971,
		-0.156879,
		-0.94651,
		0,
		-0.055612,
		0.987555,
		-0.147114,
		0,
		0.282858,
		0.435546,
		-0.444561,
		1
	},
	[1.55] = {
		0.953298,
		-0.000683,
		-0.302031,
		0,
		-0.299106,
		-0.140993,
		-0.943746,
		0,
		-0.041939,
		0.99001,
		-0.134613,
		0,
		0.282227,
		0.433997,
		-0.441098,
		1
	},
	[1.56666666667] = {
		0.948165,
		-0.008162,
		-0.317674,
		0,
		-0.316315,
		-0.120072,
		-0.941025,
		0,
		-0.030463,
		0.992732,
		-0.11643,
		0,
		0.281504,
		0.432934,
		-0.437211,
		1
	},
	[1.58333333333] = {
		0.942525,
		-0.01142,
		-0.333941,
		0,
		-0.3335,
		-0.093764,
		-0.938076,
		0,
		-0.020599,
		0.995529,
		-0.092183,
		0,
		0.280704,
		0.432382,
		-0.432897,
		1
	},
	[1.5] = {
		0.965145,
		0.045806,
		-0.257677,
		0,
		-0.246337,
		-0.173553,
		-0.953519,
		0,
		-0.088397,
		0.983759,
		-0.15622,
		0,
		0.28398,
		0.440101,
		-0.450227,
		1
	},
	[1.61666666667] = {
		0.930366,
		-0.006984,
		-0.366565,
		0,
		-0.366622,
		-0.024944,
		-0.930036,
		0,
		-0.002648,
		0.999664,
		-0.025767,
		0,
		0.279003,
		0.432781,
		-0.423002,
		1
	},
	[1.63333333333] = {
		0.923936,
		0.000542,
		-0.382547,
		0,
		-0.382502,
		0.016772,
		-0.923803,
		0,
		0.005916,
		0.999859,
		0.015703,
		0,
		0.278138,
		0.433643,
		-0.417408,
		1
	},
	[1.65] = {
		0.917328,
		0.011471,
		-0.397967,
		0,
		-0.39787,
		0.062727,
		-0.915295,
		0,
		0.014464,
		0.997965,
		0.062105,
		0,
		0.277281,
		0.434883,
		-0.411376,
		1
	},
	[1.66666666667] = {
		0.910587,
		0.02566,
		-0.41252,
		0,
		-0.412668,
		0.112348,
		-0.903926,
		0,
		0.023151,
		0.993338,
		0.112892,
		0,
		0.276443,
		0.43645,
		-0.404902,
		1
	},
	[1.68333333333] = {
		0.903763,
		0.042906,
		-0.425877,
		0,
		-0.426827,
		0.164966,
		-0.88916,
		0,
		0.032105,
		0.985365,
		0.167404,
		0,
		0.275634,
		0.438284,
		-0.397988,
		1
	},
	[1.6] = {
		0.936576,
		-0.011004,
		-0.35029,
		0,
		-0.350278,
		-0.061928,
		-0.934597,
		0,
		-0.011409,
		0.99802,
		-0.061854,
		0,
		0.279866,
		0.432344,
		-0.428163,
		1
	},
	[1.71666666667] = {
		0.890096,
		0.085443,
		-0.447692,
		0,
		-0.452893,
		0.276056,
		-0.84775,
		0,
		0.051154,
		0.957336,
		0.284413,
		0,
		0.274146,
		0.442498,
		-0.382889,
		1
	},
	[1.73333333333] = {
		0.883381,
		0.109996,
		-0.455565,
		0,
		-0.464625,
		0.332772,
		-0.820601,
		0,
		0.061337,
		0.93657,
		0.345071,
		0,
		0.273488,
		0.444744,
		-0.374755,
		1
	},
	[1.75] = {
		0.876835,
		0.136141,
		-0.461113,
		0,
		-0.475375,
		0.389027,
		-0.789098,
		0,
		0.071957,
		0.911111,
		0.405831,
		0,
		0.272899,
		0.446991,
		-0.366283,
		1
	},
	[1.76666666667] = {
		0.870529,
		0.163369,
		-0.46421,
		0,
		-0.485072,
		0.443898,
		-0.753432,
		0,
		0.082974,
		0.881059,
		0.465671,
		0,
		0.272386,
		0.449179,
		-0.357528,
		1
	},
	[1.78333333333] = {
		0.864525,
		0.191145,
		-0.464823,
		0,
		-0.493661,
		0.496516,
		-0.713982,
		0,
		0.094318,
		0.846721,
		0.523611,
		0,
		0.271956,
		0.451251,
		-0.348556,
		1
	},
	[1.7] = {
		0.896912,
		0.062945,
		-0.437705,
		0,
		-0.440264,
		0.219818,
		-0.870544,
		0,
		0.041419,
		0.973508,
		0.22487,
		0,
		0.274865,
		0.440322,
		-0.390644,
		1
	},
	[1.81666666667] = {
		0.853647,
		0.246218,
		-0.45898,
		0,
		-0.507404,
		0.592066,
		-0.626098,
		0,
		0.11759,
		0.767355,
		0.630348,
		0,
		0.271361,
		0.454877,
		-0.330267,
		1
	},
	[1.83333333333] = {
		0.84886,
		0.272528,
		-0.452952,
		0,
		-0.512563,
		0.633907,
		-0.579173,
		0,
		0.129289,
		0.723803,
		0.677786,
		0,
		0.271201,
		0.456375,
		-0.321113,
		1
	},
	[1.85] = {
		0.844538,
		0.297454,
		-0.445283,
		0,
		-0.516633,
		0.671349,
		-0.531395,
		0,
		0.140875,
		0.678831,
		0.720654,
		0,
		0.27113,
		0.457647,
		-0.312068,
		1
	},
	[1.86666666667] = {
		0.840686,
		0.320659,
		-0.436377,
		0,
		-0.519682,
		0.704281,
		-0.483652,
		0,
		0.152245,
		0.633377,
		0.75872,
		0,
		0.271147,
		0.458696,
		-0.303214,
		1
	},
	[1.88333333333] = {
		0.837295,
		0.341886,
		-0.426675,
		0,
		-0.521793,
		0.732754,
		-0.436811,
		0,
		0.163309,
		0.588376,
		0.791925,
		0,
		0.271246,
		0.459535,
		-0.294632,
		1
	},
	[1.8] = {
		0.858881,
		0.218933,
		-0.463025,
		0,
		-0.501109,
		0.546115,
		-0.671304,
		0,
		0.105894,
		0.808596,
		0.578757,
		0,
		0.271613,
		0.453162,
		-0.339443,
		1
	},
	[1.91666666667] = {
		0.8318,
		0.377724,
		-0.406736,
		0,
		-0.523605,
		0.777165,
		-0.349074,
		0,
		0.184247,
		0.503329,
		0.844223,
		0,
		0.271668,
		0.460663,
		-0.278592,
		1
	},
	[1.93333333333] = {
		0.829613,
		0.392144,
		-0.397449,
		0,
		-0.523542,
		0.793726,
		-0.309681,
		0,
		0.194026,
		0.464997,
		0.863789,
		0,
		0.271966,
		0.460989,
		-0.27131,
		1
	},
	[1.95] = {
		0.827732,
		0.404194,
		-0.389214,
		0,
		-0.522992,
		0.807056,
		-0.274117,
		0,
		0.203321,
		0.430451,
		0.879416,
		0,
		0.272307,
		0.461198,
		-0.264611,
		1
	},
	[1.96666666667] = {
		0.826101,
		0.413879,
		-0.382441,
		0,
		-0.522067,
		0.817581,
		-0.242915,
		0,
		0.212139,
		0.400332,
		0.891477,
		0,
		0.272682,
		0.461319,
		-0.258554,
		1
	},
	[1.98333333333] = {
		0.824924,
		0.421138,
		-0.377019,
		0,
		-0.520735,
		0.82565,
		-0.217111,
		0,
		0.219852,
		0.375427,
		0.9004,
		0,
		0.273074,
		0.461422,
		-0.253303,
		1
	},
	[1.9] = {
		0.834345,
		0.360949,
		-0.416635,
		0,
		-0.523063,
		0.756957,
		-0.39169,
		0,
		0.173995,
		0.544731,
		0.820362,
		0,
		0.271423,
		0.460185,
		-0.286396,
		1
	},
	[2.01666666667] = {
		0.824277,
		0.42942,
		-0.369006,
		0,
		-0.517014,
		0.836535,
		-0.1814,
		0,
		0.23079,
		0.340305,
		0.911553,
		0,
		0.273852,
		0.461755,
		-0.245314,
		1
	},
	[2.03333333333] = {
		0.82459,
		0.43118,
		-0.366244,
		0,
		-0.51484,
		0.840286,
		-0.169879,
		0,
		0.234501,
		0.328638,
		0.914881,
		0,
		0.274227,
		0.461989,
		-0.242387,
		1
	},
	[2.05] = {
		0.825202,
		0.431788,
		-0.364145,
		0,
		-0.512548,
		0.84333,
		-0.161518,
		0,
		0.237353,
		0.319926,
		0.91723,
		0,
		0.274587,
		0.462259,
		-0.240052,
		1
	},
	[2.06666666667] = {
		0.826028,
		0.431542,
		-0.362559,
		0,
		-0.510181,
		0.845888,
		-0.155528,
		0,
		0.239567,
		0.313441,
		0.918892,
		0,
		0.274931,
		0.462552,
		-0.238221,
		1
	},
	[2.08333333333] = {
		0.82699,
		0.43073,
		-0.361331,
		0,
		-0.507772,
		0.848133,
		-0.151125,
		0,
		0.241363,
		0.308452,
		0.920109,
		0,
		0.275256,
		0.462852,
		-0.236806,
		1
	},
	{
		0.824355,
		0.426189,
		-0.372562,
		0,
		-0.519008,
		0.831788,
		-0.196876,
		0,
		0.225987,
		0.355658,
		0.906883,
		0,
		0.273467,
		0.461565,
		-0.248922,
		1
	},
	[2.11666666667] = {
		0.829013,
		0.428535,
		-0.359299,
		0,
		-0.502931,
		0.852259,
		-0.143927,
		0,
		0.244538,
		0.30002,
		0.922057,
		0,
		0.275846,
		0.4634,
		-0.234881,
		1
	},
	[2.13333333333] = {
		0.829924,
		0.427716,
		-0.358169,
		0,
		-0.500548,
		0.854388,
		-0.139547,
		0,
		0.246328,
		0.295094,
		0.92317,
		0,
		0.276108,
		0.463608,
		-0.234197,
		1
	},
	[2.15] = {
		0.830672,
		0.427456,
		-0.356742,
		0,
		-0.498218,
		0.8567,
		-0.13358,
		0,
		0.248521,
		0.288696,
		0.924604,
		0,
		0.276346,
		0.463745,
		-0.233585,
		1
	},
	[2.16666666667] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.18333333333] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.1] = {
		0.82801,
		0.429633,
		-0.360299,
		0,
		-0.505346,
		0.850213,
		-0.147522,
		0,
		0.24295,
		0.304225,
		0.921098,
		0,
		0.275562,
		0.463141,
		-0.235721,
		1
	},
	[2.21666666667] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.23333333333] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.25] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.26666666667] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.28333333333] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.2] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.31666666667] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.33333333333] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	},
	[2.3] = {
		0.831186,
		0.428032,
		-0.354849,
		0,
		-0.495956,
		0.85927,
		-0.125227,
		0,
		0.25131,
		0.280076,
		0.926499,
		0,
		0.276558,
		0.463788,
		-0.232959,
		1
	}
}

return spline_matrices
