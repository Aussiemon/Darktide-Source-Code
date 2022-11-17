local spline_matrices = {
	[0] = {
		1,
		4.6e-05,
		0,
		0,
		-4.6e-05,
		0.999999,
		0.001331,
		0,
		-0,
		-0.001331,
		0.999999,
		0,
		-0.000157,
		0.154791,
		-0.120165,
		1
	},
	{
		0.999987,
		0.002581,
		-0.004389,
		0,
		-0.002551,
		0.999973,
		0.006831,
		0,
		0.004406,
		-0.00682,
		0.999967,
		0,
		-0.000209,
		0.15101,
		-0.120423,
		1
	},
	[0.0166666666667] = {
		0.999999,
		-7e-06,
		0.001676,
		0,
		1e-06,
		0.999992,
		0.003916,
		0,
		-0.001676,
		-0.003916,
		0.999991,
		0,
		0.000549,
		0.153615,
		-0.124205,
		1
	},
	[0.0333333333333] = {
		0.999983,
		-0.000123,
		0.005867,
		0,
		6.3e-05,
		0.999946,
		0.010378,
		0,
		-0.005868,
		-0.010377,
		0.999929,
		0,
		0.00232,
		0.150642,
		-0.134134,
		1
	},
	[0.05] = {
		0.999936,
		-0.000239,
		0.011315,
		0,
		2.6e-05,
		0.999824,
		0.018779,
		0,
		-0.011318,
		-0.018777,
		0.99976,
		0,
		0.004632,
		0.146699,
		-0.14668,
		1
	},
	[0.0666666666667] = {
		0.999859,
		-0.000314,
		0.016765,
		0,
		-0.000142,
		0.999631,
		0.027178,
		0,
		-0.016767,
		-0.027176,
		0.99949,
		0,
		0.006949,
		0.142666,
		-0.158815,
		1
	},
	[0.0833333333333] = {
		0.99978,
		-0.000344,
		0.020956,
		0,
		-0.000361,
		0.999434,
		0.033636,
		0,
		-0.020956,
		-0.033636,
		0.999214,
		0,
		0.008731,
		0.139497,
		-0.16787,
		1
	},
	[0.116666666667] = {
		0.999781,
		9.7e-05,
		0.020928,
		0,
		-0.000862,
		0.999332,
		0.036544,
		0,
		-0.02091,
		-0.036554,
		0.999113,
		0,
		0.009017,
		0.207919,
		-0.163281,
		1
	},
	[0.133333333333] = {
		0.999852,
		0.000976,
		0.017185,
		0,
		-0.001621,
		0.999293,
		0.037553,
		0,
		-0.017136,
		-0.037576,
		0.999147,
		0,
		0.00845,
		0.361115,
		-0.144261,
		1
	},
	[0.15] = {
		0.999908,
		0.001573,
		0.013455,
		0,
		-0.0021,
		0.999226,
		0.039281,
		0,
		-0.013383,
		-0.039306,
		0.999138,
		0,
		0.008531,
		0.514023,
		-0.123461,
		1
	},
	[0.166666666667] = {
		0.99993,
		0.0011,
		0.011764,
		0,
		-0.00159,
		0.999128,
		0.041728,
		0,
		-0.011708,
		-0.041744,
		0.99906,
		0,
		0.009183,
		0.583221,
		-0.112927,
		1
	},
	[0.183333333333] = {
		0.999926,
		0.000177,
		0.012178,
		0,
		-0.000699,
		0.999081,
		0.042851,
		0,
		-0.012159,
		-0.042857,
		0.999007,
		0,
		0.009626,
		0.582632,
		-0.112526,
		1
	},
	[0.1] = {
		0.999744,
		-0.00035,
		0.022633,
		0,
		-0.00047,
		0.999344,
		0.036219,
		0,
		-0.022631,
		-0.03622,
		0.999088,
		0,
		0.009443,
		0.138214,
		-0.171424,
		1
	},
	[0.216666666667] = {
		0.999883,
		-0.001069,
		0.015231,
		0,
		0.000436,
		0.999138,
		0.041513,
		0,
		-0.015262,
		-0.041502,
		0.999022,
		0,
		0.009858,
		0.580398,
		-0.112626,
		1
	},
	[0.233333333333] = {
		0.999842,
		-0.001847,
		0.01768,
		0,
		0.001119,
		0.999156,
		0.04107,
		0,
		-0.017741,
		-0.041044,
		0.999,
		0,
		0.009963,
		0.578653,
		-0.112807,
		1
	},
	[0.25] = {
		0.999784,
		-0.002617,
		0.020618,
		0,
		0.001777,
		0.999173,
		0.040632,
		0,
		-0.020707,
		-0.040586,
		0.998961,
		0,
		0.010042,
		0.576254,
		-0.113065,
		1
	},
	[0.266666666667] = {
		0.999708,
		-0.003295,
		0.023951,
		0,
		0.002333,
		0.999193,
		0.040088,
		0,
		-0.024064,
		-0.04002,
		0.998909,
		0,
		0.010079,
		0.573024,
		-0.113387,
		1
	},
	[0.283333333333] = {
		0.999612,
		-0.003799,
		0.027585,
		0,
		0.002713,
		0.999223,
		0.039325,
		0,
		-0.027713,
		-0.039235,
		0.998846,
		0,
		0.010062,
		0.568789,
		-0.113765,
		1
	},
	[0.2] = {
		0.999911,
		-0.000367,
		0.013366,
		0,
		-0.000196,
		0.999115,
		0.04207,
		0,
		-0.01337,
		-0.042069,
		0.999025,
		0,
		0.009741,
		0.581666,
		-0.112529,
		1
	},
	[0.316666666667] = {
		0.999366,
		-0.003951,
		0.035376,
		0,
		0.002652,
		0.999323,
		0.036687,
		0,
		-0.035497,
		-0.03657,
		0.9987,
		0,
		0.009814,
		0.556593,
		-0.114638,
		1
	},
	[0.333333333333] = {
		0.99922,
		-0.003434,
		0.039343,
		0,
		0.002073,
		0.9994,
		0.034578,
		0,
		-0.039439,
		-0.034469,
		0.998627,
		0,
		0.009557,
		0.54828,
		-0.11511,
		1
	},
	[0.35] = {
		0.999033,
		-0.002598,
		0.043887,
		0,
		0.001275,
		0.999545,
		0.030138,
		0,
		-0.043945,
		-0.030053,
		0.998582,
		0,
		0.009171,
		0.538133,
		-0.116071,
		1
	},
	[0.366666666667] = {
		0.998776,
		-0.001625,
		0.049427,
		0,
		0.000527,
		0.999753,
		0.022234,
		0,
		-0.049451,
		-0.022181,
		0.99853,
		0,
		0.00865,
		0.526139,
		-0.117864,
		1
	},
	[0.383333333333] = {
		0.998449,
		-0.000552,
		0.055663,
		0,
		-0.0001,
		0.999932,
		0.011694,
		0,
		-0.055666,
		-0.011681,
		0.998381,
		0,
		0.008024,
		0.512547,
		-0.120278,
		1
	},
	[0.3] = {
		0.999498,
		-0.004045,
		0.031425,
		0,
		0.002843,
		0.999265,
		0.038231,
		0,
		-0.031556,
		-0.038122,
		0.998775,
		0,
		0.009978,
		0.56337,
		-0.114186,
		1
	},
	[0.416666666667] = {
		0.997614,
		0.001752,
		0.069009,
		0,
		-0.000789,
		0.999902,
		-0.013982,
		0,
		-0.069027,
		0.013894,
		0.997518,
		0,
		0.006585,
		0.481573,
		-0.126139,
		1
	},
	[0.433333333333] = {
		0.99714,
		0.002906,
		0.075516,
		0,
		-0.000834,
		0.999623,
		-0.027456,
		0,
		-0.075568,
		0.027314,
		0.996766,
		0,
		0.005832,
		0.464691,
		-0.129184,
		1
	},
	[0.45] = {
		0.996664,
		0.004008,
		0.081511,
		0,
		-0.000727,
		0.999189,
		-0.040248,
		0,
		-0.081607,
		0.040055,
		0.995859,
		0,
		0.005099,
		0.44721,
		-0.132052,
		1
	},
	[0.466666666667] = {
		0.996222,
		0.00502,
		0.086695,
		0,
		-0.000547,
		0.998671,
		-0.051535,
		0,
		-0.086839,
		0.051292,
		0.994901,
		0,
		0.004418,
		0.429375,
		-0.134529,
		1
	},
	[0.483333333333] = {
		0.995855,
		0.0059,
		0.090767,
		0,
		-0.0004,
		0.998168,
		-0.060495,
		0,
		-0.090958,
		0.060208,
		0.994033,
		0,
		0.003821,
		0.411862,
		-0.136419,
		1
	},
	[0.4] = {
		0.998058,
		0.000587,
		0.062291,
		0,
		-0.000547,
		1,
		-0.000655,
		0,
		-0.062291,
		0.00062,
		0.998058,
		0,
		0.007326,
		0.497608,
		-0.123105,
		1
	},
	[0.516666666667] = {
		0.995511,
		0.007104,
		0.094382,
		0,
		-0.000656,
		0.997673,
		-0.068172,
		0,
		-0.094647,
		0.067804,
		0.993199,
		0,
		0.003003,
		0.379799,
		-0.137823,
		1
	},
	[0.533333333333] = {
		0.995635,
		0.007402,
		0.093034,
		0,
		-0.001175,
		0.997765,
		-0.066809,
		0,
		-0.093321,
		0.066408,
		0.993419,
		0,
		0.002765,
		0.363954,
		-0.137476,
		1
	},
	[0.55] = {
		0.995981,
		0.007605,
		0.089242,
		0,
		-0.001911,
		0.997966,
		-0.063723,
		0,
		-0.089545,
		0.063296,
		0.993969,
		0,
		0.002532,
		0.346461,
		-0.136949,
		1
	},
	[0.566666666667] = {
		0.996488,
		0.007779,
		0.083379,
		0,
		-0.002838,
		0.998241,
		-0.059217,
		0,
		-0.083693,
		0.058772,
		0.994757,
		0,
		0.002282,
		0.327713,
		-0.136291,
		1
	},
	[0.583333333333] = {
		0.99709,
		0.007925,
		0.075819,
		0,
		-0.003865,
		0.998558,
		-0.053537,
		0,
		-0.076134,
		0.053088,
		0.995683,
		0,
		0.00202,
		0.308111,
		-0.135528,
		1
	},
	[0.5] = {
		0.995604,
		0.006608,
		0.093429,
		0,
		-0.0004,
		0.997799,
		-0.066313,
		0,
		-0.093662,
		0.065984,
		0.993415,
		0,
		0.003338,
		0.395286,
		-0.137567,
		1
	},
	[0.616666666667] = {
		0.998335,
		0.008131,
		0.057106,
		0,
		-0.00587,
		0.999196,
		-0.039659,
		0,
		-0.057383,
		0.039257,
		0.99758,
		0,
		0.00146,
		0.267945,
		-0.133785,
		1
	},
	[0.633333333333] = {
		0.998875,
		0.008194,
		0.046705,
		0,
		-0.006704,
		0.999466,
		-0.031969,
		0,
		-0.046942,
		0.03162,
		0.998397,
		0,
		0.001168,
		0.248184,
		-0.13285,
		1
	},
	[0.65] = {
		0.999314,
		0.00823,
		0.03611,
		0,
		-0.007361,
		0.999682,
		-0.024123,
		0,
		-0.036297,
		0.023841,
		0.999057,
		0,
		0.000873,
		0.229169,
		-0.131898,
		1
	},
	[0.666666666667] = {
		0.999636,
		0.008239,
		0.0257,
		0,
		-0.00782,
		0.999835,
		-0.016383,
		0,
		-0.02583,
		0.016176,
		0.999535,
		0,
		0.000582,
		0.211302,
		-0.130945,
		1
	},
	[0.683333333333] = {
		0.999841,
		0.008223,
		0.015853,
		0,
		-0.008081,
		0.999927,
		-0.009011,
		0,
		-0.015926,
		0.008882,
		0.999834,
		0,
		0.000303,
		0.19498,
		-0.130005,
		1
	},
	[0.6] = {
		0.997725,
		0.008042,
		0.066937,
		0,
		-0.004903,
		0.998886,
		-0.046933,
		0,
		-0.067239,
		0.046498,
		0.996653,
		0,
		0.001745,
		0.288054,
		-0.134685,
		1
	},
	[0.716666666667] = {
		0.999967,
		0.008115,
		-0.000634,
		0,
		-0.008113,
		0.999961,
		0.003574,
		0,
		0.000663,
		-0.003569,
		0.999993,
		0,
		-0.000172,
		0.168562,
		-0.12821,
		1
	},
	[0.733333333333] = {
		0.999947,
		0.008024,
		-0.006517,
		0,
		-0.00797,
		0.999934,
		0.008265,
		0,
		0.006583,
		-0.008212,
		0.999945,
		0,
		-0.000341,
		0.159261,
		-0.127372,
		1
	},
	[0.75] = {
		0.999915,
		0.007909,
		-0.010324,
		0,
		-0.007789,
		0.999903,
		0.01154,
		0,
		0.010414,
		-0.011458,
		0.99988,
		0,
		-0.000443,
		0.153093,
		-0.126583,
		1
	},
	[0.766666666667] = {
		0.999902,
		0.007768,
		-0.011676,
		0,
		-0.007614,
		0.999885,
		0.013141,
		0,
		0.011777,
		-0.013051,
		0.999845,
		0,
		-0.000463,
		0.150456,
		-0.125846,
		1
	},
	[0.783333333333] = {
		0.999904,
		0.007588,
		-0.011616,
		0,
		-0.007429,
		0.999878,
		0.01371,
		0,
		0.011719,
		-0.013623,
		0.999839,
		0,
		-0.000436,
		0.149432,
		-0.125154,
		1
	},
	[0.7] = {
		0.999942,
		0.008182,
		0.006949,
		0,
		-0.008166,
		0.999964,
		-0.002272,
		0,
		-0.006967,
		0.002215,
		0.999973,
		0,
		4.7e-05,
		0.180601,
		-0.12909,
		1
	},
	[0.816666666667] = {
		0.999912,
		0.007085,
		-0.011172,
		0,
		-0.006926,
		0.999875,
		0.014215,
		0,
		0.011271,
		-0.014137,
		0.999837,
		0,
		-0.000384,
		0.147339,
		-0.123921,
		1
	},
	[0.833333333333] = {
		0.999919,
		0.006771,
		-0.010808,
		0,
		-0.006618,
		0.999878,
		0.014161,
		0,
		0.010903,
		-0.014088,
		0.999841,
		0,
		-0.000362,
		0.146728,
		-0.123386,
		1
	},
	[0.85] = {
		0.999926,
		0.006424,
		-0.010363,
		0,
		-0.006279,
		0.999884,
		0.013909,
		0,
		0.010452,
		-0.013843,
		0.99985,
		0,
		-0.000341,
		0.146425,
		-0.1229,
		1
	},
	[0.866666666667] = {
		0.999933,
		0.006046,
		-0.009848,
		0,
		-0.005913,
		0.999892,
		0.013464,
		0,
		0.009928,
		-0.013405,
		0.999861,
		0,
		-0.000322,
		0.146443,
		-0.122456,
		1
	},
	[0.883333333333] = {
		0.999941,
		0.005645,
		-0.009271,
		0,
		-0.005525,
		0.999902,
		0.012832,
		0,
		0.009343,
		-0.01278,
		0.999875,
		0,
		-0.000304,
		0.146794,
		-0.122053,
		1
	},
	[0.8] = {
		0.999907,
		0.007359,
		-0.011445,
		0,
		-0.007198,
		0.999875,
		0.014067,
		0,
		0.011547,
		-0.013983,
		0.999836,
		0,
		-0.000409,
		0.148245,
		-0.124508,
		1
	},
	[0.916666666667] = {
		0.999957,
		0.004789,
		-0.007977,
		0,
		-0.004699,
		0.999926,
		0.011264,
		0,
		0.008031,
		-0.011226,
		0.999905,
		0,
		-0.000272,
		0.147914,
		-0.12138,
		1
	},
	[0.933333333333] = {
		0.999964,
		0.004345,
		-0.007279,
		0,
		-0.004269,
		0.999937,
		0.01041,
		0,
		0.007324,
		-0.010378,
		0.999919,
		0,
		-0.000258,
		0.148517,
		-0.121113,
		1
	},
	[0.95] = {
		0.999971,
		0.003897,
		-0.006562,
		0,
		-0.003834,
		0.999947,
		0.009526,
		0,
		0.006598,
		-0.009501,
		0.999933,
		0,
		-0.000244,
		0.149136,
		-0.120887,
		1
	},
	[0.966666666667] = {
		0.999977,
		0.00345,
		-0.005834,
		0,
		-0.0034,
		0.999957,
		0.008627,
		0,
		0.005863,
		-0.008606,
		0.999946,
		0,
		-0.000231,
		0.149764,
		-0.120699,
		1
	},
	[0.983333333333] = {
		0.999982,
		0.00301,
		-0.005106,
		0,
		-0.002971,
		0.999966,
		0.007724,
		0,
		0.005129,
		-0.007709,
		0.999957,
		0,
		-0.00022,
		0.150392,
		-0.120545,
		1
	},
	[0.9] = {
		0.999949,
		0.005224,
		-0.008644,
		0,
		-0.005119,
		0.999914,
		0.012076,
		0,
		0.008707,
		-0.012031,
		0.99989,
		0,
		-0.000288,
		0.147337,
		-0.121692,
		1
	},
	[1.01666666667] = {
		0.999991,
		0.002169,
		-0.003691,
		0,
		-0.002147,
		0.99998,
		0.005962,
		0,
		0.003704,
		-0.005954,
		0.999975,
		0,
		-0.000199,
		0.151611,
		-0.120328,
		1
	},
	[1.03333333333] = {
		0.999994,
		0.001778,
		-0.003024,
		0,
		-0.001762,
		0.999985,
		0.005129,
		0,
		0.003034,
		-0.005123,
		0.999982,
		0,
		-0.00019,
		0.152186,
		-0.120258,
		1
	},
	[1.05] = {
		0.999996,
		0.001414,
		-0.002398,
		0,
		-0.001403,
		0.99999,
		0.004345,
		0,
		0.002404,
		-0.004341,
		0.999988,
		0,
		-0.000183,
		0.152725,
		-0.120209,
		1
	},
	[1.06666666667] = {
		0.999998,
		0.001082,
		-0.001823,
		0,
		-0.001075,
		0.999993,
		0.003623,
		0,
		0.001826,
		-0.003621,
		0.999992,
		0,
		-0.000176,
		0.153221,
		-0.120177,
		1
	},
	[1.08333333333] = {
		0.999999,
		0.000786,
		-0.001308,
		0,
		-0.000783,
		0.999995,
		0.002977,
		0,
		0.00131,
		-0.002976,
		0.999995,
		0,
		-0.00017,
		0.153664,
		-0.120159,
		1
	},
	[1.11666666667] = {
		1,
		0.000328,
		-0.000501,
		0,
		-0.000327,
		0.999998,
		0.001963,
		0,
		0.000502,
		-0.001963,
		0.999998,
		0,
		-0.000162,
		0.154359,
		-0.120153,
		1
	},
	[1.13333333333] = {
		1,
		0.000175,
		-0.000229,
		0,
		-0.000174,
		0.999999,
		0.001621,
		0,
		0.00023,
		-0.001621,
		0.999999,
		0,
		-0.000159,
		0.154593,
		-0.120158,
		1
	},
	[1.15] = {
		1,
		7.9e-05,
		-5.9e-05,
		0,
		-7.9e-05,
		0.999999,
		0.001406,
		0,
		5.9e-05,
		-0.001406,
		0.999999,
		0,
		-0.000158,
		0.15474,
		-0.120163,
		1
	},
	[1.16666666667] = {
		1,
		4.6e-05,
		0,
		0,
		-4.6e-05,
		0.999999,
		0.001331,
		0,
		-0,
		-0.001331,
		0.999999,
		0,
		-0.000157,
		0.154791,
		-0.120165,
		1
	},
	[1.1] = {
		0.999999,
		0.000533,
		-0.000864,
		0,
		-0.000531,
		0.999997,
		0.002419,
		0,
		0.000865,
		-0.002419,
		0.999997,
		0,
		-0.000165,
		0.154047,
		-0.120152,
		1
	}
}

return spline_matrices
