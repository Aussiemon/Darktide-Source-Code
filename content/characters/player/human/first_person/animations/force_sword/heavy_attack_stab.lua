local spline_matrices = {
	[0] = {
		-0.821873,
		-0.118057,
		0.557304,
		0,
		0.554975,
		0.054851,
		0.830057,
		0,
		-0.128563,
		0.991491,
		0.020438,
		0,
		0.647424,
		0.085704,
		-0.136451,
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
	},
	[0.00833333333333] = {
		-0.821749,
		-0.119136,
		0.557256,
		0,
		0.554917,
		0.055097,
		0.830079,
		0,
		-0.129595,
		0.991348,
		0.020835,
		0,
		0.647349,
		0.066915,
		-0.136425,
		1
	},
	[0.0166666666667] = {
		-0.821589,
		-0.120548,
		0.557189,
		0,
		0.554842,
		0.055384,
		0.83011,
		0,
		-0.130927,
		0.991161,
		0.021382,
		0,
		0.647292,
		0.048798,
		-0.136407,
		1
	},
	[0.025] = {
		-0.821396,
		-0.122239,
		0.557105,
		0,
		0.554752,
		0.055707,
		0.830149,
		0,
		-0.132511,
		0.990936,
		0.022055,
		0,
		0.647263,
		0.032052,
		-0.136402,
		1
	},
	[0.0333333333333] = {
		-0.821176,
		-0.124154,
		0.557006,
		0,
		0.554648,
		0.056063,
		0.830195,
		0,
		-0.1343,
		0.990678,
		0.022824,
		0,
		0.647273,
		0.016255,
		-0.136416,
		1
	},
	[0.0416666666667] = {
		-0.820933,
		-0.12624,
		0.556895,
		0,
		0.554532,
		0.056447,
		0.830245,
		0,
		-0.136246,
		0.990392,
		0.023665,
		0,
		0.64733,
		0.001266,
		-0.136453,
		1
	},
	[0.0583333333333] = {
		-0.820401,
		-0.130704,
		0.556649,
		0,
		0.554278,
		0.057284,
		0.830358,
		0,
		-0.140419,
		0.989765,
		0.025451,
		0,
		0.647603,
		-0.026853,
		-0.136596,
		1
	},
	[0.05] = {
		-0.820673,
		-0.128441,
		0.556775,
		0,
		0.554408,
		0.056856,
		0.8303,
		0,
		-0.138301,
		0.990086,
		0.024549,
		0,
		0.647439,
		-0.013056,
		-0.136512,
		1
	},
	[0.0666666666667] = {
		-0.820124,
		-0.132975,
		0.55652,
		0,
		0.554144,
		0.057729,
		0.830417,
		0,
		-0.142552,
		0.989437,
		0.026343,
		0,
		0.647821,
		-0.040266,
		-0.136701,
		1
	},
	[0.075] = {
		-0.819847,
		-0.135198,
		0.556392,
		0,
		0.55401,
		0.058185,
		0.830475,
		0,
		-0.144652,
		0.989109,
		0.027198,
		0,
		0.648091,
		-0.053436,
		-0.136828,
		1
	},
	[0.0833333333333] = {
		-0.819577,
		-0.137321,
		0.55627,
		0,
		0.553878,
		0.058649,
		0.83053,
		0,
		-0.146674,
		0.988789,
		0.027992,
		0,
		0.648411,
		-0.066505,
		-0.136972,
		1
	},
	[0.0916666666667] = {
		-0.81932,
		-0.139289,
		0.556159,
		0,
		0.553752,
		0.059117,
		0.83058,
		0,
		-0.148569,
		0.988486,
		0.028696,
		0,
		0.648776,
		-0.079614,
		-0.137131,
		1
	},
	[0.108333333333] = {
		-0.818877,
		-0.142543,
		0.555987,
		0,
		0.553534,
		0.060048,
		0.830659,
		0,
		-0.151791,
		0.987965,
		0.02973,
		0,
		0.649612,
		-0.106518,
		-0.137471,
		1
	},
	[0.116666666667] = {
		-0.818705,
		-0.143723,
		0.555937,
		0,
		0.553448,
		0.060504,
		0.830683,
		0,
		-0.153025,
		0.987767,
		0.030008,
		0,
		0.650064,
		-0.120597,
		-0.137638,
		1
	},
	[0.125] = {
		-0.818576,
		-0.144532,
		0.555917,
		0,
		0.553384,
		0.060948,
		0.830693,
		0,
		-0.153943,
		0.987621,
		0.030091,
		0,
		0.650522,
		-0.135284,
		-0.137793,
		1
	},
	[0.133333333333] = {
		-0.818498,
		-0.144916,
		0.555932,
		0,
		0.553345,
		0.061376,
		0.830688,
		0,
		-0.154501,
		0.987539,
		0.029953,
		0,
		0.65097,
		-0.150719,
		-0.137924,
		1
	},
	[0.141666666667] = {
		-0.818477,
		-0.144822,
		0.555988,
		0,
		0.553335,
		0.061784,
		0.830664,
		0,
		-0.15465,
		0.987527,
		0.029566,
		0,
		0.651387,
		-0.167046,
		-0.138016,
		1
	},
	[0.158333333333] = {
		-0.818634,
		-0.142982,
		0.556232,
		0,
		0.553413,
		0.062524,
		0.830557,
		0,
		-0.153533,
		0.987748,
		0.027944,
		0,
		0.652008,
		-0.202443,
		-0.138011,
		1
	},
	[0.15] = {
		-0.81852,
		-0.144195,
		0.556087,
		0,
		0.553356,
		0.062168,
		0.830621,
		0,
		-0.154343,
		0.987594,
		0.028906,
		0,
		0.651749,
		-0.184406,
		-0.138054,
		1
	},
	[0.166666666667] = {
		-0.818824,
		-0.141128,
		0.556426,
		0,
		0.553507,
		0.062848,
		0.83047,
		0,
		-0.152173,
		0.987994,
		0.026654,
		0,
		0.652178,
		-0.222797,
		-0.137874,
		1
	},
	[0.175] = {
		-0.819095,
		-0.137525,
		0.556929,
		0,
		0.553641,
		0.064705,
		0.830238,
		0,
		-0.150215,
		0.988383,
		0.02314,
		0,
		0.65221,
		-0.245875,
		-0.137144,
		1
	},
	[0.183333333333] = {
		-0.81945,
		-0.133695,
		0.557339,
		0,
		0.553816,
		0.06574,
		0.83004,
		0,
		-0.147612,
		0.98884,
		0.020172,
		0,
		0.652157,
		-0.275414,
		-0.136399,
		1
	},
	[0.191666666667] = {
		-0.828555,
		-0.135611,
		0.543236,
		0,
		0.541477,
		0.052812,
		0.839055,
		0,
		-0.142475,
		0.989354,
		0.029673,
		0,
		0.651195,
		-0.326681,
		-0.136565,
		1
	},
	[0.1] = {
		-0.819085,
		-0.141047,
		0.556063,
		0,
		0.553636,
		0.059585,
		0.830624,
		0,
		-0.15029,
		0.988208,
		0.029284,
		0,
		0.649179,
		-0.092905,
		-0.137299,
		1
	},
	[0.208333333333] = {
		-0.703971,
		-0.1358,
		0.697125,
		0,
		0.696185,
		0.062282,
		0.715155,
		0,
		-0.140537,
		0.988777,
		0.050697,
		0,
		0.60189,
		-0.25927,
		-0.136294,
		1
	},
	[0.216666666667] = {
		-0.537516,
		-0.128786,
		0.833361,
		0,
		0.831187,
		0.085674,
		0.549353,
		0,
		-0.142146,
		0.987965,
		0.060995,
		0,
		0.50625,
		-0.02224,
		-0.124322,
		1
	},
	[0.225] = {
		-0.346587,
		-0.11354,
		0.931121,
		0,
		0.927245,
		0.108536,
		0.35838,
		0,
		-0.141751,
		0.987587,
		0.067662,
		0,
		0.388458,
		0.272732,
		-0.109807,
		1
	},
	[0.233333333333] = {
		-0.1381,
		-0.09244,
		0.986095,
		0,
		0.980733,
		0.126134,
		0.149174,
		0,
		-0.13817,
		0.987697,
		0.07324,
		0,
		0.267348,
		0.546,
		-0.100165,
		1
	},
	[0.241666666667] = {
		0.00426,
		-0.078495,
		0.996905,
		0,
		0.991155,
		0.132562,
		0.006202,
		0,
		-0.132638,
		0.988062,
		0.078365,
		0,
		0.166532,
		0.674794,
		-0.098767,
		1
	},
	[0.258333333333] = {
		0.214503,
		-0.059053,
		0.974936,
		0,
		0.969627,
		0.132975,
		-0.205281,
		0,
		-0.11752,
		0.989359,
		0.085783,
		0,
		0.110127,
		0.724115,
		-0.106962,
		1
	},
	[0.25] = {
		0.127351,
		-0.065978,
		0.989661,
		0,
		0.984007,
		0.133692,
		-0.117711,
		0,
		-0.124543,
		0.988824,
		0.081948,
		0,
		0.112803,
		0.722723,
		-0.101872,
		1
	},
	[0.266666666667] = {
		0.302062,
		-0.053644,
		0.951778,
		0,
		0.947104,
		0.130425,
		-0.293228,
		0,
		-0.108406,
		0.990006,
		0.090203,
		0,
		0.10768,
		0.725855,
		-0.11164,
		1
	},
	[0.275] = {
		0.389421,
		-0.049522,
		0.919727,
		0,
		0.915789,
		0.127493,
		-0.380889,
		0,
		-0.098396,
		0.990602,
		0.095001,
		0,
		0.104618,
		0.728259,
		-0.115816,
		1
	},
	[0.283333333333] = {
		0.475677,
		-0.046012,
		0.878416,
		0,
		0.875134,
		0.125479,
		-0.467327,
		0,
		-0.08872,
		0.991029,
		0.099954,
		0,
		0.100185,
		0.730057,
		-0.119594,
		1
	},
	[0.291666666667] = {
		0.559591,
		-0.042598,
		0.827673,
		0,
		0.824938,
		0.124541,
		-0.551332,
		0,
		-0.079594,
		0.9913,
		0.104833,
		0,
		0.094377,
		0.729229,
		-0.123115,
		1
	},
	[0.2] = {
		-0.837587,
		-0.136801,
		0.528899,
		0,
		0.528946,
		0.039037,
		0.847757,
		0,
		-0.136621,
		0.989829,
		0.039664,
		0,
		0.649234,
		-0.370934,
		-0.137127,
		1
	},
	[0.308333333333] = {
		0.714365,
		-0.03597,
		0.698849,
		0,
		0.697106,
		0.123709,
		-0.706215,
		0,
		-0.061051,
		0.991666,
		0.113448,
		0,
		0.080387,
		0.728225,
		-0.127958,
		1
	},
	[0.316666666667] = {
		0.782138,
		-0.032505,
		0.622257,
		0,
		0.620958,
		0.123498,
		-0.774054,
		0,
		-0.051687,
		0.991812,
		0.116777,
		0,
		0.072718,
		0.728171,
		-0.129197,
		1
	},
	[0.325] = {
		0.841629,
		-0.028879,
		0.539284,
		0,
		0.538392,
		0.123203,
		-0.83364,
		0,
		-0.042367,
		0.991961,
		0.119239,
		0,
		0.06497,
		0.728251,
		-0.129661,
		1
	},
	[0.333333333333] = {
		0.891794,
		-0.02513,
		0.451743,
		0,
		0.451221,
		0.122676,
		-0.88394,
		0,
		-0.033205,
		0.992129,
		0.120741,
		0,
		0.05742,
		0.728418,
		-0.129397,
		1
	},
	[0.341666666667] = {
		0.932037,
		-0.021228,
		0.361742,
		0,
		0.361538,
		0.121853,
		-0.92436,
		0,
		-0.024457,
		0.992321,
		0.121246,
		0,
		0.050241,
		0.728615,
		-0.128486,
		1
	},
	[0.358333333333] = {
		0.982957,
		-0.012848,
		0.183385,
		0,
		0.183599,
		0.119103,
		-0.975759,
		0,
		-0.009305,
		0.992799,
		0.119432,
		0,
		0.03742,
		0.729055,
		-0.125161,
		1
	},
	[0.35] = {
		0.962275,
		-0.017113,
		0.271539,
		0,
		0.271581,
		0.120688,
		-0.954818,
		0,
		-0.016431,
		0.992543,
		0.120783,
		0,
		0.043528,
		0.728835,
		-0.127031,
		1
	},
	[0.366666666667] = {
		0.995014,
		-0.008516,
		0.09937,
		0,
		0.099682,
		0.117053,
		-0.98811,
		0,
		-0.003217,
		0.993089,
		0.117318,
		0,
		0.032023,
		0.729244,
		-0.123015,
		1
	},
	[0.375] = {
		0.999764,
		-0.004216,
		0.021309,
		0,
		0.021652,
		0.114531,
		-0.993184,
		0,
		0.001747,
		0.993411,
		0.114595,
		0,
		0.027404,
		0.72939,
		-0.120735,
		1
	},
	[0.383333333333] = {
		0.998783,
		-4.6e-05,
		-0.049319,
		0,
		-0.049006,
		0.111565,
		-0.992548,
		0,
		0.005548,
		0.993757,
		0.111426,
		0,
		0.023603,
		0.729424,
		-0.118463,
		1
	},
	[0.391666666667] = {
		0.99377,
		0.003919,
		-0.111385,
		0,
		-0.111152,
		0.108374,
		-0.987877,
		0,
		0.0082,
		0.994103,
		0.108134,
		0,
		0.020632,
		0.72931,
		-0.116209,
		1
	},
	[0.3] = {
		0.639672,
		-0.039303,
		0.767643,
		0,
		0.76542,
		0.124001,
		-0.631471,
		0,
		-0.070369,
		0.991503,
		0.109404,
		0,
		0.087698,
		0.7285,
		-0.125932,
		1
	},
	[0.408333333333] = {
		0.978318,
		0.011141,
		-0.206808,
		0,
		-0.206852,
		0.102171,
		-0.973023,
		0,
		0.010289,
		0.994704,
		0.10226,
		0,
		0.017205,
		0.7285,
		-0.111833,
		1
	},
	[0.416666666667] = {
		0.970873,
		0.014352,
		-0.239166,
		0,
		-0.239392,
		0.099397,
		-0.965822,
		0,
		0.009911,
		0.994944,
		0.099937,
		0,
		0.016752,
		0.727749,
		-0.109881,
		1
	},
	[0.425] = {
		0.965243,
		0.017257,
		-0.260783,
		0,
		-0.261208,
		0.097026,
		-0.960394,
		0,
		0.008729,
		0.995132,
		0.098162,
		0,
		0.017152,
		0.726759,
		-0.108174,
		1
	},
	[0.433333333333] = {
		0.962304,
		0.019812,
		-0.271254,
		0,
		-0.27189,
		0.095221,
		-0.957606,
		0,
		0.006857,
		0.995259,
		0.097018,
		0,
		0.018422,
		0.725504,
		-0.106764,
		1
	},
	[0.441666666667] = {
		0.962596,
		0.021948,
		-0.270052,
		0,
		-0.270906,
		0.094157,
		-0.95799,
		0,
		0.004402,
		0.995315,
		0.096581,
		0,
		0.020605,
		0.723952,
		-0.1057,
		1
	},
	[0.458333333333] = {
		0.972991,
		0.024503,
		-0.229541,
		0,
		-0.230837,
		0.095025,
		-0.968341,
		0,
		-0.001915,
		0.995173,
		0.098115,
		0,
		0.028036,
		0.719799,
		-0.104762,
		1
	},
	[0.45] = {
		0.966267,
		0.023563,
		-0.256462,
		0,
		-0.257538,
		0.094026,
		-0.961683,
		0,
		0.001454,
		0.995291,
		0.096922,
		0,
		0.023772,
		0.722064,
		-0.105021,
		1
	},
	[0.466666666667] = {
		0.98184,
		0.024547,
		-0.188118,
		0,
		-0.189628,
		0.097354,
		-0.977018,
		0,
		-0.005668,
		0.994947,
		0.100241,
		0,
		0.03356,
		0.717081,
		-0.104953,
		1
	},
	[0.475] = {
		0.991124,
		0.02338,
		-0.130867,
		0,
		-0.132576,
		0.101188,
		-0.985994,
		0,
		-0.009811,
		0.994593,
		0.103389,
		0,
		0.040593,
		0.714443,
		-0.105562,
		1
	},
	[0.483333333333] = {
		0.998191,
		0.020581,
		-0.056483,
		0,
		-0.058365,
		0.106646,
		-0.992583,
		0,
		-0.014405,
		0.994084,
		0.107654,
		0,
		0.049335,
		0.708986,
		-0.106792,
		1
	},
	[0.491666666667] = {
		0.995865,
		0.022928,
		0.087902,
		0,
		0.084619,
		0.11788,
		-0.989416,
		0,
		-0.033047,
		0.992763,
		0.115452,
		0,
		0.063963,
		0.692929,
		-0.109479,
		1
	},
	[0.4] = {
		0.986418,
		0.007655,
		-0.164074,
		0,
		-0.163963,
		0.105206,
		-0.98084,
		0,
		0.009753,
		0.994421,
		0.105032,
		0,
		0.0185,
		0.729024,
		-0.113967,
		1
	},
	[0.508333333333] = {
		0.840763,
		0.004741,
		0.541383,
		0,
		0.534593,
		0.150843,
		-0.831539,
		0,
		-0.085606,
		0.988546,
		0.124289,
		0,
		0.119294,
		0.637621,
		-0.118457,
		1
	},
	[0.516666666667] = {
		0.747767,
		-0.006854,
		0.663925,
		0,
		0.65647,
		0.15741,
		-0.737746,
		0,
		-0.099452,
		0.987509,
		0.122206,
		0,
		0.147112,
		0.588216,
		-0.125879,
		1
	},
	[0.525] = {
		0.746516,
		-0.008697,
		0.66531,
		0,
		0.657867,
		0.159356,
		-0.736082,
		0,
		-0.099619,
		0.987183,
		0.124683,
		0,
		0.167594,
		0.505287,
		-0.143396,
		1
	},
	[0.533333333333] = {
		0.783686,
		-0.006263,
		0.621125,
		0,
		0.614001,
		0.159151,
		-0.773093,
		0,
		-0.09401,
		0.987234,
		0.12857,
		0,
		0.185338,
		0.409596,
		-0.165041,
		1
	},
	[0.541666666667] = {
		0.811786,
		-0.004575,
		0.583937,
		0,
		0.577282,
		0.157025,
		-0.801304,
		0,
		-0.088027,
		0.987584,
		0.130112,
		0,
		0.201525,
		0.330154,
		-0.1823,
		1
	},
	[0.558333333333] = {
		0.872486,
		0.000293,
		0.488639,
		0,
		0.483192,
		0.148385,
		-0.862849,
		0,
		-0.07276,
		0.98893,
		0.129322,
		0,
		0.235574,
		0.113796,
		-0.224588,
		1
	},
	[0.55] = {
		0.841764,
		-0.002429,
		0.53984,
		0,
		0.533759,
		0.153477,
		-0.831592,
		0,
		-0.080833,
		0.988149,
		0.130488,
		0,
		0.217837,
		0.247449,
		-0.200355,
		1
	},
	[0.566666666667] = {
		0.895809,
		0.002695,
		0.444431,
		0,
		0.439482,
		0.143558,
		-0.886705,
		0,
		-0.066192,
		0.989638,
		0.127416,
		0,
		0.250486,
		-0.007164,
		-0.24563,
		1
	},
	[0.575] = {
		0.907635,
		0.004236,
		0.419738,
		0,
		0.414996,
		0.141156,
		-0.898807,
		0,
		-0.063056,
		0.989978,
		0.12636,
		0,
		0.25915,
		-0.071532,
		-0.257025,
		1
	},
	[0.583333333333] = {
		0.915009,
		0.005444,
		0.403397,
		0,
		0.39874,
		0.13988,
		-0.906333,
		0,
		-0.061361,
		0.990154,
		0.125821,
		0,
		0.264772,
		-0.111888,
		-0.264211,
		1
	},
	[0.591666666667] = {
		0.919332,
		0.006443,
		0.393429,
		0,
		0.388773,
		0.139357,
		-0.910733,
		0,
		-0.060695,
		0.990221,
		0.12561,
		0,
		0.268234,
		-0.135371,
		-0.268421,
		1
	},
	[0.5] = {
		0.94685,
		0.018304,
		0.321154,
		0,
		0.315849,
		0.136255,
		-0.938975,
		0,
		-0.060946,
		0.990505,
		0.123232,
		0,
		0.088674,
		0.670586,
		-0.113648,
		1
	},
	[0.608333333333] = {
		0.923234,
		0.008192,
		0.384151,
		0,
		0.379383,
		0.139004,
		-0.914739,
		0,
		-0.060892,
		0.990258,
		0.125225,
		0,
		0.272369,
		-0.16025,
		-0.272824,
		1
	},
	[0.616666666667] = {
		0.924738,
		0.009104,
		0.380496,
		0,
		0.375686,
		0.138363,
		-0.91636,
		0,
		-0.060989,
		0.99034,
		0.124529,
		0,
		0.274966,
		-0.175899,
		-0.27547,
		1
	},
	[0.625] = {
		0.927145,
		0.010143,
		0.374565,
		0,
		0.369772,
		0.13686,
		-0.918987,
		0,
		-0.060584,
		0.990539,
		0.123138,
		0,
		0.279237,
		-0.203186,
		-0.280041,
		1
	},
	[0.633333333333] = {
		0.931279,
		0.011367,
		0.36413,
		0,
		0.359446,
		0.134066,
		-0.923485,
		0,
		-0.059315,
		0.990907,
		0.120767,
		0,
		0.286182,
		-0.249234,
		-0.287758,
		1
	},
	[0.641666666667] = {
		0.938214,
		0.013883,
		0.345778,
		0,
		0.34125,
		0.128841,
		-0.931101,
		0,
		-0.057477,
		0.991568,
		0.116143,
		0,
		0.298459,
		-0.331695,
		-0.301635,
		1
	},
	[0.658333333333] = {
		0.943756,
		0.01088,
		0.330464,
		0,
		0.327056,
		0.116091,
		-0.937847,
		0,
		-0.048568,
		0.993179,
		0.106003,
		0,
		0.318534,
		-0.478424,
		-0.324267,
		1
	},
	[0.65] = {
		0.943669,
		0.014583,
		0.330569,
		0,
		0.326438,
		0.122308,
		-0.937272,
		0,
		-0.0541,
		0.992385,
		0.110658,
		0,
		0.311317,
		-0.419968,
		-0.316044,
		1
	},
	[0.666666666667] = {
		0.941798,
		0.002639,
		0.336169,
		0,
		0.333877,
		0.109501,
		-0.936235,
		0,
		-0.039282,
		0.993983,
		0.102247,
		0,
		0.323934,
		-0.527535,
		-0.329922,
		1
	},
	[0.675] = {
		0.939673,
		-0.012032,
		0.341863,
		0,
		0.341253,
		0.10218,
		-0.934401,
		0,
		-0.023688,
		0.994693,
		0.100122,
		0,
		0.330307,
		-0.576447,
		-0.335357,
		1
	},
	[0.683333333333] = {
		0.936696,
		-0.03073,
		0.348791,
		0,
		0.350116,
		0.094504,
		-0.931927,
		0,
		-0.004324,
		0.99505,
		0.099281,
		0,
		0.336411,
		-0.622468,
		-0.340055,
		1
	},
	[0.691666666667] = {
		0.931833,
		-0.055087,
		0.358682,
		0,
		0.362454,
		0.092975,
		-0.927353,
		0,
		0.017737,
		0.994143,
		0.106604,
		0,
		0.343904,
		-0.676513,
		-0.342435,
		1
	},
	[0.6] = {
		0.921742,
		0.007332,
		0.387734,
		0,
		0.383028,
		0.139198,
		-0.913188,
		0,
		-0.060667,
		0.990237,
		0.125497,
		0,
		0.27045,
		-0.149115,
		-0.270882,
		1
	},
	[0.708333333333] = {
		0.927402,
		-0.083692,
		0.364583,
		0,
		0.370095,
		0.063657,
		-0.92681,
		0,
		0.054358,
		0.994456,
		0.09001,
		0,
		0.345501,
		-0.702254,
		-0.349306,
		1
	},
	[0.716666666667] = {
		0.936964,
		-0.079124,
		0.340348,
		0,
		0.33878,
		-0.032885,
		-0.940291,
		0,
		0.085592,
		0.996322,
		-0.004007,
		0,
		0.334183,
		-0.611905,
		-0.383158,
		1
	},
	[0.725] = {
		0.962873,
		-0.14017,
		0.230713,
		0,
		0.168668,
		-0.354911,
		-0.919559,
		0,
		0.210777,
		0.924332,
		-0.318092,
		0,
		0.317808,
		-0.306114,
		-0.535067,
		1
	},
	[0.733333333333] = {
		0.92916,
		-0.331749,
		0.163105,
		0,
		-0.066287,
		-0.583576,
		-0.809349,
		0,
		0.363685,
		0.741203,
		-0.564226,
		0,
		0.321834,
		-0.020295,
		-0.711532,
		1
	},
	[0.741666666667] = {
		0.895097,
		-0.402852,
		0.191081,
		0,
		-0.132873,
		-0.650093,
		-0.748147,
		0,
		0.425613,
		0.644274,
		-0.635425,
		0,
		0.326527,
		0.031437,
		-0.751143,
		1
	},
	[0.758333333333] = {
		0.879873,
		-0.416601,
		0.228619,
		0,
		-0.142425,
		-0.69016,
		-0.709502,
		0,
		0.453363,
		0.591711,
		-0.666588,
		0,
		0.327303,
		0.018454,
		-0.743864,
		1
	},
	[0.75] = {
		0.882465,
		-0.412955,
		0.22522,
		0,
		-0.138,
		-0.685028,
		-0.715327,
		0,
		0.44968,
		0.600171,
		-0.661501,
		0,
		0.327464,
		0.015643,
		-0.742986,
		1
	},
	[0.766666666667] = {
		0.884134,
		-0.41057,
		0.223021,
		0,
		-0.137084,
		-0.684259,
		-0.716239,
		0,
		0.446671,
		0.602679,
		-0.661259,
		0,
		0.326349,
		0.01723,
		-0.740665,
		1
	},
	[0.775] = {
		0.884954,
		-0.409397,
		0.221924,
		0,
		-0.136645,
		-0.683873,
		-0.716691,
		0,
		0.445179,
		0.603914,
		-0.661138,
		0,
		0.325791,
		0.018012,
		-0.739504,
		1
	},
	[0.783333333333] = {
		0.885765,
		-0.408236,
		0.220827,
		0,
		-0.13622,
		-0.683485,
		-0.717142,
		0,
		0.443695,
		0.605138,
		-0.661016,
		0,
		0.325233,
		0.018787,
		-0.738342,
		1
	},
	[0.791666666667] = {
		0.886567,
		-0.407085,
		0.219731,
		0,
		-0.135805,
		-0.683095,
		-0.717592,
		0,
		0.442218,
		0.606353,
		-0.660893,
		0,
		0.324674,
		0.019556,
		-0.737181,
		1
	},
	[0.7] = {
		0.928301,
		-0.074915,
		0.364204,
		0,
		0.369607,
		0.078995,
		-0.925824,
		0,
		0.040588,
		0.994056,
		0.101021,
		0,
		0.348335,
		-0.706979,
		-0.347406,
		1
	},
	[0.808333333333] = {
		0.888146,
		-0.404812,
		0.21754,
		0,
		-0.135008,
		-0.682309,
		-0.718489,
		0,
		0.439283,
		0.608754,
		-0.660643,
		0,
		0.323557,
		0.021077,
		-0.734857,
		1
	},
	[0.816666666667] = {
		0.888925,
		-0.403689,
		0.216446,
		0,
		-0.134623,
		-0.681914,
		-0.718937,
		0,
		0.437824,
		0.609942,
		-0.660516,
		0,
		0.322998,
		0.021831,
		-0.733695,
		1
	},
	[0.825] = {
		0.889696,
		-0.402572,
		0.215351,
		0,
		-0.134247,
		-0.681516,
		-0.719384,
		0,
		0.436369,
		0.611123,
		-0.660386,
		0,
		0.322439,
		0.022581,
		-0.732532,
		1
	},
	[0.833333333333] = {
		0.890462,
		-0.401462,
		0.214256,
		0,
		-0.133879,
		-0.681116,
		-0.719832,
		0,
		0.434919,
		0.612298,
		-0.660255,
		0,
		0.32188,
		0.023328,
		-0.731369,
		1
	},
	[0.841666666667] = {
		0.891221,
		-0.400358,
		0.213162,
		0,
		-0.133517,
		-0.680713,
		-0.72028,
		0,
		0.433472,
		0.613468,
		-0.660121,
		0,
		0.32132,
		0.024073,
		-0.730206,
		1
	},
	[0.858333333333] = {
		0.892725,
		-0.398163,
		0.210971,
		0,
		-0.132811,
		-0.6799,
		-0.721177,
		0,
		0.430585,
		0.615794,
		-0.659844,
		0,
		0.3202,
		0.025559,
		-0.727877,
		1
	},
	[0.85] = {
		0.891976,
		-0.399259,
		0.212067,
		0,
		-0.133161,
		-0.680308,
		-0.720728,
		0,
		0.432027,
		0.614633,
		-0.659984,
		0,
		0.32076,
		0.024816,
		-0.729042,
		1
	},
	[0.866666666667] = {
		0.89347,
		-0.39707,
		0.209875,
		0,
		-0.132465,
		-0.67949,
		-0.721628,
		0,
		0.429145,
		0.616951,
		-0.659701,
		0,
		0.319639,
		0.026301,
		-0.726712,
		1
	},
	[0.875] = {
		0.89421,
		-0.395979,
		0.208778,
		0,
		-0.132123,
		-0.679077,
		-0.722079,
		0,
		0.427705,
		0.618106,
		-0.659555,
		0,
		0.319079,
		0.027043,
		-0.725546,
		1
	},
	[0.883333333333] = {
		0.894948,
		-0.39489,
		0.20768,
		0,
		-0.131784,
		-0.67866,
		-0.722533,
		0,
		0.426265,
		0.61926,
		-0.659405,
		0,
		0.318518,
		0.027786,
		-0.72438,
		1
	},
	[0.891666666667] = {
		0.895682,
		-0.3938,
		0.206581,
		0,
		-0.131447,
		-0.67824,
		-0.722988,
		0,
		0.424825,
		0.620413,
		-0.659251,
		0,
		0.317956,
		0.028531,
		-0.723214,
		1
	},
	[0.8] = {
		0.88736,
		-0.405944,
		0.218635,
		0,
		-0.135402,
		-0.682703,
		-0.718041,
		0,
		0.440747,
		0.607557,
		-0.660769,
		0,
		0.324116,
		0.020319,
		-0.736019,
		1
	},
	[0.908333333333] = {
		0.897229,
		-0.391492,
		0.204239,
		0,
		-0.130743,
		-0.677329,
		-0.723969,
		0,
		0.421765,
		0.622864,
		-0.658904,
		0,
		0.316762,
		0.030126,
		-0.720732,
		1
	},
	[0.916666666667] = {
		0.897869,
		-0.390524,
		0.203277,
		0,
		-0.130444,
		-0.67696,
		-0.724368,
		0,
		0.420494,
		0.623872,
		-0.658763,
		0,
		0.31627,
		0.030782,
		-0.71971,
		1
	},
	[0.925] = {
		0.897989,
		-0.390309,
		0.203161,
		0,
		-0.130352,
		-0.676956,
		-0.724389,
		0,
		0.420267,
		0.624011,
		-0.658776,
		0,
		0.316198,
		0.03086,
		-0.719565,
		1
	},
	[0.933333333333] = {
		0.897937,
		-0.390344,
		0.203325,
		0,
		-0.130327,
		-0.677071,
		-0.724286,
		0,
		0.420386,
		0.623864,
		-0.658839,
		0,
		0.316265,
		0.030749,
		-0.719714,
		1
	},
	[0.941666666667] = {
		0.897973,
		-0.39025,
		0.203346,
		0,
		-0.130264,
		-0.677121,
		-0.72425,
		0,
		0.420328,
		0.623869,
		-0.658872,
		0,
		0.316262,
		0.03074,
		-0.719715,
		1
	},
	[0.958333333333] = {
		0.898053,
		-0.390047,
		0.20338,
		0,
		-0.130124,
		-0.677212,
		-0.72419,
		0,
		0.4202,
		0.623897,
		-0.658927,
		0,
		0.316255,
		0.030742,
		-0.719718,
		1
	},
	[0.95] = {
		0.898012,
		-0.390151,
		0.203364,
		0,
		-0.130196,
		-0.677168,
		-0.724218,
		0,
		0.420266,
		0.623879,
		-0.658901,
		0,
		0.316259,
		0.030738,
		-0.719717,
		1
	},
	[0.966666666667] = {
		0.898098,
		-0.389937,
		0.203393,
		0,
		-0.130047,
		-0.677252,
		-0.724167,
		0,
		0.420128,
		0.623923,
		-0.658949,
		0,
		0.316252,
		0.030753,
		-0.719719,
		1
	},
	[0.975] = {
		0.898147,
		-0.38982,
		0.203404,
		0,
		-0.129962,
		-0.677288,
		-0.724149,
		0,
		0.42005,
		0.623957,
		-0.658966,
		0,
		0.316248,
		0.030773,
		-0.71972,
		1
	},
	[0.983333333333] = {
		0.898199,
		-0.389694,
		0.203412,
		0,
		-0.129871,
		-0.67732,
		-0.724135,
		0,
		0.419966,
		0.624,
		-0.658978,
		0,
		0.316244,
		0.030801,
		-0.71972,
		1
	},
	[0.991666666667] = {
		0.898256,
		-0.389561,
		0.203416,
		0,
		-0.129772,
		-0.677346,
		-0.724128,
		0,
		0.419875,
		0.624055,
		-0.658985,
		0,
		0.316239,
		0.03084,
		-0.719721,
		1
	},
	[0.9] = {
		0.896413,
		-0.39271,
		0.205481,
		0,
		-0.131112,
		-0.677817,
		-0.723446,
		0,
		0.423383,
		0.621565,
		-0.659093,
		0,
		0.317394,
		0.029278,
		-0.722046,
		1
	}
}

return spline_matrices
