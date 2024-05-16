﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_sword/swing_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.649426,
		-0.618198,
		-0.442805,
		0,
		-0.76036,
		-0.535477,
		-0.367583,
		0,
		-0.009873,
		0.575409,
		-0.817806,
		0,
		-0.077306,
		0.150855,
		-0.676084,
		1,
	},
	[0.0333333333333] = {
		0.734276,
		-0.609072,
		-0.299784,
		0,
		-0.677198,
		-0.626388,
		-0.386058,
		0,
		0.047356,
		0.486486,
		-0.872404,
		0,
		-0.006952,
		0.146245,
		-0.661465,
		1,
	},
	[0.05] = {
		0.828308,
		-0.544465,
		-0.132147,
		0,
		-0.559763,
		-0.81426,
		-0.153773,
		0,
		-0.023878,
		0.201342,
		-0.97923,
		0,
		0.07105,
		0.119447,
		-0.622686,
		1,
	},
	[0.0666666666667] = {
		0.93333,
		-0.358881,
		-0.009995,
		0,
		-0.331533,
		-0.872222,
		0.359603,
		0,
		-0.137773,
		-0.332315,
		-0.933052,
		0,
		0.159608,
		0.081132,
		-0.543946,
		1,
	},
	[0.0833333333333] = {
		0.991671,
		-0.117268,
		-0.053255,
		0,
		-0.016629,
		-0.526613,
		0.849943,
		0,
		-0.127716,
		-0.841978,
		-0.524177,
		0,
		0.261415,
		0.071439,
		-0.431969,
		1,
	},
	[0] = {
		0.546617,
		-0.631593,
		-0.549818,
		0,
		-0.802651,
		-0.582322,
		-0.129046,
		0,
		-0.238666,
		0.511851,
		-0.825256,
		0,
		-0.133628,
		0.135025,
		-0.666797,
		1,
	},
	[0.116666666667] = {
		0.948981,
		0.053126,
		-0.310826,
		0,
		0.276968,
		0.330781,
		0.902149,
		0,
		0.150743,
		-0.942211,
		0.299191,
		0,
		0.41887,
		0.132495,
		-0.265799,
		1,
	},
	[0.133333333333] = {
		0.928549,
		0.069777,
		-0.364594,
		0,
		0.280755,
		0.51053,
		0.812734,
		0,
		0.242846,
		-0.857024,
		0.454462,
		0,
		0.444109,
		0.153047,
		-0.21448,
		1,
	},
	[0.15] = {
		0.919486,
		0.087247,
		-0.38332,
		0,
		0.262393,
		0.589875,
		0.763674,
		0,
		0.292739,
		-0.802768,
		0.519488,
		0,
		0.442994,
		0.162431,
		-0.165984,
		1,
	},
	[0.166666666667] = {
		0.917416,
		0.095517,
		-0.386296,
		0,
		0.249866,
		0.617254,
		0.746033,
		0,
		0.309701,
		-0.780945,
		0.542412,
		0,
		0.432852,
		0.165444,
		-0.111741,
		1,
	},
	[0.183333333333] = {
		0.921038,
		0.097463,
		-0.377082,
		0,
		0.243211,
		0.612276,
		0.752307,
		0,
		0.304201,
		-0.784614,
		0.540225,
		0,
		0.415401,
		0.164062,
		-0.05307,
		1,
	},
	[0.1] = {
		0.979999,
		0.016585,
		-0.198309,
		0,
		0.198617,
		-0.019558,
		0.979882,
		0,
		0.012373,
		-0.999671,
		-0.022461,
		0,
		0.355215,
		0.099697,
		-0.334436,
		1,
	},
	[0.216666666667] = {
		0.938464,
		0.084369,
		-0.334914,
		0,
		0.235459,
		0.553137,
		0.799123,
		0,
		0.252675,
		-0.828807,
		0.499234,
		0,
		0.363529,
		0.154891,
		0.06955,
		1,
	},
	[0.233333333333] = {
		0.949094,
		0.069719,
		-0.307181,
		0,
		0.228662,
		0.51822,
		0.824113,
		0,
		0.216643,
		-0.852401,
		0.475897,
		0,
		0.331357,
		0.149981,
		0.129431,
		1,
	},
	[0.25] = {
		0.959389,
		0.050506,
		-0.27753,
		0,
		0.217812,
		0.492552,
		0.842585,
		0,
		0.179254,
		-0.868816,
		0.461548,
		0,
		0.296584,
		0.146483,
		0.18589,
		1,
	},
	[0.266666666667] = {
		0.968627,
		0.028026,
		-0.246932,
		0,
		0.202576,
		0.486531,
		0.849853,
		0,
		0.143958,
		-0.873213,
		0.46559,
		0,
		0.260422,
		0.145542,
		0.23724,
		1,
	},
	[0.283333333333] = {
		0.976502,
		0.004165,
		-0.215467,
		0,
		0.183075,
		0.511445,
		0.839588,
		0,
		0.113697,
		-0.859306,
		0.498665,
		0,
		0.224065,
		0.148456,
		0.281779,
		1,
	},
	[0.2] = {
		0.92862,
		0.093719,
		-0.359,
		0,
		0.239493,
		0.587607,
		0.772891,
		0,
		0.283386,
		-0.8037,
		0.523219,
		0,
		0.391918,
		0.160033,
		0.008056,
		1,
	},
	[0.316666666667] = {
		0.988531,
		-0.035182,
		-0.146863,
		0,
		0.129458,
		0.698178,
		0.704122,
		0,
		0.077764,
		-0.715059,
		0.694725,
		0,
		0.154814,
		0.257562,
		0.339645,
		1,
	},
	[0.333333333333] = {
		0.993187,
		-0.039322,
		-0.109701,
		0,
		0.089756,
		0.85851,
		0.50488,
		0,
		0.074327,
		-0.511287,
		0.85619,
		0,
		0.123421,
		0.436571,
		0.342385,
		1,
	},
	[0.35] = {
		0.998181,
		-0.009126,
		-0.059594,
		0,
		0.005326,
		0.99796,
		-0.063613,
		0,
		0.060053,
		0.06318,
		0.996194,
		0,
		0.07589,
		0.666997,
		0.236016,
		1,
	},
	[0.366666666667] = {
		0.997887,
		0.044294,
		-0.047532,
		0,
		-0.064844,
		0.724711,
		-0.685995,
		0,
		0.004061,
		0.687628,
		0.726052,
		0,
		0.026682,
		0.821306,
		0.021176,
		1,
	},
	[0.383333333333] = {
		0.995532,
		0.040116,
		-0.085483,
		0,
		-0.093201,
		0.272006,
		-0.957772,
		0,
		-0.01517,
		0.961459,
		0.274529,
		0,
		0.011517,
		0.829514,
		-0.215598,
		1,
	},
	[0.3] = {
		0.98305,
		-0.018344,
		-0.182417,
		0,
		0.159174,
		0.579105,
		0.799563,
		0,
		0.090972,
		-0.815047,
		0.572209,
		0,
		0.188633,
		0.156984,
		0.317449,
		1,
	},
	[0.416666666667] = {
		0.994716,
		0.078523,
		-0.066133,
		0,
		-0.029085,
		-0.402246,
		-0.915069,
		0,
		-0.098456,
		0.912158,
		-0.397837,
		0,
		-0.045918,
		0.696699,
		-0.635238,
		1,
	},
	[0.433333333333] = {
		0.989474,
		0.134974,
		-0.052178,
		0,
		0.030244,
		-0.545498,
		-0.837566,
		0,
		-0.141512,
		0.827172,
		-0.543838,
		0,
		-0.064338,
		0.561761,
		-0.767815,
		1,
	},
	[0.45] = {
		0.987457,
		0.095566,
		-0.12568,
		0,
		-0.018276,
		-0.721477,
		-0.692197,
		0,
		-0.156826,
		0.685812,
		-0.710681,
		0,
		-0.046199,
		0.465397,
		-0.835029,
		1,
	},
	[0.466666666667] = {
		0.973799,
		-0.010962,
		-0.227145,
		0,
		-0.119367,
		-0.874815,
		-0.469522,
		0,
		-0.193562,
		0.484334,
		-0.853202,
		0,
		-0.027342,
		0.369208,
		-0.883947,
		1,
	},
	[0.483333333333] = {
		0.936431,
		-0.170978,
		-0.306371,
		0,
		-0.236713,
		-0.952421,
		-0.191995,
		0,
		-0.258967,
		0.252312,
		-0.932349,
		0,
		-0.015895,
		0.290929,
		-0.909762,
		1,
	},
	[0.4] = {
		0.992617,
		0.039755,
		-0.114591,
		0,
		-0.105727,
		-0.179412,
		-0.978076,
		0,
		-0.059443,
		0.982971,
		-0.173884,
		0,
		-0.00638,
		0.801504,
		-0.445012,
		1,
	},
	[0.516666666667] = {
		0.80716,
		-0.499887,
		-0.314014,
		0,
		-0.364431,
		-0.840413,
		0.401119,
		0,
		-0.464416,
		-0.209331,
		-0.860522,
		0,
		-0.01816,
		0.172473,
		-0.912341,
		1,
	},
	[0.533333333333] = {
		0.743327,
		-0.613591,
		-0.266404,
		0,
		-0.342005,
		-0.690871,
		0.636969,
		0,
		-0.57489,
		-0.382365,
		-0.723394,
		0,
		-0.022367,
		0.126819,
		-0.898026,
		1,
	},
	[0.55] = {
		0.710842,
		-0.611173,
		-0.348096,
		0,
		-0.269592,
		-0.693867,
		0.667734,
		0,
		-0.649634,
		-0.38081,
		-0.657997,
		0,
		-0.023891,
		0.080851,
		-0.871586,
		1,
	},
	[0.566666666667] = {
		0.597548,
		-0.605556,
		-0.525583,
		0,
		-0.080117,
		-0.697287,
		0.7123,
		0,
		-0.797821,
		-0.383525,
		-0.465178,
		0,
		-0.022475,
		0.03211,
		-0.80526,
		1,
	},
	[0.583333333333] = {
		0.395499,
		-0.599261,
		-0.696037,
		0,
		0.165531,
		-0.698909,
		0.695791,
		0,
		-0.903427,
		-0.390401,
		-0.177222,
		0,
		-0.013377,
		-0.014688,
		-0.722106,
		1,
	},
	[0.5] = {
		0.880377,
		-0.346023,
		-0.324352,
		0,
		-0.330493,
		-0.938092,
		0.103723,
		0,
		-0.340162,
		0.015881,
		-0.940233,
		0,
		-0.013507,
		0.227748,
		-0.914633,
		1,
	},
	[0.616666666667] = {
		-0.005072,
		-0.593436,
		-0.804865,
		0,
		0.505725,
		-0.695881,
		0.509894,
		0,
		-0.86268,
		-0.404454,
		0.303645,
		0,
		0.012007,
		-0.082022,
		-0.587209,
		1,
	},
	[0.633333333333] = {
		-0.022812,
		-0.593308,
		-0.804652,
		0,
		0.516223,
		-0.696253,
		0.498745,
		0,
		-0.85615,
		-0.404002,
		0.322162,
		0,
		0.009707,
		-0.092359,
		-0.563601,
		1,
	},
	[0.65] = {
		-0.023529,
		-0.593681,
		-0.804357,
		0,
		0.515259,
		-0.696685,
		0.499138,
		0,
		-0.856712,
		-0.402707,
		0.322292,
		0,
		0.005662,
		-0.090044,
		-0.558451,
		1,
	},
	[0.666666666667] = {
		-0.024141,
		-0.594246,
		-0.803921,
		0,
		0.514287,
		-0.696968,
		0.499744,
		0,
		-0.857278,
		-0.401382,
		0.322438,
		0,
		0.001729,
		-0.083267,
		-0.554162,
		1,
	},
	[0.683333333333] = {
		-0.024633,
		-0.594989,
		-0.803356,
		0,
		0.513332,
		-0.697095,
		0.500548,
		0,
		-0.857836,
		-0.400059,
		0.322599,
		0,
		-0.001909,
		-0.072753,
		-0.550635,
		1,
	},
	[0.6] = {
		0.162373,
		-0.595013,
		-0.787143,
		0,
		0.38153,
		-0.697824,
		0.606198,
		0,
		-0.909983,
		-0.398749,
		0.113708,
		0,
		0.001081,
		-0.054448,
		-0.643927,
		1,
	},
	[0.716666666667] = {
		-0.025207,
		-0.596954,
		-0.80188,
		0,
		0.511565,
		-0.696855,
		0.502687,
		0,
		-0.858875,
		-0.397542,
		0.322946,
		0,
		-0.007594,
		-0.043435,
		-0.545477,
		1,
	},
	[0.733333333333] = {
		-0.025262,
		-0.598147,
		-0.800988,
		0,
		0.5108,
		-0.696475,
		0.503991,
		0,
		-0.859328,
		-0.396413,
		0.323128,
		0,
		-0.009299,
		-0.026091,
		-0.543648,
		1,
	},
	[0.75] = {
		-0.025194,
		-0.599462,
		-0.800006,
		0,
		0.510092,
		-0.695952,
		0.505428,
		0,
		-0.859751,
		-0.395343,
		0.323315,
		0,
		-0.010025,
		-0.007931,
		-0.542186,
		1,
	},
	[0.766666666667] = {
		-0.025053,
		-0.600883,
		-0.798945,
		0,
		0.509395,
		-0.695331,
		0.506982,
		0,
		-0.860168,
		-0.394277,
		0.323507,
		0,
		-0.009609,
		0.010317,
		-0.540981,
		1,
	},
	[0.783333333333] = {
		-0.024847,
		-0.602394,
		-0.797812,
		0,
		0.50871,
		-0.694624,
		0.508637,
		0,
		-0.860579,
		-0.393217,
		0.323703,
		0,
		-0.007881,
		0.027923,
		-0.539923,
		1,
	},
	[0.7] = {
		-0.024993,
		-0.595896,
		-0.802673,
		0,
		0.512417,
		-0.697059,
		0.501535,
		0,
		-0.858373,
		-0.398768,
		0.322769,
		0,
		-0.005075,
		-0.059233,
		-0.547773,
		1,
	},
	[0.816666666667] = {
		-0.024275,
		-0.60563,
		-0.795376,
		0,
		0.507372,
		-0.692993,
		0.512186,
		0,
		-0.861385,
		-0.391118,
		0.324102,
		0,
		0.000195,
		0.058305,
		-0.537757,
		1,
	},
	[0.833333333333] = {
		-0.023926,
		-0.607326,
		-0.794092,
		0,
		0.506719,
		-0.692092,
		0.514048,
		0,
		-0.861779,
		-0.390082,
		0.324302,
		0,
		0.005423,
		0.069635,
		-0.536375,
		1,
	},
	[0.85] = {
		-0.023546,
		-0.609055,
		-0.792778,
		0,
		0.506076,
		-0.691148,
		0.515947,
		0,
		-0.862167,
		-0.389058,
		0.324502,
		0,
		0.009663,
		0.076805,
		-0.534607,
		1,
	},
	[0.866666666667] = {
		-0.023143,
		-0.610803,
		-0.791444,
		0,
		0.505444,
		-0.690174,
		0.517867,
		0,
		-0.862549,
		-0.388045,
		0.324699,
		0,
		0.012999,
		0.079753,
		-0.532812,
		1,
	},
	[0.883333333333] = {
		-0.022727,
		-0.612555,
		-0.790101,
		0,
		0.504822,
		-0.689181,
		0.519792,
		0,
		-0.862924,
		-0.387047,
		0.324894,
		0,
		0.015522,
		0.079683,
		-0.531395,
		1,
	},
	[0.8] = {
		-0.024585,
		-0.603981,
		-0.796619,
		0,
		0.508035,
		-0.693841,
		0.510377,
		0,
		-0.860985,
		-0.392163,
		0.323902,
		0,
		-0.00467,
		0.044161,
		-0.53889,
		1,
	},
	[0.916666666667] = {
		-0.021886,
		-0.616016,
		-0.78743,
		0,
		0.503608,
		-0.687187,
		0.523597,
		0,
		-0.863655,
		-0.385096,
		0.32527,
		0,
		0.018495,
		0.075263,
		-0.529436,
		1,
	},
	[0.933333333333] = {
		-0.021479,
		-0.617697,
		-0.786123,
		0,
		0.503016,
		-0.686209,
		0.525445,
		0,
		-0.86401,
		-0.384146,
		0.32545,
		0,
		0.019128,
		0.073303,
		-0.528786,
		1,
	},
	[0.95] = {
		-0.021091,
		-0.619326,
		-0.784851,
		0,
		0.502433,
		-0.685261,
		0.527237,
		0,
		-0.864359,
		-0.383215,
		0.325623,
		0,
		0.019306,
		0.072044,
		-0.528307,
		1,
	},
	[0.966666666667] = {
		-0.020733,
		-0.620889,
		-0.783624,
		0,
		0.501861,
		-0.684354,
		0.528957,
		0,
		-0.8647,
		-0.382304,
		0.325788,
		0,
		0.019115,
		0.070833,
		-0.527977,
		1,
	},
	[0.983333333333] = {
		-0.020411,
		-0.622374,
		-0.782454,
		0,
		0.501298,
		-0.683502,
		0.53059,
		0,
		-0.865034,
		-0.381413,
		0.325946,
		0,
		0.01864,
		0.069677,
		-0.527761,
		1,
	},
	[0.9] = {
		-0.022305,
		-0.614297,
		-0.788759,
		0,
		0.50421,
		-0.688182,
		0.521708,
		0,
		-0.863293,
		-0.386063,
		0.325085,
		0,
		0.017323,
		0.077788,
		-0.530289,
		1,
	},
	[1.01666666667] = {
		-0.019911,
		-0.625051,
		-0.78033,
		0,
		0.500202,
		-0.682011,
		0.533534,
		0,
		-0.86568,
		-0.379699,
		0.326231,
		0,
		0.017181,
		0.067564,
		-0.527541,
		1,
	},
	[1.03333333333] = {
		-0.019751,
		-0.626217,
		-0.779399,
		0,
		0.499669,
		-0.681398,
		0.534815,
		0,
		-0.865991,
		-0.378878,
		0.326359,
		0,
		0.016368,
		0.066623,
		-0.527469,
		1,
	},
	[1.05] = {
		-0.019661,
		-0.627249,
		-0.778571,
		0,
		0.499145,
		-0.680891,
		0.53595,
		0,
		-0.866295,
		-0.378083,
		0.326475,
		0,
		0.015613,
		0.065771,
		-0.527377,
		1,
	},
	[1.06666666667] = {
		-0.01965,
		-0.628135,
		-0.777857,
		0,
		0.498631,
		-0.680501,
		0.536922,
		0,
		-0.866591,
		-0.377313,
		0.32658,
		0,
		0.015002,
		0.065015,
		-0.527231,
		1,
	},
	[1.08333333333] = {
		-0.019728,
		-0.62886,
		-0.777269,
		0,
		0.498127,
		-0.680243,
		0.537717,
		0,
		-0.866879,
		-0.376571,
		0.326672,
		0,
		0.014621,
		0.064367,
		-0.526998,
		1,
	},
	{
		-0.020134,
		-0.623766,
		-0.781352,
		0,
		0.500745,
		-0.682717,
		0.53212,
		0,
		-0.86536,
		-0.380545,
		0.326093,
		0,
		0.017967,
		0.068585,
		-0.527627,
		1,
	},
	[1.11666666667] = {
		-0.020179,
		-0.629774,
		-0.776516,
		0,
		0.497149,
		-0.680169,
		0.538714,
		0,
		-0.867431,
		-0.375173,
		0.326817,
		0,
		0.014887,
		0.063426,
		-0.526131,
		1,
	},
	[1.13333333333] = {
		-0.020512,
		-0.630039,
		-0.776293,
		0,
		0.496669,
		-0.680292,
		0.539001,
		0,
		-0.867697,
		-0.374505,
		0.326876,
		0,
		0.01487,
		0.063471,
		-0.526218,
		1,
	},
	[1.1] = {
		-0.019901,
		-0.629411,
		-0.776818,
		0,
		0.497633,
		-0.680128,
		0.538319,
		0,
		-0.867159,
		-0.375857,
		0.326751,
		0,
		0.014554,
		0.063834,
		-0.526642,
		1,
	},
}

return spline_matrices
