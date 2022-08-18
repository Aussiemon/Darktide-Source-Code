local spline_matrices = {
	[0] = {
		-0.036692,
		0.590451,
		0.806239,
		0,
		0.950642,
		-0.228124,
		0.210331,
		0,
		0.308113,
		0.774162,
		-0.552937,
		0,
		0.625285,
		-0.403824,
		-0.514006,
		1
	},
	{
		-0.256155,
		0.588992,
		0.766468,
		0,
		0.961689,
		0.075163,
		0.263639,
		0,
		0.097671,
		0.804636,
		-0.58568,
		0,
		0.811095,
		-0.945936,
		-0.503377,
		1
	},
	[0.0166666666667] = {
		0.121823,
		0.395178,
		0.910491,
		0,
		0.733525,
		-0.653821,
		0.185631,
		0,
		0.668656,
		0.645254,
		-0.369523,
		0,
		1.023395,
		-0.324707,
		-0.519962,
		1
	},
	[0.0333333333333] = {
		0.26564,
		0.108195,
		0.957982,
		0,
		0.463833,
		-0.88546,
		-0.028612,
		0,
		0.845159,
		0.451944,
		-0.285398,
		0,
		1.414054,
		-0.252502,
		-0.495558,
		1
	},
	[0.05] = {
		0.35929,
		-0.196702,
		0.912261,
		0,
		0.373057,
		-0.865759,
		-0.333602,
		0,
		0.855418,
		0.460185,
		-0.237677,
		0,
		1.392951,
		-0.203068,
		-0.42605,
		1
	},
	[0.0666666666667] = {
		0.432863,
		-0.477029,
		0.7649,
		0,
		0.360765,
		-0.68593,
		-0.63194,
		0,
		0.826122,
		0.549493,
		-0.124819,
		0,
		1.334843,
		-0.164535,
		-0.326339,
		1
	},
	[0.0833333333333] = {
		0.48081,
		-0.694911,
		0.534715,
		0,
		0.409594,
		-0.3612,
		-0.837715,
		0,
		0.775277,
		0.621798,
		0.110963,
		0,
		1.250414,
		-0.148483,
		-0.204085,
		1
	},
	[0.116666666667] = {
		0.485335,
		-0.872847,
		-0.050878,
		0,
		0.624468,
		0.38678,
		-0.678558,
		0,
		0.611956,
		0.297556,
		0.732783,
		0,
		1.038462,
		-0.194839,
		0.039654,
		1
	},
	[0.133333333333] = {
		0.446501,
		-0.821917,
		-0.35368,
		0,
		0.743552,
		0.560707,
		-0.364332,
		0,
		0.497762,
		-0.100305,
		0.861494,
		0,
		0.928205,
		-0.235294,
		0.134915,
		1
	},
	[0.15] = {
		0.393719,
		-0.673529,
		-0.625575,
		0,
		0.836428,
		0.544771,
		-0.060108,
		0,
		0.38128,
		-0.499583,
		0.777845,
		0,
		0.826978,
		-0.270047,
		0.213327,
		1
	},
	[0.166666666667] = {
		0.340505,
		-0.441397,
		-0.830196,
		0,
		0.892415,
		0.429743,
		0.137539,
		0,
		0.296061,
		-0.787712,
		0.540239,
		0,
		0.743321,
		-0.296515,
		0.281749,
		1
	},
	[0.183333333333] = {
		0.27889,
		-0.146739,
		-0.949046,
		0,
		0.924186,
		0.309563,
		0.223721,
		0,
		0.260961,
		-0.939488,
		0.221948,
		0,
		0.670998,
		-0.319162,
		0.34456,
		1
	},
	[0.1] = {
		0.498554,
		-0.829071,
		0.253151,
		0,
		0.504126,
		0.039727,
		-0.862716,
		0,
		0.705196,
		0.55773,
		0.437762,
		0,
		1.148788,
		-0.1608,
		-0.076076,
		1
	},
	[0.216666666667] = {
		0.163264,
		0.46405,
		-0.870633,
		0,
		0.953244,
		0.153271,
		0.260449,
		0,
		0.254304,
		-0.872448,
		-0.417329,
		0,
		0.54637,
		-0.342456,
		0.444282,
		1
	},
	[0.233333333333] = {
		0.152749,
		0.672081,
		-0.724552,
		0,
		0.958183,
		0.078796,
		0.275093,
		0,
		0.241977,
		-0.736273,
		-0.63194,
		0,
		0.50915,
		-0.329544,
		0.486741,
		1
	},
	[0.25] = {
		0.177427,
		0.800682,
		-0.572213,
		0,
		0.96031,
		-0.013697,
		0.278599,
		0,
		0.215232,
		-0.598933,
		-0.771333,
		0,
		0.481295,
		-0.301895,
		0.531787,
		1
	},
	[0.266666666667] = {
		0.214601,
		0.873687,
		-0.436598,
		0,
		0.958549,
		-0.102617,
		0.265806,
		0,
		0.187428,
		-0.475543,
		-0.859494,
		0,
		0.448541,
		-0.267116,
		0.579756,
		1
	},
	[0.283333333333] = {
		0.255205,
		0.907866,
		-0.332641,
		0,
		0.95419,
		-0.180911,
		0.23831,
		0,
		0.156176,
		-0.378221,
		-0.912446,
		0,
		0.41157,
		-0.229557,
		0.630459,
		1
	},
	[0.2] = {
		0.212083,
		0.17604,
		-0.961265,
		0,
		0.943725,
		0.218544,
		0.248236,
		0,
		0.253778,
		-0.959817,
		-0.119784,
		0,
		0.602848,
		-0.337139,
		0.399019,
		1
	},
	[0.316666666667] = {
		0.318516,
		0.916583,
		-0.241708,
		0,
		0.944877,
		-0.286592,
		0.158345,
		0,
		0.075865,
		-0.278819,
		-0.957342,
		0,
		0.326515,
		-0.158701,
		0.734212,
		1
	},
	[0.333333333333] = {
		0.329581,
		0.908879,
		-0.25557,
		0,
		0.943756,
		-0.309563,
		0.116165,
		0,
		0.026465,
		-0.279481,
		-0.959786,
		0,
		0.279088,
		-0.129245,
		0.783739,
		1
	},
	[0.35] = {
		0.319781,
		0.894611,
		-0.312108,
		0,
		0.947023,
		-0.31214,
		0.0756,
		0,
		-0.029789,
		-0.319749,
		-0.947034,
		0,
		0.220469,
		-0.080035,
		0.830108,
		1
	},
	[0.366666666667] = {
		0.287181,
		0.862805,
		-0.416046,
		0,
		0.953177,
		-0.30038,
		0.035008,
		0,
		-0.094767,
		-0.40662,
		-0.908669,
		0,
		0.143956,
		0.006178,
		0.873317,
		1
	},
	[0.383333333333] = {
		0.231429,
		0.795619,
		-0.559849,
		0,
		0.959041,
		-0.283204,
		-0.006024,
		0,
		-0.163345,
		-0.535524,
		-0.828573,
		0,
		0.053568,
		0.119476,
		0.912817,
		1
	},
	[0.3] = {
		0.291901,
		0.918397,
		-0.267098,
		0,
		0.948978,
		-0.243263,
		0.200661,
		0,
		0.119312,
		-0.312043,
		-0.942547,
		0,
		0.370791,
		-0.192624,
		0.682539,
		1
	},
	[0.416666666667] = {
		0.058104,
		0.482994,
		-0.873694,
		0,
		0.962784,
		-0.258505,
		-0.078878,
		0,
		-0.263952,
		-0.836595,
		-0.480039,
		0,
		-0.145973,
		0.390662,
		0.972701,
		1
	},
	[0.433333333333] = {
		-0.04013,
		0.202165,
		-0.978529,
		0,
		0.963358,
		-0.252095,
		-0.091591,
		0,
		-0.265199,
		-0.946349,
		-0.184641,
		0,
		-0.220385,
		0.519641,
		0.965266,
		1
	},
	[0.45] = {
		-0.148286,
		-0.265088,
		-0.952754,
		0,
		0.937425,
		-0.344574,
		-0.050029,
		0,
		-0.315032,
		-0.900554,
		0.299596,
		0,
		-0.222815,
		0.711844,
		0.91462,
		1
	},
	[0.466666666667] = {
		-0.299837,
		-0.727084,
		-0.617614,
		0,
		0.867351,
		-0.477344,
		0.140872,
		0,
		-0.39724,
		-0.493449,
		0.773762,
		0,
		-0.153338,
		0.975034,
		0.779076,
		1
	},
	[0.483333333333] = {
		-0.389566,
		-0.908639,
		-0.150381,
		0,
		0.83103,
		-0.41718,
		0.367898,
		0,
		-0.397022,
		0.01835,
		0.917626,
		0,
		-0.07236,
		1.164103,
		0.512733,
		1
	},
	[0.4] = {
		0.152861,
		0.674654,
		-0.722132,
		0,
		0.962605,
		-0.267025,
		-0.045705,
		0,
		-0.223662,
		-0.688142,
		-0.690243,
		0,
		-0.044758,
		0.250571,
		0.947038,
		1
	},
	[0.516666666667] = {
		-0.487845,
		-0.586201,
		0.64682,
		0,
		0.83901,
		-0.110323,
		0.532814,
		0,
		-0.240977,
		0.802619,
		0.545649,
		0,
		0.089832,
		1.464805,
		-0.223535,
		1
	},
	[0.533333333333] = {
		-0.403423,
		-0.246081,
		0.881302,
		0,
		0.877667,
		0.168293,
		0.448751,
		0,
		-0.258746,
		0.954527,
		0.148084,
		0,
		0.203842,
		1.488585,
		-0.544532,
		1
	},
	[0.55] = {
		-0.394595,
		0.604822,
		0.691727,
		0,
		0.910634,
		0.35789,
		0.206543,
		0,
		-0.12264,
		0.711411,
		-0.691993,
		0,
		0.470535,
		1.102276,
		-0.95897,
		1
	},
	[0.566666666667] = {
		-0.370518,
		0.783957,
		0.498124,
		0,
		0.859904,
		0.492253,
		-0.135097,
		0,
		-0.351114,
		0.378284,
		-0.856517,
		0,
		0.132915,
		0.665527,
		-1.227139,
		1
	},
	[0.583333333333] = {
		-0.226467,
		0.948965,
		0.219494,
		0,
		0.87387,
		0.297484,
		-0.384518,
		0,
		-0.43019,
		0.104728,
		-0.896643,
		0,
		-0.084364,
		0.333519,
		-1.328482,
		1
	},
	[0.5] = {
		-0.44986,
		-0.843017,
		0.294869,
		0,
		0.837781,
		-0.283939,
		0.466371,
		0,
		-0.309434,
		0.456838,
		0.833996,
		0,
		0.002437,
		1.331357,
		0.16306,
		1
	},
	[0.616666666667] = {
		-0.33579,
		0.913474,
		0.229804,
		0,
		0.940322,
		0.339365,
		0.025021,
		0,
		-0.055131,
		0.224492,
		-0.972915,
		0,
		0.087954,
		0.112815,
		-1.301466,
		1
	},
	[0.633333333333] = {
		-0.28552,
		0.891021,
		0.352931,
		0,
		0.95417,
		0.22984,
		0.19166,
		0,
		0.089655,
		0.391479,
		-0.915809,
		0,
		0.203861,
		0.034816,
		-1.287666,
		1
	},
	[0.65] = {
		-0.211004,
		0.851675,
		0.479715,
		0,
		0.950368,
		0.06395,
		0.304486,
		0,
		0.228646,
		0.520153,
		-0.822898,
		0,
		0.32459,
		-0.037723,
		-1.278401,
		1
	},
	[0.666666666667] = {
		-0.127664,
		0.804543,
		0.58001,
		0,
		0.926386,
		-0.112161,
		0.359483,
		0,
		0.354274,
		0.583207,
		-0.730999,
		0,
		0.436235,
		-0.10531,
		-1.282864,
		1
	},
	[0.683333333333] = {
		-0.050919,
		0.762794,
		0.644633,
		0,
		0.892492,
		-0.254907,
		0.372129,
		0,
		0.448179,
		0.594279,
		-0.667808,
		0,
		0.522902,
		-0.165625,
		-1.314479,
		1
	},
	[0.6] = {
		-0.341193,
		0.926262,
		0.160084,
		0,
		0.91431,
		0.36656,
		-0.172254,
		0,
		-0.218232,
		0.087594,
		-0.971958,
		0,
		-0.011798,
		0.195734,
		-1.316459,
		1
	},
	[0.716666666667] = {
		0.001192,
		0.683641,
		0.729817,
		0,
		0.798391,
		-0.440102,
		0.410952,
		0,
		0.602138,
		0.58219,
		-0.546338,
		0,
		0.668494,
		-0.20938,
		-1.361694,
		1
	},
	[0.733333333333] = {
		-0.00306,
		0.628551,
		0.777762,
		0,
		0.722363,
		-0.536444,
		0.436371,
		0,
		0.691507,
		0.563162,
		-0.452401,
		0,
		0.764263,
		-0.219662,
		-1.368262,
		1
	},
	[0.75] = {
		-0.023408,
		0.565848,
		0.824177,
		0,
		0.628719,
		-0.632636,
		0.4522,
		0,
		0.777281,
		0.528761,
		-0.34095,
		0,
		0.869051,
		-0.231839,
		-1.367952,
		1
	},
	[0.766666666667] = {
		-0.059191,
		0.502733,
		0.862413,
		0,
		0.525989,
		-0.718561,
		0.454978,
		0,
		0.848429,
		0.48055,
		-0.2219,
		0,
		0.973036,
		-0.247429,
		-1.361217,
		1
	},
	[0.783333333333] = {
		-0.105096,
		0.44694,
		0.888369,
		0,
		0.426303,
		-0.786825,
		0.446286,
		0,
		0.898454,
		0.425617,
		-0.10784,
		0,
		1.065756,
		-0.267287,
		-1.349576,
		1
	},
	[0.7] = {
		-0.007424,
		0.726532,
		0.687093,
		0,
		0.853666,
		-0.353231,
		0.38273,
		0,
		0.520768,
		0.589389,
		-0.617593,
		0,
		0.59055,
		-0.199436,
		-1.348506,
		1
	},
	[0.816666666667] = {
		-0.193727,
		0.370832,
		0.908269,
		0,
		0.280158,
		-0.866345,
		0.413471,
		0,
		0.940203,
		0.334559,
		0.063943,
		0,
		1.173116,
		-0.337383,
		-1.269683,
		1
	},
	[0.833333333333] = {
		-0.225092,
		0.349688,
		0.909424,
		0,
		0.244607,
		-0.883204,
		0.400149,
		0,
		0.943134,
		0.312521,
		0.113266,
		0,
		1.169485,
		-0.387326,
		-1.199881,
		1
	},
	[0.85] = {
		-0.202385,
		0.385293,
		0.900327,
		0,
		0.367615,
		-0.82223,
		0.434508,
		0,
		0.907689,
		0.418912,
		0.024768,
		0,
		1.119317,
		-0.447812,
		-1.129846,
		1
	},
	[0.866666666667] = {
		-0.183749,
		0.422414,
		0.887582,
		0,
		0.489984,
		-0.743418,
		0.455241,
		0,
		0.852145,
		0.518552,
		-0.070374,
		0,
		1.068259,
		-0.514248,
		-1.048845,
		1
	},
	[0.883333333333] = {
		-0.171039,
		0.459835,
		0.871377,
		0,
		0.605071,
		-0.648964,
		0.461232,
		0,
		0.777583,
		0.606133,
		-0.167235,
		0,
		1.018015,
		-0.584883,
		-0.960522,
		1
	},
	[0.8] = {
		-0.152384,
		0.402814,
		0.902508,
		0,
		0.341628,
		-0.835414,
		0.430551,
		0,
		0.927399,
		0.373931,
		-0.010309,
		0,
		1.135852,
		-0.296334,
		-1.321776,
		1
	},
	[0.916666666667] = {
		-0.167351,
		0.527536,
		0.832886,
		0,
		0.792507,
		-0.43054,
		0.431935,
		0,
		0.586453,
		0.732353,
		-0.346025,
		0,
		0.92693,
		-0.727368,
		-0.778319,
		1
	},
	[0.933333333333] = {
		-0.176201,
		0.554076,
		0.813605,
		0,
		0.859092,
		-0.316933,
		0.401888,
		0,
		0.480535,
		0.769775,
		-0.420159,
		0,
		0.889072,
		-0.793007,
		-0.693293,
		1
	},
	[0.95] = {
		-0.190911,
		0.573964,
		0.796315,
		0,
		0.907183,
		-0.20669,
		0.366467,
		0,
		0.374929,
		0.792366,
		-0.481231,
		0,
		0.857848,
		-0.850685,
		-0.618537,
		1
	},
	[0.966666666667] = {
		-0.210076,
		0.586529,
		0.78221,
		0,
		0.938505,
		-0.103245,
		0.329468,
		0,
		0.274001,
		0.803321,
		-0.528771,
		0,
		0.834053,
		-0.897331,
		-0.558813,
		1
	},
	[0.983333333333] = {
		-0.232255,
		0.591529,
		0.772108,
		0,
		0.955684,
		-0.008859,
		0.294262,
		0,
		0.180904,
		0.806235,
		-0.563257,
		0,
		0.818298,
		-0.930014,
		-0.518866,
		1
	},
	[0.9] = {
		-0.165463,
		0.495551,
		0.852673,
		0,
		0.707227,
		-0.542961,
		0.452795,
		0,
		0.687351,
		0.677954,
		-0.260627,
		0,
		0.970363,
		-0.656936,
		-0.868911,
		1
	}
}

return spline_matrices
