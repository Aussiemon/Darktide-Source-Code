﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_sword/attack_special_right_diagonal_down.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.842592,
		0.447086,
		-0.300256,
		0,
		-0.537834,
		0.727357,
		-0.426247,
		0,
		0.027824,
		0.52064,
		0.853323,
		0,
		0.261719,
		0.490538,
		-0.330443,
		1,
	},
	[0.0333333333333] = {
		0.734919,
		0.452952,
		-0.504706,
		0,
		-0.677457,
		0.524113,
		-0.516099,
		0,
		0.030755,
		0.721207,
		0.692036,
		0,
		0.242641,
		0.42991,
		-0.342198,
		1,
	},
	[0.05] = {
		0.751475,
		0.420908,
		-0.508057,
		0,
		-0.659037,
		0.442799,
		-0.607947,
		0,
		-0.030922,
		0.791685,
		0.610146,
		0,
		0.226646,
		0.397162,
		-0.350965,
		1,
	},
	[0.0666666666667] = {
		0.822887,
		0.390971,
		-0.41231,
		0,
		-0.557877,
		0.418192,
		-0.716861,
		0,
		-0.107847,
		0.819913,
		0.562238,
		0,
		0.214201,
		0.383353,
		-0.35898,
		1,
	},
	[0.0833333333333] = {
		0.901818,
		0.361512,
		-0.236715,
		0,
		-0.385413,
		0.425208,
		-0.818935,
		0,
		-0.195402,
		0.829763,
		0.522791,
		0,
		0.202503,
		0.392905,
		-0.364152,
		1,
	},
	[0] = {
		0.945773,
		0.324778,
		-0.00581,
		0,
		-0.316318,
		0.916775,
		-0.243859,
		0,
		-0.073874,
		0.232473,
		0.969793,
		0,
		0.277869,
		0.533396,
		-0.313189,
		1,
	},
	[0.116666666667] = {
		0.937621,
		0.280173,
		0.205841,
		0,
		0.06002,
		0.452735,
		-0.889623,
		0,
		-0.34244,
		0.846484,
		0.407677,
		0,
		0.174415,
		0.454833,
		-0.363481,
		1,
	},
	[0.133333333333] = {
		0.893765,
		0.237075,
		0.380761,
		0,
		0.244908,
		0.453245,
		-0.857082,
		0,
		-0.375771,
		0.859281,
		0.347033,
		0,
		0.157137,
		0.498052,
		-0.358461,
		1,
	},
	[0.15] = {
		0.84159,
		0.208741,
		0.49815,
		0,
		0.362095,
		0.466296,
		-0.807128,
		0,
		-0.400766,
		0.859648,
		0.316846,
		0,
		0.137756,
		0.545589,
		-0.347923,
		1,
	},
	[0.166666666667] = {
		0.803791,
		0.200955,
		0.559944,
		0,
		0.405582,
		0.50348,
		-0.762897,
		0,
		-0.435229,
		0.840313,
		0.323189,
		0,
		0.116697,
		0.593734,
		-0.329014,
		1,
	},
	[0.183333333333] = {
		0.797766,
		0.233438,
		0.555945,
		0,
		0.370145,
		0.538247,
		-0.757155,
		0,
		-0.475985,
		0.809813,
		0.342989,
		0,
		0.093453,
		0.635551,
		-0.307497,
		1,
	},
	[0.1] = {
		0.945672,
		0.324789,
		-0.014716,
		0,
		-0.165067,
		0.440639,
		-0.882378,
		0,
		-0.280103,
		0.836869,
		0.470312,
		0,
		0.189189,
		0.418175,
		-0.365654,
		1,
	},
	[0.216666666667] = {
		0.848759,
		0.458783,
		0.262919,
		0,
		0.032484,
		0.451039,
		-0.891913,
		0,
		-0.527781,
		0.76556,
		0.367921,
		0,
		0.055184,
		0.684535,
		-0.290478,
		1,
	},
	[0.233333333333] = {
		0.818052,
		0.574552,
		-0.026074,
		0,
		-0.240657,
		0.30077,
		-0.922833,
		0,
		-0.522374,
		0.761201,
		0.384316,
		0,
		0.046377,
		0.691893,
		-0.295443,
		1,
	},
	[0.25] = {
		0.685389,
		0.638631,
		-0.349846,
		0,
		-0.521958,
		0.095871,
		-0.847566,
		0,
		-0.507742,
		0.763518,
		0.399047,
		0,
		0.040245,
		0.689169,
		-0.303661,
		1,
	},
	[0.266666666667] = {
		0.449954,
		0.626474,
		-0.636452,
		0,
		-0.74237,
		-0.133764,
		-0.656502,
		0,
		-0.496416,
		0.767878,
		0.404888,
		0,
		0.031584,
		0.678058,
		-0.310608,
		1,
	},
	[0.283333333333] = {
		0.17054,
		0.492068,
		-0.853689,
		0,
		-0.867797,
		-0.33538,
		-0.366672,
		0,
		-0.466738,
		0.803361,
		0.36982,
		0,
		0.022189,
		0.655973,
		-0.302059,
		1,
	},
	[0.2] = {
		0.822747,
		0.327767,
		0.464388,
		0,
		0.245643,
		0.531738,
		-0.810502,
		0,
		-0.512589,
		0.780912,
		0.356972,
		0,
		0.070813,
		0.666265,
		-0.292975,
		1,
	},
	[0.316666666667] = {
		-0.258397,
		0.110366,
		-0.959714,
		0,
		-0.872877,
		-0.452325,
		0.182999,
		0,
		-0.413905,
		0.884998,
		0.213215,
		0,
		0.002688,
		0.603951,
		-0.25668,
		1,
	},
	[0.333333333333] = {
		-0.346571,
		0.040878,
		-0.937133,
		0,
		-0.814917,
		-0.507884,
		0.279219,
		0,
		-0.464541,
		0.860455,
		0.20933,
		0,
		-0.020324,
		0.593582,
		-0.260963,
		1,
	},
	[0.35] = {
		-0.369782,
		0.026634,
		-0.928737,
		0,
		-0.747064,
		-0.602831,
		0.28016,
		0,
		-0.55241,
		0.797424,
		0.242813,
		0,
		-0.047804,
		0.592983,
		-0.27698,
		1,
	},
	[0.366666666667] = {
		-0.350532,
		0.029207,
		-0.936095,
		0,
		-0.699194,
		-0.673152,
		0.240818,
		0,
		-0.623101,
		0.738927,
		0.256383,
		0,
		-0.069885,
		0.59061,
		-0.28415,
		1,
	},
	[0.383333333333] = {
		-0.32262,
		0.029576,
		-0.946067,
		0,
		-0.670003,
		-0.713151,
		0.206184,
		0,
		-0.66859,
		0.700387,
		0.249892,
		0,
		-0.080599,
		0.585312,
		-0.28085,
		1,
	},
	[0.3] = {
		-0.084092,
		0.277179,
		-0.957131,
		0,
		-0.901924,
		-0.429528,
		-0.045147,
		0,
		-0.423629,
		0.859463,
		0.286114,
		0,
		0.015296,
		0.627707,
		-0.276198,
		1,
	},
	[0.416666666667] = {
		-0.290534,
		-0.018449,
		-0.956687,
		0,
		-0.6295,
		-0.749299,
		0.205621,
		0,
		-0.720638,
		0.661974,
		0.206083,
		0,
		-0.088555,
		0.564699,
		-0.257637,
		1,
	},
	[0.433333333333] = {
		-0.284653,
		-0.053722,
		-0.957124,
		0,
		-0.608415,
		-0.761444,
		0.223684,
		0,
		-0.740813,
		0.646001,
		0.184062,
		0,
		-0.103832,
		0.551575,
		-0.243879,
		1,
	},
	[0.45] = {
		-0.284343,
		-0.087483,
		-0.954723,
		0,
		-0.578416,
		-0.778519,
		0.243605,
		0,
		-0.764581,
		0.621494,
		0.170765,
		0,
		-0.132941,
		0.537939,
		-0.228705,
		1,
	},
	[0.466666666667] = {
		-0.288684,
		-0.113389,
		-0.950686,
		0,
		-0.531958,
		-0.806593,
		0.257737,
		0,
		-0.796041,
		0.58013,
		0.172532,
		0,
		-0.171279,
		0.524606,
		-0.211082,
		1,
	},
	[0.483333333333] = {
		-0.297412,
		-0.125537,
		-0.94646,
		0,
		-0.45927,
		-0.850277,
		0.257098,
		0,
		-0.837029,
		0.511145,
		0.195227,
		0,
		-0.215965,
		0.512209,
		-0.189947,
		1,
	},
	[0.4] = {
		-0.302929,
		0.01158,
		-0.952943,
		0,
		-0.648116,
		-0.735596,
		0.197089,
		0,
		-0.698698,
		0.677322,
		0.230339,
		0,
		-0.083818,
		0.576307,
		-0.271048,
		1,
	},
	[0.516666666667] = {
		-0.353231,
		-0.087033,
		-0.931479,
		0,
		-0.145604,
		-0.978416,
		0.146634,
		0,
		-0.924136,
		0.187423,
		0.332934,
		0,
		-0.313955,
		0.488003,
		-0.128051,
		1,
	},
	[0.533333333333] = {
		-0.428608,
		-0.053008,
		-0.901934,
		0,
		0.134307,
		-0.990924,
		-0.005586,
		0,
		-0.893452,
		-0.12353,
		0.431837,
		0,
		-0.35829,
		0.470938,
		-0.082705,
		1,
	},
	[0.55] = {
		-0.508784,
		-0.037771,
		-0.860065,
		0,
		0.380616,
		-0.905963,
		-0.185372,
		0,
		-0.772186,
		-0.421669,
		0.475315,
		0,
		-0.386371,
		0.451922,
		-0.038474,
		1,
	},
	[0.566666666667] = {
		-0.561288,
		-0.030666,
		-0.827053,
		0,
		0.51669,
		-0.793626,
		-0.32123,
		0,
		-0.64652,
		-0.607632,
		0.461297,
		0,
		-0.395019,
		0.439035,
		-0.003909,
		1,
	},
	[0.583333333333] = {
		-0.58141,
		-0.000686,
		-0.81361,
		0,
		0.570042,
		-0.713866,
		-0.406753,
		0,
		-0.580529,
		-0.700282,
		0.41544,
		0,
		-0.391408,
		0.434325,
		0.024682,
		1,
	},
	[0.5] = {
		-0.312147,
		-0.118148,
		-0.942659,
		0,
		-0.347447,
		-0.909302,
		0.229019,
		0,
		-0.88422,
		0.399011,
		0.242786,
		0,
		-0.264001,
		0.500852,
		-0.164155,
		1,
	},
	[0.616666666667] = {
		-0.579056,
		0.106868,
		-0.808253,
		0,
		0.575651,
		-0.648439,
		-0.49815,
		0,
		-0.577339,
		-0.753729,
		0.313964,
		0,
		-0.369884,
		0.449514,
		0.080344,
		1,
	},
	[0.633333333333] = {
		-0.569661,
		0.143377,
		-0.809277,
		0,
		0.533481,
		-0.684534,
		-0.496801,
		0,
		-0.625207,
		-0.714742,
		0.313463,
		0,
		-0.353441,
		0.478896,
		0.103619,
		1,
	},
	[0.65] = {
		-0.5572,
		0.135971,
		-0.81917,
		0,
		0.446016,
		-0.783112,
		-0.433366,
		0,
		-0.700427,
		-0.606834,
		0.375704,
		0,
		-0.331407,
		0.554744,
		0.118772,
		1,
	},
	[0.666666666667] = {
		-0.53571,
		0.125197,
		-0.835069,
		0,
		0.238913,
		-0.926064,
		-0.292106,
		0,
		-0.809898,
		-0.355992,
		0.466191,
		0,
		-0.278438,
		0.653903,
		0.12125,
		1,
	},
	[0.683333333333] = {
		-0.488204,
		0.134434,
		-0.862313,
		0,
		-0.259211,
		-0.965813,
		-0.003815,
		0,
		-0.833347,
		0.221659,
		0.50636,
		0,
		-0.154602,
		0.747809,
		0.048184,
		1,
	},
	[0.6] = {
		-0.585115,
		0.051465,
		-0.809316,
		0,
		0.587231,
		-0.661388,
		-0.466611,
		0,
		-0.559286,
		-0.748276,
		0.356766,
		0,
		-0.382671,
		0.436252,
		0.05336,
		1,
	},
	[0.716666666667] = {
		-0.35639,
		0.099825,
		-0.928989,
		0,
		-0.899167,
		-0.306872,
		0.311974,
		0,
		-0.253938,
		0.946501,
		0.199126,
		0,
		0.138708,
		0.721407,
		-0.156713,
		1,
	},
	[0.733333333333] = {
		-0.307248,
		0.056651,
		-0.949942,
		0,
		-0.950223,
		0.035995,
		0.309486,
		0,
		0.051726,
		0.997745,
		0.042772,
		0,
		0.259389,
		0.642398,
		-0.235869,
		1,
	},
	[0.75] = {
		-0.349176,
		0.0199,
		-0.936846,
		0,
		-0.848456,
		0.417647,
		0.325104,
		0,
		0.397741,
		0.908391,
		-0.128948,
		0,
		0.375145,
		0.520788,
		-0.319787,
		1,
	},
	[0.766666666667] = {
		-0.394532,
		-0.00368,
		-0.918875,
		0,
		-0.686262,
		0.666174,
		0.291988,
		0,
		0.611056,
		0.745787,
		-0.265352,
		0,
		0.477642,
		0.390433,
		-0.368789,
		1,
	},
	[0.783333333333] = {
		-0.33667,
		-0.091918,
		-0.937126,
		0,
		-0.706123,
		0.683037,
		0.186684,
		0,
		0.622932,
		0.724577,
		-0.294863,
		0,
		0.621022,
		0.281204,
		-0.372288,
		1,
	},
	[0.7] = {
		-0.426175,
		0.122056,
		-0.896369,
		0,
		-0.71616,
		-0.650907,
		0.251863,
		0,
		-0.552712,
		0.749281,
		0.364812,
		0,
		0.00532,
		0.788406,
		-0.070506,
		1,
	},
	[0.816666666667] = {
		-0.321024,
		-0.149248,
		-0.935237,
		0,
		-0.792294,
		0.583332,
		0.178868,
		0,
		0.518858,
		0.798404,
		-0.305512,
		0,
		0.698029,
		0.094098,
		-0.377866,
		1,
	},
	[0.833333333333] = {
		-0.422612,
		-0.095514,
		-0.901264,
		0,
		-0.78553,
		0.534596,
		0.311688,
		0,
		0.452042,
		0.839693,
		-0.300956,
		0,
		0.680558,
		0.047672,
		-0.387248,
		1,
	},
	[0.85] = {
		-0.513073,
		-0.05223,
		-0.856754,
		0,
		-0.762977,
		0.485018,
		0.427346,
		0,
		0.393221,
		0.872943,
		-0.2887,
		0,
		0.585298,
		0.052552,
		-0.391883,
		1,
	},
	[0.866666666667] = {
		-0.534072,
		-0.056531,
		-0.843547,
		0,
		-0.762452,
		0.463305,
		0.45168,
		0,
		0.365285,
		0.884394,
		-0.290541,
		0,
		0.514466,
		0.05563,
		-0.393491,
		1,
	},
	[0.883333333333] = {
		-0.403119,
		-0.15699,
		-0.901581,
		0,
		-0.819949,
		0.499482,
		0.279645,
		0,
		0.406422,
		0.851981,
		-0.330075,
		0,
		0.524218,
		0.05586,
		-0.388727,
		1,
	},
	[0.8] = {
		-0.273127,
		-0.16451,
		-0.947807,
		0,
		-0.775782,
		0.620266,
		0.115896,
		0,
		0.568827,
		0.766946,
		-0.297035,
		0,
		0.699466,
		0.185063,
		-0.371183,
		1,
	},
	[0.916666666667] = {
		-0.237835,
		-0.292581,
		-0.926191,
		0,
		-0.845364,
		0.531935,
		0.049043,
		0,
		0.478324,
		0.794633,
		-0.37385,
		0,
		0.550499,
		0.061609,
		-0.390096,
		1,
	},
	[0.933333333333] = {
		-0.236121,
		-0.308327,
		-0.92151,
		0,
		-0.841332,
		0.539377,
		0.035107,
		0,
		0.486217,
		0.783586,
		-0.386763,
		0,
		0.563796,
		0.066418,
		-0.39824,
		1,
	},
	[0.95] = {
		-0.256079,
		-0.310388,
		-0.915469,
		0,
		-0.83516,
		0.547922,
		0.047843,
		0,
		0.486756,
		0.776814,
		-0.399535,
		0,
		0.576423,
		0.071106,
		-0.409022,
		1,
	},
	[0.966666666667] = {
		-0.294827,
		-0.300462,
		-0.907083,
		0,
		-0.826294,
		0.556927,
		0.084092,
		0,
		0.479912,
		0.77431,
		-0.412467,
		0,
		0.586714,
		0.075547,
		-0.422129,
		1,
	},
	[0.983333333333] = {
		-0.349557,
		-0.280057,
		-0.894079,
		0,
		-0.812715,
		0.565436,
		0.140632,
		0,
		0.46616,
		0.77579,
		-0.425258,
		0,
		0.592966,
		0.07935,
		-0.437226,
		1,
	},
	[0.9] = {
		-0.264049,
		-0.261293,
		-0.928442,
		0,
		-0.846086,
		0.524887,
		0.092907,
		0,
		0.463051,
		0.810074,
		-0.359672,
		0,
		0.538085,
		0.056985,
		-0.38485,
		1,
	},
	[1.01666666667] = {
		-0.493579,
		-0.21411,
		-0.842933,
		0,
		-0.761122,
		0.575295,
		0.299547,
		0,
		0.420799,
		0.789426,
		-0.446917,
		0,
		0.584848,
		0.084146,
		-0.471755,
		1,
	},
	[1.03333333333] = {
		-0.574658,
		-0.171674,
		-0.800185,
		0,
		-0.718732,
		0.573476,
		0.393127,
		0,
		0.391397,
		0.801033,
		-0.45294,
		0,
		0.565845,
		0.085991,
		-0.490129,
		1,
	},
	[1.05] = {
		-0.655547,
		-0.126036,
		-0.744563,
		0,
		-0.664078,
		0.565633,
		0.488937,
		0,
		0.359526,
		0.814969,
		-0.454496,
		0,
		0.537833,
		0.087749,
		-0.508523,
		1,
	},
	[1.06666666667] = {
		-0.731652,
		-0.07992,
		-0.676977,
		0,
		-0.598161,
		0.551569,
		0.581356,
		0,
		0.326937,
		0.830292,
		-0.451362,
		0,
		0.502297,
		0.089446,
		-0.526448,
		1,
	},
	[1.08333333333] = {
		-0.799173,
		-0.035915,
		-0.600028,
		0,
		-0.523552,
		0.532018,
		0.66547,
		0,
		0.295325,
		0.845971,
		-0.443978,
		0,
		0.460798,
		0.091053,
		-0.543495,
		1,
	},
	{
		-0.417074,
		-0.250804,
		-0.873583,
		0,
		-0.791836,
		0.572089,
		0.2138,
		0,
		0.446145,
		0.780904,
		-0.437199,
		0,
		0.593453,
		0.082131,
		-0.453932,
		1,
	},
	[1.11666666667] = {
		-0.899971,
		0.037947,
		-0.434295,
		0,
		-0.363834,
		0.483417,
		0.796199,
		0,
		0.240159,
		0.874567,
		-0.421255,
		0,
		0.366302,
		0.093678,
		-0.573918,
		1,
	},
	[1.13333333333] = {
		-0.932698,
		0.06564,
		-0.354635,
		0,
		-0.287337,
		0.45904,
		0.840666,
		0,
		0.217972,
		0.885987,
		-0.409285,
		0,
		0.316448,
		0.094494,
		-0.587059,
		1,
	},
	[1.15] = {
		-0.955265,
		0.086803,
		-0.282727,
		0,
		-0.21832,
		0.437928,
		0.872099,
		0,
		0.199515,
		0.89481,
		-0.399386,
		0,
		0.266864,
		0.094853,
		-0.598796,
		1,
	},
	[1.16666666667] = {
		-0.969732,
		0.101666,
		-0.221998,
		0,
		-0.159958,
		0.422415,
		0.892177,
		0,
		0.184479,
		0.900683,
		-0.393367,
		0,
		0.218983,
		0.094671,
		-0.609154,
		1,
	},
	[1.18333333333] = {
		-0.979442,
		0.112798,
		-0.167241,
		0,
		-0.107357,
		0.410425,
		0.905553,
		0,
		0.170785,
		0.904891,
		-0.389877,
		0,
		0.173685,
		0.094231,
		-0.618575,
		1,
	},
	[1.1] = {
		-0.855606,
		0.003855,
		-0.517614,
		0,
		-0.444001,
		0.50857,
		0.737713,
		0,
		0.266087,
		0.861012,
		-0.433424,
		0,
		0.414935,
		0.092497,
		-0.559374,
		1,
	},
	[1.21666666667] = {
		-0.989779,
		0.131241,
		-0.055793,
		0,
		-0.000728,
		0.386575,
		0.922258,
		0,
		0.142606,
		0.912872,
		-0.382528,
		0,
		0.094668,
		0.093716,
		-0.635567,
		1,
	},
	[1.23333333333] = {
		-0.990328,
		0.138743,
		-0.000362,
		0,
		0.052179,
		0.374863,
		0.925611,
		0,
		0.128557,
		0.91664,
		-0.378477,
		0,
		0.063625,
		0.093692,
		-0.642941,
		1,
	},
	[1.25] = {
		-0.987928,
		0.145227,
		0.053916,
		0,
		0.103949,
		0.363423,
		0.925807,
		0,
		0.114858,
		0.920235,
		-0.374132,
		0,
		0.038984,
		0.093815,
		-0.649465,
		1,
	},
	[1.26666666667] = {
		-0.982836,
		0.150802,
		0.106263,
		0,
		0.153874,
		0.352375,
		0.923122,
		0,
		0.101764,
		0.923629,
		-0.369531,
		0,
		0.0197,
		0.094032,
		-0.655098,
		1,
	},
	[1.28333333333] = {
		-0.975445,
		0.155589,
		0.155879,
		0,
		0.201219,
		0.341849,
		0.91796,
		0,
		0.089537,
		0.926785,
		-0.364763,
		0,
		0.005078,
		0.094305,
		-0.659806,
		1,
	},
	[1.2] = {
		-0.986154,
		0.122624,
		-0.111642,
		0,
		-0.054107,
		0.398457,
		0.91559,
		0,
		0.156758,
		0.908953,
		-0.386305,
		0,
		0.131802,
		0.093902,
		-0.627414,
		1,
	},
	[1.31666666667] = {
		-0.955924,
		0.16336,
		0.243974,
		0,
		0.285485,
		0.32294,
		0.902335,
		0,
		0.068616,
		0.932214,
		-0.355343,
		0,
		-0.013126,
		0.0949,
		-0.666358,
		1,
	},
	[1.33333333333] = {
		-0.945142,
		0.166664,
		0.280945,
		0,
		0.321026,
		0.314855,
		0.893201,
		0,
		0.060407,
		0.934393,
		-0.351086,
		0,
		-0.018121,
		0.095175,
		-0.668181,
		1,
	},
	[1.35] = {
		-0.934713,
		0.169809,
		0.312214,
		0,
		0.351275,
		0.307883,
		0.884202,
		0,
		0.05402,
		0.936148,
		-0.347432,
		0,
		-0.021292,
		0.095418,
		-0.669029,
		1,
	},
	[1.36666666667] = {
		-0.925445,
		0.172968,
		0.337096,
		0,
		0.375611,
		0.302178,
		0.876131,
		0,
		0.04968,
		0.937428,
		-0.344618,
		0,
		-0.023325,
		0.095619,
		-0.668903,
		1,
	},
	[1.38333333333] = {
		-0.917994,
		0.176143,
		0.355331,
		0,
		0.393767,
		0.298042,
		0.869551,
		0,
		0.047262,
		0.93816,
		-0.34296,
		0,
		-0.02478,
		0.095825,
		-0.668355,
		1,
	},
	[1.3] = {
		-0.966268,
		0.159724,
		0.202028,
		0,
		0.245314,
		0.331989,
		0.910826,
		0,
		0.07841,
		0.929662,
		-0.359972,
		0,
		-0.00562,
		0.094603,
		-0.663564,
		1,
	},
	[1.41666666667] = {
		-0.908971,
		0.182333,
		0.374868,
		0,
		0.414245,
		0.294535,
		0.861191,
		0,
		0.046612,
		0.938085,
		-0.343254,
		0,
		-0.026442,
		0.096366,
		-0.667672,
		1,
	},
	[1.43333333333] = {
		-0.907183,
		0.185357,
		0.377706,
		0,
		0.417997,
		0.294792,
		0.859288,
		0,
		0.04793,
		0.937412,
		-0.344909,
		0,
		-0.026758,
		0.096681,
		-0.667522,
		1,
	},
	[1.45] = {
		-0.906925,
		0.188302,
		0.376867,
		0,
		0.418303,
		0.296133,
		0.858678,
		0,
		0.050088,
		0.936401,
		-0.347338,
		0,
		-0.026796,
		0.097013,
		-0.667481,
		1,
	},
	[1.46666666667] = {
		-0.907923,
		0.191129,
		0.373023,
		0,
		0.415785,
		0.298356,
		0.859131,
		0,
		0.052911,
		0.935122,
		-0.350353,
		0,
		-0.026603,
		0.097352,
		-0.66753,
		1,
	},
	[1.48333333333] = {
		-0.909878,
		0.193794,
		0.366832,
		0,
		0.411048,
		0.301252,
		0.860399,
		0,
		0.056231,
		0.933644,
		-0.353761,
		0,
		-0.026222,
		0.097689,
		-0.66765,
		1,
	},
	[1.4] = {
		-0.912521,
		0.179258,
		0.367656,
		0,
		0.406398,
		0.295555,
		0.864574,
		0,
		0.046319,
		0.938357,
		-0.34255,
		0,
		-0.0258,
		0.096077,
		-0.667946,
		1,
	},
	[1.51666666667] = {
		-0.915462,
		0.198493,
		0.350043,
		0,
		0.397332,
		0.308186,
		0.864378,
		0,
		0.063695,
		0.930388,
		-0.361,
		0,
		-0.025082,
		0.098326,
		-0.668019,
		1,
	},
	[1.53333333333] = {
		-0.918519,
		0.200475,
		0.340782,
		0,
		0.389573,
		0.311765,
		0.866623,
		0,
		0.067492,
		0.928769,
		-0.364462,
		0,
		-0.024413,
		0.098612,
		-0.66823,
		1,
	},
	[1.55] = {
		-0.921406,
		0.202195,
		0.331856,
		0,
		0.382043,
		0.315103,
		0.868765,
		0,
		0.071092,
		0.927269,
		-0.367585,
		0,
		-0.023742,
		0.098867,
		-0.668434,
		1,
	},
	[1.56666666667] = {
		-0.92389,
		0.203657,
		0.323963,
		0,
		0.375376,
		0.317957,
		0.87063,
		0,
		0.074303,
		0.925974,
		-0.370205,
		0,
		-0.023118,
		0.099087,
		-0.668617,
		1,
	},
	[1.58333333333] = {
		-0.925756,
		0.204868,
		0.317813,
		0,
		0.370213,
		0.320083,
		0.87206,
		0,
		0.076931,
		0.924974,
		-0.372163,
		0,
		-0.02259,
		0.099266,
		-0.668763,
		1,
	},
	[1.5] = {
		-0.912489,
		0.196259,
		0.358951,
		0,
		0.404695,
		0.304604,
		0.862229,
		0,
		0.059882,
		0.93204,
		-0.357373,
		0,
		-0.0257,
		0.098016,
		-0.66782,
		1,
	},
	[1.6] = {
		-0.926746,
		0.205973,
		0.314193,
		0,
		0.367327,
		0.321311,
		0.872829,
		0,
		0.078825,
		0.924302,
		-0.373433,
		0,
		-0.022272,
		0.099316,
		-0.668871,
		1,
	},
}

return spline_matrices
