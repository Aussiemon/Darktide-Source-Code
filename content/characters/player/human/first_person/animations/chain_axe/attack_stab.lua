local spline_matrices = {
	[0] = {
		0.212471,
		-0.389595,
		0.896143,
		0,
		0.977042,
		0.099401,
		-0.188437,
		0,
		-0.015664,
		0.915606,
		0.401771,
		0,
		0.215887,
		-0.359014,
		-0.368952,
		1
	},
	{
		-0.045456,
		-0.180048,
		0.982607,
		0,
		0.991584,
		0.111229,
		0.066253,
		0,
		-0.121223,
		0.977349,
		0.173476,
		0,
		0.664572,
		-0.401499,
		-0.074552,
		1
	},
	[0.0333333333333] = {
		0.215327,
		-0.398845,
		0.891379,
		0,
		0.97652,
		0.081784,
		-0.1993,
		0,
		0.00659,
		0.913364,
		0.407091,
		0,
		0.218107,
		-0.358862,
		-0.369226,
		1
	},
	[0.0666666666667] = {
		0.221131,
		-0.420163,
		0.880093,
		0,
		0.973538,
		0.041751,
		-0.224678,
		0,
		0.057657,
		0.906488,
		0.418277,
		0,
		0.223206,
		-0.358545,
		-0.369921,
		1
	},
	[0.133333333333] = {
		0.229346,
		-0.461443,
		0.857012,
		0,
		0.960851,
		-0.03329,
		-0.275059,
		0,
		0.155454,
		0.886545,
		0.435743,
		0,
		0.233103,
		-0.357971,
		-0.371527,
		1
	},
	[0.166666666667] = {
		0.229998,
		-0.464583,
		0.85514,
		0,
		0.959875,
		-0.03657,
		-0.278035,
		0,
		0.160443,
		0.884774,
		0.43753,
		0,
		0.234627,
		-0.357257,
		-0.371775,
		1
	},
	[0.1] = {
		0.226351,
		-0.443992,
		0.866969,
		0,
		0.967312,
		-0.002018,
		-0.253582,
		0,
		0.114338,
		0.896028,
		0.429022,
		0,
		0.228895,
		-0.358224,
		-0.370804,
		1
	},
	[0.233333333333] = {
		0.282917,
		-0.262446,
		0.92254,
		0,
		0.764526,
		0.642518,
		-0.051674,
		0,
		-0.579187,
		0.719926,
		0.382426,
		0,
		0.188134,
		-0.344439,
		-0.367914,
		1
	},
	[0.266666666667] = {
		0.261878,
		-0.165605,
		0.950786,
		0,
		0.271192,
		0.958101,
		0.092184,
		0,
		-0.926215,
		0.233705,
		0.295816,
		0,
		0.152823,
		-0.074278,
		-0.307997,
		1
	},
	[0.2] = {
		0.282347,
		-0.36884,
		0.885572,
		0,
		0.936843,
		0.304641,
		-0.171811,
		0,
		-0.20641,
		0.878152,
		0.43156,
		0,
		0.214,
		-0.34651,
		-0.368947,
		1
	},
	[0.333333333333] = {
		-0.000868,
		-0.142646,
		0.989773,
		0,
		0.467103,
		0.875103,
		0.12653,
		0,
		-0.884203,
		0.462436,
		0.065871,
		0,
		0.177135,
		0.637048,
		-0.12831,
		1
	},
	[0.366666666667] = {
		0.188898,
		-0.086805,
		0.978152,
		0,
		0.760932,
		0.64257,
		-0.089925,
		0,
		-0.620726,
		0.761294,
		0.187433,
		0,
		0.157123,
		0.660851,
		-0.099408,
		1
	},
	[0.3] = {
		0.172192,
		-0.021431,
		0.98483,
		0,
		-0.17812,
		0.982606,
		0.052526,
		0,
		-0.968826,
		-0.184463,
		0.165379,
		0,
		0.139445,
		0.418638,
		-0.21726,
		1
	},
	[0.433333333333] = {
		0.164099,
		-0.0732,
		0.983724,
		0,
		0.842716,
		0.528754,
		-0.101231,
		0,
		-0.512738,
		0.845612,
		0.148455,
		0,
		0.156091,
		0.639628,
		-0.086742,
		1
	},
	[0.466666666667] = {
		0.122666,
		-0.076442,
		0.9895,
		0,
		0.853664,
		0.516636,
		-0.065915,
		0,
		-0.506172,
		0.852786,
		0.12863,
		0,
		0.153931,
		0.641078,
		-0.079927,
		1
	},
	[0.4] = {
		0.196654,
		-0.082797,
		0.976971,
		0,
		0.819666,
		0.560667,
		-0.117475,
		0,
		-0.538029,
		0.823891,
		0.178123,
		0,
		0.16464,
		0.640906,
		-0.101805,
		1
	},
	[0.533333333333] = {
		0.032559,
		-0.083224,
		0.995999,
		0,
		0.87154,
		0.490166,
		0.012467,
		0,
		-0.489242,
		0.867647,
		0.088493,
		0,
		0.171572,
		0.647642,
		-0.072587,
		1
	},
	[0.566666666667] = {
		-0.022859,
		-0.086349,
		0.996003,
		0,
		0.876128,
		0.478131,
		0.06156,
		0,
		-0.481535,
		0.874034,
		0.064723,
		0,
		0.1822,
		0.651584,
		-0.068549,
		1
	},
	[0.5] = {
		0.082776,
		-0.079572,
		0.993386,
		0,
		0.86393,
		0.502612,
		-0.031729,
		0,
		-0.496763,
		0.860842,
		0.110348,
		0,
		0.161265,
		0.643947,
		-0.076374,
		1
	},
	[0.633333333333] = {
		-0.126536,
		-0.085224,
		0.988294,
		0,
		0.880278,
		0.449627,
		0.151479,
		0,
		-0.457274,
		0.889141,
		0.018127,
		0,
		0.196467,
		0.657522,
		-0.064777,
		1
	},
	[0.666666666667] = {
		-0.16079,
		-0.078537,
		0.983859,
		0,
		0.883253,
		0.433409,
		0.178945,
		0,
		-0.440467,
		0.897769,
		-0.00032,
		0,
		0.205786,
		0.660177,
		-0.06624,
		1
	},
	[0.6] = {
		-0.078182,
		-0.087133,
		0.993124,
		0,
		0.878112,
		0.465642,
		0.109981,
		0,
		-0.472023,
		0.880673,
		0.040108,
		0,
		0.190511,
		0.65515,
		-0.06464,
		1
	},
	[0.733333333333] = {
		-0.165605,
		-0.063632,
		0.984137,
		0,
		0.877064,
		0.446783,
		0.176475,
		0,
		-0.450925,
		0.892377,
		-0.01818,
		0,
		0.229851,
		0.671197,
		-0.058054,
		1
	},
	[0.766666666667] = {
		-0.059437,
		-0.081427,
		0.994905,
		0,
		0.875838,
		0.473926,
		0.091112,
		0,
		-0.478931,
		0.876792,
		0.043148,
		0,
		0.21669,
		0.674614,
		-0.065138,
		1
	},
	[0.7] = {
		-0.180248,
		-0.063909,
		0.981543,
		0,
		0.879282,
		0.436803,
		0.18991,
		0,
		-0.440878,
		0.897284,
		-0.022539,
		0,
		0.220192,
		0.669264,
		-0.058736,
		1
	},
	[0.833333333333] = {
		-0.175744,
		-0.099677,
		0.979377,
		0,
		0.856062,
		0.475752,
		0.202036,
		0,
		-0.486078,
		0.873913,
		0.001719,
		0,
		0.346366,
		0.43514,
		-0.056032,
		1
	},
	[0.866666666667] = {
		-0.186302,
		-0.116942,
		0.975508,
		0,
		0.848891,
		0.480723,
		0.219749,
		0,
		-0.494647,
		0.86904,
		0.009711,
		0,
		0.504651,
		0.190279,
		-0.0511,
		1
	},
	[0.8] = {
		-0.094845,
		-0.090982,
		0.991326,
		0,
		0.867992,
		0.480036,
		0.127102,
		0,
		-0.487436,
		0.872518,
		0.033442,
		0,
		0.239607,
		0.606714,
		-0.063123,
		1
	},
	[0.933333333333] = {
		-0.166467,
		-0.144431,
		0.975412,
		0,
		0.888171,
		0.407714,
		0.211949,
		0,
		-0.428301,
		0.901615,
		0.060408,
		0,
		0.720878,
		-0.230754,
		-0.046521,
		1
	},
	[0.966666666667] = {
		-0.11601,
		-0.156894,
		0.980778,
		0,
		0.944941,
		0.286765,
		0.157644,
		0,
		-0.305986,
		0.945066,
		0.114988,
		0,
		0.7088,
		-0.327648,
		-0.054323,
		1
	},
	[0.9] = {
		-0.187576,
		-0.132644,
		0.973253,
		0,
		0.854865,
		0.465942,
		0.228262,
		0,
		-0.483757,
		0.874816,
		0.025993,
		0,
		0.651472,
		-0.057475,
		-0.047752,
		1
	},
	[1.03333333333] = {
		0.031888,
		-0.220199,
		0.974934,
		0,
		0.993859,
		-0.09642,
		-0.054284,
		0,
		0.105957,
		0.970678,
		0.215772,
		0,
		0.602377,
		-0.456872,
		-0.102143,
		1
	},
	[1.06666666667] = {
		0.100953,
		-0.27684,
		0.955598,
		0,
		0.934672,
		-0.302703,
		-0.186437,
		0,
		0.340875,
		0.911993,
		0.228196,
		0,
		0.537044,
		-0.496541,
		-0.131256,
		1
	},
	[1.13333333333] = {
		0.179,
		-0.40918,
		0.894724,
		0,
		0.678695,
		-0.607027,
		-0.413389,
		0,
		0.712272,
		0.681241,
		0.169051,
		0,
		0.46187,
		-0.538519,
		-0.16872,
		1
	},
	[1.16666666667] = {
		0.178501,
		-0.409612,
		0.894626,
		0,
		0.675307,
		-0.610272,
		-0.414159,
		0,
		0.71561,
		0.678075,
		0.167679,
		0,
		0.459167,
		-0.540678,
		-0.16919,
		1
	},
	[1.1] = {
		0.151023,
		-0.34284,
		0.927175,
		0,
		0.82177,
		-0.477777,
		-0.310521,
		0,
		0.549442,
		0.80882,
		0.20958,
		0,
		0.484477,
		-0.522839,
		-0.155574,
		1
	},
	[1.23333333333] = {
		0.177879,
		-0.410435,
		0.894373,
		0,
		0.67109,
		-0.614135,
		-0.415302,
		0,
		0.719721,
		0.674078,
		0.166197,
		0,
		0.455805,
		-0.543282,
		-0.169942,
		1
	},
	[1.2] = {
		0.178106,
		-0.410084,
		0.894488,
		0,
		0.672631,
		-0.612753,
		-0.414852,
		0,
		0.718224,
		0.675548,
		0.1667,
		0,
		0.457033,
		-0.542344,
		-0.169638,
		1
	}
}

return spline_matrices
