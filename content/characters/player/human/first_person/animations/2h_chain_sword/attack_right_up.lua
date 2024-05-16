﻿-- chunkname: @content/characters/player/human/first_person/animations/2h_chain_sword/attack_right_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		-0.175485,
		-0.244811,
		0.953558,
		0,
		-0.83255,
		-0.480034,
		-0.276456,
		0,
		0.525419,
		-0.842399,
		-0.119579,
		0,
		-0.663928,
		-0.100243,
		-0.317352,
		1,
	},
	[0.0333333333333] = {
		-0.186022,
		-0.267989,
		0.945292,
		0,
		-0.84372,
		-0.449467,
		-0.293457,
		0,
		0.503521,
		-0.852151,
		-0.142497,
		0,
		-0.650242,
		-0.096612,
		-0.323296,
		1,
	},
	[0.05] = {
		-0.220137,
		-0.325651,
		0.919505,
		0,
		-0.861038,
		-0.378123,
		-0.340055,
		0,
		0.458426,
		-0.866588,
		-0.197159,
		0,
		-0.632114,
		-0.086592,
		-0.344925,
		1,
	},
	[0.0666666666667] = {
		-0.269015,
		-0.395125,
		0.878355,
		0,
		-0.87618,
		-0.278282,
		-0.393533,
		0,
		0.399925,
		-0.875463,
		-0.271338,
		0,
		-0.615375,
		-0.066561,
		-0.375577,
		1,
	},
	[0.0833333333333] = {
		-0.322887,
		-0.455472,
		0.829632,
		0,
		-0.884753,
		-0.166021,
		-0.435487,
		0,
		0.336089,
		-0.874633,
		-0.349374,
		0,
		-0.605779,
		-0.032938,
		-0.408474,
		1,
	},
	[0] = {
		-0.177623,
		-0.245511,
		0.952982,
		0,
		-0.82982,
		-0.483193,
		-0.279149,
		0,
		0.529008,
		-0.840386,
		-0.117903,
		0,
		-0.669079,
		-0.10079,
		-0.319555,
		1,
	},
	[0.116666666667] = {
		-0.384377,
		-0.50541,
		0.772538,
		0,
		-0.888906,
		-0.023269,
		-0.457499,
		0,
		0.249201,
		-0.862566,
		-0.440317,
		0,
		-0.600861,
		0.114476,
		-0.458225,
		1,
	},
	[0.133333333333] = {
		-0.37859,
		-0.490679,
		0.784795,
		0,
		-0.909677,
		0.040829,
		-0.413305,
		0,
		0.170758,
		-0.870384,
		-0.461816,
		0,
		-0.599927,
		0.2094,
		-0.465579,
		1,
	},
	[0.15] = {
		-0.364815,
		-0.465407,
		0.806415,
		0,
		-0.931052,
		0.175584,
		-0.319865,
		0,
		0.007274,
		-0.867506,
		-0.497373,
		0,
		-0.598067,
		0.294269,
		-0.466418,
		1,
	},
	[0.166666666667] = {
		-0.385104,
		-0.402931,
		0.830266,
		0,
		-0.882076,
		0.42524,
		-0.202764,
		0,
		-0.271363,
		-0.810443,
		-0.519177,
		0,
		-0.594087,
		0.373871,
		-0.461034,
		1,
	},
	[0.183333333333] = {
		-0.442671,
		-0.295223,
		0.846691,
		0,
		-0.679847,
		0.726193,
		-0.102233,
		0,
		-0.58468,
		-0.620876,
		-0.52217,
		0,
		-0.582611,
		0.457493,
		-0.452732,
		1,
	},
	[0.1] = {
		-0.365526,
		-0.495952,
		0.787669,
		0,
		-0.88475,
		-0.077755,
		-0.459535,
		0,
		0.289152,
		-0.864862,
		-0.410372,
		0,
		-0.602423,
		0.027682,
		-0.439167,
		1,
	},
	[0.216666666667] = {
		-0.490107,
		-0.080278,
		0.867957,
		0,
		0.020209,
		0.994436,
		0.103387,
		0,
		-0.871428,
		0.068211,
		-0.485758,
		0,
		-0.520114,
		0.601035,
		-0.398175,
		1,
	},
	[0.233333333333] = {
		-0.454437,
		-0.064722,
		0.888424,
		0,
		0.321663,
		0.918138,
		0.23142,
		0,
		-0.830675,
		0.390939,
		-0.396417,
		0,
		-0.428007,
		0.644558,
		-0.318007,
		1,
	},
	[0.25] = {
		-0.453965,
		-0.09941,
		0.885456,
		0,
		0.53463,
		0.7646,
		0.359941,
		0,
		-0.712802,
		0.636792,
		-0.293954,
		0,
		-0.278713,
		0.651466,
		-0.228845,
		1,
	},
	[0.266666666667] = {
		-0.466815,
		-0.14221,
		0.872846,
		0,
		0.712703,
		0.523848,
		0.466516,
		0,
		-0.523582,
		0.839857,
		-0.143187,
		0,
		-0.135663,
		0.641694,
		-0.158746,
		1,
	},
	[0.283333333333] = {
		-0.277927,
		-0.101481,
		0.955226,
		0,
		0.89713,
		0.328048,
		0.295875,
		0,
		-0.343386,
		0.939195,
		-0.000131,
		0,
		-0.017375,
		0.624734,
		-0.103719,
		1,
	},
	[0.2] = {
		-0.497595,
		-0.173104,
		0.849961,
		0,
		-0.345372,
		0.9384,
		-0.011077,
		0,
		-0.795687,
		-0.299065,
		-0.526728,
		0,
		-0.557241,
		0.533867,
		-0.439919,
		1,
	},
	[0.316666666667] = {
		-0.31047,
		-0.097047,
		0.945616,
		0,
		0.945792,
		-0.131288,
		0.297054,
		0,
		0.09532,
		0.986583,
		0.132547,
		0,
		0.185324,
		0.529445,
		-0.042926,
		1,
	},
	[0.333333333333] = {
		-0.372983,
		-0.085599,
		0.923881,
		0,
		0.875666,
		-0.361667,
		0.320009,
		0,
		0.306745,
		0.92837,
		0.209852,
		0,
		0.282572,
		0.469844,
		-0.010325,
		1,
	},
	[0.35] = {
		-0.340884,
		-0.086397,
		0.936127,
		0,
		0.810556,
		-0.53144,
		0.24611,
		0,
		0.476232,
		0.842679,
		0.251189,
		0,
		0.366648,
		0.40954,
		0.010039,
		1,
	},
	[0.366666666667] = {
		-0.244614,
		-0.114506,
		0.962835,
		0,
		0.772702,
		-0.622889,
		0.122232,
		0,
		0.585744,
		0.773885,
		0.240846,
		0,
		0.443894,
		0.341451,
		0.015899,
		1,
	},
	[0.383333333333] = {
		-0.196654,
		-0.147318,
		0.969342,
		0,
		0.751247,
		-0.657936,
		0.052416,
		0,
		0.630044,
		0.738524,
		0.240058,
		0,
		0.524549,
		0.245273,
		0.015236,
		1,
	},
	[0.3] = {
		-0.277499,
		-0.097057,
		0.95581,
		0,
		0.950962,
		0.11373,
		0.28764,
		0,
		-0.136622,
		0.98876,
		0.060737,
		0,
		0.081621,
		0.582655,
		-0.076017,
		1,
	},
	[0.416666666667] = {
		-0.11572,
		-0.221407,
		0.968291,
		0,
		0.718587,
		-0.691671,
		-0.072278,
		0,
		0.685742,
		0.687438,
		0.23914,
		0,
		0.687977,
		0.042955,
		-0.016766,
		1,
	},
	[0.433333333333] = {
		-0.098711,
		-0.240015,
		0.965737,
		0,
		0.680853,
		-0.724058,
		-0.110358,
		0,
		0.725738,
		0.646632,
		0.234888,
		0,
		0.734387,
		0.006121,
		-0.05117,
		1,
	},
	[0.45] = {
		-0.106414,
		-0.221197,
		0.969406,
		0,
		0.606961,
		-0.786675,
		-0.112874,
		0,
		0.787575,
		0.576381,
		0.217971,
		0,
		0.752342,
		0.016235,
		-0.102859,
		1,
	},
	[0.466666666667] = {
		-0.129115,
		-0.16945,
		0.977044,
		0,
		0.503072,
		-0.860277,
		-0.082718,
		0,
		0.854546,
		0.480843,
		0.19632,
		0,
		0.760371,
		0.03839,
		-0.169025,
		1,
	},
	[0.483333333333] = {
		-0.154721,
		-0.111469,
		0.981649,
		0,
		0.406868,
		-0.912633,
		-0.039505,
		0,
		0.900289,
		0.393289,
		0.186556,
		0,
		0.761829,
		0.065281,
		-0.236996,
		1,
	},
	[0.4] = {
		-0.151673,
		-0.186694,
		0.970639,
		0,
		0.73827,
		-0.674353,
		-0.014343,
		0,
		0.657232,
		0.714418,
		0.240111,
		0,
		0.611449,
		0.134123,
		0.005115,
		1,
	},
	[0.516666666667] = {
		-0.161138,
		-0.063515,
		0.984886,
		0,
		0.406194,
		-0.913756,
		0.007529,
		0,
		0.899467,
		0.401268,
		0.17304,
		0,
		0.757738,
		0.11131,
		-0.34162,
		1,
	},
	[0.533333333333] = {
		-0.131913,
		-0.059078,
		0.989499,
		0,
		0.488948,
		-0.872215,
		0.013108,
		0,
		0.862281,
		0.485543,
		0.143943,
		0,
		0.752884,
		0.134091,
		-0.387996,
		1,
	},
	[0.55] = {
		-0.078547,
		-0.057861,
		0.99523,
		0,
		0.588241,
		-0.808686,
		-0.00059,
		0,
		0.804862,
		0.585389,
		0.097556,
		0,
		0.743426,
		0.15656,
		-0.431356,
		1,
	},
	[0.566666666667] = {
		-0.001194,
		-0.056507,
		0.998401,
		0,
		0.677387,
		-0.734497,
		-0.04076,
		0,
		0.735626,
		0.676256,
		0.039154,
		0,
		0.727125,
		0.177382,
		-0.46982,
		1,
	},
	[0.583333333333] = {
		0.097219,
		-0.053362,
		0.993831,
		0,
		0.734153,
		-0.670371,
		-0.107811,
		0,
		0.671989,
		0.740105,
		-0.025997,
		0,
		0.701772,
		0.19494,
		-0.501536,
		1,
	},
	[0.5] = {
		-0.16853,
		-0.074989,
		0.98284,
		0,
		0.367889,
		-0.929837,
		-0.007862,
		0,
		0.91447,
		0.360251,
		0.184293,
		0,
		0.760199,
		0.0896,
		-0.294107,
		1,
	},
	[0.616666666667] = {
		0.345098,
		-0.043323,
		0.937566,
		0,
		0.707871,
		-0.643926,
		-0.290307,
		0,
		0.6163,
		0.76386,
		-0.191551,
		0,
		0.607554,
		0.21639,
		-0.541377,
		1,
	},
	[0.633333333333] = {
		0.497106,
		-0.036316,
		0.866929,
		0,
		0.644341,
		-0.653705,
		-0.396856,
		0,
		0.581128,
		0.755878,
		-0.30156,
		0,
		0.52503,
		0.223568,
		-0.555235,
		1,
	},
	[0.65] = {
		0.649952,
		-0.029104,
		0.759418,
		0,
		0.551517,
		-0.66944,
		-0.497674,
		0,
		0.522869,
		0.742296,
		-0.419052,
		0,
		0.423998,
		0.229455,
		-0.566453,
		1,
	},
	[0.666666666667] = {
		0.786525,
		-0.022564,
		0.617146,
		0,
		0.434989,
		-0.689119,
		-0.579569,
		0,
		0.438365,
		0.724297,
		-0.532194,
		0,
		0.310874,
		0.234344,
		-0.575258,
		1,
	},
	[0.683333333333] = {
		0.893166,
		-0.017202,
		0.449399,
		0,
		0.30524,
		-0.710671,
		-0.633857,
		0,
		0.330279,
		0.703314,
		-0.629496,
		0,
		0.192074,
		0.238492,
		-0.581889,
		1,
	},
	[0.6] = {
		0.211248,
		-0.048957,
		0.976205,
		0,
		0.742171,
		-0.641883,
		-0.192794,
		0,
		0.636048,
		0.765239,
		-0.099262,
		0,
		0.665151,
		0.20761,
		-0.524661,
		1,
	},
	[0.716666666667] = {
		0.995151,
		-0.010211,
		0.097831,
		0,
		0.05685,
		-0.751949,
		-0.656765,
		0,
		0.08027,
		0.659142,
		-0.747722,
		0,
		-0.036888,
		0.245365,
		-0.589641,
		1,
	},
	[0.733333333333] = {
		0.998517,
		-0.008069,
		-0.053845,
		0,
		-0.040632,
		-0.76873,
		-0.638281,
		0,
		-0.036242,
		0.639523,
		-0.767917,
		0,
		-0.134216,
		0.248344,
		-0.591298,
		1,
	},
	[0.75] = {
		0.985072,
		-0.006394,
		-0.172027,
		0,
		-0.112248,
		-0.781509,
		-0.613713,
		0,
		-0.130517,
		0.623861,
		-0.77056,
		0,
		-0.211552,
		0.251073,
		-0.591855,
		1,
	},
	[0.766666666667] = {
		0.96877,
		-0.005014,
		-0.247913,
		0,
		-0.155998,
		-0.789475,
		-0.593627,
		0,
		-0.192744,
		0.613762,
		-0.765601,
		0,
		-0.262482,
		0.253498,
		-0.591615,
		1,
	},
	[0.783333333333] = {
		0.961435,
		-0.005417,
		-0.274978,
		0,
		-0.172172,
		-0.791518,
		-0.586392,
		0,
		-0.214474,
		0.611122,
		-0.761926,
		0,
		-0.28063,
		0.25547,
		-0.591042,
		1,
	},
	[0.7] = {
		0.962562,
		-0.013143,
		0.270743,
		0,
		0.175145,
		-0.732163,
		-0.658226,
		0,
		0.206879,
		0.681003,
		-0.70245,
		0,
		0.074014,
		0.242113,
		-0.586596,
		1,
	},
	[0.816666666667] = {
		0.961089,
		-0.009916,
		-0.276062,
		0,
		-0.177156,
		-0.78891,
		-0.588419,
		0,
		-0.211953,
		0.614429,
		-0.759969,
		0,
		-0.279872,
		0.258666,
		-0.59001,
		1,
	},
	[0.833333333333] = {
		0.960904,
		-0.012328,
		-0.276609,
		0,
		-0.179718,
		-0.78774,
		-0.589209,
		0,
		-0.210632,
		0.615885,
		-0.759157,
		0,
		-0.279466,
		0.260124,
		-0.589562,
		1,
	},
	[0.85] = {
		0.960711,
		-0.01484,
		-0.277156,
		0,
		-0.182312,
		-0.786681,
		-0.589827,
		0,
		-0.20928,
		0.617181,
		-0.758478,
		0,
		-0.279043,
		0.261466,
		-0.589169,
		1,
	},
	[0.866666666667] = {
		0.96051,
		-0.017448,
		-0.277699,
		0,
		-0.184926,
		-0.78575,
		-0.590254,
		0,
		-0.207903,
		0.618299,
		-0.757946,
		0,
		-0.278607,
		0.262673,
		-0.588838,
		1,
	},
	[0.883333333333] = {
		0.960302,
		-0.020147,
		-0.278235,
		0,
		-0.18755,
		-0.784962,
		-0.590474,
		0,
		-0.206508,
		0.619216,
		-0.757579,
		0,
		-0.27816,
		0.26373,
		-0.588577,
		1,
	},
	[0.8] = {
		0.961266,
		-0.007611,
		-0.275517,
		0,
		-0.174637,
		-0.790175,
		-0.587474,
		0,
		-0.213236,
		0.612834,
		-0.760897,
		0,
		-0.280261,
		0.257109,
		-0.590506,
		1,
	},
	[0.916666666667] = {
		0.959867,
		-0.025759,
		-0.27927,
		0,
		-0.192785,
		-0.783813,
		-0.590314,
		0,
		-0.20369,
		0.620462,
		-0.757322,
		0,
		-0.277242,
		0.265392,
		-0.588262,
		1,
	},
	[0.933333333333] = {
		0.959642,
		-0.02859,
		-0.279769,
		0,
		-0.195373,
		-0.78333,
		-0.590105,
		0,
		-0.20228,
		0.620949,
		-0.757301,
		0,
		-0.276777,
		0.266117,
		-0.588154,
		1,
	},
	[0.95] = {
		0.959413,
		-0.031408,
		-0.280252,
		0,
		-0.197928,
		-0.782883,
		-0.589846,
		0,
		-0.200879,
		0.621376,
		-0.757324,
		0,
		-0.27631,
		0.266794,
		-0.588067,
		1,
	},
	[0.966666666667] = {
		0.959181,
		-0.034198,
		-0.280719,
		0,
		-0.200438,
		-0.782471,
		-0.589546,
		0,
		-0.199493,
		0.621748,
		-0.757385,
		0,
		-0.275845,
		0.267425,
		-0.587999,
		1,
	},
	[0.983333333333] = {
		0.958947,
		-0.036947,
		-0.281169,
		0,
		-0.202893,
		-0.782092,
		-0.589209,
		0,
		-0.19813,
		0.622067,
		-0.75748,
		0,
		-0.275384,
		0.26801,
		-0.587949,
		1,
	},
	[0.9] = {
		0.960087,
		-0.02293,
		-0.278759,
		0,
		-0.190174,
		-0.784335,
		-0.590468,
		0,
		-0.205101,
		0.619914,
		-0.75739,
		0,
		-0.277704,
		0.264618,
		-0.588393,
		1,
	},
	[1.01666666667] = {
		0.958481,
		-0.042264,
		-0.282007,
		0,
		-0.207593,
		-0.781427,
		-0.588453,
		0,
		-0.195498,
		0.622564,
		-0.757756,
		0,
		-0.274484,
		0.269046,
		-0.587896,
		1,
	},
	[1.03333333333] = {
		0.958252,
		-0.044802,
		-0.282394,
		0,
		-0.209817,
		-0.781138,
		-0.588047,
		0,
		-0.194243,
		0.622749,
		-0.757927,
		0,
		-0.274051,
		0.269501,
		-0.58789,
		1,
	},
	[1.05] = {
		0.958028,
		-0.047243,
		-0.282757,
		0,
		-0.211943,
		-0.780878,
		-0.587631,
		0,
		-0.193037,
		0.622895,
		-0.758115,
		0,
		-0.273633,
		0.269914,
		-0.587895,
		1,
	},
	[1.06666666667] = {
		0.95781,
		-0.04957,
		-0.283095,
		0,
		-0.21396,
		-0.780644,
		-0.587211,
		0,
		-0.191888,
		0.623008,
		-0.758314,
		0,
		-0.273232,
		0.270287,
		-0.58791,
		1,
	},
	[1.08333333333] = {
		0.957601,
		-0.05177,
		-0.283408,
		0,
		-0.215857,
		-0.780435,
		-0.586794,
		0,
		-0.190803,
		0.62309,
		-0.75852,
		0,
		-0.272851,
		0.270621,
		-0.587933,
		1,
	},
	{
		0.958713,
		-0.03964,
		-0.281598,
		0,
		-0.205281,
		-0.781744,
		-0.588843,
		0,
		-0.196796,
		0.622338,
		-0.757605,
		0,
		-0.274929,
		0.26855,
		-0.587915,
		1,
	},
	[1.11666666667] = {
		0.957217,
		-0.055731,
		-0.283953,
		0,
		-0.21925,
		-0.78009,
		-0.585994,
		0,
		-0.188851,
		0.62318,
		-0.758934,
		0,
		-0.272162,
		0.271178,
		-0.587996,
		1,
	},
	[1.13333333333] = {
		0.957046,
		-0.057464,
		-0.284184,
		0,
		-0.220725,
		-0.779952,
		-0.585624,
		0,
		-0.187998,
		0.623196,
		-0.759133,
		0,
		-0.271859,
		0.271404,
		-0.588032,
		1,
	},
	[1.15] = {
		0.956892,
		-0.059012,
		-0.284387,
		0,
		-0.222038,
		-0.779836,
		-0.585282,
		0,
		-0.187236,
		0.623197,
		-0.759321,
		0,
		-0.271587,
		0.271595,
		-0.588069,
		1,
	},
	[1.16666666667] = {
		0.956756,
		-0.060361,
		-0.28456,
		0,
		-0.223178,
		-0.77974,
		-0.584976,
		0,
		-0.186573,
		0.623187,
		-0.759492,
		0,
		-0.27135,
		0.271753,
		-0.588106,
		1,
	},
	[1.18333333333] = {
		0.956641,
		-0.061497,
		-0.284703,
		0,
		-0.224134,
		-0.779665,
		-0.584711,
		0,
		-0.186015,
		0.623171,
		-0.759642,
		0,
		-0.27115,
		0.27188,
		-0.588139,
		1,
	},
	[1.1] = {
		0.957403,
		-0.053829,
		-0.283694,
		0,
		-0.217624,
		-0.780251,
		-0.586386,
		0,
		-0.189788,
		0.623147,
		-0.758728,
		0,
		-0.272494,
		0.270918,
		-0.587962,
		1,
	},
	[1.21666666667] = {
		0.956481,
		-0.063072,
		-0.284897,
		0,
		-0.225455,
		-0.779569,
		-0.584331,
		0,
		-0.185242,
		0.623133,
		-0.759862,
		0,
		-0.270871,
		0.272045,
		-0.588192,
		1,
	},
	[1.23333333333] = {
		0.956439,
		-0.063483,
		-0.284946,
		0,
		-0.225797,
		-0.779546,
		-0.584229,
		0,
		-0.18504,
		0.623119,
		-0.759922,
		0,
		-0.270799,
		0.272085,
		-0.588207,
		1,
	},
	[1.25] = {
		0.956425,
		-0.063623,
		-0.284963,
		0,
		-0.225914,
		-0.779539,
		-0.584193,
		0,
		-0.184972,
		0.623114,
		-0.759943,
		0,
		-0.270774,
		0.272098,
		-0.588212,
		1,
	},
	[1.2] = {
		0.956549,
		-0.062405,
		-0.284815,
		0,
		-0.224897,
		-0.779608,
		-0.584494,
		0,
		-0.185569,
		0.623151,
		-0.759767,
		0,
		-0.270989,
		0.271977,
		-0.588169,
		1,
	},
}

return spline_matrices
