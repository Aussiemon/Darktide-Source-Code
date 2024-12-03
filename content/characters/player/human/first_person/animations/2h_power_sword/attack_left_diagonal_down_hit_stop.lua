﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_power_sword/attack_left_diagonal_down_hit_stop.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.720865,
		-0.103054,
		0.685371,
		0,
		0.690415,
		-0.193339,
		0.697099,
		0,
		0.06067,
		0.975705,
		0.210522,
		0,
		-0.03231,
		0.759516,
		-0.19478,
		1,
	},
	[0.0333333333333] = {
		-0.791317,
		-0.120777,
		0.599358,
		0,
		0.611133,
		-0.126991,
		0.781274,
		0,
		-0.018247,
		0.984523,
		0.174301,
		0,
		-0.057549,
		0.755398,
		-0.201791,
		1,
	},
	[0.05] = {
		-0.575054,
		-0.124327,
		0.808614,
		0,
		0.817355,
		-0.129921,
		0.561295,
		0,
		0.035271,
		0.983699,
		0.176331,
		0,
		-0.070651,
		0.756338,
		-0.181237,
		1,
	},
	[0.0666666666667] = {
		-0.400758,
		-0.136957,
		0.905889,
		0,
		0.913948,
		-0.128796,
		0.384851,
		0,
		0.063967,
		0.982168,
		0.176788,
		0,
		-0.122469,
		0.756479,
		-0.183081,
		1,
	},
	[0.0833333333333] = {
		-0.361309,
		-0.156111,
		0.919285,
		0,
		0.928876,
		-0.146454,
		0.340208,
		0,
		0.081522,
		0.976822,
		0.197923,
		0,
		-0.182974,
		0.760295,
		-0.216145,
		1,
	},
	[0] = {
		-0.61423,
		-0.095035,
		0.783383,
		0,
		0.757997,
		-0.34713,
		0.552214,
		0,
		0.219456,
		0.932989,
		0.285254,
		0,
		0.013782,
		0.760548,
		-0.172111,
		1,
	},
	[0.116666666667] = {
		-0.245952,
		-0.178496,
		0.952705,
		0,
		0.965277,
		0.04416,
		0.257471,
		0,
		-0.088029,
		0.982949,
		0.161437,
		0,
		-0.251766,
		0.755485,
		-0.266606,
		1,
	},
	[0.133333333333] = {
		-0.242828,
		-0.16477,
		0.955973,
		0,
		0.94089,
		0.199879,
		0.273448,
		0,
		-0.236135,
		0.965867,
		0.106495,
		0,
		-0.268429,
		0.72528,
		-0.275834,
		1,
	},
	[0.15] = {
		-0.276729,
		-0.124041,
		0.952909,
		0,
		0.883933,
		0.356118,
		0.303055,
		0,
		-0.376939,
		0.926172,
		0.011096,
		0,
		-0.274247,
		0.628977,
		-0.263899,
		1,
	},
	[0.166666666667] = {
		-0.272796,
		-0.081511,
		0.958613,
		0,
		0.825574,
		0.491768,
		0.276752,
		0,
		-0.493973,
		0.866903,
		-0.066859,
		0,
		-0.270992,
		0.496048,
		-0.245805,
		1,
	},
	[0.183333333333] = {
		-0.242784,
		-0.0494,
		0.968822,
		0,
		0.785549,
		0.575965,
		0.226225,
		0,
		-0.569182,
		0.815981,
		-0.101029,
		0,
		-0.267492,
		0.399054,
		-0.25239,
		1,
	},
	[0.1] = {
		-0.302223,
		-0.177894,
		0.936491,
		0,
		0.950441,
		-0.131431,
		0.281759,
		0,
		0.072961,
		0.975233,
		0.208799,
		0,
		-0.229262,
		0.764611,
		-0.24661,
		1,
	},
	[0.216666666667] = {
		-0.224669,
		-0.089633,
		0.970304,
		0,
		0.749333,
		0.620657,
		0.230838,
		0,
		-0.622916,
		0.778942,
		-0.072278,
		0,
		-0.276081,
		0.286853,
		-0.345647,
		1,
	},
	[0.233333333333] = {
		-0.207374,
		-0.127866,
		0.969869,
		0,
		0.738514,
		0.629723,
		0.240928,
		0,
		-0.641555,
		0.766224,
		-0.036157,
		0,
		-0.279597,
		0.236662,
		-0.391685,
		1,
	},
	[0.25] = {
		-0.164304,
		-0.12396,
		0.97859,
		0,
		0.729645,
		0.652332,
		0.205138,
		0,
		-0.663794,
		0.747728,
		-0.016734,
		0,
		-0.276551,
		0.194309,
		-0.418356,
		1,
	},
	[0.266666666667] = {
		-0.120114,
		-0.085324,
		0.989087,
		0,
		0.717853,
		0.680736,
		0.1459,
		0,
		-0.685755,
		0.727543,
		-0.020516,
		0,
		-0.26757,
		0.166513,
		-0.430628,
		1,
	},
	[0.283333333333] = {
		-0.107437,
		-0.053671,
		0.992762,
		0,
		0.704548,
		0.700422,
		0.114113,
		0,
		-0.701477,
		0.711709,
		-0.037438,
		0,
		-0.256915,
		0.162234,
		-0.440041,
		1,
	},
	[0.2] = {
		-0.227623,
		-0.051995,
		0.97236,
		0,
		0.763718,
		0.609956,
		0.211398,
		0,
		-0.604089,
		0.790728,
		-0.099131,
		0,
		-0.270624,
		0.341903,
		-0.293424,
		1,
	},
	[0.316666666667] = {
		-0.146902,
		-0.003787,
		0.989144,
		0,
		0.687793,
		0.718288,
		0.104897,
		0,
		-0.710887,
		0.695736,
		-0.102914,
		0,
		-0.230803,
		0.192997,
		-0.455713,
		1,
	},
	[0.333333333333] = {
		-0.183781,
		0.018188,
		0.982799,
		0,
		0.684535,
		0.719903,
		0.114684,
		0,
		-0.705434,
		0.693837,
		-0.144755,
		0,
		-0.215373,
		0.215897,
		-0.461933,
		1,
	},
	[0.35] = {
		-0.229074,
		0.03852,
		0.972647,
		0,
		0.682827,
		0.71849,
		0.132362,
		0,
		-0.693738,
		0.69447,
		-0.190889,
		0,
		-0.198717,
		0.242747,
		-0.466939,
		1,
	},
	[0.366666666667] = {
		-0.280384,
		0.057518,
		0.958163,
		0,
		0.681235,
		0.715159,
		0.156417,
		0,
		-0.676243,
		0.696591,
		-0.239703,
		0,
		-0.181105,
		0.27273,
		-0.470624,
		1,
	},
	[0.383333333333] = {
		-0.335014,
		0.075378,
		0.939193,
		0,
		0.678584,
		0.710843,
		0.185003,
		0,
		-0.653673,
		0.6993,
		-0.289292,
		0,
		-0.162949,
		0.305034,
		-0.472821,
		1,
	},
	[0.3] = {
		-0.120732,
		-0.027736,
		0.992298,
		0,
		0.694056,
		0.712318,
		0.104355,
		0,
		-0.709726,
		0.701309,
		-0.06675,
		0,
		-0.24474,
		0.174867,
		-0.448378,
		1,
	},
	[0.416666666667] = {
		-0.444124,
		0.107243,
		0.889524,
		0,
		0.670103,
		0.698784,
		0.250324,
		0,
		-0.594739,
		0.707248,
		-0.382211,
		0,
		-0.126614,
		0.373466,
		-0.472054,
		1,
	},
	[0.433333333333] = {
		-0.494508,
		0.120555,
		0.860772,
		0,
		0.66884,
		0.685239,
		0.288272,
		0,
		-0.555082,
		0.718271,
		-0.419488,
		0,
		-0.108948,
		0.408175,
		-0.468773,
		1,
	},
	[0.45] = {
		-0.539601,
		0.132333,
		0.831456,
		0,
		0.669816,
		0.665794,
		0.328732,
		0,
		-0.510076,
		0.734307,
		-0.447902,
		0,
		-0.092065,
		0.44218,
		-0.463649,
		1,
	},
	[0.466666666667] = {
		-0.577987,
		0.142423,
		0.803521,
		0,
		0.672766,
		0.640454,
		0.370412,
		0,
		-0.461863,
		0.754675,
		-0.465992,
		0,
		-0.07633,
		0.474683,
		-0.456805,
		1,
	},
	[0.483333333333] = {
		-0.608684,
		0.150216,
		0.779063,
		0,
		0.677614,
		0.609206,
		0.411956,
		0,
		-0.412728,
		0.778654,
		-0.472602,
		0,
		-0.062115,
		0.504886,
		-0.448374,
		1,
	},
	[0.4] = {
		-0.390294,
		0.092137,
		0.916068,
		0,
		0.674094,
		0.706308,
		0.216161,
		0,
		-0.62711,
		0.701883,
		-0.337777,
		0,
		-0.144702,
		0.338849,
		-0.473375,
		1,
	},
	[0.516666666667] = {
		-0.647938,
		0.156472,
		0.745448,
		0,
		0.691974,
		0.529959,
		0.490219,
		0,
		-0.318352,
		0.833463,
		-0.451655,
		0,
		-0.038595,
		0.556277,
		-0.427914,
		1,
	},
	[0.533333333333] = {
		-0.661891,
		0.157544,
		0.732858,
		0,
		0.6987,
		0.483783,
		0.527041,
		0,
		-0.271512,
		0.860891,
		-0.430288,
		0,
		-0.027569,
		0.578178,
		-0.417454,
		1,
	},
	[0.55] = {
		-0.672918,
		0.147503,
		0.724862,
		0,
		0.702748,
		0.433389,
		0.564198,
		0,
		-0.230926,
		0.889054,
		-0.395292,
		0,
		-0.016831,
		0.600631,
		-0.406634,
		1,
	},
	[0.566666666667] = {
		-0.681515,
		0.119216,
		0.722028,
		0,
		0.703803,
		0.377088,
		0.602051,
		0,
		-0.200494,
		0.918473,
		-0.340896,
		0,
		-0.00644,
		0.625769,
		-0.394985,
		1,
	},
	[0.583333333333] = {
		-0.687723,
		0.077486,
		0.721826,
		0,
		0.704031,
		0.31379,
		0.637084,
		0,
		-0.177137,
		0.946325,
		-0.270353,
		0,
		0.003649,
		0.651783,
		-0.382742,
		1,
	},
	[0.5] = {
		-0.631097,
		0.154625,
		0.760137,
		0,
		0.684447,
		0.572138,
		0.451874,
		0,
		-0.365032,
		0.80545,
		-0.466907,
		0,
		-0.04979,
		0.531988,
		-0.438491,
		1,
	},
	[0.616666666667] = {
		-0.693669,
		-0.027159,
		0.719781,
		0,
		0.706946,
		0.165815,
		0.687556,
		0,
		-0.138024,
		0.985783,
		-0.095821,
		0,
		0.022599,
		0.699226,
		-0.357406,
		1,
	},
	[0.633333333333] = {
		-0.69505,
		-0.079991,
		0.714498,
		0,
		0.709691,
		0.082741,
		0.699637,
		0,
		-0.115083,
		0.993356,
		-0.00074,
		0,
		0.031496,
		0.717087,
		-0.344809,
		1,
	},
	[0.65] = {
		-0.697619,
		-0.126348,
		0.705241,
		0,
		0.711343,
		-0.004611,
		0.702829,
		0,
		-0.085549,
		0.991975,
		0.093094,
		0,
		0.040155,
		0.728703,
		-0.332589,
		1,
	},
	[0.666666666667] = {
		-0.703792,
		-0.161311,
		0.691849,
		0,
		0.708846,
		-0.094962,
		0.698941,
		0,
		-0.047047,
		0.982324,
		0.181178,
		0,
		0.048697,
		0.732354,
		-0.320965,
		1,
	},
	[0.683333333333] = {
		-0.714609,
		-0.186202,
		0.674287,
		0,
		0.699524,
		-0.19073,
		0.688686,
		0,
		0.000372,
		0.963821,
		0.26655,
		0,
		0.057206,
		0.73128,
		-0.309516,
		1,
	},
	[0.6] = {
		-0.691612,
		0.027053,
		0.721763,
		0,
		0.704888,
		0.243192,
		0.666326,
		0,
		-0.157501,
		0.969601,
		-0.187263,
		0,
		0.01335,
		0.676867,
		-0.370134,
		1,
	},
	[0.716666666667] = {
		-0.744983,
		-0.221768,
		0.629141,
		0,
		0.658386,
		-0.396235,
		0.639942,
		0,
		0.10737,
		0.890964,
		0.441198,
		0,
		0.073943,
		0.726952,
		-0.286325,
		1,
	},
	[0.733333333333] = {
		-0.762427,
		-0.234036,
		0.603269,
		0,
		0.626914,
		-0.498069,
		0.599087,
		0,
		0.160262,
		0.834958,
		0.526461,
		0,
		0.082036,
		0.722968,
		-0.275163,
		1,
	},
	[0.75] = {
		-0.779972,
		-0.243761,
		0.576389,
		0,
		0.5898,
		-0.594256,
		0.546804,
		0,
		0.209234,
		0.766446,
		0.607274,
		0,
		0.089869,
		0.717386,
		-0.26454,
		1,
	},
	[0.766666666667] = {
		-0.796749,
		-0.251753,
		0.549373,
		0,
		0.548995,
		-0.681504,
		0.483898,
		0,
		0.252577,
		0.687148,
		0.681199,
		0,
		0.097453,
		0.709948,
		-0.25461,
		1,
	},
	[0.783333333333] = {
		-0.811985,
		-0.258655,
		0.523237,
		0,
		0.50681,
		-0.757109,
		0.412226,
		0,
		0.289523,
		0.599903,
		0.74585,
		0,
		0.10483,
		0.700363,
		-0.245684,
		1,
	},
	[0.7] = {
		-0.728679,
		-0.206084,
		0.653113,
		0,
		0.682799,
		-0.292458,
		0.669517,
		0,
		0.053031,
		0.933808,
		0.353822,
		0,
		0.06564,
		0.729605,
		-0.297876,
		1,
	},
	[0.816666666667] = {
		-0.841151,
		-0.26657,
		0.470538,
		0,
		0.408636,
		-0.883207,
		0.230137,
		0,
		0.354234,
		0.385858,
		0.85184,
		0,
		0.120159,
		0.666969,
		-0.232031,
		1,
	},
	[0.833333333333] = {
		-0.855437,
		-0.268136,
		0.443093,
		0,
		0.354856,
		-0.926615,
		0.12435,
		0,
		0.377234,
		0.263607,
		0.88781,
		0,
		0.127842,
		0.645054,
		-0.226976,
		1,
	},
	[0.85] = {
		-0.868843,
		-0.269381,
		0.415385,
		0,
		0.304402,
		-0.952352,
		0.019096,
		0,
		0.390449,
		0.143035,
		0.909445,
		0,
		0.135144,
		0.623014,
		-0.222597,
		1,
	},
	[0.866666666667] = {
		-0.880879,
		-0.271345,
		0.387846,
		0,
		0.26249,
		-0.961875,
		-0.076777,
		0,
		0.393892,
		0.034175,
		0.918521,
		0,
		0.141753,
		0.603407,
		-0.218416,
		1,
	},
	[0.883333333333] = {
		-0.891053,
		-0.275193,
		0.360961,
		0,
		0.233806,
		-0.959904,
		-0.154659,
		0,
		0.389049,
		-0.053415,
		0.919667,
		0,
		0.14731,
		0.588797,
		-0.213876,
		1,
	},
	[0.8] = {
		-0.826485,
		-0.263747,
		0.497352,
		0,
		0.460698,
		-0.824615,
		0.328279,
		0,
		0.323542,
		0.500447,
		0.80304,
		0,
		0.112371,
		0.686233,
		-0.238158,
		1,
	},
	[0.916666666667] = {
		-0.908292,
		-0.291547,
		0.300011,
		0,
		0.207987,
		-0.93695,
		-0.280829,
		0,
		0.362971,
		-0.192676,
		0.911662,
		0,
		0.157034,
		0.568077,
		-0.202525,
		1,
	},
	[0.933333333333] = {
		-0.91514,
		-0.302828,
		0.266109,
		0,
		0.206116,
		-0.918769,
		-0.336719,
		0,
		0.34646,
		-0.253296,
		0.90322,
		0,
		0.1616,
		0.559238,
		-0.196249,
		1,
	},
	[0.95] = {
		-0.92021,
		-0.314968,
		0.232399,
		0,
		0.210051,
		-0.898351,
		-0.385803,
		0,
		0.330292,
		-0.306204,
		0.892831,
		0,
		0.165778,
		0.551553,
		-0.190034,
		1,
	},
	[0.966666666667] = {
		-0.92342,
		-0.327085,
		0.200774,
		0,
		0.218012,
		-0.877583,
		-0.426988,
		0,
		0.315857,
		-0.350518,
		0.881687,
		0,
		0.169411,
		0.545121,
		-0.184212,
		1,
	},
	[0.983333333333] = {
		-0.924972,
		-0.33832,
		0.173107,
		0,
		0.22796,
		-0.85839,
		-0.459567,
		0,
		0.304074,
		-0.385625,
		0.87111,
		0,
		0.172334,
		0.540034,
		-0.179113,
		1,
	},
	[0.9] = {
		-0.900044,
		-0.282028,
		0.332235,
		0,
		0.216988,
		-0.951157,
		-0.219584,
		0,
		0.377937,
		-0.125545,
		0.91728,
		0,
		0.152224,
		0.577967,
		-0.208518,
		1,
	},
	[1.01666666667] = {
		-0.925233,
		-0.353903,
		0.136738,
		0,
		0.244797,
		-0.832208,
		-0.497498,
		0,
		0.28986,
		-0.426829,
		0.85662,
		0,
		0.175884,
		0.534078,
		-0.172373,
		1,
	},
	[1.03333333333] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.05] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.06666666667] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.08333333333] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	{
		-0.925364,
		-0.347628,
		0.151182,
		0,
		0.237631,
		-0.842676,
		-0.483145,
		0,
		0.295353,
		-0.411159,
		0.862389,
		0,
		0.174497,
		0.536342,
		-0.175058,
		1,
	},
	[1.11666666667] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.13333333333] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.15] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.16666666667] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
	[1.1] = {
		-0.925104,
		-0.356205,
		0.131532,
		0,
		0.247562,
		-0.828451,
		-0.502377,
		0,
		0.287917,
		-0.432189,
		0.854586,
		0,
		0.176373,
		0.533307,
		-0.1714,
		1,
	},
}

return spline_matrices
