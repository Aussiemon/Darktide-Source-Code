local spline_matrices = {
	[0] = {
		0.357744,
		0.883113,
		-0.30353,
		0,
		-0.044492,
		-0.308553,
		-0.950166,
		0,
		-0.932759,
		0.35342,
		-0.071092,
		0,
		-0.119118,
		0.276916,
		-0.444199,
		1
	},
	[0.00833333333333] = {
		0.361114,
		0.920682,
		-0.148124,
		0,
		-0.059126,
		-0.135917,
		-0.988954,
		0,
		-0.930645,
		0.365883,
		0.005355,
		0,
		-0.1336,
		0.285752,
		-0.409225,
		1
	},
	[0.0166666666667] = {
		0.368077,
		0.929567,
		0.020603,
		0,
		-0.079998,
		0.053738,
		-0.995345,
		0,
		-0.926347,
		0.364716,
		0.094143,
		0,
		-0.149526,
		0.294139,
		-0.370117,
		1
	},
	[0.025] = {
		0.379449,
		0.90421,
		0.196019,
		0,
		-0.101885,
		0.251411,
		-0.962503,
		0,
		-0.919586,
		0.34525,
		0.187523,
		0,
		-0.165904,
		0.30186,
		-0.328169,
		1
	},
	[0.0333333333333] = {
		0.394257,
		0.842183,
		0.367817,
		0,
		-0.119495,
		0.443817,
		-0.888114,
		0,
		-0.911198,
		0.306193,
		0.275615,
		0,
		-0.181799,
		0.308724,
		-0.285006,
		1
	},
	[0.0416666666667] = {
		0.40958,
		0.746499,
		0.524388,
		0,
		-0.128323,
		0.616242,
		-0.777032,
		0,
		-0.903204,
		0.250966,
		0.348194,
		0,
		-0.196372,
		0.314783,
		-0.242597,
		1
	},
	[0.0583333333333] = {
		0.423002,
		0.493933,
		0.759671,
		0,
		-0.110694,
		0.860258,
		-0.497697,
		0,
		-0.899342,
		0.126436,
		0.418567,
		0,
		-0.218833,
		0.326748,
		-0.168617,
		1
	},
	[0.05] = {
		0.42095,
		0.626069,
		0.656383,
		0,
		-0.125551,
		0.756868,
		-0.641395,
		0,
		-0.898353,
		0.187586,
		0.397208,
		0,
		-0.208893,
		0.320507,
		-0.203101,
		1
	},
	[0.0666666666667] = {
		0.411144,
		0.363595,
		0.835918,
		0,
		-0.083618,
		0.928186,
		-0.3626,
		0,
		-0.907727,
		0.079183,
		0.412022,
		0,
		-0.22525,
		0.334919,
		-0.141056,
		1
	},
	[0.075] = {
		0.373949,
		0.247785,
		0.893736,
		0,
		-0.023725,
		0.96589,
		-0.257863,
		0,
		-0.927146,
		0.075224,
		0.367073,
		0,
		-0.225919,
		0.349338,
		-0.127713,
		1
	},
	[0.0833333333333] = {
		0.307701,
		0.144877,
		0.940389,
		0,
		0.060158,
		0.9834,
		-0.171187,
		0,
		-0.949579,
		0.109247,
		0.293877,
		0,
		-0.220355,
		0.369726,
		-0.12598,
		1
	},
	[0.0916666666667] = {
		0.226341,
		0.04042,
		0.973209,
		0,
		0.125697,
		0.989572,
		-0.070333,
		0,
		-0.965904,
		0.138249,
		0.2189,
		0,
		-0.210806,
		0.39067,
		-0.12343,
		1
	},
	[0.108333333333] = {
		0.08738,
		-0.268326,
		0.959357,
		0,
		0.04105,
		0.963192,
		0.26566,
		0,
		-0.995329,
		0.016168,
		0.095179,
		0,
		-0.192354,
		0.417321,
		-0.077958,
		1
	},
	[0.116666666667] = {
		0.050677,
		-0.477509,
		0.877164,
		0,
		-0.11627,
		0.8695,
		0.480054,
		0,
		-0.991924,
		-0.126315,
		-0.011456,
		0,
		-0.181481,
		0.423921,
		-0.041297,
		1
	},
	[0.125] = {
		0.084367,
		-0.662098,
		0.744653,
		0,
		-0.279369,
		0.701627,
		0.655494,
		0,
		-0.95647,
		-0.263335,
		-0.125776,
		0,
		-0.167981,
		0.422958,
		-0.005488,
		1
	},
	[0.133333333333] = {
		0.192054,
		-0.775983,
		0.600804,
		0,
		-0.377962,
		0.506492,
		0.774991,
		0,
		-0.905682,
		-0.375921,
		-0.196018,
		0,
		-0.152868,
		0.41075,
		0.025568,
		1
	},
	[0.141666666667] = {
		0.401491,
		-0.818142,
		0.411641,
		0,
		-0.374255,
		0.263659,
		0.889054,
		0,
		-0.835906,
		-0.511005,
		-0.200337,
		0,
		-0.13514,
		0.364999,
		0.054753,
		1
	},
	[0.158333333333] = {
		0.698514,
		-0.51679,
		0.494981,
		0,
		-0.227817,
		0.495118,
		0.838426,
		0,
		-0.678364,
		-0.698417,
		0.228113,
		0,
		-0.086333,
		0.364663,
		0.097175,
		1
	},
	[0.15] = {
		0.596535,
		-0.740117,
		0.31044,
		0,
		-0.284835,
		0.166391,
		0.944025,
		0,
		-0.750343,
		-0.651568,
		-0.111553,
		0,
		-0.111087,
		0.327546,
		0.077786,
		1
	},
	[0.166666666667] = {
		0.772864,
		-0.186929,
		0.606415,
		0,
		-0.212538,
		0.824181,
		0.524931,
		0,
		-0.597921,
		-0.534587,
		0.59725,
		0,
		-0.063639,
		0.429162,
		0.103276,
		1
	},
	[0.175] = {
		0.84883,
		0.043646,
		0.526861,
		0,
		-0.22363,
		0.932676,
		0.283028,
		0,
		-0.479037,
		-0.358064,
		0.801444,
		0,
		-0.042759,
		0.464583,
		0.093787,
		1
	},
	[0.183333333333] = {
		0.900618,
		0.172614,
		0.398862,
		0,
		-0.188226,
		0.982126,
		-2.2e-05,
		0,
		-0.391737,
		-0.075056,
		0.917011,
		0,
		-0.025469,
		0.503596,
		0.074648,
		1
	},
	[0.191666666667] = {
		0.93983,
		0.121837,
		0.319179,
		0,
		0.062012,
		0.857894,
		-0.510071,
		0,
		-0.335967,
		0.499173,
		0.798719,
		0,
		-0.004115,
		0.56715,
		0.029663,
		1
	},
	[0.1] = {
		0.152297,
		-0.08911,
		0.98431,
		0,
		0.129586,
		0.98913,
		0.069496,
		0,
		-0.979803,
		0.116969,
		0.162188,
		0,
		-0.20121,
		0.406628,
		-0.108511,
		1
	},
	[0.208333333333] = {
		0.97006,
		0.027386,
		0.241317,
		0,
		0.233401,
		0.169555,
		-0.957484,
		0,
		-0.067138,
		0.98514,
		0.158086,
		0,
		0.037479,
		0.59404,
		-0.076441,
		1
	},
	[0.216666666667] = {
		0.987889,
		0.032583,
		0.151701,
		0,
		0.151956,
		-0.005487,
		-0.988372,
		0,
		-0.031372,
		0.999454,
		-0.010372,
		0,
		0.040489,
		0.587275,
		-0.112216,
		1
	},
	[0.225] = {
		0.997875,
		0.01273,
		0.063905,
		0,
		0.064852,
		-0.098748,
		-0.992997,
		0,
		-0.006331,
		0.995031,
		-0.099364,
		0,
		0.046402,
		0.5818,
		-0.162769,
		1
	},
	[0.233333333333] = {
		0.999992,
		-0.003391,
		0.002245,
		0,
		0.001689,
		-0.155951,
		-0.987763,
		0,
		0.003699,
		0.987759,
		-0.155944,
		0,
		0.053766,
		0.576212,
		-0.214991,
		1
	},
	[0.241666666667] = {
		0.999843,
		-0.00014,
		0.017736,
		0,
		0.017217,
		-0.2326,
		-0.97242,
		0,
		0.004261,
		0.972573,
		-0.232561,
		0,
		0.065346,
		0.567184,
		-0.259939,
		1
	},
	[0.258333333333] = {
		0.995748,
		0.030208,
		0.087025,
		0,
		0.090648,
		-0.489444,
		-0.86731,
		0,
		0.016395,
		0.871511,
		-0.490101,
		0,
		0.079313,
		0.532315,
		-0.335872,
		1
	},
	[0.25] = {
		0.998213,
		0.013783,
		0.05814,
		0,
		0.059442,
		-0.327962,
		-0.942819,
		0,
		0.006073,
		0.94459,
		-0.328195,
		0,
		0.076279,
		0.554476,
		-0.300498,
		1
	},
	[0.266666666667] = {
		0.992706,
		0.045896,
		0.111481,
		0,
		0.116266,
		-0.609012,
		-0.784593,
		0,
		0.031883,
		0.791832,
		-0.609906,
		0,
		0.082162,
		0.510105,
		-0.363908,
		1
	},
	[0.275] = {
		0.990215,
		0.043244,
		0.132682,
		0,
		0.13273,
		-0.585459,
		-0.799763,
		0,
		0.043095,
		0.809548,
		-0.58547,
		0,
		0.089076,
		0.504387,
		-0.386516,
		1
	},
	[0.283333333333] = {
		0.988525,
		0.03454,
		0.147056,
		0,
		0.142498,
		-0.536268,
		-0.831932,
		0,
		0.050126,
		0.843341,
		-0.535036,
		0,
		0.101221,
		0.500317,
		-0.408677,
		1
	},
	[0.291666666667] = {
		0.988533,
		0.03143,
		0.147697,
		0,
		0.139906,
		-0.55868,
		-0.817498,
		0,
		0.056822,
		0.828788,
		-0.556671,
		0,
		0.125881,
		0.48583,
		-0.437055,
		1
	},
	[0.2] = {
		0.951342,
		0.03028,
		0.306645,
		0,
		0.262442,
		0.441857,
		-0.857838,
		0,
		-0.161468,
		0.896574,
		0.412411,
		0,
		0.026881,
		0.595632,
		-0.036521,
		1
	},
	[0.308333333333] = {
		0.98734,
		0.060087,
		0.146795,
		0,
		0.150992,
		-0.639527,
		-0.753795,
		0,
		0.048586,
		0.766417,
		-0.640503,
		0,
		0.161538,
		0.443055,
		-0.494979,
		1
	},
	[0.316666666667] = {
		0.985503,
		0.082665,
		0.148154,
		0,
		0.16496,
		-0.670924,
		-0.722945,
		0,
		0.039637,
		0.736904,
		-0.674834,
		0,
		0.167337,
		0.421726,
		-0.517161,
		1
	},
	[0.325] = {
		0.98471,
		0.090575,
		0.148806,
		0,
		0.169944,
		-0.68721,
		-0.706301,
		0,
		0.038288,
		0.72079,
		-0.692095,
		0,
		0.172568,
		0.408124,
		-0.530759,
		1
	},
	[0.333333333333] = {
		0.983983,
		0.097398,
		0.149299,
		0,
		0.17424,
		-0.702363,
		-0.690164,
		0,
		0.037642,
		0.705124,
		-0.708084,
		0,
		0.177708,
		0.394849,
		-0.543771,
		1
	},
	[0.341666666667] = {
		0.983351,
		0.103072,
		0.149656,
		0,
		0.177759,
		-0.716564,
		-0.674491,
		0,
		0.037717,
		0.689864,
		-0.722956,
		0,
		0.182787,
		0.381793,
		-0.556255,
		1
	},
	[0.358333333333] = {
		0.982296,
		0.111723,
		0.150374,
		0,
		0.18315,
		-0.741448,
		-0.645532,
		0,
		0.039374,
		0.661645,
		-0.748783,
		0,
		0.192494,
		0.357102,
		-0.579207,
		1
	},
	[0.35] = {
		0.982793,
		0.10784,
		0.149959,
		0,
		0.1807,
		-0.729563,
		-0.65961,
		0,
		0.038272,
		0.675357,
		-0.736497,
		0,
		0.187689,
		0.369214,
		-0.568068,
		1
	},
	[0.366666666667] = {
		0.9819,
		0.114751,
		0.150682,
		0,
		0.184955,
		-0.752297,
		-0.63233,
		0,
		0.040797,
		0.648754,
		-0.759904,
		0,
		0.197055,
		0.345448,
		-0.589745,
		1
	},
	[0.375] = {
		0.9816,
		0.116948,
		0.150948,
		0,
		0.186151,
		-0.762187,
		-0.620015,
		0,
		0.042541,
		0.636706,
		-0.769932,
		0,
		0.201395,
		0.334238,
		-0.599697,
		1
	},
	[0.383333333333] = {
		0.981389,
		0.11834,
		0.151234,
		0,
		0.186778,
		-0.771188,
		-0.608591,
		0,
		0.04461,
		0.625512,
		-0.778938,
		0,
		0.205539,
		0.323461,
		-0.609079,
		1
	},
	[0.391666666667] = {
		0.981259,
		0.118951,
		0.151599,
		0,
		0.186873,
		-0.779363,
		-0.598056,
		0,
		0.047011,
		0.615177,
		-0.786986,
		0,
		0.209514,
		0.313105,
		-0.617903,
		1
	},
	[0.3] = {
		0.988813,
		0.035681,
		0.144827,
		0,
		0.137158,
		-0.59907,
		-0.788862,
		0,
		0.058614,
		0.799902,
		-0.597262,
		0,
		0.150251,
		0.467018,
		-0.466175,
		1
	},
	[0.408333333333] = {
		0.9812,
		0.117925,
		0.152773,
		0,
		0.185609,
		-0.79347,
		-0.579617,
		0,
		0.05287,
		0.597076,
		-0.800441,
		0,
		0.217077,
		0.293603,
		-0.633922,
		1
	},
	[0.416666666667] = {
		0.981248,
		0.116334,
		0.153682,
		0,
		0.184323,
		-0.799501,
		-0.571685,
		0,
		0.056362,
		0.589292,
		-0.805952,
		0,
		0.220729,
		0.284432,
		-0.641136,
		1
	},
	[0.425] = {
		0.98138,
		0.114063,
		0.154541,
		0,
		0.182469,
		-0.804909,
		-0.564648,
		0,
		0.059986,
		0.582333,
		-0.810734,
		0,
		0.224123,
		0.275632,
		-0.647906,
		1
	},
	[0.433333333333] = {
		0.981563,
		0.111129,
		0.155512,
		0,
		0.180154,
		-0.809731,
		-0.558462,
		0,
		0.063862,
		0.576182,
		-0.814823,
		0,
		0.227367,
		0.267189,
		-0.654213,
		1
	},
	[0.441666666667] = {
		0.981789,
		0.107555,
		0.156594,
		0,
		0.177395,
		-0.814003,
		-0.55311,
		0,
		0.067978,
		0.570817,
		-0.818259,
		0,
		0.230465,
		0.259092,
		-0.660076,
		1
	},
	[0.458333333333] = {
		0.982332,
		0.098572,
		0.159082,
		0,
		0.170616,
		-0.821005,
		-0.544831,
		0,
		0.076902,
		0.562347,
		-0.823318,
		0,
		0.236246,
		0.243882,
		-0.670534,
		1
	},
	[0.45] = {
		0.982049,
		0.103363,
		0.157786,
		0,
		0.174209,
		-0.817752,
		-0.548574,
		0,
		0.072327,
		0.566214,
		-0.821079,
		0,
		0.233423,
		0.251327,
		-0.665511,
		1
	},
	[0.466666666667] = {
		0.982629,
		0.093205,
		0.160477,
		0,
		0.166631,
		-0.823785,
		-0.54186,
		0,
		0.081695,
		0.559188,
		-0.825006,
		0,
		0.238938,
		0.236745,
		-0.675163,
		1
	},
	[0.475] = {
		0.982929,
		0.08728,
		0.161965,
		0,
		0.162275,
		-0.826111,
		-0.539637,
		0,
		0.086702,
		0.556708,
		-0.826171,
		0,
		0.241506,
		0.229904,
		-0.679413,
		1
	},
	[0.483333333333] = {
		0.983221,
		0.080817,
		0.163538,
		0,
		0.157566,
		-0.827999,
		-0.538136,
		0,
		0.091918,
		0.554875,
		-0.82684,
		0,
		0.243956,
		0.223345,
		-0.683299,
		1
	},
	[0.491666666667] = {
		0.983495,
		0.073838,
		0.165185,
		0,
		0.152522,
		-0.829464,
		-0.537333,
		0,
		0.09734,
		0.553658,
		-0.827035,
		0,
		0.246293,
		0.217059,
		-0.686836,
		1
	},
	[0.4] = {
		0.9812,
		0.118804,
		0.152095,
		0,
		0.186471,
		-0.786773,
		-0.588402,
		0,
		0.04976,
		0.605701,
		-0.794135,
		0,
		0.21335,
		0.303157,
		-0.62618,
		1
	},
	[0.508333333333] = {
		0.983942,
		0.058405,
		0.168664,
		0,
		0.141508,
		-0.831174,
		-0.537704,
		0,
		0.108785,
		0.552936,
		-0.826091,
		0,
		0.250651,
		0.20525,
		-0.692927,
		1
	},
	[0.516666666667] = {
		0.984093,
		0.049991,
		0.170474,
		0,
		0.135576,
		-0.831439,
		-0.538822,
		0,
		0.114803,
		0.553363,
		-0.824991,
		0,
		0.252685,
		0.199705,
		-0.695508,
		1
	},
	[0.525] = {
		0.984182,
		0.041139,
		0.172316,
		0,
		0.129387,
		-0.831321,
		-0.540523,
		0,
		0.121013,
		0.554268,
		-0.823494,
		0,
		0.254629,
		0.194382,
		-0.697801,
		1
	},
	[0.533333333333] = {
		0.984198,
		0.031871,
		0.174177,
		0,
		0.122961,
		-0.830828,
		-0.542775,
		0,
		0.127413,
		0.555615,
		-0.821619,
		0,
		0.25649,
		0.18927,
		-0.699818,
		1
	},
	[0.541666666667] = {
		0.984131,
		0.022205,
		0.176047,
		0,
		0.116318,
		-0.829968,
		-0.545549,
		0,
		0.133999,
		0.557369,
		-0.81938,
		0,
		0.258275,
		0.184357,
		-0.701575,
		1
	},
	[0.558333333333] = {
		0.983709,
		0.001772,
		0.17976,
		0,
		0.102458,
		-0.82717,
		-0.552532,
		0,
		0.147713,
		0.561948,
		-0.813876,
		0,
		0.261636,
		0.175078,
		-0.704363,
		1
	},
	[0.55] = {
		0.983971,
		0.012165,
		0.177911,
		0,
		0.109476,
		-0.828746,
		-0.548812,
		0,
		0.140767,
		0.559492,
		-0.816795,
		0,
		0.259988,
		0.17963,
		-0.703085,
		1
	},
	[0.566666666667] = {
		0.983335,
		-0.008953,
		0.181581,
		0,
		0.095281,
		-0.825247,
		-0.556677,
		0,
		0.154833,
		0.564702,
		-0.810641,
		0,
		0.263225,
		0.170689,
		-0.705422,
		1
	},
	[0.575] = {
		0.982842,
		-0.019985,
		0.183362,
		0,
		0.087968,
		-0.822983,
		-0.561214,
		0,
		0.16212,
		0.567715,
		-0.807104,
		0,
		0.264759,
		0.166449,
		-0.706277,
		1
	},
	[0.583333333333] = {
		0.982222,
		-0.031302,
		0.185094,
		0,
		0.080536,
		-0.820386,
		-0.56611,
		0,
		0.169569,
		0.570952,
		-0.803281,
		0,
		0.266247,
		0.162348,
		-0.706943,
		1
	},
	[0.591666666667] = {
		0.981468,
		-0.042879,
		0.186766,
		0,
		0.073006,
		-0.817466,
		-0.571331,
		0,
		0.177173,
		0.574378,
		-0.799187,
		0,
		0.267692,
		0.158372,
		-0.707432,
		1
	},
	[0.5] = {
		0.983739,
		0.06636,
		0.166897,
		0,
		0.147163,
		-0.830519,
		-0.537198,
		0,
		0.102963,
		0.553023,
		-0.826779,
		0,
		0.248523,
		0.211031,
		-0.690041,
		1
	},
	[0.608333333333] = {
		0.979535,
		-0.066715,
		0.189895,
		0,
		0.057731,
		-0.810696,
		-0.582613,
		0,
		0.192816,
		0.581653,
		-0.790254,
		0,
		0.270477,
		0.150748,
		-0.707941,
		1
	},
	[0.616666666667] = {
		0.978347,
		-0.078923,
		0.191335,
		0,
		0.050024,
		-0.80687,
		-0.588608,
		0,
		0.200837,
		0.585434,
		-0.78545,
		0,
		0.271828,
		0.147075,
		-0.70799,
		1
	},
	[0.625] = {
		0.977005,
		-0.091289,
		0.192683,
		0,
		0.042295,
		-0.802766,
		-0.594792,
		0,
		0.208978,
		0.589265,
		-0.780446,
		0,
		0.273158,
		0.143479,
		-0.707921,
		1
	},
	[0.633333333333] = {
		0.975509,
		-0.103788,
		0.193934,
		0,
		0.034562,
		-0.798401,
		-0.601133,
		0,
		0.217228,
		0.593113,
		-0.77526,
		0,
		0.274472,
		0.139947,
		-0.707749,
		1
	},
	[0.641666666667] = {
		0.973856,
		-0.116392,
		0.195083,
		0,
		0.026843,
		-0.793791,
		-0.607598,
		0,
		0.225574,
		0.596949,
		-0.769914,
		0,
		0.275776,
		0.136467,
		-0.707489,
		1
	},
	[0.658333333333] = {
		0.970081,
		-0.141806,
		0.197063,
		0,
		0.011511,
		-0.783912,
		-0.620765,
		0,
		0.242508,
		0.604461,
		-0.758826,
		0,
		0.278368,
		0.129611,
		-0.706766,
		1
	},
	[0.65] = {
		0.972047,
		-0.129074,
		0.196126,
		0,
		0.019154,
		-0.788955,
		-0.614152,
		0,
		0.234006,
		0.600741,
		-0.764429,
		0,
		0.277073,
		0.133026,
		-0.707156,
		1
	},
	[0.666666666667] = {
		0.967962,
		-0.154561,
		0.197892,
		0,
		0.003929,
		-0.778685,
		-0.627403,
		0,
		0.251068,
		0.60808,
		-0.75313,
		0,
		0.279666,
		0.126211,
		-0.706335,
		1
	},
	[0.675] = {
		0.965691,
		-0.167313,
		0.198613,
		0,
		-0.003577,
		-0.773295,
		-0.634036,
		0,
		0.259669,
		0.611572,
		-0.747363,
		0,
		0.280971,
		0.122813,
		-0.705877,
		1
	},
	[0.683333333333] = {
		0.963273,
		-0.180033,
		0.19923,
		0,
		-0.010995,
		-0.767769,
		-0.640632,
		0,
		0.268297,
		0.614913,
		-0.741551,
		0,
		0.282287,
		0.119405,
		-0.705409,
		1
	},
	[0.691666666667] = {
		0.960714,
		-0.192694,
		0.199745,
		0,
		-0.018311,
		-0.762133,
		-0.647161,
		0,
		0.276936,
		0.618079,
		-0.73572,
		0,
		0.283617,
		0.115975,
		-0.704947,
		1
	},
	[0.6] = {
		0.980574,
		-0.054692,
		0.188369,
		0,
		0.065398,
		-0.814233,
		-0.576843,
		0,
		0.184925,
		0.577957,
		-0.794839,
		0,
		0.2691,
		0.154509,
		-0.70776,
		1
	},
	[0.708333333333] = {
		0.955194,
		-0.217734,
		0.20049,
		0,
		-0.032597,
		-0.750643,
		-0.659903,
		0,
		0.294179,
		0.6238,
		-0.724107,
		0,
		0.286337,
		0.108999,
		-0.704105,
		1
	},
	[0.716666666667] = {
		0.952249,
		-0.230059,
		0.200733,
		0,
		-0.039547,
		-0.744849,
		-0.66606,
		0,
		0.302749,
		0.626317,
		-0.71838,
		0,
		0.287733,
		0.105429,
		-0.703758,
		1
	},
	[0.725] = {
		0.949193,
		-0.242221,
		0.200902,
		0,
		-0.046358,
		-0.739065,
		-0.672037,
		0,
		0.311261,
		0.62858,
		-0.712744,
		0,
		0.28916,
		0.101789,
		-0.703483,
		1
	},
	[0.733333333333] = {
		0.946035,
		-0.254194,
		0.201006,
		0,
		-0.053024,
		-0.733323,
		-0.67781,
		0,
		0.319697,
		0.630573,
		-0.707228,
		0,
		0.290618,
		0.098066,
		-0.703296,
		1
	},
	[0.741666666667] = {
		0.942786,
		-0.265953,
		0.201056,
		0,
		-0.059537,
		-0.727658,
		-0.683352,
		0,
		0.32804,
		0.632284,
		-0.701859,
		0,
		0.292113,
		0.094249,
		-0.703214,
		1
	},
	[0.758333333333] = {
		0.936062,
		-0.288737,
		0.201045,
		0,
		-0.072092,
		-0.716696,
		-0.693649,
		0,
		0.34437,
		0.634805,
		-0.691688,
		0,
		0.295223,
		0.086287,
		-0.703435,
		1
	},
	[0.75] = {
		0.939458,
		-0.277475,
		0.201065,
		0,
		-0.065894,
		-0.722103,
		-0.68864,
		0,
		0.33627,
		0.633699,
		-0.69667,
		0,
		0.293647,
		0.090326,
		-0.703255,
		1
	},
	[0.766666666667] = {
		0.932612,
		-0.299716,
		0.20101,
		0,
		-0.078128,
		-0.711472,
		-0.698358,
		0,
		0.352322,
		0.635593,
		-0.686943,
		0,
		0.296844,
		0.082118,
		-0.703772,
		1
	},
	[0.775] = {
		0.929121,
		-0.310391,
		0.200975,
		0,
		-0.084,
		-0.706467,
		-0.702744,
		0,
		0.360107,
		0.636052,
		-0.682466,
		0,
		0.298513,
		0.07781,
		-0.704283,
		1
	},
	[0.783333333333] = {
		0.925604,
		-0.320739,
		0.200957,
		0,
		-0.089709,
		-0.701718,
		-0.706784,
		0,
		0.367708,
		0.636175,
		-0.678286,
		0,
		0.300234,
		0.073351,
		-0.704985,
		1
	},
	[0.791666666667] = {
		0.922075,
		-0.330741,
		0.200971,
		0,
		-0.095254,
		-0.697263,
		-0.710459,
		0,
		0.375107,
		0.635952,
		-0.674433,
		0,
		0.302007,
		0.06873,
		-0.705896,
		1
	},
	[0.7] = {
		0.958018,
		-0.20527,
		0.200163,
		0,
		-0.025515,
		-0.756415,
		-0.653594,
		0,
		0.285569,
		0.621048,
		-0.729897,
		0,
		0.284966,
		0.11251,
		-0.704507,
		1
	},
	[0.808333333333] = {
		0.915039,
		-0.349625,
		0.201163,
		0,
		-0.105861,
		-0.68938,
		-0.716623,
		0,
		0.389227,
		0.634443,
		-0.667821,
		0,
		0.30573,
		0.058956,
		-0.708413,
		1
	},
	[0.816666666667] = {
		0.911564,
		-0.358469,
		0.201376,
		0,
		-0.110925,
		-0.686027,
		-0.719071,
		0,
		0.395913,
		0.633141,
		-0.66512,
		0,
		0.307683,
		0.053783,
		-0.710054,
		1
	},
	[0.825] = {
		0.908138,
		-0.366888,
		0.20169,
		0,
		-0.115835,
		-0.683113,
		-0.721068,
		0,
		0.402329,
		0.631466,
		-0.662859,
		0,
		0.309702,
		0.048403,
		-0.711972,
		1
	},
	[0.833333333333] = {
		0.904777,
		-0.374865,
		0.202124,
		0,
		-0.120592,
		-0.680677,
		-0.72259,
		0,
		0.408455,
		0.629409,
		-0.661067,
		0,
		0.311789,
		0.042807,
		-0.714184,
		1
	},
	[0.841666666667] = {
		0.901499,
		-0.382381,
		0.202694,
		0,
		-0.125201,
		-0.678751,
		-0.723617,
		0,
		0.414276,
		0.626962,
		-0.659768,
		0,
		0.313947,
		0.036983,
		-0.716707,
		1
	},
	[0.858333333333] = {
		0.898293,
		-0.389448,
		0.203469,
		0,
		-0.129707,
		-0.677456,
		-0.724037,
		0,
		0.419816,
		0.624006,
		-0.659068,
		0,
		0.316181,
		0.030808,
		-0.719558,
		1
	},
	[0.85] = {
		0.898318,
		-0.389416,
		0.203419,
		0,
		-0.129663,
		-0.677371,
		-0.724124,
		0,
		0.419776,
		0.624118,
		-0.658988,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[0.866666666667] = {
		0.898281,
		-0.389464,
		0.203492,
		0,
		-0.129728,
		-0.677496,
		-0.723996,
		0,
		0.419835,
		0.623953,
		-0.659106,
		0,
		0.316182,
		0.030755,
		-0.71956,
		1
	},
	[0.875] = {
		0.89828,
		-0.389466,
		0.203495,
		0,
		-0.129731,
		-0.677501,
		-0.723991,
		0,
		0.419838,
		0.623946,
		-0.659111,
		0,
		0.316182,
		0.030748,
		-0.71956,
		1
	},
	[0.883333333333] = {
		0.898285,
		-0.389458,
		0.203484,
		0,
		-0.129721,
		-0.677482,
		-0.72401,
		0,
		0.419829,
		0.623971,
		-0.659093,
		0,
		0.316182,
		0.030773,
		-0.719559,
		1
	},
	[0.891666666667] = {
		0.898295,
		-0.389446,
		0.203465,
		0,
		-0.129704,
		-0.677449,
		-0.724044,
		0,
		0.419813,
		0.624015,
		-0.659062,
		0,
		0.316181,
		0.030817,
		-0.719558,
		1
	},
	[0.8] = {
		0.918548,
		-0.340376,
		0.201034,
		0,
		-0.100638,
		-0.693138,
		-0.713745,
		0,
		0.382286,
		0.635377,
		-0.670935,
		0,
		0.303838,
		0.063935,
		-0.707033,
		1
	},
	[0.908333333333] = {
		0.898315,
		-0.389421,
		0.203426,
		0,
		-0.12967,
		-0.677384,
		-0.724111,
		0,
		0.419782,
		0.624102,
		-0.659,
		0,
		0.316179,
		0.030905,
		-0.719555,
		1
	},
	[0.916666666667] = {
		0.898318,
		-0.389416,
		0.203419,
		0,
		-0.129663,
		-0.677371,
		-0.724124,
		0,
		0.419776,
		0.624118,
		-0.658988,
		0,
		0.316179,
		0.030921,
		-0.719554,
		1
	},
	[0.9] = {
		0.898306,
		-0.389432,
		0.203443,
		0,
		-0.129685,
		-0.677413,
		-0.724081,
		0,
		0.419796,
		0.624063,
		-0.659028,
		0,
		0.31618,
		0.030866,
		-0.719556,
		1
	}
}

return spline_matrices
