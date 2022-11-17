local spline_matrices = {
	[0] = {
		0.002544,
		-0.138346,
		0.990381,
		0,
		-0.771055,
		0.630371,
		0.090037,
		0,
		-0.636764,
		-0.763867,
		-0.105069,
		0,
		-0.371232,
		0.264317,
		-0.143913,
		1
	},
	{
		0.875042,
		-0.415105,
		-0.248976,
		0,
		-0.357115,
		-0.20641,
		-0.910968,
		0,
		0.326756,
		0.886049,
		-0.328858,
		0,
		0.017642,
		0.002165,
		-0.618939,
		1
	},
	[0.0166666666667] = {
		-0.009955,
		-0.155409,
		0.9878,
		0,
		-0.787656,
		0.609798,
		0.088001,
		0,
		-0.616035,
		-0.77717,
		-0.128479,
		0,
		-0.369134,
		0.26893,
		-0.154638,
		1
	},
	[0.0333333333333] = {
		-0.020624,
		-0.17329,
		0.984655,
		0,
		-0.80878,
		0.581869,
		0.085463,
		0,
		-0.58775,
		-0.794606,
		-0.152154,
		0,
		-0.367402,
		0.272869,
		-0.166306,
		1
	},
	[0.05] = {
		-0.029872,
		-0.192046,
		0.980931,
		0,
		-0.831026,
		0.550097,
		0.08239,
		0,
		-0.55543,
		-0.812718,
		-0.176028,
		0,
		-0.365727,
		0.276726,
		-0.178285,
		1
	},
	[0.0666666666667] = {
		-0.03826,
		-0.211676,
		0.976591,
		0,
		-0.851532,
		0.518319,
		0.078985,
		0,
		-0.522905,
		-0.828576,
		-0.200079,
		0,
		-0.363839,
		0.281078,
		-0.189933,
		1
	},
	[0.0833333333333] = {
		-0.0465,
		-0.232158,
		0.971566,
		0,
		-0.868075,
		0.490628,
		0.07569,
		0,
		-0.49425,
		-0.839873,
		-0.224345,
		0,
		-0.361498,
		0.286469,
		-0.200599,
		1
	},
	[0.116666666667] = {
		-0.066241,
		-0.275495,
		0.959018,
		0,
		-0.882693,
		0.464337,
		0.072419,
		0,
		-0.465258,
		-0.841721,
		-0.273935,
		0,
		-0.354561,
		0.302371,
		-0.216327,
		1
	},
	[0.133333333333] = {
		-0.080108,
		-0.298062,
		0.951179,
		0,
		-0.877392,
		0.473935,
		0.074619,
		0,
		-0.473038,
		-0.82858,
		-0.299484,
		0,
		-0.34946,
		0.313811,
		-0.220027,
		1
	},
	[0.15] = {
		-0.098658,
		-0.320658,
		0.942043,
		0,
		-0.860052,
		0.503675,
		0.081373,
		0,
		-0.500577,
		-0.802178,
		-0.325474,
		0,
		-0.342808,
		0.328181,
		-0.22001,
		1
	},
	[0.166666666667] = {
		-0.123321,
		-0.336415,
		0.933604,
		0,
		-0.829814,
		0.550912,
		0.088904,
		0,
		-0.544243,
		-0.763754,
		-0.347101,
		0,
		-0.334387,
		0.344462,
		-0.217013,
		1
	},
	[0.183333333333] = {
		-0.152868,
		-0.341078,
		0.927522,
		0,
		-0.787739,
		0.608789,
		0.09404,
		0,
		-0.596741,
		-0.716269,
		-0.361745,
		0,
		-0.324144,
		0.361425,
		-0.212333,
		1
	},
	[0.1] = {
		-0.055472,
		-0.253457,
		0.965755,
		0,
		-0.878964,
		0.471239,
		0.073188,
		0,
		-0.473652,
		-0.844803,
		-0.24892,
		0,
		-0.358482,
		0.293409,
		-0.209622,
		1
	},
	[0.216666666667] = {
		-0.219424,
		-0.330191,
		0.918056,
		0,
		-0.661591,
		0.741941,
		0.108723,
		0,
		-0.717043,
		-0.583521,
		-0.381252,
		0,
		-0.297169,
		0.398101,
		-0.198276,
		1
	},
	[0.233333333333] = {
		-0.254753,
		-0.321139,
		0.912124,
		0,
		-0.573915,
		0.809369,
		0.124669,
		0,
		-0.778282,
		-0.491722,
		-0.390496,
		0,
		-0.279827,
		0.418229,
		-0.18899,
		1
	},
	[0.25] = {
		-0.292068,
		-0.313483,
		0.903562,
		0,
		-0.466867,
		0.871276,
		0.15137,
		0,
		-0.834704,
		-0.377633,
		-0.400827,
		0,
		-0.259396,
		0.439848,
		-0.178161,
		1
	},
	[0.266666666667] = {
		-0.33332,
		-0.309216,
		0.890665,
		0,
		-0.337724,
		0.921159,
		0.193414,
		0,
		-0.88025,
		-0.23633,
		-0.41147,
		0,
		-0.235357,
		0.463126,
		-0.165634,
		1
	},
	[0.283333333333] = {
		-0.381844,
		-0.308207,
		0.871323,
		0,
		-0.183593,
		0.949265,
		0.25532,
		0,
		-0.905808,
		-0.062476,
		-0.419056,
		0,
		-0.206839,
		0.488035,
		-0.151474,
		1
	},
	[0.2] = {
		-0.18534,
		-0.337894,
		0.922755,
		0,
		-0.732225,
		0.673735,
		0.099636,
		0,
		-0.655359,
		-0.657198,
		-0.372284,
		0,
		-0.311831,
		0.379239,
		-0.206065,
		1
	},
	[0.316666666667] = {
		-0.547752,
		-0.3165,
		0.774465,
		0,
		0.237081,
		0.829022,
		0.506474,
		0,
		-0.802347,
		0.461033,
		-0.379062,
		0,
		-0.130993,
		0.545709,
		-0.11358,
		1
	},
	[0.333333333333] = {
		-0.649994,
		-0.26986,
		0.710411,
		0,
		0.468273,
		0.594031,
		0.6541,
		0,
		-0.598521,
		0.757828,
		-0.259749,
		0,
		-0.066112,
		0.570615,
		-0.079648,
		1
	},
	[0.35] = {
		-0.668225,
		-0.171084,
		0.724021,
		0,
		0.647578,
		0.345307,
		0.679268,
		0,
		-0.366221,
		0.922764,
		-0.119953,
		0,
		0.022094,
		0.589281,
		-0.034652,
		1
	},
	[0.366666666667] = {
		-0.642361,
		-0.082768,
		0.761919,
		0,
		0.75815,
		0.076865,
		0.647534,
		0,
		-0.11216,
		0.9936,
		0.013376,
		0,
		0.126244,
		0.598261,
		0.013309,
		1
	},
	[0.383333333333] = {
		-0.621798,
		-0.029787,
		0.782611,
		0,
		0.772806,
		-0.185422,
		0.606951,
		0,
		0.127034,
		0.982207,
		0.138315,
		0,
		0.254953,
		0.575875,
		0.059156,
		1
	},
	[0.3] = {
		-0.441886,
		-0.308364,
		0.842406,
		0,
		-0.004391,
		0.939795,
		0.34171,
		0,
		-0.897061,
		0.147298,
		-0.416636,
		0,
		-0.173085,
		0.514074,
		-0.135523,
		1
	},
	[0.416666666667] = {
		-0.537919,
		-0.080495,
		0.839145,
		0,
		0.69232,
		-0.610129,
		0.385272,
		0,
		0.480974,
		0.788202,
		0.383928,
		0,
		0.482499,
		0.454533,
		0.13222,
		1
	},
	[0.433333333333] = {
		-0.483839,
		-0.164855,
		0.85949,
		0,
		0.637037,
		-0.739739,
		0.216726,
		0,
		0.600069,
		0.652387,
		0.462934,
		0,
		0.561871,
		0.365843,
		0.140354,
		1
	},
	[0.45] = {
		-0.419099,
		-0.223063,
		0.880113,
		0,
		0.59174,
		-0.802303,
		0.078438,
		0,
		0.688621,
		0.553672,
		0.46824,
		0,
		0.646131,
		0.250818,
		0.116792,
		1
	},
	[0.466666666667] = {
		-0.353774,
		-0.268686,
		0.895908,
		0,
		0.563705,
		-0.825598,
		-0.025006,
		0,
		0.746378,
		0.496181,
		0.443535,
		0,
		0.698448,
		0.145344,
		0.075522,
		1
	},
	[0.483333333333] = {
		-0.297555,
		-0.307278,
		0.903903,
		0,
		0.546755,
		-0.830994,
		-0.102507,
		0,
		0.782637,
		0.463712,
		0.415272,
		0,
		0.716554,
		0.092426,
		0.043778,
		1
	},
	[0.4] = {
		-0.589521,
		-0.018937,
		0.807531,
		0,
		0.739439,
		-0.415025,
		0.530079,
		0,
		0.325107,
		0.909613,
		0.258669,
		0,
		0.381098,
		0.528536,
		0.10043,
		1
	},
	[0.516666666667] = {
		-0.189678,
		-0.380264,
		0.905219,
		0,
		0.499945,
		-0.830892,
		-0.244283,
		0,
		0.845031,
		0.406225,
		0.347712,
		0,
		0.732181,
		-0.001087,
		-0.018183,
		1
	},
	[0.533333333333] = {
		-0.136233,
		-0.415522,
		0.899323,
		0,
		0.473806,
		-0.824561,
		-0.309206,
		0,
		0.870028,
		0.38398,
		0.309209,
		0,
		0.732552,
		-0.039322,
		-0.04766,
		1
	},
	[0.55] = {
		-0.082505,
		-0.449817,
		0.889302,
		0,
		0.446987,
		-0.814257,
		-0.37039,
		0,
		0.890728,
		0.366947,
		0.268243,
		0,
		0.729731,
		-0.071935,
		-0.076002,
		1
	},
	[0.566666666667] = {
		-0.028527,
		-0.482802,
		0.875265,
		0,
		0.419652,
		-0.800503,
		-0.427886,
		0,
		0.907236,
		0.355101,
		0.225445,
		0,
		0.724652,
		-0.099708,
		-0.10322,
		1
	},
	[0.583333333333] = {
		0.025655,
		-0.51415,
		0.857317,
		0,
		0.391912,
		-0.783773,
		-0.481772,
		0,
		0.919645,
		0.348352,
		0.181394,
		0,
		0.717947,
		-0.123405,
		-0.129452,
		1
	},
	[0.5] = {
		-0.242812,
		-0.34438,
		0.906887,
		0,
		0.525178,
		-0.832681,
		-0.175589,
		0,
		0.815617,
		0.433642,
		0.383046,
		0,
		0.727323,
		0.043449,
		0.012219,
		1
	},
	[0.616666666667] = {
		0.134334,
		-0.570784,
		0.810037,
		0,
		0.335445,
		-0.742992,
		-0.579171,
		0,
		0.932433,
		0.349526,
		0.091658,
		0,
		0.701108,
		-0.161182,
		-0.179845,
		1
	},
	[0.633333333333] = {
		0.188614,
		-0.595515,
		0.780889,
		0,
		0.306761,
		-0.719645,
		-0.622904,
		0,
		0.932911,
		0.357034,
		0.046946,
		0,
		0.691317,
		-0.176321,
		-0.204522,
		1
	},
	[0.65] = {
		0.242652,
		-0.617499,
		0.748207,
		0,
		0.277769,
		-0.694743,
		-0.663458,
		0,
		0.929497,
		0.368819,
		0.002941,
		0,
		0.680659,
		-0.189514,
		-0.229219,
		1
	},
	[0.666666666667] = {
		0.296256,
		-0.636484,
		0.712124,
		0,
		0.248453,
		-0.66857,
		-0.700917,
		0,
		0.922228,
		0.38458,
		-0.039931,
		0,
		0.66907,
		-0.201068,
		-0.254224,
		1
	},
	[0.683333333333] = {
		0.349193,
		-0.652233,
		0.672797,
		0,
		0.218792,
		-0.641398,
		-0.73535,
		0,
		0.91115,
		0.403982,
		-0.081269,
		0,
		0.65173,
		-0.208438,
		-0.27929,
		1
	},
	[0.6] = {
		0.079973,
		-0.543571,
		0.835545,
		0,
		0.363832,
		-0.76448,
		-0.532162,
		0,
		0.928025,
		0.346556,
		0.136631,
		0,
		0.710021,
		-0.143703,
		-0.154911,
		1
	},
	[0.716666666667] = {
		0.45179,
		-0.673341,
		0.585233,
		0,
		0.158212,
		-0.585128,
		-0.795358,
		0,
		0.877983,
		0.451926,
		-0.157825,
		0,
		0.594805,
		-0.20634,
		-0.326614,
		1
	},
	[0.733333333333] = {
		0.500465,
		-0.678685,
		0.537514,
		0,
		0.127013,
		-0.556586,
		-0.821024,
		0,
		0.856389,
		0.479165,
		-0.19235,
		0,
		0.563235,
		-0.201888,
		-0.349313,
		1
	},
	[0.75] = {
		0.546937,
		-0.680529,
		0.487586,
		0,
		0.095266,
		-0.528042,
		-0.843858,
		0,
		0.831736,
		0.507987,
		-0.223975,
		0,
		0.529954,
		-0.195468,
		-0.371345,
		1
	},
	[0.766666666667] = {
		0.590924,
		-0.678881,
		0.43581,
		0,
		0.063079,
		-0.499683,
		-0.863909,
		0,
		0.804258,
		0.537994,
		-0.252451,
		0,
		0.495251,
		-0.187254,
		-0.392696,
		1
	},
	[0.783333333333] = {
		0.632161,
		-0.673795,
		0.382587,
		0,
		0.030571,
		-0.471691,
		-0.881234,
		0,
		0.774234,
		0.568778,
		-0.277585,
		0,
		0.459414,
		-0.177426,
		-0.413353,
		1
	},
	[0.7] = {
		0.401202,
		-0.664535,
		0.630421,
		0,
		0.188769,
		-0.613484,
		-0.766814,
		0,
		0.896328,
		0.426651,
		-0.120687,
		0,
		0.624381,
		-0.208652,
		-0.303265,
		1
	},
	[0.816666666667] = {
		0.705477,
		-0.653812,
		0.273555,
		0,
		-0.034868,
		-0.417529,
		-0.907995,
		0,
		0.707875,
		0.631031,
		-0.317354,
		0,
		0.385514,
		-0.153666,
		-0.452552,
		1
	},
	[0.833333333333] = {
		0.737202,
		-0.639311,
		0.218667,
		0,
		-0.067507,
		-0.391699,
		-0.917614,
		0,
		0.672292,
		0.661705,
		-0.331919,
		0,
		0.348033,
		-0.140127,
		-0.471086,
		1
	},
	[0.85] = {
		0.765483,
		-0.622167,
		0.164149,
		0,
		-0.099888,
		-0.366911,
		-0.924878,
		0,
		0.635656,
		0.691582,
		-0.343011,
		0,
		0.310582,
		-0.125757,
		-0.488911,
		1
	},
	[0.866666666667] = {
		0.790275,
		-0.602716,
		0.11045,
		0,
		-0.131856,
		-0.343301,
		-0.929924,
		0,
		0.598398,
		0.720332,
		-0.350774,
		0,
		0.273437,
		-0.110774,
		-0.506032,
		1
	},
	[0.883333333333] = {
		0.811589,
		-0.581343,
		0.057993,
		0,
		-0.163261,
		-0.320986,
		-0.932906,
		0,
		0.560953,
		0.747669,
		-0.35542,
		0,
		0.236871,
		-0.095404,
		-0.522457,
		1
	},
	[0.8] = {
		0.670412,
		-0.665382,
		0.328351,
		0,
		-0.002125,
		-0.444248,
		-0.895901,
		0,
		0.741986,
		0.599925,
		-0.299243,
		0,
		0.422738,
		-0.166166,
		-0.433307,
		1
	},
	[0.916666666667] = {
		0.844116,
		-0.534536,
		-0.041717,
		0,
		-0.22382,
		-0.280605,
		-0.933363,
		0,
		0.48721,
		0.797203,
		-0.356503,
		0,
		0.166506,
		-0.064456,
		-0.553262,
		1
	},
	[0.933333333333] = {
		0.85562,
		-0.510008,
		-0.088356,
		0,
		-0.252727,
		-0.262664,
		-0.931202,
		0,
		0.451713,
		0.819084,
		-0.353633,
		0,
		0.133196,
		-0.049375,
		-0.567666,
		1
	},
	[0.95] = {
		0.864216,
		-0.48535,
		-0.132537,
		0,
		-0.28058,
		-0.246271,
		-0.927699,
		0,
		0.417619,
		0.838919,
		-0.349011,
		0,
		0.101442,
		-0.034901,
		-0.581424,
		1
	},
	[0.966666666667] = {
		0.870144,
		-0.461021,
		-0.174096,
		0,
		-0.307301,
		-0.231438,
		-0.92304,
		0,
		0.385248,
		0.856678,
		-0.343056,
		0,
		0.071461,
		-0.021302,
		-0.594548,
		1
	},
	[0.983333333333] = {
		0.873663,
		-0.437464,
		-0.212928,
		0,
		-0.332826,
		-0.218158,
		-0.917406,
		0,
		0.35488,
		0.872372,
		-0.336196,
		0,
		0.043462,
		-0.008854,
		-0.607049,
		1
	},
	[0.9] = {
		0.829496,
		-0.558467,
		0.00716,
		0,
		-0.193959,
		-0.300063,
		-0.933993,
		0,
		0.523753,
		0.773354,
		-0.357221,
		0,
		0.201144,
		-0.079884,
		-0.538196,
		1
	},
	[1.01666666667] = {
		0.874554,
		-0.394339,
		-0.282227,
		0,
		-0.380143,
		-0.196163,
		-0.903887,
		0,
		0.301075,
		0.897784,
		-0.321461,
		0,
		-0.005802,
		0.011469,
		-0.630226,
		1
	},
	[1.03333333333] = {
		0.872462,
		-0.375535,
		-0.312703,
		0,
		-0.401902,
		-0.187377,
		-0.896306,
		0,
		0.278001,
		0.907669,
		-0.314407,
		0,
		-0.026683,
		0.018772,
		-0.640916,
		1
	},
	[1.05] = {
		0.869015,
		-0.359031,
		-0.340454,
		0,
		-0.422399,
		-0.180004,
		-0.888357,
		0,
		0.257665,
		0.915803,
		-0.308081,
		0,
		-0.044811,
		0.023787,
		-0.651014,
		1
	},
	[1.06666666667] = {
		0.864444,
		-0.345133,
		-0.36554,
		0,
		-0.441652,
		-0.173997,
		-0.880153,
		0,
		0.240167,
		0.922284,
		-0.30284,
		0,
		-0.059994,
		0.026225,
		-0.66052,
		1
	},
	[1.08333333333] = {
		0.858952,
		-0.334117,
		-0.388031,
		0,
		-0.459689,
		-0.169306,
		-0.871792,
		0,
		0.225585,
		0.927201,
		-0.299016,
		0,
		-0.072034,
		0.025807,
		-0.669434,
		1
	}
}

return spline_matrices
