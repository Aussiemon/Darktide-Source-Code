﻿-- chunkname: @content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right_diagonal_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.261524,
		-0.457392,
		0.84994,
		0,
		0.705867,
		-0.509958,
		-0.491625,
		0,
		0.658299,
		0.728516,
		0.189491,
		0,
		0.545173,
		-0.168084,
		-1.096332,
		1
	},
	[0.0333333333333] = {
		0.255526,
		-0.435569,
		0.863126,
		0,
		0.639257,
		-0.593635,
		-0.488823,
		0,
		0.725298,
		0.676666,
		0.126752,
		0,
		0.519246,
		-0.180443,
		-1.092082,
		1
	},
	[0.05] = {
		0.251752,
		-0.411137,
		0.876121,
		0,
		0.56037,
		-0.67616,
		-0.478323,
		0,
		0.789054,
		0.61137,
		0.060164,
		0,
		0.47728,
		-0.191717,
		-1.081231,
		1
	},
	[0.0666666666667] = {
		0.250817,
		-0.383942,
		0.888639,
		0,
		0.467926,
		-0.755528,
		-0.458502,
		0,
		0.847429,
		0.530817,
		-0.009842,
		0,
		0.420666,
		-0.201896,
		-1.064284,
		1
	},
	[0.0833333333333] = {
		0.253467,
		-0.354016,
		0.900237,
		0,
		0.361112,
		-0.828725,
		-0.427567,
		0,
		0.897414,
		0.433461,
		-0.082215,
		0,
		0.350766,
		-0.210811,
		-1.041661,
		1
	},
	[0] = {
		0.269281,
		-0.476862,
		0.836714,
		0,
		0.761644,
		-0.426262,
		-0.488057,
		0,
		0.589395,
		0.768703,
		0.248415,
		0,
		0.553608,
		-0.154535,
		-1.093389,
		1
	},
	[0.116666666667] = {
		0.272753,
		-0.287591,
		0.918094,
		0,
		0.105985,
		-0.939487,
		-0.325779,
		0,
		0.956229,
		0.186161,
		-0.225767,
		0,
		0.176754,
		-0.223125,
		-0.980714,
		1
	},
	[0.133333333333] = {
		0.290743,
		-0.25291,
		0.92277,
		0,
		-0.037693,
		-0.966711,
		-0.253077,
		0,
		0.956059,
		0.038798,
		-0.290597,
		0,
		0.075843,
		-0.225069,
		-0.943008,
		1
	},
	[0.15] = {
		0.31466,
		-0.219183,
		0.923552,
		0,
		-0.185825,
		-0.968372,
		-0.166509,
		0,
		0.930837,
		-0.119225,
		-0.345438,
		0,
		-0.031731,
		-0.2229,
		-0.901014,
		1
	},
	[0.166666666667] = {
		0.344088,
		-0.18825,
		0.919873,
		0,
		-0.331446,
		-0.940978,
		-0.068588,
		0,
		0.878491,
		-0.281288,
		-0.386173,
		0,
		-0.143535,
		-0.215569,
		-0.855375,
		1
	},
	[0.183333333333] = {
		0.377931,
		-0.161954,
		0.911559,
		0,
		-0.466705,
		-0.88366,
		0.036498,
		0,
		0.799596,
		-0.439223,
		-0.409547,
		0,
		-0.256749,
		-0.202205,
		-0.807033,
		1
	},
	[0.1] = {
		0.26052,
		-0.32167,
		0.910306,
		0,
		0.239992,
		-0.891695,
		-0.383776,
		0,
		0.935165,
		0.318447,
		-0.155106,
		0,
		0.268964,
		-0.21809,
		-1.013704,
		1
	},
	[0.216666666667] = {
		0.451794,
		-0.128564,
		0.88281,
		0,
		-0.678459,
		-0.692075,
		0.246427,
		0,
		0.579289,
		-0.710284,
		-0.399901,
		0,
		-0.475063,
		-0.156016,
		-0.707542,
		1
	},
	[0.233333333333] = {
		0.487817,
		-0.122291,
		0.864338,
		0,
		-0.746842,
		-0.571094,
		0.340703,
		0,
		0.451953,
		-0.811724,
		-0.369922,
		0,
		-0.574147,
		-0.123874,
		-0.659542,
		1
	},
	[0.25] = {
		0.520956,
		-0.12221,
		0.84479,
		0,
		-0.789836,
		-0.444302,
		0.422793,
		0,
		0.323672,
		-0.887502,
		-0.327988,
		0,
		-0.663022,
		-0.086942,
		-0.614845,
		1
	},
	[0.266666666667] = {
		0.550154,
		-0.127042,
		0.825343,
		0,
		-0.810458,
		-0.319389,
		0.491069,
		0,
		0.201219,
		-0.939069,
		-0.278676,
		0,
		-0.7396,
		-0.046472,
		-0.574881,
		1
	},
	[0.283333333333] = {
		0.57494,
		-0.135273,
		0.806936,
		0,
		-0.813281,
		-0.202419,
		0.545528,
		0,
		0.089544,
		-0.969911,
		-0.226393,
		0,
		-0.802184,
		-0.00373,
		-0.54086,
		1
	},
	[0.2] = {
		0.414505,
		-0.141785,
		0.898934,
		0,
		-0.584209,
		-0.798837,
		0.143386,
		0,
		0.697772,
		-0.5846,
		-0.413954,
		0,
		-0.368295,
		-0.182332,
		-0.75725,
		1
	},
	[0.316666666667] = {
		0.611652,
		-0.156115,
		0.775571,
		0,
		-0.785873,
		-0.007107,
		0.618347,
		0,
		-0.091021,
		-0.987713,
		-0.127033,
		0,
		-0.879804,
		0.084215,
		-0.494446,
		1
	},
	[0.333333333333] = {
		0.624424,
		-0.166317,
		0.763173,
		0,
		-0.764884,
		0.067771,
		0.640593,
		0,
		-0.158263,
		-0.983741,
		-0.084895,
		0,
		-0.892322,
		0.127738,
		-0.483581,
		1
	},
	[0.35] = {
		0.636765,
		-0.166326,
		0.752905,
		0,
		-0.742589,
		0.130601,
		0.656891,
		0,
		-0.207588,
		-0.977384,
		-0.040349,
		0,
		-0.894695,
		0.177415,
		-0.481145,
		1
	},
	[0.366666666667] = {
		0.651117,
		-0.152822,
		0.743433,
		0,
		-0.71979,
		0.186343,
		0.668714,
		0,
		-0.240727,
		-0.970527,
		0.011332,
		0,
		-0.895883,
		0.238981,
		-0.485339,
		1
	},
	[0.383333333333] = {
		0.666254,
		-0.133792,
		0.733624,
		0,
		-0.697528,
		0.236124,
		0.676535,
		0,
		-0.263742,
		-0.962468,
		0.063995,
		0,
		-0.896161,
		0.310229,
		-0.494187,
		1
	},
	[0.3] = {
		0.595326,
		-0.145405,
		0.790218,
		0,
		-0.803441,
		-0.097528,
		0.587342,
		0,
		-0.008334,
		-0.984554,
		-0.174885,
		0,
		-0.849345,
		0.040146,
		-0.513775,
		1
	},
	[0.416666666667] = {
		0.691994,
		-0.109218,
		0.713594,
		0,
		-0.65556,
		0.318862,
		0.68452,
		0,
		-0.3023,
		-0.941487,
		0.149052,
		0,
		-0.894485,
		0.472052,
		-0.518415,
		1
	},
	[0.433333333333] = {
		0.698522,
		-0.11861,
		0.70569,
		0,
		-0.635307,
		0.35105,
		0.687858,
		0,
		-0.329319,
		-0.928814,
		0.169863,
		0,
		-0.892769,
		0.557388,
		-0.530303,
		1
	},
	[0.45] = {
		0.696834,
		-0.153001,
		0.700724,
		0,
		-0.61469,
		0.376009,
		0.693378,
		0,
		-0.369566,
		-0.913897,
		0.167968,
		0,
		-0.890334,
		0.642452,
		-0.539686,
		1
	},
	[0.466666666667] = {
		0.681502,
		-0.220517,
		0.697801,
		0,
		-0.59314,
		0.392066,
		0.703185,
		0,
		-0.428648,
		-0.893116,
		0.136396,
		0,
		-0.886598,
		0.725023,
		-0.544509,
		1
	},
	[0.483333333333] = {
		0.638586,
		-0.331058,
		0.694701,
		0,
		-0.57595,
		0.393108,
		0.716762,
		0,
		-0.510382,
		-0.857827,
		0.06036,
		0,
		-0.861303,
		0.815637,
		-0.521288,
		1
	},
	[0.4] = {
		0.680497,
		-0.116801,
		0.723382,
		0,
		-0.67615,
		0.280364,
		0.681335,
		0,
		-0.282391,
		-0.952761,
		0.111812,
		0,
		-0.895648,
		0.388796,
		-0.505804,
		1
	},
	[0.516666666667] = {
		0.380267,
		-0.674558,
		0.632747,
		0,
		-0.504577,
		0.42205,
		0.753177,
		0,
		-0.775113,
		-0.605678,
		-0.179875,
		0,
		-0.659687,
		1.069583,
		-0.355875,
		1
	},
	[0.533333333333] = {
		0.182643,
		-0.825678,
		0.533757,
		0,
		-0.42415,
		0.423601,
		0.800412,
		0,
		-0.886983,
		-0.372583,
		-0.272844,
		0,
		-0.446142,
		1.230347,
		-0.243742,
		1
	},
	[0.55] = {
		-0.05416,
		-0.917851,
		0.393212,
		0,
		-0.319441,
		0.389022,
		0.864072,
		0,
		-0.946057,
		-0.07881,
		-0.314268,
		0,
		-0.188866,
		1.362992,
		-0.115036,
		1
	},
	[0.566666666667] = {
		-0.354592,
		-0.905314,
		0.23382,
		0,
		-0.16942,
		0.308138,
		0.936135,
		0,
		-0.919544,
		0.292332,
		-0.262641,
		0,
		0.08626,
		1.42135,
		0.030265,
		1
	},
	[0.583333333333] = {
		-0.756382,
		-0.646724,
		0.098151,
		0,
		0.02396,
		0.122556,
		0.992172,
		0,
		-0.653691,
		0.752813,
		-0.077203,
		0,
		0.429487,
		1.286754,
		0.248289,
		1
	},
	[0.5] = {
		0.559102,
		-0.476232,
		0.678681,
		0,
		-0.567241,
		0.377291,
		0.732044,
		0,
		-0.604683,
		-0.794263,
		-0.059194,
		0,
		-0.798348,
		0.919222,
		-0.451847,
		1
	},
	[0.616666666667] = {
		-0.966112,
		0.250808,
		-0.061023,
		0,
		-0.136443,
		-0.29552,
		0.945543,
		0,
		0.219116,
		0.921826,
		0.319726,
		0,
		1.226158,
		0.597153,
		0.837187,
		1
	},
	[0.633333333333] = {
		-0.957042,
		0.178307,
		0.228642,
		0,
		0.094216,
		-0.554525,
		0.826816,
		0,
		0.274214,
		0.81284,
		0.513904,
		0,
		1.521307,
		0.147463,
		0.734286,
		1
	},
	[0.65] = {
		-0.91259,
		-0.084532,
		0.400041,
		0,
		0.320418,
		-0.755627,
		0.57128,
		0,
		0.253991,
		0.649525,
		0.716663,
		0,
		1.660917,
		-0.153812,
		0.616068,
		1
	},
	[0.666666666667] = {
		-0.847423,
		-0.183251,
		0.498291,
		0,
		0.428935,
		-0.789398,
		0.439164,
		0,
		0.312872,
		0.585892,
		0.747557,
		0,
		1.65174,
		-0.202573,
		0.538167,
		1
	},
	[0.683333333333] = {
		-0.761346,
		-0.267245,
		0.590706,
		0,
		0.532717,
		-0.777166,
		0.335003,
		0,
		0.369548,
		0.569731,
		0.734057,
		0,
		1.611205,
		-0.227702,
		0.374866,
		1
	},
	[0.6] = {
		-0.956213,
		-0.292412,
		0.01236,
		0,
		0.041821,
		-0.094718,
		0.994625,
		0,
		-0.28967,
		0.95159,
		0.1028,
		0,
		0.777634,
		0.976836,
		0.503157,
		1
	},
	[0.716666666667] = {
		-0.495057,
		-0.388655,
		0.777088,
		0,
		0.743436,
		-0.652376,
		0.147338,
		0,
		0.44969,
		0.650656,
		0.611904,
		0,
		1.454258,
		-0.222074,
		-0.127191,
		1
	},
	[0.733333333333] = {
		-0.307774,
		-0.41303,
		0.857135,
		0,
		0.834433,
		-0.550023,
		0.034581,
		0,
		0.457161,
		0.725865,
		0.513929,
		0,
		1.345648,
		-0.200075,
		-0.422116,
		1
	},
	[0.75] = {
		-0.092397,
		-0.403129,
		0.910467,
		0,
		0.896028,
		-0.432462,
		-0.10055,
		0,
		0.434277,
		0.806513,
		0.401173,
		0,
		1.223438,
		-0.171907,
		-0.714474,
		1
	},
	[0.766666666667] = {
		0.134139,
		-0.358073,
		0.924008,
		0,
		0.914427,
		-0.314596,
		-0.254661,
		0,
		0.381877,
		0.879098,
		0.285232,
		0,
		1.09494,
		-0.141987,
		-0.979027,
		1
	},
	[0.783333333333] = {
		0.35079,
		-0.286884,
		0.891428,
		0,
		0.883688,
		-0.213613,
		-0.416491,
		0,
		0.309905,
		0.933845,
		0.178583,
		0,
		0.969615,
		-0.113138,
		-1.190723,
		1
	},
	[0.7] = {
		-0.646043,
		-0.337293,
		0.684734,
		0,
		0.638874,
		-0.729837,
		0.243265,
		0,
		0.417693,
		0.594619,
		0.686994,
		0,
		1.544092,
		-0.232853,
		0.146038,
		1
	},
	[0.816666666667] = {
		0.691809,
		-0.144641,
		0.707446,
		0,
		0.698723,
		-0.113084,
		-0.706398,
		0,
		0.182175,
		0.983001,
		0.022831,
		0,
		0.770309,
		-0.059539,
		-1.362719,
		1
	},
	[0.833333333333] = {
		0.699011,
		-0.135739,
		0.70211,
		0,
		0.695375,
		-0.10005,
		-0.711649,
		0,
		0.166845,
		0.98568,
		0.024453,
		0,
		0.736483,
		-0.030959,
		-1.347715,
		1
	},
	[0.85] = {
		0.704113,
		-0.129007,
		0.698271,
		0,
		0.692513,
		-0.092669,
		-0.715428,
		0,
		0.157003,
		0.987304,
		0.024089,
		0,
		0.714165,
		-0.012892,
		-1.337953,
		1
	},
	[0.866666666667] = {
		0.705903,
		-0.127304,
		0.696775,
		0,
		0.691208,
		-0.091047,
		-0.716897,
		0,
		0.154703,
		0.987676,
		0.023723,
		0,
		0.706112,
		-0.007196,
		-1.334468,
		1
	},
	[0.883333333333] = {
		0.705626,
		-0.129029,
		0.696737,
		0,
		0.691014,
		-0.092306,
		-0.716924,
		0,
		0.156817,
		0.987335,
		0.024027,
		0,
		0.706099,
		-0.008297,
		-1.334468,
		1
	},
	[0.8] = {
		0.539778,
		-0.207893,
		0.815733,
		0,
		0.808007,
		-0.143882,
		-0.571335,
		0,
		0.236146,
		0.967511,
		0.090315,
		0,
		0.858011,
		-0.086042,
		-1.325886,
		1
	},
	[0.916666666667] = {
		0.705121,
		-0.132133,
		0.696667,
		0,
		0.690656,
		-0.094571,
		-0.716973,
		0,
		0.160621,
		0.98671,
		0.024574,
		0,
		0.706068,
		-0.010279,
		-1.334471,
		1
	},
	[0.933333333333] = {
		0.704914,
		-0.133387,
		0.696638,
		0,
		0.690508,
		-0.095487,
		-0.716994,
		0,
		0.162158,
		0.986453,
		0.024795,
		0,
		0.706052,
		-0.01108,
		-1.334473,
		1
	},
	[0.95] = {
		0.704752,
		-0.134361,
		0.696615,
		0,
		0.690393,
		-0.096197,
		-0.717011,
		0,
		0.163351,
		0.986252,
		0.024966,
		0,
		0.706039,
		-0.011702,
		-1.334475,
		1
	},
	[0.966666666667] = {
		0.704646,
		-0.13499,
		0.6966,
		0,
		0.690317,
		-0.096657,
		-0.717021,
		0,
		0.164122,
		0.986121,
		0.025077,
		0,
		0.706029,
		-0.012105,
		-1.334476,
		1
	},
	[0.983333333333] = {
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.706026,
		-0.012248,
		-1.334477,
		1
	},
	[0.9] = {
		0.705362,
		-0.130659,
		0.696701,
		0,
		0.690827,
		-0.093496,
		-0.716949,
		0,
		0.158815,
		0.987009,
		0.024314,
		0,
		0.706084,
		-0.009338,
		-1.33447,
		1
	},
	{
		0.704609,
		-0.135214,
		0.696595,
		0,
		0.69029,
		-0.09682,
		-0.717025,
		0,
		0.164396,
		0.986075,
		0.025117,
		0,
		0.706026,
		-0.012248,
		-1.334477,
		1
	}
}

return spline_matrices
