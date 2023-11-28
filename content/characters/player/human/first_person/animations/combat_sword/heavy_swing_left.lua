﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_sword/heavy_swing_left.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.190686,
		-0.103242,
		-0.976207,
		0,
		0.044341,
		0.994345,
		-0.096499,
		0,
		0.980649,
		-0.024885,
		0.194186,
		0,
		0.468009,
		0.393142,
		-0.061842,
		1
	},
	[0.0333333333333] = {
		0.191642,
		-0.101633,
		-0.976189,
		0,
		0.035343,
		0.994694,
		-0.096621,
		0,
		0.980828,
		-0.015985,
		0.194217,
		0,
		0.464433,
		0.397353,
		-0.061877,
		1
	},
	[0.05] = {
		0.190911,
		-0.077044,
		-0.978579,
		0,
		0.006862,
		0.996995,
		-0.077155,
		0,
		0.981583,
		0.008015,
		0.190866,
		0,
		0.444439,
		0.444986,
		-0.053686,
		1
	},
	[0.0666666666667] = {
		0.175527,
		-0.034268,
		-0.983878,
		0,
		-0.090073,
		0.994643,
		-0.050712,
		0,
		0.980345,
		0.097522,
		0.1715,
		0,
		0.395847,
		0.526253,
		-0.049095,
		1
	},
	[0.0833333333333] = {
		0.092874,
		0.065428,
		-0.993526,
		0,
		-0.382397,
		0.923658,
		0.025081,
		0,
		0.919319,
		0.377592,
		0.110803,
		0,
		0.310516,
		0.608575,
		-0.056275,
		1
	},
	[0] = {
		0.1903,
		-0.103884,
		-0.976214,
		0,
		0.047939,
		0.994183,
		-0.096451,
		0,
		0.980555,
		-0.028444,
		0.194173,
		0,
		0.469428,
		0.391448,
		-0.061828,
		1
	},
	[0.116666666667] = {
		-0.022083,
		0.085755,
		-0.996072,
		0,
		-0.905999,
		0.419532,
		0.056205,
		0,
		0.422704,
		0.903681,
		0.068429,
		0,
		0.08371,
		0.732955,
		-0.05483,
		1
	},
	[0.133333333333] = {
		-0.005406,
		0.054532,
		-0.998497,
		0,
		-0.997043,
		0.076243,
		0.009562,
		0,
		0.07665,
		0.995597,
		0.053958,
		0,
		-0.042224,
		0.747834,
		-0.047064,
		1
	},
	[0.15] = {
		-0.004095,
		0.060336,
		-0.99817,
		0,
		-0.98636,
		-0.164497,
		-0.005896,
		0,
		-0.164551,
		0.984531,
		0.060187,
		0,
		-0.200852,
		0.714477,
		-0.052614,
		1
	},
	[0.166666666667] = {
		-0.001843,
		0.091312,
		-0.995821,
		0,
		-0.92437,
		-0.380054,
		-0.033138,
		0,
		-0.381492,
		0.920446,
		0.085107,
		0,
		-0.355165,
		0.645387,
		-0.063137,
		1
	},
	[0.183333333333] = {
		0.009393,
		0.128267,
		-0.991695,
		0,
		-0.773775,
		-0.627254,
		-0.088459,
		0,
		-0.633391,
		0.768179,
		0.093359,
		0,
		-0.451993,
		0.521638,
		-0.074499,
		1
	},
	[0.1] = {
		-0.011327,
		0.122611,
		-0.99239,
		0,
		-0.687696,
		0.719523,
		0.096748,
		0,
		0.72591,
		0.683559,
		0.076169,
		0,
		0.199148,
		0.679841,
		-0.061252,
		1
	},
	[0.216666666667] = {
		-0.042004,
		0.129785,
		-0.990652,
		0,
		-0.477072,
		-0.873796,
		-0.094248,
		0,
		-0.87786,
		0.468654,
		0.09862,
		0,
		-0.557513,
		0.227886,
		-0.129952,
		1
	},
	[0.233333333333] = {
		-0.069852,
		0.101789,
		-0.992351,
		0,
		-0.315651,
		-0.945922,
		-0.074808,
		0,
		-0.946301,
		0.308011,
		0.098205,
		0,
		-0.573811,
		0.084489,
		-0.173462,
		1
	},
	[0.25] = {
		0.017527,
		0.181407,
		-0.983252,
		0,
		0.213293,
		-0.961445,
		-0.173581,
		0,
		-0.976831,
		-0.206679,
		-0.055545,
		0,
		-0.535563,
		-0.052429,
		-0.22904,
		1
	},
	[0.266666666667] = {
		0.073089,
		0.299326,
		-0.951347,
		0,
		0.666395,
		-0.724355,
		-0.176709,
		0,
		-0.742007,
		-0.621058,
		-0.252412,
		0,
		-0.469884,
		-0.141473,
		-0.275728,
		1
	},
	[0.283333333333] = {
		0.106463,
		0.329269,
		-0.938215,
		0,
		0.783444,
		-0.608811,
		-0.124763,
		0,
		-0.612276,
		-0.721756,
		-0.322779,
		0,
		-0.438683,
		-0.19523,
		-0.300971,
		1
	},
	[0.2] = {
		0.017909,
		0.157651,
		-0.987332,
		0,
		-0.581095,
		-0.801949,
		-0.138591,
		0,
		-0.813639,
		0.576215,
		0.077248,
		0,
		-0.512141,
		0.374305,
		-0.095274,
		1
	},
	[0.316666666667] = {
		0.214452,
		0.300753,
		-0.929278,
		0,
		0.774132,
		-0.632488,
		-0.026051,
		0,
		-0.595592,
		-0.713797,
		-0.368461,
		0,
		-0.411736,
		-0.265579,
		-0.335886,
		1
	},
	[0.333333333333] = {
		0.289388,
		0.281212,
		-0.914972,
		0,
		0.735647,
		-0.676918,
		0.024624,
		0,
		-0.612437,
		-0.680222,
		-0.402764,
		0,
		-0.391658,
		-0.274028,
		-0.350237,
		1
	},
	[0.35] = {
		0.381657,
		0.267384,
		-0.884784,
		0,
		0.684362,
		-0.725164,
		0.076057,
		0,
		-0.621278,
		-0.634541,
		-0.459752,
		0,
		-0.358576,
		-0.247057,
		-0.363451,
		1
	},
	[0.366666666667] = {
		0.486687,
		0.238451,
		-0.840403,
		0,
		0.596623,
		-0.793441,
		0.120385,
		0,
		-0.638104,
		-0.559994,
		-0.528423,
		0,
		-0.318262,
		-0.190585,
		-0.377082,
		1
	},
	[0.383333333333] = {
		0.588579,
		0.192412,
		-0.785208,
		0,
		0.485154,
		-0.860996,
		0.152679,
		0,
		-0.646684,
		-0.470811,
		-0.600114,
		0,
		-0.275653,
		-0.129801,
		-0.393962,
		1
	},
	[0.3] = {
		0.152597,
		0.323759,
		-0.933753,
		0,
		0.801769,
		-0.592963,
		-0.07457,
		0,
		-0.577824,
		-0.737275,
		-0.350064,
		0,
		-0.423119,
		-0.23745,
		-0.320089,
		1
	},
	[0.416666666667] = {
		0.751438,
		0.061085,
		-0.65697,
		0,
		0.239291,
		-0.953145,
		0.185077,
		0,
		-0.614883,
		-0.296281,
		-0.730846,
		0,
		-0.196257,
		-0.072611,
		-0.448469,
		1
	},
	[0.433333333333] = {
		0.816171,
		-0.033437,
		-0.576843,
		0,
		0.088493,
		-0.979313,
		0.181974,
		0,
		-0.570994,
		-0.199568,
		-0.796328,
		0,
		-0.149992,
		-0.056677,
		-0.488745,
		1
	},
	[0.45] = {
		0.85928,
		-0.140944,
		-0.491705,
		0,
		-0.06887,
		-0.984414,
		0.161823,
		0,
		-0.506849,
		-0.105187,
		-0.855593,
		0,
		-0.102525,
		-0.041238,
		-0.531401,
		1
	},
	[0.466666666667] = {
		0.877086,
		-0.2481,
		-0.411299,
		0,
		-0.213958,
		-0.968432,
		0.12791,
		0,
		-0.430049,
		-0.024188,
		-0.902481,
		0,
		-0.0596,
		-0.025301,
		-0.570214,
		1
	},
	[0.483333333333] = {
		0.874814,
		-0.340116,
		-0.344994,
		0,
		-0.330212,
		-0.939694,
		0.089077,
		0,
		-0.354486,
		0.035995,
		-0.934368,
		0,
		-0.028092,
		-0.011761,
		-0.598936,
		1
	},
	[0.4] = {
		0.675518,
		0.134236,
		-0.725022,
		0,
		0.367836,
		-0.913546,
		0.17358,
		0,
		-0.63904,
		-0.383945,
		-0.666493,
		0,
		-0.236395,
		-0.090578,
		-0.41646,
		1
	},
	[0.516666666667] = {
		0.852991,
		-0.448076,
		-0.267645,
		0,
		-0.456863,
		-0.888954,
		0.032205,
		0,
		-0.252354,
		0.094807,
		-0.962979,
		0,
		-0.014445,
		-0.000333,
		-0.614,
		1
	},
	[0.533333333333] = {
		0.840337,
		-0.485715,
		-0.240655,
		0,
		-0.498418,
		-0.866888,
		0.009233,
		0,
		-0.213105,
		0.112188,
		-0.970567,
		0,
		-0.01332,
		0.003058,
		-0.615712,
		1
	},
	[0.55] = {
		0.827375,
		-0.517704,
		-0.217791,
		0,
		-0.532614,
		-0.846277,
		-0.011711,
		0,
		-0.178249,
		0.125688,
		-0.975925,
		0,
		-0.012123,
		0.005899,
		-0.616808,
		1
	},
	[0.566666666667] = {
		0.814885,
		-0.54454,
		-0.198589,
		0,
		-0.560458,
		-0.827625,
		-0.030382,
		0,
		-0.147813,
		0.136059,
		-0.979612,
		0,
		-0.010935,
		0.008235,
		-0.617353,
		1
	},
	[0.583333333333] = {
		0.803419,
		-0.566718,
		-0.182617,
		0,
		-0.582844,
		-0.811243,
		-0.046664,
		0,
		-0.121702,
		0.143928,
		-0.982076,
		0,
		-0.009812,
		0.010116,
		-0.617409,
		1
	},
	[0.5] = {
		0.864276,
		-0.404336,
		-0.299231,
		0,
		-0.406868,
		-0.91172,
		0.056793,
		0,
		-0.295778,
		0.072662,
		-0.952489,
		0,
		-0.015393,
		-0.004317,
		-0.611608,
		1
	},
	[0.616666666667] = {
		0.784891,
		-0.598924,
		-0.158859,
		0,
		-0.614222,
		-0.785842,
		-0.072002,
		0,
		-0.081714,
		0.154089,
		-0.984672,
		0,
		-0.007909,
		0.012688,
		-0.616284,
		1
	},
	[0.633333333333] = {
		0.77818,
		-0.609757,
		-0.150444,
		0,
		-0.624416,
		-0.776864,
		-0.081162,
		0,
		-0.067386,
		0.157098,
		-0.985281,
		0,
		-0.007169,
		0.013459,
		-0.615206,
		1
	},
	[0.65] = {
		0.77325,
		-0.617535,
		-0.143998,
		0,
		-0.631578,
		-0.770291,
		-0.088103,
		0,
		-0.056514,
		0.159071,
		-0.985648,
		0,
		-0.006584,
		0.013933,
		-0.613846,
		1
	},
	[0.666666666667] = {
		0.770083,
		-0.622546,
		-0.139315,
		0,
		-0.63607,
		-0.766014,
		-0.092939,
		0,
		-0.048859,
		0.160185,
		-0.985877,
		0,
		-0.006152,
		0.014139,
		-0.612246,
		1
	},
	[0.683333333333] = {
		0.768612,
		-0.625042,
		-0.136228,
		0,
		-0.638187,
		-0.763899,
		-0.095793,
		0,
		-0.04419,
		0.160566,
		-0.986035,
		0,
		-0.005872,
		0.014104,
		-0.610443,
		1
	},
	[0.6] = {
		0.793345,
		-0.584704,
		-0.169487,
		0,
		-0.600546,
		-0.797296,
		-0.060527,
		0,
		-0.099741,
		0.149803,
		-0.983672,
		0,
		-0.008795,
		0.011586,
		-0.617034,
		1
	},
	[0.716666666667] = {
		0.77034,
		-0.623327,
		-0.134308,
		0,
		-0.636186,
		-0.765531,
		-0.096074,
		0,
		-0.042932,
		0.159455,
		-0.986271,
		0,
		-0.005732,
		0.013395,
		-0.606371,
		1
	},
	[0.733333333333] = {
		0.773272,
		-0.619478,
		-0.135265,
		0,
		-0.632409,
		-0.768938,
		-0.093768,
		0,
		-0.045923,
		0.158051,
		-0.986362,
		0,
		-0.005852,
		0.01276,
		-0.604165,
		1
	},
	[0.75] = {
		0.777379,
		-0.613847,
		-0.137386,
		0,
		-0.626957,
		-0.773836,
		-0.090014,
		0,
		-0.051059,
		0.15611,
		-0.986419,
		0,
		-0.006081,
		0.011961,
		-0.601886,
		1
	},
	[0.766666666667] = {
		0.782494,
		-0.606577,
		-0.140599,
		0,
		-0.619938,
		-0.780039,
		-0.08495,
		0,
		-0.058144,
		0.153635,
		-0.986415,
		0,
		-0.006406,
		0.011013,
		-0.599564,
		1
	},
	[0.783333333333] = {
		0.788444,
		-0.59781,
		-0.144838,
		0,
		-0.611448,
		-0.787359,
		-0.078718,
		0,
		-0.066981,
		0.150626,
		-0.986319,
		0,
		-0.006811,
		0.009931,
		-0.597227,
		1
	},
	[0.7] = {
		0.768739,
		-0.625239,
		-0.134597,
		0,
		-0.638163,
		-0.763793,
		-0.096794,
		0,
		-0.042285,
		0.160304,
		-0.986162,
		0,
		-0.005735,
		0.013849,
		-0.608474,
		1
	},
	[0.816666666667] = {
		0.802151,
		-0.576347,
		-0.156137,
		0,
		-0.590433,
		-0.804597,
		-0.063338,
		0,
		-0.089123,
		0.142995,
		-0.985703,
		0,
		-0.007799,
		0.007425,
		-0.59262,
		1
	},
	[0.833333333333] = {
		0.809558,
		-0.563941,
		-0.163054,
		0,
		-0.578108,
		-0.814139,
		-0.054493,
		0,
		-0.102018,
		0.138378,
		-0.985111,
		0,
		-0.008346,
		0.006033,
		-0.590408,
		1
	},
	[0.85] = {
		0.817108,
		-0.550628,
		-0.170717,
		0,
		-0.564723,
		-0.824048,
		-0.045082,
		0,
		-0.115855,
		0.133245,
		-0.984288,
		0,
		-0.008909,
		0.004568,
		-0.588296,
		1
	},
	[0.866666666667] = {
		0.824641,
		-0.536574,
		-0.179042,
		0,
		-0.550414,
		-0.834147,
		-0.035258,
		0,
		-0.130429,
		0.127622,
		-0.98321,
		0,
		-0.009475,
		0.003049,
		-0.586314,
		1
	},
	[0.883333333333] = {
		0.832008,
		-0.521961,
		-0.187935,
		0,
		-0.535336,
		-0.844264,
		-0.025174,
		0,
		-0.145527,
		0.121554,
		-0.981859,
		0,
		-0.010032,
		0.001494,
		-0.584493,
		1
	},
	[0.8] = {
		0.795055,
		-0.587686,
		-0.150041,
		0,
		-0.601581,
		-0.795608,
		-0.071464,
		0,
		-0.077375,
		0.14708,
		-0.986094,
		0,
		-0.007282,
		0.00873,
		-0.594903,
		1
	},
	[0.916666666667] = {
		0.845726,
		-0.491836,
		-0.206992,
		0,
		-0.503603,
		-0.863922,
		-0.004842,
		0,
		-0.176444,
		0.108337,
		-0.978331,
		0,
		-0.011086,
		-0.001645,
		-0.581466,
		1
	},
	[0.933333333333] = {
		0.85186,
		-0.476745,
		-0.216908,
		0,
		-0.487375,
		-0.873178,
		0.005108,
		0,
		-0.191834,
		0.101364,
		-0.976179,
		0,
		-0.011567,
		-0.003185,
		-0.580329,
		1
	},
	[0.95] = {
		0.857449,
		-0.461846,
		-0.22689,
		0,
		-0.47114,
		-0.881936,
		0.01472,
		0,
		-0.206901,
		0.094275,
		-0.973809,
		0,
		-0.011996,
		-0.004678,
		-0.579457,
		1
	},
	[0.966666666667] = {
		0.862486,
		-0.447273,
		-0.236779,
		0,
		-0.455064,
		-0.890139,
		0.023855,
		0,
		-0.221436,
		0.087175,
		-0.971271,
		0,
		-0.012356,
		-0.006099,
		-0.578812,
		1
	},
	[0.983333333333] = {
		0.866937,
		-0.433241,
		-0.246421,
		0,
		-0.439416,
		-0.897701,
		0.032364,
		0,
		-0.235233,
		0.080223,
		-0.968622,
		0,
		-0.01265,
		-0.007411,
		-0.578369,
		1
	},
	[0.9] = {
		0.839075,
		-0.50698,
		-0.197291,
		0,
		-0.519665,
		-0.854239,
		-0.014985,
		0,
		-0.160937,
		0.115099,
		-0.98023,
		0,
		-0.010572,
		-7.8e-05,
		-0.582866,
		1
	},
	[1.01666666667] = {
		0.874041,
		-0.407704,
		-0.264255,
		0,
		-0.410544,
		-0.910626,
		0.047052,
		0,
		-0.259821,
		0.067363,
		-0.963304,
		0,
		-0.013053,
		-0.00962,
		-0.577986,
		1
	},
	[1.03333333333] = {
		0.876717,
		-0.396672,
		-0.272063,
		0,
		-0.397923,
		-0.915882,
		0.053074,
		0,
		-0.270231,
		0.061729,
		-0.960815,
		0,
		-0.013174,
		-0.010501,
		-0.577994,
		1
	},
	[1.05] = {
		0.878846,
		-0.387116,
		-0.278874,
		0,
		-0.386923,
		-0.920278,
		0.058124,
		0,
		-0.279142,
		0.05682,
		-0.958567,
		0,
		-0.013252,
		-0.011225,
		-0.578102,
		1
	},
	[1.06666666667] = {
		0.880462,
		-0.379273,
		-0.284498,
		0,
		-0.377854,
		-0.923778,
		0.062139,
		0,
		-0.28638,
		0.052787,
		-0.956661,
		0,
		-0.013296,
		-0.011783,
		-0.578285,
		1
	},
	[1.08333333333] = {
		0.881598,
		-0.373378,
		-0.288747,
		0,
		-0.37102,
		-0.926343,
		0.065059,
		0,
		-0.29177,
		0.049775,
		-0.955192,
		0,
		-0.013312,
		-0.012169,
		-0.578516,
		1
	},
	{
		0.870787,
		-0.419973,
		-0.255643,
		0,
		-0.424477,
		-0.904549,
		0.040124,
		0,
		-0.248093,
		0.073575,
		-0.965938,
		0,
		-0.01288,
		-0.008587,
		-0.578102,
		1
	},
	[1.11666666667] = {
		0.882507,
		-0.368348,
		-0.292405,
		0,
		-0.365222,
		-0.928481,
		0.067349,
		0,
		-0.296301,
		0.047357,
		-0.95392,
		0,
		-0.013292,
		-0.012402,
		-0.579016,
		1
	},
	[1.13333333333] = {
		0.882507,
		-0.36833,
		-0.292428,
		0,
		-0.365222,
		-0.928485,
		0.067292,
		0,
		-0.296301,
		0.047416,
		-0.953917,
		0,
		-0.01328,
		-0.012366,
		-0.579138,
		1
	},
	[1.1] = {
		0.882277,
		-0.369661,
		-0.291441,
		0,
		-0.366717,
		-0.92793,
		0.066819,
		0,
		-0.295137,
		0.047924,
		-0.954252,
		0,
		-0.013309,
		-0.012377,
		-0.578768,
		1
	}
}

return spline_matrices
