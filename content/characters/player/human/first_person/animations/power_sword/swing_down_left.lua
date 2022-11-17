local spline_matrices = {
	[0] = {
		0.61118,
		-0.669479,
		-0.422204,
		0,
		-0.790489,
		-0.543143,
		-0.28306,
		0,
		-0.039814,
		0.506748,
		-0.861174,
		0,
		-0.115519,
		0.031202,
		-0.655504,
		1
	},
	{
		0.800113,
		-0.417012,
		-0.431186,
		0,
		-0.513738,
		-0.847468,
		-0.133688,
		0,
		-0.309667,
		0.328481,
		-0.892304,
		0,
		-0.121126,
		-0.022047,
		-0.651943,
		1
	},
	[0.0166666666667] = {
		0.624337,
		-0.682142,
		-0.380638,
		0,
		-0.776366,
		-0.595736,
		-0.205803,
		0,
		-0.086373,
		0.424005,
		-0.901532,
		0,
		-0.104606,
		0.029872,
		-0.602169,
		1
	},
	[0.0333333333333] = {
		0.641165,
		-0.689458,
		-0.33698,
		0,
		-0.755679,
		-0.643707,
		-0.120795,
		0,
		-0.133633,
		0.332098,
		-0.933731,
		0,
		-0.093097,
		0.025269,
		-0.54534,
		1
	},
	[0.05] = {
		0.661557,
		-0.690875,
		-0.291608,
		0,
		-0.727828,
		-0.685195,
		-0.027832,
		0,
		-0.18058,
		0.230653,
		-0.956133,
		0,
		-0.080988,
		0.018088,
		-0.485453,
		1
	},
	[0.0666666666667] = {
		0.685339,
		-0.685738,
		-0.245101,
		0,
		-0.692292,
		-0.71793,
		0.072856,
		0,
		-0.225925,
		0.11975,
		-0.966756,
		0,
		-0.068264,
		0.00905,
		-0.422941,
		1
	},
	[0.0833333333333] = {
		0.712223,
		-0.673367,
		-0.19828,
		0,
		-0.648737,
		-0.739308,
		0.180454,
		0,
		-0.268102,
		0.000108,
		-0.963391,
		0,
		-0.054907,
		-0.001092,
		-0.358253,
		1
	},
	[0.116666666667] = {
		0.773317,
		-0.624709,
		-0.108258,
		0,
		-0.537981,
		-0.736894,
		0.409346,
		0,
		-0.335497,
		-0.258313,
		-0.905934,
		0,
		-0.026234,
		-0.021529,
		-0.224308,
		1
	},
	[0.133333333333] = {
		0.806039,
		-0.587957,
		-0.067876,
		0,
		-0.472264,
		-0.708043,
		0.525016,
		0,
		-0.356746,
		-0.391128,
		-0.848382,
		0,
		-0.010934,
		-0.030197,
		-0.156177,
		1
	},
	[0.15] = {
		0.8389,
		-0.543307,
		-0.032628,
		0,
		-0.401691,
		-0.658457,
		0.636458,
		0,
		-0.367276,
		-0.520818,
		-0.770621,
		0,
		0.00494,
		-0.036749,
		-0.088151,
		1
	},
	[0.166666666667] = {
		0.870748,
		-0.491714,
		-0.003938,
		0,
		-0.328585,
		-0.587794,
		0.739277,
		0,
		-0.365827,
		-0.64243,
		-0.67339,
		0,
		0.021276,
		-0.040416,
		-0.02099,
		1
	},
	[0.183333333333] = {
		0.900424,
		-0.434677,
		0.017094,
		0,
		-0.255754,
		-0.497182,
		0.829096,
		0,
		-0.35189,
		-0.75091,
		-0.558845,
		0,
		0.037902,
		-0.040506,
		0.044471,
		1
	},
	[0.1] = {
		0.741762,
		-0.653159,
		-0.152226,
		0,
		-0.59715,
		-0.746539,
		0.293412,
		0,
		-0.305287,
		-0.126741,
		-0.943788,
		0,
		-0.040899,
		-0.011554,
		-0.291866,
		1
	},
	[0.216666666667] = {
		0.949358,
		-0.3123,
		0.034474,
		0,
		-0.122898,
		-0.268117,
		0.955515,
		0,
		-0.289164,
		-0.911363,
		-0.29292,
		0,
		0.07108,
		-0.027733,
		0.166759,
		1
	},
	[0.233333333333] = {
		0.967387,
		-0.251328,
		0.031563,
		0,
		-0.068234,
		-0.138562,
		0.988,
		0,
		-0.243938,
		-0.957933,
		-0.151193,
		0,
		0.087074,
		-0.014072,
		0.221839,
		1
	},
	[0.25] = {
		0.980915,
		-0.193142,
		0.022402,
		0,
		-0.023977,
		-0.005821,
		0.999696,
		0,
		-0.192953,
		-0.981154,
		-0.01034,
		0,
		0.102288,
		0.004785,
		0.271801,
		1
	},
	[0.266666666667] = {
		0.990226,
		-0.139206,
		0.008634,
		0,
		0.008951,
		0.125206,
		0.99209,
		0,
		-0.139186,
		-0.982316,
		0.125228,
		0,
		0.11646,
		0.029001,
		0.315946,
		1
	},
	[0.283333333333] = {
		0.995871,
		-0.090432,
		-0.007915,
		0,
		0.030426,
		0.250373,
		0.967671,
		0,
		-0.085526,
		-0.963917,
		0.25209,
		0,
		0.129368,
		0.058709,
		0.353672,
		1
	},
	[0.2] = {
		0.926889,
		-0.374143,
		0.029883,
		0,
		-0.186222,
		-0.389289,
		0.902095,
		0,
		-0.325879,
		-0.841707,
		-0.430501,
		0,
		0.054593,
		-0.036432,
		0.107351,
		1
	},
	[0.316666666667] = {
		0.999066,
		-0.009353,
		-0.042175,
		0,
		0.041595,
		0.471929,
		0.880655,
		0,
		0.011667,
		-0.881587,
		0.471878,
		0,
		0.150733,
		0.135293,
		0.407849,
		1
	},
	[0.333333333333] = {
		0.998707,
		0.024084,
		-0.044777,
		0,
		0.022888,
		0.573438,
		0.818929,
		0,
		0.0454,
		-0.818895,
		0.572145,
		0,
		0.156436,
		0.20059,
		0.40388,
		1
	},
	[0.35] = {
		0.996608,
		0.065176,
		-0.050244,
		0,
		-0.008463,
		0.688471,
		0.725214,
		0,
		0.081858,
		-0.722329,
		0.686688,
		0,
		0.155746,
		0.287043,
		0.380104,
		1
	},
	[0.366666666667] = {
		0.987499,
		0.131568,
		-0.086812,
		0,
		-0.053692,
		0.798563,
		0.599511,
		0,
		0.148201,
		-0.587356,
		0.795644,
		0,
		0.151006,
		0.379186,
		0.364744,
		1
	},
	[0.383333333333] = {
		0.974752,
		0.165842,
		-0.149516,
		0,
		-0.097786,
		0.919028,
		0.381871,
		0,
		0.200739,
		-0.357609,
		0.912041,
		0,
		0.135857,
		0.481311,
		0.323684,
		1
	},
	[0.3] = {
		0.998563,
		-0.047182,
		-0.025416,
		0,
		0.040978,
		0.366559,
		0.929492,
		0,
		-0.034539,
		-0.929198,
		0.367966,
		0,
		0.140835,
		0.094049,
		0.384468,
		1
	},
	[0.416666666667] = {
		0.973175,
		-0.039442,
		-0.226661,
		0,
		-0.103082,
		0.806018,
		-0.582846,
		0,
		0.205681,
		0.590576,
		0.78033,
		0,
		0.058354,
		0.695014,
		0.067889,
		1
	},
	[0.433333333333] = {
		0.976252,
		-0.018322,
		-0.215864,
		0,
		-0.181963,
		0.471395,
		-0.862946,
		0,
		0.117568,
		0.881732,
		0.456867,
		0,
		0.000138,
		0.744821,
		-0.064372,
		1
	},
	[0.45] = {
		0.942682,
		0.015541,
		-0.33333,
		0,
		-0.333053,
		-0.017955,
		-0.942737,
		0,
		-0.020636,
		0.999718,
		-0.01175,
		0,
		-0.069603,
		0.747788,
		-0.223175,
		1
	},
	[0.466666666667] = {
		0.922152,
		0.009951,
		-0.3867,
		0,
		-0.308211,
		-0.585186,
		-0.750042,
		0,
		-0.233755,
		0.810838,
		-0.536563,
		0,
		-0.127497,
		0.64366,
		-0.405947,
		1
	},
	[0.483333333333] = {
		0.912804,
		-0.011262,
		-0.408242,
		0,
		-0.113822,
		-0.967027,
		-0.227822,
		0,
		-0.392215,
		0.254424,
		-0.883989,
		0,
		-0.173342,
		0.451851,
		-0.569799,
		1
	},
	[0.4] = {
		0.972554,
		0.072288,
		-0.221164,
		0,
		-0.093924,
		0.9916,
		-0.08892,
		0,
		0.212878,
		0.107253,
		0.971174,
		0,
		0.102911,
		0.597714,
		0.212036,
		1
	},
	[0.516666666667] = {
		0.892616,
		-0.121636,
		-0.434099,
		0,
		0.153587,
		-0.823259,
		0.546493,
		0,
		-0.423849,
		-0.554481,
		-0.716173,
		0,
		-0.191954,
		0.128717,
		-0.689575,
		1
	},
	[0.533333333333] = {
		0.881701,
		-0.198008,
		-0.428248,
		0,
		0.194932,
		-0.673699,
		0.712834,
		0,
		-0.429657,
		-0.711985,
		-0.555403,
		0,
		-0.174455,
		0.00197,
		-0.669685,
		1
	},
	[0.55] = {
		0.88637,
		-0.238193,
		-0.397003,
		0,
		0.204936,
		-0.56706,
		0.797775,
		0,
		-0.415149,
		-0.788484,
		-0.45381,
		0,
		-0.161259,
		-0.064221,
		-0.654079,
		1
	},
	[0.566666666667] = {
		0.892452,
		-0.259968,
		-0.368708,
		0,
		0.193435,
		-0.517837,
		0.833323,
		0,
		-0.407568,
		-0.815022,
		-0.411858,
		0,
		-0.151045,
		-0.096391,
		-0.638698,
		1
	},
	[0.583333333333] = {
		0.894079,
		-0.276186,
		-0.352626,
		0,
		0.180765,
		-0.497819,
		0.848233,
		0,
		-0.409814,
		-0.82213,
		-0.395165,
		0,
		-0.145392,
		-0.117991,
		-0.631961,
		1
	},
	[0.5] = {
		0.906225,
		-0.049129,
		-0.419931,
		0,
		0.071977,
		-0.9608,
		0.267735,
		0,
		-0.416624,
		-0.272853,
		-0.867165,
		0,
		-0.197244,
		0.278127,
		-0.672971,
		1
	},
	[0.616666666667] = {
		0.895122,
		-0.305399,
		-0.324791,
		0,
		0.1498,
		-0.480131,
		0.864312,
		0,
		-0.419901,
		-0.822318,
		-0.384027,
		0,
		-0.135984,
		-0.152335,
		-0.621307,
		1
	},
	[0.633333333333] = {
		0.894515,
		-0.318883,
		-0.3133,
		0,
		0.131526,
		-0.482083,
		0.866197,
		0,
		-0.427252,
		-0.816033,
		-0.389288,
		0,
		-0.132167,
		-0.165287,
		-0.617284,
		1
	},
	[0.65] = {
		0.893163,
		-0.331874,
		-0.303512,
		0,
		0.111354,
		-0.490666,
		0.864203,
		0,
		-0.43573,
		-0.805672,
		-0.401289,
		0,
		-0.128899,
		-0.175672,
		-0.614055,
		1
	},
	[0.666666666667] = {
		0.891076,
		-0.344523,
		-0.295443,
		0,
		0.089219,
		-0.505293,
		0.858323,
		0,
		-0.444998,
		-0.791191,
		-0.419517,
		0,
		-0.126149,
		-0.183714,
		-0.611556,
		1
	},
	[0.683333333333] = {
		0.888271,
		-0.356876,
		-0.289161,
		0,
		0.065054,
		-0.525449,
		0.848334,
		0,
		-0.454689,
		-0.772362,
		-0.443525,
		0,
		-0.123887,
		-0.189521,
		-0.60976,
		1
	},
	[0.6] = {
		0.894975,
		-0.291234,
		-0.337939,
		0,
		0.16621,
		-0.485297,
		0.858406,
		0,
		-0.413997,
		-0.824421,
		-0.385923,
		0,
		-0.140381,
		-0.136604,
		-0.626185,
		1
	},
	[0.716666666667] = {
		0.880623,
		-0.380616,
		-0.282198,
		0,
		0.010456,
		-0.579827,
		0.814673,
		0,
		-0.473703,
		-0.72037,
		-0.506629,
		0,
		-0.120697,
		-0.194832,
		-0.608194,
		1
	},
	[0.733333333333] = {
		0.875871,
		-0.391851,
		-0.281609,
		0,
		-0.019963,
		-0.612514,
		0.790208,
		0,
		-0.482133,
		-0.686498,
		-0.544306,
		0,
		-0.119698,
		-0.194526,
		-0.608385,
		1
	},
	[0.75] = {
		0.870588,
		-0.402495,
		-0.282974,
		0,
		-0.052349,
		-0.647647,
		0.76014,
		0,
		-0.48922,
		-0.646956,
		-0.584903,
		0,
		-0.119043,
		-0.192367,
		-0.609193,
		1
	},
	[0.766666666667] = {
		0.864863,
		-0.41238,
		-0.286276,
		0,
		-0.086514,
		-0.684167,
		0.724176,
		0,
		-0.494497,
		-0.601546,
		-0.627387,
		0,
		-0.118689,
		-0.188445,
		-0.610586,
		1
	},
	[0.783333333333] = {
		0.858803,
		-0.421323,
		-0.291453,
		0,
		-0.122177,
		-0.720927,
		0.682156,
		0,
		-0.497524,
		-0.550229,
		-0.67061,
		0,
		-0.118587,
		-0.182854,
		-0.61252,
		1
	},
	[0.7] = {
		0.884774,
		-0.368925,
		-0.284728,
		0,
		0.038806,
		-0.55053,
		0.833913,
		0,
		-0.464402,
		-0.748873,
		-0.472778,
		0,
		-0.12208,
		-0.193195,
		-0.608646,
		1
	},
	[0.816666666667] = {
		0.846178,
		-0.435632,
		-0.306934,
		0,
		-0.196408,
		-0.790367,
		0.580297,
		0,
		-0.495386,
		-0.43075,
		-0.754352,
		0,
		-0.118944,
		-0.167079,
		-0.617775,
		1
	},
	[0.833333333333] = {
		0.839887,
		-0.440671,
		-0.316858,
		0,
		-0.233978,
		-0.820721,
		0.521221,
		0,
		-0.489739,
		-0.363629,
		-0.79242,
		0,
		-0.119303,
		-0.157127,
		-0.620946,
		1
	},
	[0.85] = {
		0.833793,
		-0.444148,
		-0.327906,
		0,
		-0.271102,
		-0.846801,
		0.457637,
		0,
		-0.480929,
		-0.292678,
		-0.826466,
		0,
		-0.11972,
		-0.14598,
		-0.624364,
		1
	},
	[0.866666666667] = {
		0.828021,
		-0.446015,
		-0.339783,
		0,
		-0.307203,
		-0.867825,
		0.39052,
		0,
		-0.469049,
		-0.218976,
		-0.855595,
		0,
		-0.120154,
		-0.133792,
		-0.627931,
		1
	},
	[0.883333333333] = {
		0.822675,
		-0.446291,
		-0.35218,
		0,
		-0.341739,
		-0.883269,
		0.321014,
		0,
		-0.454336,
		-0.143737,
		-0.879158,
		0,
		-0.120571,
		-0.120739,
		-0.631553,
		1
	},
	[0.8] = {
		0.85253,
		-0.429132,
		-0.298393,
		0,
		-0.158963,
		-0.756726,
		0.634111,
		0,
		-0.497919,
		-0.493165,
		-0.713348,
		0,
		-0.118689,
		-0.175696,
		-0.614939,
		1
	},
	[0.916666666667] = {
		0.813537,
		-0.442473,
		-0.377327,
		0,
		-0.404327,
		-0.89676,
		0.179838,
		0,
		-0.417945,
		0.006258,
		-0.908451,
		0,
		-0.121254,
		-0.092799,
		-0.638593,
		1
	},
	[0.933333333333] = {
		0.809815,
		-0.438722,
		-0.389515,
		0,
		-0.431754,
		-0.89518,
		0.110635,
		0,
		-0.397224,
		0.078581,
		-0.914351,
		0,
		-0.121472,
		-0.078324,
		-0.641856,
		1
	},
	[0.95] = {
		0.806664,
		-0.434041,
		-0.401125,
		0,
		-0.456385,
		-0.888702,
		0.043837,
		0,
		-0.375508,
		0.147706,
		-0.914974,
		0,
		-0.12157,
		-0.063796,
		-0.644865,
		1
	},
	[0.966666666667] = {
		0.804041,
		-0.428685,
		-0.412003,
		0,
		-0.478192,
		-0.878036,
		-0.019625,
		0,
		-0.353341,
		0.212796,
		-0.910971,
		0,
		-0.121545,
		-0.049429,
		-0.647573,
		1
	},
	[0.983333333333] = {
		0.801884,
		-0.422915,
		-0.422048,
		0,
		-0.497256,
		-0.864,
		-0.079002,
		0,
		-0.331238,
		0.273216,
		-0.903125,
		0,
		-0.121397,
		-0.035433,
		-0.649942,
		1
	},
	[0.9] = {
		0.817831,
		-0.445062,
		-0.36479,
		0,
		-0.374238,
		-0.892896,
		0.250365,
		0,
		-0.437148,
		-0.068238,
		-0.896797,
		0,
		-0.120944,
		-0.107007,
		-0.635135,
		1
	},
	[1.01666666667] = {
		0.798638,
		-0.411278,
		-0.43935,
		0,
		-0.527863,
		-0.82934,
		-0.183183,
		0,
		-0.289031,
		0.378213,
		-0.879441,
		0,
		-0.120734,
		-0.009557,
		-0.65356,
		1
	},
	[1.03333333333] = {
		0.797364,
		-0.406,
		-0.446514,
		0,
		-0.539895,
		-0.810502,
		-0.227158,
		0,
		-0.269674,
		0.422198,
		-0.865462,
		0,
		-0.120222,
		0.001764,
		-0.654786,
		1
	},
	[1.05] = {
		0.796196,
		-0.401444,
		-0.452676,
		0,
		-0.550118,
		-0.791789,
		-0.265405,
		0,
		-0.251878,
		0.46034,
		-0.851261,
		0,
		-0.119587,
		0.011652,
		-0.655627,
		1
	},
	[1.06666666667] = {
		0.795037,
		-0.397861,
		-0.457845,
		0,
		-0.558819,
		-0.773973,
		-0.297805,
		0,
		-0.235875,
		0.492619,
		-0.837669,
		0,
		-0.118828,
		0.019848,
		-0.656089,
		1
	},
	[1.08333333333] = {
		0.793798,
		-0.395485,
		-0.462035,
		0,
		-0.566272,
		-0.757744,
		-0.324283,
		0,
		-0.221855,
		0.519053,
		-0.825448,
		0,
		-0.117939,
		0.026098,
		-0.656184,
		1
	},
	[1.1] = {
		0.792391,
		-0.394539,
		-0.465247,
		0,
		-0.572733,
		-0.743713,
		-0.344773,
		0,
		-0.209984,
		0.539657,
		-0.815277,
		0,
		-0.116913,
		0.030154,
		-0.655918,
		1
	}
}

return spline_matrices
