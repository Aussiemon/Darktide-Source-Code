﻿-- chunkname: @content/characters/player/human/first_person/animations/chain_sword/attack_right_diagonal_up.lua

local spline_matrices = {
	[0.0166666666667] = {
		0.624376,
		-0.72793,
		-0.283325,
		0,
		-0.749318,
		-0.455716,
		-0.480463,
		0,
		0.220628,
		0.51229,
		-0.829989,
		0,
		0.093592,
		-0.069369,
		-0.442299,
		1,
	},
	[0.0333333333333] = {
		0.486633,
		-0.873507,
		-0.013142,
		0,
		-0.807203,
		-0.44384,
		-0.389139,
		0,
		0.334083,
		0.199976,
		-0.921085,
		0,
		0.022646,
		-0.049797,
		-0.423709,
		1,
	},
	[0.05] = {
		0.286359,
		-0.901445,
		0.324648,
		0,
		-0.874368,
		-0.384414,
		-0.296151,
		0,
		0.391763,
		-0.199056,
		-0.898275,
		0,
		-0.04923,
		-0.0288,
		-0.404393,
		1,
	},
	[0.0666666666667] = {
		0.06435,
		-0.755669,
		0.651785,
		0,
		-0.932912,
		-0.277446,
		-0.229561,
		0,
		0.354308,
		-0.593286,
		-0.722826,
		0,
		-0.119104,
		-0.008041,
		-0.386243,
		1,
	},
	[0.0833333333333] = {
		-0.110569,
		-0.479731,
		0.870421,
		0,
		-0.965634,
		-0.155415,
		-0.20832,
		0,
		0.235214,
		-0.863542,
		-0.446061,
		0,
		-0.183992,
		0.01052,
		-0.371194,
		1,
	},
	[0] = {
		0.700864,
		-0.535869,
		-0.47078,
		0,
		-0.7073,
		-0.436714,
		-0.555885,
		0,
		0.092286,
		0.722582,
		-0.685097,
		0,
		0.160753,
		-0.085942,
		-0.458389,
		1,
	},
	[0.116666666667] = {
		-0.238626,
		-0.007367,
		0.971084,
		0,
		-0.97104,
		-0.010319,
		-0.238693,
		0,
		0.011779,
		-0.99992,
		-0.004692,
		0,
		-0.287379,
		0.032044,
		-0.357297,
		1,
	},
	[0.133333333333] = {
		-0.245184,
		0.095832,
		0.964728,
		0,
		-0.969197,
		-0.00034,
		-0.246286,
		0,
		-0.023274,
		-0.995398,
		0.092963,
		0,
		-0.326665,
		0.034769,
		-0.358575,
		1,
	},
	[0.15] = {
		-0.241967,
		0.155444,
		0.957752,
		0,
		-0.969979,
		-0.013981,
		-0.242786,
		0,
		-0.024349,
		-0.987746,
		0.15416,
		0,
		-0.363879,
		0.036562,
		-0.361966,
		1,
	},
	[0.166666666667] = {
		-0.234673,
		0.182078,
		0.95487,
		0,
		-0.972074,
		-0.044727,
		-0.230373,
		0,
		0.000763,
		-0.982266,
		0.187489,
		0,
		-0.398399,
		0.037569,
		-0.367076,
		1,
	},
	[0.183333333333] = {
		-0.22499,
		0.183221,
		0.956979,
		0,
		-0.973557,
		-0.082168,
		-0.213156,
		0,
		0.039579,
		-0.979632,
		0.196863,
		0,
		-0.429458,
		0.03789,
		-0.373504,
		1,
	},
	[0.1] = {
		-0.204963,
		-0.198043,
		0.958525,
		0,
		-0.973546,
		-0.059794,
		-0.220529,
		0,
		0.100988,
		-0.978368,
		-0.180549,
		0,
		-0.241007,
		0.024644,
		-0.361006,
		1,
	},
	[0.216666666667] = {
		-0.196412,
		0.13027,
		0.971829,
		0,
		-0.973195,
		-0.146832,
		-0.177006,
		0,
		0.119637,
		-0.980546,
		0.155618,
		0,
		-0.478796,
		0.037629,
		-0.388541,
		1,
	},
	[0.233333333333] = {
		-0.17641,
		0.085076,
		0.980633,
		0,
		-0.972625,
		-0.168165,
		-0.16038,
		0,
		0.151264,
		-0.982081,
		0.112413,
		0,
		-0.496203,
		0.037554,
		-0.396435,
		1,
	},
	[0.25] = {
		-0.153317,
		0.033228,
		0.987618,
		0,
		-0.973394,
		-0.177308,
		-0.145144,
		0,
		0.170289,
		-0.983594,
		0.059528,
		0,
		-0.5083,
		0.037758,
		-0.404108,
		1,
	},
	[0.266666666667] = {
		-0.129461,
		-0.021121,
		0.99136,
		0,
		-0.976738,
		-0.16964,
		-0.131165,
		0,
		0.170945,
		-0.98528,
		0.001332,
		0,
		-0.514838,
		0.038493,
		-0.411136,
		1,
	},
	[0.283333333333] = {
		-0.108876,
		-0.07416,
		0.991285,
		0,
		-0.983079,
		-0.139752,
		-0.11843,
		0,
		0.147317,
		-0.987405,
		-0.057689,
		0,
		-0.515583,
		0.040002,
		-0.417043,
		1,
	},
	[0.2] = {
		-0.212524,
		0.164419,
		0.963224,
		0,
		-0.97381,
		-0.117137,
		-0.194865,
		0,
		0.08079,
		-0.979411,
		0.185008,
		0,
		-0.456407,
		0.037803,
		-0.380791,
		1,
	},
	[0.316666666667] = {
		-0.084222,
		-0.186061,
		0.978922,
		0,
		-0.996447,
		0.014973,
		-0.082884,
		0,
		0.000764,
		-0.982424,
		-0.186661,
		0,
		-0.48716,
		0.031205,
		-0.418657,
		1,
	},
	[0.333333333333] = {
		-0.119084,
		-0.219204,
		0.968385,
		0,
		-0.986473,
		0.136779,
		-0.090347,
		0,
		-0.11265,
		-0.966044,
		-0.232527,
		0,
		-0.455369,
		0.047576,
		-0.396272,
		1,
	},
	[0.35] = {
		-0.222445,
		-0.178069,
		0.958546,
		0,
		-0.946381,
		0.275683,
		-0.168409,
		0,
		-0.234266,
		-0.944611,
		-0.229845,
		0,
		-0.423889,
		0.126759,
		-0.334018,
		1,
	},
	[0.366666666667] = {
		-0.349364,
		-0.076044,
		0.933896,
		0,
		-0.85319,
		0.437816,
		-0.283523,
		0,
		-0.387314,
		-0.895843,
		-0.217836,
		0,
		-0.385387,
		0.243374,
		-0.302617,
		1,
	},
	[0.383333333333] = {
		-0.429161,
		-0.030185,
		0.902723,
		0,
		-0.69781,
		0.645651,
		-0.310155,
		0,
		-0.573482,
		-0.763036,
		-0.298152,
		0,
		-0.350118,
		0.36187,
		-0.269124,
		1,
	},
	[0.3] = {
		-0.097166,
		-0.122323,
		0.987723,
		0,
		-0.990856,
		-0.081452,
		-0.107561,
		0,
		0.09361,
		-0.989142,
		-0.11329,
		0,
		-0.508169,
		0.042352,
		-0.421355,
		1,
	},
	[0.416666666667] = {
		-0.542594,
		-0.28972,
		0.78845,
		0,
		0.099387,
		0.909901,
		0.402743,
		0,
		-0.834094,
		0.296888,
		-0.464913,
		0,
		-0.165619,
		0.656032,
		-0.143042,
		1,
	},
	[0.433333333333] = {
		-0.594279,
		-0.206191,
		0.777379,
		0,
		0.570555,
		0.573149,
		0.58819,
		0,
		-0.566833,
		0.793086,
		-0.222967,
		0,
		-0.043284,
		0.711767,
		-0.082651,
		1,
	},
	[0.45] = {
		-0.599188,
		-0.08536,
		0.796045,
		0,
		0.778647,
		0.169156,
		0.604232,
		0,
		-0.186233,
		0.981886,
		-0.034891,
		0,
		0.094737,
		0.675387,
		-0.005292,
		1,
	},
	[0.466666666667] = {
		-0.606327,
		-0.039768,
		0.794221,
		0,
		0.793418,
		-0.097368,
		0.600839,
		0,
		0.053438,
		0.994454,
		0.090589,
		0,
		0.23088,
		0.607396,
		0.054419,
		1,
	},
	[0.483333333333] = {
		-0.563468,
		-0.050673,
		0.824582,
		0,
		0.79692,
		-0.29644,
		0.526348,
		0,
		0.217768,
		0.953706,
		0.207417,
		0,
		0.332042,
		0.512107,
		0.095052,
		1,
	},
	[0.4] = {
		-0.458831,
		-0.232191,
		0.857649,
		0,
		-0.404822,
		0.913875,
		0.030839,
		0,
		-0.790945,
		-0.333046,
		-0.51331,
		0,
		-0.285781,
		0.511061,
		-0.211375,
		1,
	},
	[0.516666666667] = {
		-0.445429,
		-0.14687,
		0.883189,
		0,
		0.755276,
		-0.591362,
		0.282576,
		0,
		0.480782,
		0.792919,
		0.374337,
		0,
		0.478945,
		0.368424,
		0.132314,
		1,
	},
	[0.533333333333] = {
		-0.402509,
		-0.193905,
		0.894644,
		0,
		0.673999,
		-0.724101,
		0.146297,
		0,
		0.619445,
		0.661875,
		0.422149,
		0,
		0.543068,
		0.318593,
		0.139514,
		1,
	},
	[0.55] = {
		-0.348438,
		-0.227812,
		0.909227,
		0,
		0.575773,
		-0.817456,
		0.015832,
		0,
		0.739646,
		0.529024,
		0.416001,
		0,
		0.606588,
		0.276347,
		0.139476,
		1,
	},
	[0.566666666667] = {
		-0.266223,
		-0.240327,
		0.933471,
		0,
		0.473138,
		-0.87631,
		-0.090673,
		0,
		0.839801,
		0.417521,
		0.347001,
		0,
		0.669093,
		0.242924,
		0.130236,
		1,
	},
	[0.583333333333] = {
		-0.116622,
		-0.223911,
		0.967607,
		0,
		0.383338,
		-0.908909,
		-0.164125,
		0,
		0.916216,
		0.35178,
		0.191832,
		0,
		0.736008,
		0.221661,
		0.101102,
		1,
	},
	[0.5] = {
		-0.500892,
		-0.097194,
		0.860035,
		0,
		0.792575,
		-0.450758,
		0.410661,
		0,
		0.347754,
		0.887339,
		0.302815,
		0,
		0.413331,
		0.427471,
		0.120103,
		1,
	},
	[0.616666666667] = {
		0.306929,
		-0.130764,
		0.942706,
		0,
		0.2384,
		-0.948374,
		-0.209169,
		0,
		0.92139,
		0.288942,
		-0.259909,
		0,
		0.797045,
		0.174225,
		-0.017278,
		1,
	},
	[0.633333333333] = {
		0.461235,
		-0.090099,
		0.882692,
		0,
		0.164303,
		-0.968953,
		-0.184758,
		0,
		0.871933,
		0.230246,
		-0.432111,
		0,
		0.776574,
		0.137731,
		-0.078486,
		1,
	},
	[0.65] = {
		0.562524,
		-0.065467,
		0.824185,
		0,
		0.077349,
		-0.988321,
		-0.131297,
		0,
		0.823155,
		0.137608,
		-0.55089,
		0,
		0.757146,
		0.096623,
		-0.142716,
		1,
	},
	[0.666666666667] = {
		0.64729,
		-0.048919,
		0.760672,
		0,
		-0.014838,
		-0.998558,
		-0.051591,
		0,
		0.762099,
		0.022108,
		-0.647083,
		0,
		0.726599,
		0.047816,
		-0.207556,
		1,
	},
	[0.683333333333] = {
		0.717638,
		-0.04262,
		0.695111,
		0,
		-0.106727,
		-0.993066,
		0.049297,
		0,
		0.68819,
		-0.109564,
		-0.71721,
		0,
		0.684449,
		-0.004742,
		-0.268672,
		1,
	},
	[0.6] = {
		0.094913,
		-0.182935,
		0.978533,
		0,
		0.307811,
		-0.929407,
		-0.203607,
		0,
		0.946702,
		0.320528,
		-0.031903,
		0,
		0.801984,
		0.208759,
		0.048048,
		1,
	},
	[0.716666666667] = {
		0.81927,
		-0.05821,
		0.570445,
		0,
		-0.262714,
		-0.922382,
		0.283184,
		0,
		0.509684,
		-0.381868,
		-0.770973,
		0,
		0.577933,
		-0.099804,
		-0.361429,
		1,
	},
	[0.733333333333] = {
		0.854321,
		-0.07918,
		0.51368,
		0,
		-0.316129,
		-0.863653,
		0.392641,
		0,
		0.412552,
		-0.49783,
		-0.762867,
		0,
		0.523318,
		-0.13538,
		-0.390933,
		1,
	},
	[0.75] = {
		0.881048,
		-0.106718,
		0.460831,
		0,
		-0.350124,
		-0.802201,
		0.483619,
		0,
		0.318068,
		-0.58744,
		-0.744142,
		0,
		0.473702,
		-0.161194,
		-0.411367,
		1,
	},
	[0.766666666667] = {
		0.90125,
		-0.138541,
		0.410554,
		0,
		-0.36583,
		-0.75105,
		0.549629,
		0,
		0.2322,
		-0.645546,
		-0.727566,
		0,
		0.431934,
		-0.177522,
		-0.425395,
		1,
	},
	[0.783333333333] = {
		0.9168,
		-0.172164,
		0.36033,
		0,
		-0.366115,
		-0.722715,
		0.58621,
		0,
		0.159492,
		-0.669359,
		-0.725617,
		0,
		0.399924,
		-0.184831,
		-0.435356,
		1,
	},
	[0.7] = {
		0.774253,
		-0.045679,
		0.631226,
		0,
		-0.191456,
		-0.967563,
		0.16482,
		0,
		0.603223,
		-0.248464,
		-0.757884,
		0,
		0.63335,
		-0.055365,
		-0.320759,
		1,
	},
	[0.816666666667] = {
		0.939865,
		-0.221638,
		0.259865,
		0,
		-0.335825,
		-0.738358,
		0.584849,
		0,
		0.062249,
		-0.636948,
		-0.768389,
		0,
		0.343547,
		-0.19382,
		-0.454343,
		1,
	},
	[0.833333333333] = {
		0.949343,
		-0.233392,
		0.210421,
		0,
		-0.31254,
		-0.770894,
		0.555014,
		0,
		0.032676,
		-0.592664,
		-0.804787,
		0,
		0.311134,
		-0.200543,
		-0.464545,
		1,
	},
	[0.85] = {
		0.957918,
		-0.237216,
		0.161619,
		0,
		-0.28683,
		-0.812621,
		0.507323,
		0,
		0.01099,
		-0.532331,
		-0.846465,
		0,
		0.274536,
		-0.20821,
		-0.474195,
		1,
	},
	[0.866666666667] = {
		0.965479,
		-0.234165,
		0.114088,
		0,
		-0.26041,
		-0.857666,
		0.443391,
		0,
		-0.005977,
		-0.457795,
		-0.889038,
		0,
		0.23318,
		-0.216181,
		-0.482135,
		1,
	},
	[0.883333333333] = {
		0.971747,
		-0.225848,
		0.068557,
		0,
		-0.235096,
		-0.900451,
		0.365948,
		0,
		-0.020917,
		-0.371726,
		-0.928107,
		0,
		0.18721,
		-0.223611,
		-0.487005,
		1,
	},
	[0.8] = {
		0.929271,
		-0.20133,
		0.309712,
		0,
		-0.354673,
		-0.720645,
		0.595715,
		0,
		0.103258,
		-0.663428,
		-0.741081,
		0,
		0.372749,
		-0.188492,
		-0.444434,
		1,
	},
	[0.916666666667] = {
		0.979117,
		-0.202748,
		-0.014955,
		0,
		-0.196391,
		-0.962301,
		0.18817,
		0,
		-0.052542,
		-0.181303,
		-0.982023,
		0,
		0.093959,
		-0.218765,
		-0.449812,
		1,
	},
	[0.933333333333] = {
		0.979593,
		-0.193715,
		-0.053589,
		0,
		-0.187809,
		-0.977179,
		0.099247,
		0,
		-0.071591,
		-0.087158,
		-0.993619,
		0,
		0.055709,
		-0.209817,
		-0.422788,
		1,
	},
	[0.95] = {
		0.977391,
		-0.190529,
		-0.091676,
		0,
		-0.189625,
		-0.981681,
		0.018558,
		0,
		-0.093533,
		-0.000754,
		-0.995616,
		0,
		0.025312,
		-0.200202,
		-0.401232,
		1,
	},
	[0.966666666667] = {
		0.971749,
		-0.196341,
		-0.130975,
		0,
		-0.204025,
		-0.977791,
		-0.047952,
		0,
		-0.118651,
		0.07332,
		-0.990225,
		0,
		0.004393,
		-0.190329,
		-0.387072,
		1,
	},
	[0.983333333333] = {
		0.961267,
		-0.214322,
		-0.173295,
		0,
		-0.232869,
		-0.967887,
		-0.094689,
		0,
		-0.147436,
		0.131377,
		-0.980307,
		0,
		-0.005407,
		-0.180575,
		-0.382285,
		1,
	},
	[0.9] = {
		0.976396,
		-0.214471,
		0.025539,
		0,
		-0.212974,
		-0.936348,
		0.279096,
		0,
		-0.035944,
		-0.277947,
		-0.959924,
		0,
		0.138467,
		-0.226653,
		-0.480392,
		1,
	},
	[1.01666666667] = {
		0.915438,
		-0.300614,
		-0.267591,
		0,
		-0.344144,
		-0.929419,
		-0.133212,
		0,
		-0.208659,
		0.214037,
		-0.95428,
		0,
		0.008375,
		-0.153624,
		-0.384357,
		1,
	},
	[1.03333333333] = {
		0.876658,
		-0.361848,
		-0.317076,
		0,
		-0.418573,
		-0.898563,
		-0.131836,
		0,
		-0.237208,
		0.248295,
		-0.939192,
		0,
		0.025784,
		-0.136544,
		-0.385535,
		1,
	},
	[1.05] = {
		0.826971,
		-0.426896,
		-0.365894,
		0,
		-0.496815,
		-0.859512,
		-0.12006,
		0,
		-0.263237,
		0.281068,
		-0.92288,
		0,
		0.045393,
		-0.119083,
		-0.38633,
		1,
	},
	[1.06666666667] = {
		0.768026,
		-0.489782,
		-0.412614,
		0,
		-0.573039,
		-0.813244,
		-0.101297,
		0,
		-0.285943,
		0.314242,
		-0.905256,
		0,
		0.063487,
		-0.102832,
		-0.386432,
		1,
	},
	[1.08333333333] = {
		0.703167,
		-0.54509,
		-0.456544,
		0,
		-0.642484,
		-0.762156,
		-0.079576,
		0,
		-0.304581,
		0.349278,
		-0.886135,
		0,
		0.076266,
		-0.089492,
		-0.385538,
		1,
	},
	{
		0.943261,
		-0.249432,
		-0.219184,
		0,
		-0.280051,
		-0.952262,
		-0.121528,
		0,
		-0.178407,
		0.176015,
		-0.968086,
		0,
		-0.003214,
		-0.168795,
		-0.383149,
		1,
	},
	[1.1] = {
		0.637224,
		-0.588247,
		-0.497907,
		0,
		-0.701728,
		-0.709974,
		-0.059285,
		0,
		-0.318627,
		0.387173,
		-0.865202,
		0,
		0.079838,
		-0.080855,
		-0.383334,
		1,
	},
}

return spline_matrices
