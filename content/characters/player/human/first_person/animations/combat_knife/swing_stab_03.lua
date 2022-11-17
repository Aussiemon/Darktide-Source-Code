local spline_matrices = {
	[0] = {
		0.804226,
		0.116528,
		-0.582788,
		0,
		-0.530458,
		-0.301477,
		-0.792292,
		0,
		-0.268021,
		0.946326,
		-0.180642,
		0,
		0.077976,
		0.164259,
		-0.359566,
		1
	},
	{
		0.927384,
		-0.062618,
		0.368832,
		0,
		0.362996,
		0.389135,
		-0.846645,
		0,
		-0.09051,
		0.91905,
		0.383608,
		0,
		0.430253,
		0.103122,
		-0.519471,
		1
	},
	[0.0166666666667] = {
		0.85356,
		0.122025,
		-0.506502,
		0,
		-0.466338,
		-0.254533,
		-0.847197,
		0,
		-0.2323,
		0.959335,
		-0.160354,
		0,
		0.085345,
		0.15938,
		-0.370485,
		1
	},
	[0.0333333333333] = {
		0.898121,
		0.123232,
		-0.422128,
		0,
		-0.391839,
		-0.211446,
		-0.895407,
		0,
		-0.1996,
		0.96959,
		-0.141617,
		0,
		0.101492,
		0.141069,
		-0.389694,
		1
	},
	[0.05] = {
		0.935761,
		0.120416,
		-0.331438,
		0,
		-0.30967,
		-0.169004,
		-0.935704,
		0,
		-0.168688,
		0.978232,
		-0.120858,
		0,
		0.123942,
		0.112245,
		-0.413043,
		1
	},
	[0.0666666666667] = {
		0.964986,
		0.113292,
		-0.236574,
		0,
		-0.222509,
		-0.124022,
		-0.96701,
		0,
		-0.138895,
		0.985791,
		-0.094471,
		0,
		0.15012,
		0.075748,
		-0.436372,
		1
	},
	[0.0833333333333] = {
		0.984982,
		0.101037,
		-0.140005,
		0,
		-0.132956,
		-0.073445,
		-0.988397,
		0,
		-0.110148,
		0.992168,
		-0.058909,
		0,
		0.177261,
		0.034253,
		-0.455471,
		1
	},
	[0.116666666667] = {
		0.998449,
		0.055399,
		-0.005522,
		0,
		-0.006488,
		0.017276,
		-0.99983,
		0,
		-0.055294,
		0.998315,
		0.017609,
		0,
		0.22171,
		-0.053559,
		-0.462861,
		1
	},
	[0.133333333333] = {
		0.999316,
		0.029222,
		0.022661,
		0,
		0.020868,
		0.060286,
		-0.997963,
		0,
		-0.030529,
		0.997753,
		0.059635,
		0,
		0.232561,
		-0.094898,
		-0.442165,
		1
	},
	[0.15] = {
		0.986362,
		-0.034951,
		-0.160834,
		0,
		-0.158359,
		0.064756,
		-0.985256,
		0,
		0.044851,
		0.997289,
		0.058338,
		0,
		0.218971,
		-0.088257,
		-0.408497,
		1
	},
	[0.166666666667] = {
		0.93018,
		-0.051081,
		-0.363533,
		0,
		-0.358027,
		0.092616,
		-0.929106,
		0,
		0.081128,
		0.994391,
		0.067862,
		0,
		0.187601,
		-0.020158,
		-0.379926,
		1
	},
	[0.183333333333] = {
		0.830838,
		-0.01561,
		-0.556295,
		0,
		-0.552109,
		0.102407,
		-0.827459,
		0,
		0.069885,
		0.99462,
		0.076466,
		0,
		0.145831,
		0.062155,
		-0.357951,
		1
	},
	[0.1] = {
		0.99498,
		0.081156,
		-0.058552,
		0,
		-0.056708,
		-0.024835,
		-0.998082,
		0,
		-0.082454,
		0.996392,
		-0.020108,
		0,
		0.202232,
		-0.009681,
		-0.465817,
		1
	},
	[0.216666666667] = {
		0.555215,
		0.095199,
		-0.82624,
		0,
		-0.829034,
		-0.016234,
		-0.558963,
		0,
		-0.066626,
		0.995326,
		0.06991,
		0,
		0.057297,
		0.116175,
		-0.340448,
		1
	},
	[0.233333333333] = {
		0.413761,
		0.149987,
		-0.897945,
		0,
		-0.896994,
		-0.101389,
		-0.430258,
		0,
		-0.155575,
		0.983476,
		0.092587,
		0,
		0.01977,
		0.112901,
		-0.333206,
		1
	},
	[0.25] = {
		0.224932,
		0.241155,
		-0.94406,
		0,
		-0.95438,
		-0.140746,
		-0.263343,
		0,
		-0.196379,
		0.960227,
		0.198495,
		0,
		-0.009321,
		0.159176,
		-0.281755,
		1
	},
	[0.266666666667] = {
		0.036178,
		0.301766,
		-0.952695,
		0,
		-0.98613,
		-0.143741,
		-0.082978,
		0,
		-0.161981,
		0.942484,
		0.29238,
		0,
		-0.02715,
		0.253599,
		-0.208079,
		1
	},
	[0.283333333333] = {
		-0.102098,
		0.20472,
		-0.973481,
		0,
		-0.993353,
		-0.073275,
		0.088773,
		0,
		-0.053159,
		0.976074,
		0.21084,
		0,
		-0.023971,
		0.47522,
		-0.106627,
		1
	},
	[0.2] = {
		0.698061,
		0.04026,
		-0.714905,
		0,
		-0.715821,
		0.06383,
		-0.695361,
		0,
		0.017637,
		0.997148,
		0.073376,
		0,
		0.100603,
		0.113184,
		-0.344693,
		1
	},
	[0.316666666667] = {
		-0.278124,
		0.103878,
		-0.954912,
		0,
		-0.960543,
		-0.028242,
		0.276692,
		0,
		0.001774,
		0.994189,
		0.107634,
		0,
		-0.012049,
		0.659194,
		-0.027753,
		1
	},
	[0.333333333333] = {
		-0.312784,
		0.120942,
		-0.942093,
		0,
		-0.949824,
		-0.041018,
		0.310085,
		0,
		-0.00114,
		0.991812,
		0.127703,
		0,
		-0.00741,
		0.671193,
		-0.030044,
		1
	},
	[0.35] = {
		-0.369719,
		0.139625,
		-0.918593,
		0,
		-0.929133,
		-0.060295,
		0.364796,
		0,
		-0.004452,
		0.988367,
		0.152022,
		0,
		-0.004681,
		0.667877,
		-0.038743,
		1
	},
	[0.366666666667] = {
		-0.444774,
		0.159505,
		-0.881325,
		0,
		-0.895635,
		-0.083231,
		0.436932,
		0,
		-0.003661,
		0.983682,
		0.179878,
		0,
		-0.002744,
		0.657736,
		-0.053685,
		1
	},
	[0.383333333333] = {
		-0.513111,
		0.176657,
		-0.839946,
		0,
		-0.858321,
		-0.107193,
		0.501791,
		0,
		-0.001391,
		0.978418,
		0.206631,
		0,
		-0.001567,
		0.637639,
		-0.07325,
		1
	},
	[0.3] = {
		-0.223492,
		0.102396,
		-0.969312,
		0,
		-0.974646,
		-0.012445,
		0.223407,
		0,
		0.010813,
		0.994666,
		0.102581,
		0,
		-0.016192,
		0.645633,
		-0.032591,
		1
	},
	[0.416666666667] = {
		-0.544923,
		0.209453,
		-0.811904,
		0,
		-0.838466,
		-0.142755,
		0.525923,
		0,
		-0.005747,
		0.967342,
		0.253409,
		0,
		-0.003335,
		0.551699,
		-0.115599,
		1
	},
	[0.433333333333] = {
		-0.507429,
		0.236271,
		-0.828669,
		0,
		-0.861612,
		-0.152391,
		0.484151,
		0,
		-0.01189,
		0.959663,
		0.280901,
		0,
		-0.00568,
		0.483093,
		-0.137306,
		1
	},
	[0.45] = {
		-0.462891,
		0.260266,
		-0.847345,
		0,
		-0.886057,
		-0.163012,
		0.433969,
		0,
		-0.02518,
		0.951677,
		0.306067,
		0,
		-0.004266,
		0.411432,
		-0.160697,
		1
	},
	[0.466666666667] = {
		-0.437586,
		0.270146,
		-0.857636,
		0,
		-0.897826,
		-0.183519,
		0.400286,
		0,
		-0.049256,
		0.945168,
		0.32285,
		0,
		0.004772,
		0.349189,
		-0.187058,
		1
	},
	[0.483333333333] = {
		-0.468302,
		0.246365,
		-0.848527,
		0,
		-0.878139,
		-0.236072,
		0.416103,
		0,
		-0.0978,
		0.939986,
		0.326895,
		0,
		0.031305,
		0.29846,
		-0.223927,
		1
	},
	[0.4] = {
		-0.551486,
		0.190233,
		-0.812203,
		0,
		-0.834181,
		-0.128315,
		0.536355,
		0,
		-0.002185,
		0.973317,
		0.229453,
		0,
		-0.001379,
		0.604509,
		-0.094528,
		1
	},
	[0.516666666667] = {
		-0.529911,
		0.173672,
		-0.83008,
		0,
		-0.822402,
		-0.344152,
		0.453006,
		0,
		-0.206999,
		0.922712,
		0.325198,
		0,
		0.092748,
		0.228285,
		-0.291329,
		1
	},
	[0.533333333333] = {
		-0.475245,
		0.181844,
		-0.860857,
		0,
		-0.849424,
		-0.349911,
		0.39502,
		0,
		-0.229392,
		0.918964,
		0.320756,
		0,
		0.102279,
		0.208317,
		-0.303959,
		1
	},
	[0.55] = {
		-0.378295,
		0.209696,
		-0.901621,
		0,
		-0.894462,
		-0.333639,
		0.297695,
		0,
		-0.238391,
		0.919082,
		0.313779,
		0,
		0.111757,
		0.191171,
		-0.320786,
		1
	},
	[0.566666666667] = {
		-0.229083,
		0.252707,
		-0.940032,
		0,
		-0.944938,
		-0.289583,
		0.15243,
		0,
		-0.233697,
		0.923191,
		0.30513,
		0,
		0.122615,
		0.179093,
		-0.344058,
		1
	},
	[0.583333333333] = {
		-0.005899,
		0.308884,
		-0.951081,
		0,
		-0.974788,
		-0.213927,
		-0.063431,
		0,
		-0.223055,
		0.926729,
		0.302359,
		0,
		0.133892,
		0.171241,
		-0.373334,
		1
	},
	[0.5] = {
		-0.522068,
		0.200094,
		-0.829101,
		0,
		-0.837579,
		-0.303729,
		0.454105,
		0,
		-0.160958,
		0.93151,
		0.326161,
		0,
		0.068107,
		0.256511,
		-0.265191,
		1
	},
	[0.616666666667] = {
		0.563759,
		0.386853,
		-0.729741,
		0,
		-0.789689,
		-0.006416,
		-0.613473,
		0,
		-0.242006,
		0.922119,
		0.301876,
		0,
		0.165288,
		0.148495,
		-0.442001,
		1
	},
	[0.633333333333] = {
		0.780927,
		0.383864,
		-0.492749,
		0,
		-0.561451,
		0.085681,
		-0.823062,
		0,
		-0.273725,
		0.919406,
		0.282431,
		0,
		0.19024,
		0.133152,
		-0.476318,
		1
	},
	[0.65] = {
		0.899238,
		0.363828,
		-0.242898,
		0,
		-0.312702,
		0.146305,
		-0.938516,
		0,
		-0.305922,
		0.919904,
		0.245333,
		0,
		0.218428,
		0.11611,
		-0.506159,
		1
	},
	[0.666666666667] = {
		0.947167,
		0.320574,
		0.010334,
		0,
		-0.072097,
		0.244189,
		-0.967044,
		0,
		-0.312532,
		0.915207,
		0.2544,
		0,
		0.24689,
		0.098651,
		-0.531057,
		1
	},
	[0.683333333333] = {
		0.929226,
		0.234788,
		0.28533,
		0,
		0.173404,
		0.404797,
		-0.897814,
		0,
		-0.326297,
		0.88375,
		0.335435,
		0,
		0.274824,
		0.083002,
		-0.550528,
		1
	},
	[0.6] = {
		0.278926,
		0.360779,
		-0.889966,
		0,
		-0.93403,
		-0.113413,
		-0.338712,
		0,
		-0.223134,
		0.92573,
		0.305344,
		0,
		0.146984,
		0.161984,
		-0.406752,
		1
	},
	[0.716666666667] = {
		0.71122,
		0.003373,
		0.702962,
		0,
		0.544818,
		0.629281,
		-0.554237,
		0,
		-0.44423,
		0.77717,
		0.44572,
		0,
		0.321418,
		0.062478,
		-0.569459,
		1
	},
	[0.733333333333] = {
		0.640425,
		-0.043173,
		0.766806,
		0,
		0.602638,
		0.64719,
		-0.466876,
		0,
		-0.476113,
		0.761105,
		0.440494,
		0,
		0.334938,
		0.057098,
		-0.56773,
		1
	},
	[0.75] = {
		0.642205,
		-0.042867,
		0.765333,
		0,
		0.620521,
		0.615251,
		-0.48623,
		0,
		-0.450029,
		0.787165,
		0.421717,
		0,
		0.345429,
		0.055997,
		-0.561818,
		1
	},
	[0.766666666667] = {
		0.656854,
		-0.04026,
		0.752942,
		0,
		0.621539,
		0.594252,
		-0.510445,
		0,
		-0.426887,
		0.803271,
		0.41536,
		0,
		0.354428,
		0.059181,
		-0.554194,
		1
	},
	[0.783333333333] = {
		0.69559,
		-0.025614,
		0.717982,
		0,
		0.599498,
		0.571435,
		-0.560415,
		0,
		-0.395926,
		0.820248,
		0.41284,
		0,
		0.36189,
		0.062025,
		-0.546302,
		1
	},
	[0.7] = {
		0.835757,
		0.114924,
		0.536938,
		0,
		0.396691,
		0.549752,
		-0.735125,
		0,
		-0.379666,
		0.827385,
		0.41387,
		0,
		0.300606,
		0.070672,
		-0.563403,
		1
	},
	[0.816666666667] = {
		0.77981,
		-0.00074,
		0.626016,
		0,
		0.533239,
		0.524655,
		-0.663621,
		0,
		-0.327951,
		0.851314,
		0.409526,
		0,
		0.375588,
		0.068123,
		-0.527553,
		1
	},
	[0.833333333333] = {
		0.818831,
		0.007678,
		0.573984,
		0,
		0.493419,
		0.501572,
		-0.710608,
		0,
		-0.293351,
		0.865082,
		0.406914,
		0,
		0.381757,
		0.0713,
		-0.51805,
		1
	},
	[0.85] = {
		0.852584,
		0.012679,
		0.522437,
		0,
		0.453269,
		0.47961,
		-0.751346,
		0,
		-0.260093,
		0.87739,
		0.403161,
		0,
		0.387459,
		0.074504,
		-0.509409,
		1
	},
	[0.866666666667] = {
		0.87968,
		0.014061,
		0.475357,
		0,
		0.416532,
		0.459562,
		-0.784413,
		0,
		-0.229486,
		0.888034,
		0.398411,
		0,
		0.39269,
		0.077686,
		-0.502378,
		1
	},
	[0.883333333333] = {
		0.899446,
		0.011838,
		0.436872,
		0,
		0.387154,
		0.442178,
		-0.809067,
		0,
		-0.202753,
		0.896849,
		0.393132,
		0,
		0.397444,
		0.080786,
		-0.497726,
		1
	},
	[0.8] = {
		0.73774,
		-0.012095,
		0.674976,
		0,
		0.569461,
		0.54813,
		-0.612591,
		0,
		-0.362565,
		0.836306,
		0.411266,
		0,
		0.368958,
		0.065018,
		-0.537199,
		1
	},
	[0.916666666667] = {
		0.918738,
		-0.002098,
		0.394862,
		0,
		0.359715,
		0.4169,
		-0.834745,
		0,
		-0.162867,
		0.90895,
		0.383777,
		0,
		0.405878,
		0.086676,
		-0.497275,
		1
	},
	[0.933333333333] = {
		0.923778,
		-0.01185,
		0.382744,
		0,
		0.353951,
		0.407839,
		-0.841657,
		0,
		-0.146125,
		0.912977,
		0.380947,
		0,
		0.410331,
		0.08978,
		-0.499629,
		1
	},
	[0.95] = {
		0.926988,
		-0.022922,
		0.37439,
		0,
		0.351607,
		0.400729,
		-0.846043,
		0,
		-0.130636,
		0.91591,
		0.37953,
		0,
		0.415033,
		0.093012,
		-0.503162,
		1
	},
	[0.966666666667] = {
		0.928565,
		-0.035157,
		0.369502,
		0,
		0.352487,
		0.395384,
		-0.848189,
		0,
		-0.116275,
		0.917843,
		0.379532,
		0,
		0.419946,
		0.09634,
		-0.507739,
		1
	},
	[0.983333333333] = {
		0.928659,
		-0.048431,
		0.367758,
		0,
		0.356366,
		0.391607,
		-0.84832,
		0,
		-0.102932,
		0.918857,
		0.380929,
		0,
		0.425033,
		0.099733,
		-0.513219,
		1
	},
	[0.9] = {
		0.911608,
		0.006136,
		0.411016,
		0,
		0.369062,
		0.428081,
		-0.824948,
		0,
		-0.18101,
		0.90372,
		0.387977,
		0,
		0.401709,
		0.083735,
		-0.496232,
		1
	},
	[1.01666666667] = {
		0.924824,
		-0.077606,
		0.372393,
		0,
		0.372116,
		0.387693,
		-0.843341,
		0,
		-0.078926,
		0.918516,
		0.387427,
		0,
		0.435566,
		0.106434,
		-0.526362,
		1
	},
	[1.03333333333] = {
		0.921048,
		-0.093318,
		0.378104,
		0,
		0.383449,
		0.38707,
		-0.838537,
		0,
		-0.068102,
		0.917316,
		0.392293,
		0,
		0.440932,
		0.10963,
		-0.533753,
		1
	},
	[1.05] = {
		0.916712,
		-0.108296,
		0.384592,
		0,
		0.395219,
		0.387099,
		-0.83304,
		0,
		-0.05866,
		0.915656,
		0.397659,
		0,
		0.446236,
		0.112694,
		-0.541317,
		1
	},
	[1.06666666667] = {
		0.912462,
		-0.121369,
		0.390746,
		0,
		0.405962,
		0.387733,
		-0.827562,
		0,
		-0.051065,
		0.913747,
		0.403063,
		0,
		0.451369,
		0.115603,
		-0.548773,
		1
	},
	[1.08333333333] = {
		0.908319,
		-0.132886,
		0.396608,
		0,
		0.41585,
		0.388932,
		-0.822071,
		0,
		-0.045012,
		0.911632,
		0.408535,
		0,
		0.456297,
		0.118317,
		-0.556046,
		1
	},
	[1.11666666667] = {
		0.900308,
		-0.152622,
		0.407619,
		0,
		0.433736,
		0.392756,
		-0.810936,
		0,
		-0.036328,
		0.90689,
		0.419798,
		0,
		0.465402,
		0.122999,
		-0.569752,
		1
	},
	[1.13333333333] = {
		0.896373,
		-0.161501,
		0.412835,
		0,
		0.442063,
		0.395202,
		-0.80523,
		0,
		-0.033108,
		0.904286,
		0.425642,
		0,
		0.469521,
		0.124891,
		-0.576041,
		1
	},
	[1.15] = {
		0.892417,
		-0.170147,
		0.417901,
		0,
		0.450196,
		0.397858,
		-0.799395,
		0,
		-0.03025,
		0.901532,
		0.431655,
		0,
		0.473323,
		0.126436,
		-0.581856,
		1
	},
	[1.16666666667] = {
		0.888375,
		-0.178869,
		0.422841,
		0,
		0.458295,
		0.400591,
		-0.793406,
		0,
		-0.027471,
		0.898628,
		0.43785,
		0,
		0.476783,
		0.12773,
		-0.587121,
		1
	},
	[1.18333333333] = {
		0.884171,
		-0.187968,
		0.427679,
		0,
		0.466521,
		0.403253,
		-0.787239,
		0,
		-0.024488,
		0.895575,
		0.444236,
		0,
		0.479884,
		0.128877,
		-0.591756,
		1
	},
	[1.1] = {
		0.904276,
		-0.143192,
		0.402221,
		0,
		0.425052,
		0.390633,
		-0.816539,
		0,
		-0.040198,
		0.909342,
		0.414104,
		0,
		0.460985,
		0.120795,
		-0.563063,
		1
	},
	[1.21666666667] = {
		0.874915,
		-0.208474,
		0.437106,
		0,
		0.483985,
		0.407695,
		-0.774302,
		0,
		-0.016784,
		0.889001,
		0.457597,
		0,
		0.484997,
		0.130641,
		-0.598828,
		1
	},
	[1.23333333333] = {
		0.869651,
		-0.22046,
		0.441707,
		0,
		0.493534,
		0.4091,
		-0.767504,
		0,
		-0.011499,
		0.885458,
		0.464578,
		0,
		0.487015,
		0.131216,
		-0.601111,
		1
	},
	[1.25] = {
		0.863791,
		-0.233981,
		0.446226,
		0,
		0.503826,
		0.409683,
		-0.760473,
		0,
		-0.004875,
		0.88171,
		0.471766,
		0,
		0.488681,
		0.131557,
		-0.602456,
		1
	},
	[1.26666666667] = {
		0.858023,
		-0.247996,
		0.449772,
		0,
		0.513603,
		0.409413,
		-0.754051,
		0,
		0.002859,
		0.877997,
		0.478657,
		0,
		0.489902,
		0.131671,
		-0.602604,
		1
	},
	[1.2] = {
		0.879718,
		-0.197739,
		0.43243,
		0,
		0.475032,
		0.405682,
		-0.780876,
		0,
		-0.021019,
		0.892369,
		0.450818,
		0,
		0.482621,
		0.129855,
		-0.595684,
		1
	}
}

return spline_matrices
