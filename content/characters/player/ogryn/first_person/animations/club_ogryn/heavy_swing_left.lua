local spline_matrices = {
	[0] = {
		0.284056,
		0.454565,
		-0.844206,
		0,
		0.785262,
		-0.615506,
		-0.067198,
		0,
		-0.55016,
		-0.643835,
		-0.531791,
		0,
		1.736476,
		-0.619697,
		-0.249378,
		1
	},
	{
		0.137135,
		-0.109551,
		-0.984476,
		0,
		0.989338,
		-0.034045,
		0.1416,
		0,
		-0.049029,
		-0.993398,
		0.103714,
		0,
		0.461882,
		-1.274509,
		-1.086686,
		1
	},
	[0.0166666666667] = {
		0.339199,
		0.475043,
		-0.811959,
		0,
		0.802924,
		-0.595935,
		-0.013231,
		0,
		-0.49016,
		-0.647453,
		-0.583564,
		0,
		1.73413,
		-0.621421,
		-0.237909,
		1
	},
	[0.0333333333333] = {
		0.399883,
		0.497281,
		-0.769938,
		0,
		0.815181,
		-0.576981,
		0.050725,
		0,
		-0.419015,
		-0.647923,
		-0.636099,
		0,
		1.726359,
		-0.630686,
		-0.220045,
		1
	},
	[0.05] = {
		0.461633,
		0.520259,
		-0.718488,
		0,
		0.820143,
		-0.558956,
		0.122206,
		0,
		-0.338025,
		-0.645677,
		-0.684719,
		0,
		1.713522,
		-0.645659,
		-0.196901,
		1
	},
	[0.0666666666667] = {
		0.520288,
		0.543034,
		-0.659101,
		0,
		0.816702,
		-0.541966,
		0.19817,
		0,
		-0.249597,
		-0.641394,
		-0.725476,
		0,
		1.696075,
		-0.664479,
		-0.169534,
		1
	},
	[0.0833333333333] = {
		0.572342,
		0.564854,
		-0.594445,
		0,
		0.804827,
		-0.525823,
		0.275254,
		0,
		-0.157094,
		-0.635964,
		-0.75556,
		0,
		1.674777,
		-0.685161,
		-0.138951,
		1
	},
	[0.116666666667] = {
		0.64755,
		0.603989,
		-0.464625,
		0,
		0.761638,
		-0.493629,
		0.419807,
		0,
		0.024206,
		-0.625722,
		-0.77967,
		0,
		1.625883,
		-0.723328,
		-0.071762,
		1
	},
	[0.133333333333] = {
		0.668837,
		0.621196,
		-0.408378,
		0,
		0.735931,
		-0.475543,
		0.481938,
		0,
		0.105176,
		-0.622876,
		-0.775218,
		0,
		1.602164,
		-0.735978,
		-0.036699,
		1
	},
	[0.15] = {
		0.679428,
		0.637083,
		-0.364008,
		0,
		0.712493,
		-0.454316,
		0.534743,
		0,
		0.175301,
		-0.622673,
		-0.762593,
		0,
		1.582285,
		-0.740783,
		-0.001504,
		1
	},
	[0.166666666667] = {
		0.679917,
		0.651852,
		-0.335861,
		0,
		0.69557,
		-0.428312,
		0.576828,
		0,
		0.232153,
		-0.62581,
		-0.744625,
		0,
		1.569213,
		-0.734693,
		0.033267,
		1
	},
	[0.183333333333] = {
		0.670564,
		0.66542,
		-0.327965,
		0,
		0.689424,
		-0.395725,
		0.606709,
		0,
		0.273932,
		-0.632944,
		-0.724115,
		0,
		1.566126,
		-0.714116,
		0.066995,
		1
	},
	[0.1] = {
		0.615246,
		0.585234,
		-0.52818,
		0,
		0.785695,
		-0.509999,
		0.350121,
		0,
		-0.064469,
		-0.630399,
		-0.77359,
		0,
		1.650817,
		-0.705554,
		-0.106084,
		1
	},
	[0.216666666667] = {
		0.610451,
		0.691839,
		-0.385626,
		0,
		0.744133,
		-0.334175,
		0.57844,
		0,
		0.271321,
		-0.640067,
		-0.718818,
		0,
		1.57872,
		-0.541579,
		0.098837,
		1
	},
	[0.233333333333] = {
		0.558976,
		0.700794,
		-0.443208,
		0,
		0.793646,
		-0.29737,
		0.530752,
		0,
		0.240151,
		-0.648428,
		-0.722405,
		0,
		1.609914,
		-0.411083,
		0.097749,
		1
	},
	[0.25] = {
		0.494462,
		0.701279,
		-0.513533,
		0,
		0.843158,
		-0.243448,
		0.479393,
		0,
		0.211169,
		-0.670031,
		-0.711664,
		0,
		1.644041,
		-0.266208,
		0.090348,
		1
	},
	[0.266666666667] = {
		0.41886,
		0.686063,
		-0.594873,
		0,
		0.884972,
		-0.161659,
		0.436682,
		0,
		0.203425,
		-0.709354,
		-0.674859,
		0,
		1.669016,
		-0.116286,
		0.079747,
		1
	},
	[0.283333333333] = {
		0.336395,
		0.643349,
		-0.687707,
		0,
		0.911184,
		-0.037903,
		0.410252,
		0,
		0.237869,
		-0.764635,
		-0.59896,
		0,
		1.672685,
		0.030223,
		0.068268,
		1
	},
	[0.2] = {
		0.647968,
		0.678961,
		-0.345179,
		0,
		0.705254,
		-0.363667,
		0.608574,
		0,
		0.287668,
		-0.637775,
		-0.714485,
		0,
		1.563156,
		-0.648088,
		0.090129,
		1
	},
	[0.316666666667] = {
		0.166483,
		0.310077,
		-0.936021,
		0,
		0.847426,
		0.44034,
		0.296597,
		0,
		0.504135,
		-0.842587,
		-0.189459,
		0,
		1.632996,
		0.385287,
		0.021807,
		1
	},
	[0.333333333333] = {
		0.115286,
		0.120819,
		-0.985957,
		0,
		0.743471,
		0.647759,
		0.166309,
		0,
		0.658756,
		-0.752204,
		-0.015148,
		0,
		1.600294,
		0.564612,
		-0.030602,
		1
	},
	[0.35] = {
		0.071218,
		0.009966,
		-0.997411,
		0,
		0.616148,
		0.785922,
		0.051847,
		0,
		0.784404,
		-0.618246,
		0.049831,
		0,
		1.528761,
		0.715809,
		-0.091446,
		1
	},
	[0.366666666667] = {
		0.057146,
		-0.047457,
		-0.997237,
		0,
		0.438468,
		0.898574,
		-0.017636,
		0,
		0.896928,
		-0.436249,
		0.072158,
		0,
		1.411024,
		0.877506,
		-0.133416,
		1
	},
	[0.383333333333] = {
		0.028354,
		-0.088076,
		-0.99571,
		0,
		0.243378,
		0.966743,
		-0.078583,
		0,
		0.969517,
		-0.240105,
		0.048847,
		0,
		1.286078,
		1.056812,
		-0.149287,
		1
	},
	[0.3] = {
		0.245378,
		0.520695,
		-0.81772,
		0,
		0.906714,
		0.175192,
		0.383638,
		0,
		0.343016,
		-0.835574,
		-0.429134,
		0,
		1.657953,
		0.195166,
		0.054097,
		1
	},
	[0.416666666667] = {
		0.035685,
		-0.172414,
		-0.984378,
		0,
		-0.26631,
		0.947748,
		-0.175652,
		0,
		0.963227,
		0.268418,
		-0.012095,
		0,
		0.975303,
		1.32137,
		-0.159916,
		1
	},
	[0.433333333333] = {
		0.063691,
		-0.108593,
		-0.992044,
		0,
		-0.578673,
		0.805867,
		-0.125365,
		0,
		0.813069,
		0.582054,
		-0.011513,
		0,
		0.722557,
		1.391323,
		-0.154807,
		1
	},
	[0.45] = {
		0.020906,
		0.021326,
		-0.999554,
		0,
		-0.842688,
		0.538368,
		-0.006139,
		0,
		0.537997,
		0.84244,
		0.029226,
		0,
		0.402963,
		1.414263,
		-0.13676,
		1
	},
	[0.466666666667] = {
		-0.058721,
		0.07781,
		-0.995237,
		0,
		-0.990028,
		0.123338,
		0.068057,
		0,
		0.128046,
		0.98931,
		0.069791,
		0,
		0.020627,
		1.355613,
		-0.144261,
		1
	},
	[0.483333333333] = {
		-0.003368,
		0.058786,
		-0.998265,
		0,
		-0.875329,
		-0.482856,
		-0.025481,
		0,
		-0.483516,
		0.873724,
		0.053083,
		0,
		-0.639562,
		1.11721,
		-0.283107,
		1
	},
	[0.4] = {
		0.016555,
		-0.134189,
		-0.990818,
		0,
		0.017802,
		0.990836,
		-0.133894,
		0,
		0.999704,
		-0.015422,
		0.018792,
		0,
		1.151778,
		1.211673,
		-0.152322,
		1
	},
	[0.516666666667] = {
		0.055323,
		-0.015958,
		-0.998341,
		0,
		0.481409,
		-0.875552,
		0.040673,
		0,
		-0.874748,
		-0.482861,
		-0.040755,
		0,
		-0.726773,
		-0.178923,
		-0.378191,
		1
	},
	[0.533333333333] = {
		0.113097,
		-0.084115,
		-0.990017,
		0,
		0.883631,
		-0.447095,
		0.13893,
		0,
		-0.454318,
		-0.890523,
		0.023761,
		0,
		-0.403689,
		-0.765055,
		-0.344471,
		1
	},
	[0.55] = {
		0.124601,
		-0.073763,
		-0.989461,
		0,
		0.933805,
		-0.328366,
		0.142072,
		0,
		-0.335385,
		-0.941666,
		0.027965,
		0,
		-0.418956,
		-0.779544,
		-0.362774,
		1
	},
	[0.566666666667] = {
		0.143722,
		-0.079985,
		-0.98638,
		0,
		0.963394,
		-0.216626,
		0.157939,
		0,
		-0.226308,
		-0.972973,
		0.045923,
		0,
		-0.388063,
		-0.810043,
		-0.372023,
		1
	},
	[0.583333333333] = {
		0.158318,
		-0.083691,
		-0.983835,
		0,
		0.978827,
		-0.117625,
		0.167518,
		0,
		-0.129744,
		-0.989525,
		0.063297,
		0,
		-0.348602,
		-0.85433,
		-0.379016,
		1
	},
	[0.5] = {
		0.064577,
		0.080078,
		-0.994695,
		0,
		-0.347678,
		-0.932516,
		-0.097644,
		0,
		-0.935387,
		0.352139,
		-0.032378,
		0,
		-1.110268,
		0.661259,
		-0.418583,
		1
	},
	[0.616666666667] = {
		0.172838,
		-0.086528,
		-0.981142,
		0,
		0.984709,
		-0.006859,
		0.174072,
		0,
		-0.021791,
		-0.996226,
		0.084019,
		0,
		-0.312919,
		-0.908875,
		-0.408837,
		1
	},
	[0.633333333333] = {
		0.176663,
		-0.087444,
		-0.980379,
		0,
		0.984218,
		0.026075,
		0.175029,
		0,
		0.010258,
		-0.995828,
		0.090671,
		0,
		-0.299636,
		-0.935624,
		-0.432812,
		1
	},
	[0.65] = {
		0.1794,
		-0.088336,
		-0.979802,
		0,
		0.983109,
		0.05278,
		0.175247,
		0,
		0.036233,
		-0.994691,
		0.096313,
		0,
		-0.283423,
		-0.967906,
		-0.461478,
		1
	},
	[0.666666666667] = {
		0.181135,
		-0.089264,
		-0.979399,
		0,
		0.981829,
		0.073719,
		0.174866,
		0,
		0.056591,
		-0.993276,
		0.100995,
		0,
		-0.265144,
		-1.00594,
		-0.49477,
		1
	},
	[0.683333333333] = {
		0.181956,
		-0.090263,
		-0.979155,
		0,
		0.980682,
		0.089364,
		0.174002,
		0,
		0.071795,
		-0.991901,
		0.10478,
		0,
		-0.24385,
		-1.047191,
		-0.532205,
		1
	},
	[0.6] = {
		0.167848,
		-0.085502,
		-0.982098,
		0,
		0.983964,
		-0.046449,
		0.172211,
		0,
		-0.060342,
		-0.995255,
		0.076335,
		0,
		-0.322587,
		-0.887715,
		-0.389788,
		1
	},
	[0.716666666667] = {
		0.181206,
		-0.092542,
		-0.979081,
		0,
		0.97945,
		0.106634,
		0.171195,
		0,
		0.088561,
		-0.989982,
		0.109963,
		0,
		-0.187622,
		-1.127775,
		-0.617042,
		1
	},
	[0.733333333333] = {
		0.179807,
		-0.093819,
		-0.979218,
		0,
		0.979484,
		0.109162,
		0.169397,
		0,
		0.091001,
		-0.989587,
		0.111522,
		0,
		-0.152178,
		-1.163365,
		-0.663233,
		1
	},
	[0.75] = {
		0.177839,
		-0.095171,
		-0.979447,
		0,
		0.979931,
		0.108201,
		0.167413,
		0,
		0.090044,
		-0.989563,
		0.112503,
		0,
		-0.111942,
		-1.193415,
		-0.710731,
		1
	},
	[0.766666666667] = {
		0.175384,
		-0.096577,
		-0.979752,
		0,
		0.980727,
		0.104178,
		0.16529,
		0,
		0.086105,
		-0.989858,
		0.112987,
		0,
		-0.067127,
		-1.218916,
		-0.758856,
		1
	},
	[0.783333333333] = {
		0.172527,
		-0.098013,
		-0.980116,
		0,
		0.981784,
		0.097513,
		0.163069,
		0,
		0.079591,
		-0.990396,
		0.113052,
		0,
		-0.018065,
		-1.241273,
		-0.806784,
		1
	},
	[0.7] = {
		0.181951,
		-0.091354,
		-0.979055,
		0,
		0.979857,
		0.100183,
		0.172752,
		0,
		0.082303,
		-0.990766,
		0.107743,
		0,
		-0.218125,
		-1.088425,
		-0.573125,
		1
	},
	[0.816666666667] = {
		0.165936,
		-0.100869,
		-0.980964,
		0,
		0.984281,
		0.07794,
		0.158483,
		0,
		0.060471,
		-0.991842,
		0.112216,
		0,
		0.088644,
		-1.273953,
		-0.896647,
		1
	},
	[0.833333333333] = {
		0.16237,
		-0.102235,
		-0.981419,
		0,
		0.985528,
		0.06588,
		0.156187,
		0,
		0.048688,
		-0.992576,
		0.111452,
		0,
		0.143499,
		-1.283818,
		-0.936122,
		1
	},
	[0.85] = {
		0.158736,
		-0.103529,
		-0.981878,
		0,
		0.986665,
		0.052874,
		0.153934,
		0,
		0.03598,
		-0.99322,
		0.110541,
		0,
		0.19731,
		-1.289517,
		-0.970655,
		1
	},
	[0.866666666667] = {
		0.155119,
		-0.104728,
		-0.982329,
		0,
		0.987633,
		0.039359,
		0.15176,
		0,
		0.02277,
		-0.993722,
		0.109539,
		0,
		0.248528,
		-1.291685,
		-0.999852,
		1
	},
	[0.883333333333] = {
		0.151605,
		-0.105818,
		-0.982761,
		0,
		0.988396,
		0.025773,
		0.149699,
		0,
		0.009488,
		-0.994051,
		0.108497,
		0,
		0.295767,
		-1.291403,
		-1.023983,
		1
	},
	[0.8] = {
		0.16935,
		-0.099453,
		-0.980525,
		0,
		0.983002,
		0.088626,
		0.160788,
		0,
		0.070909,
		-0.991088,
		0.112771,
		0,
		0.034287,
		-1.259755,
		-0.853156,
		1
	},
	[0.916666666667] = {
		0.145232,
		-0.107611,
		-0.983528,
		0,
		0.989275,
		0.000161,
		0.146063,
		0,
		-0.01556,
		-0.994193,
		0.106481,
		0,
		0.37474,
		-1.286475,
		-1.058361,
		1
	},
	[0.933333333333] = {
		0.142545,
		-0.108299,
		-0.983846,
		0,
		0.989435,
		-0.010976,
		0.144563,
		0,
		-0.026455,
		-0.994058,
		0.10559,
		0,
		0.405352,
		-1.283096,
		-1.069575,
		1
	},
	[0.95] = {
		0.140306,
		-0.10884,
		-0.984108,
		0,
		0.989465,
		-0.020408,
		0.143327,
		0,
		-0.035683,
		-0.99385,
		0.10483,
		0,
		0.429603,
		-1.279872,
		-1.077605,
		1
	},
	[0.966666666667] = {
		0.138601,
		-0.109232,
		-0.984306,
		0,
		0.989423,
		-0.027691,
		0.142394,
		0,
		-0.04281,
		-0.993631,
		0.104238,
		0,
		0.447281,
		-1.277197,
		-1.082939,
		1
	},
	[0.983333333333] = {
		0.137515,
		-0.10947,
		-0.984432,
		0,
		0.989365,
		-0.032383,
		0.141806,
		0,
		-0.047403,
		-0.993462,
		0.103853,
		0,
		0.458153,
		-1.275348,
		-1.085916,
		1
	},
	[0.9] = {
		0.14828,
		-0.106782,
		-0.983164,
		0,
		0.988939,
		0.012559,
		0.147788,
		0,
		-0.003433,
		-0.994203,
		0.107463,
		0,
		0.338059,
		-1.289465,
		-1.043364,
		1
	}
}

return spline_matrices
