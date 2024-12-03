﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_force_sword/attack_left_diagonal_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.209368,
		0.201703,
		-0.956808,
		0,
		0.564623,
		0.823826,
		0.050119,
		0,
		0.798352,
		-0.529742,
		-0.286369,
		0,
		0.467822,
		0.001138,
		-0.26677,
		1,
	},
	[0.0333333333333] = {
		0.175802,
		0.267506,
		-0.947383,
		0,
		0.651216,
		0.690107,
		0.315704,
		0,
		0.738249,
		-0.672452,
		-0.052882,
		0,
		0.410739,
		0.041089,
		-0.214922,
		1,
	},
	[0.05] = {
		0.513382,
		0.337835,
		-0.788864,
		0,
		0.567402,
		0.556014,
		0.607374,
		0,
		0.643812,
		-0.759418,
		0.09376,
		0,
		0.344117,
		0.088517,
		-0.165606,
		1,
	},
	[0.0666666666667] = {
		0.626248,
		0.407876,
		-0.664417,
		0,
		0.467638,
		0.48537,
		0.738736,
		0,
		0.623801,
		-0.773339,
		0.113224,
		0,
		0.291215,
		0.127791,
		-0.127206,
		1,
	},
	[0.0833333333333] = {
		0.583277,
		0.492451,
		-0.645972,
		0,
		0.444194,
		0.47244,
		0.761243,
		0,
		0.680059,
		-0.730953,
		0.056819,
		0,
		0.258976,
		0.151076,
		-0.104459,
		1,
	},
	[0] = {
		-0.395327,
		0.147184,
		-0.906672,
		0,
		0.406718,
		0.91309,
		-0.029112,
		0,
		0.823588,
		-0.380268,
		-0.420831,
		0,
		0.492033,
		-0.015673,
		-0.312918,
		1,
	},
	[0.116666666667] = {
		0.429381,
		0.656999,
		-0.619665,
		0,
		0.377174,
		0.49298,
		0.784035,
		0,
		0.820592,
		-0.570371,
		-0.036126,
		0,
		0.21224,
		0.189114,
		-0.083828,
		1,
	},
	[0.133333333333] = {
		0.369625,
		0.685914,
		-0.626817,
		0,
		0.31067,
		0.54454,
		0.779077,
		0,
		0.875706,
		-0.482699,
		-0.011818,
		0,
		0.185414,
		0.224929,
		-0.072983,
		1,
	},
	[0.15] = {
		0.333682,
		0.57606,
		-0.746198,
		0,
		0.17546,
		0.739781,
		0.649567,
		0,
		0.926213,
		-0.347677,
		0.145776,
		0,
		0.154148,
		0.294304,
		-0.05408,
		1,
	},
	[0.166666666667] = {
		0.311396,
		0.361962,
		-0.878645,
		0,
		-0.05239,
		0.929749,
		0.364447,
		0,
		0.948835,
		-0.067455,
		0.308483,
		0,
		0.121366,
		0.386376,
		-0.031912,
		1,
	},
	[0.183333333333] = {
		0.410762,
		0.108333,
		-0.905283,
		0,
		-0.265022,
		0.96423,
		-0.004863,
		0,
		0.872375,
		0.241917,
		0.42478,
		0,
		0.085289,
		0.467063,
		-0.015459,
		1,
	},
	[0.1] = {
		0.509034,
		0.585186,
		-0.631222,
		0,
		0.417474,
		0.473464,
		0.775595,
		0,
		0.752729,
		-0.658323,
		-0.003291,
		0,
		0.234723,
		0.168004,
		-0.092147,
		1,
	},
	[0.216666666667] = {
		0.551583,
		-0.054356,
		-0.832347,
		0,
		-0.616418,
		0.645706,
		-0.450658,
		0,
		0.561948,
		0.761649,
		0.322655,
		0,
		-0.011931,
		0.503029,
		-0.035149,
		1,
	},
	[0.233333333333] = {
		0.569466,
		-0.045743,
		-0.820741,
		0,
		-0.748376,
		0.384201,
		-0.540669,
		0,
		0.340061,
		0.922116,
		0.184556,
		0,
		-0.075354,
		0.500069,
		-0.07018,
		1,
	},
	[0.25] = {
		0.597569,
		-0.019575,
		-0.801579,
		0,
		-0.793773,
		0.126813,
		-0.594847,
		0,
		0.113295,
		0.991733,
		0.060241,
		0,
		-0.128649,
		0.487041,
		-0.103764,
		1,
	},
	[0.266666666667] = {
		0.652003,
		0.032654,
		-0.757513,
		0,
		-0.754988,
		-0.064143,
		-0.652594,
		0,
		-0.069899,
		0.997406,
		-0.017167,
		0,
		-0.155299,
		0.457478,
		-0.123735,
		1,
	},
	[0.283333333333] = {
		0.701089,
		0.102124,
		-0.705723,
		0,
		-0.680781,
		-0.198601,
		-0.70505,
		0,
		-0.21216,
		0.974745,
		-0.069713,
		0,
		-0.166367,
		0.415584,
		-0.137314,
		1,
	},
	[0.2] = {
		0.516862,
		-0.053911,
		-0.85437,
		0,
		-0.426698,
		0.848981,
		-0.311706,
		0,
		0.742148,
		0.525667,
		0.415802,
		0,
		0.043862,
		0.502231,
		-0.013849,
		1,
	},
	[0.316666666667] = {
		0.688396,
		0.23617,
		-0.68581,
		0,
		-0.547033,
		-0.451841,
		-0.704695,
		0,
		-0.476304,
		0.86027,
		-0.181853,
		0,
		-0.216049,
		0.317902,
		-0.209218,
		1,
	},
	[0.333333333333] = {
		0.644978,
		0.299546,
		-0.703048,
		0,
		-0.473905,
		-0.564943,
		-0.675465,
		0,
		-0.599514,
		0.768838,
		-0.222419,
		0,
		-0.255712,
		0.261384,
		-0.269191,
		1,
	},
	[0.35] = {
		0.618277,
		0.344557,
		-0.706409,
		0,
		-0.404426,
		-0.631196,
		-0.66184,
		0,
		-0.673924,
		0.69489,
		-0.250906,
		0,
		-0.28479,
		0.209348,
		-0.308831,
		1,
	},
	[0.366666666667] = {
		0.617376,
		0.371785,
		-0.69327,
		0,
		-0.348754,
		-0.660584,
		-0.664831,
		0,
		-0.705137,
		0.652231,
		-0.278167,
		0,
		-0.30132,
		0.157565,
		-0.322174,
		1,
	},
	[0.383333333333] = {
		0.624416,
		0.392172,
		-0.675504,
		0,
		-0.302051,
		-0.676306,
		-0.671844,
		0,
		-0.720326,
		0.623547,
		-0.303841,
		0,
		-0.314278,
		0.101434,
		-0.327413,
		1,
	},
	[0.3] = {
		0.715263,
		0.170595,
		-0.677714,
		0,
		-0.61034,
		-0.319885,
		-0.724678,
		0,
		-0.340417,
		0.931971,
		-0.124681,
		0,
		-0.182607,
		0.369266,
		-0.160242,
		1,
	},
	[0.416666666667] = {
		0.643511,
		0.414165,
		-0.643709,
		0,
		-0.245379,
		-0.684964,
		-0.686013,
		0,
		-0.72504,
		0.599409,
		-0.339155,
		0,
		-0.329561,
		0.01272,
		-0.332182,
		1,
	},
	[0.433333333333] = {
		0.647283,
		0.416821,
		-0.638189,
		0,
		-0.238211,
		-0.684696,
		-0.688801,
		0,
		-0.724072,
		0.597873,
		-0.3439,
		0,
		-0.331631,
		-0.001628,
		-0.341194,
		1,
	},
	[0.45] = {
		0.647763,
		0.410637,
		-0.641701,
		0,
		-0.249013,
		-0.681917,
		-0.687737,
		0,
		-0.719997,
		0.605283,
		-0.339467,
		0,
		-0.327841,
		0.005394,
		-0.358034,
		1,
	},
	[0.466666666667] = {
		0.648785,
		0.393797,
		-0.651154,
		0,
		-0.277064,
		-0.674714,
		-0.684103,
		0,
		-0.70874,
		0.624247,
		-0.328638,
		0,
		-0.317876,
		0.023615,
		-0.379637,
		1,
	},
	[0.483333333333] = {
		0.649664,
		0.369643,
		-0.664305,
		0,
		-0.315981,
		-0.663476,
		-0.6782,
		0,
		-0.691442,
		0.65051,
		-0.314236,
		0,
		-0.303793,
		0.049319,
		-0.403822,
		1,
	},
	[0.4] = {
		0.634608,
		0.406168,
		-0.657495,
		0,
		-0.266952,
		-0.683187,
		-0.6797,
		0,
		-0.725264,
		0.606863,
		-0.325129,
		0,
		-0.323683,
		0.050102,
		-0.329211,
		1,
	},
	[0.516666666667] = {
		0.649215,
		0.313203,
		-0.693126,
		0,
		-0.401739,
		-0.632597,
		-0.662139,
		0,
		-0.645853,
		0.708326,
		-0.284865,
		0,
		-0.271492,
		0.108284,
		-0.451255,
		1,
	},
	[0.533333333333] = {
		0.647957,
		0.288198,
		-0.705049,
		0,
		-0.437545,
		-0.616846,
		-0.654259,
		0,
		-0.623463,
		0.732422,
		-0.27359,
		0,
		-0.257394,
		0.134094,
		-0.470183,
		1,
	},
	[0.55] = {
		0.646676,
		0.270391,
		-0.713231,
		0,
		-0.462357,
		-0.604739,
		-0.648473,
		0,
		-0.60666,
		0.749119,
		-0.266053,
		0,
		-0.247421,
		0.152485,
		-0.483049,
		1,
	},
	[0.566666666667] = {
		0.646095,
		0.263619,
		-0.716287,
		0,
		-0.471949,
		-0.599567,
		-0.646362,
		0,
		-0.599855,
		0.755662,
		-0.262963,
		0,
		-0.243649,
		0.159732,
		-0.48771,
		1,
	},
	[0.583333333333] = {
		0.646082,
		0.263611,
		-0.716301,
		0,
		-0.472496,
		-0.598899,
		-0.646581,
		0,
		-0.599438,
		0.756194,
		-0.262383,
		0,
		-0.243671,
		0.160164,
		-0.487558,
		1,
	},
	[0.5] = {
		0.649865,
		0.34159,
		-0.678964,
		0,
		-0.359487,
		-0.648934,
		-0.670562,
		0,
		-0.66966,
		0.679853,
		-0.298922,
		0,
		-0.287645,
		0.078783,
		-0.428416,
		1,
	},
	[0.616666666667] = {
		0.646081,
		0.263482,
		-0.716349,
		0,
		-0.473639,
		-0.597572,
		-0.646973,
		0,
		-0.598536,
		0.757288,
		-0.261284,
		0,
		-0.243697,
		0.16101,
		-0.487266,
		1,
	},
	[0.633333333333] = {
		0.646097,
		0.263362,
		-0.716379,
		0,
		-0.474219,
		-0.596927,
		-0.647143,
		0,
		-0.598059,
		0.757838,
		-0.260782,
		0,
		-0.243699,
		0.161415,
		-0.487132,
		1,
	},
	[0.65] = {
		0.646126,
		0.263204,
		-0.716411,
		0,
		-0.474796,
		-0.596305,
		-0.647294,
		0,
		-0.597569,
		0.758383,
		-0.26032,
		0,
		-0.243691,
		0.161801,
		-0.487007,
		1,
	},
	[0.666666666667] = {
		0.646171,
		0.263008,
		-0.716443,
		0,
		-0.475362,
		-0.595712,
		-0.647424,
		0,
		-0.597072,
		0.758916,
		-0.259908,
		0,
		-0.243673,
		0.162164,
		-0.486895,
		1,
	},
	[0.683333333333] = {
		0.646232,
		0.262775,
		-0.716473,
		0,
		-0.475909,
		-0.595157,
		-0.647533,
		0,
		-0.596569,
		0.759432,
		-0.259553,
		0,
		-0.243644,
		0.162499,
		-0.486798,
		1,
	},
	[0.6] = {
		0.646077,
		0.263565,
		-0.716323,
		0,
		-0.473062,
		-0.598231,
		-0.646786,
		0,
		-0.598997,
		0.756738,
		-0.261821,
		0,
		-0.243687,
		0.160592,
		-0.487409,
		1,
	},
	[0.716666666667] = {
		0.646412,
		0.262194,
		-0.716523,
		0,
		-0.476919,
		-0.594187,
		-0.647681,
		0,
		-0.595567,
		0.760392,
		-0.259044,
		0,
		-0.243543,
		0.163067,
		-0.486659,
		1,
	},
	[0.733333333333] = {
		0.646535,
		0.261847,
		-0.716539,
		0,
		-0.477366,
		-0.593787,
		-0.647718,
		0,
		-0.595075,
		0.760824,
		-0.258907,
		0,
		-0.24347,
		0.16329,
		-0.486621,
		1,
	},
	[0.75] = {
		0.646682,
		0.261462,
		-0.716547,
		0,
		-0.477766,
		-0.593453,
		-0.647729,
		0,
		-0.594594,
		0.761217,
		-0.258858,
		0,
		-0.243379,
		0.163467,
		-0.486607,
		1,
	},
	[0.766666666667] = {
		0.646851,
		0.261027,
		-0.716554,
		0,
		-0.478152,
		-0.593157,
		-0.647716,
		0,
		-0.5941,
		0.761597,
		-0.258873,
		0,
		-0.243273,
		0.163615,
		-0.48661,
		1,
	},
	[0.783333333333] = {
		0.647034,
		0.260535,
		-0.716567,
		0,
		-0.478561,
		-0.592864,
		-0.647681,
		0,
		-0.59357,
		0.761993,
		-0.258922,
		0,
		-0.243158,
		0.163754,
		-0.486621,
		1,
	},
	[0.7] = {
		0.646312,
		0.262503,
		-0.716501,
		0,
		-0.476431,
		-0.594646,
		-0.647619,
		0,
		-0.596066,
		0.759926,
		-0.259262,
		0,
		-0.243601,
		0.162802,
		-0.486719,
		1,
	},
	[0.816666666667] = {
		0.64744,
		0.259394,
		-0.716614,
		0,
		-0.479443,
		-0.59229,
		-0.647555,
		0,
		-0.592415,
		0.762829,
		-0.259108,
		0,
		-0.242901,
		0.164009,
		-0.486663,
		1,
	},
	[0.833333333333] = {
		0.64766,
		0.258756,
		-0.716646,
		0,
		-0.479909,
		-0.592009,
		-0.647466,
		0,
		-0.591797,
		0.763263,
		-0.259241,
		0,
		-0.242762,
		0.164125,
		-0.486694,
		1,
	},
	[0.85] = {
		0.647889,
		0.258079,
		-0.716683,
		0,
		-0.48039,
		-0.591733,
		-0.647362,
		0,
		-0.591156,
		0.763706,
		-0.259399,
		0,
		-0.242615,
		0.164234,
		-0.48673,
		1,
	},
	[0.866666666667] = {
		0.648126,
		0.257369,
		-0.716724,
		0,
		-0.480881,
		-0.591462,
		-0.647245,
		0,
		-0.590496,
		0.764155,
		-0.259579,
		0,
		-0.242464,
		0.164336,
		-0.486771,
		1,
	},
	[0.883333333333] = {
		0.64837,
		0.256629,
		-0.716769,
		0,
		-0.481382,
		-0.591197,
		-0.647115,
		0,
		-0.589821,
		0.764609,
		-0.259778,
		0,
		-0.242307,
		0.164431,
		-0.486817,
		1,
	},
	[0.8] = {
		0.647231,
		0.259988,
		-0.716588,
		0,
		-0.478993,
		-0.592575,
		-0.647627,
		0,
		-0.593008,
		0.762405,
		-0.259,
		0,
		-0.243034,
		0.163885,
		-0.486639,
		1,
	},
	[0.916666666667] = {
		0.64887,
		0.255084,
		-0.716868,
		0,
		-0.482399,
		-0.590685,
		-0.646825,
		0,
		-0.588438,
		0.765522,
		-0.260226,
		0,
		-0.241984,
		0.164601,
		-0.48692,
		1,
	},
	[0.933333333333] = {
		0.649124,
		0.254287,
		-0.716921,
		0,
		-0.48291,
		-0.590439,
		-0.646668,
		0,
		-0.587738,
		0.765976,
		-0.26047,
		0,
		-0.241819,
		0.164677,
		-0.486976,
		1,
	},
	[0.95] = {
		0.649379,
		0.253482,
		-0.716976,
		0,
		-0.483421,
		-0.5902,
		-0.646504,
		0,
		-0.587036,
		0.766427,
		-0.260725,
		0,
		-0.241653,
		0.164746,
		-0.487035,
		1,
	},
	[0.966666666667] = {
		0.649633,
		0.252672,
		-0.717032,
		0,
		-0.483928,
		-0.589969,
		-0.646336,
		0,
		-0.586337,
		0.766873,
		-0.260988,
		0,
		-0.241487,
		0.16481,
		-0.487096,
		1,
	},
	[0.983333333333] = {
		0.649884,
		0.251862,
		-0.717088,
		0,
		-0.484428,
		-0.589746,
		-0.646165,
		0,
		-0.585644,
		0.76731,
		-0.261257,
		0,
		-0.241322,
		0.164868,
		-0.487158,
		1,
	},
	[0.9] = {
		0.648618,
		0.255866,
		-0.716817,
		0,
		-0.481888,
		-0.590938,
		-0.646975,
		0,
		-0.589133,
		0.765065,
		-0.259994,
		0,
		-0.242147,
		0.164519,
		-0.486867,
		1,
	},
	[1.01666666667] = {
		0.650377,
		0.250265,
		-0.717201,
		0,
		-0.485402,
		-0.589326,
		-0.645818,
		0,
		-0.584291,
		0.768155,
		-0.261805,
		0,
		-0.240997,
		0.164969,
		-0.487285,
		1,
	},
	[1.03333333333] = {
		0.650614,
		0.249487,
		-0.717257,
		0,
		-0.485869,
		-0.58913,
		-0.645645,
		0,
		-0.583637,
		0.768559,
		-0.262078,
		0,
		-0.24084,
		0.165012,
		-0.487348,
		1,
	},
	[1.05] = {
		0.650844,
		0.248729,
		-0.717312,
		0,
		-0.486321,
		-0.588944,
		-0.645475,
		0,
		-0.583005,
		0.768947,
		-0.262348,
		0,
		-0.240687,
		0.16505,
		-0.487411,
		1,
	},
	[1.06666666667] = {
		0.651065,
		0.247997,
		-0.717365,
		0,
		-0.486754,
		-0.588768,
		-0.645308,
		0,
		-0.582396,
		0.769318,
		-0.262613,
		0,
		-0.24054,
		0.165084,
		-0.487472,
		1,
	},
	[1.08333333333] = {
		0.651276,
		0.247294,
		-0.717415,
		0,
		-0.487167,
		-0.588604,
		-0.645147,
		0,
		-0.581815,
		0.769669,
		-0.26287,
		0,
		-0.240399,
		0.165113,
		-0.487532,
		1,
	},
	{
		0.650133,
		0.251058,
		-0.717145,
		0,
		-0.48492,
		-0.589531,
		-0.645992,
		0,
		-0.584961,
		0.767739,
		-0.26153,
		0,
		-0.241158,
		0.164921,
		-0.487221,
		1,
	},
	[1.11666666667] = {
		0.651662,
		0.246,
		-0.71751,
		0,
		-0.487919,
		-0.58831,
		-0.644846,
		0,
		-0.58075,
		0.770309,
		-0.263351,
		0,
		-0.240139,
		0.165161,
		-0.487643,
		1,
	},
	[1.13333333333] = {
		0.651835,
		0.245418,
		-0.717552,
		0,
		-0.488255,
		-0.588182,
		-0.644709,
		0,
		-0.580274,
		0.770592,
		-0.263571,
		0,
		-0.240023,
		0.16518,
		-0.487694,
		1,
	},
	[1.15] = {
		0.651992,
		0.244886,
		-0.717591,
		0,
		-0.48856,
		-0.588067,
		-0.644582,
		0,
		-0.57984,
		0.770849,
		-0.263774,
		0,
		-0.239917,
		0.165195,
		-0.487741,
		1,
	},
	[1.16666666667] = {
		0.652133,
		0.244408,
		-0.717626,
		0,
		-0.488833,
		-0.587965,
		-0.644469,
		0,
		-0.579453,
		0.771078,
		-0.263957,
		0,
		-0.239822,
		0.165208,
		-0.487783,
		1,
	},
	[1.18333333333] = {
		0.652255,
		0.243991,
		-0.717657,
		0,
		-0.48907,
		-0.587878,
		-0.644368,
		0,
		-0.579114,
		0.771277,
		-0.264118,
		0,
		-0.239739,
		0.165218,
		-0.487821,
		1,
	},
	[1.1] = {
		0.651476,
		0.246627,
		-0.717464,
		0,
		-0.487556,
		-0.588451,
		-0.644992,
		0,
		-0.581265,
		0.77,
		-0.263117,
		0,
		-0.240265,
		0.165139,
		-0.487589,
		1,
	},
	[1.21666666667] = {
		0.652441,
		0.243355,
		-0.717704,
		0,
		-0.489428,
		-0.587748,
		-0.644214,
		0,
		-0.578602,
		0.771577,
		-0.264366,
		0,
		-0.239613,
		0.165231,
		-0.487878,
		1,
	},
	[1.23333333333] = {
		0.652502,
		0.243147,
		-0.717719,
		0,
		-0.489545,
		-0.587706,
		-0.644164,
		0,
		-0.578435,
		0.771674,
		-0.264448,
		0,
		-0.239572,
		0.165235,
		-0.487897,
		1,
	},
	[1.25] = {
		0.652539,
		0.243019,
		-0.717729,
		0,
		-0.489617,
		-0.587681,
		-0.644132,
		0,
		-0.578332,
		0.771734,
		-0.264499,
		0,
		-0.239546,
		0.165237,
		-0.487909,
		1,
	},
	[1.26666666667] = {
		0.652552,
		0.242975,
		-0.717732,
		0,
		-0.489642,
		-0.587672,
		-0.644121,
		0,
		-0.578296,
		0.771754,
		-0.264516,
		0,
		-0.239538,
		0.165237,
		-0.487913,
		1,
	},
	[1.2] = {
		0.652359,
		0.243638,
		-0.717683,
		0,
		-0.489269,
		-0.587805,
		-0.644283,
		0,
		-0.57883,
		0.771444,
		-0.264255,
		0,
		-0.239669,
		0.165226,
		-0.487853,
		1,
	},
}

return spline_matrices
