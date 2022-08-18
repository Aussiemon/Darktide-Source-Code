local spline_matrices = {
	[0] = {
		-0.403629,
		0.019807,
		0.914708,
		0,
		0.889756,
		-0.224377,
		0.397477,
		0,
		0.213112,
		0.974301,
		0.072942,
		0,
		0.727642,
		0.0031,
		-1.311343,
		1
	},
	{
		-0.403629,
		0.019807,
		0.914708,
		0,
		0.889756,
		-0.224377,
		0.397477,
		0,
		0.213112,
		0.974301,
		0.072942,
		0,
		0.727641,
		0.003099,
		-1.311344,
		1
	},
	[0.0166666666667] = {
		-0.369091,
		0.033678,
		0.928783,
		0,
		0.881769,
		-0.303109,
		0.361398,
		0,
		0.293694,
		0.952361,
		0.082178,
		0,
		0.728299,
		0.011337,
		-1.30849,
		1
	},
	[0.0333333333333] = {
		-0.330697,
		0.047072,
		0.942562,
		0,
		0.865057,
		-0.384122,
		0.322687,
		0,
		0.377249,
		0.922081,
		0.086308,
		0,
		0.726705,
		0.027994,
		-1.304223,
		1
	},
	[0.05] = {
		-0.287205,
		0.058235,
		0.956097,
		0,
		0.83867,
		-0.46693,
		0.280371,
		0,
		0.462758,
		0.882374,
		0.085264,
		0,
		0.722977,
		0.052474,
		-1.298553,
		1
	},
	[0.0666666666667] = {
		-0.237753,
		0.065086,
		0.969143,
		0,
		0.801465,
		-0.550536,
		0.233591,
		0,
		0.548751,
		0.83227,
		0.078728,
		0,
		0.717262,
		0.084188,
		-1.291482,
		1
	},
	[0.0833333333333] = {
		-0.182012,
		0.065283,
		0.981127,
		0,
		0.752244,
		-0.633337,
		0.181692,
		0,
		0.633246,
		0.771117,
		0.066166,
		0,
		0.709745,
		0.122556,
		-1.283003,
		1
	},
	[0.116666666667] = {
		-0.053978,
		0.036113,
		0.997889,
		0,
		0.614043,
		-0.786858,
		0.061691,
		0,
		0.787425,
		0.616076,
		0.020299,
		0,
		0.690331,
		0.216908,
		-1.261728,
		1
	},
	[0.133333333333] = {
		0.014987,
		0.002684,
		0.999884,
		0,
		0.524581,
		-0.851342,
		-0.005577,
		0,
		0.851228,
		0.524604,
		-0.014167,
		0,
		0.67911,
		0.271669,
		-1.248857,
		1
	},
	[0.15] = {
		0.083613,
		-0.044782,
		0.995492,
		0,
		0.42273,
		-0.903052,
		-0.076129,
		0,
		0.90239,
		0.42719,
		-0.056577,
		0,
		0.667443,
		0.330599,
		-1.234443,
		1
	},
	[0.166666666667] = {
		0.149913,
		-0.107933,
		0.98279,
		0,
		0.306199,
		-0.940084,
		-0.14995,
		0,
		0.94009,
		0.323408,
		-0.107882,
		0,
		0.666062,
		0.393158,
		-1.218532,
		1
	},
	[0.183333333333] = {
		0.208169,
		-0.184113,
		0.960608,
		0,
		0.17482,
		-0.959305,
		-0.221747,
		0,
		0.962343,
		0.214094,
		-0.167511,
		0,
		0.68341,
		0.458174,
		-1.201584,
		1
	},
	[0.1] = {
		-0.120349,
		0.056386,
		0.991129,
		0,
		0.689973,
		-0.713074,
		0.124348,
		0,
		0.71376,
		0.698817,
		0.046913,
		0,
		0.700667,
		0.166995,
		-1.273096,
		1
	},
	[0.216666666667] = {
		0.289393,
		-0.360687,
		0.886655,
		0,
		-0.107133,
		-0.932675,
		-0.344441,
		0,
		0.951196,
		0.004689,
		-0.308551,
		0,
		0.759155,
		0.591389,
		-1.165307,
		1
	},
	[0.233333333333] = {
		0.309982,
		-0.452084,
		0.83638,
		0,
		-0.243297,
		-0.88814,
		-0.38989,
		0,
		0.919085,
		-0.08263,
		-0.385298,
		0,
		0.809806,
		0.657779,
		-1.146253,
		1
	},
	[0.25] = {
		0.318103,
		-0.539741,
		0.779416,
		0,
		-0.3676,
		-0.828025,
		-0.423374,
		0,
		0.873888,
		-0.151837,
		-0.461806,
		0,
		0.863735,
		0.723073,
		-1.126715,
		1
	},
	[0.266666666667] = {
		0.315872,
		-0.620483,
		0.717792,
		0,
		-0.475723,
		-0.758133,
		-0.446007,
		0,
		0.820921,
		-0.200589,
		-0.534651,
		0,
		0.917187,
		0.786751,
		-1.106593,
		1
	},
	[0.283333333333] = {
		0.306115,
		-0.692244,
		0.653523,
		0,
		-0.565305,
		-0.68452,
		-0.460285,
		0,
		0.765979,
		-0.228539,
		-0.600871,
		0,
		0.966518,
		0.84833,
		-1.085695,
		1
	},
	[0.2] = {
		0.255307,
		-0.269805,
		0.928452,
		0,
		0.034663,
		-0.957104,
		-0.287662,
		0,
		0.966238,
		0.105625,
		-0.235003,
		0,
		0.715715,
		0.52457,
		-1.183797,
		1
	},
	[0.316666666667] = {
		0.276582,
		-0.805605,
		0.52393,
		0,
		-0.687284,
		-0.546882,
		-0.478081,
		0,
		0.671672,
		-0.22786,
		-0.704937,
		0,
		1.038626,
		0.963167,
		-1.040489,
		1
	},
	[0.333333333333] = {
		0.262965,
		-0.847389,
		0.461282,
		0,
		-0.721067,
		-0.490274,
		-0.489586,
		0,
		0.641025,
		-0.203871,
		-0.739949,
		0,
		1.05434,
		1.015316,
		-1.015564,
		1
	},
	[0.35] = {
		0.253655,
		-0.882234,
		0.396638,
		0,
		-0.738926,
		-0.441344,
		-0.50912,
		0,
		0.624217,
		-0.163945,
		-0.763855,
		0,
		1.044689,
		1.059097,
		-0.984375,
		1
	},
	[0.366666666667] = {
		0.248063,
		-0.908879,
		0.335266,
		0,
		-0.739208,
		-0.401273,
		-0.54088,
		0,
		0.626128,
		-0.113659,
		-0.771392,
		0,
		0.999062,
		1.108683,
		-0.942605,
		1
	},
	[0.383333333333] = {
		0.248686,
		-0.92661,
		0.282045,
		0,
		-0.721851,
		-0.371464,
		-0.583906,
		0,
		0.645823,
		-0.058385,
		-0.761252,
		0,
		0.920445,
		1.175814,
		-0.890211,
		1
	},
	[0.3] = {
		0.291967,
		-0.754012,
		0.588406,
		0,
		-0.635671,
		-0.612651,
		-0.46966,
		0,
		0.714617,
		-0.236908,
		-0.658178,
		0,
		1.008171,
		0.907313,
		-1.063761,
		1
	},
	[0.416666666667] = {
		0.285825,
		-0.941643,
		0.177801,
		0,
		-0.656934,
		-0.327622,
		-0.679044,
		0,
		0.697669,
		0.077285,
		-0.71224,
		0,
		0.718236,
		1.324582,
		-0.7583,
		1
	},
	[0.433333333333] = {
		0.329003,
		-0.937422,
		0.114001,
		0,
		-0.623482,
		-0.306301,
		-0.71934,
		0,
		0.709244,
		0.165587,
		-0.68524,
		0,
		0.622,
		1.386488,
		-0.680847,
		1
	},
	[0.45] = {
		0.398561,
		-0.916745,
		0.026976,
		0,
		-0.598712,
		-0.28235,
		-0.749548,
		0,
		0.694761,
		0.282589,
		-0.6614,
		0,
		0.535001,
		1.42586,
		-0.592507,
		1
	},
	[0.466666666667] = {
		0.515598,
		-0.851575,
		-0.094759,
		0,
		-0.577033,
		-0.263345,
		-0.773099,
		0,
		0.633397,
		0.453287,
		-0.627167,
		0,
		0.435658,
		1.440919,
		-0.485702,
		1
	},
	[0.483333333333] = {
		0.66059,
		-0.714411,
		-0.230732,
		0,
		-0.548645,
		-0.249608,
		-0.797925,
		0,
		0.512455,
		0.653691,
		-0.556847,
		0,
		0.316754,
		1.43704,
		-0.362419,
		1
	},
	[0.4] = {
		0.260102,
		-0.937418,
		0.231506,
		0,
		-0.692316,
		-0.348182,
		-0.632034,
		0,
		0.673087,
		0.004118,
		-0.739552,
		0,
		0.822295,
		1.251017,
		-0.828396,
		1
	},
	[0.516666666667] = {
		0.840383,
		-0.365344,
		-0.400351,
		0,
		-0.474616,
		-0.139371,
		-0.869089,
		0,
		0.261719,
		0.92038,
		-0.290523,
		0,
		0.143152,
		1.385727,
		-0.148689,
		1
	},
	[0.533333333333] = {
		0.874779,
		-0.212734,
		-0.435322,
		0,
		-0.451403,
		-0.031364,
		-0.891769,
		0,
		0.176057,
		0.976607,
		-0.123465,
		0,
		0.088447,
		1.352492,
		-0.056857,
		1
	},
	[0.55] = {
		0.889017,
		-0.001661,
		-0.457871,
		0,
		-0.456164,
		0.083124,
		-0.886005,
		0,
		0.039532,
		0.996538,
		0.073141,
		0,
		-0.083778,
		1.226868,
		0.075614,
		1
	},
	[0.566666666667] = {
		0.872441,
		0.299751,
		-0.386001,
		0,
		-0.460529,
		0.239866,
		-0.854621,
		0,
		-0.163585,
		0.923371,
		0.347313,
		0,
		-0.310192,
		1.051666,
		0.253605,
		1
	},
	[0.583333333333] = {
		0.819615,
		0.500077,
		-0.279562,
		0,
		-0.520271,
		0.445351,
		-0.728684,
		0,
		-0.239895,
		0.742688,
		0.625192,
		0,
		-0.40067,
		0.826909,
		0.370684,
		1
	},
	[0.5] = {
		0.774384,
		-0.535668,
		-0.336734,
		0,
		-0.510522,
		-0.214605,
		-0.832654,
		0,
		0.373761,
		0.816703,
		-0.439657,
		0,
		0.213371,
		1.416247,
		-0.246566,
		1
	},
	[0.616666666667] = {
		0.60614,
		0.779471,
		-0.158175,
		0,
		-0.784263,
		0.618848,
		0.04426,
		0,
		0.132385,
		0.097223,
		0.986419,
		0,
		-0.522962,
		-0.160488,
		0.401346,
		1
	},
	[0.633333333333] = {
		0.626977,
		0.778756,
		-0.020943,
		0,
		-0.77433,
		0.625913,
		0.092985,
		0,
		0.085521,
		-0.042083,
		0.995447,
		0,
		-0.534124,
		-0.537748,
		0.394692,
		1
	},
	[0.65] = {
		0.664527,
		0.747243,
		0.005623,
		0,
		-0.747257,
		0.664534,
		0.000658,
		0,
		-0.003245,
		-0.004639,
		0.999984,
		0,
		-0.49341,
		-0.669252,
		0.378541,
		1
	},
	[0.666666666667] = {
		0.617923,
		0.785422,
		0.035831,
		0,
		-0.786163,
		0.616589,
		0.042019,
		0,
		0.01091,
		-0.054133,
		0.998474,
		0,
		-0.35465,
		-0.672734,
		0.265167,
		1
	},
	[0.683333333333] = {
		0.53561,
		0.841387,
		0.072045,
		0,
		-0.844034,
		0.530657,
		0.077519,
		0,
		0.026992,
		-0.102328,
		0.994384,
		0,
		-0.215276,
		-0.663775,
		0.134879,
		1
	},
	[0.6] = {
		0.732775,
		0.615551,
		-0.290066,
		0,
		-0.677615,
		0.621066,
		-0.393846,
		0,
		-0.062282,
		0.485154,
		0.872208,
		0,
		-0.456941,
		0.381624,
		0.411237,
		1
	},
	[0.716666666667] = {
		0.234648,
		0.953362,
		0.189847,
		0,
		-0.96685,
		0.208659,
		0.147178,
		0,
		0.100701,
		-0.218088,
		0.97072,
		0,
		0.07892,
		-0.614195,
		-0.158878,
		1
	},
	[0.733333333333] = {
		0.016097,
		0.964994,
		0.261778,
		0,
		-0.985039,
		-0.029622,
		0.169764,
		0,
		0.171576,
		-0.260594,
		0.95008,
		0,
		0.236967,
		-0.568972,
		-0.312409,
		1
	},
	[0.75] = {
		-0.227899,
		0.91358,
		0.336798,
		0,
		-0.936323,
		-0.300525,
		0.181613,
		0,
		0.267134,
		-0.273962,
		0.923896,
		0,
		0.391308,
		-0.507081,
		-0.463757,
		1
	},
	[0.766666666667] = {
		-0.46345,
		0.786334,
		0.408526,
		0,
		-0.801847,
		-0.568376,
		0.184364,
		0,
		0.377168,
		-0.242132,
		0.893933,
		0,
		0.530926,
		-0.429848,
		-0.607859,
		1
	},
	[0.783333333333] = {
		-0.651762,
		0.593133,
		0.472652,
		0,
		-0.585537,
		-0.789612,
		0.183463,
		0,
		0.48203,
		-0.157181,
		0.861941,
		0,
		0.645467,
		-0.343249,
		-0.740299,
		1
	},
	[0.7] = {
		0.409116,
		0.903732,
		0.126067,
		0,
		-0.910856,
		0.396224,
		0.115537,
		0,
		0.054464,
		-0.162097,
		0.985271,
		0,
		-0.07388,
		-0.644782,
		-0.008252,
		1
	},
	[0.816666666667] = {
		-0.80028,
		0.138914,
		0.583313,
		0,
		-0.029003,
		-0.980624,
		0.193742,
		0,
		0.598924,
		0.13813,
		0.788803,
		0,
		0.778146,
		-0.176888,
		-0.956874,
		1
	},
	[0.833333333333] = {
		-0.766761,
		-0.053154,
		0.639729,
		0,
		0.238244,
		-0.948953,
		0.206706,
		0,
		0.596086,
		0.310905,
		0.740284,
		0,
		0.795624,
		-0.112137,
		-1.034854,
		1
	},
	[0.85] = {
		-0.683952,
		-0.193981,
		0.703264,
		0,
		0.466163,
		-0.85773,
		0.216774,
		0,
		0.561161,
		0.476099,
		0.677073,
		0,
		0.782626,
		-0.065101,
		-1.087751,
		1
	},
	[0.866666666667] = {
		-0.642903,
		-0.186807,
		0.742818,
		0,
		0.538582,
		-0.799816,
		0.264997,
		0,
		0.544615,
		0.570436,
		0.614815,
		0,
		0.777987,
		-0.044584,
		-1.125385,
		1
	},
	[0.883333333333] = {
		-0.60188,
		-0.174272,
		0.779339,
		0,
		0.610048,
		-0.730106,
		0.307875,
		0,
		0.515346,
		0.660738,
		0.54575,
		0,
		0.771959,
		-0.026679,
		-1.161551,
		1
	},
	[0.8] = {
		-0.765935,
		0.364671,
		0.529488,
		0,
		-0.315,
		-0.930806,
		0.185403,
		0,
		0.560462,
		-0.024783,
		0.827809,
		0,
		0.728479,
		-0.256058,
		-0.857629,
		1
	},
	[0.916666666667] = {
		-0.526388,
		-0.135311,
		0.839409,
		0,
		0.736219,
		-0.566395,
		0.370376,
		0,
		0.425321,
		0.81295,
		0.397761,
		0,
		0.757736,
		-0.00057,
		-1.225692,
		1
	},
	[0.933333333333] = {
		-0.493107,
		-0.108843,
		0.863133,
		0,
		0.785893,
		-0.481248,
		0.388293,
		0,
		0.373118,
		0.869801,
		0.322846,
		0,
		0.750521,
		0.007057,
		-1.252374,
		1
	},
	[0.95] = {
		-0.46388,
		-0.078848,
		0.882382,
		0,
		0.825365,
		-0.400328,
		0.398133,
		0,
		0.32185,
		0.912974,
		0.250782,
		0,
		0.743757,
		0.011079,
		-1.27467,
		1
	},
	[0.966666666667] = {
		-0.43921,
		-0.046632,
		0.897173,
		0,
		0.855061,
		-0.328077,
		0.401542,
		0,
		0.275617,
		0.943499,
		0.183968,
		0,
		0.73766,
		0.011662,
		-1.292133,
		1
	},
	[0.983333333333] = {
		-0.419199,
		-0.013418,
		0.907795,
		0,
		0.876082,
		-0.268346,
		0.400588,
		0,
		0.238228,
		0.963229,
		0.124245,
		0,
		0.732299,
		0.008968,
		-1.30444,
		1
	},
	[0.9] = {
		-0.562787,
		-0.157063,
		0.811543,
		0,
		0.676948,
		-0.650982,
		0.343459,
		0,
		0.474355,
		0.742667,
		0.472688,
		0,
		0.765039,
		-0.011886,
		-1.195228,
		1
	}
}

return spline_matrices
