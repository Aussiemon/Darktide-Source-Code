﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_axe/attack_right.lua

local spline_matrices = {
	[0.00833333333333] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.0166666666667] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.025] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.0333333333333] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.0416666666667] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.0583333333333] = {
		0.462934,
		-0.286226,
		-0.838908,
		0,
		-0.815126,
		-0.509281,
		-0.276049,
		0,
		-0.348227,
		0.811608,
		-0.469074,
		0,
		0.098161,
		-0.123974,
		-0.626669,
		1,
	},
	[0.05] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.0666666666667] = {
		0.455745,
		-0.425906,
		-0.781601,
		0,
		-0.847682,
		-0.475544,
		-0.235145,
		0,
		-0.271536,
		0.769715,
		-0.57776,
		0,
		0.065366,
		-0.113692,
		-0.623093,
		1,
	},
	[0.075] = {
		0.433229,
		-0.56847,
		-0.699396,
		0,
		-0.881441,
		-0.429174,
		-0.197159,
		0,
		-0.188084,
		0.701891,
		-0.687003,
		0,
		0.032022,
		-0.103201,
		-0.620277,
		1,
	},
	[0.0833333333333] = {
		0.391676,
		-0.706822,
		-0.589061,
		0,
		-0.914532,
		-0.369407,
		-0.16483,
		0,
		-0.101097,
		0.603275,
		-0.7911,
		0,
		-0.001489,
		-0.092894,
		-0.618076,
		1,
	},
	[0.0916666666667] = {
		0.328465,
		-0.83053,
		-0.449811,
		0,
		-0.944382,
		-0.296819,
		-0.141569,
		0,
		-0.015935,
		0.471294,
		-0.881832,
		0,
		-0.034846,
		-0.083182,
		-0.616253,
		1,
	},
	[0] = {
		0.458498,
		-0.153234,
		-0.875385,
		0,
		-0.784929,
		-0.53173,
		-0.318042,
		0,
		-0.416733,
		0.832936,
		-0.364075,
		0,
		0.129991,
		-0.133705,
		-0.631084,
		1,
	},
	[0.108333333333] = {
		0.140584,
		-0.984634,
		-0.103597,
		0,
		-0.982815,
		-0.126145,
		-0.134768,
		0,
		0.119629,
		0.120763,
		-0.985447,
		0,
		-0.100226,
		-0.066904,
		-0.612269,
		1,
	},
	[0.116666666667] = {
		0.027362,
		-0.996289,
		0.081608,
		0,
		-0.987338,
		-0.039697,
		-0.153584,
		0,
		0.156254,
		-0.076372,
		-0.98476,
		0,
		-0.131987,
		-0.060646,
		-0.609234,
		1,
	},
	[0.125] = {
		-0.085962,
		-0.962816,
		0.256117,
		0,
		-0.982067,
		0.038592,
		-0.184538,
		0,
		0.167792,
		-0.267387,
		-0.948868,
		0,
		-0.162962,
		-0.055531,
		-0.604998,
		1,
	},
	[0.133333333333] = {
		-0.189435,
		-0.893041,
		0.408156,
		0,
		-0.969336,
		0.103821,
		-0.222733,
		0,
		0.156535,
		-0.437834,
		-0.885324,
		0,
		-0.192939,
		-0.051316,
		-0.599361,
		1,
	},
	[0.141666666667] = {
		-0.275785,
		-0.801009,
		0.531346,
		0,
		-0.952605,
		0.153916,
		-0.262402,
		0,
		0.128403,
		-0.578529,
		-0.805492,
		0,
		-0.221588,
		-0.047762,
		-0.592288,
		1,
	},
	[0.158333333333] = {
		-0.386012,
		-0.609127,
		0.692791,
		0,
		-0.921066,
		0.212721,
		-0.326171,
		0,
		0.051309,
		-0.764012,
		-0.643159,
		0,
		-0.27315,
		-0.04222,
		-0.574202,
		1,
	},
	[0.15] = {
		-0.341439,
		-0.701943,
		0.625056,
		0,
		-0.935496,
		0.189467,
		-0.298246,
		0,
		0.090924,
		-0.68657,
		-0.721356,
		0,
		-0.248484,
		-0.04473,
		-0.583861,
		1,
	},
	[0.166666666667] = {
		-0.410957,
		-0.532621,
		0.739885,
		0,
		-0.911525,
		0.226389,
		-0.343321,
		0,
		0.015358,
		-0.815514,
		-0.578533,
		0,
		-0.295097,
		-0.040356,
		-0.563413,
		1,
	},
	[0.175] = {
		-0.419704,
		-0.477708,
		0.771779,
		0,
		-0.907653,
		0.224449,
		-0.354667,
		0,
		-0.003797,
		-0.849363,
		-0.527795,
		0,
		-0.31452,
		-0.03979,
		-0.551983,
		1,
	},
	[0.183333333333] = {
		-0.418302,
		-0.431519,
		0.799259,
		0,
		-0.908118,
		0.216671,
		-0.358295,
		0,
		-0.018565,
		-0.875697,
		-0.482504,
		0,
		-0.332855,
		-0.040244,
		-0.539718,
		1,
	},
	[0.191666666667] = {
		-0.408475,
		-0.393222,
		0.823726,
		0,
		-0.912312,
		0.204446,
		-0.354808,
		0,
		-0.028889,
		-0.896425,
		-0.442252,
		0,
		-0.35009,
		-0.041646,
		-0.526683,
		1,
	},
	[0.1] = {
		0.243523,
		-0.927048,
		-0.285093,
		0,
		-0.968024,
		-0.214067,
		-0.130782,
		0,
		0.060212,
		0.307825,
		-0.949536,
		0,
		-0.06781,
		-0.074436,
		-0.614461,
		1,
	},
	[0.208333333333] = {
		-0.368016,
		-0.336684,
		0.866722,
		0,
		-0.929088,
		0.170121,
		-0.328412,
		0,
		-0.036877,
		-0.926122,
		-0.375417,
		0,
		-0.381243,
		-0.04705,
		-0.498529,
		1,
	},
	[0.216666666667] = {
		-0.338819,
		-0.316667,
		0.885959,
		0,
		-0.940196,
		0.149109,
		-0.306265,
		0,
		-0.03512,
		-0.936744,
		-0.34825,
		0,
		-0.395166,
		-0.05095,
		-0.483502,
		1,
	},
	[0.225] = {
		-0.304272,
		-0.301104,
		0.903745,
		0,
		-0.952112,
		0.126036,
		-0.278564,
		0,
		-0.030028,
		-0.945225,
		-0.325034,
		0,
		-0.407993,
		-0.055552,
		-0.467901,
		1,
	},
	[0.233333333333] = {
		-0.264722,
		-0.289295,
		0.919908,
		0,
		-0.964073,
		0.101209,
		-0.245603,
		0,
		-0.022051,
		-0.951875,
		-0.305693,
		0,
		-0.419733,
		-0.060769,
		-0.451771,
		1,
	},
	[0.241666666667] = {
		-0.220475,
		-0.280568,
		0.934169,
		0,
		-0.975321,
		0.075011,
		-0.207659,
		0,
		-0.011811,
		-0.956899,
		-0.290182,
		0,
		-0.430421,
		-0.066472,
		-0.43514,
		1,
	},
	[0.258333333333] = {
		-0.11936,
		-0.270041,
		0.955422,
		0,
		-0.992769,
		0.020121,
		-0.118338,
		0,
		0.012732,
		-0.962639,
		-0.27049,
		0,
		-0.448744,
		-0.078824,
		-0.40055,
		1,
	},
	[0.25] = {
		-0.171877,
		-0.274323,
		0.946153,
		0,
		-0.985118,
		0.047858,
		-0.165079,
		0,
		4e-06,
		-0.960446,
		-0.278466,
		0,
		-0.440089,
		-0.072525,
		-0.418046,
		1,
	},
	[0.266666666667] = {
		-0.063466,
		-0.267267,
		0.96153,
		0,
		-0.997655,
		-0.007761,
		-0.068008,
		0,
		0.025639,
		-0.963591,
		-0.266148,
		0,
		-0.456402,
		-0.085261,
		-0.382719,
		1,
	},
	[0.275] = {
		-0.004864,
		-0.265623,
		0.964065,
		0,
		-0.999269,
		-0.035277,
		-0.014762,
		0,
		0.037931,
		-0.963431,
		-0.265257,
		0,
		-0.46309,
		-0.091724,
		-0.364627,
		1,
	},
	[0.283333333333] = {
		0.055638,
		-0.264818,
		0.962692,
		0,
		-0.997259,
		-0.061839,
		0.040625,
		0,
		0.048773,
		-0.962314,
		-0.267533,
		0,
		-0.468841,
		-0.0981,
		-0.34635,
		1,
	},
	[0.291666666667] = {
		0.117103,
		-0.264671,
		0.957202,
		0,
		-0.991464,
		-0.086786,
		0.097298,
		0,
		0.05732,
		-0.960426,
		-0.272575,
		0,
		-0.473703,
		-0.104269,
		-0.327966,
		1,
	},
	[0.2] = {
		-0.391432,
		-0.361916,
		0.846048,
		0,
		-0.919544,
		0.188718,
		-0.344708,
		0,
		-0.034909,
		-0.912909,
		-0.406668,
		0,
		-0.366219,
		-0.04393,
		-0.512938,
		1,
	},
	[0.308333333333] = {
		0.238646,
		-0.266254,
		0.933893,
		0,
		-0.968978,
		-0.128926,
		0.210855,
		0,
		0.064262,
		-0.955242,
		-0.288762,
		0,
		-0.481011,
		-0.115499,
		-0.291194,
		1,
	},
	[0.316666666667] = {
		0.296428,
		-0.268273,
		0.916602,
		0,
		-0.953093,
		-0.14458,
		0.265913,
		0,
		0.061185,
		-0.952432,
		-0.298547,
		0,
		-0.483612,
		-0.120311,
		-0.27296,
		1,
	},
	[0.325] = {
		0.350659,
		-0.271523,
		0.896278,
		0,
		-0.935007,
		-0.155581,
		0.318679,
		0,
		0.052915,
		-0.949774,
		-0.308432,
		0,
		-0.485632,
		-0.12442,
		-0.254926,
		1,
	},
	[0.333333333333] = {
		0.400206,
		-0.276452,
		0.873733,
		0,
		-0.915596,
		-0.161161,
		0.36839,
		0,
		0.038969,
		-0.947418,
		-0.317616,
		0,
		-0.487167,
		-0.127694,
		-0.23716,
		1,
	},
	[0.341666666667] = {
		0.446324,
		-0.282366,
		0.849155,
		0,
		-0.894585,
		-0.164786,
		0.415407,
		0,
		0.022632,
		-0.945047,
		-0.326149,
		0,
		-0.488099,
		-0.130267,
		-0.219683,
		1,
	},
	[0.358333333333] = {
		0.505066,
		-0.313145,
		0.804269,
		0,
		-0.862633,
		-0.153121,
		0.482099,
		0,
		-0.027816,
		-0.93728,
		-0.347465,
		0,
		-0.488073,
		-0.136307,
		-0.185936,
		1,
	},
	[0.35] = {
		0.480723,
		-0.292126,
		0.826782,
		0,
		-0.876865,
		-0.163983,
		0.451903,
		0,
		0.003566,
		-0.942216,
		-0.334986,
		0,
		-0.488708,
		-0.131849,
		-0.203095,
		1,
	},
	[0.366666666667] = {
		0.518687,
		-0.346135,
		0.781763,
		0,
		-0.851768,
		-0.13022,
		0.507478,
		0,
		-0.073855,
		-0.929104,
		-0.36237,
		0,
		-0.486148,
		-0.14508,
		-0.166736,
		1,
	},
	[0.375] = {
		0.522842,
		-0.386326,
		0.759861,
		0,
		-0.843425,
		-0.105226,
		0.526842,
		0,
		-0.123576,
		-0.91634,
		-0.380853,
		0,
		-0.483549,
		-0.143727,
		-0.144668,
		1,
	},
	[0.383333333333] = {
		0.520511,
		-0.426779,
		0.739546,
		0,
		-0.837456,
		-0.086235,
		0.539657,
		0,
		-0.16654,
		-0.900235,
		-0.402295,
		0,
		-0.480581,
		-0.12085,
		-0.11937,
		1,
	},
	[0.391666666667] = {
		0.513559,
		-0.460779,
		0.723837,
		0,
		-0.834359,
		-0.071291,
		0.546592,
		0,
		-0.200255,
		-0.884647,
		-0.421067,
		0,
		-0.478875,
		-0.080276,
		-0.080192,
		1,
	},
	[0.3] = {
		0.178482,
		-0.265125,
		0.947551,
		0,
		-0.981941,
		-0.109401,
		0.154349,
		0,
		0.062742,
		-0.957988,
		-0.279863,
		0,
		-0.477736,
		-0.110109,
		-0.309554,
		1,
	},
	[0.408333333333] = {
		0.489244,
		-0.488074,
		0.722789,
		0,
		-0.839988,
		-0.040722,
		0.541075,
		0,
		-0.234652,
		-0.871852,
		-0.429899,
		0,
		-0.469157,
		0.039949,
		-0.029757,
		1,
	},
	[0.416666666667] = {
		0.475424,
		-0.476015,
		0.739853,
		0,
		-0.845928,
		-0.016386,
		0.533045,
		0,
		-0.241614,
		-0.879285,
		-0.410465,
		0,
		-0.458119,
		0.105956,
		-0.016723,
		1,
	},
	[0.425] = {
		0.458218,
		-0.456689,
		0.762543,
		0,
		-0.848946,
		0.029273,
		0.527669,
		0,
		-0.263302,
		-0.889145,
		-0.37429,
		0,
		-0.444931,
		0.170282,
		-0.006319,
		1,
	},
	[0.433333333333] = {
		0.434286,
		-0.438797,
		0.786672,
		0,
		-0.842942,
		0.109912,
		0.526658,
		0,
		-0.317561,
		-0.891839,
		-0.322147,
		0,
		-0.430891,
		0.230195,
		0.001465,
		1,
	},
	[0.441666666667] = {
		0.394016,
		-0.435351,
		0.809457,
		0,
		-0.809274,
		0.253155,
		0.530083,
		0,
		-0.435691,
		-0.863934,
		-0.252571,
		0,
		-0.422304,
		0.292863,
		0.008308,
		1,
	},
	[0.458333333333] = {
		0.276017,
		-0.324305,
		0.904788,
		0,
		-0.674016,
		0.605791,
		0.422752,
		0,
		-0.685213,
		-0.726528,
		-0.051378,
		0,
		-0.375087,
		0.42731,
		0.000746,
		1,
	},
	[0.45] = {
		0.333916,
		-0.412956,
		0.84733,
		0,
		-0.74523,
		0.434774,
		0.505573,
		0,
		-0.577176,
		-0.800274,
		-0.162569,
		0,
		-0.408391,
		0.361055,
		0.010774,
		1,
	},
	[0.466666666667] = {
		0.233505,
		-0.211473,
		0.949081,
		0,
		-0.569337,
		0.761517,
		0.309755,
		0,
		-0.788246,
		-0.612676,
		0.057418,
		0,
		-0.322545,
		0.492795,
		-0.025043,
		1,
	},
	[0.475] = {
		0.163166,
		-0.108429,
		0.980622,
		0,
		-0.370185,
		0.914595,
		0.162723,
		0,
		-0.914516,
		-0.389563,
		0.109092,
		0,
		-0.232532,
		0.571394,
		-0.060101,
		1,
	},
	[0.483333333333] = {
		0.09572,
		-0.046698,
		0.994312,
		0,
		-0.081106,
		0.995212,
		0.054548,
		0,
		-0.992098,
		-0.085867,
		0.091474,
		0,
		-0.108464,
		0.642392,
		-0.074579,
		1,
	},
	[0.491666666667] = {
		0.070146,
		-0.066069,
		0.995346,
		0,
		0.229061,
		0.972208,
		0.048391,
		0,
		-0.970881,
		0.224601,
		0.08333,
		0,
		0.037129,
		0.679938,
		-0.06287,
		1,
	},
	[0.4] = {
		0.502329,
		-0.484106,
		0.716455,
		0,
		-0.835026,
		-0.056473,
		0.547304,
		0,
		-0.224493,
		-0.873185,
		-0.43261,
		0,
		-0.476297,
		-0.024817,
		-0.04565,
		1,
	},
	[0.508333333333] = {
		0.052179,
		-0.057959,
		0.996954,
		0,
		0.685965,
		0.727606,
		0.006398,
		0,
		-0.725761,
		0.683542,
		0.077723,
		0,
		0.281702,
		0.649418,
		-0.069732,
		1,
	},
	[0.516666666667] = {
		0.057885,
		-0.051446,
		0.996997,
		0,
		0.832193,
		0.554135,
		-0.019722,
		0,
		-0.551456,
		0.830835,
		0.074889,
		0,
		0.377321,
		0.595955,
		-0.07515,
		1,
	},
	[0.525] = {
		0.055276,
		-0.062349,
		0.996523,
		0,
		0.933258,
		0.358005,
		-0.029368,
		0,
		-0.354929,
		0.931636,
		0.077977,
		0,
		0.458446,
		0.535698,
		-0.082662,
		1,
	},
	[0.533333333333] = {
		0.039856,
		-0.08085,
		0.995929,
		0,
		0.988532,
		0.148484,
		-0.027506,
		0,
		-0.145656,
		0.985604,
		0.085841,
		0,
		0.522474,
		0.481462,
		-0.100735,
		1,
	},
	[0.541666666667] = {
		0.036734,
		-0.116657,
		0.992493,
		0,
		0.995501,
		-0.082527,
		-0.046546,
		0,
		0.087338,
		0.989738,
		0.113101,
		0,
		0.571933,
		0.433416,
		-0.130603,
		1,
	},
	[0.558333333333] = {
		0.017157,
		-0.252076,
		0.967555,
		0,
		0.848722,
		-0.507892,
		-0.14737,
		0,
		0.528562,
		0.823713,
		0.205229,
		0,
		0.638052,
		0.346306,
		-0.198745,
		1,
	},
	[0.55] = {
		0.038458,
		-0.184184,
		0.982139,
		0,
		0.943457,
		-0.317163,
		-0.096422,
		0,
		0.329258,
		0.930314,
		0.161572,
		0,
		0.610084,
		0.38649,
		-0.165643,
		1,
	},
	[0.566666666667] = {
		-0.023619,
		-0.267717,
		0.963208,
		0,
		0.757525,
		-0.63352,
		-0.157507,
		0,
		0.652379,
		0.725934,
		0.217765,
		0,
		0.659049,
		0.318003,
		-0.222087,
		1,
	},
	[0.575] = {
		-0.042971,
		-0.237314,
		0.970482,
		0,
		0.694417,
		-0.705471,
		-0.141762,
		0,
		0.718289,
		0.667828,
		0.195109,
		0,
		0.67324,
		0.297869,
		-0.237772,
		1,
	},
	[0.583333333333] = {
		-0.043232,
		-0.209698,
		0.97681,
		0,
		0.637764,
		-0.758383,
		-0.13458,
		0,
		0.769018,
		0.617156,
		0.166524,
		0,
		0.679533,
		0.276852,
		-0.252114,
		1,
	},
	[0.591666666667] = {
		-0.028422,
		-0.18691,
		0.981966,
		0,
		0.588634,
		-0.797101,
		-0.134685,
		0,
		0.8079,
		0.57419,
		0.132677,
		0,
		0.679526,
		0.255144,
		-0.265362,
		1,
	},
	[0.5] = {
		0.05497,
		-0.078061,
		0.995432,
		0,
		0.493994,
		0.868506,
		0.040828,
		0,
		-0.867726,
		0.489494,
		0.086303,
		0,
		0.174337,
		0.682064,
		-0.060635,
		1,
	},
	[0.608333333333] = {
		0.03278,
		-0.156054,
		0.987204,
		0,
		0.511559,
		-0.845928,
		-0.150708,
		0,
		0.858623,
		0.509954,
		0.052101,
		0,
		0.666217,
		0.211477,
		-0.289493,
		1,
	},
	[0.616666666667] = {
		0.073282,
		-0.146039,
		0.986561,
		0,
		0.480722,
		-0.861545,
		-0.163241,
		0,
		0.873806,
		0.486224,
		0.007068,
		0,
		0.655866,
		0.189829,
		-0.30081,
		1,
	},
	[0.625] = {
		0.116995,
		-0.137833,
		0.983521,
		0,
		0.452962,
		-0.873913,
		-0.176354,
		0,
		0.88382,
		0.46613,
		-0.03981,
		0,
		0.644973,
		0.168587,
		-0.311907,
		1,
	},
	[0.633333333333] = {
		0.161638,
		-0.130094,
		0.978238,
		0,
		0.426956,
		-0.884477,
		-0.188172,
		0,
		0.889709,
		0.448081,
		-0.087421,
		0,
		0.634984,
		0.148002,
		-0.322999,
		1,
	},
	[0.641666666667] = {
		0.20511,
		-0.121578,
		0.971158,
		0,
		0.401646,
		-0.8944,
		-0.196797,
		0,
		0.89253,
		0.430427,
		-0.134619,
		0,
		0.627363,
		0.128327,
		-0.334314,
		1,
	},
	[0.658333333333] = {
		0.281114,
		-0.098185,
		0.954638,
		0,
		0.350083,
		-0.915711,
		-0.197271,
		0,
		0.893542,
		0.389658,
		-0.223046,
		0,
		0.625167,
		0.09279,
		-0.358583,
		1,
	},
	[0.65] = {
		0.245499,
		-0.111227,
		0.962995,
		0,
		0.376227,
		-0.904597,
		-0.200394,
		0,
		0.893411,
		0.411501,
		-0.180231,
		0,
		0.62359,
		0.109824,
		-0.346093,
		1,
	},
	[0.666666666667] = {
		0.310517,
		-0.081648,
		0.947055,
		0,
		0.322699,
		-0.928083,
		-0.185818,
		0,
		0.894117,
		0.363313,
		-0.261838,
		0,
		0.633603,
		0.07754,
		-0.372045,
		1,
	},
	[0.675] = {
		0.335668,
		-0.063383,
		0.939846,
		0,
		0.291894,
		-0.941624,
		-0.167753,
		0,
		0.895614,
		0.330645,
		-0.297572,
		0,
		0.644029,
		0.062655,
		-0.385447,
		1,
	},
	[0.683333333333] = {
		0.359644,
		-0.0466,
		0.931925,
		0,
		0.254437,
		-0.956006,
		-0.145995,
		0,
		0.897729,
		0.289623,
		-0.331965,
		0,
		0.650087,
		0.046279,
		-0.397496,
		1,
	},
	[0.691666666667] = {
		0.384666,
		-0.028796,
		0.922606,
		0,
		0.210883,
		-0.970337,
		-0.11821,
		0,
		0.898643,
		0.240034,
		-0.367184,
		0,
		0.651622,
		0.028153,
		-0.408631,
		1,
	},
	[0.6] = {
		-0.002037,
		-0.169269,
		0.985568,
		0,
		0.547005,
		-0.825238,
		-0.140602,
		0,
		0.837127,
		0.538824,
		0.094272,
		0,
		0.674588,
		0.23331,
		-0.277749,
		1,
	},
	[0.708333333333] = {
		0.445135,
		0.015675,
		0.895326,
		0,
		0.114895,
		-0.992582,
		-0.039745,
		0,
		0.888062,
		0.120561,
		-0.443634,
		0,
		0.642282,
		-0.013162,
		-0.429288,
		1,
	},
	[0.716666666667] = {
		0.48104,
		0.039009,
		0.87583,
		0,
		0.06507,
		-0.997843,
		0.008705,
		0,
		0.87428,
		0.052803,
		-0.482541,
		0,
		0.631585,
		-0.036085,
		-0.438568,
		1,
	},
	[0.725] = {
		0.519895,
		0.061474,
		0.852015,
		0,
		0.015813,
		-0.997929,
		0.062354,
		0,
		0.854084,
		-0.018945,
		-0.51979,
		0,
		0.617904,
		-0.05978,
		-0.447068,
		1,
	},
	[0.733333333333] = {
		0.560635,
		0.082335,
		0.823959,
		0,
		-0.03143,
		-0.992212,
		0.120533,
		0,
		0.827466,
		-0.093472,
		-0.553681,
		0,
		0.602379,
		-0.083486,
		-0.454772,
		1,
	},
	[0.741666666667] = {
		0.602624,
		0.10024,
		0.791705,
		0,
		-0.075199,
		-0.980532,
		0.181387,
		0,
		0.794474,
		-0.168843,
		-0.583355,
		0,
		0.585344,
		-0.106999,
		-0.461653,
		1,
	},
	[0.758333333333] = {
		0.686953,
		0.122777,
		0.716255,
		0,
		-0.147933,
		-0.94136,
		0.303245,
		0,
		0.711485,
		-0.314273,
		-0.628507,
		0,
		0.548086,
		-0.152817,
		-0.472959,
		1,
	},
	[0.75] = {
		0.645039,
		0.114023,
		0.755595,
		0,
		-0.114304,
		-0.963283,
		0.242943,
		0,
		0.755553,
		-0.243075,
		-0.608321,
		0,
		0.567136,
		-0.130151,
		-0.467708,
		1,
	},
	[0.766666666667] = {
		0.72743,
		0.125898,
		0.674534,
		0,
		-0.175725,
		-0.916064,
		0.360482,
		0,
		0.6633,
		-0.380758,
		-0.644249,
		0,
		0.52851,
		-0.17491,
		-0.47744,
		1,
	},
	[0.775] = {
		0.765608,
		0.123084,
		0.631422,
		0,
		-0.197775,
		-0.888955,
		0.41309,
		0,
		0.612151,
		-0.441145,
		-0.656249,
		0,
		0.508701,
		-0.196381,
		-0.481185,
		1,
	},
	[0.783333333333] = {
		0.800773,
		0.114308,
		0.58796,
		0,
		-0.214598,
		-0.861703,
		0.4598,
		0,
		0.559205,
		-0.494371,
		-0.665498,
		0,
		0.48893,
		-0.217208,
		-0.484226,
		1,
	},
	[0.791666666667] = {
		0.8324,
		0.099748,
		0.545124,
		0,
		-0.227037,
		-0.835946,
		0.499648,
		0,
		0.505533,
		-0.539671,
		-0.673195,
		0,
		0.469429,
		-0.237384,
		-0.486598,
		1,
	},
	[0.7] = {
		0.413041,
		-0.007511,
		0.910681,
		0,
		0.163954,
		-0.983015,
		-0.082469,
		0,
		0.895833,
		0.183373,
		-0.404794,
		0,
		0.648995,
		0.008296,
		-0.419273,
		1,
	},
	[0.808333333333] = {
		0.883841,
		0.05578,
		0.46445,
		0,
		-0.242255,
		-0.794774,
		0.556459,
		0,
		0.400172,
		-0.604336,
		-0.688941,
		0,
		0.432238,
		-0.275596,
		-0.489596,
		1,
	},
	[0.816666666667] = {
		0.903557,
		0.029786,
		0.427431,
		0,
		-0.245325,
		-0.781913,
		0.573086,
		0,
		0.351284,
		-0.622675,
		-0.699196,
		0,
		0.415289,
		-0.293234,
		-0.490589,
		1,
	},
	[0.825] = {
		0.91959,
		0.002346,
		0.392872,
		0,
		-0.246271,
		-0.775695,
		0.581074,
		0,
		0.306112,
		-0.631103,
		-0.712744,
		0,
		0.399746,
		-0.309802,
		-0.491258,
		1,
	},
	[0.833333333333] = {
		0.93228,
		-0.026048,
		0.360799,
		0,
		-0.245957,
		-0.777018,
		0.579438,
		0,
		0.265254,
		-0.62894,
		-0.730805,
		0,
		0.385782,
		-0.325261,
		-0.491571,
		1,
	},
	[0.841666666667] = {
		0.942567,
		-0.056006,
		0.329288,
		0,
		-0.244987,
		-0.78603,
		0.567572,
		0,
		0.227043,
		-0.615646,
		-0.754607,
		0,
		0.372319,
		-0.339992,
		-0.491244,
		1,
	},
	[0.858333333333] = {
		0.958018,
		-0.121743,
		0.259578,
		0,
		-0.243574,
		-0.823181,
		0.512879,
		0,
		0.15124,
		-0.554574,
		-0.818275,
		0,
		0.343358,
		-0.368279,
		-0.48823,
		1,
	},
	[0.85] = {
		0.951161,
		-0.088101,
		0.295856,
		0,
		-0.243957,
		-0.801787,
		0.545548,
		0,
		0.18915,
		-0.59108,
		-0.784121,
		0,
		0.358167,
		-0.354371,
		-0.49009,
		1,
	},
	[0.866666666667] = {
		0.963022,
		-0.156191,
		0.219527,
		0,
		-0.244537,
		-0.848746,
		0.468862,
		0,
		0.113091,
		-0.505207,
		-0.855556,
		0,
		0.327927,
		-0.381568,
		-0.485785,
		1,
	},
	[0.875] = {
		0.965996,
		-0.190479,
		0.17484,
		0,
		-0.247547,
		-0.876568,
		0.412734,
		0,
		0.074642,
		-0.44198,
		-0.893914,
		0,
		0.311919,
		-0.394059,
		-0.482854,
		1,
	},
	[0.883333333333] = {
		0.966714,
		-0.223357,
		0.1248,
		0,
		-0.253308,
		-0.904204,
		0.343876,
		0,
		0.036037,
		-0.364043,
		-0.930685,
		0,
		0.295385,
		-0.405551,
		-0.4795,
		1,
	},
	[0.891666666667] = {
		0.964934,
		-0.253267,
		0.068974,
		0,
		-0.262481,
		-0.928665,
		0.26208,
		0,
		-0.002323,
		-0.270994,
		-0.962578,
		0,
		0.278393,
		-0.415831,
		-0.475739,
		1,
	},
	[0.8] = {
		0.860154,
		0.079713,
		0.503766,
		0,
		-0.236168,
		-0.813195,
		0.531919,
		0,
		0.452061,
		-0.576506,
		-0.680648,
		0,
		0.450408,
		-0.25691,
		-0.488321,
		1,
	},
	[0.908333333333] = {
		0.953114,
		-0.296719,
		-0.059427,
		0,
		-0.293093,
		-0.954026,
		0.062701,
		0,
		-0.075299,
		-0.042343,
		-0.996262,
		0,
		0.243404,
		-0.431987,
		-0.466717,
		1,
	},
	[0.916666666667] = {
		0.942975,
		-0.306391,
		-0.130087,
		0,
		-0.31493,
		-0.947764,
		-0.05062,
		0,
		-0.107782,
		0.088702,
		-0.99021,
		0,
		0.225655,
		-0.437614,
		-0.461155,
		1,
	},
	[0.925] = {
		0.93026,
		-0.305893,
		-0.202596,
		0,
		-0.340779,
		-0.924982,
		-0.168158,
		0,
		-0.135959,
		0.225472,
		-0.964716,
		0,
		0.207945,
		-0.4416,
		-0.45462,
		1,
	},
	[0.933333333333] = {
		0.915434,
		-0.294436,
		-0.274388,
		0,
		-0.369855,
		-0.884283,
		-0.285045,
		0,
		-0.158709,
		0.362423,
		-0.918401,
		0,
		0.190461,
		-0.444098,
		-0.446914,
		1,
	},
	[0.941666666667] = {
		0.899157,
		-0.272187,
		-0.342682,
		0,
		-0.401004,
		-0.826019,
		-0.396092,
		0,
		-0.175251,
		0.493566,
		-0.851869,
		0,
		0.173392,
		-0.445384,
		-0.43791,
		1,
	},
	[0.958333333333] = {
		0.865377,
		-0.200863,
		-0.459104,
		0,
		-0.46405,
		-0.667025,
		-0.582869,
		0,
		-0.189157,
		0.717448,
		-0.670438,
		0,
		0.141195,
		-0.445809,
		-0.416116,
		1,
	},
	[0.95] = {
		0.88221,
		-0.240323,
		-0.404907,
		0,
		-0.432859,
		-0.752369,
		-0.496562,
		0,
		-0.185305,
		0.61334,
		-0.767774,
		0,
		0.156918,
		-0.445822,
		-0.4276,
		1,
	},
	[0.966666666667] = {
		0.849334,
		-0.156333,
		-0.504175,
		0,
		-0.493399,
		-0.57456,
		-0.653023,
		0,
		-0.187589,
		0.803394,
		-0.565128,
		0,
		0.126345,
		-0.445714,
		-0.403729,
		1,
	},
	[0.975] = {
		0.834569,
		-0.109362,
		-0.539939,
		0,
		-0.520066,
		-0.479707,
		-0.706691,
		0,
		-0.181727,
		0.870587,
		-0.457224,
		0,
		0.112455,
		-0.44583,
		-0.39081,
		1,
	},
	[0.983333333333] = {
		0.821359,
		-0.062337,
		-0.566995,
		0,
		-0.543594,
		-0.386742,
		-0.74494,
		0,
		-0.172843,
		0.920078,
		-0.351541,
		0,
		0.09958,
		-0.446351,
		-0.377789,
		1,
	},
	[0.991666666667] = {
		0.809778,
		-0.017229,
		-0.586483,
		0,
		-0.563874,
		-0.299159,
		-0.769773,
		0,
		-0.162189,
		0.954048,
		-0.251967,
		0,
		0.08776,
		-0.447389,
		-0.365078,
		1,
	},
	[0.9] = {
		0.960443,
		-0.27838,
		0.007364,
		0,
		-0.275625,
		-0.946498,
		0.167848,
		0,
		-0.039755,
		-0.163238,
		-0.985785,
		0,
		0.26103,
		-0.424698,
		-0.471518,
		1,
	},
	[1.00833333333] = {
		0.791066,
		0.061982,
		-0.608583,
		0,
		-0.595533,
		-0.149387,
		-0.789318,
		0,
		-0.139838,
		0.986834,
		-0.081263,
		0,
		0.067391,
		-0.451056,
		-0.342133,
		1,
	},
	[1.01666666667] = {
		0.7835,
		0.094648,
		-0.614141,
		0,
		-0.607684,
		-0.089736,
		-0.789093,
		0,
		-0.129797,
		0.991458,
		-0.012792,
		0,
		0.058897,
		-0.453541,
		-0.332606,
		1,
	},
	[1.025] = {
		0.776776,
		0.122273,
		-0.617793,
		0,
		-0.617981,
		-0.040991,
		-0.785124,
		0,
		-0.121323,
		0.99165,
		0.043722,
		0,
		0.051575,
		-0.456329,
		-0.324772,
		1,
	},
	[1.03333333333] = {
		0.770625,
		0.144771,
		-0.620627,
		0,
		-0.626851,
		-0.003334,
		-0.779132,
		0,
		-0.114865,
		0.98946,
		0.088181,
		0,
		0.045469,
		-0.459319,
		-0.31888,
		1,
	},
	[1.04166666667] = {
		0.76558,
		0.161792,
		-0.622664,
		0,
		-0.633837,
		0.023948,
		-0.773096,
		0,
		-0.110169,
		0.986534,
		0.120884,
		0,
		0.041113,
		-0.461877,
		-0.315141,
		1,
	},
	[1.05833333333] = {
		0.760002,
		0.180916,
		-0.624233,
		0,
		-0.641466,
		0.054387,
		-0.765221,
		0,
		-0.10449,
		0.981994,
		0.157386,
		0,
		0.038126,
		-0.464252,
		-0.313317,
		1,
	},
	[1.05] = {
		0.762131,
		0.173578,
		-0.623721,
		0,
		-0.638565,
		0.042716,
		-0.768381,
		0,
		-0.106731,
		0.983893,
		0.143396,
		0,
		0.038778,
		-0.463484,
		-0.313397,
		1,
	},
	[1.06666666667] = {
		0.758966,
		0.184504,
		-0.624442,
		0,
		-0.642879,
		0.060149,
		-0.763602,
		0,
		-0.103328,
		0.980989,
		0.164265,
		0,
		0.03883,
		-0.464308,
		-0.314561,
		1,
	},
	[1.075] = {
		0.758831,
		0.184978,
		-0.624467,
		0,
		-0.643076,
		0.061028,
		-0.763366,
		0,
		-0.103096,
		0.980846,
		0.165265,
		0,
		0.040574,
		-0.463768,
		-0.316782,
		1,
	},
	[1.08333333333] = {
		0.759422,
		0.182926,
		-0.624352,
		0,
		-0.642292,
		0.057945,
		-0.764267,
		0,
		-0.103626,
		0.981417,
		0.161497,
		0,
		0.043039,
		-0.462782,
		-0.319642,
		1,
	},
	[1.09166666667] = {
		0.760581,
		0.178916,
		-0.624104,
		0,
		-0.640738,
		0.051771,
		-0.766012,
		0,
		-0.104742,
		0.982501,
		0.154015,
		0,
		0.045905,
		-0.461521,
		-0.322807,
		1,
	},
	{
		0.799743,
		0.024516,
		-0.599842,
		0,
		-0.581074,
		-0.219501,
		-0.783692,
		0,
		-0.150879,
		0.975304,
		-0.161299,
		0,
		0.077022,
		-0.448976,
		-0.353067,
		1,
	},
	[1.10833333333] = {
		0.763964,
		0.167273,
		-0.6232,
		0,
		-0.636156,
		0.033599,
		-0.770828,
		0,
		-0.108,
		0.985338,
		0.13208,
		0,
		0.051896,
		-0.458672,
		-0.329082,
		1,
	},
	[1.11666666667] = {
		0.765862,
		0.160789,
		-0.622578,
		0,
		-0.633567,
		0.02341,
		-0.773334,
		0,
		-0.109769,
		0.986711,
		0.1198,
		0,
		0.055036,
		-0.457172,
		-0.332327,
		1,
	},
	[1.125] = {
		0.767664,
		0.15466,
		-0.62191,
		0,
		-0.631095,
		0.013739,
		-0.775584,
		0,
		-0.111407,
		0.987872,
		0.108152,
		0,
		0.057986,
		-0.455773,
		-0.33537,
		1,
	},
	[1.13333333333] = {
		0.769187,
		0.149504,
		-0.621289,
		0,
		-0.628996,
		0.005573,
		-0.777388,
		0,
		-0.11276,
		0.988745,
		0.098324,
		0,
		0.060456,
		-0.454611,
		-0.337914,
		1,
	},
	[1.14166666667] = {
		0.770241,
		0.145948,
		-0.620829,
		0,
		-0.62754,
		-7.4e-05,
		-0.778585,
		0,
		-0.113679,
		0.989292,
		0.091531,
		0,
		0.062153,
		-0.453817,
		-0.33966,
		1,
	},
	[1.15] = {
		0.770634,
		0.144624,
		-0.62065,
		0,
		-0.626995,
		-0.00218,
		-0.77902,
		0,
		-0.114018,
		0.989484,
		0.088999,
		0,
		0.062783,
		-0.453523,
		-0.340308,
		1,
	},
	[1.1] = {
		0.762148,
		0.173509,
		-0.623718,
		0,
		-0.638622,
		0.04336,
		-0.768298,
		0,
		-0.106263,
		0.983877,
		0.143854,
		0,
		0.048858,
		-0.460136,
		-0.325936,
		1,
	},
}

return spline_matrices
