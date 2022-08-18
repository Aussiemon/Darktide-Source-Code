local spline_matrices = {
	[0] = {
		0.662576,
		-0.627867,
		-0.408381,
		0,
		-0.741984,
		-0.624653,
		-0.243453,
		0,
		-0.10224,
		0.464318,
		-0.879747,
		0,
		-0.014417,
		-0.017151,
		-0.583364,
		1
	},
	[0.0166666666667] = {
		0.68523,
		-0.608227,
		-0.400648,
		0,
		-0.618144,
		-0.776583,
		0.121723,
		0,
		-0.385172,
		0.16425,
		-0.908111,
		0,
		0.032548,
		-0.044615,
		-0.488226,
		1
	},
	[0.0333333333333] = {
		0.703147,
		-0.583861,
		-0.405822,
		0,
		-0.32369,
		-0.771011,
		0.548422,
		0,
		-0.633095,
		-0.25426,
		-0.731124,
		0,
		0.162441,
		-0.072771,
		-0.278817,
		1
	},
	[0.05] = {
		0.713848,
		-0.556736,
		-0.424814,
		0,
		0.10261,
		-0.516917,
		0.849864,
		0,
		-0.692743,
		-0.650263,
		-0.311874,
		0,
		0.331249,
		-0.084065,
		-0.032307,
		1
	},
	[0.0666666666667] = {
		0.717043,
		-0.529741,
		-0.453017,
		0,
		0.454654,
		-0.137175,
		0.880041,
		0,
		-0.528337,
		-0.836993,
		0.142488,
		0,
		0.480181,
		-0.074413,
		0.165858,
		1
	},
	[0.0833333333333] = {
		0.719918,
		-0.496278,
		-0.485208,
		0,
		0.618587,
		0.14176,
		0.772822,
		0,
		-0.314752,
		-0.856512,
		0.409047,
		0,
		0.548898,
		-0.058598,
		0.246505,
		1
	},
	[0.116666666667] = {
		0.718347,
		-0.371016,
		-0.588494,
		0,
		0.69365,
		0.317322,
		0.64665,
		0,
		-0.053176,
		-0.872728,
		0.485303,
		0,
		0.524676,
		0.039956,
		0.237445,
		1
	},
	[0.133333333333] = {
		0.710552,
		-0.277119,
		-0.646778,
		0,
		0.701899,
		0.343859,
		0.623778,
		0,
		0.04954,
		-0.897199,
		0.438839,
		0,
		0.491196,
		0.123922,
		0.226204,
		1
	},
	[0.15] = {
		0.698996,
		-0.170324,
		-0.694547,
		0,
		0.69443,
		0.393626,
		0.60235,
		0,
		0.170797,
		-0.903354,
		0.393421,
		0,
		0.454807,
		0.215325,
		0.214108,
		1
	},
	[0.166666666667] = {
		0.682247,
		-0.069496,
		-0.727811,
		0,
		0.65119,
		0.510347,
		0.561692,
		0,
		0.332401,
		-0.857156,
		0.393438,
		0,
		0.422233,
		0.303242,
		0.20407,
		1
	},
	[0.183333333333] = {
		0.663606,
		0.030731,
		-0.74745,
		0,
		0.502562,
		0.721793,
		0.475864,
		0,
		0.554128,
		-0.691427,
		0.463542,
		0,
		0.384928,
		0.399527,
		0.197015,
		1
	},
	[0.1] = {
		0.722089,
		-0.44417,
		-0.530378,
		0,
		0.671927,
		0.267856,
		0.690484,
		0,
		-0.164627,
		-0.854966,
		0.491865,
		0,
		0.547086,
		-0.025002,
		0.244987,
		1
	},
	[0.216666666667] = {
		0.581418,
		0.167703,
		-0.796134,
		0,
		-0.001958,
		0.978812,
		0.204753,
		0,
		0.813603,
		-0.117488,
		0.569427,
		0,
		0.306295,
		0.571303,
		0.171821,
		1
	},
	[0.233333333333] = {
		0.541939,
		0.188118,
		-0.819093,
		0,
		-0.213436,
		0.973479,
		0.082359,
		0,
		0.812864,
		0.13019,
		0.567717,
		0,
		0.283343,
		0.611167,
		0.159152,
		1
	},
	[0.25] = {
		0.542183,
		0.188493,
		-0.818845,
		0,
		-0.210487,
		0.97391,
		0.084819,
		0,
		0.81347,
		0.126369,
		0.567713,
		0,
		0.285234,
		0.609926,
		0.160531,
		1
	},
	[0.266666666667] = {
		0.516244,
		0.211306,
		-0.829965,
		0,
		-0.617002,
		0.763854,
		-0.189305,
		0,
		0.59397,
		0.609817,
		0.524712,
		0,
		0.169558,
		0.667269,
		0.081612,
		1
	},
	[0.283333333333] = {
		0.471422,
		0.211925,
		-0.856066,
		0,
		-0.865562,
		0.297211,
		-0.403074,
		0,
		0.16901,
		0.930996,
		0.323546,
		0,
		-0.011863,
		0.702105,
		-0.03807,
		1
	},
	[0.2] = {
		0.628792,
		0.117851,
		-0.768591,
		0,
		0.264117,
		0.897309,
		0.353665,
		0,
		0.731343,
		-0.425379,
		0.533095,
		0,
		0.343273,
		0.493126,
		0.188055,
		1
	},
	[0.316666666667] = {
		0.366357,
		0.15245,
		-0.917901,
		0,
		-0.927486,
		-0.019161,
		-0.373365,
		0,
		-0.074508,
		0.988125,
		0.134375,
		0,
		-0.331082,
		0.600482,
		-0.18839,
		1
	},
	[0.333333333333] = {
		0.310411,
		-0.347146,
		-0.884949,
		0,
		-0.609103,
		-0.787356,
		0.095209,
		0,
		-0.729821,
		0.509471,
		-0.455851,
		0,
		-0.698118,
		0.071359,
		-0.344058,
		1
	},
	[0.35] = {
		0.405328,
		-0.503651,
		-0.762919,
		0,
		-0.356919,
		-0.855498,
		0.375142,
		0,
		-0.841616,
		0.120244,
		-0.52652,
		0,
		-0.684283,
		0.043666,
		-0.348133,
		1
	},
	[0.366666666667] = {
		0.495514,
		-0.565965,
		-0.6589,
		0,
		-0.187527,
		-0.810393,
		0.555065,
		0,
		-0.848115,
		-0.151481,
		-0.507695,
		0,
		-0.662293,
		0.027002,
		-0.354077,
		1
	},
	[0.383333333333] = {
		0.563533,
		-0.584677,
		-0.583595,
		0,
		-0.088678,
		-0.745184,
		0.660936,
		0,
		-0.82132,
		-0.320708,
		-0.471784,
		0,
		-0.633741,
		0.015553,
		-0.362407,
		1
	},
	[0.3] = {
		0.44585,
		0.226234,
		-0.866046,
		0,
		-0.892201,
		0.190229,
		-0.409622,
		0,
		0.072077,
		0.955317,
		0.28666,
		0,
		-0.144973,
		0.671819,
		-0.107383,
		1
	},
	[0.416666666667] = {
		0.645056,
		-0.583332,
		-0.493586,
		0,
		-0.015399,
		-0.655733,
		0.754836,
		0,
		-0.76398,
		-0.47931,
		-0.431967,
		0,
		-0.563007,
		-0.001552,
		-0.384803,
		1
	},
	[0.433333333333] = {
		0.667878,
		-0.57957,
		-0.466944,
		0,
		-0.015629,
		-0.638168,
		0.769738,
		0,
		-0.744106,
		-0.506794,
		-0.435277,
		0,
		-0.522133,
		-0.009044,
		-0.397808,
		1
	},
	[0.45] = {
		0.682963,
		-0.57715,
		-0.447727,
		0,
		-0.032518,
		-0.63636,
		0.770707,
		0,
		-0.729729,
		-0.511805,
		-0.453378,
		0,
		-0.478397,
		-0.016226,
		-0.411544,
		1
	},
	[0.466666666667] = {
		0.692175,
		-0.576676,
		-0.43398,
		0,
		-0.063662,
		-0.647746,
		0.759192,
		0,
		-0.718917,
		-0.497865,
		-0.485066,
		0,
		-0.43257,
		-0.023119,
		-0.42586,
		1
	},
	[0.483333333333] = {
		0.696688,
		-0.578155,
		-0.424692,
		0,
		-0.107945,
		-0.669756,
		0.734693,
		0,
		-0.709207,
		-0.466008,
		-0.52902,
		0,
		-0.385524,
		-0.029516,
		-0.440681,
		1
	},
	[0.4] = {
		0.611658,
		-0.586605,
		-0.530819,
		0,
		-0.036688,
		-0.691281,
		0.721654,
		0,
		-0.790271,
		-0.421931,
		-0.444349,
		0,
		-0.600385,
		0.006462,
		-0.372838,
		1
	},
	[0.516666666667] = {
		0.694497,
		-0.585859,
		-0.417663,
		0,
		-0.233624,
		-0.732663,
		0.639237,
		0,
		-0.68051,
		-0.346372,
		-0.645703,
		0,
		-0.291272,
		-0.039387,
		-0.47186,
		1
	},
	[0.533333333333] = {
		0.689025,
		-0.591126,
		-0.419302,
		0,
		-0.312728,
		-0.764427,
		0.563783,
		0,
		-0.653793,
		-0.257333,
		-0.711572,
		0,
		-0.245646,
		-0.042129,
		-0.488198,
		1
	},
	[0.55] = {
		0.681599,
		-0.59644,
		-0.42389,
		0,
		-0.398883,
		-0.788521,
		0.468111,
		0,
		-0.613446,
		-0.149982,
		-0.775364,
		0,
		-0.201926,
		-0.042929,
		-0.504827,
		1
	},
	[0.566666666667] = {
		0.673206,
		-0.601109,
		-0.430653,
		0,
		-0.486775,
		-0.798656,
		0.353834,
		0,
		-0.556636,
		-0.028572,
		-0.830265,
		0,
		-0.160693,
		-0.041573,
		-0.521348,
		1
	},
	[0.583333333333] = {
		0.66503,
		-0.604718,
		-0.438237,
		0,
		-0.569421,
		-0.790263,
		0.226372,
		0,
		-0.483214,
		0.098997,
		-0.869887,
		0,
		-0.122533,
		-0.038125,
		-0.537137,
		1
	},
	[0.5] = {
		0.697257,
		-0.581344,
		-0.419371,
		0,
		-0.164826,
		-0.699392,
		0.695473,
		0,
		-0.697614,
		-0.4158,
		-0.583477,
		0,
		-0.338149,
		-0.035055,
		-0.456007,
		1
	},
	[0.616666666667] = {
		0.653878,
		-0.610095,
		-0.447467,
		0,
		-0.692217,
		-0.721134,
		-0.028304,
		0,
		-0.305416,
		0.328252,
		-0.893852,
		0,
		-0.05866,
		-0.027192,
		-0.563567,
		1
	},
	[0.633333333333] = {
		0.652411,
		-0.614152,
		-0.444047,
		0,
		-0.725633,
		-0.675267,
		-0.13218,
		0,
		-0.218672,
		0.408451,
		-0.8862,
		0,
		-0.035306,
		-0.021666,
		-0.57304,
		1
	},
	[0.65] = {
		0.654126,
		-0.621008,
		-0.431818,
		0,
		-0.742026,
		-0.63757,
		-0.207129,
		0,
		-0.146686,
		0.455909,
		-0.877856,
		0,
		-0.01969,
		-0.017616,
		-0.579673,
		1
	},
	[0.666666666667] = {
		0.659377,
		-0.631324,
		-0.408231,
		0,
		-0.745441,
		-0.619552,
		-0.245911,
		0,
		-0.097671,
		0.46646,
		-0.879133,
		0,
		-0.013433,
		-0.01606,
		-0.583419,
		1
	},
	[0.683333333333] = {
		0.660426,
		-0.63019,
		-0.408286,
		0,
		-0.744311,
		-0.621233,
		-0.245093,
		0,
		-0.099185,
		0.465758,
		-0.879336,
		0,
		-0.013764,
		-0.016419,
		-0.583401,
		1
	},
	[0.6] = {
		0.658269,
		-0.607422,
		-0.444658,
		0,
		-0.639634,
		-0.762777,
		0.095075,
		0,
		-0.396926,
		0.221834,
		-0.89064,
		0,
		-0.088183,
		-0.033047,
		-0.551443,
		1
	},
	[0.716666666667] = {
		0.661987,
		-0.628503,
		-0.408358,
		0,
		-0.742623,
		-0.623719,
		-0.243897,
		0,
		-0.101411,
		0.464713,
		-0.879635,
		0,
		-0.014242,
		-0.016951,
		-0.583374,
		1
	},
	[0.733333333333] = {
		0.662423,
		-0.628033,
		-0.408376,
		0,
		-0.74215,
		-0.62441,
		-0.243568,
		0,
		-0.102025,
		0.464421,
		-0.879718,
		0,
		-0.014372,
		-0.017099,
		-0.583367,
		1
	},
	[0.75] = {
		0.662576,
		-0.627867,
		-0.408381,
		0,
		-0.741984,
		-0.624653,
		-0.243453,
		0,
		-0.10224,
		0.464318,
		-0.879747,
		0,
		-0.014417,
		-0.017151,
		-0.583364,
		1
	},
	[0.7] = {
		0.661309,
		-0.629236,
		-0.408328,
		0,
		-0.743357,
		-0.622641,
		-0.244414,
		0,
		-0.100448,
		0.465167,
		-0.879505,
		0,
		-0.014037,
		-0.01672,
		-0.583386,
		1
	}
}

return spline_matrices
