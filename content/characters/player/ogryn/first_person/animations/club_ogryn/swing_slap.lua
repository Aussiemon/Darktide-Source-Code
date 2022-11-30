local spline_matrices = {
	[0] = {
		0.77221,
		0.57666,
		0.266749,
		0,
		0.317584,
		0.013307,
		-0.948137,
		0,
		-0.550302,
		0.816876,
		-0.172862,
		0,
		-1.157594,
		0.40436,
		-0.985262,
		1
	},
	{
		0.767969,
		0.580505,
		0.270624,
		0,
		0.316695,
		0.023094,
		-0.948246,
		0,
		-0.556712,
		0.813929,
		-0.166108,
		0,
		-0.627128,
		0.381376,
		-0.820951,
		1
	},
	[0.0166666666667] = {
		0.811666,
		0.497789,
		0.305622,
		0,
		0.424589,
		-0.143462,
		-0.893948,
		0,
		-0.401153,
		0.85535,
		-0.327799,
		0,
		-1.202378,
		0.377525,
		-0.943247,
		1
	},
	[0.0333333333333] = {
		0.831751,
		0.406428,
		0.378162,
		0,
		0.519944,
		-0.331599,
		-0.78721,
		0,
		-0.194546,
		0.851386,
		-0.487128,
		0,
		-1.270293,
		0.317634,
		-0.885565,
		1
	},
	[0.05] = {
		0.817854,
		0.312311,
		0.483297,
		0,
		0.57102,
		-0.544221,
		-0.614621,
		0,
		0.071067,
		0.778643,
		-0.623429,
		0,
		-1.358614,
		0.241096,
		-0.82187,
		1
	},
	[0.0666666666667] = {
		0.756612,
		0.233568,
		0.610724,
		0,
		0.537806,
		-0.753533,
		-0.378091,
		0,
		0.37189,
		0.61452,
		-0.695747,
		0,
		-1.458756,
		0.162582,
		-0.764055,
		1
	},
	[0.0833333333333] = {
		0.647603,
		0.191794,
		0.737445,
		0,
		0.394168,
		-0.912575,
		-0.108806,
		0,
		0.652106,
		0.361141,
		-0.666585,
		0,
		-1.555738,
		0.090542,
		-0.72191,
		1
	},
	[0.116666666667] = {
		0.381604,
		0.244536,
		0.891393,
		0,
		-0.128553,
		-0.940957,
		0.313166,
		0,
		0.915343,
		-0.234097,
		-0.327637,
		0,
		-1.686037,
		-0.034909,
		-0.682295,
		1
	},
	[0.133333333333] = {
		0.282972,
		0.307448,
		0.908516,
		0,
		-0.39637,
		-0.825076,
		0.402667,
		0,
		0.873394,
		-0.474052,
		-0.111611,
		0,
		-1.714479,
		-0.08745,
		-0.668523,
		1
	},
	[0.15] = {
		0.224319,
		0.36421,
		0.903898,
		0,
		-0.615759,
		-0.665943,
		0.421142,
		0,
		0.755329,
		-0.651054,
		0.074882,
		0,
		-1.686301,
		-0.085792,
		-0.654756,
		1
	},
	[0.166666666667] = {
		0.202224,
		0.398575,
		0.894563,
		0,
		-0.778667,
		-0.488548,
		0.393698,
		0,
		0.593956,
		-0.776182,
		0.211561,
		0,
		-1.637486,
		-0.042386,
		-0.642775,
		1
	},
	[0.183333333333] = {
		0.205139,
		0.410086,
		0.888677,
		0,
		-0.904242,
		-0.268037,
		0.33242,
		0,
		0.374519,
		-0.871772,
		0.315832,
		0,
		-1.613542,
		0.040054,
		-0.62921,
		1
	},
	[0.1] = {
		0.511603,
		0.198386,
		0.836005,
		0,
		0.154282,
		-0.978376,
		0.137756,
		0,
		0.845257,
		0.058504,
		-0.531148,
		0,
		-1.633981,
		0.025445,
		-0.697056,
		1
	},
	[0.216666666667] = {
		0.237503,
		0.367989,
		0.898986,
		0,
		-0.926743,
		0.363178,
		0.096174,
		0,
		-0.291101,
		-0.855971,
		0.427287,
		0,
		-1.596377,
		0.336742,
		-0.578884,
		1
	},
	[0.233333333333] = {
		0.235269,
		0.308855,
		0.921551,
		0,
		-0.740977,
		0.670588,
		-0.035576,
		0,
		-0.628969,
		-0.674478,
		0.386623,
		0,
		-1.571906,
		0.519595,
		-0.534143,
		1
	},
	[0.25] = {
		0.199245,
		0.234705,
		0.951428,
		0,
		-0.457378,
		0.880929,
		-0.121531,
		0,
		-0.866664,
		-0.410948,
		0.28287,
		0,
		-1.518417,
		0.702387,
		-0.483422,
		1
	},
	[0.266666666667] = {
		0.125217,
		0.156958,
		0.979635,
		0,
		-0.159966,
		0.977681,
		-0.136198,
		0,
		-0.979148,
		-0.139654,
		0.14753,
		0,
		-1.444991,
		0.857631,
		-0.430858,
		1
	},
	[0.283333333333] = {
		-0.064285,
		0.015724,
		0.997808,
		0,
		0.105865,
		0.994341,
		-0.008849,
		0,
		-0.9923,
		0.105064,
		-0.065585,
		0,
		-1.328586,
		1.019369,
		-0.378613,
		1
	},
	[0.2] = {
		0.22125,
		0.401957,
		0.888526,
		0,
		-0.972794,
		0.026781,
		0.230118,
		0,
		0.068702,
		-0.915267,
		0.396947,
		0,
		-1.606372,
		0.171384,
		-0.609796,
		1
	},
	[0.316666666667] = {
		-0.121378,
		0.039694,
		0.991812,
		0,
		0.711707,
		0.699988,
		0.059084,
		0,
		-0.691911,
		0.713051,
		-0.113214,
		0,
		-0.964091,
		1.152742,
		-0.344322,
		1
	},
	[0.333333333333] = {
		0.121916,
		0.074364,
		0.989751,
		0,
		0.913732,
		0.381002,
		-0.141179,
		0,
		-0.387596,
		0.921579,
		-0.021498,
		0,
		-0.727003,
		1.189467,
		-0.334545,
		1
	},
	[0.35] = {
		0.346852,
		0.009076,
		0.937876,
		0,
		0.919901,
		0.191773,
		-0.34206,
		0,
		-0.182963,
		0.981397,
		0.058168,
		0,
		-0.42206,
		1.242175,
		-0.320372,
		1
	},
	[0.366666666667] = {
		0.508862,
		-0.108477,
		0.853986,
		0,
		0.860327,
		0.029571,
		-0.508884,
		0,
		0.029949,
		0.993659,
		0.108373,
		0,
		-0.095654,
		1.277186,
		-0.309387,
		1
	},
	[0.383333333333] = {
		0.50152,
		-0.281761,
		0.817979,
		0,
		0.786848,
		-0.244493,
		-0.566651,
		0,
		0.35965,
		0.927811,
		0.099085,
		0,
		0.406814,
		1.231029,
		-0.296714,
		1
	},
	[0.3] = {
		-0.23326,
		-0.054809,
		0.970869,
		0,
		0.367469,
		0.919409,
		0.140192,
		0,
		-0.900309,
		0.389465,
		-0.19432,
		0,
		-1.164261,
		1.129215,
		-0.346577,
		1
	},
	[0.416666666667] = {
		0.278625,
		-0.479063,
		0.832386,
		0,
		0.470569,
		-0.687444,
		-0.553159,
		0,
		0.837217,
		0.54582,
		0.033893,
		0,
		0.925022,
		0.947625,
		-0.283763,
		1
	},
	[0.433333333333] = {
		0.125201,
		-0.49406,
		0.860366,
		0,
		0.221875,
		-0.831283,
		-0.509647,
		0,
		0.967004,
		0.254702,
		0.005542,
		0,
		1.027789,
		0.760746,
		-0.290121,
		1
	},
	[0.45] = {
		-0.03658,
		-0.441611,
		0.896461,
		0,
		-0.078438,
		-0.893025,
		-0.443119,
		0,
		0.996248,
		-0.086526,
		-0.001972,
		0,
		1.131881,
		0.561415,
		-0.310531,
		1
	},
	[0.466666666667] = {
		-0.167888,
		-0.323692,
		0.931148,
		0,
		-0.382327,
		-0.849245,
		-0.364154,
		0,
		0.908647,
		-0.41714,
		0.018822,
		0,
		1.240086,
		0.355936,
		-0.34882,
		1
	},
	[0.483333333333] = {
		-0.238578,
		-0.170505,
		0.956038,
		0,
		-0.633064,
		-0.719229,
		-0.286252,
		0,
		0.736418,
		-0.673526,
		0.063652,
		0,
		1.314251,
		0.16754,
		-0.403419,
		1
	},
	[0.4] = {
		0.397808,
		-0.415038,
		0.818225,
		0,
		0.651047,
		-0.500676,
		-0.570492,
		0,
		0.646442,
		0.759649,
		0.071036,
		0,
		0.813956,
		1.109331,
		-0.286281,
		1
	},
	[0.516666666667] = {
		-0.209636,
		0.088486,
		0.973767,
		0,
		-0.895099,
		-0.418168,
		-0.154701,
		0,
		0.39351,
		-0.904049,
		0.166867,
		0,
		1.29659,
		-0.002644,
		-0.54178,
		1
	},
	[0.533333333333] = {
		-0.151191,
		0.154774,
		0.976313,
		0,
		-0.935861,
		-0.340427,
		-0.090959,
		0,
		0.318285,
		-0.927445,
		0.196317,
		0,
		1.295607,
		-0.023851,
		-0.621257,
		1
	},
	[0.55] = {
		-0.074461,
		0.190594,
		0.978841,
		0,
		-0.942338,
		-0.3346,
		-0.006533,
		0,
		0.326275,
		-0.922885,
		0.204519,
		0,
		1.289217,
		-0.019114,
		-0.722462,
		1
	},
	[0.566666666667] = {
		0.024395,
		0.219604,
		0.975284,
		0,
		-0.916118,
		-0.385596,
		0.10974,
		0,
		0.400165,
		-0.896153,
		0.191777,
		0,
		1.260743,
		-0.001111,
		-0.855886,
		1
	},
	[0.583333333333] = {
		0.140511,
		0.25306,
		0.957192,
		0,
		-0.840765,
		-0.480049,
		0.250334,
		0,
		0.522849,
		-0.839948,
		0.145312,
		0,
		1.185692,
		0.051487,
		-1.024367,
		1
	},
	[0.5] = {
		-0.246107,
		-0.023483,
		0.968958,
		0,
		-0.801598,
		-0.557054,
		-0.2171,
		0,
		0.54486,
		-0.830144,
		0.118271,
		0,
		1.30414,
		0.058808,
		-0.471727,
		1
	},
	[0.616666666667] = {
		0.377123,
		0.37053,
		0.848814,
		0,
		-0.474886,
		-0.709479,
		0.520695,
		0,
		0.795149,
		-0.599456,
		-0.091601,
		0,
		0.751034,
		0.361264,
		-1.28122,
		1
	},
	[0.633333333333] = {
		0.460374,
		0.456771,
		0.761194,
		0,
		-0.19785,
		-0.783104,
		0.58958,
		0,
		0.865397,
		-0.422029,
		-0.270148,
		0,
		0.527798,
		0.506381,
		-1.381871,
		1
	},
	[0.65] = {
		0.503398,
		0.547086,
		0.668795,
		0,
		0.088238,
		-0.802523,
		0.590061,
		0,
		0.859537,
		-0.238022,
		-0.452262,
		0,
		0.323565,
		0.632655,
		-1.462392,
		1
	},
	[0.666666666667] = {
		0.511994,
		0.626493,
		0.58768,
		0,
		0.33634,
		-0.77574,
		0.53395,
		0,
		0.790403,
		-0.075719,
		-0.607889,
		0,
		0.146154,
		0.732508,
		-1.523807,
		1
	},
	[0.683333333333] = {
		0.502596,
		0.685611,
		0.526626,
		0,
		0.521536,
		-0.726277,
		0.447796,
		0,
		0.68949,
		0.049594,
		-0.722595,
		0,
		0.00347,
		0.788907,
		-1.534891,
		1
	},
	[0.6] = {
		0.263922,
		0.30142,
		0.916238,
		0,
		-0.696186,
		-0.597933,
		0.397242,
		0,
		0.667586,
		-0.742712,
		0.052037,
		0,
		0.977112,
		0.20561,
		-1.160437,
		1
	},
	[0.716666666667] = {
		0.490104,
		0.738939,
		0.46235,
		0,
		0.720623,
		-0.641906,
		0.26203,
		0,
		0.490409,
		0.204758,
		-0.847097,
		0,
		-0.173177,
		0.751391,
		-1.428711,
		1
	},
	[0.733333333333] = {
		0.493716,
		0.745389,
		0.447928,
		0,
		0.7788,
		-0.608168,
		0.15363,
		0,
		0.38693,
		0.272997,
		-0.880771,
		0,
		-0.257972,
		0.716336,
		-1.369788,
		1
	},
	[0.75] = {
		0.504381,
		0.742907,
		0.440101,
		0,
		0.817148,
		-0.575379,
		0.034762,
		0,
		0.27905,
		0.342094,
		-0.897275,
		0,
		-0.341275,
		0.677685,
		-1.301812,
		1
	},
	[0.766666666667] = {
		0.522133,
		0.733132,
		0.435769,
		0,
		0.836027,
		-0.540996,
		-0.091553,
		0,
		0.168629,
		0.412117,
		-0.89539,
		0,
		-0.418757,
		0.636091,
		-1.226224,
		1
	},
	[0.783333333333] = {
		0.546352,
		0.717503,
		0.432075,
		0,
		0.835551,
		-0.50259,
		-0.22194,
		0,
		0.057914,
		0.482278,
		-0.874102,
		0,
		-0.486518,
		0.592868,
		-1.146354,
		1
	},
	[0.7] = {
		0.492708,
		0.721413,
		0.486623,
		0,
		0.641617,
		-0.678942,
		0.356884,
		0,
		0.587849,
		0.136386,
		-0.797391,
		0,
		-0.090576,
		0.782869,
		-1.478839,
		1
	},
	[0.816666666667] = {
		0.608877,
		0.674717,
		0.417164,
		0,
		0.778239,
		-0.406205,
		-0.478896,
		0,
		-0.153665,
		0.616242,
		-0.77242,
		0,
		-0.583534,
		0.508574,
		-0.991936,
		1
	},
	[0.833333333333] = {
		0.643395,
		0.651024,
		0.402753,
		0,
		0.723927,
		-0.346334,
		-0.596642,
		0,
		-0.248942,
		0.67544,
		-0.694124,
		0,
		-0.611943,
		0.471084,
		-0.926305,
		1
	},
	[0.85] = {
		0.677114,
		0.628395,
		0.382933,
		0,
		0.655689,
		-0.278982,
		-0.701599,
		0,
		-0.334049,
		0.726147,
		-0.600934,
		0,
		-0.62934,
		0.438769,
		-0.873372,
		1
	},
	[0.866666666667] = {
		0.707782,
		0.608835,
		0.358279,
		0,
		0.576965,
		-0.205564,
		-0.790477,
		0,
		-0.407621,
		0.766201,
		-0.496771,
		0,
		-0.638063,
		0.412691,
		-0.835254,
		1
	},
	[0.883333333333] = {
		0.733384,
		0.594219,
		0.330229,
		0,
		0.491712,
		-0.128235,
		-0.861263,
		0,
		-0.469432,
		0.794015,
		-0.386231,
		0,
		-0.640192,
		0.393588,
		-0.813176,
		1
	},
	[0.8] = {
		0.575835,
		0.697488,
		0.426527,
		0,
		0.816007,
		-0.45812,
		-0.352502,
		0,
		-0.050466,
		0.551032,
		-0.832957,
		0,
		-0.541982,
		0.549767,
		-1.066795,
		1
	},
	[0.916666666667] = {
		0.763131,
		0.585825,
		0.272837,
		0,
		0.317571,
		0.027746,
		-0.947829,
		0,
		-0.562832,
		0.809963,
		-0.164867,
		0,
		-0.629151,
		0.378391,
		-0.820785,
		1
	},
	[0.933333333333] = {
		0.764162,
		0.584696,
		0.272373,
		0,
		0.317364,
		0.026803,
		-0.947925,
		0,
		-0.561548,
		0.81081,
		-0.16508,
		0,
		-0.628748,
		0.379054,
		-0.820787,
		1
	},
	[0.95] = {
		0.765166,
		0.583594,
		0.271918,
		0,
		0.317173,
		0.025862,
		-0.948015,
		0,
		-0.560288,
		0.811634,
		-0.165311,
		0,
		-0.628342,
		0.379688,
		-0.820805,
		1
	},
	[0.966666666667] = {
		0.766139,
		0.582523,
		0.271473,
		0,
		0.316996,
		0.024927,
		-0.948099,
		0,
		-0.559057,
		0.812432,
		-0.16556,
		0,
		-0.627935,
		0.380289,
		-0.820838,
		1
	},
	[0.983333333333] = {
		0.767075,
		0.581492,
		0.271041,
		0,
		0.316837,
		0.024003,
		-0.948176,
		0,
		-0.557863,
		0.813198,
		-0.165826,
		0,
		-0.62753,
		0.380853,
		-0.820887,
		1
	},
	[0.9] = {
		0.752263,
		0.58614,
		0.3009,
		0,
		0.403992,
		-0.049579,
		-0.913418,
		0,
		-0.520472,
		0.808692,
		-0.274092,
		0,
		-0.637098,
		0.381991,
		-0.808,
		1
	},
	[1.01666666667] = {
		0.768816,
		0.579569,
		0.270225,
		0,
		0.316574,
		0.022205,
		-0.948308,
		0,
		-0.55561,
		0.81462,
		-0.166405,
		0,
		-0.626732,
		0.381854,
		-0.821031,
		1
	},
	[1.03333333333] = {
		0.769611,
		0.57869,
		0.269845,
		0,
		0.316473,
		0.02134,
		-0.948361,
		0,
		-0.554566,
		0.815268,
		-0.166717,
		0,
		-0.626344,
		0.382284,
		-0.821128,
		1
	},
	[1.05] = {
		0.770349,
		0.577875,
		0.269487,
		0,
		0.316395,
		0.020503,
		-0.948406,
		0,
		-0.553585,
		0.815868,
		-0.167043,
		0,
		-0.625965,
		0.382662,
		-0.82124,
		1
	},
	[1.06666666667] = {
		0.771024,
		0.577129,
		0.269153,
		0,
		0.316341,
		0.019699,
		-0.948441,
		0,
		-0.552675,
		0.816415,
		-0.167381,
		0,
		-0.625598,
		0.382985,
		-0.821369,
		1
	},
	[1.08333333333] = {
		0.771633,
		0.576459,
		0.268846,
		0,
		0.316312,
		0.018933,
		-0.948466,
		0,
		-0.551842,
		0.816907,
		-0.167732,
		0,
		-0.625245,
		0.383248,
		-0.821515,
		1
	},
	[1.11666666667] = {
		0.772629,
		0.575371,
		0.268315,
		0,
		0.316332,
		0.017529,
		-0.948486,
		0,
		-0.550435,
		0.817704,
		-0.168465,
		0,
		-0.624595,
		0.383581,
		-0.821855,
		1
	},
	[1.13333333333] = {
		0.773009,
		0.574966,
		0.268087,
		0,
		0.316373,
		0.016901,
		-0.948484,
		0,
		-0.549877,
		0.818002,
		-0.16884,
		0,
		-0.62431,
		0.383644,
		-0.822042,
		1
	},
	[1.15] = {
		0.773306,
		0.574662,
		0.267883,
		0,
		0.316431,
		0.016327,
		-0.948475,
		0,
		-0.549427,
		0.818228,
		-0.169215,
		0,
		-0.624061,
		0.383632,
		-0.822236,
		1
	},
	[1.16666666667] = {
		0.773516,
		0.574465,
		0.2677,
		0,
		0.316502,
		0.015813,
		-0.94846,
		0,
		-0.549091,
		0.818376,
		-0.169588,
		0,
		-0.623853,
		0.383543,
		-0.822436,
		1
	},
	[1.18333333333] = {
		0.773634,
		0.574382,
		0.267538,
		0,
		0.316584,
		0.015362,
		-0.94844,
		0,
		-0.548877,
		0.818443,
		-0.169955,
		0,
		-0.623691,
		0.383371,
		-0.822638,
		1
	},
	[1.1] = {
		0.772169,
		0.575871,
		0.268566,
		0,
		0.31631,
		0.018208,
		-0.948481,
		0,
		-0.551093,
		0.817338,
		-0.168094,
		0,
		-0.624909,
		0.383448,
		-0.821678,
		1
	},
	[1.21666666667] = {
		0.773606,
		0.574544,
		0.26727,
		0,
		0.316771,
		0.014656,
		-0.948389,
		0,
		-0.548808,
		0.818343,
		-0.170661,
		0,
		-0.623513,
		0.382797,
		-0.823041,
		1
	},
	[1.23333333333] = {
		0.773513,
		0.574719,
		0.267162,
		0,
		0.316871,
		0.014374,
		-0.94836,
		0,
		-0.548881,
		0.818224,
		-0.170994,
		0,
		-0.623467,
		0.382452,
		-0.823236,
		1
	},
	[1.25] = {
		0.773386,
		0.574933,
		0.267069,
		0,
		0.316974,
		0.014133,
		-0.948329,
		0,
		-0.549,
		0.818079,
		-0.171309,
		0,
		-0.62344,
		0.382092,
		-0.823424,
		1
	},
	[1.26666666667] = {
		0.773235,
		0.575172,
		0.26699,
		0,
		0.317076,
		0.013929,
		-0.948298,
		0,
		-0.549154,
		0.817914,
		-0.171603,
		0,
		-0.623429,
		0.381725,
		-0.823602,
		1
	},
	[1.28333333333] = {
		0.773068,
		0.575427,
		0.266925,
		0,
		0.317176,
		0.01376,
		-0.948267,
		0,
		-0.549332,
		0.817737,
		-0.171874,
		0,
		-0.623432,
		0.381362,
		-0.823768,
		1
	},
	[1.2] = {
		0.773657,
		0.574418,
		0.267395,
		0,
		0.316674,
		0.01498,
		-0.948416,
		0,
		-0.548792,
		0.818425,
		-0.170314,
		0,
		-0.623582,
		0.383115,
		-0.822841,
		1
	},
	[1.31666666667] = {
		0.772723,
		0.575935,
		0.26683,
		0,
		0.317355,
		0.013514,
		-0.94821,
		0,
		-0.549714,
		0.817384,
		-0.172333,
		0,
		-0.623463,
		0.380691,
		-0.824054,
		1
	},
	[1.33333333333] = {
		0.772562,
		0.576165,
		0.266798,
		0,
		0.317431,
		0.013432,
		-0.948186,
		0,
		-0.549896,
		0.817223,
		-0.172516,
		0,
		-0.623486,
		0.380403,
		-0.82417,
		1
	},
	[1.35] = {
		0.772422,
		0.576364,
		0.266775,
		0,
		0.317494,
		0.013373,
		-0.948166,
		0,
		-0.550057,
		0.817083,
		-0.172663,
		0,
		-0.623509,
		0.380161,
		-0.824264,
		1
	},
	[1.36666666667] = {
		0.77231,
		0.576521,
		0.26676,
		0,
		0.317542,
		0.013334,
		-0.94815,
		0,
		-0.550185,
		0.816974,
		-0.172772,
		0,
		-0.62353,
		0.379976,
		-0.824334,
		1
	},
	[1.38333333333] = {
		0.772237,
		0.576623,
		0.266752,
		0,
		0.317573,
		0.013313,
		-0.94814,
		0,
		-0.550271,
		0.816902,
		-0.172839,
		0,
		-0.623544,
		0.379857,
		-0.824378,
		1
	},
	[1.3] = {
		0.772894,
		0.575685,
		0.266872,
		0,
		0.317269,
		0.013623,
		-0.948238,
		0,
		-0.549522,
		0.817558,
		-0.172118,
		0,
		-0.623444,
		0.381014,
		-0.82392,
		1
	},
	[1.4] = {
		0.77221,
		0.57666,
		0.266749,
		0,
		0.317584,
		0.013307,
		-0.948137,
		0,
		-0.550302,
		0.816876,
		-0.172862,
		0,
		-0.62355,
		0.379815,
		-0.824393,
		1
	}
}

return spline_matrices
