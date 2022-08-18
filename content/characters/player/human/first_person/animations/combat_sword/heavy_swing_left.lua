local spline_matrices = {
	[0] = {
		0.27135,
		-0.121857,
		-0.954735,
		0,
		0.721674,
		0.682093,
		0.118052,
		0,
		0.636833,
		-0.721041,
		0.273027,
		0,
		0.445058,
		0.190068,
		-0.02647,
		1
	},
	{
		0.815519,
		-0.418009,
		-0.400246,
		0,
		-0.578335,
		-0.614189,
		-0.536937,
		0,
		-0.021382,
		0.669359,
		-0.742632,
		0,
		-0.00282,
		0.00237,
		-0.594647,
		1
	},
	[0.0166666666667] = {
		0.312202,
		-0.083461,
		-0.946343,
		0,
		0.641828,
		0.75295,
		0.145336,
		0,
		0.700419,
		-0.652763,
		0.28864,
		0,
		0.443274,
		0.222886,
		-0.014878,
		1
	},
	[0.0333333333333] = {
		0.357425,
		-0.025877,
		-0.933583,
		0,
		0.552645,
		0.811684,
		0.189083,
		0,
		0.752882,
		-0.583523,
		0.304417,
		0,
		0.434949,
		0.254989,
		-0.012374,
		1
	},
	[0.05] = {
		0.404881,
		0.061314,
		-0.912311,
		0,
		0.467536,
		0.843573,
		0.264185,
		0,
		0.7858,
		-0.533502,
		0.31288,
		0,
		0.415937,
		0.284713,
		-0.010196,
		1
	},
	[0.0666666666667] = {
		0.402021,
		0.153098,
		-0.90274,
		0,
		0.317048,
		0.901655,
		0.294107,
		0,
		0.858988,
		-0.404449,
		0.313945,
		0,
		0.372099,
		0.326922,
		-0.01572,
		1
	},
	[0.0833333333333] = {
		0.300695,
		0.212493,
		-0.929747,
		0,
		0.072083,
		0.967011,
		0.244322,
		0,
		0.950992,
		-0.140486,
		0.275458,
		0,
		0.301817,
		0.397692,
		-0.03357,
		1
	},
	[0.116666666667] = {
		0.033787,
		0.141712,
		-0.989331,
		0,
		-0.675477,
		0.732818,
		0.0819,
		0,
		0.736606,
		0.665504,
		0.120483,
		0,
		-0.014978,
		0.505278,
		-0.085234,
		1
	},
	[0.133333333333] = {
		-0.052377,
		0.084817,
		-0.995019,
		0,
		-0.986838,
		-0.157049,
		0.038559,
		0,
		-0.152996,
		0.983942,
		0.091927,
		0,
		-0.382344,
		0.40723,
		-0.114221,
		1
	},
	[0.15] = {
		0.083405,
		0.192209,
		-0.977803,
		0,
		-0.72837,
		-0.657894,
		-0.191452,
		0,
		-0.680089,
		0.72817,
		0.085128,
		0,
		-0.474426,
		0.274448,
		-0.147944,
		1
	},
	[0.166666666667] = {
		0.052649,
		0.182108,
		-0.981868,
		0,
		-0.585786,
		-0.790665,
		-0.178056,
		0,
		-0.808754,
		0.584538,
		0.065049,
		0,
		-0.503562,
		0.179097,
		-0.162775,
		1
	},
	[0.183333333333] = {
		-0.022261,
		0.104444,
		-0.994282,
		0,
		-0.561027,
		-0.824479,
		-0.074046,
		0,
		-0.827498,
		0.55617,
		0.07695,
		0,
		-0.518093,
		0.099117,
		-0.169837,
		1
	},
	[0.1] = {
		0.142037,
		0.218124,
		-0.96553,
		0,
		-0.257551,
		0.949967,
		0.17672,
		0,
		0.955768,
		0.223573,
		0.191109,
		0,
		0.18638,
		0.47347,
		-0.057835,
		1
	},
	[0.216666666667] = {
		-0.046559,
		0.028209,
		-0.998517,
		0,
		-0.397245,
		-0.917683,
		-0.007402,
		0,
		-0.916531,
		0.396311,
		0.053933,
		0,
		-0.510511,
		-0.009049,
		-0.196778,
		1
	},
	[0.233333333333] = {
		-0.002102,
		0.039031,
		-0.999236,
		0,
		-0.25148,
		-0.967145,
		-0.037248,
		0,
		-0.96786,
		0.25121,
		0.011849,
		0,
		-0.497901,
		-0.036959,
		-0.215785,
		1
	},
	[0.25] = {
		0.054032,
		0.066833,
		-0.9963,
		0,
		-0.098248,
		-0.99256,
		-0.07191,
		0,
		-0.993694,
		0.10177,
		-0.047063,
		0,
		-0.481301,
		-0.060121,
		-0.235222,
		1
	},
	[0.266666666667] = {
		0.11177,
		0.098666,
		-0.988824,
		0,
		0.03726,
		-0.994775,
		-0.095049,
		0,
		-0.993035,
		-0.02622,
		-0.114862,
		0,
		-0.461996,
		-0.090723,
		-0.253522,
		1
	},
	[0.283333333333] = {
		0.184496,
		0.132495,
		-0.973862,
		0,
		0.129604,
		-0.985498,
		-0.109525,
		0,
		-0.974251,
		-0.106009,
		-0.198992,
		0,
		-0.442181,
		-0.139135,
		-0.271104,
		1
	},
	[0.2] = {
		-0.065789,
		0.041972,
		-0.99695,
		0,
		-0.516037,
		-0.856564,
		-0.002008,
		0,
		-0.854036,
		0.514331,
		0.078011,
		0,
		-0.518762,
		0.035005,
		-0.17994,
		1
	},
	[0.316666666667] = {
		0.295034,
		0.151335,
		-0.943426,
		0,
		0.109239,
		-0.986246,
		-0.124042,
		0,
		-0.949222,
		-0.066462,
		-0.307508,
		0,
		-0.383198,
		-0.162189,
		-0.307082,
		1
	},
	[0.333333333333] = {
		0.388072,
		0.138654,
		-0.911139,
		0,
		0.031947,
		-0.990048,
		-0.137055,
		0,
		-0.921075,
		0.024079,
		-0.38864,
		0,
		-0.341408,
		-0.153994,
		-0.337015,
		1
	},
	[0.35] = {
		0.490826,
		0.107073,
		-0.864653,
		0,
		-0.068377,
		-0.984625,
		-0.160744,
		0,
		-0.86857,
		0.13802,
		-0.475958,
		0,
		-0.2938,
		-0.138652,
		-0.374019,
		1
	},
	[0.366666666667] = {
		0.592549,
		0.05339,
		-0.803763,
		0,
		-0.182133,
		-0.963082,
		-0.198244,
		0,
		-0.784674,
		0.263861,
		-0.560949,
		0,
		-0.242764,
		-0.117553,
		-0.415714,
		1
	},
	[0.383333333333] = {
		0.681399,
		-0.0212,
		-0.731606,
		0,
		-0.296685,
		-0.921776,
		-0.249614,
		0,
		-0.669084,
		0.387143,
		-0.634386,
		0,
		-0.19059,
		-0.092475,
		-0.459434,
		1
	},
	[0.3] = {
		0.219477,
		0.150368,
		-0.96396,
		0,
		0.157299,
		-0.980578,
		-0.117146,
		0,
		-0.962854,
		-0.125919,
		-0.238867,
		0,
		-0.416543,
		-0.162006,
		-0.28643,
		1
	},
	[0.416666666667] = {
		0.789011,
		-0.203354,
		-0.579748,
		0,
		-0.48046,
		-0.792347,
		-0.375959,
		0,
		-0.382909,
		0.575181,
		-0.722874,
		0,
		-0.093299,
		-0.039832,
		-0.541034,
		1
	},
	[0.433333333333] = {
		0.807291,
		-0.289849,
		-0.51407,
		0,
		-0.537267,
		-0.721381,
		-0.436982,
		0,
		-0.244182,
		0.628965,
		-0.738091,
		0,
		-0.054782,
		-0.01754,
		-0.572805,
		1
	},
	[0.45] = {
		0.810389,
		-0.36099,
		-0.461472,
		0,
		-0.571708,
		-0.659488,
		-0.488084,
		0,
		-0.128142,
		0.659365,
		-0.740822,
		0,
		-0.028252,
		-0.001244,
		-0.594711,
		1
	},
	[0.466666666667] = {
		0.807166,
		-0.411086,
		-0.423664,
		0,
		-0.588636,
		-0.61472,
		-0.525002,
		0,
		-0.044613,
		0.673148,
		-0.738161,
		0,
		-0.017863,
		0.00679,
		-0.604136,
		1
	},
	[0.483333333333] = {
		0.802422,
		-0.446793,
		-0.395593,
		0,
		-0.596538,
		-0.58263,
		-0.551983,
		0,
		0.016138,
		0.67891,
		-0.734044,
		0,
		-0.016796,
		0.009747,
		-0.606263,
		1
	},
	[0.4] = {
		0.748054,
		-0.110192,
		-0.654426,
		0,
		-0.399191,
		-0.862483,
		-0.311077,
		0,
		-0.530153,
		0.493943,
		-0.689172,
		0,
		-0.13977,
		-0.065688,
		-0.502234,
		1
	},
	[0.516666666667] = {
		0.789158,
		-0.503966,
		-0.351066,
		0,
		-0.603504,
		-0.530107,
		-0.595625,
		0,
		0.114072,
		0.681912,
		-0.722484,
		0,
		-0.014244,
		0.014322,
		-0.609342,
		1
	},
	[0.533333333333] = {
		0.782104,
		-0.526203,
		-0.333802,
		0,
		-0.604215,
		-0.509323,
		-0.612793,
		0,
		0.152441,
		0.680956,
		-0.716283,
		0,
		-0.012893,
		0.016024,
		-0.610383,
		1
	},
	[0.55] = {
		0.775418,
		-0.544724,
		-0.319378,
		0,
		-0.603874,
		-0.491878,
		-0.62721,
		0,
		0.184561,
		0.679214,
		-0.710356,
		0,
		-0.011554,
		0.017387,
		-0.611143,
		1
	},
	[0.566666666667] = {
		0.769405,
		-0.559889,
		-0.307474,
		0,
		-0.602901,
		-0.477524,
		-0.639126,
		0,
		0.211013,
		0.677123,
		-0.704967,
		0,
		-0.010257,
		0.018448,
		-0.611658,
		1
	},
	[0.583333333333] = {
		0.764262,
		-0.572026,
		-0.29781,
		0,
		-0.601604,
		-0.466014,
		-0.648771,
		0,
		0.23233,
		0.674995,
		-0.700289,
		0,
		-0.009024,
		0.01924,
		-0.611958,
		1
	},
	[0.5] = {
		0.796138,
		-0.477628,
		-0.371532,
		0,
		-0.601186,
		-0.554473,
		-0.575443,
		0,
		0.068844,
		0.681492,
		-0.72858,
		0,
		-0.015564,
		0.012244,
		-0.607983,
		1
	},
	[0.616666666667] = {
		0.756988,
		-0.588349,
		-0.284279,
		0,
		-0.598856,
		-0.450615,
		-0.662055,
		0,
		0.261419,
		0.67141,
		-0.693447,
		0,
		-0.00681,
		0.020128,
		-0.612018,
		1
	},
	[0.633333333333] = {
		0.754922,
		-0.59302,
		-0.280034,
		0,
		-0.597658,
		-0.44631,
		-0.666042,
		0,
		0.269994,
		0.670174,
		-0.691353,
		0,
		-0.005845,
		0.020273,
		-0.611822,
		1
	},
	[0.65] = {
		0.753881,
		-0.59564,
		-0.277267,
		0,
		-0.596668,
		-0.44402,
		-0.668456,
		0,
		0.275047,
		0.669373,
		-0.690137,
		0,
		-0.004982,
		0.020246,
		-0.611501,
		1
	},
	[0.666666666667] = {
		0.753812,
		-0.596382,
		-0.275854,
		0,
		-0.595911,
		-0.443576,
		-0.669426,
		0,
		0.276871,
		0.669006,
		-0.689763,
		0,
		-0.004221,
		0.020065,
		-0.61107,
		1
	},
	[0.683333333333] = {
		0.754644,
		-0.595404,
		-0.275692,
		0,
		-0.595387,
		-0.444823,
		-0.669064,
		0,
		0.27573,
		0.669049,
		-0.690179,
		0,
		-0.003564,
		0.019745,
		-0.610545,
		1
	},
	[0.6] = {
		0.760104,
		-0.581426,
		-0.290147,
		0,
		-0.600205,
		-0.457117,
		-0.656353,
		0,
		0.24899,
		0.673044,
		-0.696431,
		0,
		-0.007872,
		0.019791,
		-0.61207,
		1
	},
	[0.716666666667] = {
		0.758654,
		-0.588842,
		-0.278765,
		0,
		-0.594947,
		-0.451817,
		-0.664754,
		0,
		0.265485,
		0.670169,
		-0.693103,
		0,
		-0.002558,
		0.018745,
		-0.609263,
		1
	},
	[0.733333333333] = {
		0.761628,
		-0.58351,
		-0.281848,
		0,
		-0.594956,
		-0.457295,
		-0.660991,
		0,
		0.256807,
		0.671117,
		-0.695451,
		0,
		-0.002205,
		0.01809,
		-0.60853,
		1
	},
	[0.75] = {
		0.765104,
		-0.576969,
		-0.285872,
		0,
		-0.595052,
		-0.463918,
		-0.656272,
		0,
		0.246027,
		0.672225,
		-0.698272,
		0,
		-0.001949,
		0.017349,
		-0.607751,
		1
	},
	[0.766666666667] = {
		0.768966,
		-0.569336,
		-0.29077,
		0,
		-0.595182,
		-0.471559,
		-0.650684,
		0,
		0.233343,
		0.673416,
		-0.701472,
		0,
		-0.001787,
		0.016532,
		-0.606937,
		1
	},
	[0.783333333333] = {
		0.773154,
		-0.560667,
		-0.296455,
		0,
		-0.595246,
		-0.48016,
		-0.644305,
		0,
		0.218894,
		0.674611,
		-0.704972,
		0,
		-0.001677,
		0.015635,
		-0.606069,
		1
	},
	[0.7] = {
		0.75629,
		-0.592848,
		-0.276688,
		0,
		-0.595077,
		-0.447616,
		-0.667476,
		0,
		0.271861,
		0.669456,
		-0.691318,
		0,
		-0.00301,
		0.0193,
		-0.609939,
		1
	},
	[0.816666666667] = {
		0.782149,
		-0.540582,
		-0.309861,
		0,
		-0.594865,
		-0.499855,
		-0.629508,
		0,
		0.185415,
		0.676695,
		-0.712535,
		0,
		-0.001512,
		0.013609,
		-0.604148,
		1
	},
	[0.833333333333] = {
		0.786701,
		-0.529465,
		-0.317439,
		0,
		-0.594357,
		-0.510629,
		-0.621287,
		0,
		0.166856,
		0.67744,
		-0.716404,
		0,
		-0.001472,
		0.012514,
		-0.603134,
		1
	},
	[0.85] = {
		0.791133,
		-0.517845,
		-0.325493,
		0,
		-0.593613,
		-0.521798,
		-0.612659,
		0,
		0.147421,
		0.677911,
		-0.720211,
		0,
		-0.001468,
		0.011389,
		-0.60211,
		1
	},
	[0.866666666667] = {
		0.79534,
		-0.505891,
		-0.333929,
		0,
		-0.592629,
		-0.53319,
		-0.603738,
		0,
		0.127378,
		0.678072,
		-0.723873,
		0,
		-0.00151,
		0.010252,
		-0.601099,
		1
	},
	[0.883333333333] = {
		0.799232,
		-0.493783,
		-0.342646,
		0,
		-0.59142,
		-0.544629,
		-0.594645,
		0,
		0.107011,
		0.677907,
		-0.727318,
		0,
		-0.001608,
		0.009123,
		-0.600121,
		1
	},
	[0.8] = {
		0.777592,
		-0.551033,
		-0.302842,
		0,
		-0.595152,
		-0.489645,
		-0.637214,
		0,
		0.202841,
		0.675729,
		-0.708693,
		0,
		-0.001583,
		0.014655,
		-0.605133,
		1
	},
	[0.916666666667] = {
		0.805831,
		-0.469799,
		-0.360452,
		0,
		-0.588407,
		-0.566993,
		-0.576451,
		0,
		0.066443,
		0.676614,
		-0.733334,
		0,
		-0.001973,
		0.006954,
		-0.598327,
		1
	},
	[0.933333333333] = {
		0.80854,
		-0.45817,
		-0.369248,
		0,
		-0.586583,
		-0.577717,
		-0.567594,
		0,
		0.046734,
		0.675517,
		-0.735862,
		0,
		-0.002169,
		0.005917,
		-0.597486,
		1
	},
	[0.95] = {
		0.810851,
		-0.446996,
		-0.377778,
		0,
		-0.584593,
		-0.587951,
		-0.559074,
		0,
		0.027789,
		0.674172,
		-0.738051,
		0,
		-0.002356,
		0.004925,
		-0.596687,
		1
	},
	[0.966666666667] = {
		0.812769,
		-0.436456,
		-0.385891,
		0,
		-0.582501,
		-0.597543,
		-0.55103,
		0,
		0.009914,
		0.672643,
		-0.739901,
		0,
		-0.002529,
		0.003993,
		-0.59594,
		1
	},
	[0.983333333333] = {
		0.814315,
		-0.426732,
		-0.393434,
		0,
		-0.580385,
		-0.60634,
		-0.543604,
		0,
		-0.006581,
		0.671008,
		-0.741421,
		0,
		-0.002685,
		0.003136,
		-0.595256,
		1
	},
	[0.9] = {
		0.802733,
		-0.481709,
		-0.351534,
		0,
		-0.590015,
		-0.555934,
		-0.585509,
		0,
		0.086615,
		0.677417,
		-0.730482,
		0,
		-0.001772,
		0.008023,
		-0.5992,
		1
	},
	[1.01666666667] = {
		0.81642,
		-0.410469,
		-0.406169,
		0,
		-0.576446,
		-0.62094,
		-0.531172,
		0,
		-0.034177,
		0.667794,
		-0.743561,
		0,
		-0.002935,
		0.00171,
		-0.594123,
		1
	},
	[1.03333333333] = {
		0.817061,
		-0.404295,
		-0.411044,
		0,
		-0.574819,
		-0.626445,
		-0.526449,
		0,
		-0.044655,
		0.666417,
		-0.744241,
		0,
		-0.003028,
		0.00117,
		-0.593697,
		1
	},
	[1.05] = {
		0.817483,
		-0.399669,
		-0.414712,
		0,
		-0.573554,
		-0.630557,
		-0.522909,
		0,
		-0.052509,
		0.665329,
		-0.744702,
		0,
		-0.003097,
		0.000767,
		-0.593379,
		1
	},
	[1.06666666667] = {
		0.817723,
		-0.396767,
		-0.41702,
		0,
		-0.57274,
		-0.633131,
		-0.520687,
		0,
		-0.057437,
		0.664621,
		-0.744969,
		0,
		-0.00314,
		0.000515,
		-0.593181,
		1
	},
	[1.08333333333] = {
		0.817801,
		-0.395762,
		-0.417821,
		0,
		-0.572454,
		-0.634021,
		-0.519917,
		0,
		-0.059144,
		0.664372,
		-0.745058,
		0,
		-0.003156,
		0.000427,
		-0.593113,
		1
	}
}

return spline_matrices
