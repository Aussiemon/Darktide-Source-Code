local spline_matrices = {
	[0] = {
		0.971888,
		0.016302,
		-0.23488,
		0,
		-0.200087,
		0.582986,
		-0.78746,
		0,
		0.124095,
		0.812319,
		0.569858,
		0,
		0.009701,
		0.315599,
		-0.441409,
		1
	},
	{
		0.944366,
		-0.133938,
		-0.300387,
		0,
		0.017477,
		0.932468,
		-0.360828,
		0,
		0.32843,
		0.335504,
		0.882933,
		0,
		0.051113,
		0.27875,
		-0.603973,
		1
	},
	[0.0166666666667] = {
		0.978902,
		0.03272,
		-0.201693,
		0,
		-0.202047,
		0.302135,
		-0.931607,
		0,
		0.030457,
		0.952703,
		0.302372,
		0,
		-0.021046,
		0.181525,
		-0.520385,
		1
	},
	[0.0333333333333] = {
		0.981064,
		0.055945,
		-0.185427,
		0,
		-0.19356,
		0.249181,
		-0.948917,
		0,
		-0.006882,
		0.96684,
		0.255291,
		0,
		-0.013547,
		0.183694,
		-0.483852,
		1
	},
	[0.05] = {
		0.979593,
		0.063855,
		-0.190576,
		0,
		-0.20054,
		0.247096,
		-0.948012,
		0,
		-0.013445,
		0.966885,
		0.254859,
		0,
		-0.007794,
		0.17638,
		-0.490358,
		1
	},
	[0.0666666666667] = {
		0.977857,
		0.065161,
		-0.198871,
		0,
		-0.209139,
		0.270028,
		-0.939865,
		0,
		-0.007542,
		0.960645,
		0.277677,
		0,
		-0.000996,
		0.167839,
		-0.512302,
		1
	},
	[0.0833333333333] = {
		0.979203,
		0.061088,
		-0.193466,
		0,
		-0.202798,
		0.267402,
		-0.942003,
		0,
		-0.005811,
		0.961647,
		0.27423,
		0,
		0.008792,
		0.154203,
		-0.52693,
		1
	},
	[0.116666666667] = {
		0.985172,
		0.036801,
		-0.167579,
		0,
		-0.171552,
		0.226363,
		-0.958817,
		0,
		0.002648,
		0.973348,
		0.22932,
		0,
		0.017452,
		0.136863,
		-0.52238,
		1
	},
	[0.133333333333] = {
		0.982996,
		0.022198,
		-0.182281,
		0,
		-0.182084,
		0.246246,
		-0.95195,
		0,
		0.023754,
		0.968953,
		0.246101,
		0,
		0.003053,
		0.150639,
		-0.512515,
		1
	},
	[0.15] = {
		0.976132,
		0.010854,
		-0.216905,
		0,
		-0.210691,
		0.289581,
		-0.933677,
		0,
		0.052678,
		0.957092,
		0.284957,
		0,
		-0.020984,
		0.174975,
		-0.499333,
		1
	},
	[0.166666666667] = {
		0.967274,
		0.004984,
		-0.253686,
		0,
		-0.240385,
		0.338027,
		-0.909919,
		0,
		0.081217,
		0.941123,
		0.328162,
		0,
		-0.043929,
		0.19852,
		-0.48726,
		1
	},
	[0.183333333333] = {
		0.961706,
		0.001799,
		-0.274076,
		0,
		-0.25471,
		0.375127,
		-0.891293,
		0,
		0.10121,
		0.926972,
		0.36122,
		0,
		-0.05584,
		0.211245,
		-0.484263,
		1
	},
	[0.1] = {
		0.983025,
		0.050794,
		-0.176299,
		0,
		-0.183357,
		0.238286,
		-0.953729,
		0,
		-0.006434,
		0.969866,
		0.243555,
		0,
		0.017508,
		0.139983,
		-0.527364,
		1
	},
	[0.216666666667] = {
		0.957264,
		0.003019,
		-0.289199,
		0,
		-0.260502,
		0.443368,
		-0.85765,
		0,
		0.125632,
		0.896335,
		0.425207,
		0,
		-0.060051,
		0.222054,
		-0.502078,
		1
	},
	[0.233333333333] = {
		0.954518,
		0.008885,
		-0.29802,
		0,
		-0.264635,
		0.485688,
		-0.833112,
		0,
		0.137343,
		0.874087,
		0.465949,
		0,
		-0.060901,
		0.229387,
		-0.51574,
		1
	},
	[0.25] = {
		0.951631,
		0.017274,
		-0.306757,
		0,
		-0.268784,
		0.53048,
		-0.803957,
		0,
		0.148841,
		0.847522,
		0.509464,
		0,
		-0.061085,
		0.238024,
		-0.531151,
		1
	},
	[0.266666666667] = {
		0.948768,
		0.027317,
		-0.314791,
		0,
		-0.272396,
		0.575576,
		-0.771046,
		0,
		0.160124,
		0.817292,
		0.553529,
		0,
		-0.060693,
		0.247806,
		-0.547263,
		1
	},
	[0.283333333333] = {
		0.946091,
		0.03803,
		-0.32166,
		0,
		-0.274996,
		0.619029,
		-0.73565,
		0,
		0.17114,
		0.784447,
		0.596116,
		0,
		-0.059787,
		0.258417,
		-0.563087,
		1
	},
	[0.2] = {
		0.959713,
		0.000432,
		-0.280983,
		0,
		-0.25698,
		0.405771,
		-0.877104,
		0,
		0.113636,
		0.913975,
		0.389535,
		0,
		-0.058415,
		0.216037,
		-0.491234,
		1
	},
	[0.316666666667] = {
		0.941987,
		0.057168,
		-0.330744,
		0,
		-0.275457,
		0.694721,
		-0.664445,
		0,
		0.19179,
		0.717004,
		0.670165,
		0,
		-0.056669,
		0.279962,
		-0.59066,
		1
	},
	[0.333333333333] = {
		0.940868,
		0.063265,
		-0.332813,
		0,
		-0.272567,
		0.724775,
		-0.632778,
		0,
		0.201182,
		0.686075,
		0.699162,
		0,
		-0.054644,
		0.289279,
		-0.601498,
		1
	},
	[0.35] = {
		0.940542,
		0.065484,
		-0.333305,
		0,
		-0.267127,
		0.748704,
		-0.6067,
		0,
		0.209818,
		0.659662,
		0.721681,
		0,
		-0.052423,
		0.296661,
		-0.609895,
		1
	},
	[0.366666666667] = {
		0.940896,
		0.064212,
		-0.332553,
		0,
		-0.259192,
		0.768551,
		-0.584936,
		0,
		0.218024,
		0.636559,
		0.73977,
		0,
		-0.049969,
		0.30282,
		-0.616773,
		1
	},
	[0.383333333333] = {
		0.94165,
		0.060829,
		-0.331051,
		0,
		-0.249325,
		0.786793,
		-0.564618,
		0,
		0.226123,
		0.614212,
		0.75605,
		0,
		-0.047237,
		0.308925,
		-0.623245,
		1
	},
	[0.3] = {
		0.943778,
		0.048364,
		-0.327024,
		0,
		-0.276145,
		0.659168,
		-0.699458,
		0,
		0.181736,
		0.750439,
		0.635463,
		0,
		-0.058418,
		0.269392,
		-0.577742,
		1
	},
	[0.416666666667] = {
		0.943735,
		0.049033,
		-0.327047,
		0,
		-0.2254,
		0.819028,
		-0.527625,
		0,
		0.24199,
		0.571655,
		0.783997,
		0,
		-0.041358,
		0.320938,
		-0.634877,
		1
	},
	[0.433333333333] = {
		0.944766,
		0.041171,
		-0.325149,
		0,
		-0.212153,
		0.833013,
		-0.510961,
		0,
		0.249817,
		0.55172,
		0.795737,
		0,
		-0.038453,
		0.326576,
		-0.640106,
		1
	},
	[0.45] = {
		0.945609,
		0.032359,
		-0.323693,
		0,
		-0.198593,
		0.845527,
		-0.495625,
		0,
		0.257654,
		0.532951,
		0.805964,
		0,
		-0.035754,
		0.331727,
		-0.645013,
		1
	},
	[0.466666666667] = {
		0.946256,
		0.022897,
		-0.322607,
		0,
		-0.18498,
		0.856544,
		-0.481782,
		0,
		0.265296,
		0.515565,
		0.814745,
		0,
		-0.033171,
		0.336209,
		-0.649663,
		1
	},
	[0.483333333333] = {
		0.946756,
		0.013095,
		-0.321686,
		0,
		-0.171537,
		0.866057,
		-0.469595,
		0,
		0.272449,
		0.499773,
		0.822191,
		0,
		-0.030568,
		0.339839,
		-0.654116,
		1
	},
	[0.4] = {
		0.942648,
		0.055669,
		-0.329114,
		0,
		-0.237927,
		0.803602,
		-0.54554,
		0,
		0.234107,
		0.592558,
		0.770759,
		0,
		-0.044328,
		0.314988,
		-0.629278,
		1
	},
	[0.516666666667] = {
		0.947158,
		-0.006257,
		-0.320705,
		0,
		-0.146749,
		0.880591,
		-0.450582,
		0,
		0.285229,
		0.473836,
		0.833141,
		0,
		-0.0256,
		0.343798,
		-0.662611,
		1
	},
	[0.533333333333] = {
		0.947021,
		-0.015153,
		-0.320813,
		0,
		-0.136222,
		0.885636,
		-0.443951,
		0,
		0.290851,
		0.464133,
		0.836652,
		0,
		-0.023391,
		0.343752,
		-0.666735,
		1
	},
	[0.55] = {
		0.946658,
		-0.023086,
		-0.321411,
		0,
		-0.127484,
		0.889223,
		-0.439353,
		0,
		0.295949,
		0.456892,
		0.838847,
		0,
		-0.021469,
		0.342104,
		-0.670823,
		1
	},
	[0.566666666667] = {
		0.946127,
		-0.03093,
		-0.322316,
		0,
		-0.1203,
		0.890599,
		-0.43859,
		0,
		0.30062,
		0.453736,
		0.838899,
		0,
		-0.019874,
		0.337989,
		-0.673554,
		1
	},
	[0.583333333333] = {
		0.945483,
		-0.039705,
		-0.323243,
		0,
		-0.114119,
		0.889218,
		-0.443023,
		0,
		0.305024,
		0.455758,
		0.836209,
		0,
		-0.018575,
		0.330874,
		-0.673831,
		1
	},
	[0.5] = {
		0.947065,
		0.003269,
		-0.321024,
		0,
		-0.158658,
		0.874069,
		-0.459163,
		0,
		0.279096,
		0.48579,
		0.82832,
		0,
		-0.028019,
		0.342431,
		-0.658417,
		1
	},
	[0.616666666667] = {
		0.943916,
		-0.059642,
		-0.324755,
		0,
		-0.104413,
		0.879162,
		-0.464942,
		0,
		0.313242,
		0.472775,
		0.823628,
		0,
		-0.016676,
		0.308939,
		-0.66831,
		1
	},
	[0.633333333333] = {
		0.943037,
		-0.070523,
		-0.325127,
		0,
		-0.100743,
		0.870855,
		-0.481105,
		0,
		0.317068,
		0.486454,
		0.814144,
		0,
		-0.015989,
		0.294801,
		-0.663094,
		1
	},
	[0.65] = {
		0.942123,
		-0.081692,
		-0.325162,
		0,
		-0.097741,
		0.860806,
		-0.49946,
		0,
		0.320703,
		0.502334,
		0.803001,
		0,
		-0.01541,
		0.279303,
		-0.656488,
		1
	},
	[0.666666666667] = {
		0.941195,
		-0.092856,
		-0.324853,
		0,
		-0.09529,
		0.849504,
		-0.518905,
		0,
		0.324148,
		0.519346,
		0.790701,
		0,
		-0.014878,
		0.263132,
		-0.648654,
		1
	},
	[0.683333333333] = {
		0.940272,
		-0.103842,
		-0.324199,
		0,
		-0.093268,
		0.837319,
		-0.5387,
		0,
		0.327398,
		0.536762,
		0.777623,
		0,
		-0.014332,
		0.246714,
		-0.639889,
		1
	},
	[0.6] = {
		0.944739,
		-0.049304,
		-0.324095,
		0,
		-0.108864,
		0.885338,
		-0.452023,
		0,
		0.30922,
		0.462326,
		0.831046,
		0,
		-0.017529,
		0.321078,
		-0.671983,
		1
	},
	[0.716666666667] = {
		0.938511,
		-0.12461,
		-0.321978,
		0,
		-0.089986,
		0.812072,
		-0.576578,
		0,
		0.333316,
		0.570098,
		0.750925,
		0,
		-0.01314,
		0.214953,
		-0.620457,
		1
	},
	[0.733333333333] = {
		0.937707,
		-0.134059,
		-0.320521,
		0,
		-0.088456,
		0.800032,
		-0.593401,
		0,
		0.335978,
		0.584789,
		0.738337,
		0,
		-0.012421,
		0.200436,
		-0.61041,
		1
	},
	[0.75] = {
		0.936971,
		-0.142691,
		-0.318944,
		0,
		-0.0868,
		0.789143,
		-0.608046,
		0,
		0.338455,
		0.597405,
		0.727018,
		0,
		-0.011546,
		0.187324,
		-0.60066,
		1
	},
	[0.766666666667] = {
		0.93631,
		-0.150374,
		-0.317351,
		0,
		-0.084861,
		0.780017,
		-0.619977,
		0,
		0.340767,
		0.607421,
		0.717577,
		0,
		-0.010461,
		0.175975,
		-0.591613,
		1
	},
	[0.783333333333] = {
		0.935729,
		-0.156992,
		-0.315856,
		0,
		-0.082473,
		0.773281,
		-0.628677,
		0,
		0.342943,
		0.61432,
		0.710634,
		0,
		-0.009114,
		0.166742,
		-0.58368,
		1
	},
	[0.7] = {
		0.939372,
		-0.11448,
		-0.323225,
		0,
		-0.091546,
		0.82468,
		-0.558142,
		0,
		0.330453,
		0.553893,
		0.764201,
		0,
		-0.013757,
		0.230507,
		-0.630408,
		1
	},
	[0.816666666667] = {
		0.93484,
		-0.166526,
		-0.313596,
		0,
		-0.075713,
		0.769398,
		-0.634267,
		0,
		0.346902,
		0.616682,
		0.706656,
		0,
		-0.005418,
		0.156047,
		-0.572774,
		1
	},
	[0.833333333333] = {
		0.934558,
		-0.169177,
		-0.313017,
		0,
		-0.07101,
		0.773354,
		-0.629985,
		0,
		0.348652,
		0.610985,
		0.710731,
		0,
		-0.002948,
		0.155339,
		-0.57057,
		1
	},
	[0.85] = {
		0.934484,
		-0.170347,
		-0.312605,
		0,
		-0.065244,
		0.781271,
		-0.620773,
		0,
		0.349976,
		0.600498,
		0.718971,
		0,
		0.000155,
		0.157813,
		-0.570201,
		1
	},
	[0.866666666667] = {
		0.934698,
		-0.170174,
		-0.312059,
		0,
		-0.058447,
		0.792407,
		-0.607186,
		0,
		0.350605,
		0.585775,
		0.730715,
		0,
		0.004019,
		0.163047,
		-0.570874,
		1
	},
	[0.883333333333] = {
		0.935189,
		-0.168769,
		-0.31135,
		0,
		-0.050713,
		0.80627,
		-0.589369,
		0,
		0.3505,
		0.566961,
		0.745456,
		0,
		0.008605,
		0.170881,
		-0.572411,
		1
	},
	[0.8] = {
		0.935235,
		-0.162421,
		-0.314572,
		0,
		-0.079477,
		0.769548,
		-0.633623,
		0,
		0.344992,
		0.617588,
		0.706799,
		0,
		-0.007452,
		0.159977,
		-0.577268,
		1
	},
	[0.916666666667] = {
		0.936946,
		-0.162705,
		-0.309289,
		0,
		-0.032906,
		0.840005,
		-0.541579,
		0,
		0.347922,
		0.517608,
		0.781685,
		0,
		0.0198,
		0.193722,
		-0.577288,
		1
	},
	[0.933333333333] = {
		0.938155,
		-0.158269,
		-0.307921,
		0,
		-0.023153,
		0.858723,
		-0.511917,
		0,
		0.345439,
		0.487387,
		0.801951,
		0,
		0.026285,
		0.208395,
		-0.580209,
		1
	},
	[0.95] = {
		0.939527,
		-0.153051,
		-0.306371,
		0,
		-0.013085,
		0.877889,
		-0.478685,
		0,
		0.342223,
		0.453746,
		0.822798,
		0,
		0.032864,
		0.224496,
		-0.584052,
		1
	},
	[0.966666666667] = {
		0.941039,
		-0.147172,
		-0.304609,
		0,
		-0.002855,
		0.896926,
		-0.442171,
		0,
		0.338287,
		0.41697,
		0.843622,
		0,
		0.039176,
		0.241539,
		-0.589465,
		1
	},
	[0.983333333333] = {
		0.942661,
		-0.140759,
		-0.302617,
		0,
		0.007383,
		0.915285,
		-0.402738,
		0,
		0.33367,
		0.377412,
		0.863843,
		0,
		0.045251,
		0.259608,
		-0.596194,
		1
	},
	[0.9] = {
		0.935944,
		-0.166242,
		-0.310439,
		0,
		-0.042153,
		0.822328,
		-0.56745,
		0,
		0.349617,
		0.544187,
		0.762646,
		0,
		0.013877,
		0.18116,
		-0.574618,
		1
	},
	[1.01666666667] = {
		0.946123,
		-0.126848,
		-0.297927,
		0,
		0.027283,
		0.948033,
		-0.317001,
		0,
		0.322656,
		0.291794,
		0.900416,
		0,
		0.056778,
		0.298937,
		-0.612542,
		1
	},
	[1.03333333333] = {
		0.947898,
		-0.119627,
		-0.29526,
		0,
		0.036669,
		0.96163,
		-0.271889,
		0,
		0.316456,
		0.246897,
		0.915913,
		0,
		0.062247,
		0.320079,
		-0.621646,
		1
	},
	[1.05] = {
		0.949657,
		-0.112393,
		-0.292438,
		0,
		0.045528,
		0.973035,
		-0.226119,
		0,
		0.309966,
		0.201421,
		0.929167,
		0,
		0.06751,
		0.342047,
		-0.631022,
		1
	},
	[1.06666666667] = {
		0.951365,
		-0.105255,
		-0.289527,
		0,
		0.053759,
		0.982124,
		-0.180395,
		0,
		0.303339,
		0.156057,
		0.940017,
		0,
		0.072538,
		0.364646,
		-0.640422,
		1
	},
	[1.08333333333] = {
		0.952988,
		-0.098312,
		-0.286616,
		0,
		0.061294,
		0.988893,
		-0.135401,
		0,
		0.296744,
		0.111467,
		0.948429,
		0,
		0.077285,
		0.387614,
		-0.649623,
		1
	},
	[1.11666666667] = {
		0.955846,
		-0.085336,
		-0.281206,
		0,
		0.074117,
		0.99598,
		-0.050312,
		0,
		0.284369,
		0.027248,
		0.958328,
		0,
		0.085678,
		0.433317,
		-0.666703,
		1
	},
	[1.13333333333] = {
		0.957028,
		-0.079432,
		-0.278906,
		0,
		0.079375,
		0.996778,
		-0.011516,
		0,
		0.278922,
		-0.011117,
		0.960249,
		0,
		0.089155,
		0.455257,
		-0.674313,
		1
	},
	[1.15] = {
		0.957995,
		-0.073986,
		-0.277078,
		0,
		0.083882,
		0.996186,
		0.024016,
		0,
		0.274244,
		-0.046249,
		0.960547,
		0,
		0.092023,
		0.475996,
		-0.681191,
		1
	},
	[1.16666666667] = {
		0.958717,
		-0.069037,
		-0.275855,
		0,
		0.087662,
		0.994589,
		0.055756,
		0,
		0.270513,
		-0.077636,
		0.959581,
		0,
		0.094172,
		0.495054,
		-0.687299,
		1
	},
	[1.18333333333] = {
		0.959164,
		-0.064619,
		-0.275369,
		0,
		0.090749,
		0.99239,
		0.083221,
		0,
		0.267896,
		-0.104812,
		0.95773,
		0,
		0.09549,
		0.511938,
		-0.692624,
		1
	},
	[1.1] = {
		0.954493,
		-0.091648,
		-0.283802,
		0,
		0.068087,
		0.993445,
		-0.091821,
		0,
		0.290357,
		0.06832,
		0.954477,
		0,
		0.081691,
		0.41063,
		-0.658435,
		1
	},
	[1.21666666667] = {
		0.959121,
		-0.05751,
		-0.277093,
		0,
		0.094946,
		0.987775,
		0.123634,
		0,
		0.266595,
		-0.144889,
		0.952856,
		0,
		0.09518,
		0.537189,
		-0.700951,
		1
	},
	[1.23333333333] = {
		0.958552,
		-0.054913,
		-0.279575,
		0,
		0.096077,
		0.986077,
		0.135729,
		0,
		0.268229,
		-0.156964,
		0.950482,
		0,
		0.09334,
		0.544565,
		-0.703959,
		1
	},
	[1.25] = {
		0.957534,
		-0.053329,
		-0.283347,
		0,
		0.096762,
		0.985188,
		0.141572,
		0,
		0.2716,
		-0.162977,
		0.94851,
		0,
		0.090109,
		0.547703,
		-0.706514,
		1
	},
	[1.26666666667] = {
		0.956048,
		-0.052939,
		-0.288391,
		0,
		0.097165,
		0.985192,
		0.141265,
		0,
		0.276642,
		-0.163078,
		0.947035,
		0,
		0.085486,
		0.546575,
		-0.708728,
		1
	},
	[1.28333333333] = {
		0.954131,
		-0.053566,
		-0.294559,
		0,
		0.097204,
		0.985989,
		0.13556,
		0,
		0.283171,
		-0.157974,
		0.94597,
		0,
		0.079733,
		0.54156,
		-0.710222,
		1
	},
	[1.2] = {
		0.959306,
		-0.060766,
		-0.275752,
		0,
		0.09317,
		0.989995,
		0.105969,
		0,
		0.266554,
		-0.127349,
		0.95537,
		0,
		0.095863,
		0.52615,
		-0.697172,
		1
	},
	[1.31666666667] = {
		0.949071,
		-0.057193,
		-0.309829,
		0,
		0.095755,
		0.989229,
		0.110713,
		0,
		0.30016,
		-0.134742,
		0.944324,
		0,
		0.06461,
		0.522291,
		-0.713776,
		1
	},
	[1.33333333333] = {
		0.945977,
		-0.059872,
		-0.318657,
		0,
		0.094045,
		0.99122,
		0.092944,
		0,
		0.310295,
		-0.117891,
		0.943302,
		0,
		0.055342,
		0.509091,
		-0.716333,
		1
	},
	[1.35] = {
		0.942548,
		-0.062905,
		-0.328094,
		0,
		0.09153,
		0.993157,
		0.072532,
		0,
		0.321286,
		-0.098396,
		0.941856,
		0,
		0.045209,
		0.494101,
		-0.719061,
		1
	},
	[1.36666666667] = {
		0.93881,
		-0.066107,
		-0.338031,
		0,
		0.088126,
		0.994844,
		0.050195,
		0,
		0.33297,
		-0.076913,
		0.939795,
		0,
		0.034423,
		0.477766,
		-0.72172,
		1
	},
	[1.38333333333] = {
		0.9348,
		-0.069283,
		-0.348351,
		0,
		0.083762,
		0.996129,
		0.026658,
		0,
		0.345155,
		-0.054098,
		0.936985,
		0,
		0.023199,
		0.46054,
		-0.724092,
		1
	},
	[1.3] = {
		0.951796,
		-0.055037,
		-0.301755,
		0,
		0.096773,
		0.987407,
		0.125149,
		0,
		0.291067,
		-0.148318,
		0.945136,
		0,
		0.072808,
		0.53326,
		-0.711651,
		1
	},
	[1.41666666667] = {
		0.926115,
		-0.074668,
		-0.369777,
		0,
		0.072006,
		0.997183,
		-0.021019,
		0,
		0.370305,
		-0.00716,
		0.928883,
		0,
		0.000305,
		0.42525,
		-0.727276,
		1
	},
	[1.43333333333] = {
		0.921545,
		-0.076389,
		-0.380683,
		0,
		0.064596,
		0.996955,
		-0.043681,
		0,
		0.382861,
		0.015663,
		0.923673,
		0,
		-0.010936,
		0.408114,
		-0.727832,
		1
	},
	[1.45] = {
		0.916866,
		-0.0771,
		-0.391679,
		0,
		0.056211,
		0.996331,
		-0.064542,
		0,
		0.395218,
		0.03716,
		0.917836,
		0,
		-0.02176,
		0.391931,
		-0.72759,
		1
	},
	[1.46666666667] = {
		0.912132,
		-0.076512,
		-0.402691,
		0,
		0.046908,
		0.995454,
		-0.082886,
		0,
		0.407203,
		0.056714,
		0.911575,
		0,
		-0.031968,
		0.377157,
		-0.726509,
		1
	},
	[1.48333333333] = {
		0.907364,
		-0.074317,
		-0.413725,
		0,
		0.036789,
		0.99451,
		-0.097959,
		0,
		0.418733,
		0.073664,
		0.905117,
		0,
		-0.041371,
		0.36424,
		-0.724577,
		1
	},
	[1.4] = {
		0.930554,
		-0.072216,
		-0.358963,
		0,
		0.078397,
		0.996919,
		0.002671,
		0,
		0.357664,
		-0.030627,
		0.933348,
		0,
		0.011754,
		0.44288,
		-0.725993,
		1
	},
	[1.51666666667] = {
		0.897811,
		-0.063758,
		-0.435742,
		0,
		0.014496,
		0.993207,
		-0.115459,
		0,
		0.440143,
		0.097344,
		0.892636,
		0,
		-0.057069,
		0.345728,
		-0.718166,
		1
	},
	[1.53333333333] = {
		0.891891,
		-0.050055,
		-0.449472,
		0,
		-0.001893,
		0.993434,
		-0.11439,
		0,
		0.452247,
		0.102874,
		0.88594,
		0,
		-0.06408,
		0.341191,
		-0.713215,
		1
	},
	[1.55] = {
		0.884215,
		-0.028319,
		-0.466222,
		0,
		-0.02407,
		0.994071,
		-0.106032,
		0,
		0.46646,
		0.104977,
		0.878291,
		0,
		-0.071123,
		0.339471,
		-0.707203,
		1
	},
	[1.56666666667] = {
		0.87604,
		-0.004867,
		-0.482214,
		0,
		-0.046465,
		0.994445,
		-0.094449,
		0,
		0.479995,
		0.105147,
		0.870947,
		0,
		-0.077234,
		0.339374,
		-0.701293,
		1
	},
	[1.58333333333] = {
		0.869326,
		0.013915,
		-0.494043,
		0,
		-0.063698,
		0.994421,
		-0.084076,
		0,
		0.490117,
		0.104559,
		0.865363,
		0,
		-0.081524,
		0.339922,
		-0.696757,
		1
	},
	[1.5] = {
		0.90259,
		-0.070185,
		-0.424741,
		0,
		0.025956,
		0.993698,
		-0.109043,
		0,
		0.429718,
		0.087396,
		0.898724,
		0,
		-0.049792,
		0.353619,
		-0.721794,
		1
	},
	[1.6] = {
		0.866528,
		0.021627,
		-0.49866,
		0,
		-0.070609,
		0.994325,
		-0.079573,
		0,
		0.494109,
		0.104162,
		0.863138,
		0,
		-0.083143,
		0.340288,
		-0.694945,
		1
	}
}

return spline_matrices
