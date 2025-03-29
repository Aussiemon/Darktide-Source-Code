﻿-- chunkname: @content/characters/player/human/first_person/animations/power_sword/heavy_swing_down_left.lua

local spline_matrices = {
	[0.03333333333333333] = {
		0.978198,
		0.111947,
		-0.174917,
		0,
		0.089791,
		0.531486,
		0.842294,
		0,
		0.187258,
		-0.839637,
		0.509847,
		0,
		0.359314,
		0.036808,
		0.204734,
		1,
	},
	[0.06666666666666667] = {
		0.949912,
		0.176921,
		-0.257617,
		0,
		0.175431,
		0.380327,
		0.908061,
		0,
		0.258634,
		-0.907772,
		0.33024,
		0,
		0.332336,
		0.065576,
		0.215743,
		1,
	},
	[0] = {
		0.994483,
		0.063304,
		-0.083638,
		0,
		0.01935,
		0.672959,
		0.739427,
		0,
		0.103094,
		-0.736966,
		0.668021,
		0,
		0.388986,
		0.010261,
		0.189375,
		1,
	},
	[0.13333333333333333] = {
		0.901568,
		0.243262,
		-0.35777,
		0,
		0.256026,
		0.366615,
		0.894452,
		0,
		0.34875,
		-0.898007,
		0.268247,
		0,
		0.263921,
		0.144799,
		0.245585,
		1,
	},
	[0.16666666666666666] = {
		0.893712,
		0.222297,
		-0.389697,
		0,
		0.187351,
		0.604331,
		0.774392,
		0,
		0.407651,
		-0.765093,
		0.49845,
		0,
		0.213302,
		0.23673,
		0.241654,
		1,
	},
	[0.1] = {
		0.919603,
		0.230038,
		-0.318455,
		0,
		0.237548,
		0.320029,
		0.917144,
		0,
		0.312893,
		-0.919056,
		0.239654,
		0,
		0.302012,
		0.106537,
		0.224231,
		1,
	},
	[0.23333333333333334] = {
		0.925367,
		0.109562,
		-0.362894,
		0,
		-0.328492,
		0.709527,
		-0.62343,
		0,
		0.189179,
		0.696109,
		0.692563,
		0,
		0.026119,
		0.640051,
		-0.050585,
		1,
	},
	[0.26666666666666666] = {
		0.932378,
		0.072137,
		-0.354215,
		0,
		-0.359985,
		0.09607,
		-0.927999,
		0,
		-0.032914,
		0.992757,
		0.115541,
		0,
		-0.061599,
		0.590906,
		-0.287542,
		1,
	},
	[0.2] = {
		0.909434,
		0.146023,
		-0.389367,
		0,
		-0.13017,
		0.989229,
		0.066953,
		0,
		0.394949,
		-0.010205,
		0.918646,
		0,
		0.127076,
		0.501819,
		0.136345,
		1,
	},
	[0.3333333333333333] = {
		0.924031,
		-0.175485,
		-0.339665,
		0,
		-0.111397,
		-0.973466,
		0.199885,
		0,
		-0.365729,
		-0.146862,
		-0.919061,
		0,
		-0.152736,
		-0.006886,
		-0.653925,
		1,
	},
	[0.36666666666666664] = {
		0.899109,
		-0.273155,
		-0.342036,
		0,
		-0.099158,
		-0.888184,
		0.448661,
		0,
		-0.426345,
		-0.36948,
		-0.82566,
		0,
		-0.172138,
		-0.154304,
		-0.633541,
		1,
	},
	[0.3] = {
		0.937845,
		-0.07541,
		-0.338763,
		0,
		-0.185195,
		-0.93426,
		-0.304731,
		0,
		-0.293513,
		0.348528,
		-0.890156,
		0,
		-0.134496,
		0.219074,
		-0.633263,
		1,
	},
	[0.43333333333333335] = {
		0.841257,
		-0.421246,
		-0.338879,
		0,
		-0.367412,
		-0.905285,
		0.213233,
		0,
		-0.396606,
		-0.054875,
		-0.916347,
		0,
		-0.193762,
		-0.241084,
		-0.666193,
		1,
	},
	[0.4666666666666667] = {
		0.765506,
		-0.485528,
		-0.422212,
		0,
		-0.613441,
		-0.748717,
		-0.251224,
		0,
		-0.194141,
		0.451316,
		-0.87099,
		0,
		-0.205302,
		-0.242897,
		-0.721061,
		1,
	},
	[0.4] = {
		0.893071,
		-0.321421,
		-0.314823,
		0,
		-0.131324,
		-0.855491,
		0.500888,
		0,
		-0.430324,
		-0.405984,
		-0.806225,
		0,
		-0.172478,
		-0.206664,
		-0.625754,
		1,
	},
	[0.5333333333333333] = {
		0.703119,
		-0.529296,
		-0.474836,
		0,
		-0.706062,
		-0.440558,
		-0.554423,
		0,
		0.084261,
		0.725089,
		-0.68348,
		0,
		-0.141362,
		-0.22122,
		-0.730912,
		1,
	},
	[0.5666666666666667] = {
		0.675394,
		-0.554937,
		-0.485683,
		0,
		-0.713883,
		-0.326799,
		-0.619332,
		0,
		0.184969,
		0.765015,
		-0.616878,
		0,
		-0.092251,
		-0.212048,
		-0.728487,
		1,
	},
	[0.5] = {
		0.731974,
		-0.506316,
		-0.455913,
		0,
		-0.679967,
		-0.58519,
		-0.441811,
		0,
		-0.0431,
		0.633401,
		-0.772623,
		0,
		-0.182233,
		-0.231374,
		-0.729223,
		1,
	},
	[0.6333333333333333] = {
		0.629858,
		-0.593664,
		-0.500841,
		0,
		-0.707197,
		-0.171697,
		-0.685852,
		0,
		0.321172,
		0.786183,
		-0.527982,
		0,
		-0.004071,
		-0.194293,
		-0.716093,
		1,
	},
	[0.6666666666666666] = {
		0.622681,
		-0.592524,
		-0.511061,
		0,
		-0.690595,
		-0.109071,
		-0.71497,
		0,
		0.367895,
		0.798134,
		-0.477111,
		0,
		0.018524,
		-0.18495,
		-0.707375,
		1,
	},
	[0.6] = {
		0.649578,
		-0.578627,
		-0.493193,
		0,
		-0.713646,
		-0.240308,
		-0.657998,
		0,
		0.262217,
		0.779386,
		-0.569034,
		0,
		-0.043695,
		-0.203231,
		-0.723289,
		1,
	},
	[0.7333333333333333] = {
		0.654279,
		-0.560911,
		-0.507245,
		0,
		-0.635899,
		-0.045004,
		-0.770459,
		0,
		0.409331,
		0.826652,
		-0.386128,
		0,
		0.036643,
		-0.168934,
		-0.688953,
		1,
	},
	[0.7666666666666667] = {
		0.684278,
		-0.543818,
		-0.485825,
		0,
		-0.605344,
		-0.052141,
		-0.794254,
		0,
		0.406598,
		0.837582,
		-0.364876,
		0,
		0.042922,
		-0.162652,
		-0.680934,
		1,
	},
	[0.7] = {
		0.632131,
		-0.578021,
		-0.516044,
		0,
		-0.664555,
		-0.061944,
		-0.744667,
		0,
		0.398468,
		0.813667,
		-0.423284,
		0,
		0.028689,
		-0.176236,
		-0.697956,
		1,
	},
	[0.8333333333333334] = {
		0.749788,
		-0.51406,
		-0.416605,
		0,
		-0.540717,
		-0.113132,
		-0.833562,
		0,
		0.38137,
		0.850261,
		-0.362786,
		0,
		0.052584,
		-0.151978,
		-0.669142,
		1,
	},
	[0.8666666666666667] = {
		0.778181,
		-0.502409,
		-0.376856,
		0,
		-0.509696,
		-0.154624,
		-0.846346,
		0,
		0.366941,
		0.850692,
		-0.376401,
		0,
		0.05683,
		-0.147068,
		-0.665746,
		1,
	},
	[0.8] = {
		0.717416,
		-0.528064,
		-0.454383,
		0,
		-0.573278,
		-0.076922,
		-0.815742,
		0,
		0.395812,
		0.845714,
		-0.357912,
		0,
		0.048061,
		-0.157091,
		-0.674257,
		1,
	},
	[0.9] = {
		0.800066,
		-0.494463,
		-0.339709,
		0,
		-0.483198,
		-0.195534,
		-0.853397,
		0,
		0.355548,
		0.84692,
		-0.395363,
		0,
		0.060932,
		-0.142154,
		-0.66423,
		1,
	},
}

return spline_matrices
