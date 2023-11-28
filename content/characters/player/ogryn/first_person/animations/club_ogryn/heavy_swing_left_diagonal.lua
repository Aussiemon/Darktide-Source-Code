﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_left_diagonal.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.684344,
		-0.130768,
		-0.717337,
		0,
		0.673253,
		0.491106,
		0.552761,
		0,
		0.280005,
		-0.861229,
		0.424125,
		0,
		1.26425,
		0.806,
		0.856881,
		1
	},
	[0.0333333333333] = {
		0.746906,
		-0.122603,
		-0.653528,
		0,
		0.632283,
		0.43514,
		0.640992,
		0,
		0.205789,
		-0.891976,
		0.402529,
		0,
		1.243035,
		0.763542,
		0.89189,
		1
	},
	[0.05] = {
		0.808513,
		-0.115405,
		-0.577052,
		0,
		0.574162,
		0.369682,
		0.73053,
		0,
		0.129019,
		-0.921964,
		0.365153,
		0,
		1.207489,
		0.693902,
		0.925102,
		1
	},
	[0.0666666666667] = {
		0.864124,
		-0.110143,
		-0.491079,
		0,
		0.50022,
		0.295394,
		0.813955,
		0,
		0.05541,
		-0.949005,
		0.310353,
		0,
		1.159119,
		0.600724,
		0.950874,
		1
	},
	[0.0833333333333] = {
		0.910121,
		-0.10732,
		-0.400203,
		0,
		0.414235,
		0.213723,
		0.884721,
		0,
		-0.009415,
		-0.970981,
		0.23897,
		0,
		1.104949,
		0.493359,
		0.973429,
		1
	},
	[0] = {
		0.626689,
		-0.138666,
		-0.766832,
		0,
		0.697933,
		0.537587,
		0.47317,
		0,
		0.346627,
		-0.831728,
		0.43368,
		0,
		1.276988,
		0.827056,
		0.836082,
		1
	},
	[0.116666666667] = {
		0.968086,
		-0.107898,
		-0.226204,
		0,
		0.231343,
		0.037594,
		0.972146,
		0,
		-0.096389,
		-0.993451,
		0.061356,
		0,
		0.995815,
		0.258477,
		1.007695,
		1
	},
	[0.133333333333] = {
		0.981945,
		-0.109249,
		-0.154433,
		0,
		0.149626,
		-0.050952,
		0.987429,
		0,
		-0.115744,
		-0.992708,
		-0.033685,
		0,
		0.947911,
		0.141053,
		1.018335,
		1
	},
	[0.15] = {
		0.989026,
		-0.109237,
		-0.099473,
		0,
		0.084322,
		-0.135502,
		0.987182,
		0,
		-0.121316,
		-0.984737,
		-0.124804,
		0,
		0.908748,
		0.030312,
		1.025131,
		1
	},
	[0.166666666667] = {
		0.992192,
		-0.106177,
		-0.065433,
		0,
		0.041609,
		-0.212784,
		0.976213,
		0,
		-0.117574,
		-0.971313,
		-0.206705,
		0,
		0.880968,
		-0.06891,
		1.028732,
		1
	},
	[0.183333333333] = {
		0.993542,
		-0.098698,
		-0.055968,
		0,
		0.026295,
		-0.27955,
		0.959771,
		0,
		-0.110374,
		-0.955045,
		-0.275149,
		0,
		0.864236,
		-0.149992,
		1.02001,
		1
	},
	[0.1] = {
		0.944728,
		-0.106822,
		-0.309965,
		0,
		0.322152,
		0.126864,
		0.938149,
		0,
		-0.060891,
		-0.986151,
		0.154265,
		0,
		1.049162,
		0.377503,
		0.992297,
		1
	},
	[0.216666666667] = {
		0.983034,
		-0.07605,
		-0.166916,
		0,
		0.122812,
		-0.403027,
		0.906911,
		0,
		-0.136242,
		-0.912023,
		-0.386849,
		0,
		0.912928,
		-0.204475,
		0.962034,
		1
	},
	[0.233333333333] = {
		0.961413,
		-0.061019,
		-0.268258,
		0,
		0.214231,
		-0.445708,
		0.869166,
		0,
		-0.172601,
		-0.893097,
		-0.415437,
		0,
		0.972964,
		-0.185986,
		0.935672,
		1
	},
	[0.25] = {
		0.926633,
		-0.044672,
		-0.373303,
		0,
		0.312803,
		-0.459244,
		0.831414,
		0,
		-0.208578,
		-0.887186,
		-0.411577,
		0,
		1.038763,
		-0.147052,
		0.910051,
		1
	},
	[0.266666666667] = {
		0.884358,
		-0.030546,
		-0.465809,
		0,
		0.408738,
		-0.431334,
		0.804291,
		0,
		-0.225487,
		-0.901675,
		-0.368968,
		0,
		1.098735,
		-0.094466,
		0.88657,
		1
	},
	[0.283333333333] = {
		0.845366,
		-0.022342,
		-0.53372,
		0,
		0.49445,
		-0.345419,
		0.797624,
		0,
		-0.202178,
		-0.938182,
		-0.280959,
		0,
		1.142321,
		-0.034463,
		0.86881,
		1
	},
	[0.2] = {
		0.992097,
		-0.088314,
		-0.089135,
		0,
		0.053707,
		-0.343133,
		0.93775,
		0,
		-0.113402,
		-0.935126,
		-0.335678,
		0,
		0.871766,
		-0.195306,
		0.989887,
		1
	},
	[0.316666666667] = {
		0.80741,
		-0.065416,
		-0.586353,
		0,
		0.587525,
		0.179912,
		0.788953,
		0,
		0.053882,
		-0.981505,
		0.183697,
		0,
		1.198437,
		0.168717,
		0.835113,
		1
	},
	[0.333333333333] = {
		0.794731,
		-0.072409,
		-0.602627,
		0,
		0.56618,
		0.446234,
		0.693048,
		0,
		0.218729,
		-0.891982,
		0.395633,
		0,
		1.205368,
		0.293869,
		0.773503,
		1
	},
	[0.35] = {
		0.768503,
		-0.045308,
		-0.63824,
		0,
		0.519079,
		0.627369,
		0.580486,
		0,
		0.374111,
		-0.777403,
		0.505654,
		0,
		1.171444,
		0.41538,
		0.701255,
		1
	},
	[0.366666666667] = {
		0.728073,
		-0.007583,
		-0.685458,
		0,
		0.430411,
		0.783321,
		0.448504,
		0,
		0.533532,
		-0.621572,
		0.573578,
		0,
		1.097077,
		0.593616,
		0.627726,
		1
	},
	[0.383333333333] = {
		0.677678,
		0.021207,
		-0.735053,
		0,
		0.282673,
		0.915269,
		0.287015,
		0,
		0.678858,
		-0.402283,
		0.614263,
		0,
		1.007626,
		0.840718,
		0.551292,
		1
	},
	[0.3] = {
		0.819871,
		-0.036494,
		-0.571384,
		0,
		0.562708,
		-0.132869,
		0.815908,
		0,
		-0.105695,
		-0.990462,
		-0.0884,
		0,
		1.173051,
		0.050676,
		0.856824,
		1
	},
	[0.416666666667] = {
		0.585211,
		0.033452,
		-0.810191,
		0,
		-0.19843,
		0.974679,
		-0.103085,
		0,
		0.786227,
		0.221092,
		0.577031,
		0,
		0.734154,
		1.272321,
		0.340742,
		1
	},
	[0.433333333333] = {
		0.555652,
		0.044785,
		-0.830208,
		0,
		-0.469857,
		0.84072,
		-0.26912,
		0,
		0.685919,
		0.539616,
		0.48819,
		0,
		0.522192,
		1.38126,
		0.175151,
		1
	},
	[0.45] = {
		0.529418,
		0.081754,
		-0.844413,
		0,
		-0.704795,
		0.596406,
		-0.38414,
		0,
		0.472208,
		0.798509,
		0.373368,
		0,
		0.286642,
		1.451403,
		-0.024639,
		1
	},
	[0.466666666667] = {
		0.465754,
		0.112746,
		-0.877702,
		0,
		-0.876239,
		0.197301,
		-0.439633,
		0,
		0.123604,
		0.973838,
		0.190686,
		0,
		0.0086,
		1.450605,
		-0.23463,
		1
	},
	[0.483333333333] = {
		0.346858,
		0.012089,
		-0.93784,
		0,
		-0.824337,
		-0.473034,
		-0.310977,
		0,
		-0.44739,
		0.880961,
		-0.154111,
		0,
		-0.580511,
		1.186284,
		-0.585412,
		1
	},
	[0.4] = {
		0.630744,
		0.031373,
		-0.775357,
		0,
		0.071839,
		0.992531,
		0.098601,
		0,
		0.772659,
		-0.117893,
		0.623778,
		0,
		0.8992,
		1.093747,
		0.463428,
		1
	},
	[0.516666666667] = {
		0.41548,
		0.108135,
		-0.903152,
		0,
		0.331548,
		-0.942604,
		0.039665,
		0,
		-0.847025,
		-0.315918,
		-0.427486,
		0,
		-0.763847,
		0.040669,
		-0.80961,
		1
	},
	[0.533333333333] = {
		0.340715,
		0.300906,
		-0.890712,
		0,
		0.728284,
		-0.683617,
		0.04764,
		0,
		-0.594571,
		-0.664924,
		-0.452064,
		0,
		-0.464671,
		-0.443087,
		-0.791752,
		1
	},
	[0.55] = {
		0.29909,
		0.334488,
		-0.893679,
		0,
		0.81164,
		-0.581664,
		0.053927,
		0,
		-0.501783,
		-0.741475,
		-0.445454,
		0,
		-0.438597,
		-0.502232,
		-0.782923,
		1
	},
	[0.566666666667] = {
		0.269472,
		0.34744,
		-0.898148,
		0,
		0.871896,
		-0.484013,
		0.07436,
		0,
		-0.40888,
		-0.803129,
		-0.433359,
		0,
		-0.403667,
		-0.571869,
		-0.776086,
		1
	},
	[0.583333333333] = {
		0.240702,
		0.35561,
		-0.903108,
		0,
		0.914733,
		-0.394233,
		0.088566,
		0,
		-0.32454,
		-0.84742,
		-0.420181,
		0,
		-0.362113,
		-0.644375,
		-0.773007,
		1
	},
	[0.5] = {
		0.361375,
		-0.093253,
		-0.927746,
		0,
		-0.349809,
		-0.93587,
		-0.042188,
		0,
		-0.864316,
		0.33978,
		-0.370821,
		0,
		-1.019011,
		0.716753,
		-0.820523,
		1
	},
	[0.616666666667] = {
		0.206446,
		0.360723,
		-0.909538,
		0,
		0.951582,
		-0.290391,
		0.10082,
		0,
		-0.227753,
		-0.886314,
		-0.403207,
		0,
		-0.320287,
		-0.715768,
		-0.796518,
		1
	},
	[0.633333333333] = {
		0.195744,
		0.361125,
		-0.911742,
		0,
		0.960338,
		-0.25886,
		0.103648,
		0,
		-0.198584,
		-0.895868,
		-0.397473,
		0,
		-0.305267,
		-0.74279,
		-0.820594,
		1
	},
	[0.65] = {
		0.186716,
		0.360959,
		-0.913699,
		0,
		0.966721,
		-0.233081,
		0.105472,
		0,
		-0.174895,
		-0.902985,
		-0.392467,
		0,
		-0.288321,
		-0.773955,
		-0.850204,
		1
	},
	[0.666666666667] = {
		0.179255,
		0.360394,
		-0.915415,
		0,
		0.971293,
		-0.212743,
		0.106441,
		0,
		-0.156388,
		-0.908216,
		-0.388184,
		0,
		-0.270109,
		-0.809249,
		-0.885233,
		1
	},
	[0.683333333333] = {
		0.173248,
		0.359557,
		-0.916899,
		0,
		0.974483,
		-0.197487,
		0.106685,
		0,
		-0.142716,
		-0.911986,
		-0.384596,
		0,
		-0.249558,
		-0.846579,
		-0.924914,
		1
	},
	[0.6] = {
		0.218912,
		0.359533,
		-0.907091,
		0,
		0.939738,
		-0.3279,
		0.096825,
		0,
		-0.262623,
		-0.873623,
		-0.409648,
		0,
		-0.332924,
		-0.693047,
		-0.778269,
		1
	},
	[0.716666666667] = {
		0.165141,
		0.357403,
		-0.919234,
		0,
		0.97788,
		-0.180642,
		0.105443,
		0,
		-0.128367,
		-0.916314,
		-0.379329,
		0,
		-0.196268,
		-0.918034,
		-1.014466,
		1
	},
	[0.733333333333] = {
		0.162814,
		0.35619,
		-0.92012,
		0,
		0.978462,
		-0.17823,
		0.104143,
		0,
		-0.126898,
		-0.917258,
		-0.377537,
		0,
		-0.162731,
		-0.94907,
		-1.062648,
		1
	},
	[0.75] = {
		0.161489,
		0.354926,
		-0.920841,
		0,
		0.978447,
		-0.179265,
		0.102496,
		0,
		-0.128697,
		-0.917546,
		-0.376226,
		0,
		-0.124504,
		-0.975007,
		-1.111609,
		1
	},
	[0.766666666667] = {
		0.161056,
		0.353624,
		-0.921418,
		0,
		0.977895,
		-0.183324,
		0.100571,
		0,
		-0.133353,
		-0.917247,
		-0.375332,
		0,
		-0.081705,
		-0.997039,
		-1.160538,
		1
	},
	[0.783333333333] = {
		0.161406,
		0.35229,
		-0.921868,
		0,
		0.976842,
		-0.189978,
		0.098432,
		0,
		-0.140458,
		-0.916406,
		-0.374795,
		0,
		-0.034596,
		-1.016809,
		-1.208522,
		1
	},
	[0.7] = {
		0.168582,
		0.358538,
		-0.918167,
		0,
		0.976604,
		-0.186922,
		0.10632,
		0,
		-0.133506,
		-0.914609,
		-0.381662,
		0,
		-0.225108,
		-0.883357,
		-0.968235,
		1
	},
	[0.816666666667] = {
		0.164019,
		0.349534,
		-0.922455,
		0,
		0.973335,
		-0.20936,
		0.093736,
		0,
		-0.160361,
		-0.913233,
		-0.374553,
		0,
		0.068749,
		-1.047849,
		-1.296146,
		1
	},
	[0.833333333333] = {
		0.166062,
		0.34812,
		-0.922625,
		0,
		0.970941,
		-0.221224,
		0.091287,
		0,
		-0.172328,
		-0.910973,
		-0.37474,
		0,
		0.122325,
		-1.058835,
		-1.33348,
		1
	},
	[0.85] = {
		0.168446,
		0.34669,
		-0.922731,
		0,
		0.968179,
		-0.23396,
		0.088838,
		0,
		-0.185083,
		-0.908333,
		-0.375068,
		0,
		0.17516,
		-1.066944,
		-1.36545,
		1
	},
	[0.866666666667] = {
		0.171059,
		0.34526,
		-0.922786,
		0,
		0.965118,
		-0.247136,
		0.08644,
		0,
		-0.19821,
		-0.905383,
		-0.375492,
		0,
		0.225722,
		-1.072563,
		-1.391865,
		1
	},
	[0.883333333333] = {
		0.173788,
		0.343852,
		-0.922802,
		0,
		0.961849,
		-0.260322,
		0.084141,
		0,
		-0.211294,
		-0.902219,
		-0.375974,
		0,
		0.272598,
		-1.076284,
		-1.413118,
		1
	},
	[0.8] = {
		0.162431,
		0.350926,
		-0.922208,
		0,
		0.975313,
		-0.198801,
		0.096135,
		0,
		-0.149599,
		-0.915057,
		-0.374554,
		0,
		0.015958,
		-1.033833,
		-1.254154,
		1
	},
	[0.916666666667] = {
		0.179137,
		0.341217,
		-0.922757,
		0,
		0.955173,
		-0.285024,
		0.080034,
		0,
		-0.235699,
		-0.89573,
		-0.37698,
		0,
		0.351593,
		-1.079576,
		-1.441713,
		1
	},
	[0.933333333333] = {
		0.181531,
		0.340067,
		-0.922714,
		0,
		0.952064,
		-0.295703,
		0.078324,
		0,
		-0.246214,
		-0.8927,
		-0.377445,
		0,
		0.382445,
		-1.079854,
		-1.450216,
		1
	},
	[0.95] = {
		0.183588,
		0.33909,
		-0.922667,
		0,
		0.949333,
		-0.304716,
		0.076907,
		0,
		-0.255073,
		-0.890037,
		-0.377851,
		0,
		0.407004,
		-1.079593,
		-1.455677,
		1
	},
	[0.966666666667] = {
		0.185195,
		0.338333,
		-0.922623,
		0,
		0.947164,
		-0.311658,
		0.075833,
		0,
		-0.261886,
		-0.887919,
		-0.378174,
		0,
		0.425008,
		-1.078967,
		-1.458586,
		1
	},
	[0.983333333333] = {
		0.18624,
		0.337845,
		-0.922591,
		0,
		0.945737,
		-0.316122,
		0.075152,
		0,
		-0.266261,
		-0.886526,
		-0.378388,
		0,
		0.436199,
		-1.078098,
		-1.459317,
		1
	},
	[0.9] = {
		0.176518,
		0.342492,
		-0.92279,
		0,
		0.958488,
		-0.273092,
		0.081989,
		0,
		-0.223926,
		-0.898955,
		-0.37648,
		0,
		0.3148,
		-1.078502,
		-1.429566,
		1
	},
	{
		0.186614,
		0.337674,
		-0.922579,
		0,
		0.945227,
		-0.317701,
		0.074913,
		0,
		-0.267808,
		-0.886026,
		-0.378466,
		0,
		0.44024,
		-1.07706,
		-1.458092,
		1
	}
}

return spline_matrices
