﻿-- chunkname: @content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_stab_01.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.999519,
		0.02528,
		0.017973,
		0,
		-0.025954,
		0.998928,
		0.038337,
		0,
		-0.016984,
		-0.038785,
		0.999103,
		0,
		0.140755,
		0.305252,
		-0.164588,
		1,
	},
	[0.0333333333333] = {
		0.991354,
		0.004431,
		0.131141,
		0,
		-0.009141,
		0.999334,
		0.035335,
		0,
		-0.130897,
		-0.036228,
		0.990734,
		0,
		0.148551,
		0.294819,
		-0.166953,
		1,
	},
	[0.05] = {
		0.95544,
		-0.025535,
		0.294078,
		0,
		0.014705,
		0.999132,
		0.038979,
		0,
		-0.294818,
		-0.032917,
		0.954986,
		0,
		0.159657,
		0.279011,
		-0.170564,
		1,
	},
	[0.0666666666667] = {
		0.875464,
		-0.060776,
		0.479446,
		0,
		0.039071,
		0.997714,
		0.05513,
		0,
		-0.481701,
		-0.029532,
		0.875838,
		0,
		0.172545,
		0.25911,
		-0.175136,
		1,
	},
	[0.0833333333333] = {
		0.747743,
		-0.09736,
		0.656812,
		0,
		0.055523,
		0.994895,
		0.084265,
		0,
		-0.661663,
		-0.026541,
		0.749331,
		0,
		0.185712,
		0.236362,
		-0.180418,
		1,
	},
	[0] = {
		0.999166,
		0.033118,
		-0.023877,
		0,
		-0.032131,
		0.998659,
		0.040605,
		0,
		0.02519,
		-0.039804,
		0.99889,
		0,
		0.137816,
		0.309013,
		-0.163749,
		1,
	},
	[0.116666666667] = {
		0.412258,
		-0.157652,
		0.897324,
		0,
		0.044683,
		0.987228,
		0.152919,
		0,
		-0.909971,
		-0.022947,
		0.414037,
		0,
		0.20684,
		0.187043,
		-0.192489,
		1,
	},
	[0.133333333333] = {
		0.259633,
		-0.172324,
		0.950208,
		0,
		0.02271,
		0.984768,
		0.172386,
		0,
		-0.96544,
		-0.023178,
		0.259591,
		0,
		0.211798,
		0.162727,
		-0.199319,
		1,
	},
	[0.15] = {
		0.1642,
		-0.177348,
		0.970354,
		0,
		-0.00293,
		0.983613,
		0.180267,
		0,
		-0.986423,
		-0.032443,
		0.160989,
		0,
		0.209189,
		0.122294,
		-0.218812,
		1,
	},
	[0.166666666667] = {
		0.112962,
		-0.179253,
		0.977296,
		0,
		-0.031158,
		0.982469,
		0.183803,
		0,
		-0.993111,
		-0.051213,
		0.105396,
		0,
		0.200527,
		0.072115,
		-0.247082,
		1,
	},
	[0.183333333333] = {
		0.05592,
		-0.18,
		0.982076,
		0,
		-0.060269,
		0.981213,
		0.183274,
		0,
		-0.996615,
		-0.069437,
		0.044021,
		0,
		0.191211,
		0.047855,
		-0.260116,
		1,
	},
	[0.1] = {
		0.584904,
		-0.131127,
		0.800433,
		0,
		0.057597,
		0.991069,
		0.120269,
		0,
		-0.809055,
		-0.024243,
		0.587233,
		0,
		0.19765,
		0.211958,
		-0.186223,
		1,
	},
	[0.216666666667] = {
		0.039332,
		-0.17841,
		0.98317,
		0,
		-0.094855,
		0.978821,
		0.181415,
		0,
		-0.994714,
		-0.100394,
		0.021576,
		0,
		0.140421,
		0.364536,
		-0.213524,
		1,
	},
	[0.233333333333] = {
		0.195433,
		-0.183436,
		0.963409,
		0,
		-0.078235,
		0.976305,
		0.201762,
		0,
		-0.977592,
		-0.114803,
		0.176451,
		0,
		0.09695,
		0.52182,
		-0.190281,
		1,
	},
	[0.25] = {
		0.275589,
		-0.204069,
		0.939365,
		0,
		-0.051994,
		0.972612,
		0.226546,
		0,
		-0.959869,
		-0.111275,
		0.25743,
		0,
		0.059216,
		0.661677,
		-0.166341,
		1,
	},
	[0.266666666667] = {
		0.274762,
		-0.201416,
		0.940179,
		0,
		-0.045543,
		0.97399,
		0.221969,
		0,
		-0.960433,
		-0.103807,
		0.258442,
		0,
		0.06115,
		0.668401,
		-0.159326,
		1,
	},
	[0.283333333333] = {
		0.274643,
		-0.196375,
		0.94128,
		0,
		-0.042953,
		0.97544,
		0.216035,
		0,
		-0.960586,
		-0.099763,
		0.259463,
		0,
		0.062042,
		0.672516,
		-0.153382,
		1,
	},
	[0.2] = {
		-0.045572,
		-0.179394,
		0.982721,
		0,
		-0.093302,
		0.980207,
		0.174609,
		0,
		-0.994594,
		-0.083733,
		-0.061408,
		0,
		0.179334,
		0.206111,
		-0.238631,
		1,
	},
	[0.316666666667] = {
		0.276162,
		-0.17533,
		0.944984,
		0,
		-0.051671,
		0.97909,
		0.196758,
		0,
		-0.959721,
		-0.103165,
		0.261328,
		0,
		0.058783,
		0.673488,
		-0.146776,
		1,
	},
	[0.333333333333] = {
		0.280256,
		-0.164509,
		0.945724,
		0,
		-0.056252,
		0.980698,
		0.187262,
		0,
		-0.958276,
		-0.10568,
		0.265592,
		0,
		0.057978,
		0.670987,
		-0.143743,
		1,
	},
	[0.35] = {
		0.287841,
		-0.155287,
		0.945004,
		0,
		-0.058614,
		0.98206,
		0.17923,
		0,
		-0.955883,
		-0.10698,
		0.273575,
		0,
		0.058823,
		0.666839,
		-0.140115,
		1,
	},
	[0.366666666667] = {
		0.298471,
		-0.145349,
		0.943286,
		0,
		-0.060776,
		0.983436,
		0.170766,
		0,
		-0.952482,
		-0.108297,
		0.284693,
		0,
		0.060107,
		0.661092,
		-0.137131,
		1,
	},
	[0.383333333333] = {
		0.312566,
		-0.134797,
		0.940283,
		0,
		-0.062551,
		0.984811,
		0.161973,
		0,
		-0.947834,
		-0.109443,
		0.299387,
		0,
		0.061783,
		0.653973,
		-0.134785,
		1,
	},
	[0.3] = {
		0.27494,
		-0.18733,
		0.943035,
		0,
		-0.045719,
		0.977179,
		0.207441,
		0,
		-0.960374,
		-0.100149,
		0.260101,
		0,
		0.060893,
		0.674147,
		-0.149314,
		1,
	},
	[0.416666666667] = {
		0.352708,
		-0.112286,
		0.928972,
		0,
		-0.064323,
		0.987516,
		0.143784,
		0,
		-0.93352,
		-0.110468,
		0.341083,
		0,
		0.066124,
		0.636514,
		-0.13199,
		1,
	},
	[0.433333333333] = {
		0.379429,
		-0.100546,
		0.919741,
		0,
		-0.06407,
		0.988836,
		0.134531,
		0,
		-0.923,
		-0.109973,
		0.368751,
		0,
		0.068694,
		0.626628,
		-0.131526,
		1,
	},
	[0.45] = {
		0.410929,
		-0.088627,
		0.907349,
		0,
		-0.062935,
		0.990131,
		0.125215,
		0,
		-0.909492,
		-0.108558,
		0.401296,
		0,
		0.071473,
		0.616275,
		-0.131668,
		1,
	},
	[0.466666666667] = {
		0.466822,
		-0.071865,
		0.881427,
		0,
		-0.054408,
		0.992471,
		0.109735,
		0,
		-0.882676,
		-0.099183,
		0.459397,
		0,
		0.077345,
		0.597883,
		-0.132977,
		1,
	},
	[0.483333333333] = {
		0.553383,
		-0.048413,
		0.831519,
		0,
		-0.039522,
		0.995659,
		0.084272,
		0,
		-0.831989,
		-0.079498,
		0.549067,
		0,
		0.087828,
		0.567834,
		-0.135989,
		1,
	},
	[0.4] = {
		0.330525,
		-0.123739,
		0.935651,
		0,
		-0.063779,
		0.986173,
		0.152951,
		0,
		-0.94164,
		-0.11023,
		0.318063,
		0,
		0.063804,
		0.645704,
		-0.133073,
		1,
	},
	[0.516666666667] = {
		0.740156,
		0.001497,
		0.672433,
		0,
		-0.026221,
		0.999301,
		0.026638,
		0,
		-0.671924,
		-0.037348,
		0.739678,
		0,
		0.11441,
		0.497426,
		-0.147218,
		1,
	},
	[0.533333333333] = {
		0.809841,
		0.019429,
		0.586327,
		0,
		-0.033056,
		0.999375,
		0.012541,
		0,
		-0.585717,
		-0.029537,
		0.809977,
		0,
		0.126333,
		0.46939,
		-0.15581,
		1,
	},
	[0.55] = {
		0.868654,
		0.03247,
		0.494354,
		0,
		-0.045457,
		0.998864,
		0.014267,
		0,
		-0.49333,
		-0.034865,
		0.869143,
		0,
		0.137837,
		0.447333,
		-0.169467,
		1,
	},
	[0.566666666667] = {
		0.921941,
		0.044199,
		0.3848,
		0,
		-0.059357,
		0.997855,
		0.027599,
		0,
		-0.382754,
		-0.048285,
		0.922587,
		0,
		0.150523,
		0.426765,
		-0.188174,
		1,
	},
	[0.583333333333] = {
		0.96101,
		0.054479,
		0.271095,
		0,
		-0.070261,
		0.996332,
		0.048847,
		0,
		-0.267439,
		-0.06599,
		0.961312,
		0,
		0.162774,
		0.408195,
		-0.208342,
		1,
	},
	[0.5] = {
		0.650516,
		-0.022485,
		0.759159,
		0,
		-0.028254,
		0.998153,
		0.053773,
		0,
		-0.758967,
		-0.05643,
		0.64868,
		0,
		0.100861,
		0.532284,
		-0.140738,
		1,
	},
	[0.616666666667] = {
		0.993062,
		0.068932,
		0.095273,
		0,
		-0.077725,
		0.992731,
		0.09189,
		0,
		-0.088246,
		-0.098657,
		0.991201,
		0,
		0.180348,
		0.378713,
		-0.239183,
		1,
	},
	[0.633333333333] = {
		0.995313,
		0.071595,
		0.065006,
		0,
		-0.077966,
		0.991782,
		0.101439,
		0,
		-0.057209,
		-0.106032,
		0.992716,
		0,
		0.183104,
		0.368443,
		-0.243257,
		1,
	},
	[0.65] = {
		0.995537,
		0.071442,
		0.061657,
		0,
		-0.077551,
		0.991637,
		0.103157,
		0,
		-0.053771,
		-0.107478,
		0.992752,
		0,
		0.18269,
		0.359678,
		-0.241133,
		1,
	},
	[0.666666666667] = {
		0.995847,
		0.069734,
		0.058539,
		0,
		-0.075491,
		0.991843,
		0.102702,
		0,
		-0.050899,
		-0.106694,
		0.992988,
		0,
		0.181317,
		0.350686,
		-0.237651,
		1,
	},
	[0.683333333333] = {
		0.996244,
		0.0666,
		0.055345,
		0,
		-0.071901,
		0.992379,
		0.100071,
		0,
		-0.048259,
		-0.103675,
		0.99344,
		0,
		0.179087,
		0.341489,
		-0.233151,
		1,
	},
	[0.6] = {
		0.983582,
		0.062938,
		0.169134,
		0,
		-0.076083,
		0.99447,
		0.07239,
		0,
		-0.163642,
		-0.084069,
		0.982931,
		0,
		0.173149,
		0.39206,
		-0.226465,
		1,
	},
	[0.716666666667] = {
		0.997128,
		0.057159,
		0.049692,
		0,
		-0.061499,
		0.993977,
		0.090709,
		0,
		-0.044208,
		-0.093504,
		0.994637,
		0,
		0.172705,
		0.323336,
		-0.221207,
		1,
	},
	[0.733333333333] = {
		0.99755,
		0.051363,
		0.047487,
		0,
		-0.055266,
		0.994856,
		0.0849,
		0,
		-0.042882,
		-0.087316,
		0.995257,
		0,
		0.168857,
		0.314709,
		-0.214001,
		1,
	},
	[0.75] = {
		0.997942,
		0.045118,
		0.045574,
		0,
		-0.048608,
		0.995719,
		0.07862,
		0,
		-0.041831,
		-0.080673,
		0.995862,
		0,
		0.164745,
		0.306497,
		-0.206304,
		1,
	},
	[0.766666666667] = {
		0.998291,
		0.038624,
		0.043861,
		0,
		-0.041723,
		0.996526,
		0.072082,
		0,
		-0.040924,
		-0.073789,
		0.996434,
		0,
		0.1605,
		0.298788,
		-0.198366,
		1,
	},
	[0.783333333333] = {
		0.998592,
		0.032083,
		0.042257,
		0,
		-0.034811,
		0.997245,
		0.065497,
		0,
		-0.04004,
		-0.066876,
		0.996958,
		0,
		0.156255,
		0.291665,
		-0.190439,
		1,
	},
	[0.7] = {
		0.996687,
		0.062305,
		0.052282,
		0,
		-0.06711,
		0.993132,
		0.095836,
		0,
		-0.045951,
		-0.099027,
		0.994023,
		0,
		0.176159,
		0.332292,
		-0.227673,
		1,
	},
	[0.816666666667] = {
		0.999045,
		0.019665,
		0.039011,
		0,
		-0.021723,
		0.998356,
		0.053032,
		0,
		-0.037904,
		-0.053829,
		0.99783,
		0,
		0.148283,
		0.279519,
		-0.175623,
		1,
	},
	[0.833333333333] = {
		0.999208,
		0.014193,
		0.037186,
		0,
		-0.015956,
		0.99874,
		0.047571,
		0,
		-0.036464,
		-0.048127,
		0.998175,
		0,
		0.144819,
		0.27466,
		-0.169239,
		1,
	},
	[0.85] = {
		0.999339,
		0.009479,
		0.035103,
		0,
		-0.010983,
		0.999019,
		0.042902,
		0,
		-0.034661,
		-0.04326,
		0.998462,
		0,
		0.141874,
		0.270719,
		-0.163876,
		1,
	},
	[0.866666666667] = {
		0.99945,
		0.005728,
		0.03267,
		0,
		-0.007009,
		0.999205,
		0.039237,
		0,
		-0.032419,
		-0.039445,
		0.998696,
		0,
		0.139578,
		0.267777,
		-0.159789,
		1,
	},
	[0.883333333333] = {
		0.999551,
		0.003138,
		0.029794,
		0,
		-0.004234,
		0.999314,
		0.036788,
		0,
		-0.029659,
		-0.036898,
		0.998879,
		0,
		0.138056,
		0.265913,
		-0.157235,
		1,
	},
	[0.8] = {
		0.998842,
		0.025696,
		0.040671,
		0,
		-0.028076,
		0.997858,
		0.059078,
		0,
		-0.039066,
		-0.060151,
		0.997425,
		0,
		0.152139,
		0.285214,
		-0.182774,
		1,
	},
	[0.916666666667] = {
		0.99975,
		0.002282,
		0.022254,
		0,
		-0.003077,
		0.999357,
		0.03573,
		0,
		-0.022158,
		-0.035789,
		0.999114,
		0,
		0.137346,
		0.266157,
		-0.156818,
		1,
	},
	[0.933333333333] = {
		0.99984,
		0.004127,
		0.017426,
		0,
		-0.004752,
		0.99934,
		0.036024,
		0,
		-0.017266,
		-0.036101,
		0.999199,
		0,
		0.137333,
		0.268945,
		-0.157391,
		1,
	},
	[0.95] = {
		0.999901,
		0.007123,
		0.012114,
		0,
		-0.007562,
		0.999301,
		0.036617,
		0,
		-0.011845,
		-0.036705,
		0.999256,
		0,
		0.137383,
		0.273161,
		-0.158141,
		1,
	},
	[0.966666666667] = {
		0.999919,
		0.010949,
		0.006533,
		0,
		-0.011186,
		0.999235,
		0.037462,
		0,
		-0.006118,
		-0.037532,
		0.999277,
		0,
		0.137481,
		0.278396,
		-0.159019,
		1,
	},
	[0.983333333333] = {
		0.999883,
		0.015283,
		0.000897,
		0,
		-0.015306,
		0.999141,
		0.038505,
		0,
		-0.000308,
		-0.038514,
		0.999258,
		0,
		0.137614,
		0.284243,
		-0.159973,
		1,
	},
	[0.9] = {
		0.99965,
		0.001913,
		0.026384,
		0,
		-0.002857,
		0.999356,
		0.035773,
		0,
		-0.026298,
		-0.035836,
		0.999012,
		0,
		0.137434,
		0.265206,
		-0.156471,
		1,
	},
	[1.01666666667] = {
		0.999661,
		0.024183,
		-0.009672,
		0,
		-0.023768,
		0.99888,
		0.040911,
		0,
		0.010651,
		-0.040667,
		0.999116,
		0,
		0.137924,
		0.29614,
		-0.161903,
		1,
	},
	[1.03333333333] = {
		0.999504,
		0.028106,
		-0.014173,
		0,
		-0.027488,
		0.998735,
		0.042111,
		0,
		0.015338,
		-0.041701,
		0.999012,
		0,
		0.13807,
		0.301373,
		-0.162772,
		1,
	},
	[1.05] = {
		0.999352,
		0.031251,
		-0.017862,
		0,
		-0.030455,
		0.998603,
		0.043185,
		0,
		0.019187,
		-0.042613,
		0.998907,
		0,
		0.138189,
		0.305582,
		-0.163506,
		1,
	},
	[1.06666666667] = {
		0.999235,
		0.033294,
		-0.020523,
		0,
		-0.032366,
		0.998506,
		0.044031,
		0,
		0.021958,
		-0.043334,
		0.998819,
		0,
		0.138266,
		0.308359,
		-0.164049,
		1,
	},
	[1.08333333333] = {
		0.999184,
		0.033917,
		-0.02194,
		0,
		-0.032914,
		0.998465,
		0.044553,
		0,
		0.023417,
		-0.043795,
		0.998766,
		0,
		0.138283,
		0.309295,
		-0.164347,
		1,
	},
	{
		0.999793,
		0.019801,
		-0.004577,
		0,
		-0.019604,
		0.99902,
		0.03968,
		0,
		0.005358,
		-0.039582,
		0.999202,
		0,
		0.137767,
		0.290294,
		-0.160952,
		1,
	},
	[1.11666666667] = {
		0.999171,
		0.033495,
		-0.023142,
		0,
		-0.032468,
		0.99853,
		0.043399,
		0,
		0.024562,
		-0.042612,
		0.99879,
		0,
		0.138105,
		0.309108,
		-0.16425,
		1,
	},
	[1.13333333333] = {
		0.999168,
		0.033305,
		-0.023542,
		0,
		-0.032293,
		0.998589,
		0.042152,
		0,
		0.024913,
		-0.041357,
		0.998834,
		0,
		0.137971,
		0.309054,
		-0.164035,
		1,
	},
	[1.15] = {
		0.999167,
		0.03317,
		-0.023791,
		0,
		-0.032174,
		0.998638,
		0.041068,
		0,
		0.025121,
		-0.040269,
		0.998873,
		0,
		0.137861,
		0.309023,
		-0.163836,
		1,
	},
	[1.16666666667] = {
		0.999166,
		0.033118,
		-0.023877,
		0,
		-0.032131,
		0.998659,
		0.040605,
		0,
		0.02519,
		-0.039804,
		0.99889,
		0,
		0.137816,
		0.309013,
		-0.163749,
		1,
	},
	[1.1] = {
		0.999176,
		0.033709,
		-0.022604,
		0,
		-0.032682,
		0.998481,
		0.044352,
		0,
		0.024065,
		-0.043576,
		0.99876,
		0,
		0.138223,
		0.309188,
		-0.164385,
		1,
	},
}

return spline_matrices
