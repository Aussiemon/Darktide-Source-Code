﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_power_sword/attack_right.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.077771,
		-0.843849,
		-0.530915,
		0,
		-0.898125,
		-0.171884,
		0.404757,
		0,
		-0.432809,
		0.508306,
		-0.744514,
		0,
		-0.290609,
		-0.037524,
		-0.677674,
		1,
	},
	[0.0333333333333] = {
		0.043131,
		-0.875179,
		-0.481873,
		0,
		-0.829381,
		-0.300277,
		0.471128,
		0,
		-0.557016,
		0.379336,
		-0.738808,
		0,
		-0.294091,
		-0.05055,
		-0.666078,
		1,
	},
	[0.05] = {
		0.303998,
		-0.800986,
		-0.515758,
		0,
		-0.60834,
		-0.579844,
		0.541944,
		0,
		-0.733149,
		0.149006,
		-0.663543,
		0,
		-0.301482,
		-0.060707,
		-0.618372,
		1,
	},
	[0.0666666666667] = {
		0.557337,
		-0.516579,
		-0.650017,
		0,
		-0.103591,
		-0.820029,
		0.562869,
		0,
		-0.823799,
		-0.246372,
		-0.510545,
		0,
		-0.318162,
		-0.067788,
		-0.519555,
		1,
	},
	[0.0833333333333] = {
		0.613671,
		-0.15021,
		-0.775142,
		0,
		0.42783,
		-0.761859,
		0.486345,
		0,
		-0.663603,
		-0.630085,
		-0.403267,
		0,
		-0.326743,
		-0.061475,
		-0.39787,
		1,
	},
	[0] = {
		-0.137148,
		-0.817858,
		-0.558837,
		0,
		-0.920704,
		-0.102842,
		0.376466,
		0,
		-0.365368,
		0.566156,
		-0.738901,
		0,
		-0.288708,
		-0.030821,
		-0.679158,
		1,
	},
	[0.116666666667] = {
		0.260669,
		0.195945,
		-0.945334,
		0,
		0.965402,
		-0.060099,
		0.253745,
		0,
		-0.007094,
		-0.978772,
		-0.204832,
		0,
		-0.308999,
		-0.037595,
		-0.236002,
		1,
	},
	[0.133333333333] = {
		-0.395866,
		0.002893,
		-0.918304,
		0,
		0.894913,
		0.2255,
		-0.385072,
		0,
		0.205964,
		-0.974239,
		-0.091856,
		0,
		-0.287618,
		-0.021182,
		-0.200647,
		1,
	},
	[0.15] = {
		-0.394245,
		0.019966,
		-0.918788,
		0,
		0.900248,
		0.209351,
		-0.381741,
		0,
		0.184727,
		-0.977637,
		-0.10051,
		0,
		-0.280111,
		-0.003061,
		-0.196943,
		1,
	},
	[0.166666666667] = {
		-0.392479,
		0.047926,
		-0.918512,
		0,
		0.907353,
		0.183659,
		-0.378128,
		0,
		0.150571,
		-0.981821,
		-0.115568,
		0,
		-0.272416,
		0.017414,
		-0.193681,
		1,
	},
	[0.183333333333] = {
		-0.388149,
		0.081663,
		-0.917971,
		0,
		0.915983,
		0.143956,
		-0.374502,
		0,
		0.101565,
		-0.986209,
		-0.130678,
		0,
		-0.265814,
		0.041264,
		-0.190396,
		1,
	},
	[0.1] = {
		0.309263,
		0.163021,
		-0.936899,
		0,
		0.887404,
		-0.403638,
		0.222691,
		0,
		-0.341864,
		-0.900278,
		-0.269496,
		0,
		-0.326002,
		-0.04896,
		-0.285923,
		1,
	},
	[0.216666666667] = {
		-0.363308,
		0.146041,
		-0.920152,
		0,
		0.930406,
		0.00546,
		-0.36649,
		0,
		-0.048499,
		-0.989263,
		-0.137861,
		0,
		-0.261017,
		0.103299,
		-0.181914,
		1,
	},
	[0.233333333333] = {
		-0.339364,
		0.174611,
		-0.924307,
		0,
		0.930193,
		-0.083848,
		-0.357365,
		0,
		-0.139901,
		-0.981061,
		-0.133967,
		0,
		-0.267426,
		0.142118,
		-0.176603,
		1,
	},
	[0.25] = {
		-0.308349,
		0.203933,
		-0.929157,
		0,
		0.91977,
		-0.185374,
		-0.34592,
		0,
		-0.242786,
		-0.961274,
		-0.130412,
		0,
		-0.279366,
		0.186411,
		-0.17079,
		1,
	},
	[0.266666666667] = {
		-0.272712,
		0.227619,
		-0.934782,
		0,
		0.883682,
		-0.32494,
		-0.336927,
		0,
		-0.380439,
		-0.917935,
		-0.112528,
		0,
		-0.291181,
		0.238532,
		-0.163699,
		1,
	},
	[0.283333333333] = {
		-0.234708,
		0.239667,
		-0.942057,
		0,
		0.788682,
		-0.519568,
		-0.328677,
		0,
		-0.568236,
		-0.820127,
		-0.067074,
		0,
		-0.297139,
		0.301436,
		-0.154625,
		1,
	},
	[0.2] = {
		-0.379067,
		0.116058,
		-0.918062,
		0,
		0.924675,
		0.085917,
		-0.370936,
		0,
		0.035827,
		-0.98952,
		-0.139884,
		0,
		-0.261587,
		0.069533,
		-0.186625,
		1,
	},
	[0.316666666667] = {
		-0.147204,
		0.235484,
		-0.960665,
		0,
		0.255744,
		-0.929157,
		-0.266949,
		0,
		-0.955471,
		-0.284981,
		0.076552,
		0,
		-0.307113,
		0.483656,
		-0.134014,
		1,
	},
	[0.333333333333] = {
		-0.097864,
		0.21853,
		-0.970911,
		0,
		-0.163246,
		-0.965904,
		-0.200948,
		0,
		-0.98172,
		0.138832,
		0.130201,
		0,
		-0.294366,
		0.585654,
		-0.121257,
		1,
	},
	[0.35] = {
		-0.046399,
		0.186751,
		-0.981311,
		0,
		-0.577821,
		-0.806358,
		-0.126136,
		0,
		-0.814844,
		0.561169,
		0.145323,
		0,
		-0.249061,
		0.674312,
		-0.104718,
		1,
	},
	[0.366666666667] = {
		0.010463,
		0.117814,
		-0.992981,
		0,
		-0.909928,
		-0.410647,
		-0.05831,
		0,
		-0.414634,
		0.904151,
		0.102906,
		0,
		-0.13105,
		0.732803,
		-0.078647,
		1,
	},
	[0.383333333333] = {
		0.001867,
		0.099665,
		-0.995019,
		0,
		-0.999208,
		-0.039365,
		-0.005818,
		0,
		-0.039748,
		0.994242,
		0.099512,
		0,
		0.030374,
		0.746031,
		-0.069224,
		1,
	},
	[0.3] = {
		-0.193271,
		0.241363,
		-0.950994,
		0,
		0.585687,
		-0.749248,
		-0.309189,
		0,
		-0.787157,
		-0.616743,
		0.003445,
		0,
		-0.302713,
		0.38406,
		-0.144613,
		1,
	},
	[0.416666666667] = {
		-0.10001,
		0.180789,
		-0.978424,
		0,
		-0.903807,
		0.394719,
		0.165317,
		0,
		0.41609,
		0.90084,
		0.123922,
		0,
		0.341625,
		0.661026,
		-0.120731,
		1,
	},
	[0.433333333333] = {
		-0.127509,
		0.212468,
		-0.968813,
		0,
		-0.828135,
		0.514744,
		0.221881,
		0,
		0.545833,
		0.8306,
		0.110318,
		0,
		0.42707,
		0.597956,
		-0.13152,
		1,
	},
	[0.45] = {
		-0.14795,
		0.238574,
		-0.959788,
		0,
		-0.739484,
		0.617727,
		0.267539,
		0,
		0.656714,
		0.749331,
		0.085029,
		0,
		0.485696,
		0.519669,
		-0.151685,
		1,
	},
	[0.466666666667] = {
		-0.174612,
		0.258192,
		-0.950183,
		0,
		-0.589878,
		0.74524,
		0.310903,
		0,
		0.788387,
		0.61478,
		0.022173,
		0,
		0.547122,
		0.418797,
		-0.20366,
		1,
	},
	[0.483333333333] = {
		-0.202325,
		0.272993,
		-0.9405,
		0,
		-0.388357,
		0.859255,
		0.332956,
		0,
		0.899024,
		0.432615,
		-0.067831,
		0,
		0.609586,
		0.300556,
		-0.272879,
		1,
	},
	[0.4] = {
		-0.046502,
		0.13446,
		-0.989827,
		0,
		-0.973891,
		0.214314,
		0.074866,
		0,
		0.222201,
		0.967466,
		0.120983,
		0,
		0.197456,
		0.714099,
		-0.092008,
		1,
	},
	[0.516666666667] = {
		-0.245245,
		0.304058,
		-0.920545,
		0,
		0.045774,
		0.952116,
		0.302291,
		0,
		0.96838,
		0.031998,
		-0.247419,
		0,
		0.707607,
		0.069701,
		-0.415186,
		1,
	},
	[0.533333333333] = {
		-0.255161,
		0.327969,
		-0.909576,
		0,
		0.202367,
		0.937995,
		0.281447,
		0,
		0.945484,
		-0.112254,
		-0.30571,
		0,
		0.727093,
		-0.013054,
		-0.465632,
		1,
	},
	[0.55] = {
		-0.254285,
		0.36206,
		-0.896801,
		0,
		0.295589,
		0.912005,
		0.284385,
		0,
		0.920851,
		-0.19277,
		-0.33893,
		0,
		0.713845,
		-0.063978,
		-0.493846,
		1,
	},
	[0.566666666667] = {
		-0.24476,
		0.403572,
		-0.881602,
		0,
		0.345561,
		0.885859,
		0.309582,
		0,
		0.905914,
		-0.228874,
		-0.356282,
		0,
		0.672818,
		-0.093474,
		-0.507543,
		1,
	},
	[0.583333333333] = {
		-0.231364,
		0.446393,
		-0.86441,
		0,
		0.365942,
		0.863196,
		0.34782,
		0,
		0.901419,
		-0.235851,
		-0.363066,
		0,
		0.619399,
		-0.107477,
		-0.514215,
		1,
	},
	[0.5] = {
		-0.226946,
		0.286923,
		-0.930683,
		0,
		-0.163552,
		0.930818,
		0.326846,
		0,
		0.960076,
		0.226391,
		-0.164318,
		0,
		0.665705,
		0.179426,
		-0.34728,
		1,
	},
	[0.616666666667] = {
		-0.211552,
		0.513603,
		-0.831539,
		0,
		0.370739,
		0.82938,
		0.41795,
		0,
		0.904322,
		-0.219866,
		-0.365869,
		0,
		0.536954,
		-0.112227,
		-0.535835,
		1,
	},
	[0.633333333333] = {
		-0.228762,
		0.531409,
		-0.815643,
		0,
		0.372634,
		0.821848,
		0.43094,
		0,
		0.89934,
		-0.205354,
		-0.386029,
		0,
		0.522226,
		-0.103014,
		-0.564118,
		1,
	},
	[0.65] = {
		-0.272885,
		0.541569,
		-0.795133,
		0,
		0.372461,
		0.82152,
		0.431715,
		0,
		0.887021,
		-0.178348,
		-0.425894,
		0,
		0.512579,
		-0.08097,
		-0.601428,
		1,
	},
	[0.666666666667] = {
		-0.324427,
		0.546372,
		-0.772156,
		0,
		0.372357,
		0.824169,
		0.426728,
		0,
		0.869539,
		-0.149075,
		-0.470828,
		0,
		0.506947,
		-0.055383,
		-0.638942,
		1,
	},
	[0.683333333333] = {
		-0.365989,
		0.548024,
		-0.752144,
		0,
		0.373155,
		0.826821,
		0.42086,
		0,
		0.85253,
		-0.126636,
		-0.507105,
		0,
		0.504338,
		-0.03499,
		-0.667881,
		1,
	},
	[0.6] = {
		-0.218796,
		0.484806,
		-0.846812,
		0,
		0.369797,
		0.844301,
		0.387822,
		0,
		0.902983,
		-0.228294,
		-0.36401,
		0,
		0.568967,
		-0.111803,
		-0.521224,
		1,
	},
	[0.716666666667] = {
		-0.378951,
		0.548603,
		-0.745273,
		0,
		0.378857,
		0.826726,
		0.415923,
		0,
		0.844313,
		-0.124737,
		-0.52113,
		0,
		0.503934,
		-0.031969,
		-0.679095,
		1,
	},
	[0.733333333333] = {
		-0.376217,
		0.548835,
		-0.746486,
		0,
		0.382698,
		0.825788,
		0.414267,
		0,
		0.843803,
		-0.129824,
		-0.520713,
		0,
		0.503895,
		-0.035774,
		-0.678933,
		1,
	},
	[0.75] = {
		-0.373483,
		0.549071,
		-0.747684,
		0,
		0.386742,
		0.824785,
		0.412506,
		0,
		0.843173,
		-0.135097,
		-0.520392,
		0,
		0.503739,
		-0.039716,
		-0.678831,
		1,
	},
	[0.766666666667] = {
		-0.370825,
		0.549303,
		-0.748836,
		0,
		0.390795,
		0.823756,
		0.410738,
		0,
		0.842477,
		-0.14033,
		-0.520134,
		0,
		0.503506,
		-0.043625,
		-0.678763,
		1,
	},
	[0.783333333333] = {
		-0.368317,
		0.549527,
		-0.749908,
		0,
		0.394667,
		0.822744,
		0.40906,
		0,
		0.841772,
		-0.1453,
		-0.519911,
		0,
		0.503244,
		-0.047332,
		-0.67871,
		1,
	},
	[0.7] = {
		-0.381614,
		0.548381,
		-0.744076,
		0,
		0.375413,
		0.827565,
		0.417374,
		0,
		0.844652,
		-0.12006,
		-0.521679,
		0,
		0.503813,
		-0.02847,
		-0.67934,
		1,
	},
	[0.816666666667] = {
		-0.364639,
		0.549854,
		-0.751464,
		0,
		0.401406,
		0.821014,
		0.405966,
		0,
		0.840185,
		-0.153611,
		-0.520089,
		0,
		0.5023,
		-0.053542,
		-0.678947,
		1,
	},
	[0.833333333333] = {
		-0.363625,
		0.549834,
		-0.751971,
		0,
		0.404216,
		0.820404,
		0.404408,
		0,
		0.839277,
		-0.156905,
		-0.520571,
		0,
		0.50156,
		-0.056056,
		-0.679291,
		1,
	},
	[0.85] = {
		-0.362983,
		0.549768,
		-0.752329,
		0,
		0.406848,
		0.819878,
		0.402834,
		0,
		0.838283,
		-0.159861,
		-0.521274,
		0,
		0.500661,
		-0.058329,
		-0.679763,
		1,
	},
	[0.866666666667] = {
		-0.362675,
		0.549664,
		-0.752553,
		0,
		0.409306,
		0.819429,
		0.401254,
		0,
		0.837219,
		-0.1625,
		-0.522167,
		0,
		0.499629,
		-0.060374,
		-0.680343,
		1,
	},
	[0.883333333333] = {
		-0.36266,
		0.549529,
		-0.75266,
		0,
		0.411594,
		0.819051,
		0.399681,
		0,
		0.836103,
		-0.164842,
		-0.52322,
		0,
		0.49849,
		-0.062205,
		-0.681014,
		1,
	},
	[0.8] = {
		-0.36618,
		0.549741,
		-0.750797,
		0,
		0.398241,
		0.821797,
		0.407497,
		0,
		0.841021,
		-0.149781,
		-0.519856,
		0,
		0.502869,
		-0.050667,
		-0.678746,
		1,
	},
	[0.916666666667] = {
		-0.363349,
		0.549188,
		-0.752576,
		0,
		0.415671,
		0.81849,
		0.3966,
		0,
		0.833784,
		-0.168719,
		-0.525679,
		0,
		0.495987,
		-0.065277,
		-0.682552,
		1,
	},
	[0.933333333333] = {
		-0.363973,
		0.548995,
		-0.752415,
		0,
		0.417465,
		0.818293,
		0.395119,
		0,
		0.832615,
		-0.170294,
		-0.527023,
		0,
		0.494674,
		-0.066545,
		-0.683382,
		1,
	},
	[0.95] = {
		-0.364605,
		0.548795,
		-0.752255,
		0,
		0.419036,
		0.818144,
		0.393764,
		0,
		0.831548,
		-0.171654,
		-0.528264,
		0,
		0.493464,
		-0.067652,
		-0.684147,
		1,
	},
	[0.966666666667] = {
		-0.365116,
		0.548593,
		-0.752154,
		0,
		0.420341,
		0.818034,
		0.392598,
		0,
		0.830665,
		-0.172818,
		-0.529273,
		0,
		0.492467,
		-0.068611,
		-0.68477,
		1,
	},
	[0.983333333333] = {
		-0.365515,
		0.548394,
		-0.752106,
		0,
		0.421409,
		0.817958,
		0.39161,
		0,
		0.829948,
		-0.173805,
		-0.530074,
		0,
		0.49166,
		-0.069435,
		-0.685266,
		1,
	},
	[0.9] = {
		-0.362898,
		0.549368,
		-0.752662,
		0,
		0.413715,
		0.818741,
		0.398125,
		0,
		0.834952,
		-0.166909,
		-0.524401,
		0,
		0.497267,
		-0.063835,
		-0.681756,
		1,
	},
	[1.01666666667] = {
		-0.36602,
		0.548025,
		-0.752129,
		0,
		0.42295,
		0.817881,
		0.390107,
		0,
		0.828941,
		-0.175326,
		-0.531148,
		0,
		0.490539,
		-0.070727,
		-0.685937,
		1,
	},
	[1.03333333333] = {
		-0.366146,
		0.547865,
		-0.752184,
		0,
		0.423481,
		0.817865,
		0.389564,
		0,
		0.828614,
		-0.175899,
		-0.531468,
		0,
		0.490183,
		-0.071221,
		-0.686141,
		1,
	},
	[1.05] = {
		-0.3662,
		0.547728,
		-0.752257,
		0,
		0.423891,
		0.817855,
		0.38914,
		0,
		0.82838,
		-0.176372,
		-0.531676,
		0,
		0.489936,
		-0.071631,
		-0.686275,
		1,
	},
	[1.06666666667] = {
		-0.366193,
		0.54762,
		-0.75234,
		0,
		0.424208,
		0.817843,
		0.38882,
		0,
		0.828221,
		-0.176766,
		-0.531793,
		0,
		0.489776,
		-0.071971,
		-0.686353,
		1,
	},
	[1.08333333333] = {
		-0.366134,
		0.547544,
		-0.752424,
		0,
		0.424461,
		0.817821,
		0.388588,
		0,
		0.828117,
		-0.177099,
		-0.531844,
		0,
		0.489682,
		-0.072252,
		-0.686391,
		1,
	},
	{
		-0.365813,
		0.548203,
		-0.7521,
		0,
		0.422269,
		0.81791,
		0.390784,
		0,
		0.829379,
		-0.174635,
		-0.530691,
		0,
		0.491025,
		-0.070136,
		-0.685651,
		1,
	},
	[1.11666666667] = {
		-0.365901,
		0.547511,
		-0.752561,
		0,
		0.424891,
		0.81772,
		0.388332,
		0,
		0.828,
		-0.177665,
		-0.531837,
		0,
		0.489609,
		-0.072693,
		-0.686396,
		1,
	},
	[1.13333333333] = {
		-0.365689,
		0.547565,
		-0.752625,
		0,
		0.425095,
		0.817625,
		0.388308,
		0,
		0.827989,
		-0.177937,
		-0.531764,
		0,
		0.489639,
		-0.072879,
		-0.686355,
		1,
	},
	[1.15] = {
		-0.365361,
		0.547671,
		-0.752707,
		0,
		0.425296,
		0.817491,
		0.388371,
		0,
		0.82803,
		-0.178228,
		-0.531602,
		0,
		0.489746,
		-0.073059,
		-0.68626,
		1,
	},
	[1.16666666667] = {
		-0.36494,
		0.547835,
		-0.752792,
		0,
		0.42553,
		0.817309,
		0.388498,
		0,
		0.828096,
		-0.178557,
		-0.531389,
		0,
		0.489895,
		-0.073247,
		-0.686133,
		1,
	},
	[1.18333333333] = {
		-0.364447,
		0.548062,
		-0.752865,
		0,
		0.425831,
		0.817072,
		0.388667,
		0,
		0.828158,
		-0.178945,
		-0.531161,
		0,
		0.490055,
		-0.073455,
		-0.685997,
		1,
	},
	[1.1] = {
		-0.366034,
		0.547506,
		-0.7525,
		0,
		0.424679,
		0.817783,
		0.388431,
		0,
		0.82805,
		-0.177392,
		-0.531851,
		0,
		0.489633,
		-0.072488,
		-0.6864,
		1,
	},
	[1.21666666667] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
	[1.23333333333] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
	[1.25] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
	[1.26666666667] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
	[1.28333333333] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
	[1.2] = {
		-0.363907,
		0.548357,
		-0.752912,
		0,
		0.426235,
		0.816772,
		0.388854,
		0,
		0.828188,
		-0.179411,
		-0.530958,
		0,
		0.490191,
		-0.073697,
		-0.685873,
		1,
	},
}

return spline_matrices
