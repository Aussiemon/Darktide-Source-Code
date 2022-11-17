local spline_matrices = {
	[0] = {
		0.297327,
		-0.744727,
		0.597476,
		0,
		-0.917189,
		-0.048934,
		0.395435,
		0,
		-0.265254,
		-0.665572,
		-0.697606,
		0,
		-0.775519,
		0.759657,
		-0.364574,
		1
	},
	[0.0333333333333] = {
		0.155138,
		-0.812647,
		0.561726,
		0,
		-0.9828,
		-0.069296,
		0.17118,
		0,
		-0.100184,
		-0.578621,
		-0.80942,
		0,
		-0.890179,
		0.668652,
		-0.396163,
		1
	},
	[0.0666666666667] = {
		0.081448,
		-0.84805,
		0.523619,
		0,
		-0.966522,
		-0.19546,
		-0.166224,
		0,
		0.243313,
		-0.492551,
		-0.835579,
		0,
		-0.917555,
		0.413828,
		-0.509595,
		1
	},
	[0.133333333333] = {
		-0.13679,
		-0.90729,
		0.397633,
		0,
		-0.901304,
		-0.05256,
		-0.429986,
		0,
		0.411022,
		-0.417207,
		-0.810555,
		0,
		-0.846934,
		0.272851,
		-0.652992,
		1
	},
	[0.166666666667] = {
		-0.37986,
		-0.88415,
		0.272003,
		0,
		-0.886984,
		0.264653,
		-0.378441,
		0,
		0.262612,
		-0.385017,
		-0.884758,
		0,
		-0.808916,
		0.404172,
		-0.688401,
		1
	},
	[0.1] = {
		0.021807,
		-0.868844,
		0.494606,
		0,
		-0.891401,
		-0.240907,
		-0.383885,
		0,
		0.45269,
		-0.432521,
		-0.779742,
		0,
		-0.883027,
		0.243845,
		-0.602944,
		1
	},
	[0.233333333333] = {
		-0.524658,
		-0.744258,
		0.413297,
		0,
		-0.847694,
		0.412012,
		-0.334157,
		0,
		0.078416,
		-0.525668,
		-0.847068,
		0,
		-0.716346,
		0.655556,
		-0.728845,
		1
	},
	[0.266666666667] = {
		0.059763,
		-0.313758,
		0.94762,
		0,
		-0.900545,
		-0.426488,
		-0.084416,
		0,
		0.430635,
		-0.84833,
		-0.308042,
		0,
		-0.528537,
		0.799433,
		-0.471842,
		1
	},
	[0.2] = {
		-0.555711,
		-0.793084,
		0.249407,
		0,
		-0.82099,
		0.476222,
		-0.314942,
		0,
		0.131002,
		-0.379777,
		-0.915755,
		0,
		-0.758035,
		0.555427,
		-0.71068,
		1
	},
	[0.333333333333] = {
		-0.944834,
		-0.083415,
		-0.316751,
		0,
		-0.319157,
		0.016939,
		0.94755,
		0,
		-0.073674,
		0.996371,
		-0.042627,
		0,
		0.419075,
		1.202129,
		0.717058,
		1
	},
	[0.366666666667] = {
		-0.83781,
		-0.298661,
		0.457031,
		0,
		0.503638,
		-0.099613,
		0.858153,
		0,
		-0.21077,
		0.949147,
		0.233873,
		0,
		1.013662,
		0.716185,
		0.8442,
		1
	},
	[0.3] = {
		-0.592466,
		-0.271484,
		0.758472,
		0,
		-0.451857,
		0.891447,
		-0.03388,
		0,
		-0.66694,
		-0.362794,
		-0.650824,
		0,
		0.094917,
		1.494403,
		-0.086534,
		1
	},
	[0.433333333333] = {
		-0.554176,
		-0.697535,
		0.45424,
		0,
		0.829389,
		-0.509077,
		0.230117,
		0,
		0.070728,
		0.504267,
		0.860647,
		0,
		1.354179,
		0.123953,
		0.678163,
		1
	},
	[0.466666666667] = {
		-0.319412,
		-0.784391,
		0.531702,
		0,
		0.914329,
		-0.402516,
		-0.04454,
		0,
		0.248955,
		0.471924,
		0.84576,
		0,
		1.269864,
		0.047142,
		0.297033,
		1
	},
	[0.4] = {
		-0.803972,
		-0.362921,
		0.47108,
		0,
		0.593504,
		-0.440194,
		0.673782,
		0,
		-0.037162,
		0.82129,
		0.569299,
		0,
		1.189439,
		0.523713,
		0.851221,
		1
	},
	[0.533333333333] = {
		0.456495,
		-0.673779,
		0.581063,
		0,
		0.757475,
		-0.048285,
		-0.651077,
		0,
		0.466738,
		0.737353,
		0.488329,
		0,
		0.893916,
		0.074298,
		-0.826327,
		1
	},
	[0.566666666667] = {
		0.77534,
		-0.505592,
		0.37845,
		0,
		0.452298,
		0.026314,
		-0.891479,
		0,
		0.440766,
		0.862371,
		0.249081,
		0,
		0.687539,
		0.138416,
		-1.193722,
		1
	},
	[0.5] = {
		0.037848,
		-0.787209,
		0.615523,
		0,
		0.915046,
		-0.220228,
		-0.337921,
		0,
		0.401569,
		0.576022,
		0.711998,
		0,
		1.105164,
		0.036002,
		-0.263892,
		1
	},
	[0.633333333333] = {
		0.875636,
		-0.431785,
		0.216389,
		0,
		0.262382,
		0.049134,
		-0.963712,
		0,
		0.405485,
		0.900637,
		0.156316,
		0,
		0.547953,
		0.248916,
		-1.215136,
		1
	},
	[0.666666666667] = {
		0.873749,
		-0.437554,
		0.212389,
		0,
		0.26268,
		0.057006,
		-0.963198,
		0,
		0.409344,
		0.897383,
		0.164746,
		0,
		0.54913,
		0.257898,
		-1.212729,
		1
	},
	[0.6] = {
		0.868905,
		-0.439501,
		0.227691,
		0,
		0.270372,
		0.036111,
		-0.962079,
		0,
		0.414612,
		0.897516,
		0.150206,
		0,
		0.57619,
		0.211248,
		-1.229583,
		1
	},
	[0.733333333333] = {
		0.871582,
		-0.4442,
		0.207438,
		0,
		0.263012,
		0.066588,
		-0.962492,
		0,
		0.413726,
		0.89345,
		0.174867,
		0,
		0.550458,
		0.268878,
		-1.209738,
		1
	},
	[0.766666666667] = {
		0.87148,
		-0.444516,
		0.207191,
		0,
		0.263027,
		0.067063,
		-0.962455,
		0,
		0.413932,
		0.893257,
		0.175364,
		0,
		0.55052,
		0.269425,
		-1.209589,
		1
	},
	[0.7] = {
		0.87235,
		-0.441841,
		0.209242,
		0,
		0.262895,
		0.063115,
		-0.962758,
		0,
		0.41218,
		0.89487,
		0.171217,
		0,
		0.54999,
		0.264892,
		-1.21083,
		1
	}
}

return spline_matrices
