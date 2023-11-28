﻿-- chunkname: @content/characters/player/human/first_person/animations/sabre/attack_stab_02.lua

local spline_matrices = {
	[0.00833333333333] = {
		0.920713,
		0.254664,
		-0.295693,
		0,
		-0.387437,
		0.505862,
		-0.770711,
		0,
		-0.046693,
		0.824166,
		0.56442,
		0,
		0.057296,
		0.664591,
		-0.18963,
		1
	},
	[0.0166666666667] = {
		0.777915,
		0.318007,
		-0.541959,
		0,
		-0.628276,
		0.378735,
		-0.67958,
		0,
		-0.010852,
		0.869155,
		0.49442,
		0,
		0.005256,
		0.615591,
		-0.177349,
		1
	},
	[0.025] = {
		0.580572,
		0.321309,
		-0.748129,
		0,
		-0.813694,
		0.261624,
		-0.51909,
		0,
		0.028941,
		0.910117,
		0.413339,
		0,
		-0.057551,
		0.549209,
		-0.162499,
		1
	},
	[0.0333333333333] = {
		0.329471,
		0.279262,
		-0.901921,
		0,
		-0.94239,
		0.155829,
		-0.296005,
		0,
		0.057882,
		0.947486,
		0.314515,
		0,
		-0.12698,
		0.476456,
		-0.147246,
		1
	},
	[0.0416666666667] = {
		0.085917,
		0.211051,
		-0.973692,
		0,
		-0.99418,
		0.081925,
		-0.069967,
		0,
		0.065003,
		0.974036,
		0.216861,
		0,
		-0.188428,
		0.399404,
		-0.134566,
		1
	},
	[0.0583333333333] = {
		-0.143525,
		0.111228,
		-0.983376,
		0,
		-0.988271,
		0.036262,
		0.148341,
		0,
		0.052159,
		0.993133,
		0.104719,
		0,
		-0.248895,
		0.224249,
		-0.118974,
		1
	},
	[0.05] = {
		-0.077987,
		0.150068,
		-0.985595,
		0,
		-0.99529,
		0.045374,
		0.085663,
		0,
		0.057576,
		0.987634,
		0.145822,
		0,
		-0.228308,
		0.319351,
		-0.125693,
		1
	},
	[0.0666666666667] = {
		-0.146982,
		0.086395,
		-0.985359,
		0,
		-0.987577,
		0.043151,
		0.151096,
		0,
		0.055573,
		0.995326,
		0.07898,
		0,
		-0.26276,
		0.111606,
		-0.112777,
		1
	},
	[0.075] = {
		-0.109847,
		0.07237,
		-0.99131,
		0,
		-0.991672,
		0.059477,
		0.11423,
		0,
		0.067227,
		0.995603,
		0.065234,
		0,
		-0.271476,
		-0.003021,
		-0.107408,
		1
	},
	[0.0833333333333] = {
		-0.051535,
		0.065805,
		-0.996501,
		0,
		-0.995097,
		0.080958,
		0.056809,
		0,
		0.084413,
		0.994543,
		0.06131,
		0,
		-0.276681,
		-0.104034,
		-0.103299,
		1
	},
	[0.0916666666667] = {
		0.007785,
		0.064286,
		-0.997901,
		0,
		-0.994597,
		0.10381,
		-0.001072,
		0,
		0.103523,
		0.992517,
		0.064747,
		0,
		-0.280142,
		-0.175861,
		-0.100797,
		1
	},
	[0] = {
		0.989864,
		0.140463,
		-0.020974,
		0,
		-0.10378,
		0.614579,
		-0.781999,
		0,
		-0.096952,
		0.776249,
		0.622927,
		0,
		0.085587,
		0.684717,
		-0.197434,
		1
	},
	[0.108333333333] = {
		0.080669,
		0.08607,
		-0.993018,
		0,
		-0.986802,
		0.147238,
		-0.067402,
		0,
		0.140408,
		0.985349,
		0.096812,
		0,
		-0.286147,
		-0.198598,
		-0.115266,
		1
	},
	[0.116666666667] = {
		0.093831,
		0.112294,
		-0.989235,
		0,
		-0.982697,
		0.169827,
		-0.073933,
		0,
		0.159697,
		0.979055,
		0.126286,
		0,
		-0.285485,
		-0.168282,
		-0.129126,
		1
	},
	[0.125] = {
		0.031171,
		0.128397,
		-0.991233,
		0,
		-0.983684,
		0.179742,
		-0.007651,
		0,
		0.177184,
		0.975298,
		0.131905,
		0,
		-0.254476,
		-0.050443,
		-0.122201,
		1
	},
	[0.133333333333] = {
		-0.033837,
		0.144011,
		-0.988997,
		0,
		-0.981375,
		0.182443,
		0.060142,
		0,
		0.189097,
		0.972613,
		0.135155,
		0,
		-0.22328,
		0.098007,
		-0.115533,
		1
	},
	[0.141666666667] = {
		-0.030213,
		0.168704,
		-0.985204,
		0,
		-0.980748,
		0.185242,
		0.061797,
		0,
		0.192927,
		0.968104,
		0.159859,
		0,
		-0.222837,
		0.197509,
		-0.136288,
		1
	},
	[0.158333333333] = {
		0.016016,
		0.161473,
		-0.986747,
		0,
		-0.989333,
		0.145468,
		0.007747,
		0,
		0.144791,
		0.976097,
		0.16208,
		0,
		-0.200553,
		0.379748,
		-0.148011,
		1
	},
	[0.15] = {
		-0.004699,
		0.182101,
		-0.983269,
		0,
		-0.983316,
		0.177964,
		0.037658,
		0,
		0.181844,
		0.967041,
		0.178227,
		0,
		-0.224396,
		0.286361,
		-0.158527,
		1
	},
	[0.166666666667] = {
		0.04611,
		0.127017,
		-0.990828,
		0,
		-0.994229,
		0.10202,
		-0.03319,
		0,
		0.096869,
		0.98664,
		0.130988,
		0,
		-0.153546,
		0.466869,
		-0.122726,
		1
	},
	[0.175] = {
		0.094434,
		0.086991,
		-0.991723,
		0,
		-0.994535,
		0.052807,
		-0.09007,
		0,
		0.044534,
		0.994809,
		0.091502,
		0,
		-0.089777,
		0.556318,
		-0.075592,
		1
	},
	[0.183333333333] = {
		0.14645,
		0.054991,
		-0.987688,
		0,
		-0.989211,
		0.011901,
		-0.146014,
		0,
		0.003725,
		0.998416,
		0.056141,
		0,
		-0.046146,
		0.605561,
		-0.044593,
		1
	},
	[0.191666666667] = {
		0.188579,
		0.045064,
		-0.981024,
		0,
		-0.982011,
		-0.001158,
		-0.188822,
		0,
		-0.009645,
		0.998983,
		0.044035,
		0,
		-0.043114,
		0.605265,
		-0.047532,
		1
	},
	[0.1] = {
		0.046809,
		0.066713,
		-0.996674,
		0,
		-0.991546,
		0.12398,
		-0.038269,
		0,
		0.121015,
		0.99004,
		0.071952,
		0,
		-0.283771,
		-0.202975,
		-0.100138,
		1
	},
	[0.208333333333] = {
		0.260929,
		0.049227,
		-0.964102,
		0,
		-0.965348,
		0.008779,
		-0.260818,
		0,
		-0.004375,
		0.998749,
		0.049812,
		0,
		-0.04124,
		0.604594,
		-0.050982,
		1
	},
	[0.216666666667] = {
		0.291531,
		0.051433,
		-0.955178,
		0,
		-0.95656,
		0.013953,
		-0.291201,
		0,
		-0.00165,
		0.998579,
		0.053266,
		0,
		-0.040949,
		0.604002,
		-0.052601,
		1
	},
	[0.225] = {
		0.319233,
		0.051114,
		-0.946297,
		0,
		-0.947673,
		0.01449,
		-0.318914,
		0,
		-0.002589,
		0.998588,
		0.053065,
		0,
		-0.040563,
		0.603194,
		-0.054436,
		1
	},
	[0.233333333333] = {
		0.344817,
		0.050926,
		-0.937287,
		0,
		-0.938663,
		0.014986,
		-0.344509,
		0,
		-0.003498,
		0.99859,
		0.05297,
		0,
		-0.040306,
		0.60229,
		-0.056184,
		1
	},
	[0.241666666667] = {
		0.368441,
		0.050864,
		-0.928259,
		0,
		-0.929641,
		0.015488,
		-0.368141,
		0,
		-0.004348,
		0.998585,
		0.052992,
		0,
		-0.040143,
		0.601316,
		-0.057859,
		1
	},
	[0.258333333333] = {
		0.410414,
		0.051091,
		-0.910467,
		0,
		-0.911881,
		0.016694,
		-0.410115,
		0,
		-0.005754,
		0.998554,
		0.053441,
		0,
		-0.03997,
		0.599269,
		-0.061049,
		1
	},
	[0.25] = {
		0.390257,
		0.050922,
		-0.919297,
		0,
		-0.920692,
		0.016042,
		-0.389961,
		0,
		-0.00511,
		0.998574,
		0.053144,
		0,
		-0.040043,
		0.6003,
		-0.059476,
		1
	},
	[0.266666666667] = {
		0.429054,
		0.051362,
		-0.901818,
		0,
		-0.903257,
		0.017488,
		-0.428743,
		0,
		-0.00625,
		0.998527,
		0.053896,
		0,
		-0.039889,
		0.59825,
		-0.062597,
		1
	},
	[0.275] = {
		0.446313,
		0.051723,
		-0.893381,
		0,
		-0.894853,
		0.018467,
		-0.445979,
		0,
		-0.006569,
		0.998491,
		0.054526,
		0,
		-0.039762,
		0.59727,
		-0.064133,
		1
	},
	[0.283333333333] = {
		0.462323,
		0.05216,
		-0.885176,
		0,
		-0.886686,
		0.019674,
		-0.461953,
		0,
		-0.00668,
		0.998445,
		0.055346,
		0,
		-0.039552,
		0.596354,
		-0.065676,
		1
	},
	[0.291666666667] = {
		0.477226,
		0.052657,
		-0.877201,
		0,
		-0.878756,
		0.021144,
		-0.476803,
		0,
		-0.006559,
		0.998389,
		0.056363,
		0,
		-0.039295,
		0.595431,
		-0.067201,
		1
	},
	[0.2] = {
		0.226677,
		0.045246,
		-0.972918,
		0,
		-0.973923,
		0.000693,
		-0.226879,
		0,
		-0.009591,
		0.998976,
		0.044223,
		0,
		-0.041711,
		0.604969,
		-0.049485,
		1
	},
	[0.308333333333] = {
		0.504086,
		0.053782,
		-0.861977,
		0,
		-0.863634,
		0.024775,
		-0.50351,
		0,
		-0.005724,
		0.998245,
		0.058937,
		0,
		-0.038808,
		0.593373,
		-0.07011,
		1
	},
	[0.316666666667] = {
		0.516173,
		0.054403,
		-0.854755,
		0,
		-0.856469,
		0.026857,
		-0.515499,
		0,
		-0.005088,
		0.998158,
		0.060458,
		0,
		-0.038568,
		0.592284,
		-0.071503,
		1
	},
	[0.325] = {
		0.527447,
		0.05506,
		-0.847802,
		0,
		-0.849577,
		0.029064,
		-0.526664,
		0,
		-0.004357,
		0.99806,
		0.062107,
		0,
		-0.038321,
		0.591187,
		-0.072862,
		1
	},
	[0.333333333333] = {
		0.537966,
		0.055752,
		-0.841121,
		0,
		-0.842959,
		0.031356,
		-0.537063,
		0,
		-0.003568,
		0.997952,
		0.063865,
		0,
		-0.038063,
		0.590106,
		-0.07419,
		1
	},
	[0.341666666667] = {
		0.547788,
		0.056479,
		-0.834709,
		0,
		-0.836613,
		0.033692,
		-0.546758,
		0,
		-0.002757,
		0.997835,
		0.065707,
		0,
		-0.037786,
		0.589064,
		-0.075494,
		1
	},
	[0.358333333333] = {
		0.565553,
		0.058045,
		-0.822667,
		0,
		-0.824711,
		0.038338,
		-0.564253,
		0,
		-0.001213,
		0.997578,
		0.069553,
		0,
		-0.03715,
		0.587193,
		-0.078046,
		1
	},
	[0.35] = {
		0.556966,
		0.057243,
		-0.82856,
		0,
		-0.830533,
		0.036033,
		-0.555803,
		0,
		-0.001961,
		0.99771,
		0.067611,
		0,
		-0.037484,
		0.588085,
		-0.076777,
		1
	},
	[0.366666666667] = {
		0.573599,
		0.058888,
		-0.817017,
		0,
		-0.819136,
		0.040567,
		-0.572163,
		0,
		-0.000549,
		0.99744,
		0.071507,
		0,
		-0.036777,
		0.586412,
		-0.079306,
		1
	},
	[0.375] = {
		0.581152,
		0.059775,
		-0.811596,
		0,
		-0.813795,
		0.042681,
		-0.579583,
		0,
		-5e-06,
		0.997299,
		0.073448,
		0,
		-0.036358,
		0.585764,
		-0.080561,
		1
	},
	[0.383333333333] = {
		0.58826,
		0.060707,
		-0.80639,
		0,
		-0.808672,
		0.044638,
		-0.586564,
		0,
		0.000386,
		0.997157,
		0.075351,
		0,
		-0.035885,
		0.585275,
		-0.081817,
		1
	},
	[0.391666666667] = {
		0.594967,
		0.06169,
		-0.801379,
		0,
		-0.80375,
		0.046397,
		-0.593156,
		0,
		0.00059,
		0.997016,
		0.077188,
		0,
		-0.03535,
		0.584968,
		-0.08308,
		1
	},
	[0.3] = {
		0.491125,
		0.053199,
		-0.869463,
		0,
		-0.871067,
		0.022858,
		-0.490633,
		0,
		-0.006227,
		0.998322,
		0.057566,
		0,
		-0.039049,
		0.59443,
		-0.068677,
		1
	},
	[0.408333333333] = {
		0.608043,
		0.063711,
		-0.791343,
		0,
		-0.793904,
		0.04945,
		-0.606029,
		0,
		0.000522,
		0.996742,
		0.080648,
		0,
		-0.03401,
		0.584912,
		-0.085685,
		1
	},
	[0.416666666667] = {
		0.615448,
		0.064589,
		-0.785527,
		0,
		-0.788177,
		0.051171,
		-0.613317,
		0,
		0.000583,
		0.996599,
		0.082401,
		0,
		-0.033109,
		0.585024,
		-0.087086,
		1
	},
	[0.425] = {
		0.62294,
		0.065438,
		-0.779528,
		0,
		-0.78227,
		0.052946,
		-0.620686,
		0,
		0.000656,
		0.996451,
		0.084172,
		0,
		-0.03208,
		0.585181,
		-0.08853,
		1
	},
	[0.433333333333] = {
		0.629943,
		0.066343,
		-0.773802,
		0,
		-0.776641,
		0.054637,
		-0.62757,
		0,
		0.000644,
		0.9963,
		0.085943,
		0,
		-0.030962,
		0.585367,
		-0.089987,
		1
	},
	[0.441666666667] = {
		0.6359,
		0.067392,
		-0.768824,
		0,
		-0.771771,
		0.05611,
		-0.63342,
		0,
		0.000452,
		0.996148,
		0.087692,
		0,
		-0.029797,
		0.585561,
		-0.091427,
		1
	},
	[0.458333333333] = {
		0.642489,
		0.070291,
		-0.763064,
		0,
		-0.766294,
		0.057852,
		-0.63988,
		0,
		-0.000833,
		0.995848,
		0.091033,
		0,
		-0.027487,
		0.585901,
		-0.094135,
		1
	},
	[0.45] = {
		0.640263,
		0.068676,
		-0.76508,
		0,
		-0.768156,
		0.057228,
		-0.6377,
		0,
		-1.1e-05,
		0.995996,
		0.089395,
		0,
		-0.028625,
		0.585745,
		-0.092819,
		1
	},
	[0.466666666667] = {
		0.642029,
		0.072327,
		-0.763261,
		0,
		-0.766678,
		0.057839,
		-0.639422,
		0,
		-0.002101,
		0.995702,
		0.092586,
		0,
		-0.026424,
		0.586008,
		-0.095344,
		1
	},
	[0.475] = {
		0.638308,
		0.074872,
		-0.766131,
		0,
		-0.769771,
		0.057039,
		-0.635767,
		0,
		-0.003902,
		0.995561,
		0.094043,
		0,
		-0.025476,
		0.586048,
		-0.096417,
		1
	},
	[0.483333333333] = {
		0.630711,
		0.078,
		-0.772087,
		0,
		-0.775992,
		0.055292,
		-0.628315,
		0,
		-0.006319,
		0.995419,
		0.0954,
		0,
		-0.024676,
		0.586002,
		-0.097322,
		1
	},
	[0.491666666667] = {
		0.619036,
		0.082747,
		-0.780992,
		0,
		-0.785273,
		0.050153,
		-0.617115,
		0,
		-0.011896,
		0.995308,
		0.096026,
		0,
		-0.024244,
		0.585742,
		-0.098017,
		1
	},
	[0.4] = {
		0.601317,
		0.062726,
		-0.796544,
		0,
		-0.79901,
		0.04792,
		-0.599405,
		0,
		0.000572,
		0.99688,
		0.078933,
		0,
		-0.034746,
		0.584866,
		-0.084356,
		1
	},
	[0.508333333333] = {
		0.575441,
		0.094528,
		-0.812362,
		0,
		-0.817429,
		0.034866,
		-0.574973,
		0,
		-0.026027,
		0.994912,
		0.097333,
		0,
		-0.024061,
		0.584863,
		-0.099487,
		1
	},
	[0.516666666667] = {
		0.536934,
		0.098207,
		-0.837889,
		0,
		-0.843248,
		0.032808,
		-0.536523,
		0,
		-0.025201,
		0.994625,
		0.100429,
		0,
		-0.023578,
		0.58466,
		-0.100797,
		1
	},
	[0.525] = {
		0.477909,
		0.102289,
		-0.872433,
		0,
		-0.878239,
		0.036104,
		-0.476857,
		0,
		-0.017279,
		0.994099,
		0.107089,
		0,
		-0.027507,
		0.577741,
		-0.101962,
		1
	},
	[0.533333333333] = {
		0.396363,
		0.109144,
		-0.911583,
		0,
		-0.91808,
		0.041639,
		-0.394202,
		0,
		-0.005068,
		0.993153,
		0.116707,
		0,
		-0.039397,
		0.558963,
		-0.102488,
		1
	},
	[0.541666666667] = {
		0.298905,
		0.117435,
		-0.947029,
		0,
		-0.954215,
		0.048635,
		-0.295142,
		0,
		0.011399,
		0.991889,
		0.126595,
		0,
		-0.057066,
		0.531385,
		-0.102903,
		1
	},
	[0.558333333333] = {
		0.093454,
		0.132067,
		-0.986826,
		0,
		-0.994178,
		0.06577,
		-0.085349,
		0,
		0.053632,
		0.989056,
		0.137444,
		0,
		-0.10218,
		0.462139,
		-0.105458,
		1
	},
	[0.55] = {
		0.194442,
		0.125641,
		-0.972834,
		0,
		-0.980411,
		0.056661,
		-0.188638,
		0,
		0.031421,
		0.990456,
		0.134197,
		0,
		-0.07856,
		0.498084,
		-0.103748,
		1
	},
	[0.566666666667] = {
		0.006544,
		0.134911,
		-0.990836,
		0,
		-0.997063,
		0.07649,
		0.00383,
		0,
		0.076306,
		0.987901,
		0.135015,
		0,
		-0.126428,
		0.426663,
		-0.108286,
		1
	},
	[0.575] = {
		-0.056752,
		0.132244,
		-0.989591,
		0,
		-0.993584,
		0.089637,
		0.06896,
		0,
		0.097824,
		0.987156,
		0.126309,
		0,
		-0.149886,
		0.394781,
		-0.112288,
		1
	},
	[0.583333333333] = {
		-0.088105,
		0.121829,
		-0.988633,
		0,
		-0.989204,
		0.105972,
		0.101215,
		0,
		0.117099,
		0.986878,
		0.111177,
		0,
		-0.171097,
		0.369621,
		-0.117409,
		1
	},
	[0.591666666667] = {
		-0.103407,
		0.126328,
		-0.986584,
		0,
		-0.984475,
		0.12844,
		0.119632,
		0,
		0.14183,
		0.983638,
		0.111085,
		0,
		-0.190542,
		0.351741,
		-0.120529,
		1
	},
	[0.5] = {
		0.601626,
		0.088857,
		-0.79382,
		0,
		-0.798527,
		0.042,
		-0.600492,
		0,
		-0.020017,
		0.995159,
		0.096223,
		0,
		-0.024154,
		0.585293,
		-0.098652,
		1
	},
	[0.608333333333] = {
		-0.066125,
		0.132389,
		-0.98899,
		0,
		-0.978291,
		0.186492,
		0.090374,
		0,
		0.196403,
		0.973496,
		0.117183,
		0,
		-0.230787,
		0.33147,
		-0.124949,
		1
	},
	[0.616666666667] = {
		-0.045509,
		0.134412,
		-0.98988,
		0,
		-0.975793,
		0.206202,
		0.072861,
		0,
		0.213908,
		0.969234,
		0.121774,
		0,
		-0.248674,
		0.324146,
		-0.126943,
		1
	},
	[0.625] = {
		-0.038388,
		0.129222,
		-0.990872,
		0,
		-0.973536,
		0.218725,
		0.066241,
		0,
		0.225288,
		0.967192,
		0.117406,
		0,
		-0.260964,
		0.320134,
		-0.128921,
		1
	},
	[0.633333333333] = {
		-0.014259,
		0.138677,
		-0.990235,
		0,
		-0.97742,
		0.206874,
		0.043046,
		0,
		0.210823,
		0.968489,
		0.132596,
		0,
		-0.267571,
		0.318738,
		-0.130087,
		1
	},
	[0.641666666667] = {
		0.051566,
		0.183494,
		-0.981667,
		0,
		-0.989839,
		0.139822,
		-0.025859,
		0,
		0.132514,
		0.973026,
		0.188839,
		0,
		-0.275281,
		0.321658,
		-0.13125,
		1
	},
	[0.658333333333] = {
		0.208341,
		0.42043,
		-0.883082,
		0,
		-0.97692,
		0.045943,
		-0.208606,
		0,
		-0.047132,
		0.906161,
		0.420298,
		0,
		-0.276596,
		0.352522,
		-0.129519,
		1
	},
	[0.65] = {
		0.131165,
		0.271724,
		-0.953395,
		0,
		-0.990716,
		0.070606,
		-0.116176,
		0,
		0.035748,
		0.959782,
		0.278462,
		0,
		-0.279176,
		0.334292,
		-0.131554,
		1
	},
	[0.666666666667] = {
		0.276859,
		0.603034,
		-0.74813,
		0,
		-0.950213,
		0.055963,
		-0.306534,
		0,
		-0.142983,
		0.79575,
		0.588505,
		0,
		-0.272603,
		0.371218,
		-0.128408,
		1
	},
	[0.675] = {
		0.323242,
		0.768962,
		-0.551554,
		0,
		-0.912362,
		0.09851,
		-0.397355,
		0,
		-0.251217,
		0.631659,
		0.733414,
		0,
		-0.265858,
		0.3893,
		-0.130843,
		1
	},
	[0.683333333333] = {
		0.341786,
		0.879772,
		-0.33043,
		0,
		-0.867425,
		0.16004,
		-0.471128,
		0,
		-0.361603,
		0.447649,
		0.817835,
		0,
		-0.254691,
		0.407006,
		-0.137432,
		1
	},
	[0.691666666667] = {
		0.339533,
		0.93045,
		-0.137768,
		0,
		-0.818828,
		0.220314,
		-0.530077,
		0,
		-0.462858,
		0.292787,
		0.836683,
		0,
		-0.237785,
		0.424216,
		-0.146395,
		1
	},
	[0.6] = {
		-0.090769,
		0.129959,
		-0.987356,
		0,
		-0.981198,
		0.1579,
		0.110986,
		0,
		0.170327,
		0.978866,
		0.113183,
		0,
		-0.210931,
		0.339848,
		-0.122937,
		1
	},
	[0.708333333333] = {
		0.331821,
		0.942804,
		0.031851,
		0,
		-0.704878,
		0.270239,
		-0.655834,
		0,
		-0.62693,
		0.195168,
		0.754233,
		0,
		-0.182417,
		0.451235,
		-0.162087,
		1
	},
	[0.716666666667] = {
		0.340327,
		0.939727,
		0.03304,
		0,
		-0.631947,
		0.2546,
		-0.731999,
		0,
		-0.696291,
		0.228239,
		0.680504,
		0,
		-0.141384,
		0.460647,
		-0.167975,
		1
	},
	[0.725] = {
		0.36203,
		0.932166,
		-7e-05,
		0,
		-0.547071,
		0.212409,
		-0.809689,
		0,
		-0.75475,
		0.29317,
		0.58686,
		0,
		-0.093711,
		0.467422,
		-0.173268,
		1
	},
	[0.733333333333] = {
		0.398744,
		0.915441,
		-0.054502,
		0,
		-0.452337,
		0.144633,
		-0.880041,
		0,
		-0.797743,
		0.375564,
		0.471759,
		0,
		-0.041698,
		0.471598,
		-0.178489,
		1
	},
	[0.741666666667] = {
		0.44937,
		0.885728,
		-0.116415,
		0,
		-0.352126,
		0.055853,
		-0.934285,
		0,
		-0.82102,
		0.460833,
		0.336986,
		0,
		0.012341,
		0.473321,
		-0.183954,
		1
	},
	[0.758333333333] = {
		0.57357,
		0.791669,
		-0.21042,
		0,
		-0.156266,
		-0.146411,
		-0.976803,
		0,
		-0.804113,
		0.593147,
		0.039734,
		0,
		0.116684,
		0.470971,
		-0.195742,
		1
	},
	[0.75] = {
		0.509756,
		0.842918,
		-0.172156,
		0,
		-0.251923,
		-0.045085,
		-0.966697,
		0,
		-0.822608,
		0.536149,
		0.189368,
		0,
		0.065988,
		0.472912,
		-0.189733,
		1
	},
	[0.766666666667] = {
		0.633872,
		0.740321,
		-0.223899,
		0,
		-0.066859,
		-0.235953,
		-0.969462,
		0,
		-0.770543,
		0.629484,
		-0.100067,
		0,
		0.16176,
		0.468422,
		-0.201908,
		1
	},
	[0.775] = {
		0.684325,
		0.698561,
		-0.209075,
		0,
		0.018204,
		-0.303004,
		-0.952815,
		0,
		-0.72895,
		0.648229,
		-0.22007,
		0,
		0.198532,
		0.466475,
		-0.208295,
		1
	},
	[0.783333333333] = {
		0.719159,
		0.675172,
		-0.164174,
		0,
		0.103952,
		-0.338158,
		-0.93533,
		0,
		-0.687026,
		0.655585,
		-0.313375,
		0,
		0.224378,
		0.466544,
		-0.215145,
		1
	},
	[0.791666666667] = {
		0.73977,
		0.666513,
		-0.092203,
		0,
		0.198238,
		-0.346843,
		-0.916734,
		0,
		-0.642995,
		0.659894,
		-0.388712,
		0,
		0.243807,
		0.468381,
		-0.223053,
		1
	},
	[0.7] = {
		0.332413,
		0.942994,
		-0.016276,
		0,
		-0.766147,
		0.259929,
		-0.587754,
		0,
		-0.550018,
		0.207847,
		0.808876,
		0,
		-0.21444,
		0.439284,
		-0.155047,
		1
	},
	[0.808333333333] = {
		0.740903,
		0.661656,
		0.115215,
		0,
		0.420769,
		-0.32359,
		-0.847492,
		0,
		-0.523466,
		0.676388,
		-0.518153,
		0,
		0.283071,
		0.474061,
		-0.241652,
		1
	},
	[0.816666666667] = {
		0.710367,
		0.659669,
		0.245391,
		0,
		0.544102,
		-0.293535,
		-0.785996,
		0,
		-0.446466,
		0.691863,
		-0.567444,
		0,
		0.303419,
		0.478264,
		-0.251004,
		1
	},
	[0.825] = {
		0.651568,
		0.653086,
		0.385926,
		0,
		0.66819,
		-0.253248,
		-0.699562,
		0,
		-0.359139,
		0.713684,
		-0.601394,
		0,
		0.324262,
		0.48357,
		-0.25924,
		1
	},
	[0.833333333333] = {
		0.560931,
		0.637998,
		0.527556,
		0,
		0.784338,
		-0.205654,
		-0.585252,
		0,
		-0.264896,
		0.742068,
		-0.615764,
		0,
		0.345222,
		0.490007,
		-0.265426,
		1
	},
	[0.841666666667] = {
		0.438865,
		0.611259,
		0.658605,
		0,
		0.882442,
		-0.155018,
		-0.444146,
		0,
		-0.169393,
		0.776101,
		-0.607432,
		0,
		0.365551,
		0.497437,
		-0.268792,
		1
	},
	[0.858333333333] = {
		0.128442,
		0.519868,
		0.844535,
		0,
		0.991713,
		-0.064932,
		-0.110856,
		0,
		-0.002794,
		0.851775,
		-0.5239,
		0,
		0.400317,
		0.513832,
		-0.266129,
		1
	},
	[0.85] = {
		0.291126,
		0.57151,
		0.767217,
		0,
		0.953356,
		-0.106471,
		-0.282446,
		0,
		-0.079735,
		0.813659,
		-0.575849,
		0,
		0.38425,
		0.505534,
		-0.268968,
		1
	},
	[0.866666666667] = {
		-0.035888,
		0.459771,
		0.887312,
		0,
		0.997747,
		-0.033873,
		0.057906,
		0,
		0.05668,
		0.887391,
		-0.45752,
		0,
		0.41305,
		0.521833,
		-0.260957,
		1
	},
	[0.875] = {
		-0.189373,
		0.395983,
		0.898518,
		0,
		0.977084,
		-0.014578,
		0.212356,
		0,
		0.097188,
		0.918142,
		-0.384147,
		0,
		0.422239,
		0.529141,
		-0.254414,
		1
	},
	[0.883333333333] = {
		-0.322966,
		0.333292,
		0.885782,
		0,
		0.938724,
		-0.006226,
		0.344612,
		0,
		0.120371,
		0.942803,
		-0.310859,
		0,
		0.42817,
		0.535525,
		-0.24745,
		1
	},
	[0.891666666667] = {
		-0.431922,
		0.275549,
		0.858787,
		0,
		0.892501,
		-0.006603,
		0.450997,
		0,
		0.129942,
		0.961264,
		-0.243076,
		0,
		0.431467,
		0.54093,
		-0.240788,
		1
	},
	[0.8] = {
		0.748745,
		0.662857,
		0.001529,
		0,
		0.304315,
		-0.341695,
		-0.889178,
		0,
		-0.588875,
		0.666232,
		-0.45756,
		0,
		0.263264,
		0.470826,
		-0.232082,
		1
	},
	[0.908333333333] = {
		-0.573301,
		0.184016,
		0.798414,
		0,
		0.809582,
		-0.02276,
		0.586566,
		0,
		0.12611,
		0.98266,
		-0.135927,
		0,
		0.433197,
		0.549148,
		-0.229834,
		1
	},
	[0.916666666667] = {
		-0.608081,
		0.152358,
		0.779117,
		0,
		0.784644,
		-0.033884,
		0.61902,
		0,
		0.120712,
		0.987744,
		-0.098943,
		0,
		0.433009,
		0.552231,
		-0.225737,
		1
	},
	[0.925] = {
		-0.626494,
		0.126289,
		0.769127,
		0,
		0.770989,
		-0.044388,
		0.635299,
		0,
		0.114372,
		0.991,
		-0.069559,
		0,
		0.431611,
		0.555024,
		-0.222291,
		1
	},
	[0.933333333333] = {
		-0.635753,
		0.10118,
		0.765233,
		0,
		0.764621,
		-0.053211,
		0.64228,
		0,
		0.105704,
		0.993444,
		-0.043535,
		0,
		0.428095,
		0.557819,
		-0.219201,
		1
	},
	[0.941666666667] = {
		-0.636816,
		0.076656,
		0.767196,
		0,
		0.765104,
		-0.060152,
		0.64109,
		0,
		0.095292,
		0.995241,
		-0.020344,
		0,
		0.422666,
		0.56065,
		-0.21641,
		1
	},
	[0.958333333333] = {
		-0.616448,
		0.028346,
		0.786885,
		0,
		0.784209,
		-0.067716,
		0.616791,
		0,
		0.070769,
		0.997302,
		0.019514,
		0,
		0.406751,
		0.5665,
		-0.211562,
		1
	},
	[0.95] = {
		-0.630277,
		0.052441,
		0.774597,
		0,
		0.771862,
		-0.065042,
		0.632455,
		0,
		0.083548,
		0.996504,
		0.000517,
		0,
		0.415501,
		0.563538,
		-0.213874,
		1
	},
	[0.966666666667] = {
		-0.595428,
		0.00427,
		0.803397,
		0,
		0.801371,
		-0.068013,
		0.594288,
		0,
		0.057178,
		0.997675,
		0.037075,
		0,
		0.396552,
		0.569548,
		-0.209447,
		1
	},
	[0.975] = {
		-0.567176,
		-0.019809,
		0.823358,
		0,
		0.822476,
		-0.065764,
		0.564986,
		0,
		0.042956,
		0.997639,
		0.053592,
		0,
		0.385027,
		0.572689,
		-0.207512,
		1
	},
	[0.983333333333] = {
		-0.53157,
		-0.043825,
		0.84588,
		0,
		0.846543,
		-0.060806,
		0.528837,
		0,
		0.028258,
		0.997187,
		0.069422,
		0,
		0.372292,
		0.575923,
		-0.205738,
		1
	},
	[0.991666666667] = {
		-0.488477,
		-0.067632,
		0.869952,
		0,
		0.872476,
		-0.052986,
		0.485776,
		0,
		0.013241,
		0.996302,
		0.08489,
		0,
		0.358453,
		0.57925,
		-0.204107,
		1
	},
	[0.9] = {
		-0.515066,
		0.225314,
		0.827007,
		0,
		0.847172,
		-0.012976,
		0.53116,
		0,
		0.130409,
		0.9742,
		-0.184196,
		0,
		0.432894,
		0.545428,
		-0.234857,
		1
	},
	[1.00833333333] = {
		-0.379646,
		-0.113629,
		0.918127,
		0,
		0.924974,
		-0.028308,
		0.378974,
		0,
		-0.017072,
		0.99312,
		0.115851,
		0,
		0.327897,
		0.586146,
		-0.201181,
		1
	},
	[1.01666666667] = {
		-0.314197,
		-0.135146,
		0.939689,
		0,
		0.948819,
		-0.011363,
		0.315616,
		0,
		-0.031977,
		0.990761,
		0.131799,
		0,
		0.3114,
		0.589687,
		-0.199822,
		1
	},
	[1.025] = {
		-0.241968,
		-0.155134,
		0.957802,
		0,
		0.969174,
		0.008577,
		0.24623,
		0,
		-0.046414,
		0.987856,
		0.148277,
		0,
		0.29425,
		0.593262,
		-0.19848,
		1
	},
	[1.03333333333] = {
		-0.163747,
		-0.173158,
		0.971186,
		0,
		0.984668,
		0.031323,
		0.171605,
		0,
		-0.060135,
		0.984396,
		0.165375,
		0,
		0.276586,
		0.596844,
		-0.197106,
		1
	},
	[1.04166666667] = {
		-0.080637,
		-0.188797,
		0.9787,
		0,
		0.994075,
		0.05657,
		0.092817,
		0,
		-0.072889,
		0.980385,
		0.183117,
		0,
		0.258561,
		0.600404,
		-0.195653,
		1
	},
	[1.05833333333] = {
		0.094434,
		-0.211532,
		0.972798,
		0,
		0.991031,
		0.112785,
		-0.07168,
		0,
		-0.094554,
		0.970842,
		0.220286,
		0,
		0.222147,
		0.607334,
		-0.192323,
		1
	},
	[1.05] = {
		0.005967,
		-0.20168,
		0.979433,
		0,
		0.996411,
		0.083899,
		0.011206,
		0,
		-0.084433,
		0.975851,
		0.201457,
		0,
		0.24035,
		0.603911,
		-0.194071,
		1
	},
	[1.06666666667] = {
		0.182991,
		-0.218202,
		0.958594,
		0,
		0.977695,
		0.142633,
		-0.15417,
		0,
		-0.103087,
		0.965424,
		0.239436,
		0,
		0.204166,
		0.610645,
		-0.19038,
		1
	},
	[1.075] = {
		0.269837,
		-0.221688,
		0.937039,
		0,
		0.956611,
		0.172811,
		-0.234589,
		0,
		-0.109925,
		0.959683,
		0.2587,
		0,
		0.186637,
		0.613822,
		-0.188232,
		1
	},
	[1.08333333333] = {
		0.35327,
		-0.222144,
		0.908764,
		0,
		0.928422,
		0.202696,
		-0.311364,
		0,
		-0.115035,
		0.953712,
		0.277849,
		0,
		0.169798,
		0.616849,
		-0.185892,
		1
	},
	[1.09166666667] = {
		0.431802,
		-0.219872,
		0.874759,
		0,
		0.894156,
		0.231717,
		-0.383135,
		0,
		-0.118456,
		0.947609,
		0.296656,
		0,
		0.153891,
		0.619717,
		-0.183391,
		1
	},
	{
		-0.43782,
		-0.091002,
		0.894445,
		0,
		0.89906,
		-0.042179,
		0.435788,
		0,
		-0.00193,
		0.994957,
		0.100283,
		0,
		0.343619,
		0.582662,
		-0.202598,
		1
	},
	[1.10833333333] = {
		0.569757,
		-0.20895,
		0.794806,
		0,
		0.812899,
		0.285352,
		-0.50771,
		0,
		-0.120713,
		0.935368,
		0.332437,
		0,
		0.125823,
		0.624981,
		-0.178142,
		1
	},
	[1.11666666667] = {
		0.627852,
		-0.201402,
		0.751824,
		0,
		0.76904,
		0.309343,
		-0.55936,
		0,
		-0.119915,
		0.929378,
		0.349108,
		0,
		0.114111,
		0.627397,
		-0.175549,
		1
	},
	[1.125] = {
		0.678367,
		-0.19326,
		0.708851,
		0,
		0.725165,
		0.331234,
		-0.603672,
		0,
		-0.11813,
		0.923545,
		0.364843,
		0,
		0.104226,
		0.629691,
		-0.173098,
		1
	},
	[1.13333333333] = {
		0.721407,
		-0.185124,
		0.667309,
		0,
		0.682795,
		0.350994,
		-0.640776,
		0,
		-0.115598,
		0.917896,
		0.379611,
		0,
		0.09636,
		0.631881,
		-0.170887,
		1
	},
	[1.14166666667] = {
		0.75727,
		-0.177577,
		0.628497,
		0,
		0.643329,
		0.368671,
		-0.670977,
		0,
		-0.112558,
		0.912441,
		0.393424,
		0,
		0.090691,
		0.633991,
		-0.169012,
		1
	},
	[1.15833333333] = {
		0.811462,
		-0.164821,
		0.560682,
		0,
		0.574736,
		0.398871,
		-0.714549,
		0,
		-0.105867,
		0.902073,
		0.418397,
		0,
		0.085365,
		0.638038,
		-0.166495,
		1
	},
	[1.15] = {
		0.786371,
		-0.171167,
		0.593567,
		0,
		0.608018,
		0.384367,
		-0.694677,
		0,
		-0.109242,
		0.907174,
		0.406328,
		0,
		0.08739,
		0.63604,
		-0.167566,
		1
	},
	[1.16666666667] = {
		0.834995,
		-0.157177,
		0.527332,
		0,
		0.540625,
		0.412865,
		-0.732985,
		0,
		-0.102509,
		0.897127,
		0.429714,
		0,
		0.083416,
		0.639977,
		-0.16567,
		1
	},
	[1.175] = {
		0.856966,
		-0.148326,
		0.493568,
		0,
		0.505742,
		0.426315,
		-0.749987,
		0,
		-0.099173,
		0.892331,
		0.440352,
		0,
		0.081541,
		0.641857,
		-0.165068,
		1
	},
	[1.18333333333] = {
		0.877362,
		-0.138357,
		0.45945,
		0,
		0.470156,
		0.439185,
		-0.765552,
		0,
		-0.095864,
		0.887679,
		0.450373,
		0,
		0.079743,
		0.643677,
		-0.164669,
		1
	},
	[1.19166666667] = {
		0.896166,
		-0.127362,
		0.425048,
		0,
		0.433953,
		0.451441,
		-0.77967,
		0,
		-0.092584,
		0.883165,
		0.459835,
		0,
		0.078023,
		0.645436,
		-0.164451,
		1
	},
	[1.1] = {
		0.504245,
		-0.2153,
		0.836291,
		0,
		0.855141,
		0.259393,
		-0.448831,
		0,
		-0.120295,
		0.941467,
		0.31491,
		0,
		0.139155,
		0.622425,
		-0.180784,
		1
	},
	[1.20833333333] = {
		0.928927,
		-0.102665,
		0.355744,
		0,
		0.360107,
		0.473984,
		-0.803531,
		0,
		-0.086123,
		0.874528,
		0.477267,
		0,
		0.074829,
		0.64877,
		-0.16448,
		1
	},
	[1.21666666667] = {
		0.942856,
		-0.08916,
		0.32105,
		0,
		0.322711,
		0.484215,
		-0.813261,
		0,
		-0.082947,
		0.870395,
		0.485317,
		0,
		0.073361,
		0.650343,
		-0.164691,
		1
	},
	[1.225] = {
		0.955143,
		-0.075022,
		0.286486,
		0,
		0.285189,
		0.49372,
		-0.821528,
		0,
		-0.079811,
		0.866379,
		0.492969,
		0,
		0.071985,
		0.651855,
		-0.165009,
		1
	},
	[1.23333333333] = {
		0.965794,
		-0.060364,
		0.252187,
		0,
		0.247703,
		0.502486,
		-0.828342,
		0,
		-0.076718,
		0.862475,
		0.500251,
		0,
		0.070704,
		0.653305,
		-0.16542,
		1
	},
	[1.24166666667] = {
		0.97483,
		-0.045302,
		0.2183,
		0,
		0.210427,
		0.510505,
		-0.833729,
		0,
		-0.073673,
		0.85868,
		0.507189,
		0,
		0.069523,
		0.654696,
		-0.165908,
		1
	},
	[1.25833333333] = {
		0.988215,
		-0.014459,
		0.152386,
		0,
		0.137262,
		0.524317,
		-0.840387,
		0,
		-0.067747,
		0.8514,
		0.520123,
		0,
		0.067478,
		0.657307,
		-0.167066,
		1
	},
	[1.25] = {
		0.982286,
		-0.029958,
		0.184979,
		0,
		0.173548,
		0.517779,
		-0.837727,
		0,
		-0.070681,
		0.85499,
		0.513806,
		0,
		0.068447,
		0.656029,
		-0.166461,
		1
	},
	[1.26666666667] = {
		0.99269,
		0.001064,
		0.120691,
		0,
		0.101775,
		0.530143,
		-0.841778,
		0,
		-0.064879,
		0.847908,
		0.526159,
		0,
		0.066621,
		0.658532,
		-0.167711,
		1
	},
	[1.275] = {
		0.995799,
		0.016477,
		0.090066,
		0,
		0.067297,
		0.535288,
		-0.841985,
		0,
		-0.062085,
		0.844509,
		0.53193,
		0,
		0.065878,
		0.659709,
		-0.168386,
		1
	},
	[1.28333333333] = {
		0.997655,
		0.031644,
		0.060684,
		0,
		0.03404,
		0.539796,
		-0.841107,
		0,
		-0.059373,
		0.841201,
		0.537453,
		0,
		0.065252,
		0.660841,
		-0.169081,
		1
	},
	[1.29166666667] = {
		0.998386,
		0.046426,
		0.032719,
		0,
		0.00222,
		0.543722,
		-0.839262,
		0,
		-0.056754,
		0.83798,
		0.542741,
		0,
		0.064744,
		0.661934,
		-0.169789,
		1
	},
	[1.2] = {
		0.91336,
		-0.115433,
		0.390447,
		0,
		0.397231,
		0.463051,
		-0.792333,
		0,
		-0.089336,
		0.878783,
		0.468786,
		0,
		0.076384,
		0.647134,
		-0.164394,
		1
	},
	[1.30833333333] = {
		0.997069,
		0.074287,
		-0.018288,
		0,
		-0.056267,
		0.5501,
		-0.833201,
		0,
		-0.051836,
		0.831788,
		0.552667,
		0,
		0.064086,
		0.664022,
		-0.171204,
		1
	},
	[1.31666666667] = {
		0.995356,
		0.087093,
		-0.041003,
		0,
		-0.082523,
		0.552709,
		-0.829279,
		0,
		-0.049562,
		0.828811,
		0.557329,
		0,
		0.063936,
		0.665029,
		-0.171898,
		1
	},
	[1.325] = {
		0.993178,
		0.098971,
		-0.061654,
		0,
		-0.106523,
		0.555048,
		-0.824969,
		0,
		-0.047428,
		0.825909,
		0.561805,
		0,
		0.063903,
		0.666019,
		-0.172571,
		1
	},
	[1.33333333333] = {
		0.990722,
		0.109792,
		-0.080096,
		0,
		-0.12808,
		0.557211,
		-0.820434,
		0,
		-0.045447,
		0.82308,
		0.566104,
		0,
		0.063985,
		0.666998,
		-0.173216,
		1
	},
	[1.34166666667] = {
		0.988172,
		0.119429,
		-0.096194,
		0,
		-0.147013,
		0.559292,
		-0.81583,
		0,
		-0.043633,
		0.820322,
		0.570235,
		0,
		0.064182,
		0.667973,
		-0.173826,
		1
	},
	[1.35833333333] = {
		0.983529,
		0.13473,
		-0.120491,
		0,
		-0.176074,
		0.563515,
		-0.807124,
		0,
		-0.040845,
		0.815045,
		0.577956,
		0,
		0.06498,
		0.669947,
		-0.17505,
		1
	},
	[1.35] = {
		0.985707,
		0.127759,
		-0.10982,
		0,
		-0.163152,
		0.561385,
		-0.811312,
		0,
		-0.042001,
		0.817633,
		0.574205,
		0,
		0.064489,
		0.668949,
		-0.174392,
		1
	},
	[1.36666666667] = {
		0.981779,
		0.14044,
		-0.128009,
		0,
		-0.185676,
		0.565681,
		-0.803449,
		0,
		-0.040424,
		0.812577,
		0.58145,
		0,
		0.065704,
		0.67098,
		-0.175926,
		1
	},
	[1.375] = {
		0.980499,
		0.14499,
		-0.132663,
		0,
		-0.192264,
		0.56792,
		-0.800313,
		0,
		-0.040695,
		0.810213,
		0.584722,
		0,
		0.066627,
		0.672038,
		-0.176992,
		1
	},
	[1.38333333333] = {
		0.979695,
		0.148479,
		-0.134731,
		0,
		-0.19613,
		0.570256,
		-0.79771,
		0,
		-0.041612,
		0.807937,
		0.587798,
		0,
		0.067718,
		0.673113,
		-0.17822,
		1
	},
	[1.39166666667] = {
		0.979343,
		0.151006,
		-0.134478,
		0,
		-0.197553,
		0.572698,
		-0.795607,
		0,
		-0.043126,
		0.805739,
		0.590699,
		0,
		0.068947,
		0.674196,
		-0.179584,
		1
	},
	[1.3] = {
		0.998137,
		0.060686,
		0.006339,
		0,
		-0.027952,
		0.547132,
		-0.83658,
		0,
		-0.054238,
		0.834844,
		0.547809,
		0,
		0.064355,
		0.662992,
		-0.170499,
		1
	},
	[1.40833333333] = {
		0.979811,
		0.153554,
		-0.128029,
		0,
		-0.194144,
		0.577893,
		-0.792684,
		0,
		-0.047733,
		0.801536,
		0.596038,
		0,
		0.071707,
		0.676347,
		-0.182607,
		1
	},
	[1.41666666667] = {
		0.980506,
		0.153767,
		-0.122329,
		0,
		-0.189833,
		0.580628,
		-0.791728,
		0,
		-0.050715,
		0.799516,
		0.5985,
		0,
		0.073184,
		0.677396,
		-0.184211,
		1
	},
	[1.425] = {
		0.981414,
		0.153402,
		-0.115302,
		0,
		-0.184128,
		0.583435,
		-0.791012,
		0,
		-0.054071,
		0.797541,
		0.600837,
		0,
		0.07469,
		0.678415,
		-0.185839,
		1
	},
	[1.43333333333] = {
		0.982465,
		0.152555,
		-0.107193,
		0,
		-0.177283,
		0.586295,
		-0.790461,
		0,
		-0.057742,
		0.795603,
		0.60306,
		0,
		0.076199,
		0.679394,
		-0.187463,
		1
	},
	[1.44166666667] = {
		0.98359,
		0.151326,
		-0.098244,
		0,
		-0.169555,
		0.589192,
		-0.790003,
		0,
		-0.061663,
		0.793696,
		0.605181,
		0,
		0.077685,
		0.680322,
		-0.189056,
		1
	},
	[1.45833333333] = {
		0.985823,
		0.148126,
		-0.078808,
		0,
		-0.152489,
		0.595023,
		-0.78911,
		0,
		-0.069995,
		0.78994,
		0.609176,
		0,
		0.080483,
		0.681987,
		-0.192038,
		1
	},
	[1.45] = {
		0.984727,
		0.149815,
		-0.0887,
		0,
		-0.161204,
		0.592107,
		-0.789571,
		0,
		-0.06577,
		0.791811,
		0.607214,
		0,
		0.079122,
		0.68119,
		-0.19059,
		1
	},
	[1.46666666667] = {
		0.986834,
		0.146365,
		-0.068818,
		0,
		-0.143675,
		0.597928,
		-0.788568,
		0,
		-0.07427,
		0.788073,
		0.611085,
		0,
		0.081741,
		0.682703,
		-0.193371,
		1
	},
	[1.475] = {
		0.987725,
		0.144639,
		-0.05898,
		0,
		-0.135029,
		0.600809,
		-0.787906,
		0,
		-0.078526,
		0.786198,
		0.612965,
		0,
		0.08287,
		0.683327,
		-0.194562,
		1
	},
	[1.48333333333] = {
		0.988473,
		0.143058,
		-0.049549,
		0,
		-0.126819,
		0.603656,
		-0.787093,
		0,
		-0.08269,
		0.784304,
		0.614841,
		0,
		0.083841,
		0.683851,
		-0.195584,
		1
	},
	[1.49166666667] = {
		0.989064,
		0.141735,
		-0.040778,
		0,
		-0.119318,
		0.606463,
		-0.786108,
		0,
		-0.086689,
		0.782377,
		0.616742,
		0,
		0.084626,
		0.684262,
		-0.19641,
		1
	},
	[1.4] = {
		0.979401,
		0.152665,
		-0.132161,
		0,
		-0.196803,
		0.575246,
		-0.793953,
		0,
		-0.045184,
		0.803608,
		0.593441,
		0,
		0.070286,
		0.675277,
		-0.181056,
		1
	},
	[1.50833333333] = {
		0.989758,
		0.140321,
		-0.026236,
		0,
		-0.107526,
		0.611929,
		-0.783569,
		0,
		-0.093897,
		0.778365,
		0.62075,
		0,
		0.085528,
		0.684706,
		-0.197362,
		1
	},
	[1.51666666667] = {
		0.989864,
		0.140463,
		-0.020974,
		0,
		-0.10378,
		0.614579,
		-0.781999,
		0,
		-0.096952,
		0.776249,
		0.622927,
		0,
		0.085587,
		0.684717,
		-0.197434,
		1
	},
	[1.5] = {
		0.989493,
		0.140784,
		-0.032922,
		0,
		-0.112796,
		0.609222,
		-0.784937,
		0,
		-0.09045,
		0.780403,
		0.618701,
		0,
		0.085198,
		0.68455,
		-0.197011,
		1
	}
}

return spline_matrices
