local spline_matrices = {
	[0] = {
		0.987613,
		0.153557,
		-0.032258,
		0,
		-0.053616,
		0.52347,
		0.850356,
		0,
		0.147464,
		-0.838093,
		0.525219,
		0,
		0.266709,
		0.022316,
		0.16848,
		1
	},
	[0.0166666666667] = {
		0.984898,
		0.163452,
		-0.057087,
		0,
		-0.025195,
		0.461528,
		0.886768,
		0,
		0.171291,
		-0.871938,
		0.458676,
		0,
		0.262448,
		0.022333,
		0.170508,
		1
	},
	[0.0333333333333] = {
		0.979336,
		0.180275,
		-0.091658,
		0,
		0.010492,
		0.407319,
		0.913226,
		0,
		0.201966,
		-0.895317,
		0.39701,
		0,
		0.258556,
		0.027535,
		0.172947,
		1
	},
	[0.05] = {
		0.97027,
		0.202382,
		-0.132732,
		0,
		0.051748,
		0.362265,
		0.930637,
		0,
		0.236429,
		-0.909838,
		0.341022,
		0,
		0.254707,
		0.037711,
		0.175675,
		1
	},
	[0.0666666666667] = {
		0.952284,
		0.224255,
		-0.207039,
		0,
		0.126879,
		0.326088,
		0.936786,
		0,
		0.277592,
		-0.918355,
		0.282075,
		0,
		0.253106,
		0.052543,
		0.178424,
		1
	},
	[0.0833333333333] = {
		0.933208,
		0.249121,
		-0.258964,
		0,
		0.179355,
		0.301562,
		0.936425,
		0,
		0.311377,
		-0.920326,
		0.236739,
		0,
		0.248757,
		0.071931,
		0.181056,
		1
	},
	[0.116666666667] = {
		0.895131,
		0.286828,
		-0.341278,
		0,
		0.261836,
		0.281319,
		0.923202,
		0,
		0.360808,
		-0.915745,
		0.176715,
		0,
		0.235861,
		0.12271,
		0.185302,
		1
	},
	[0.133333333333] = {
		0.883038,
		0.293372,
		-0.366302,
		0,
		0.28606,
		0.28229,
		0.915687,
		0,
		0.37204,
		-0.91337,
		0.165351,
		0,
		0.226975,
		0.151258,
		0.186578,
		1
	},
	[0.15] = {
		0.880298,
		0.288086,
		-0.376938,
		0,
		0.295702,
		0.28813,
		0.910792,
		0,
		0.370994,
		-0.913229,
		0.168452,
		0,
		0.214169,
		0.182584,
		0.187117,
		1
	},
	[0.166666666667] = {
		0.876874,
		0.28742,
		-0.385332,
		0,
		0.256317,
		0.398582,
		0.880587,
		0,
		0.406685,
		-0.870931,
		0.275836,
		0,
		0.194067,
		0.231096,
		0.189973,
		1
	},
	[0.183333333333] = {
		0.883111,
		0.286374,
		-0.371625,
		0,
		0.158108,
		0.564108,
		0.810422,
		0,
		0.441721,
		-0.774449,
		0.452892,
		0,
		0.162715,
		0.303913,
		0.196289,
		1
	},
	[0.1] = {
		0.913079,
		0.271076,
		-0.304639,
		0,
		0.225382,
		0.287109,
		0.931005,
		0,
		0.339838,
		-0.918742,
		0.201058,
		0,
		0.24288,
		0.095458,
		0.183444,
		1
	},
	[0.216666666667] = {
		0.911294,
		0.275988,
		-0.305571,
		0,
		-0.107986,
		0.876332,
		0.469447,
		0,
		0.397344,
		-0.394807,
		0.828399,
		0,
		0.07339,
		0.50318,
		0.159614,
		1
	},
	[0.233333333333] = {
		0.92462,
		0.211266,
		-0.31693,
		0,
		-0.251251,
		0.96367,
		-0.090621,
		0,
		0.286271,
		0.163419,
		0.94411,
		0,
		0.014446,
		0.628861,
		0.027913,
		1
	},
	[0.25] = {
		0.921046,
		0.130209,
		-0.367043,
		0,
		-0.351492,
		0.683782,
		-0.639449,
		0,
		0.167716,
		0.717975,
		0.675562,
		0,
		-0.056972,
		0.69332,
		-0.137169,
		1
	},
	[0.266666666667] = {
		0.888502,
		0.07341,
		-0.452962,
		0,
		-0.457024,
		0.230067,
		-0.859184,
		0,
		0.041139,
		0.970402,
		0.237965,
		0,
		-0.14481,
		0.606475,
		-0.363006,
		1
	},
	[0.283333333333] = {
		0.842345,
		-0.047467,
		-0.536844,
		0,
		-0.521569,
		-0.322652,
		-0.789849,
		0,
		-0.135722,
		0.945327,
		-0.296542,
		0,
		-0.211851,
		0.42149,
		-0.564845,
		1
	},
	[0.2] = {
		0.89975,
		0.282424,
		-0.332696,
		0,
		0.041648,
		0.703306,
		0.709666,
		0,
		0.434414,
		-0.652378,
		0.621037,
		0,
		0.122319,
		0.395551,
		0.202449,
		1
	},
	[0.316666666667] = {
		0.792295,
		-0.363175,
		-0.490277,
		0,
		-0.499692,
		-0.847327,
		-0.179847,
		0,
		-0.350109,
		0.387479,
		-0.852809,
		0,
		-0.24491,
		-0.032879,
		-0.684627,
		1
	},
	[0.333333333333] = {
		0.786852,
		-0.443127,
		-0.429538,
		0,
		-0.479725,
		-0.877034,
		0.025992,
		0,
		-0.388237,
		0.185609,
		-0.902674,
		0,
		-0.247452,
		-0.11672,
		-0.661605,
		1
	},
	[0.35] = {
		0.78203,
		-0.499351,
		-0.372932,
		0,
		-0.473708,
		-0.865089,
		0.164989,
		0,
		-0.405007,
		0.047634,
		-0.913072,
		0,
		-0.242245,
		-0.176099,
		-0.63465,
		1
	},
	[0.366666666667] = {
		0.781018,
		-0.523283,
		-0.34086,
		0,
		-0.463509,
		-0.851501,
		0.245164,
		0,
		-0.418533,
		-0.033486,
		-0.907584,
		0,
		-0.232096,
		-0.21852,
		-0.609947,
		1
	},
	[0.383333333333] = {
		0.778175,
		-0.554502,
		-0.294907,
		0,
		-0.488938,
		-0.829588,
		0.269674,
		0,
		-0.394186,
		-0.065662,
		-0.916682,
		0,
		-0.224312,
		-0.24804,
		-0.595857,
		1
	},
	[0.3] = {
		0.809422,
		-0.249779,
		-0.531457,
		0,
		-0.525649,
		-0.71164,
		-0.466113,
		0,
		-0.261781,
		0.656642,
		-0.707313,
		0,
		-0.234234,
		0.180738,
		-0.659926,
		1
	},
	[0.416666666667] = {
		0.765994,
		-0.600248,
		-0.230119,
		0,
		-0.557191,
		-0.798464,
		0.228021,
		0,
		-0.320611,
		-0.046442,
		-0.946072,
		0,
		-0.217759,
		-0.283727,
		-0.591821,
		1
	},
	[0.433333333333] = {
		0.749032,
		-0.612744,
		-0.251981,
		0,
		-0.57975,
		-0.790277,
		0.198374,
		0,
		-0.320688,
		-0.002503,
		-0.947182,
		0,
		-0.218064,
		-0.294432,
		-0.598566,
		1
	},
	[0.45] = {
		0.730504,
		-0.621602,
		-0.282798,
		0,
		-0.604685,
		-0.781207,
		0.155148,
		0,
		-0.317364,
		0.057668,
		-0.946549,
		0,
		-0.218985,
		-0.299457,
		-0.612351,
		1
	},
	[0.466666666667] = {
		0.714447,
		-0.630806,
		-0.302736,
		0,
		-0.637114,
		-0.765356,
		0.091192,
		0,
		-0.289226,
		0.127725,
		-0.948702,
		0,
		-0.217515,
		-0.295622,
		-0.629976,
		1
	},
	[0.483333333333] = {
		0.703061,
		-0.615702,
		-0.355831,
		0,
		-0.665088,
		-0.746424,
		-0.022545,
		0,
		-0.25172,
		0.252509,
		-0.934278,
		0,
		-0.210098,
		-0.282177,
		-0.645694,
		1
	},
	[0.4] = {
		0.777753,
		-0.581864,
		-0.237772,
		0,
		-0.529755,
		-0.81038,
		0.250288,
		0,
		-0.338319,
		-0.068701,
		-0.93852,
		0,
		-0.219565,
		-0.268812,
		-0.591264,
		1
	},
	[0.516666666667] = {
		0.684811,
		-0.582145,
		-0.438339,
		0,
		-0.714946,
		-0.653129,
		-0.249549,
		0,
		-0.141018,
		0.484283,
		-0.863472,
		0,
		-0.185223,
		-0.239737,
		-0.663482,
		1
	},
	[0.533333333333] = {
		0.678269,
		-0.564945,
		-0.469881,
		0,
		-0.731284,
		-0.581567,
		-0.356375,
		0,
		-0.071935,
		0.585335,
		-0.807594,
		0,
		-0.1693,
		-0.213158,
		-0.666024,
		1
	},
	[0.55] = {
		0.673393,
		-0.547966,
		-0.496261,
		0,
		-0.73928,
		-0.496811,
		-0.454581,
		0,
		0.002547,
		0.672988,
		-0.739649,
		0,
		-0.152391,
		-0.184694,
		-0.665428,
		1
	},
	[0.566666666667] = {
		0.670037,
		-0.531342,
		-0.518387,
		0,
		-0.738097,
		-0.402419,
		-0.541546,
		0,
		0.079137,
		0.745476,
		-0.661818,
		0,
		-0.135443,
		-0.155694,
		-0.662299,
		1
	},
	[0.583333333333] = {
		0.668028,
		-0.515031,
		-0.537105,
		0,
		-0.727917,
		-0.302402,
		-0.615378,
		0,
		0.154517,
		0.802058,
		-0.576912,
		0,
		-0.11947,
		-0.127528,
		-0.657317,
		1
	},
	[0.5] = {
		0.693095,
		-0.599238,
		-0.400666,
		0,
		-0.692039,
		-0.708704,
		-0.137188,
		0,
		-0.201746,
		0.372361,
		-0.905895,
		0,
		-0.199275,
		-0.263134,
		-0.65725,
		1
	},
	[0.616666666667] = {
		0.668151,
		-0.482358,
		-0.566485,
		0,
		-0.684969,
		-0.101509,
		-0.721466,
		0,
		0.290502,
		0.870073,
		-0.398224,
		0,
		-0.093979,
		-0.079123,
		-0.644963,
		1
	},
	[0.633333333333] = {
		0.67039,
		-0.465135,
		-0.578124,
		0,
		-0.656076,
		-0.007615,
		-0.754656,
		0,
		0.346615,
		0.885207,
		-0.310269,
		0,
		-0.084968,
		-0.061512,
		-0.639246,
		1
	},
	[0.65] = {
		0.674137,
		-0.446526,
		-0.588348,
		0,
		-0.625552,
		0.078361,
		-0.776237,
		0,
		0.392714,
		0.891333,
		-0.2265,
		0,
		-0.077296,
		-0.049416,
		-0.634939,
		1
	},
	[0.666666666667] = {
		0.679467,
		-0.425781,
		-0.597524,
		0,
		-0.596009,
		0.15465,
		-0.787944,
		0,
		0.427899,
		0.891512,
		-0.14869,
		0,
		-0.071062,
		-0.042022,
		-0.631572,
		1
	},
	[0.683333333333] = {
		0.676224,
		-0.430416,
		-0.597881,
		0,
		-0.592177,
		0.165192,
		-0.788694,
		0,
		0.438232,
		0.887386,
		-0.143176,
		0,
		-0.068279,
		-0.042313,
		-0.629481,
		1
	},
	[0.6] = {
		0.667368,
		-0.498823,
		-0.552989,
		0,
		-0.709675,
		-0.200839,
		-0.675296,
		0,
		0.225791,
		0.843113,
		-0.488036,
		0,
		-0.105354,
		-0.101561,
		-0.651262,
		1
	},
	[0.716666666667] = {
		0.672179,
		-0.436616,
		-0.597948,
		0,
		-0.588075,
		0.175823,
		-0.789464,
		0,
		0.449826,
		0.8823,
		-0.138579,
		0,
		-0.065675,
		-0.047447,
		-0.626435,
		1
	},
	[0.733333333333] = {
		0.671218,
		-0.43843,
		-0.5977,
		0,
		-0.587621,
		0.176799,
		-0.789585,
		0,
		0.45185,
		0.881205,
		-0.13896,
		0,
		-0.065585,
		-0.050023,
		-0.625349,
		1
	},
	[0.75] = {
		0.670846,
		-0.439537,
		-0.597305,
		0,
		-0.588051,
		0.175457,
		-0.789564,
		0,
		0.451844,
		0.880921,
		-0.140766,
		0,
		-0.066129,
		-0.052075,
		-0.624496,
		1
	},
	[0.766666666667] = {
		0.670965,
		-0.440044,
		-0.596798,
		0,
		-0.589206,
		0.172221,
		-0.789415,
		0,
		0.450158,
		0.881307,
		-0.143723,
		0,
		-0.067182,
		-0.054179,
		-0.623843,
		1
	},
	[0.783333333333] = {
		0.671477,
		-0.440054,
		-0.596215,
		0,
		-0.590919,
		0.16751,
		-0.789148,
		0,
		0.44714,
		0.882209,
		-0.147557,
		0,
		-0.068613,
		-0.056298,
		-0.623348,
		1
	},
	[0.7] = {
		0.67382,
		-0.433985,
		-0.598017,
		0,
		-0.589556,
		0.1721,
		-0.78918,
		0,
		0.445411,
		0.88433,
		-0.139894,
		0,
		-0.066528,
		-0.044499,
		-0.627792,
		1
	},
	[0.816666666667] = {
		0.673279,
		-0.438995,
		-0.594961,
		0,
		-0.595332,
		0.155343,
		-0.78832,
		0,
		0.438491,
		0.884959,
		-0.156758,
		0,
		-0.072084,
		-0.060432,
		-0.622668,
		1
	},
	[0.833333333333] = {
		0.674372,
		-0.438135,
		-0.594357,
		0,
		-0.597701,
		0.148729,
		-0.787803,
		0,
		0.433562,
		0.88652,
		-0.161575,
		0,
		-0.073863,
		-0.062369,
		-0.622403,
		1
	},
	[0.85] = {
		0.675464,
		-0.437198,
		-0.593806,
		0,
		-0.599968,
		0.142325,
		-0.787262,
		0,
		0.428703,
		0.888032,
		-0.166169,
		0,
		-0.075497,
		-0.064165,
		-0.622136,
		1
	},
	[0.866666666667] = {
		0.676461,
		-0.436295,
		-0.593336,
		0,
		-0.601989,
		0.136558,
		-0.786741,
		0,
		0.424276,
		0.889381,
		-0.170269,
		0,
		-0.076856,
		-0.065781,
		-0.621831,
		1
	},
	[0.883333333333] = {
		0.67727,
		-0.435538,
		-0.592969,
		0,
		-0.603625,
		0.131855,
		-0.786289,
		0,
		0.420645,
		0.890461,
		-0.1736,
		0,
		-0.077811,
		-0.067173,
		-0.621451,
		1
	},
	[0.8] = {
		0.672281,
		-0.439669,
		-0.595591,
		0,
		-0.593017,
		0.161744,
		-0.788777,
		0,
		0.443135,
		0.883476,
		-0.151994,
		0,
		-0.07029,
		-0.058395,
		-0.622969,
		1
	},
	[0.916666666667] = {
		0.67796,
		-0.434919,
		-0.592635,
		0,
		-0.60521,
		0.12736,
		-0.785812,
		0,
		0.417242,
		0.891418,
		-0.176872,
		0,
		-0.077996,
		-0.069121,
		-0.620318,
		1
	},
	[0.9] = {
		0.6778,
		-0.435042,
		-0.592728,
		0,
		-0.604743,
		0.128646,
		-0.785962,
		0,
		0.418178,
		0.891173,
		-0.175892,
		0,
		-0.078234,
		-0.0683,
		-0.620958,
		1
	}
}

return spline_matrices
