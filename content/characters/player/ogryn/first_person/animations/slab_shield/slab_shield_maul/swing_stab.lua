﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_stab.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.286163,
		-0.432316,
		0.855111,
		0,
		0.057519,
		0.898572,
		0.43504,
		0,
		-0.956453,
		-0.075307,
		0.282004,
		0,
		0.810994,
		-0.12622,
		-0.420233,
		1
	},
	[0.0333333333333] = {
		0.287706,
		-0.430035,
		0.855743,
		0,
		0.054312,
		0.89941,
		0.433719,
		0,
		-0.956178,
		-0.078306,
		0.282121,
		0,
		0.811436,
		-0.123705,
		-0.424341,
		1
	},
	[0.05] = {
		0.288514,
		-0.428783,
		0.856099,
		0,
		0.052639,
		0.899871,
		0.432967,
		0,
		-0.956028,
		-0.079853,
		0.282196,
		0,
		0.811655,
		-0.121899,
		-0.430993,
		1
	},
	[0.0666666666667] = {
		0.290084,
		-0.426329,
		0.856793,
		0,
		0.049376,
		0.900765,
		0.431491,
		0,
		-0.955727,
		-0.082864,
		0.282348,
		0,
		0.81207,
		-0.118398,
		-0.439694,
		1
	},
	[0.0833333333333] = {
		0.291578,
		-0.423942,
		0.85747,
		0,
		0.04627,
		0.901624,
		0.430038,
		0,
		-0.955427,
		-0.085714,
		0.282509,
		0,
		0.812431,
		-0.114224,
		-0.450219,
		1
	},
	[0] = {
		0.896527,
		0.047213,
		0.440465,
		0,
		0.368098,
		-0.632586,
		-0.681424,
		0,
		0.24646,
		0.77305,
		-0.58451,
		0,
		0.595455,
		-0.422096,
		-0.517789,
		1
	},
	[0.116666666667] = {
		0.293501,
		-0.420698,
		0.858411,
		0,
		0.042268,
		0.902791,
		0.427997,
		0,
		-0.955024,
		-0.089334,
		0.282752,
		0,
		0.812763,
		-0.104192,
		-0.47552,
		1
	},
	[0.133333333333] = {
		0.293921,
		-0.419991,
		0.858614,
		0,
		0.041392,
		0.903042,
		0.427553,
		0,
		-0.954933,
		-0.090127,
		0.282808,
		0,
		0.812739,
		-0.097834,
		-0.489651,
		1
	},
	[0.15] = {
		0.294066,
		-0.419684,
		0.858714,
		0,
		0.041122,
		0.903162,
		0.427325,
		0,
		-0.9549,
		-0.09035,
		0.282848,
		0,
		0.812604,
		-0.090235,
		-0.504323,
		1
	},
	[0.166666666667] = {
		0.294149,
		-0.419561,
		0.858746,
		0,
		0.041,
		0.903208,
		0.42724,
		0,
		-0.95488,
		-0.090463,
		0.28288,
		0,
		0.812409,
		-0.080802,
		-0.519197,
		1
	},
	[0.183333333333] = {
		0.294181,
		-0.41953,
		0.85875,
		0,
		0.040944,
		0.903217,
		0.427228,
		0,
		-0.954872,
		-0.090522,
		0.282887,
		0,
		0.812174,
		-0.069291,
		-0.533919,
		1
	},
	[0.1] = {
		0.292785,
		-0.421956,
		0.858039,
		0,
		0.043759,
		0.902335,
		0.428808,
		0,
		-0.955177,
		-0.088002,
		0.282654,
		0,
		0.812678,
		-0.109466,
		-0.462264,
		1
	},
	[0.216666666667] = {
		0.286083,
		-0.462821,
		0.839019,
		0,
		0.026724,
		0.879129,
		0.475834,
		0,
		-0.957832,
		-0.113706,
		0.263873,
		0,
		0.777697,
		0.007803,
		-0.481511,
		1
	},
	[0.233333333333] = {
		0.191292,
		-0.512466,
		0.83713,
		0,
		-0.01507,
		0.851246,
		0.524551,
		0,
		-0.981418,
		-0.112958,
		0.155113,
		0,
		0.717951,
		0.137939,
		-0.447888,
		1
	},
	[0.25] = {
		0.071036,
		-0.571379,
		0.817606,
		0,
		-0.093692,
		0.812231,
		0.575763,
		0,
		-0.993064,
		-0.117504,
		0.004164,
		0,
		0.627723,
		0.329103,
		-0.402569,
		1
	},
	[0.266666666667] = {
		0.190941,
		-0.614548,
		0.765423,
		0,
		-0.131209,
		0.756793,
		0.64035,
		0,
		-0.972793,
		-0.222699,
		0.063868,
		0,
		0.37633,
		0.764928,
		-0.287263,
		1
	},
	[0.283333333333] = {
		0.220327,
		-0.694268,
		0.685163,
		0,
		-0.186175,
		0.65958,
		0.728212,
		0,
		-0.957494,
		-0.288005,
		0.016068,
		0,
		0.122628,
		1.261057,
		-0.222691,
		1
	},
	[0.2] = {
		0.06498,
		-0.460951,
		0.885043,
		0,
		-0.045847,
		0.884602,
		0.464087,
		0,
		-0.996833,
		-0.070733,
		0.036348,
		0,
		0.836238,
		-0.051271,
		-0.540685,
		1
	},
	[0.316666666667] = {
		0.235973,
		-0.678226,
		0.695936,
		0,
		-0.194698,
		0.668642,
		0.717643,
		0,
		-0.952055,
		-0.304841,
		0.025732,
		0,
		0.111626,
		1.351389,
		-0.196928,
		1
	},
	[0.333333333333] = {
		0.233892,
		-0.677891,
		0.696964,
		0,
		-0.195201,
		0.669511,
		0.716695,
		0,
		-0.952466,
		-0.303678,
		0.024268,
		0,
		0.114318,
		1.46499,
		-0.195507,
		1
	},
	[0.35] = {
		0.232909,
		-0.67631,
		0.698826,
		0,
		-0.195839,
		0.67125,
		0.714892,
		0,
		-0.952576,
		-0.303363,
		0.023892,
		0,
		0.110334,
		1.457242,
		-0.197497,
		1
	},
	[0.366666666667] = {
		0.232907,
		-0.672804,
		0.702203,
		0,
		-0.198358,
		0.674015,
		0.711588,
		0,
		-0.952055,
		-0.305021,
		0.023527,
		0,
		0.103421,
		1.449314,
		-0.202365,
		1
	},
	[0.383333333333] = {
		0.232115,
		-0.669144,
		0.705953,
		0,
		-0.199945,
		0.677452,
		0.70787,
		0,
		-0.951916,
		-0.305459,
		0.023455,
		0,
		0.098706,
		1.450879,
		-0.207883,
		1
	},
	[0.3] = {
		0.22787,
		-0.68699,
		0.690014,
		0,
		-0.190041,
		0.66365,
		0.7235,
		0,
		-0.954966,
		-0.295995,
		0.020669,
		0,
		0.11148,
		1.18128,
		-0.212386,
		1
	},
	[0.416666666667] = {
		0.230079,
		-0.661563,
		0.713721,
		0,
		-0.2024,
		0.68483,
		0.70003,
		0,
		-0.951892,
		-0.305519,
		0.023665,
		0,
		0.090766,
		1.463385,
		-0.219647,
		1
	},
	[0.433333333333] = {
		0.228977,
		-0.657846,
		0.717501,
		0,
		-0.203446,
		0.688465,
		0.69615,
		0,
		-0.951934,
		-0.305376,
		0.023807,
		0,
		0.087084,
		1.471445,
		-0.225455,
		1
	},
	[0.45] = {
		0.227916,
		-0.654319,
		0.721055,
		0,
		-0.204493,
		0.691862,
		0.692466,
		0,
		-0.951965,
		-0.305275,
		0.023883,
		0,
		0.083303,
		1.47879,
		-0.230883,
		1
	},
	[0.466666666667] = {
		0.226963,
		-0.651092,
		0.72427,
		0,
		-0.205631,
		0.694874,
		0.689105,
		0,
		-0.951947,
		-0.305334,
		0.023826,
		0,
		0.07921,
		1.483986,
		-0.235653,
		1
	},
	[0.483333333333] = {
		0.226188,
		-0.648276,
		0.727033,
		0,
		-0.206954,
		0.697354,
		0.686198,
		0,
		-0.951845,
		-0.305672,
		0.02357,
		0,
		0.074602,
		1.485597,
		-0.239476,
		1
	},
	[0.4] = {
		0.231148,
		-0.665363,
		0.709833,
		0,
		-0.201263,
		0.681109,
		0.703977,
		0,
		-0.951874,
		-0.305586,
		0.023524,
		0,
		0.094566,
		1.45605,
		-0.213712,
		1
	},
	[0.516666666667] = {
		0.225518,
		-0.642954,
		0.73195,
		0,
		-0.210626,
		0.70136,
		0.680978,
		0,
		-0.951198,
		-0.307741,
		0.022747,
		0,
		0.063156,
		1.484319,
		-0.245815,
		1
	},
	[0.533333333333] = {
		0.22564,
		-0.64015,
		0.734367,
		0,
		-0.213041,
		0.703139,
		0.678387,
		0,
		-0.950631,
		-0.309521,
		0.022279,
		0,
		0.056293,
		1.483692,
		-0.248899,
		1
	},
	[0.55] = {
		0.225551,
		-0.637448,
		0.73674,
		0,
		-0.215265,
		0.704927,
		0.675825,
		0,
		-0.950151,
		-0.311028,
		0.021776,
		0,
		0.049873,
		1.483026,
		-0.251896,
		1
	},
	[0.566666666667] = {
		0.225501,
		-0.634797,
		0.739041,
		0,
		-0.217545,
		0.706617,
		0.673325,
		0,
		-0.949644,
		-0.31261,
		0.021246,
		0,
		0.043345,
		1.482354,
		-0.25475,
		1
	},
	[0.583333333333] = {
		0.223825,
		-0.632313,
		0.741676,
		0,
		-0.218018,
		0.709216,
		0.670433,
		0,
		-0.949932,
		-0.311758,
		0.020885,
		0,
		0.040607,
		1.481409,
		-0.258408,
		1
	},
	[0.5] = {
		0.225693,
		-0.64566,
		0.72951,
		0,
		-0.208595,
		0.699436,
		0.683577,
		0,
		-0.951604,
		-0.306451,
		0.023176,
		0,
		0.06927,
		1.484949,
		-0.242683,
		1
	},
	[0.616666666667] = {
		0.231038,
		-0.633003,
		0.738869,
		0,
		-0.227192,
		0.703321,
		0.67359,
		0,
		-0.946047,
		-0.32349,
		0.018681,
		0,
		0.021266,
		1.479773,
		-0.264848,
		1
	},
	[0.633333333333] = {
		0.23798,
		-0.639754,
		0.730808,
		0,
		-0.232663,
		0.692969,
		0.682394,
		0,
		-0.942992,
		-0.332428,
		0.016066,
		0,
		0.009147,
		1.479114,
		-0.269251,
		1
	},
	[0.65] = {
		0.246994,
		-0.649645,
		0.718997,
		0,
		-0.238465,
		0.678418,
		0.694898,
		0,
		-0.939217,
		-0.343091,
		0.012648,
		0,
		-0.000369,
		1.47821,
		-0.271736,
		1
	},
	[0.666666666667] = {
		0.2635,
		-0.657278,
		0.706083,
		0,
		-0.249327,
		0.660676,
		0.708056,
		0,
		-0.931882,
		-0.362618,
		0.010211,
		0,
		-0.012162,
		1.475086,
		-0.277438,
		1
	},
	[0.683333333333] = {
		0.289841,
		-0.66186,
		0.691328,
		0,
		-0.26643,
		0.637983,
		0.722491,
		0,
		-0.919243,
		-0.393598,
		0.008575,
		0,
		-0.023947,
		1.469063,
		-0.283727,
		1
	},
	[0.6] = {
		0.224548,
		-0.62924,
		0.744067,
		0,
		-0.221183,
		0.710725,
		0.667793,
		0,
		-0.949029,
		-0.314526,
		0.020415,
		0,
		0.032239,
		1.480681,
		-0.261523,
		1
	},
	[0.716666666667] = {
		0.375535,
		-0.656768,
		0.653934,
		0,
		-0.318456,
		0.571178,
		0.756533,
		0,
		-0.870379,
		-0.492353,
		0.005346,
		0,
		-0.048339,
		1.449281,
		-0.298316,
		1
	},
	[0.733333333333] = {
		0.428702,
		-0.645985,
		0.631599,
		0,
		-0.347461,
		0.527438,
		0.775293,
		0,
		-0.833958,
		-0.551826,
		0.001659,
		0,
		-0.060109,
		1.433583,
		-0.30641,
		1
	},
	[0.75] = {
		0.483696,
		-0.629564,
		0.608019,
		0,
		-0.374653,
		0.478895,
		0.793911,
		0,
		-0.790995,
		-0.611808,
		-0.004228,
		0,
		-0.070645,
		1.411761,
		-0.314767,
		1
	},
	[0.766666666667] = {
		0.536757,
		-0.608709,
		0.584264,
		0,
		-0.397836,
		0.428071,
		0.811469,
		0,
		-0.744055,
		-0.668003,
		-0.012396,
		0,
		-0.079199,
		1.38231,
		-0.323195,
		1
	},
	[0.783333333333] = {
		0.584603,
		-0.585695,
		0.561428,
		0,
		-0.415683,
		0.378038,
		0.827221,
		0,
		-0.69674,
		-0.716972,
		-0.022461,
		0,
		-0.085263,
		1.343867,
		-0.331456,
		1
	},
	[0.7] = {
		0.32802,
		-0.661821,
		0.674089,
		0,
		-0.29041,
		0.608369,
		0.738613,
		0,
		-0.898925,
		-0.438042,
		0.007358,
		0,
		-0.036038,
		1.460501,
		-0.290676,
		1
	},
	[0.816666666667] = {
		0.641266,
		-0.494308,
		0.586888,
		0,
		-0.471926,
		0.349017,
		0.809613,
		0,
		-0.605032,
		-0.796145,
		-0.009464,
		0,
		-0.058768,
		1.247002,
		-0.40035,
		1
	},
	[0.833333333333] = {
		0.65915,
		-0.465522,
		0.590602,
		0,
		-0.388657,
		0.46146,
		0.797496,
		0,
		-0.643791,
		-0.755211,
		0.123243,
		0,
		-0.027096,
		1.211689,
		-0.439121,
		1
	},
	[0.85] = {
		0.657999,
		-0.418094,
		0.626287,
		0,
		-0.324709,
		0.592867,
		0.736934,
		0,
		-0.679413,
		-0.688263,
		0.254347,
		0,
		0.004946,
		1.171669,
		-0.496835,
		1
	},
	[0.866666666667] = {
		0.640299,
		-0.354119,
		0.681628,
		0,
		-0.267132,
		0.729341,
		0.629843,
		0,
		-0.720179,
		-0.585372,
		0.3724,
		0,
		0.036463,
		1.124312,
		-0.568898,
		1
	},
	[0.883333333333] = {
		0.610451,
		-0.277252,
		0.741944,
		0,
		-0.197337,
		0.853957,
		0.481472,
		0,
		-0.767078,
		-0.440328,
		0.466587,
		0,
		0.067776,
		1.067269,
		-0.648303,
		1
	},
	[0.8] = {
		0.614462,
		-0.546435,
		0.569073,
		0,
		-0.439792,
		0.361602,
		0.822087,
		0,
		-0.654995,
		-0.755415,
		-0.018127,
		0,
		-0.080048,
		1.299199,
		-0.361291,
		1
	},
	[0.916666666667] = {
		0.547438,
		-0.118272,
		0.828446,
		0,
		0.077007,
		0.992882,
		0.090862,
		0,
		-0.833296,
		0.014055,
		0.552649,
		0,
		0.145747,
		0.911527,
		-0.802035,
		1
	},
	[0.933333333333] = {
		0.538035,
		-0.056323,
		0.841039,
		0,
		0.314658,
		0.93906,
		-0.138408,
		0,
		-0.78199,
		0.339108,
		0.52297,
		0,
		0.213353,
		0.79958,
		-0.870593,
		1
	},
	[0.95] = {
		0.559697,
		-0.017736,
		0.828508,
		0,
		0.543364,
		0.762717,
		-0.350741,
		0,
		-0.625696,
		0.64649,
		0.436527,
		0,
		0.294177,
		0.662456,
		-0.929651,
		1
	},
	[0.966666666667] = {
		0.60346,
		-0.011524,
		0.79731,
		0,
		0.691156,
		0.506216,
		-0.515799,
		0,
		-0.397667,
		0.86233,
		0.313446,
		0,
		0.379094,
		0.507414,
		-0.975997,
		1
	},
	[0.983333333333] = {
		0.651658,
		-0.028944,
		0.757961,
		0,
		0.738407,
		0.25276,
		-0.625194,
		0,
		-0.173486,
		0.967096,
		0.186086,
		0,
		0.462923,
		0.34691,
		-1.008585,
		1
	},
	[0.9] = {
		0.577005,
		-0.193858,
		0.7934,
		0,
		-0.095709,
		0.948681,
		0.301403,
		0,
		-0.811113,
		-0.249847,
		0.52884,
		0,
		0.099578,
		0.998376,
		-0.727521,
		1
	},
	{
		0.693799,
		-0.043278,
		0.718867,
		0,
		0.71982,
		0.072735,
		-0.69034,
		0,
		-0.02241,
		0.996412,
		0.081616,
		0,
		0.545368,
		0.192937,
		-1.02855,
		1
	}
}

return spline_matrices
