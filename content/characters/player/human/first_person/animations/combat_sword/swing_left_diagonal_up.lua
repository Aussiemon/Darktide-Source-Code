local spline_matrices = {
	[0] = {
		0.9078,
		-0.352677,
		-0.226976,
		0,
		-0.355792,
		-0.361048,
		-0.862007,
		0,
		0.222061,
		0.863286,
		-0.453239,
		0,
		-0.108344,
		0.052299,
		-0.757479,
		1
	},
	{
		0.849014,
		-0.197855,
		-0.489928,
		0,
		-0.528371,
		-0.317189,
		-0.787538,
		0,
		0.000418,
		0.927494,
		-0.373839,
		0,
		-0.079425,
		0.022949,
		-0.693119,
		1
	},
	[0.0166666666667] = {
		0.828389,
		-0.54309,
		-0.137203,
		0,
		-0.357884,
		-0.324713,
		-0.875489,
		0,
		0.430918,
		0.774348,
		-0.463352,
		0,
		-0.091362,
		0.063275,
		-0.759103,
		1
	},
	[0.0333333333333] = {
		0.298752,
		-0.941151,
		-0.158054,
		0,
		-0.351421,
		0.045487,
		-0.935112,
		0,
		0.887271,
		0.33491,
		-0.317151,
		0,
		-0.030606,
		0.109824,
		-0.738235,
		1
	},
	[0.05] = {
		-0.22852,
		-0.931559,
		-0.282799,
		0,
		-0.167957,
		0.323855,
		-0.931079,
		0,
		0.958942,
		-0.165273,
		-0.230469,
		0,
		0.042913,
		0.15906,
		-0.699306,
		1
	},
	[0.0666666666667] = {
		-0.433532,
		-0.815929,
		-0.382504,
		0,
		-0.037463,
		0.44042,
		-0.89701,
		0,
		0.900359,
		-0.374553,
		-0.221503,
		0,
		0.112922,
		0.210221,
		-0.649434,
		1
	},
	[0.0833333333333] = {
		-0.563334,
		-0.665652,
		-0.489451,
		0,
		0.102249,
		0.531672,
		-0.840756,
		0,
		0.819878,
		-0.523672,
		-0.231446,
		0,
		0.192946,
		0.262068,
		-0.595048,
		1
	},
	[0.116666666667] = {
		-0.651983,
		-0.332336,
		-0.681521,
		0,
		0.359946,
		0.655435,
		-0.663961,
		0,
		0.667351,
		-0.678202,
		-0.307709,
		0,
		0.344176,
		0.366104,
		-0.492376,
		1
	},
	[0.133333333333] = {
		-0.639779,
		-0.170275,
		-0.749459,
		0,
		0.458168,
		0.69843,
		-0.549798,
		0,
		0.617062,
		-0.695128,
		-0.368826,
		0,
		0.408479,
		0.418702,
		-0.444288,
		1
	},
	[0.15] = {
		-0.611043,
		-0.020958,
		-0.79132,
		0,
		0.524452,
		0.73806,
		-0.42452,
		0,
		0.592939,
		-0.674409,
		-0.439995,
		0,
		0.457413,
		0.472151,
		-0.395245,
		1
	},
	[0.166666666667] = {
		-0.583463,
		0.108506,
		-0.804858,
		0,
		0.549373,
		0.782616,
		-0.292747,
		0,
		0.598131,
		-0.612975,
		-0.516238,
		0,
		0.481154,
		0.524702,
		-0.345999,
		1
	},
	[0.183333333333] = {
		-0.575667,
		0.208205,
		-0.790733,
		0,
		0.521413,
		0.83839,
		-0.158843,
		0,
		0.629871,
		-0.503739,
		-0.591194,
		0,
		0.470266,
		0.574354,
		-0.298218,
		1
	},
	[0.1] = {
		-0.631452,
		-0.500404,
		-0.592337,
		0,
		0.238231,
		0.601756,
		-0.762323,
		0,
		0.737912,
		-0.622484,
		-0.260769,
		0,
		0.271417,
		0.314225,
		-0.541876,
		1
	},
	[0.216666666667] = {
		-0.639814,
		0.273442,
		-0.71824,
		0,
		0.125382,
		0.959181,
		0.253479,
		0,
		0.758233,
		0.072125,
		-0.647982,
		0,
		0.300058,
		0.686127,
		-0.192778,
		1
	},
	[0.233333333333] = {
		-0.696406,
		0.233036,
		-0.678759,
		0,
		-0.208032,
		0.839646,
		0.501714,
		0,
		0.686835,
		0.4906,
		-0.536256,
		0,
		0.171051,
		0.72338,
		-0.118882,
		1
	},
	[0.25] = {
		-0.737716,
		0.154576,
		-0.657177,
		0,
		-0.479653,
		0.565016,
		0.671335,
		0,
		0.475088,
		0.810471,
		-0.342678,
		0,
		0.039224,
		0.728602,
		-0.049114,
		1
	},
	[0.266666666667] = {
		-0.76644,
		0.10523,
		-0.633637,
		0,
		-0.600071,
		0.234544,
		0.76479,
		0,
		0.229095,
		0.966393,
		-0.116618,
		0,
		-0.075886,
		0.691856,
		0.018078,
		1
	},
	[0.283333333333] = {
		-0.819667,
		0.083718,
		-0.56669,
		0,
		-0.572727,
		-0.100079,
		0.813614,
		0,
		0.011401,
		0.991451,
		0.129979,
		0,
		-0.176312,
		0.598181,
		0.111286,
		1
	},
	[0.2] = {
		-0.601099,
		0.257778,
		-0.756459,
		0,
		0.389714,
		0.920927,
		0.004149,
		0,
		0.697713,
		-0.292309,
		-0.654028,
		0,
		0.407788,
		0.629465,
		-0.252274,
		1
	},
	[0.316666666667] = {
		-0.835471,
		-0.055123,
		-0.546763,
		0,
		-0.402997,
		-0.614972,
		0.677793,
		0,
		-0.373605,
		0.78662,
		0.491577,
		0,
		-0.387844,
		0.330021,
		0.234842,
		1
	},
	[0.333333333333] = {
		-0.794394,
		-0.080031,
		-0.602107,
		0,
		-0.340068,
		-0.762754,
		0.550054,
		0,
		-0.503281,
		0.641717,
		0.578712,
		0,
		-0.420607,
		0.212063,
		0.226179,
		1
	},
	[0.35] = {
		-0.744209,
		-0.04726,
		-0.666273,
		0,
		-0.299668,
		-0.867849,
		0.396278,
		0,
		-0.596953,
		0.494575,
		0.631699,
		0,
		-0.429702,
		0.086045,
		0.195087,
		1
	},
	[0.366666666667] = {
		-0.689557,
		0.019969,
		-0.723956,
		0,
		-0.273183,
		-0.93295,
		0.234469,
		0,
		-0.670733,
		0.359452,
		0.648777,
		0,
		-0.425268,
		-0.031575,
		0.149133,
		1
	},
	[0.383333333333] = {
		-0.632199,
		0.094796,
		-0.768985,
		0,
		-0.250435,
		-0.964214,
		0.087025,
		0,
		-0.733217,
		0.247598,
		0.633316,
		0,
		-0.416289,
		-0.123492,
		0.097112,
		1
	},
	[0.3] = {
		-0.812376,
		-0.030144,
		-0.582354,
		0,
		-0.527312,
		-0.388411,
		0.755698,
		0,
		-0.248972,
		0.920993,
		0.29964,
		0,
		-0.308081,
		0.467206,
		0.183436,
		1
	},
	[0.416666666667] = {
		-0.513213,
		0.180513,
		-0.839063,
		0,
		-0.190581,
		-0.977193,
		-0.093661,
		0,
		-0.836834,
		0.111841,
		0.535911,
		0,
		-0.41061,
		-0.192854,
		0.006095,
		1
	},
	[0.433333333333] = {
		-0.445223,
		0.205008,
		-0.871635,
		0,
		-0.162357,
		-0.975785,
		-0.146574,
		0,
		-0.880578,
		0.076258,
		0.467726,
		0,
		-0.406528,
		-0.208803,
		-0.037614,
		1
	},
	[0.45] = {
		-0.370357,
		0.222955,
		-0.901735,
		0,
		-0.138714,
		-0.973157,
		-0.183642,
		0,
		-0.918474,
		0.05707,
		0.391343,
		0,
		-0.399882,
		-0.2212,
		-0.081639,
		1
	},
	[0.466666666667] = {
		-0.289223,
		0.234609,
		-0.928067,
		0,
		-0.12048,
		-0.970714,
		-0.207844,
		0,
		-0.94965,
		0.0517,
		0.309018,
		0,
		-0.391207,
		-0.230458,
		-0.125752,
		1
	},
	[0.483333333333] = {
		-0.202986,
		0.240323,
		-0.949232,
		0,
		-0.108276,
		-0.968978,
		-0.222169,
		0,
		-0.973177,
		0.057682,
		0.22271,
		0,
		-0.381062,
		-0.236878,
		-0.169754,
		1
	},
	[0.4] = {
		-0.574197,
		0.149136,
		-0.805019,
		0,
		-0.222357,
		-0.974718,
		-0.021973,
		0,
		-0.787944,
		0.166385,
		0.592841,
		0,
		-0.411681,
		-0.172755,
		0.049065,
		1
	},
	[0.516666666667] = {
		-0.022384,
		0.236282,
		-0.971427,
		0,
		-0.102827,
		-0.967061,
		-0.232851,
		0,
		-0.994447,
		0.094677,
		0.045943,
		0,
		-0.358,
		-0.242371,
		-0.25583,
		1
	},
	[0.533333333333] = {
		0.067521,
		0.228368,
		-0.971231,
		0,
		-0.108991,
		-0.965938,
		-0.2347,
		0,
		-0.991747,
		0.121702,
		-0.040331,
		0,
		-0.345747,
		-0.242079,
		-0.297054,
		1
	},
	[0.55] = {
		0.153963,
		0.218378,
		-0.963642,
		0,
		-0.119979,
		-0.963922,
		-0.237611,
		0,
		-0.980765,
		0.1522,
		-0.122208,
		0,
		-0.333373,
		-0.240252,
		-0.336397,
		1
	},
	[0.566666666667] = {
		0.234708,
		0.208175,
		-0.949513,
		0,
		-0.134475,
		-0.960454,
		-0.243814,
		0,
		-0.962719,
		0.184911,
		-0.197431,
		0,
		-0.321107,
		-0.237222,
		-0.37332,
		1
	},
	[0.583333333333] = {
		0.307884,
		0.199944,
		-0.930177,
		0,
		-0.150885,
		-0.955035,
		-0.255229,
		0,
		-0.939383,
		0.218931,
		-0.263871,
		0,
		-0.309191,
		-0.233363,
		-0.40716,
		1
	},
	[0.5] = {
		-0.113339,
		0.240633,
		-0.963976,
		0,
		-0.102419,
		-0.967889,
		-0.229568,
		0,
		-0.988263,
		0.072711,
		0.134345,
		0,
		-0.369872,
		-0.240745,
		-0.213253,
		1
	},
	[0.616666666667] = {
		0.430374,
		0.193837,
		-0.881592,
		0,
		-0.188118,
		-0.935965,
		-0.297627,
		0,
		-0.882831,
		0.293934,
		-0.366351,
		0,
		-0.286308,
		-0.222309,
		-0.464742,
		1
	},
	[0.633333333333] = {
		0.486593,
		0.187816,
		-0.853201,
		0,
		-0.216678,
		-0.920158,
		-0.32613,
		0,
		-0.846332,
		0.343563,
		-0.407047,
		0,
		-0.273308,
		-0.211309,
		-0.491687,
		1
	},
	[0.65] = {
		0.54043,
		0.177299,
		-0.822496,
		0,
		-0.251262,
		-0.898932,
		-0.35887,
		0,
		-0.802996,
		0.400607,
		-0.441262,
		0,
		-0.259013,
		-0.196596,
		-0.517989,
		1
	},
	[0.666666666667] = {
		0.59138,
		0.161755,
		-0.790003,
		0,
		-0.289895,
		-0.871535,
		-0.395458,
		0,
		-0.752483,
		0.462884,
		-0.468516,
		0,
		-0.243524,
		-0.17877,
		-0.54354,
		1
	},
	[0.683333333333] = {
		0.63878,
		0.140948,
		-0.756369,
		0,
		-0.33052,
		-0.837472,
		-0.435198,
		0,
		-0.694778,
		0.527991,
		-0.488374,
		0,
		-0.226966,
		-0.158494,
		-0.568141,
		1
	},
	[0.6] = {
		0.372064,
		0.196131,
		-0.907249,
		0,
		-0.167469,
		-0.947197,
		-0.273446,
		0,
		-0.912975,
		0.253675,
		-0.319572,
		0,
		-0.297908,
		-0.229045,
		-0.437189,
		1
	},
	[0.716666666667] = {
		0.720053,
		0.084417,
		-0.688765,
		0,
		-0.409537,
		-0.749578,
		-0.520011,
		0,
		-0.560181,
		0.656511,
		-0.505164,
		0,
		-0.191484,
		-0.113527,
		-0.613344,
		1
	},
	[0.733333333333] = {
		0.752708,
		0.050089,
		-0.656446,
		0,
		-0.444232,
		-0.697255,
		-0.562577,
		0,
		-0.485889,
		0.715071,
		-0.502578,
		0,
		-0.173219,
		-0.090387,
		-0.633282,
		1
	},
	[0.75] = {
		0.779605,
		0.013235,
		-0.626131,
		0,
		-0.473816,
		-0.641305,
		-0.603512,
		0,
		-0.409528,
		0.767172,
		-0.493694,
		0,
		-0.155214,
		-0.067841,
		-0.651027,
		1
	},
	[0.766666666667] = {
		0.800814,
		-0.024707,
		-0.598403,
		0,
		-0.497477,
		-0.583787,
		-0.641646,
		0,
		-0.333486,
		0.811531,
		-0.479796,
		0,
		-0.138029,
		-0.046624,
		-0.666326,
		1
	},
	[0.783333333333] = {
		0.816752,
		-0.062201,
		-0.573626,
		0,
		-0.514949,
		-0.527046,
		-0.676055,
		0,
		-0.260276,
		0.847557,
		-0.462496,
		0,
		-0.122273,
		-0.027418,
		-0.679003,
		1
	},
	[0.7] = {
		0.681901,
		0.115,
		-0.722347,
		0,
		-0.371058,
		-0.796667,
		-0.477114,
		0,
		-0.630338,
		0.593377,
		-0.500577,
		0,
		-0.209527,
		-0.136491,
		-0.591518,
		1
	},
	[0.816666666667] = {
		0.835939,
		-0.129944,
		-0.533218,
		0,
		-0.532745,
		-0.42557,
		-0.731487,
		0,
		-0.131869,
		0.895547,
		-0.424978,
		0,
		-0.097555,
		0.002489,
		-0.696066,
		1
	},
	[0.833333333333] = {
		0.841221,
		-0.157616,
		-0.517208,
		0,
		-0.534623,
		-0.385385,
		-0.752102,
		0,
		-0.080781,
		0.909195,
		-0.408459,
		0,
		-0.08982,
		0.01204,
		-0.700354,
		1
	},
	[0.85] = {
		0.845085,
		-0.179727,
		-0.503517,
		0,
		-0.533083,
		-0.354914,
		-0.768023,
		0,
		-0.040671,
		0.917461,
		-0.395742,
		0,
		-0.085938,
		0.017236,
		-0.701775,
		1
	},
	[0.866666666667] = {
		0.847811,
		-0.196132,
		-0.492696,
		0,
		-0.53018,
		-0.333159,
		-0.779688,
		0,
		-0.011224,
		0.922246,
		-0.386441,
		0,
		-0.08429,
		0.01972,
		-0.701584,
		1
	},
	[0.883333333333] = {
		0.849383,
		-0.207639,
		-0.485216,
		0,
		-0.52769,
		-0.317424,
		-0.787899,
		0,
		0.009579,
		0.925272,
		-0.379183,
		0,
		-0.082907,
		0.021581,
		-0.7011,
		1
	},
	[0.8] = {
		0.828142,
		-0.097739,
		-0.551931,
		0,
		-0.526486,
		-0.473518,
		-0.706111,
		0,
		-0.192334,
		0.875344,
		-0.443599,
		0,
		-0.108574,
		-0.010851,
		-0.688936,
		1
	},
	[0.916666666667] = {
		0.850658,
		-0.218183,
		-0.478307,
		0,
		-0.52488,
		-0.301065,
		-0.796154,
		0,
		0.029706,
		0.928308,
		-0.370624,
		0,
		-0.080929,
		0.023737,
		-0.699463,
		1
	},
	[0.933333333333] = {
		0.850769,
		-0.218341,
		-0.478038,
		0,
		-0.524621,
		-0.299061,
		-0.797079,
		0,
		0.031073,
		0.928919,
		-0.368978,
		0,
		-0.080298,
		0.024167,
		-0.698392,
		1
	},
	[0.95] = {
		0.850643,
		-0.215833,
		-0.479398,
		0,
		-0.525002,
		-0.300302,
		-0.796361,
		0,
		0.027917,
		0.929104,
		-0.368763,
		0,
		-0.079867,
		0.024246,
		-0.697194,
		1
	},
	[0.966666666667] = {
		0.850302,
		-0.211213,
		-0.482053,
		0,
		-0.525869,
		-0.304156,
		-0.794324,
		0,
		0.021152,
		0.928912,
		-0.369695,
		0,
		-0.079603,
		0.024031,
		-0.695898,
		1
	},
	[0.983333333333] = {
		0.849756,
		-0.205034,
		-0.48567,
		0,
		-0.527047,
		-0.309995,
		-0.791281,
		0,
		0.011685,
		0.928366,
		-0.371483,
		0,
		-0.079467,
		0.02358,
		-0.694532,
		1
	},
	[0.9] = {
		0.850243,
		-0.214803,
		-0.480569,
		0,
		-0.525894,
		-0.306961,
		-0.793228,
		0,
		0.022872,
		0.927165,
		-0.373955,
		0,
		-0.081791,
		0.022896,
		-0.700378,
		1
	},
	[1.01666666667] = {
		0.848108,
		-0.190233,
		-0.494494,
		0,
		-0.529693,
		-0.325096,
		-0.783414,
		0,
		-0.011727,
		0.92635,
		-0.376482,
		0,
		-0.079439,
		0.022197,
		-0.691687,
		1
	},
	[1.03333333333] = {
		0.8471,
		-0.182732,
		-0.499029,
		0,
		-0.530899,
		-0.333065,
		-0.779239,
		0,
		-0.023817,
		0.925028,
		-0.379151,
		0,
		-0.079477,
		0.021383,
		-0.690262,
		1
	},
	[1.05] = {
		0.846084,
		-0.175918,
		-0.503185,
		0,
		-0.531906,
		-0.340434,
		-0.775358,
		0,
		-0.034902,
		0.923665,
		-0.381607,
		0,
		-0.079508,
		0.020569,
		-0.688874,
		1
	},
	[1.06666666667] = {
		0.845183,
		-0.170352,
		-0.506603,
		0,
		-0.532662,
		-0.346531,
		-0.772132,
		0,
		-0.044019,
		0.92244,
		-0.383622,
		0,
		-0.079504,
		0.019818,
		-0.687553,
		1
	},
	[1.08333333333] = {
		0.844537,
		-0.166601,
		-0.508921,
		0,
		-0.533139,
		-0.350684,
		-0.769925,
		0,
		-0.0502,
		0.921556,
		-0.384987,
		0,
		-0.079437,
		0.019195,
		-0.686329,
		1
	},
	[1.1] = {
		0.844292,
		-0.165227,
		-0.509775,
		0,
		-0.533308,
		-0.352216,
		-0.769108,
		0,
		-0.052474,
		0.921219,
		-0.38549,
		0,
		-0.07928,
		0.018762,
		-0.685233,
		1
	}
}

return spline_matrices
