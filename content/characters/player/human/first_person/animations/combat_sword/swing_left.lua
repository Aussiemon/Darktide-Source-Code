﻿-- chunkname: @content/characters/player/human/first_person/animations/combat_sword/swing_left.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.633371,
		-0.576988,
		-0.515681,
		0,
		-0.773711,
		-0.484742,
		-0.407918,
		0,
		-0.014608,
		0.657351,
		-0.753443,
		0,
		-0.014531,
		0.014112,
		-0.620254,
		1,
	},
	[0.0333333333333] = {
		0.295671,
		-0.767211,
		-0.56918,
		0,
		-0.757591,
		0.174632,
		-0.628935,
		0,
		0.581923,
		0.617164,
		-0.529598,
		0,
		0.037881,
		-0.007247,
		-0.642742,
		1,
	},
	[0.05] = {
		0.215688,
		-0.826191,
		-0.520469,
		0,
		-0.58489,
		0.317503,
		-0.746388,
		0,
		0.781909,
		0.465404,
		-0.414749,
		0,
		0.102134,
		-0.045108,
		-0.626695,
		1,
	},
	[0.0666666666667] = {
		0.059596,
		-0.897022,
		-0.437949,
		0,
		-0.397426,
		0.381136,
		-0.834738,
		0,
		0.915697,
		0.223799,
		-0.333786,
		0,
		0.181311,
		-0.08535,
		-0.604032,
		1,
	},
	[0.0833333333333] = {
		-0.140843,
		-0.918059,
		-0.370582,
		0,
		-0.194729,
		0.39269,
		-0.898819,
		0,
		0.970692,
		-0.05443,
		-0.23408,
		0,
		0.259938,
		-0.119219,
		-0.572771,
		1,
	},
	[0] = {
		0.633371,
		-0.576988,
		-0.515681,
		0,
		-0.773711,
		-0.484742,
		-0.407918,
		0,
		-0.014608,
		0.657351,
		-0.753443,
		0,
		-0.014531,
		0.014112,
		-0.620254,
		1,
	},
	[0.116666666667] = {
		-0.300838,
		-0.81863,
		-0.489224,
		0,
		0.160835,
		0.462089,
		-0.872127,
		0,
		0.940015,
		-0.341054,
		-0.00735,
		0,
		0.365426,
		-0.122373,
		-0.486888,
		1,
	},
	[0.133333333333] = {
		-0.279312,
		-0.738693,
		-0.613447,
		0,
		0.32564,
		0.528139,
		-0.784237,
		0,
		0.903296,
		-0.41881,
		0.093032,
		0,
		0.411715,
		-0.094352,
		-0.407534,
		1,
	},
	[0.15] = {
		-0.20368,
		-0.634975,
		-0.745199,
		0,
		0.481112,
		0.597993,
		-0.641042,
		0,
		0.85267,
		-0.489092,
		0.183695,
		0,
		0.455802,
		-0.053413,
		-0.306639,
		1,
	},
	[0.166666666667] = {
		-0.072698,
		-0.506229,
		-0.85933,
		0,
		0.609767,
		0.659261,
		-0.439954,
		0,
		0.78924,
		-0.555975,
		0.260755,
		0,
		0.49341,
		-0.004789,
		-0.203016,
		1,
	},
	[0.183333333333] = {
		0.10256,
		-0.358444,
		-0.9279,
		0,
		0.689509,
		0.697975,
		-0.193414,
		0,
		0.716979,
		-0.619959,
		0.318734,
		0,
		0.522082,
		0.045637,
		-0.11681,
		1,
	},
	[0.1] = {
		-0.2742,
		-0.878895,
		-0.390331,
		0,
		-0.005356,
		0.407277,
		-0.913289,
		0,
		0.961658,
		-0.248333,
		-0.116383,
		0,
		0.319905,
		-0.133452,
		-0.534754,
		1,
	},
	[0.216666666667] = {
		0.358852,
		-0.08768,
		-0.929267,
		0,
		0.701022,
		0.682648,
		0.206301,
		0,
		0.616274,
		-0.725468,
		0.306435,
		0,
		0.571571,
		0.152653,
		-0.059582,
		1,
	},
	[0.233333333333] = {
		0.368397,
		0.021106,
		-0.929429,
		0,
		0.702707,
		0.648233,
		0.293252,
		0,
		0.608676,
		-0.761149,
		0.223976,
		0,
		0.605106,
		0.212665,
		-0.055763,
		1,
	},
	[0.25] = {
		0.356693,
		0.115749,
		-0.927023,
		0,
		0.705674,
		0.616878,
		0.348548,
		0,
		0.612204,
		-0.778501,
		0.138355,
		0,
		0.633726,
		0.272731,
		-0.054873,
		1,
	},
	[0.266666666667] = {
		0.354092,
		0.186171,
		-0.916493,
		0,
		0.697847,
		0.599808,
		0.391458,
		0,
		0.622598,
		-0.778184,
		0.082468,
		0,
		0.647079,
		0.328906,
		-0.053808,
		1,
	},
	[0.283333333333] = {
		0.37062,
		0.200261,
		-0.906938,
		0,
		0.698773,
		0.583144,
		0.414318,
		0,
		0.611847,
		-0.787298,
		0.076188,
		0,
		0.640923,
		0.374065,
		-0.052017,
		1,
	},
	[0.2] = {
		0.29605,
		-0.205942,
		-0.932707,
		0,
		0.70551,
		0.705413,
		0.06818,
		0,
		0.643903,
		-0.678218,
		0.354132,
		0,
		0.543197,
		0.096059,
		-0.069294,
		1,
	},
	[0.316666666667] = {
		0.270454,
		0.277864,
		-0.921763,
		0,
		0.352231,
		0.862503,
		0.363348,
		0,
		0.895984,
		-0.422942,
		0.135394,
		0,
		0.522201,
		0.506383,
		-0.050458,
		1,
	},
	[0.333333333333] = {
		0.098135,
		0.293848,
		-0.950801,
		0,
		-0.172057,
		0.946035,
		0.274617,
		0,
		0.980187,
		0.136642,
		0.143398,
		0,
		0.383904,
		0.601194,
		-0.053669,
		1,
	},
	[0.35] = {
		-0.055215,
		0.213929,
		-0.975288,
		0,
		-0.680011,
		0.707176,
		0.193617,
		0,
		0.73112,
		0.673897,
		0.106427,
		0,
		0.209889,
		0.665092,
		-0.058688,
		1,
	},
	[0.366666666667] = {
		-0.118203,
		0.116607,
		-0.986119,
		0,
		-0.936159,
		0.318055,
		0.149824,
		0,
		0.33111,
		0.940874,
		0.071568,
		0,
		0.037691,
		0.67524,
		-0.06176,
		1,
	},
	[0.383333333333] = {
		-0.109012,
		0.077711,
		-0.990998,
		0,
		-0.99076,
		-0.08942,
		0.101974,
		0,
		-0.080691,
		0.992958,
		0.086741,
		0,
		-0.164941,
		0.595191,
		-0.068937,
		1,
	},
	[0.3] = {
		0.361669,
		0.214557,
		-0.907282,
		0,
		0.635863,
		0.654924,
		0.408353,
		0,
		0.681816,
		-0.724596,
		0.100437,
		0,
		0.60589,
		0.424366,
		-0.050613,
		1,
	},
	[0.416666666667] = {
		-0.103567,
		-0.04022,
		-0.993809,
		0,
		-0.52112,
		-0.848866,
		0.088661,
		0,
		-0.847176,
		0.527076,
		0.066955,
		0,
		-0.408564,
		0.329455,
		-0.07782,
		1,
	},
	[0.433333333333] = {
		-0.056006,
		-0.17061,
		-0.983746,
		0,
		0.08598,
		-0.982456,
		0.165491,
		0,
		-0.994721,
		-0.075314,
		0.069692,
		0,
		-0.400506,
		0.174544,
		-0.071115,
		1,
	},
	[0.45] = {
		0.05073,
		-0.251161,
		-0.966615,
		0,
		0.604503,
		-0.762706,
		0.229904,
		0,
		-0.794986,
		-0.595984,
		0.113136,
		0,
		-0.353484,
		0.066816,
		-0.062531,
		1,
	},
	[0.466666666667] = {
		0.13391,
		-0.255342,
		-0.957533,
		0,
		0.817161,
		-0.51818,
		0.25246,
		0,
		-0.560638,
		-0.816266,
		0.139267,
		0,
		-0.322388,
		0.025097,
		-0.058469,
		1,
	},
	[0.483333333333] = {
		0.176215,
		-0.228547,
		-0.957452,
		0,
		0.879151,
		-0.400973,
		0.257517,
		0,
		-0.442767,
		-0.887123,
		0.13027,
		0,
		-0.311436,
		0.016639,
		-0.06126,
		1,
	},
	[0.4] = {
		-0.097666,
		0.051062,
		-0.993908,
		0,
		-0.870308,
		-0.488789,
		0.06041,
		0,
		-0.482727,
		0.870907,
		0.092178,
		0,
		-0.341631,
		0.470298,
		-0.077874,
		1,
	},
	[0.516666666667] = {
		0.215213,
		-0.162162,
		-0.963009,
		0,
		0.907056,
		-0.332193,
		0.258646,
		0,
		-0.361847,
		-0.929167,
		0.075598,
		0,
		-0.291308,
		0.00029,
		-0.084343,
		1,
	},
	[0.533333333333] = {
		0.223586,
		-0.126198,
		-0.96648,
		0,
		0.896995,
		-0.361295,
		0.254688,
		0,
		-0.381325,
		-0.923872,
		0.032418,
		0,
		-0.280924,
		-0.008198,
		-0.10329,
		1,
	},
	[0.55] = {
		0.23003,
		-0.088344,
		-0.969165,
		0,
		0.872701,
		-0.421986,
		0.2456,
		0,
		-0.430672,
		-0.902287,
		-0.019971,
		0,
		-0.270391,
		-0.016686,
		-0.126375,
		1,
	},
	[0.566666666667] = {
		0.237774,
		-0.048625,
		-0.970103,
		0,
		0.831075,
		-0.506782,
		0.2291,
		0,
		-0.50277,
		-0.860702,
		-0.080088,
		0,
		-0.260028,
		-0.024772,
		-0.152997,
		1,
	},
	[0.583333333333] = {
		0.249626,
		-0.007998,
		-0.968309,
		0,
		0.768004,
		-0.60742,
		0.203005,
		0,
		-0.589794,
		-0.794341,
		-0.145485,
		0,
		-0.250145,
		-0.031746,
		-0.182542,
		1,
	},
	[0.5] = {
		0.201076,
		-0.19644,
		-0.959677,
		0,
		0.903083,
		-0.342355,
		0.259296,
		0,
		-0.379487,
		-0.918806,
		0.108562,
		0,
		-0.301394,
		0.00856,
		-0.070129,
		1,
	},
	[0.616666666667] = {
		0.293876,
		0.066458,
		-0.953531,
		0,
		0.569609,
		-0.813274,
		0.11887,
		0,
		-0.767582,
		-0.578073,
		-0.276857,
		0,
		-0.23204,
		-0.039356,
		-0.247328,
		1,
	},
	[0.633333333333] = {
		0.327414,
		0.093573,
		-0.940236,
		0,
		0.441304,
		-0.89503,
		0.064599,
		0,
		-0.835494,
		-0.436081,
		-0.334339,
		0,
		-0.223154,
		-0.039222,
		-0.280656,
		1,
	},
	[0.65] = {
		0.366832,
		0.109616,
		-0.923807,
		0,
		0.306509,
		-0.951827,
		0.00877,
		0,
		-0.878343,
		-0.286372,
		-0.382759,
		0,
		-0.213601,
		-0.036746,
		-0.3132,
		1,
	},
	[0.666666666667] = {
		0.40951,
		0.112862,
		-0.905297,
		0,
		0.178454,
		-0.983058,
		-0.041833,
		0,
		-0.894682,
		-0.144423,
		-0.422713,
		0,
		-0.202904,
		-0.032848,
		-0.343959,
		1,
	},
	[0.683333333333] = {
		0.452831,
		0.103315,
		-0.88559,
		0,
		0.069516,
		-0.994331,
		-0.080455,
		0,
		-0.888882,
		-0.02513,
		-0.457446,
		0,
		-0.190958,
		-0.028825,
		-0.372061,
		1,
	},
	[0.6] = {
		0.267886,
		0.031397,
		-0.962939,
		0,
		0.680541,
		-0.713645,
		0.166055,
		0,
		-0.681983,
		-0.699803,
		-0.212543,
		0,
		-0.240877,
		-0.036796,
		-0.214281,
		1,
	},
	[0.716666666667] = {
		0.53976,
		0.04564,
		-0.840581,
		0,
		-0.078977,
		-0.99138,
		-0.104541,
		0,
		-0.838106,
		0.122813,
		-0.531502,
		0,
		-0.163708,
		-0.023604,
		-0.420302,
		1,
	},
	[0.733333333333] = {
		0.586713,
		-0.010905,
		-0.809721,
		0,
		-0.155301,
		-0.982864,
		-0.099293,
		0,
		-0.794763,
		0.184007,
		-0.578353,
		0,
		-0.14759,
		-0.019665,
		-0.445142,
		1,
	},
	[0.75] = {
		0.630881,
		-0.083985,
		-0.771321,
		0,
		-0.237801,
		-0.96721,
		-0.089189,
		0,
		-0.738539,
		0.239688,
		-0.630166,
		0,
		-0.130058,
		-0.014528,
		-0.470839,
		1,
	},
	[0.766666666667] = {
		0.667483,
		-0.169102,
		-0.725169,
		0,
		-0.323512,
		-0.943014,
		-0.077875,
		0,
		-0.670676,
		0.286581,
		-0.684153,
		0,
		-0.111521,
		-0.00853,
		-0.496883,
		1,
	},
	[0.783333333333] = {
		0.692902,
		-0.260536,
		-0.672315,
		0,
		-0.4086,
		-0.910146,
		-0.068411,
		0,
		-0.594082,
		0.32211,
		-0.737097,
		0,
		-0.092448,
		-0.002076,
		-0.522683,
		1,
	},
	[0.7] = {
		0.49518,
		0.082369,
		-0.864877,
		0,
		-0.010811,
		-0.994834,
		-0.100936,
		0,
		-0.868723,
		0.059332,
		-0.491732,
		0,
		-0.178022,
		-0.026077,
		-0.39676,
		1,
	},
	[0.816666666667] = {
		0.705903,
		-0.43678,
		-0.557606,
		0,
		-0.560327,
		-0.825918,
		-0.062395,
		0,
		-0.433285,
		0.356486,
		-0.827757,
		0,
		-0.05504,
		0.01045,
		-0.570802,
		1,
	},
	[0.833333333333] = {
		0.697189,
		-0.510041,
		-0.503772,
		0,
		-0.620016,
		-0.781759,
		-0.066577,
		0,
		-0.359871,
		0.358764,
		-0.861267,
		0,
		-0.038144,
		0.015701,
		-0.591623,
		1,
	},
	[0.85] = {
		0.683887,
		-0.567816,
		-0.45813,
		0,
		-0.666041,
		-0.7422,
		-0.074354,
		0,
		-0.297805,
		0.355983,
		-0.88577,
		0,
		-0.023547,
		0.019834,
		-0.609262,
		1,
	},
	[0.866666666667] = {
		0.671173,
		-0.607588,
		-0.424692,
		0,
		-0.697486,
		-0.711636,
		-0.084183,
		0,
		-0.251077,
		0.352718,
		-0.901416,
		0,
		-0.012106,
		0.022597,
		-0.622972,
		1,
	},
	[0.883333333333] = {
		0.661344,
		-0.633279,
		-0.401971,
		0,
		-0.717636,
		-0.690119,
		-0.093457,
		0,
		-0.218224,
		0.350276,
		-0.91087,
		0,
		-0.003731,
		0.024258,
		-0.632965,
		1,
	},
	[0.8] = {
		0.705468,
		-0.351854,
		-0.615235,
		0,
		-0.488846,
		-0.870097,
		-0.062932,
		0,
		-0.513172,
		0.345151,
		-0.785828,
		0,
		-0.073398,
		0.004396,
		-0.547567,
		1,
	},
	[0.916666666667] = {
		0.648854,
		-0.66232,
		-0.374593,
		0,
		-0.739431,
		-0.664988,
		-0.105041,
		0,
		-0.179529,
		0.345142,
		-0.92122,
		0,
		0.006385,
		0.025837,
		-0.644855,
		1,
	},
	[0.933333333333] = {
		0.646503,
		-0.668082,
		-0.368376,
		0,
		-0.743405,
		-0.660157,
		-0.107429,
		0,
		-0.171415,
		0.343306,
		-0.923449,
		0,
		0.008579,
		0.025934,
		-0.647387,
		1,
	},
	[0.95] = {
		0.646497,
		-0.669293,
		-0.36618,
		0,
		-0.743884,
		-0.659552,
		-0.10783,
		0,
		-0.169345,
		0.342108,
		-0.924275,
		0,
		0.009198,
		0.025669,
		-0.648064,
		1,
	},
	[0.966666666667] = {
		0.648456,
		-0.66676,
		-0.367337,
		0,
		-0.741499,
		-0.662438,
		-0.106557,
		0,
		-0.17229,
		0.341478,
		-0.923964,
		0,
		0.008504,
		0.025109,
		-0.647197,
		1,
	},
	[0.983333333333] = {
		0.65192,
		-0.66122,
		-0.371199,
		0,
		-0.736798,
		-0.668072,
		-0.103963,
		0,
		-0.179245,
		0.341274,
		-0.922715,
		0,
		0.006764,
		0.024318,
		-0.645097,
		1,
	},
	[0.9] = {
		0.653795,
		-0.651085,
		-0.385539,
		0,
		-0.731178,
		-0.674755,
		-0.100426,
		0,
		-0.194759,
		0.347556,
		-0.91721,
		0,
		0.002361,
		0.025306,
		-0.640153,
		1,
	},
	[1.01666666667] = {
		0.661423,
		-0.64397,
		-0.384478,
		0,
		-0.722521,
		-0.684609,
		-0.096298,
		0,
		-0.201204,
		0.341487,
		-0.918098,
		0,
		0.001225,
		0.022292,
		-0.638438,
		1,
	},
	[1.03333333333] = {
		0.666537,
		-0.633719,
		-0.392593,
		0,
		-0.714037,
		-0.694042,
		-0.091964,
		0,
		-0.214196,
		0.341624,
		-0.915103,
		0,
		-0.002039,
		0.021188,
		-0.634501,
		1,
	},
	[1.05] = {
		0.671353,
		-0.623415,
		-0.400798,
		0,
		-0.705465,
		-0.70329,
		-0.08776,
		0,
		-0.227167,
		0.341667,
		-0.911953,
		0,
		-0.005281,
		0.020117,
		-0.630575,
		1,
	},
	[1.06666666667] = {
		0.675539,
		-0.613883,
		-0.408405,
		0,
		-0.697488,
		-0.711656,
		-0.084001,
		0,
		-0.239077,
		0.341604,
		-0.908927,
		0,
		-0.008244,
		0.01915,
		-0.626973,
		1,
	},
	[1.08333333333] = {
		0.678821,
		-0.605984,
		-0.414711,
		0,
		-0.69084,
		-0.718458,
		-0.08098,
		0,
		-0.24888,
		0.34147,
		-0.906342,
		0,
		-0.010671,
		0.018364,
		-0.624011,
		1,
	},
	{
		0.656402,
		-0.653385,
		-0.377127,
		0,
		-0.730297,
		-0.675709,
		-0.100418,
		0,
		-0.189216,
		0.34133,
		-0.920701,
		0,
		0.004248,
		0.023357,
		-0.642074,
		1,
	},
	[1.11666666667] = {
		0.681734,
		-0.59861,
		-0.4206,
		0,
		-0.684607,
		-0.724701,
		-0.078236,
		0,
		-0.257977,
		0.341283,
		-0.903866,
		0,
		-0.012916,
		0.017643,
		-0.621264,
		1,
	},
	[1.13333333333] = {
		0.681734,
		-0.59861,
		-0.4206,
		0,
		-0.684607,
		-0.724701,
		-0.078236,
		0,
		-0.257977,
		0.341283,
		-0.903866,
		0,
		-0.012916,
		0.017643,
		-0.621264,
		1,
	},
	[1.1] = {
		0.680963,
		-0.600598,
		-0.419012,
		0,
		-0.68629,
		-0.723028,
		-0.078969,
		0,
		-0.255529,
		0.341338,
		-0.90454,
		0,
		-0.012313,
		0.017836,
		-0.622003,
		1,
	},
}

return spline_matrices
