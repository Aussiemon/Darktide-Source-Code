﻿-- chunkname: @content/characters/player/human/first_person/animations/force_sword/attack_stab.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.917541,
		-0.370398,
		0.144654,
		0,
		-0.129607,
		-0.622485,
		-0.771825,
		0,
		0.375927,
		0.689433,
		-0.619162,
		0,
		0.322528,
		-0.041967,
		-0.688389,
		1
	},
	[0.0333333333333] = {
		0.934099,
		-0.351274,
		0.06376,
		0,
		-0.152144,
		-0.553238,
		-0.819011,
		0,
		0.322972,
		0.755337,
		-0.570224,
		0,
		0.332718,
		-0.144968,
		-0.657905,
		1
	},
	[0.05] = {
		0.945955,
		-0.322636,
		-0.032801,
		0,
		-0.190767,
		-0.471805,
		-0.860818,
		0,
		0.262255,
		0.820552,
		-0.507854,
		0,
		0.345199,
		-0.265349,
		-0.626473,
		1
	},
	[0.0666666666667] = {
		0.951209,
		-0.2777,
		-0.134474,
		0,
		-0.237883,
		-0.382487,
		-0.892813,
		0,
		0.1965,
		0.881241,
		-0.429886,
		0,
		0.358373,
		-0.390447,
		-0.592702,
		1
	},
	[0.0833333333333] = {
		0.949866,
		-0.214565,
		-0.22741,
		0,
		-0.284482,
		-0.291377,
		-0.913329,
		0,
		0.129707,
		0.932235,
		-0.337809,
		0,
		0.37056,
		-0.507494,
		-0.555941,
		1
	},
	[0] = {
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677371,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658988,
		0,
		0.316264,
		0.030856,
		-0.719817,
		1
	},
	[0.116666666667] = {
		0.941329,
		-0.052782,
		-0.333337,
		0,
		-0.337396,
		-0.123841,
		-0.933181,
		0,
		0.007974,
		0.990897,
		-0.134383,
		0,
		0.383748,
		-0.663981,
		-0.474029,
		1
	},
	[0.133333333333] = {
		0.94466,
		0.028562,
		-0.326806,
		0,
		-0.325211,
		-0.049286,
		-0.944356,
		0,
		-0.04308,
		0.998376,
		-0.03727,
		0,
		0.379886,
		-0.67524,
		-0.430356,
		1
	},
	[0.15] = {
		0.957973,
		0.093341,
		-0.271246,
		0,
		-0.274083,
		0.018809,
		-0.961522,
		0,
		-0.084647,
		0.995457,
		0.043602,
		0,
		0.365519,
		-0.621964,
		-0.385165,
		1
	},
	[0.166666666667] = {
		0.978359,
		0.129288,
		-0.161547,
		0,
		-0.172649,
		0.079784,
		-0.981747,
		0,
		-0.114039,
		0.988392,
		0.100379,
		0,
		0.338301,
		-0.48883,
		-0.338012,
		1
	},
	[0.183333333333] = {
		0.98711,
		0.097101,
		0.127223,
		0,
		0.114278,
		0.128891,
		-0.985052,
		0,
		-0.112047,
		0.986893,
		0.116133,
		0,
		0.267303,
		-0.074501,
		-0.276951,
		1
	},
	[0.1] = {
		0.944855,
		-0.137341,
		-0.297299,
		0,
		-0.320729,
		-0.204562,
		-0.924817,
		0,
		0.066199,
		0.969171,
		-0.237331,
		0,
		0.379791,
		-0.603292,
		-0.516112,
		1
	},
	[0.216666666667] = {
		0.953607,
		0.026612,
		0.299877,
		0,
		0.294695,
		0.121154,
		-0.94788,
		0,
		-0.061556,
		0.992277,
		0.107691,
		0,
		0.077188,
		0.674816,
		-0.109334,
		1
	},
	[0.233333333333] = {
		0.945363,
		0.01338,
		0.325745,
		0,
		0.322549,
		0.107023,
		-0.940483,
		0,
		-0.047446,
		0.994166,
		0.09686,
		0,
		0.05943,
		0.732902,
		-0.098614,
		1
	},
	[0.25] = {
		0.937702,
		0.008119,
		0.347345,
		0,
		0.344889,
		0.099169,
		-0.93339,
		0,
		-0.042024,
		0.995037,
		0.090191,
		0,
		0.050746,
		0.730292,
		-0.094989,
		1
	},
	[0.266666666667] = {
		0.930444,
		0.007702,
		0.366354,
		0,
		0.364078,
		0.093774,
		-0.926635,
		0,
		-0.041491,
		0.995564,
		0.084448,
		0,
		0.046354,
		0.726614,
		-0.093089,
		1
	},
	[0.283333333333] = {
		0.923055,
		0.010872,
		0.384513,
		0,
		0.381982,
		0.091984,
		-0.919581,
		0,
		-0.045366,
		0.995701,
		0.080753,
		0,
		0.044369,
		0.721061,
		-0.092296,
		1
	},
	[0.2] = {
		0.962627,
		0.064389,
		0.263065,
		0,
		0.25214,
		0.141512,
		-0.957288,
		0,
		-0.098866,
		0.98784,
		0.119988,
		0,
		0.117378,
		0.498836,
		-0.147838,
		1
	},
	[0.316666666667] = {
		0.904785,
		0.016618,
		0.425545,
		0,
		0.421945,
		0.100359,
		-0.90105,
		0,
		-0.057681,
		0.994813,
		0.083791,
		0,
		0.046017,
		0.71,
		-0.093353,
		1
	},
	[0.333333333333] = {
		0.891823,
		0.013594,
		0.45218,
		0,
		0.448115,
		0.110444,
		-0.887127,
		0,
		-0.062,
		0.993789,
		0.092405,
		0,
		0.04779,
		0.706106,
		-0.09501,
		1
	},
	[0.35] = {
		0.876641,
		0.007361,
		0.481089,
		0,
		0.476785,
		0.121012,
		-0.87065,
		0,
		-0.064626,
		0.992624,
		0.102574,
		0,
		0.050825,
		0.702804,
		-0.096915,
		1
	},
	[0.366666666667] = {
		0.860992,
		0.001883,
		0.508615,
		0,
		0.504133,
		0.129354,
		-0.853884,
		0,
		-0.067399,
		0.991597,
		0.110424,
		0,
		0.056627,
		0.699846,
		-0.098605,
		1
	},
	[0.383333333333] = {
		0.845023,
		-0.002345,
		0.534725,
		0,
		0.530029,
		0.135976,
		-0.837006,
		0,
		-0.070747,
		0.990709,
		0.116146,
		0,
		0.064497,
		0.697225,
		-0.100098,
		1
	},
	[0.3] = {
		0.914807,
		0.014764,
		0.403621,
		0,
		0.400599,
		0.094167,
		-0.911402,
		0,
		-0.051464,
		0.995447,
		0.08023,
		0,
		0.044495,
		0.714785,
		-0.092431,
		1
	},
	[0.416666666667] = {
		0.812923,
		-0.006145,
		0.582339,
		0,
		0.576834,
		0.146065,
		-0.803696,
		0,
		-0.080121,
		0.989256,
		0.122285,
		0,
		0.083762,
		0.692031,
		-0.10272,
		1
	},
	[0.433333333333] = {
		0.797246,
		-0.005813,
		0.603627,
		0,
		0.597466,
		0.150426,
		-0.787659,
		0,
		-0.086223,
		0.988604,
		0.123399,
		0,
		0.093916,
		0.689163,
		-0.103951,
		1
	},
	[0.45] = {
		0.782125,
		-0.004369,
		0.623106,
		0,
		0.616129,
		0.154805,
		-0.772283,
		0,
		-0.093086,
		0.987935,
		0.123769,
		0,
		0.103657,
		0.685101,
		-0.10534,
		1
	},
	[0.466666666667] = {
		0.767779,
		-0.002159,
		0.640712,
		0,
		0.632771,
		0.159542,
		-0.757725,
		0,
		-0.100585,
		0.987189,
		0.123858,
		0,
		0.112329,
		0.678344,
		-0.107184,
		1
	},
	[0.483333333333] = {
		0.7544,
		0.000446,
		0.656414,
		0,
		0.647367,
		0.164951,
		-0.744115,
		0,
		-0.108608,
		0.986302,
		0.12415,
		0,
		0.119301,
		0.669659,
		-0.109427,
		1
	},
	[0.4] = {
		0.828926,
		-0.005045,
		0.559335,
		0,
		0.554315,
		0.141384,
		-0.820211,
		0,
		-0.074942,
		0.989942,
		0.119993,
		0,
		0.07376,
		0.694718,
		-0.101446,
		1
	},
	[0.516666666667] = {
		0.747804,
		0.002297,
		0.663916,
		0,
		0.653968,
		0.169944,
		-0.737187,
		0,
		-0.114522,
		0.985451,
		0.125582,
		0,
		0.138106,
		0.590822,
		-0.123862,
		1
	},
	[0.533333333333] = {
		0.783699,
		0.002981,
		0.621134,
		0,
		0.611897,
		0.168174,
		-0.772851,
		0,
		-0.106763,
		0.985753,
		0.129974,
		0,
		0.180029,
		0.412192,
		-0.164453,
		1
	},
	[0.55] = {
		0.841729,
		0.006667,
		0.539859,
		0,
		0.532089,
		0.159236,
		-0.83158,
		0,
		-0.091509,
		0.987218,
		0.130486,
		0,
		0.215155,
		0.249789,
		-0.20035,
		1
	},
	[0.566666666667] = {
		0.895741,
		0.010674,
		0.444449,
		0,
		0.438204,
		0.147467,
		-0.886696,
		0,
		-0.075006,
		0.989009,
		0.127415,
		0,
		0.250545,
		-0.004933,
		-0.245625,
		1
	},
	[0.583333333333] = {
		0.931241,
		0.014028,
		0.364134,
		0,
		0.359079,
		0.134871,
		-0.923511,
		0,
		-0.062066,
		0.990764,
		0.120561,
		0,
		0.286875,
		-0.248499,
		-0.287704,
		1
	},
	[0.5] = {
		0.74691,
		0.002009,
		0.664922,
		0,
		0.655294,
		0.167362,
		-0.7366,
		0,
		-0.112762,
		0.985894,
		0.123688,
		0,
		0.123514,
		0.654222,
		-0.113144,
		1
	},
	[0.616666666667] = {
		0.941795,
		0.003427,
		0.336171,
		0,
		0.333786,
		0.109794,
		-0.936233,
		0,
		-0.040118,
		0.993948,
		0.10226,
		0,
		0.324379,
		-0.527258,
		-0.329929,
		1
	},
	[0.633333333333] = {
		0.9367,
		-0.030672,
		0.348788,
		0,
		0.350106,
		0.094642,
		-0.931917,
		0,
		-0.004426,
		0.995039,
		0.09939,
		0,
		0.336475,
		-0.622397,
		-0.340122,
		1
	},
	[0.65] = {
		0.928264,
		-0.07545,
		0.364188,
		0,
		0.369645,
		0.078992,
		-0.925809,
		0,
		0.041084,
		0.994016,
		0.101216,
		0,
		0.347982,
		-0.707084,
		-0.347545,
		1
	},
	[0.666666666667] = {
		0.936888,
		-0.08013,
		0.340324,
		0,
		0.338745,
		-0.032958,
		-0.940301,
		0,
		0.086563,
		0.996239,
		-0.003735,
		0,
		0.333586,
		-0.612126,
		-0.383326,
		1
	},
	[0.683333333333] = {
		0.954181,
		-0.090874,
		0.285098,
		0,
		0.266374,
		-0.176102,
		-0.947646,
		0,
		0.136323,
		0.980168,
		-0.143827,
		0,
		0.321466,
		-0.46161,
		-0.446325,
		1
	},
	[0.6] = {
		0.943641,
		0.016246,
		0.330572,
		0,
		0.32623,
		0.122786,
		-0.937282,
		0,
		-0.055816,
		0.9923,
		0.110566,
		0,
		0.312044,
		-0.419458,
		-0.316004,
		1
	},
	[0.716666666667] = {
		0.959677,
		-0.227275,
		0.165426,
		0,
		0.040798,
		-0.469646,
		-0.881912,
		0,
		0.278128,
		0.853099,
		-0.441436,
		0,
		0.320536,
		-0.142458,
		-0.640396,
		1
	},
	[0.733333333333] = {
		0.929011,
		-0.332168,
		0.163104,
		0,
		-0.066551,
		-0.583546,
		-0.809349,
		0,
		0.364019,
		0.741039,
		-0.564226,
		0,
		0.321824,
		-0.02044,
		-0.711532,
		1
	},
	[0.75] = {
		0.882188,
		-0.413547,
		0.225218,
		0,
		-0.13846,
		-0.684935,
		-0.715327,
		0,
		0.450081,
		0.599869,
		-0.661501,
		0,
		0.327473,
		0.015423,
		-0.742987,
		1
	},
	[0.766666666667] = {
		0.883804,
		-0.411281,
		0.22302,
		0,
		-0.137635,
		-0.684149,
		-0.716238,
		0,
		0.447154,
		0.602319,
		-0.66126,
		0,
		0.326361,
		0.016968,
		-0.740665,
		1
	},
	[0.783333333333] = {
		0.885412,
		-0.409001,
		0.220825,
		0,
		-0.136811,
		-0.683367,
		-0.717142,
		0,
		0.444217,
		0.604755,
		-0.661017,
		0,
		0.325248,
		0.018506,
		-0.738343,
		1
	},
	[0.7] = {
		0.96649,
		-0.138466,
		0.216158,
		0,
		0.16066,
		-0.330475,
		-0.93004,
		0,
		0.200214,
		0.933603,
		-0.297154,
		0,
		0.324308,
		-0.313452,
		-0.550794,
		1
	},
	[0.816666666667] = {
		0.888599,
		-0.404405,
		0.216445,
		0,
		-0.135174,
		-0.681805,
		-0.718937,
		0,
		0.438315,
		0.609589,
		-0.660516,
		0,
		0.323015,
		0.02157,
		-0.733695,
		1
	},
	[0.833333333333] = {
		0.890176,
		-0.402095,
		0.214256,
		0,
		-0.134363,
		-0.68102,
		-0.719832,
		0,
		0.435354,
		0.611989,
		-0.660255,
		0,
		0.321895,
		0.023099,
		-0.731369,
		1
	},
	[0.85] = {
		0.891741,
		-0.399782,
		0.212066,
		0,
		-0.133561,
		-0.68023,
		-0.720728,
		0,
		0.432387,
		0.614379,
		-0.659984,
		0,
		0.320774,
		0.024628,
		-0.729042,
		1
	},
	[0.866666666667] = {
		0.893293,
		-0.397466,
		0.209875,
		0,
		-0.132767,
		-0.679431,
		-0.721628,
		0,
		0.429418,
		0.616761,
		-0.659702,
		0,
		0.319651,
		0.026159,
		-0.726712,
		1
	},
	[0.883333333333] = {
		0.894831,
		-0.395153,
		0.20768,
		0,
		-0.131984,
		-0.678621,
		-0.722533,
		0,
		0.426447,
		0.619135,
		-0.659405,
		0,
		0.318526,
		0.027693,
		-0.72438,
		1
	},
	[0.8] = {
		0.887011,
		-0.406708,
		0.218634,
		0,
		-0.13599,
		-0.682586,
		-0.718041,
		0,
		0.44127,
		0.607178,
		-0.66077,
		0,
		0.324132,
		0.02004,
		-0.73602,
		1
	},
	[0.916666666667] = {
		0.897862,
		-0.390542,
		0.203277,
		0,
		-0.130457,
		-0.676958,
		-0.724368,
		0,
		0.420506,
		0.623863,
		-0.658763,
		0,
		0.31627,
		0.030775,
		-0.71971,
		1
	},
	[0.933333333333] = {
		0.897969,
		-0.39027,
		0.203325,
		0,
		-0.130271,
		-0.677082,
		-0.724286,
		0,
		0.420335,
		0.623899,
		-0.658839,
		0,
		0.316262,
		0.030775,
		-0.719714,
		1
	},
	[0.95] = {
		0.898069,
		-0.390019,
		0.203364,
		0,
		-0.130097,
		-0.677187,
		-0.724218,
		0,
		0.420174,
		0.623941,
		-0.658901,
		0,
		0.316254,
		0.030784,
		-0.719717,
		1
	},
	[0.966666666667] = {
		0.898162,
		-0.389791,
		0.203393,
		0,
		-0.129937,
		-0.677273,
		-0.724167,
		0,
		0.420027,
		0.623991,
		-0.658948,
		0,
		0.316247,
		0.030805,
		-0.719719,
		1
	},
	[0.983333333333] = {
		0.898245,
		-0.389589,
		0.203412,
		0,
		-0.129792,
		-0.677335,
		-0.724135,
		0,
		0.419893,
		0.624049,
		-0.658978,
		0,
		0.31624,
		0.030838,
		-0.71972,
		1
	},
	[0.9] = {
		0.896354,
		-0.392844,
		0.205481,
		0,
		-0.131214,
		-0.677797,
		-0.723446,
		0,
		0.423476,
		0.621502,
		-0.659093,
		0,
		0.317399,
		0.029231,
		-0.722046,
		1
	},
	{
		0.898318,
		-0.389416,
		0.203418,
		0,
		-0.129664,
		-0.677371,
		-0.724124,
		0,
		0.419775,
		0.624118,
		-0.658988,
		0,
		0.316234,
		0.030886,
		-0.719721,
		1
	}
}

return spline_matrices
