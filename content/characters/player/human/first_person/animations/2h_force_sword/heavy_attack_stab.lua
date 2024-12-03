﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_stab.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.630677,
		0.026032,
		-0.775608,
		0,
		-0.77588,
		-0.041754,
		0.629497,
		0,
		-0.015998,
		0.998789,
		0.046531,
		0,
		0.010241,
		-0.703653,
		-0.221496,
		1,
	},
	[0.0333333333333] = {
		-0.598359,
		0.027922,
		-0.800741,
		0,
		-0.801145,
		-0.035251,
		0.597431,
		0,
		-0.011545,
		0.998988,
		0.043462,
		0,
		0.0019,
		-0.406812,
		-0.183388,
		1,
	},
	[0.05] = {
		-0.552088,
		0.030539,
		-0.833226,
		0,
		-0.833767,
		-0.026854,
		0.551462,
		0,
		-0.005534,
		0.999173,
		0.040288,
		0,
		-0.006525,
		-0.049274,
		-0.139179,
		1,
	},
	[0.0666666666667] = {
		-0.498835,
		0.03359,
		-0.866046,
		0,
		-0.866697,
		-0.018442,
		0.498494,
		0,
		0.000773,
		0.999266,
		0.038312,
		0,
		-0.010235,
		0.256456,
		-0.102526,
		1,
	},
	[0.0833333333333] = {
		-0.446813,
		0.036978,
		-0.893863,
		0,
		-0.894606,
		-0.011635,
		0.446704,
		0,
		0.006118,
		0.999248,
		0.03828,
		0,
		-0.008,
		0.507065,
		-0.065948,
		1,
	},
	[0] = {
		-0.642849,
		0.025305,
		-0.765575,
		0,
		-0.765788,
		-0.04436,
		0.641561,
		0,
		-0.017726,
		0.998695,
		0.047895,
		0,
		0.014011,
		-0.827539,
		-0.237755,
		1,
	},
	[0.116666666667] = {
		-0.413089,
		0.03604,
		-0.909977,
		0,
		-0.91066,
		-0.008131,
		0.413077,
		0,
		0.007489,
		0.999317,
		0.036179,
		0,
		-0.005971,
		0.623838,
		-0.04575,
		1,
	},
	[0.133333333333] = {
		-0.426832,
		0.031925,
		-0.903767,
		0,
		-0.904317,
		-0.009661,
		0.426751,
		0,
		0.004893,
		0.999444,
		0.032994,
		0,
		-0.006711,
		0.593713,
		-0.047163,
		1,
	},
	[0.15] = {
		-0.395679,
		0.037394,
		-0.917627,
		0,
		-0.918365,
		-0.008822,
		0.395637,
		0,
		0.006699,
		0.999262,
		0.037831,
		0,
		-0.00851,
		0.560157,
		-0.047698,
		1,
	},
	[0.166666666667] = {
		-0.356645,
		0.041717,
		-0.933308,
		0,
		-0.934202,
		-0.006889,
		0.356679,
		0,
		0.00845,
		0.999106,
		0.041429,
		0,
		-0.009983,
		0.539897,
		-0.047902,
		1,
	},
	[0.183333333333] = {
		-0.324217,
		0.044991,
		-0.944912,
		0,
		-0.945931,
		-0.004998,
		0.324328,
		0,
		0.009869,
		0.998975,
		0.044178,
		0,
		-0.010897,
		0.532535,
		-0.047239,
		1,
	},
	[0.1] = {
		-0.405283,
		0.040739,
		-0.913283,
		0,
		-0.914143,
		-0.007773,
		0.405318,
		0,
		0.009413,
		0.99914,
		0.040392,
		0,
		-0.006044,
		0.636568,
		-0.04429,
		1,
	},
	[0.216666666667] = {
		-0.318341,
		0.05201,
		-0.946549,
		0,
		-0.947901,
		-0.004869,
		0.318528,
		0,
		0.011958,
		0.998635,
		0.05085,
		0,
		-0.011642,
		0.523557,
		-0.042754,
		1,
	},
	[0.233333333333] = {
		-0.328863,
		0.05486,
		-0.942783,
		0,
		-0.944291,
		-0.005608,
		0.329063,
		0,
		0.012765,
		0.998478,
		0.053648,
		0,
		-0.011857,
		0.52116,
		-0.041589,
		1,
	},
	[0.25] = {
		-0.342194,
		0.056617,
		-0.937922,
		0,
		-0.939535,
		-0.006497,
		0.34239,
		0,
		0.013292,
		0.998375,
		0.055417,
		0,
		-0.011923,
		0.519571,
		-0.041366,
		1,
	},
	[0.266666666667] = {
		-0.357073,
		0.056782,
		-0.932349,
		0,
		-0.933981,
		-0.007448,
		0.357244,
		0,
		0.013341,
		0.998359,
		0.055692,
		0,
		-0.011709,
		0.518418,
		-0.041253,
		1,
	},
	[0.283333333333] = {
		-0.372281,
		0.055819,
		-0.92644,
		0,
		-0.928029,
		-0.008379,
		0.372415,
		0,
		0.013025,
		0.998406,
		0.054921,
		0,
		-0.011272,
		0.517668,
		-0.041309,
		1,
	},
	[0.2] = {
		-0.311898,
		0.048573,
		-0.948873,
		0,
		-0.950052,
		-0.004368,
		0.312062,
		0,
		0.011014,
		0.99881,
		0.04751,
		0,
		-0.01143,
		0.527132,
		-0.045224,
		1,
	},
	[0.316666666667] = {
		-0.400499,
		0.053184,
		-0.914752,
		0,
		-0.916217,
		-0.009999,
		0.400559,
		0,
		0.012156,
		0.998535,
		0.052733,
		0,
		-0.009923,
		0.517339,
		-0.042131,
		1,
	},
	[0.333333333333] = {
		-0.415227,
		0.05168,
		-0.908249,
		0,
		-0.909643,
		-0.010801,
		0.41525,
		0,
		0.01165,
		0.998605,
		0.051495,
		0,
		-0.009068,
		0.517313,
		-0.04296,
		1,
	},
	[0.35] = {
		-0.430774,
		0.050167,
		-0.901064,
		0,
		-0.902391,
		-0.011628,
		0.430761,
		0,
		0.011132,
		0.998673,
		0.050279,
		0,
		-0.008134,
		0.517079,
		-0.04411,
		1,
	},
	[0.366666666667] = {
		-0.44712,
		0.048735,
		-0.893145,
		0,
		-0.894411,
		-0.012487,
		0.447072,
		0,
		0.010636,
		0.998734,
		0.049173,
		0,
		-0.007153,
		0.516413,
		-0.045611,
		1,
	},
	[0.383333333333] = {
		-0.464243,
		0.047473,
		-0.884435,
		0,
		-0.885649,
		-0.013382,
		0.464162,
		0,
		0.0102,
		0.998783,
		0.048257,
		0,
		-0.006157,
		0.515091,
		-0.047493,
		1,
	},
	[0.3] = {
		-0.386605,
		0.054591,
		-0.920628,
		0,
		-0.922159,
		-0.009218,
		0.386701,
		0,
		0.012624,
		0.998466,
		0.053905,
		0,
		-0.010668,
		0.517383,
		-0.041591,
		1,
	},
	[0.416666666667] = {
		-0.500508,
		0.045643,
		-0.864528,
		0,
		-0.865679,
		-0.015288,
		0.500367,
		0,
		0.009621,
		0.998841,
		0.047165,
		0,
		-0.00424,
		0.50958,
		-0.052481,
		1,
	},
	[0.433333333333] = {
		-0.519112,
		0.044881,
		-0.853527,
		0,
		-0.854655,
		-0.016284,
		0.518941,
		0,
		0.009392,
		0.99886,
		0.046811,
		0,
		-0.003341,
		0.504939,
		-0.055566,
		1,
	},
	[0.45] = {
		-0.53779,
		0.044193,
		-0.84192,
		0,
		-0.843029,
		-0.017304,
		0.53759,
		0,
		0.009189,
		0.998873,
		0.046561,
		0,
		-0.00251,
		0.498743,
		-0.059061,
		1,
	},
	[0.466666666667] = {
		-0.556412,
		0.043588,
		-0.829762,
		0,
		-0.830858,
		-0.018346,
		0.556183,
		0,
		0.00902,
		0.998881,
		0.046424,
		0,
		-0.00177,
		0.490766,
		-0.062985,
		1,
	},
	[0.483333333333] = {
		-0.579543,
		0.043188,
		-0.813797,
		0,
		-0.814892,
		-0.019661,
		0.579279,
		0,
		0.009018,
		0.998873,
		0.046588,
		0,
		-0.001131,
		0.478998,
		-0.067757,
		1,
	},
	[0.4] = {
		-0.482116,
		0.046467,
		-0.874874,
		0,
		-0.876052,
		-0.014318,
		0.482004,
		0,
		0.009871,
		0.998817,
		0.04761,
		0,
		-0.005181,
		0.512888,
		-0.049786,
		1,
	},
	[0.516666666667] = {
		-0.644088,
		0.043189,
		-0.763731,
		0,
		-0.76489,
		-0.023722,
		0.643724,
		0,
		0.009685,
		0.998785,
		0.048314,
		0,
		5.8e-05,
		0.440379,
		-0.080722,
		1,
	},
	[0.533333333333] = {
		-0.679677,
		0.04376,
		-0.732205,
		0,
		-0.733441,
		-0.026676,
		0.67923,
		0,
		0.01019,
		0.998686,
		0.050226,
		0,
		0.000736,
		0.414917,
		-0.088511,
		1,
	},
	[0.55] = {
		-0.713996,
		0.044327,
		-0.698745,
		0,
		-0.700069,
		-0.03003,
		0.713444,
		0,
		0.010641,
		0.998566,
		0.052473,
		0,
		0.00152,
		0.386253,
		-0.097277,
		1,
	},
	[0.566666666667] = {
		-0.744896,
		0.044549,
		-0.665691,
		0,
		-0.667092,
		-0.03349,
		0.744222,
		0,
		0.01086,
		0.998446,
		0.054665,
		0,
		0.00244,
		0.355041,
		-0.107155,
		1,
	},
	[0.583333333333] = {
		-0.770637,
		0.044146,
		-0.635744,
		0,
		-0.637186,
		-0.036719,
		0.769835,
		0,
		0.010641,
		0.99835,
		0.056426,
		0,
		0.003526,
		0.321933,
		-0.118252,
		1,
	},
	[0.5] = {
		-0.609772,
		0.043,
		-0.79141,
		0,
		-0.792523,
		-0.02141,
		0.609466,
		0,
		0.009263,
		0.998846,
		0.047134,
		0,
		-0.000547,
		0.461978,
		-0.073758,
		1,
	},
	[0.616666666667] = {
		-0.805075,
		0.039808,
		-0.591836,
		0,
		-0.593102,
		-0.038574,
		0.804202,
		0,
		0.009184,
		0.998462,
		0.054665,
		0,
		0.006307,
		0.250033,
		-0.145005,
		1,
	},
	[0.633333333333] = {
		-0.819718,
		0.034167,
		-0.571747,
		0,
		-0.572687,
		-0.032267,
		0.819139,
		0,
		0.009539,
		0.998895,
		0.046017,
		0,
		0.007988,
		0.207701,
		-0.161744,
		1,
	},
	[0.65] = {
		-0.83358,
		0.02646,
		-0.551765,
		0,
		-0.552303,
		-0.0213,
		0.833372,
		0,
		0.010298,
		0.999423,
		0.032369,
		0,
		0.009804,
		0.161704,
		-0.18033,
		1,
	},
	[0.666666666667] = {
		-0.846507,
		0.017238,
		-0.532099,
		0,
		-0.532264,
		-0.006698,
		0.846552,
		0,
		0.011028,
		0.999829,
		0.014845,
		0,
		0.011706,
		0.113207,
		-0.200244,
		1,
	},
	[0.683333333333] = {
		-0.858368,
		0.00685,
		-0.512989,
		0,
		-0.512908,
		0.010783,
		0.858376,
		0,
		0.011412,
		0.999918,
		-0.005742,
		0,
		0.01364,
		0.063322,
		-0.221045,
		1,
	},
	[0.6] = {
		-0.789821,
		0.042896,
		-0.611835,
		0,
		-0.613259,
		-0.03934,
		0.788901,
		0,
		0.009771,
		0.998305,
		0.057378,
		0,
		0.004809,
		0.287569,
		-0.130638,
		1,
	},
	[0.716666666667] = {
		-0.878511,
		-0.016009,
		-0.477454,
		0,
		-0.477608,
		0.051318,
		0.877073,
		0,
		0.010461,
		0.998554,
		-0.052729,
		0,
		0.017386,
		-0.036167,
		-0.263519,
		1,
	},
	[0.733333333333] = {
		-0.88667,
		-0.027772,
		-0.461568,
		0,
		-0.462314,
		0.072823,
		0.883721,
		0,
		0.00907,
		0.996958,
		-0.07741,
		0,
		0.019078,
		-0.083556,
		-0.284288,
		1,
	},
	[0.75] = {
		-0.893518,
		-0.039285,
		-0.447305,
		0,
		-0.448969,
		0.094122,
		0.888576,
		0,
		0.007194,
		0.994785,
		-0.101737,
		0,
		0.020567,
		-0.1279,
		-0.304139,
		1,
	},
	[0.766666666667] = {
		-0.899056,
		-0.050191,
		-0.434948,
		0,
		-0.437805,
		0.114449,
		0.891756,
		0,
		0.005021,
		0.99216,
		-0.12487,
		0,
		0.021787,
		-0.168094,
		-0.322611,
		1,
	},
	[0.783333333333] = {
		-0.903277,
		-0.060137,
		-0.424822,
		0,
		-0.429048,
		0.133052,
		0.893429,
		0,
		0.002796,
		0.989283,
		-0.145984,
		0,
		0.022765,
		-0.203143,
		-0.339123,
		1,
	},
	[0.7] = {
		-0.869061,
		-0.00435,
		-0.494686,
		0,
		-0.494577,
		0.030379,
		0.868603,
		0,
		0.01125,
		0.999529,
		-0.028552,
		0,
		0.015553,
		0.013161,
		-0.242286,
		1,
	},
	[0.816666666667] = {
		-0.907791,
		-0.075734,
		-0.412528,
		0,
		-0.419422,
		0.162166,
		0.893189,
		0,
		-0.000747,
		0.983853,
		-0.178977,
		0,
		0.024082,
		-0.253791,
		-0.363994,
		1,
	},
	[0.833333333333] = {
		-0.908098,
		-0.080686,
		-0.410911,
		0,
		-0.418755,
		0.171248,
		0.891806,
		0,
		-0.001589,
		0.981918,
		-0.189298,
		0,
		0.024333,
		-0.267235,
		-0.371385,
		1,
	},
	[0.85] = {
		-0.907487,
		-0.084482,
		-0.411497,
		0,
		-0.420076,
		0.178158,
		0.889829,
		0,
		-0.001863,
		0.980369,
		-0.197165,
		0,
		0.024379,
		-0.275982,
		-0.376717,
		1,
	},
	[0.866666666667] = {
		-0.906374,
		-0.088209,
		-0.413165,
		0,
		-0.422472,
		0.185079,
		0.887278,
		0,
		-0.001798,
		0.978757,
		-0.205016,
		0,
		0.024331,
		-0.284345,
		-0.381771,
		1,
	},
	[0.883333333333] = {
		-0.904779,
		-0.09189,
		-0.415851,
		0,
		-0.42588,
		0.192056,
		0.884161,
		0,
		-0.001379,
		0.977073,
		-0.212902,
		0,
		0.024193,
		-0.292357,
		-0.386536,
		1,
	},
	[0.8] = {
		-0.906184,
		-0.068768,
		-0.417255,
		0,
		-0.422883,
		0.149198,
		0.893818,
		0,
		0.000788,
		0.986413,
		-0.164281,
		0,
		0.023545,
		-0.232068,
		-0.353079,
		1,
	},
	[0.916666666667] = {
		-0.900209,
		-0.099168,
		-0.424016,
		0,
		-0.435458,
		0.206265,
		0.87626,
		0,
		0.000562,
		0.973458,
		-0.228865,
		0,
		0.023664,
		-0.307431,
		-0.395169,
		1,
	},
	[0.933333333333] = {
		-0.897263,
		-0.102758,
		-0.429372,
		0,
		-0.441492,
		0.213456,
		0.871505,
		0,
		0.002098,
		0.971534,
		-0.236893,
		0,
		0.023279,
		-0.314505,
		-0.399051,
		1,
	},
	[0.95] = {
		-0.893892,
		-0.106309,
		-0.435494,
		0,
		-0.448264,
		0.220678,
		0.866234,
		0,
		0.004015,
		0.969536,
		-0.244917,
		0,
		0.02282,
		-0.321279,
		-0.402653,
		1,
	},
	[0.966666666667] = {
		-0.890109,
		-0.109819,
		-0.442319,
		0,
		-0.455704,
		0.227911,
		0.860459,
		0,
		0.006314,
		0.967469,
		-0.252911,
		0,
		0.022288,
		-0.327757,
		-0.405985,
		1,
	},
	[0.983333333333] = {
		-0.885924,
		-0.113286,
		-0.449784,
		0,
		-0.463744,
		0.235136,
		0.854197,
		0,
		0.008992,
		0.965338,
		-0.260848,
		0,
		0.021688,
		-0.333945,
		-0.409056,
		1,
	},
	[0.9] = {
		-0.902718,
		-0.095544,
		-0.419489,
		0,
		-0.430231,
		0.199125,
		0.880483,
		0,
		-0.000595,
		0.975305,
		-0.22086,
		0,
		0.02397,
		-0.300051,
		-0.391,
		1,
	},
	[1.01666666667] = {
		-0.876395,
		-0.120074,
		-0.466385,
		0,
		-0.481345,
		0.249482,
		0.840277,
		0,
		0.015459,
		0.960906,
		-0.276442,
		0,
		0.020298,
		-0.345468,
		-0.414457,
		1,
	},
	[1.03333333333] = {
		-0.871076,
		-0.123389,
		-0.475396,
		0,
		-0.490771,
		0.256566,
		0.832657,
		0,
		0.01923,
		0.958618,
		-0.284044,
		0,
		0.019515,
		-0.350812,
		-0.416807,
		1,
	},
	[1.05] = {
		-0.865407,
		-0.126644,
		-0.4848,
		0,
		-0.500525,
		0.263567,
		0.824626,
		0,
		0.023343,
		0.956292,
		-0.291481,
		0,
		0.018677,
		-0.355881,
		-0.418939,
		1,
	},
	[1.06666666667] = {
		-0.859404,
		-0.129836,
		-0.494537,
		0,
		-0.510541,
		0.270466,
		0.816208,
		0,
		0.027782,
		0.953934,
		-0.298726,
		0,
		0.017789,
		-0.36068,
		-0.420866,
		1,
	},
	[1.08333333333] = {
		-0.853084,
		-0.132963,
		-0.504547,
		0,
		-0.520758,
		0.277245,
		0.807432,
		0,
		0.032525,
		0.951555,
		-0.305755,
		0,
		0.016856,
		-0.365213,
		-0.422597,
		1,
	},
	{
		-0.881348,
		-0.116705,
		-0.457826,
		0,
		-0.472314,
		0.242332,
		0.847464,
		0,
		0.012043,
		0.963148,
		-0.268701,
		0,
		0.021024,
		-0.339848,
		-0.411877,
		1,
	},
	[1.11666666667] = {
		-0.839576,
		-0.139007,
		-0.525157,
		0,
		-0.541552,
		0.290368,
		0.788928,
		0,
		0.042822,
		0.946765,
		-0.319066,
		0,
		0.014874,
		-0.373489,
		-0.425528,
		1,
	},
	[1.13333333333] = {
		-0.832433,
		-0.141917,
		-0.535644,
		0,
		-0.552015,
		0.296677,
		0.77927,
		0,
		0.048322,
		0.944374,
		-0.325304,
		0,
		0.013836,
		-0.37724,
		-0.426753,
		1,
	},
	[1.15] = {
		-0.825066,
		-0.144743,
		-0.546182,
		0,
		-0.562448,
		0.302795,
		0.769394,
		0,
		0.054017,
		0.942,
		-0.331237,
		0,
		0.012774,
		-0.380736,
		-0.427834,
		1,
	},
	[1.16666666667] = {
		-0.817505,
		-0.14748,
		-0.556718,
		0,
		-0.5728,
		0.308706,
		0.759342,
		0,
		0.059875,
		0.939654,
		-0.336846,
		0,
		0.011694,
		-0.383981,
		-0.428784,
		1,
	},
	[1.18333333333] = {
		-0.809781,
		-0.150119,
		-0.567202,
		0,
		-0.583023,
		0.314395,
		0.749159,
		0,
		0.065863,
		0.937347,
		-0.342115,
		0,
		0.010601,
		-0.386978,
		-0.429617,
		1,
	},
	[1.1] = {
		-0.846468,
		-0.136021,
		-0.514773,
		0,
		-0.531115,
		0.283885,
		0.798327,
		0,
		0.037547,
		0.949161,
		-0.312542,
		0,
		0.015882,
		-0.369481,
		-0.424148,
		1,
	},
	[1.21666666667] = {
		-0.793987,
		-0.155068,
		-0.587826,
		0,
		-0.602899,
		0.325049,
		0.728599,
		0,
		0.07809,
		0.932897,
		-0.351575,
		0,
		0.0084,
		-0.39224,
		-0.430984,
		1,
	},
	[1.23333333333] = {
		-0.785992,
		-0.157356,
		-0.597876,
		0,
		-0.612468,
		0.329987,
		0.718326,
		0,
		0.084258,
		0.930778,
		-0.355743,
		0,
		0.007302,
		-0.394511,
		-0.431544,
		1,
	},
	[1.25] = {
		-0.777988,
		-0.159506,
		-0.607694,
		0,
		-0.621739,
		0.334649,
		0.708132,
		0,
		0.090413,
		0.928746,
		-0.359524,
		0,
		0.006214,
		-0.396547,
		-0.432039,
		1,
	},
	[1.26666666667] = {
		-0.770018,
		-0.161504,
		-0.617242,
		0,
		-0.630679,
		0.339022,
		0.698074,
		0,
		0.096517,
		0.926812,
		-0.362911,
		0,
		0.005141,
		-0.398351,
		-0.432483,
		1,
	},
	[1.28333333333] = {
		-0.762129,
		-0.163338,
		-0.626482,
		0,
		-0.639254,
		0.343097,
		0.688214,
		0,
		0.102533,
		0.924989,
		-0.365899,
		0,
		0.004089,
		-0.399927,
		-0.432888,
		1,
	},
	[1.2] = {
		-0.801929,
		-0.152652,
		-0.577587,
		0,
		-0.593071,
		0.319847,
		0.738894,
		0,
		0.071946,
		0.935091,
		-0.347028,
		0,
		0.009501,
		-0.38973,
		-0.430346,
		1,
	},
	[1.31666666667] = {
		-0.746786,
		-0.166494,
		-0.643887,
		0,
		-0.655196,
		0.350344,
		0.669311,
		0,
		0.114146,
		0.921704,
		-0.370718,
		0,
		0.002072,
		-0.402432,
		-0.433613,
		1,
	},
	[1.33333333333] = {
		-0.739432,
		-0.167869,
		-0.651966,
		0,
		-0.66251,
		0.353576,
		0.660352,
		0,
		0.119667,
		0.92022,
		-0.37266,
		0,
		0.001118,
		-0.403421,
		-0.433907,
		1,
	},
	[1.35] = {
		-0.73236,
		-0.16912,
		-0.659581,
		0,
		-0.669355,
		0.356557,
		0.65179,
		0,
		0.124948,
		0.918839,
		-0.37433,
		0,
		0.000207,
		-0.404258,
		-0.434156,
		1,
	},
	[1.36666666667] = {
		-0.725623,
		-0.170249,
		-0.666698,
		0,
		-0.67571,
		0.359288,
		0.643683,
		0,
		0.129951,
		0.917566,
		-0.375747,
		0,
		-0.000654,
		-0.404956,
		-0.434364,
		1,
	},
	[1.38333333333] = {
		-0.719275,
		-0.171258,
		-0.673286,
		0,
		-0.681554,
		0.361768,
		0.636088,
		0,
		0.134638,
		0.916403,
		-0.376932,
		0,
		-0.001459,
		-0.405528,
		-0.434533,
		1,
	},
	[1.3] = {
		-0.754368,
		-0.164994,
		-0.635378,
		0,
		-0.647436,
		0.346863,
		0.678611,
		0,
		0.108422,
		0.923289,
		-0.368485,
		0,
		0.003065,
		-0.401278,
		-0.433268,
		1,
	},
	[1.41666666667] = {
		-0.707963,
		-0.172925,
		-0.684752,
		0,
		-0.691637,
		0.36597,
		0.62266,
		0,
		0.142925,
		0.914419,
		-0.378694,
		0,
		-0.002883,
		-0.406341,
		-0.434775,
		1,
	},
	[1.43333333333] = {
		-0.703108,
		-0.173588,
		-0.68957,
		0,
		-0.695838,
		0.367689,
		0.61694,
		0,
		0.146454,
		0.913604,
		-0.379314,
		0,
		-0.003489,
		-0.406609,
		-0.434854,
		1,
	},
	[1.45] = {
		-0.69886,
		-0.174139,
		-0.693736,
		0,
		-0.699454,
		0.36915,
		0.611957,
		0,
		0.149527,
		0.912909,
		-0.379787,
		0,
		-0.004017,
		-0.4068,
		-0.434911,
		1,
	},
	[1.46666666667] = {
		-0.695272,
		-0.174584,
		-0.697221,
		0,
		-0.702466,
		0.370352,
		0.607767,
		0,
		0.152111,
		0.912337,
		-0.380135,
		0,
		-0.004462,
		-0.406928,
		-0.434949,
		1,
	},
	[1.48333333333] = {
		-0.692396,
		-0.174923,
		-0.699993,
		0,
		-0.704853,
		0.371292,
		0.60442,
		0,
		0.154175,
		0.91189,
		-0.380377,
		0,
		-0.004817,
		-0.407006,
		-0.434972,
		1,
	},
	[1.4] = {
		-0.71337,
		-0.172149,
		-0.679315,
		0,
		-0.686869,
		0.363996,
		0.629061,
		0,
		0.138975,
		0.915353,
		-0.377908,
		0,
		-0.002204,
		-0.405985,
		-0.434669,
		1,
	},
	[1.51666666667] = {
		-0.688981,
		-0.175302,
		-0.70326,
		0,
		-0.707657,
		0.372375,
		0.600466,
		0,
		0.156614,
		0.911376,
		-0.380612,
		0,
		-0.005239,
		-0.40706,
		-0.434988,
		1,
	},
	[1.53333333333] = {
		-0.688537,
		-0.175348,
		-0.703683,
		0,
		-0.708019,
		0.372511,
		0.599954,
		0,
		0.156929,
		0.911311,
		-0.380637,
		0,
		-0.005294,
		-0.407062,
		-0.434989,
		1,
	},
	[1.5] = {
		-0.690282,
		-0.175161,
		-0.702017,
		0,
		-0.706592,
		0.371968,
		0.60197,
		0,
		0.155686,
		0.911569,
		-0.38053,
		0,
		-0.005078,
		-0.407045,
		-0.434984,
		1,
	},
}

return spline_matrices
