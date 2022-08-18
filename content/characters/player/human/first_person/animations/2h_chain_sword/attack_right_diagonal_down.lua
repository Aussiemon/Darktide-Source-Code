local spline_matrices = {
	[0] = {
		0.873088,
		-0.275957,
		0.401952,
		0,
		-0.476043,
		-0.304337,
		0.825083,
		0,
		-0.105358,
		-0.911716,
		-0.39708,
		0,
		-0.295029,
		-0.509446,
		-0.236837,
		1
	},
	{
		0.695204,
		-0.137951,
		0.705451,
		0,
		-0.139353,
		-0.988658,
		-0.056004,
		0,
		0.705175,
		-0.059372,
		-0.706543,
		0,
		0.476229,
		0.092695,
		-0.469449,
		1
	},
	[0.0166666666667] = {
		0.87319,
		-0.276012,
		0.401693,
		0,
		-0.470151,
		-0.259815,
		0.843477,
		0,
		-0.128444,
		-0.925372,
		-0.356635,
		0,
		-0.28604,
		-0.490692,
		-0.229436,
		1
	},
	[0.0333333333333] = {
		0.873479,
		-0.275667,
		0.401302,
		0,
		-0.453197,
		-0.159193,
		0.87708,
		0,
		-0.177898,
		-0.94798,
		-0.263983,
		0,
		-0.265332,
		-0.445213,
		-0.210291,
		1
	},
	[0.05] = {
		0.873931,
		-0.274988,
		0.400781,
		0,
		-0.430895,
		-0.056817,
		0.900612,
		0,
		-0.224886,
		-0.959767,
		-0.168145,
		0,
		-0.242316,
		-0.389501,
		-0.185074,
		1
	},
	[0.0666666666667] = {
		0.874524,
		-0.27404,
		0.400138,
		0,
		-0.418773,
		-0.010548,
		0.90803,
		0,
		-0.244616,
		-0.96166,
		-0.123985,
		0,
		-0.226373,
		-0.341189,
		-0.159476,
		1
	},
	[0.0833333333333] = {
		0.88559,
		-0.250379,
		0.391204,
		0,
		-0.406852,
		-0.011871,
		0.913417,
		0,
		-0.224056,
		-0.968075,
		-0.11238,
		0,
		-0.218313,
		-0.306894,
		-0.130899,
		1
	},
	[0.116666666667] = {
		0.935205,
		-0.113638,
		0.335376,
		0,
		-0.339254,
		-0.016119,
		0.940557,
		0,
		-0.101477,
		-0.993391,
		-0.053626,
		0,
		-0.208363,
		-0.252194,
		-0.060673,
		1
	},
	[0.133333333333] = {
		0.953592,
		-0.032871,
		0.299303,
		0,
		-0.300007,
		-0.018996,
		0.953748,
		0,
		-0.025665,
		-0.999279,
		-0.027976,
		0,
		-0.205688,
		-0.222373,
		-0.02904,
		1
	},
	[0.15] = {
		0.962436,
		0.033211,
		0.26947,
		0,
		-0.268828,
		-0.022564,
		0.962924,
		0,
		0.03806,
		-0.999194,
		-0.012789,
		0,
		-0.204102,
		-0.18449,
		-0.006384,
		1
	},
	[0.166666666667] = {
		0.964243,
		0.067449,
		0.256291,
		0,
		-0.255019,
		-0.026986,
		0.966559,
		0,
		0.072109,
		-0.997358,
		-0.008821,
		0,
		-0.203339,
		-0.135049,
		0.002342,
		1
	},
	[0.183333333333] = {
		0.95141,
		0.078051,
		0.29787,
		0,
		-0.295547,
		-0.040062,
		0.954488,
		0,
		0.086431,
		-0.996144,
		-0.015047,
		0,
		-0.206923,
		-0.06782,
		0.002443,
		1
	},
	[0.1] = {
		0.909745,
		-0.191706,
		0.368257,
		0,
		-0.377669,
		-0.013754,
		0.925838,
		0,
		-0.172424,
		-0.981356,
		-0.084914,
		0,
		-0.212446,
		-0.278639,
		-0.096294,
		1
	},
	[0.216666666667] = {
		0.843271,
		0.088867,
		0.530092,
		0,
		-0.522896,
		-0.092619,
		0.84735,
		0,
		0.124398,
		-0.991728,
		-0.031635,
		0,
		-0.227434,
		0.105304,
		0.002873,
		1
	},
	[0.233333333333] = {
		0.755748,
		0.090167,
		0.648625,
		0,
		-0.638782,
		-0.116641,
		0.760495,
		0,
		0.144228,
		-0.989073,
		-0.030554,
		0,
		-0.237178,
		0.193705,
		0.003473,
		1
	},
	[0.25] = {
		0.675077,
		0.088453,
		0.732425,
		0,
		-0.721281,
		-0.129451,
		0.680438,
		0,
		0.155,
		-0.987633,
		-0.02359,
		0,
		-0.241714,
		0.271719,
		0.004937,
		1
	},
	[0.266666666667] = {
		0.623108,
		0.066132,
		0.779335,
		0,
		-0.779497,
		0.134292,
		0.611842,
		0,
		-0.064196,
		-0.988733,
		0.135228,
		0,
		-0.233388,
		0.338772,
		0.001587,
		1
	},
	[0.283333333333] = {
		0.589488,
		0.021703,
		0.807486,
		0,
		-0.609295,
		0.668255,
		0.426843,
		0,
		-0.530343,
		-0.743616,
		0.407152,
		0,
		-0.207446,
		0.397026,
		-0.010329,
		1
	},
	[0.2] = {
		0.91185,
		0.084973,
		0.401633,
		0,
		-0.397215,
		-0.064466,
		0.915458,
		0,
		0.103681,
		-0.994296,
		-0.025031,
		0,
		-0.216148,
		0.015222,
		0.002584,
		1
	},
	[0.316666666667] = {
		0.540554,
		-0.069117,
		0.838465,
		0,
		0.337834,
		0.930571,
		-0.14109,
		0,
		-0.770499,
		0.359529,
		0.526374,
		0,
		-0.093159,
		0.583071,
		-0.04759,
		1
	},
	[0.333333333333] = {
		0.505185,
		-0.058926,
		0.860997,
		0,
		0.708116,
		0.598589,
		-0.374517,
		0,
		-0.493315,
		0.798886,
		0.344124,
		0,
		-0.009176,
		0.639927,
		-0.069396,
		1
	},
	[0.35] = {
		0.484509,
		-0.046635,
		0.873542,
		0,
		0.862961,
		0.189116,
		-0.468544,
		0,
		-0.143351,
		0.980847,
		0.131873,
		0,
		0.073917,
		0.645078,
		-0.091142,
		1
	},
	[0.366666666667] = {
		0.514643,
		-0.045857,
		0.856178,
		0,
		0.854506,
		-0.054612,
		-0.516563,
		0,
		0.070446,
		0.997454,
		0.01108,
		0,
		0.159574,
		0.623355,
		-0.116047,
		1
	},
	[0.383333333333] = {
		0.512817,
		-0.040005,
		0.857565,
		0,
		0.833346,
		-0.216827,
		-0.508449,
		0,
		0.206284,
		0.97539,
		-0.077854,
		0,
		0.287488,
		0.567045,
		-0.171835,
		1
	},
	[0.3] = {
		0.557977,
		-0.021877,
		0.829568,
		0,
		-0.171752,
		0.974964,
		0.141233,
		0,
		-0.811889,
		-0.221284,
		0.54025,
		0,
		-0.162219,
		0.480592,
		-0.027409,
		1
	},
	[0.416666666667] = {
		0.552159,
		-0.169772,
		0.816271,
		0,
		0.534266,
		-0.679568,
		-0.502739,
		0,
		0.640062,
		0.713698,
		-0.284526,
		0,
		0.483254,
		0.354714,
		-0.266554,
		1
	},
	[0.433333333333] = {
		0.671717,
		-0.122997,
		0.730526,
		0,
		0.156737,
		-0.9402,
		-0.302419,
		0,
		0.724038,
		0.31764,
		-0.61227,
		0,
		0.52022,
		0.279112,
		-0.331813,
		1
	},
	[0.45] = {
		0.723942,
		-0.137892,
		0.67594,
		0,
		-0.153134,
		-0.987496,
		-0.037441,
		0,
		0.672651,
		-0.076404,
		-0.736005,
		0,
		0.444185,
		0.075522,
		-0.670389,
		1
	},
	[0.466666666667] = {
		0.689116,
		-0.131895,
		0.712546,
		0,
		-0.113259,
		-0.990816,
		-0.073869,
		0,
		0.715745,
		-0.029798,
		-0.697726,
		0,
		0.481029,
		0.066661,
		-0.462531,
		1
	},
	[0.483333333333] = {
		0.689437,
		-0.131463,
		0.712316,
		0,
		-0.111969,
		-0.990914,
		-0.074508,
		0,
		0.715639,
		-0.028389,
		-0.697893,
		0,
		0.480879,
		0.066342,
		-0.462619,
		1
	},
	[0.4] = {
		0.506745,
		-0.035853,
		0.86135,
		0,
		0.783638,
		-0.397296,
		-0.477563,
		0,
		0.359333,
		0.91699,
		-0.173232,
		0,
		0.41389,
		0.467426,
		-0.229934,
		1
	},
	[0.516666666667] = {
		0.69096,
		-0.130543,
		0.711008,
		0,
		-0.109791,
		-0.9911,
		-0.075274,
		0,
		0.714507,
		-0.026051,
		-0.699143,
		0,
		0.479986,
		0.065995,
		-0.463428,
		1
	},
	[0.533333333333] = {
		0.692083,
		-0.130076,
		0.710002,
		0,
		-0.108921,
		-0.991185,
		-0.075418,
		0,
		0.713553,
		-0.025139,
		-0.70015,
		0,
		0.479292,
		0.065924,
		-0.464099,
		1
	},
	[0.55] = {
		0.693394,
		-0.129616,
		0.708805,
		0,
		-0.108209,
		-0.991264,
		-0.075412,
		0,
		0.712388,
		-0.024409,
		-0.701362,
		0,
		0.478465,
		0.065892,
		-0.464912,
		1
	},
	[0.566666666667] = {
		0.694853,
		-0.129176,
		0.707455,
		0,
		-0.107664,
		-0.991334,
		-0.075264,
		0,
		0.711047,
		-0.02387,
		-0.70274,
		0,
		0.477531,
		0.065876,
		-0.465843,
		1
	},
	[0.583333333333] = {
		0.696423,
		-0.12881,
		0.705977,
		0,
		-0.107295,
		-0.991391,
		-0.075043,
		0,
		0.709565,
		-0.023486,
		-0.704248,
		0,
		0.476514,
		0.065884,
		-0.466863,
		1
	},
	[0.5] = {
		0.690065,
		-0.131009,
		0.711791,
		0,
		-0.11081,
		-0.99101,
		-0.074973,
		0,
		0.715214,
		-0.027138,
		-0.698378,
		0,
		0.480523,
		0.066127,
		-0.462926,
		1
	},
	[0.616666666667] = {
		0.699733,
		-0.128457,
		0.702761,
		0,
		-0.107122,
		-0.991446,
		-0.074566,
		0,
		0.706328,
		-0.023105,
		-0.707508,
		0,
		0.47433,
		0.065959,
		-0.469056,
		1
	},
	[0.633333333333] = {
		0.701395,
		-0.128484,
		0.701097,
		0,
		-0.107344,
		-0.991442,
		-0.074303,
		0,
		0.704643,
		-0.023143,
		-0.709184,
		0,
		0.473212,
		0.06611,
		-0.470177,
		1
	},
	[0.65] = {
		0.703011,
		-0.128647,
		0.699446,
		0,
		-0.107779,
		-0.991416,
		-0.074019,
		0,
		0.702964,
		-0.02335,
		-0.710842,
		0,
		0.472104,
		0.066486,
		-0.471278,
		1
	},
	[0.666666666667] = {
		0.704546,
		-0.128932,
		0.697847,
		0,
		-0.108411,
		-0.99137,
		-0.073711,
		0,
		0.701329,
		-0.023721,
		-0.712443,
		0,
		0.471032,
		0.067068,
		-0.472335,
		1
	},
	[0.683333333333] = {
		0.705964,
		-0.129327,
		0.69634,
		0,
		-0.109223,
		-0.991305,
		-0.073377,
		0,
		0.699775,
		-0.024255,
		-0.713952,
		0,
		0.470022,
		0.067836,
		-0.473325,
		1
	},
	[0.6] = {
		0.698062,
		-0.128569,
		0.7044,
		0,
		-0.107111,
		-0.991429,
		-0.074812,
		0,
		0.70798,
		-0.023226,
		-0.70585,
		0,
		0.475438,
		0.06592,
		-0.467942,
		1
	},
	[0.716666666667] = {
		0.708312,
		-0.130387,
		0.693754,
		0,
		-0.111322,
		-0.991128,
		-0.072619,
		0,
		0.697067,
		-0.025793,
		-0.716542,
		0,
		0.468294,
		0.069853,
		-0.475008,
		1
	},
	[0.733333333333] = {
		0.709171,
		-0.131025,
		0.692754,
		0,
		-0.112577,
		-0.991017,
		-0.072192,
		0,
		0.69599,
		-0.026791,
		-0.717551,
		0,
		0.46763,
		0.071063,
		-0.475657,
		1
	},
	[0.75] = {
		0.709776,
		-0.131716,
		0.692004,
		0,
		-0.113947,
		-0.990894,
		-0.071733,
		0,
		0.695151,
		-0.027937,
		-0.718321,
		0,
		0.467134,
		0.072382,
		-0.476146,
		1
	},
	[0.766666666667] = {
		0.71009,
		-0.132447,
		0.691542,
		0,
		-0.115417,
		-0.990759,
		-0.071241,
		0,
		0.694587,
		-0.029228,
		-0.718815,
		0,
		0.466835,
		0.073789,
		-0.476453,
		1
	},
	[0.783333333333] = {
		0.71008,
		-0.133203,
		0.691407,
		0,
		-0.11697,
		-0.990614,
		-0.070717,
		0,
		0.694338,
		-0.030659,
		-0.718996,
		0,
		0.466758,
		0.075266,
		-0.476556,
		1
	},
	[0.7] = {
		0.707231,
		-0.129816,
		0.694962,
		0,
		-0.110198,
		-0.991224,
		-0.073013,
		0,
		0.698341,
		-0.024947,
		-0.71533,
		0,
		0.4691,
		0.068771,
		-0.474223,
		1
	},
	[0.816666666667] = {
		0.709224,
		-0.134726,
		0.69199,
		0,
		-0.12028,
		-0.990302,
		-0.069529,
		0,
		0.694646,
		-0.03392,
		-0.718551,
		0,
		0.467182,
		0.078358,
		-0.476244,
		1
	},
	[0.833333333333] = {
		0.708471,
		-0.135459,
		0.692618,
		0,
		-0.122014,
		-0.990138,
		-0.06884,
		0,
		0.695112,
		-0.035738,
		-0.718012,
		0,
		0.467623,
		0.079937,
		-0.475892,
		1
	},
	[0.85] = {
		0.707535,
		-0.136152,
		0.693439,
		0,
		-0.123785,
		-0.989971,
		-0.068073,
		0,
		0.695753,
		-0.037674,
		-0.717293,
		0,
		0.468194,
		0.081515,
		-0.475433,
		1
	},
	[0.866666666667] = {
		0.706442,
		-0.136789,
		0.694427,
		0,
		-0.125581,
		-0.989804,
		-0.067219,
		0,
		0.696541,
		-0.039721,
		-0.716417,
		0,
		0.468877,
		0.083072,
		-0.474885,
		1
	},
	[0.883333333333] = {
		0.705218,
		-0.137353,
		0.695559,
		0,
		-0.127388,
		-0.989637,
		-0.066267,
		0,
		0.697453,
		-0.041873,
		-0.715407,
		0,
		0.469655,
		0.084592,
		-0.474266,
		1
	},
	[0.8] = {
		0.709769,
		-0.133968,
		0.691578,
		0,
		-0.118594,
		-0.990462,
		-0.070152,
		0,
		0.69438,
		-0.032225,
		-0.718887,
		0,
		0.466888,
		0.076795,
		-0.476472,
		1
	},
	[0.916666666667] = {
		0.702482,
		-0.138197,
		0.698155,
		0,
		-0.130991,
		-0.989314,
		-0.064028,
		0,
		0.699543,
		-0.046473,
		-0.713077,
		0,
		0.471423,
		0.087446,
		-0.472887,
		1
	},
	[0.933333333333] = {
		0.701022,
		-0.138445,
		0.699572,
		0,
		-0.132761,
		-0.989162,
		-0.062718,
		0,
		0.700673,
		-0.048909,
		-0.711805,
		0,
		0.472377,
		0.088745,
		-0.472162,
		1
	},
	[0.95] = {
		0.699538,
		-0.138555,
		0.701034,
		0,
		-0.134495,
		-0.989019,
		-0.061266,
		0,
		0.701825,
		-0.051428,
		-0.710491,
		0,
		0.473354,
		0.089933,
		-0.471439,
		1
	},
	[0.966666666667] = {
		0.698055,
		-0.138511,
		0.70252,
		0,
		-0.136179,
		-0.988886,
		-0.059659,
		0,
		0.702975,
		-0.054024,
		-0.709159,
		0,
		0.474334,
		0.090994,
		-0.470735,
		1
	},
	[0.983333333333] = {
		0.696601,
		-0.138306,
		0.704002,
		0,
		-0.137803,
		-0.988766,
		-0.057895,
		0,
		0.7041,
		-0.056683,
		-0.707835,
		0,
		0.475298,
		0.091914,
		-0.470067,
		1
	},
	[0.9] = {
		0.703889,
		-0.137828,
		0.69681,
		0,
		-0.129196,
		-0.989473,
		-0.065207,
		0,
		0.698462,
		-0.044126,
		-0.714286,
		0,
		0.47051,
		0.086056,
		-0.473594,
		1
	},
	[1.01666666667] = {
		0.693891,
		-0.137464,
		0.706838,
		0,
		-0.140817,
		-0.988561,
		-0.054015,
		0,
		0.706177,
		-0.062055,
		-0.705311,
		0,
		0.477107,
		0.093337,
		-0.468895,
		1
	},
	[1.03333333333] = {
		0.692689,
		-0.136861,
		0.708132,
		0,
		-0.142185,
		-0.988475,
		-0.05196,
		0,
		0.707082,
		-0.064694,
		-0.704166,
		0,
		0.477913,
		0.093845,
		-0.468419,
		1
	},
	[1.05] = {
		0.691628,
		-0.13616,
		0.709303,
		0,
		-0.143443,
		-0.988401,
		-0.049868,
		0,
		0.707867,
		-0.067255,
		-0.703137,
		0,
		0.478628,
		0.094218,
		-0.468034,
		1
	},
	[1.06666666667] = {
		0.690734,
		-0.135378,
		0.710323,
		0,
		-0.14458,
		-0.988339,
		-0.047771,
		0,
		0.708507,
		-0.069702,
		-0.702253,
		0,
		0.479232,
		0.09446,
		-0.467752,
		1
	},
	[1.08333333333] = {
		0.690037,
		-0.134532,
		0.711161,
		0,
		-0.145584,
		-0.98829,
		-0.045698,
		0,
		0.708981,
		-0.072001,
		-0.701542,
		0,
		0.479708,
		0.094572,
		-0.467587,
		1
	},
	[1.11666666667] = {
		0.689343,
		-0.132725,
		0.712173,
		0,
		-0.147145,
		-0.988234,
		-0.041746,
		0,
		0.709334,
		-0.076016,
		-0.700762,
		0,
		0.480194,
		0.094409,
		-0.467661,
		1
	},
	[1.13333333333] = {
		0.68927,
		-0.1318,
		0.712415,
		0,
		-0.14767,
		-0.988229,
		-0.039955,
		0,
		0.709296,
		-0.077663,
		-0.70062,
		0,
		0.480254,
		0.094139,
		-0.467836,
		1
	},
	[1.15] = {
		0.689225,
		-0.130882,
		0.712628,
		0,
		-0.147994,
		-0.988244,
		-0.038368,
		0,
		0.709272,
		-0.079021,
		-0.700492,
		0,
		0.48029,
		0.093744,
		-0.46799,
		1
	},
	[1.16666666667] = {
		0.689209,
		-0.129989,
		0.712807,
		0,
		-0.148106,
		-0.988278,
		-0.037022,
		0,
		0.709264,
		-0.080055,
		-0.700383,
		0,
		0.480303,
		0.093229,
		-0.468118,
		1
	},
	[1.1] = {
		0.689564,
		-0.133642,
		0.711788,
		0,
		-0.146443,
		-0.988254,
		-0.043679,
		0,
		0.709264,
		-0.074117,
		-0.701035,
		0,
		0.480035,
		0.094555,
		-0.467553,
		1
	}
}

return spline_matrices
