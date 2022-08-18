local spline_matrices = {
	[0] = {
		0.121721,
		0.962331,
		0.243113,
		0,
		0.942639,
		-0.188781,
		0.275308,
		0,
		0.310832,
		0.195657,
		-0.930108,
		0,
		0.632101,
		-0.443587,
		-0.534843,
		1
	},
	{
		0.477152,
		0.807118,
		0.347687,
		0,
		0.87871,
		-0.431889,
		-0.203323,
		0,
		-0.013944,
		0.402532,
		-0.9153,
		0,
		0.53252,
		-0.350603,
		-1.501917,
		1
	},
	[0.0333333333333] = {
		0.15592,
		0.709414,
		0.687329,
		0,
		0.951337,
		-0.295092,
		0.088765,
		0,
		0.265796,
		0.640041,
		-0.720902,
		0,
		0.629728,
		-0.332369,
		-0.527238,
		1
	},
	[0.0666666666667] = {
		0.23207,
		0.168684,
		0.957961,
		0,
		0.936432,
		-0.305165,
		-0.173119,
		0,
		0.263134,
		0.937241,
		-0.228781,
		0,
		0.646812,
		-0.214442,
		-0.454768,
		1
	},
	[0.133333333333] = {
		0.281183,
		-0.913891,
		0.292813,
		0,
		0.882819,
		0.126705,
		-0.452302,
		0,
		0.376254,
		0.38568,
		0.842427,
		0,
		0.734971,
		-0.172394,
		-0.202577,
		1
	},
	[0.166666666667] = {
		0.21995,
		-0.917881,
		-0.330327,
		0,
		0.891134,
		0.326815,
		-0.314756,
		0,
		0.396865,
		-0.225135,
		0.889838,
		0,
		0.779856,
		-0.240365,
		-0.142598,
		1
	},
	[0.1] = {
		0.289739,
		-0.487648,
		0.82356,
		0,
		0.904192,
		-0.14268,
		-0.402591,
		0,
		0.313828,
		0.861302,
		0.399588,
		0,
		0.685161,
		-0.15064,
		-0.325903,
		1
	},
	[0.233333333333] = {
		0.113754,
		-0.224038,
		-0.967919,
		0,
		0.961321,
		0.2708,
		0.050298,
		0,
		0.250844,
		-0.936202,
		0.246177,
		0,
		0.813195,
		-0.303623,
		-0.13621,
		1
	},
	[0.266666666667] = {
		0.097136,
		0.103946,
		-0.989828,
		0,
		0.984797,
		0.133864,
		0.1107,
		0,
		0.14401,
		-0.985533,
		-0.089362,
		0,
		0.802628,
		-0.271926,
		-0.10683,
		1
	},
	[0.2] = {
		0.151714,
		-0.617298,
		-0.771963,
		0,
		0.924034,
		0.365855,
		-0.110954,
		0,
		0.350918,
		-0.696487,
		0.625909,
		0,
		0.807373,
		-0.293876,
		-0.135267,
		1
	},
	[0.333333333333] = {
		0.001664,
		0.416139,
		-0.909299,
		0,
		0.999964,
		0.006845,
		0.004962,
		0,
		0.008289,
		-0.909275,
		-0.416113,
		0,
		0.739752,
		-0.166427,
		0.110717,
		1
	},
	[0.366666666667] = {
		-0.181098,
		0.398779,
		-0.898987,
		0,
		0.983464,
		0.074677,
		-0.16499,
		0,
		0.001339,
		-0.914001,
		-0.405709,
		0,
		0.655947,
		-0.073479,
		0.282889,
		1
	},
	[0.3] = {
		0.069022,
		0.315771,
		-0.946321,
		0,
		0.995837,
		0.034809,
		0.084249,
		0,
		0.059544,
		-0.948197,
		-0.312054,
		0,
		0.778464,
		-0.219842,
		-0.026382,
		1
	},
	[0.433333333333] = {
		-0.591889,
		-0.205623,
		-0.77935,
		0,
		0.759886,
		0.180075,
		-0.624617,
		0,
		0.268777,
		-0.961921,
		0.049666,
		0,
		0.369242,
		0.325892,
		0.616861,
		1
	},
	[0.466666666667] = {
		-0.6413,
		-0.703487,
		-0.306332,
		0,
		0.649738,
		-0.285532,
		-0.704494,
		0,
		0.408135,
		-0.650828,
		0.640195,
		0,
		0.292068,
		0.798939,
		0.555619,
		1
	},
	[0.4] = {
		-0.441047,
		0.196981,
		-0.8756,
		0,
		0.894209,
		0.17972,
		-0.409989,
		0,
		0.076603,
		-0.963794,
		-0.255407,
		0,
		0.52564,
		0.093619,
		0.457637,
		1
	},
	[0.533333333333] = {
		-0.741706,
		-0.290805,
		0.604404,
		0,
		0.670345,
		-0.351741,
		0.653388,
		0,
		0.022585,
		0.889781,
		0.455828,
		0,
		0.038716,
		1.607019,
		-0.447663,
		1
	},
	[0.566666666667] = {
		-0.695492,
		-0.056375,
		0.716319,
		0,
		0.710744,
		0.092416,
		0.697353,
		0,
		-0.105512,
		0.994123,
		-0.024206,
		0,
		-0.120746,
		1.453828,
		-0.958956,
		1
	},
	[0.5] = {
		-0.63481,
		-0.767662,
		0.087816,
		0,
		0.769907,
		-0.638043,
		-0.012032,
		0,
		0.065267,
		0.059973,
		0.996064,
		0,
		0.189656,
		1.362812,
		0.304268,
		1
	},
	[0.633333333333] = {
		-0.697461,
		0.346384,
		-0.627348,
		0,
		0.71604,
		0.372142,
		-0.590591,
		0,
		0.028891,
		-0.86112,
		-0.50758,
		0,
		-0.261758,
		0.145132,
		-1.515327,
		1
	},
	[0.666666666667] = {
		-0.720012,
		0.288248,
		-0.631265,
		0,
		0.683211,
		0.134941,
		-0.717644,
		0,
		-0.121676,
		-0.948,
		-0.294093,
		0,
		-0.027191,
		-0.140872,
		-1.531824,
		1
	},
	[0.6] = {
		-0.809742,
		0.450085,
		0.376486,
		0,
		0.582128,
		0.535484,
		0.611869,
		0,
		0.073791,
		0.714619,
		-0.695611,
		0,
		-0.160081,
		0.808738,
		-1.42717,
		1
	},
	[0.733333333333] = {
		-0.480504,
		0.695052,
		-0.534807,
		0,
		0.761701,
		0.028515,
		-0.647301,
		0,
		-0.434658,
		-0.718393,
		-0.543124,
		0,
		0.258986,
		-0.213632,
		-1.562019,
		1
	},
	[0.766666666667] = {
		-0.118307,
		0.893357,
		-0.433494,
		0,
		0.88105,
		-0.106913,
		-0.460783,
		0,
		-0.45799,
		-0.436443,
		-0.774443,
		0,
		0.361019,
		-0.160268,
		-1.572051,
		1
	},
	[0.7] = {
		-0.689854,
		0.480708,
		-0.541314,
		0,
		0.660898,
		0.112977,
		-0.741923,
		0,
		-0.295493,
		-0.869572,
		-0.395637,
		0,
		0.158791,
		-0.240988,
		-1.551868,
		1
	},
	[0.833333333333] = {
		0.516563,
		0.850173,
		0.101824,
		0,
		0.854155,
		-0.503332,
		-0.130674,
		0,
		-0.059844,
		0.154475,
		-0.986183,
		0,
		0.523487,
		-0.053836,
		-1.584348,
		1
	},
	[0.866666666667] = {
		0.511957,
		0.845354,
		0.152566,
		0,
		0.858228,
		-0.495773,
		-0.13287,
		0,
		-0.036684,
		0.19896,
		-0.979321,
		0,
		0.532356,
		-0.114239,
		-1.578825,
		1
	},
	[0.8] = {
		0.259372,
		0.946035,
		-0.19428,
		0,
		0.916399,
		-0.30458,
		-0.259701,
		0,
		-0.304859,
		-0.110679,
		-0.945944,
		0,
		0.456799,
		-0.089465,
		-1.57879,
		1
	},
	[0.933333333333] = {
		0.496744,
		0.827806,
		0.260734,
		0,
		0.867883,
		-0.472064,
		-0.154709,
		0,
		-0.004986,
		0.303138,
		-0.952934,
		0,
		0.538142,
		-0.265415,
		-1.53579,
		1
	},
	[0.966666666667] = {
		0.487407,
		0.816731,
		0.308843,
		0,
		0.87317,
		-0.454676,
		-0.175626,
		0,
		-0.003016,
		0.355274,
		-0.934757,
		0,
		0.535555,
		-0.325547,
		-1.514129,
		1
	},
	[0.9] = {
		0.505098,
		0.837832,
		0.207156,
		0,
		0.86289,
		-0.485443,
		-0.140591,
		0,
		-0.017229,
		0.249766,
		-0.968153,
		0,
		0.537579,
		-0.189242,
		-1.559366,
		1
	}
}

return spline_matrices
