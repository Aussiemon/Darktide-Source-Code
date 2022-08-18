local spline_matrices = {
	[0] = {
		0.972015,
		-0.233887,
		0.021986,
		0,
		0.050738,
		0.117633,
		-0.99176,
		0,
		0.229374,
		0.965121,
		0.126208,
		0,
		0.807086,
		-0.047223,
		-1.370142,
		1
	},
	[0.0333333333333] = {
		0.963932,
		-0.195533,
		-0.180563,
		0,
		-0.02085,
		0.620862,
		-0.783643,
		0,
		0.265332,
		0.759143,
		0.594391,
		0,
		0.802584,
		-0.027114,
		-1.028511,
		1
	},
	[0.0666666666667] = {
		0.942996,
		-0.08095,
		-0.322808,
		0,
		-0.059886,
		0.91286,
		-0.403857,
		0,
		0.327371,
		0.400167,
		0.855976,
		0,
		0.806476,
		-0.083274,
		-0.350948,
		1
	},
	[0.133333333333] = {
		0.893524,
		0.222388,
		-0.390076,
		0,
		-0.060878,
		0.920713,
		0.385462,
		0,
		0.44487,
		-0.320672,
		0.836218,
		0,
		0.783043,
		0.250172,
		0.588947,
		1
	},
	[0.166666666667] = {
		0.86785,
		0.327598,
		-0.373517,
		0,
		-0.035956,
		0.791251,
		0.610433,
		0,
		0.495523,
		-0.516334,
		0.698467,
		0,
		0.722473,
		0.639775,
		0.848359,
		1
	},
	[0.1] = {
		0.91891,
		0.073758,
		-0.38751,
		0,
		-0.063911,
		0.997222,
		0.038257,
		0,
		0.389256,
		-0.010389,
		0.921071,
		0,
		0.806518,
		-0.051325,
		0.164499,
		1
	},
	[0.233333333333] = {
		0.769512,
		0.20308,
		-0.605483,
		0,
		-0.209887,
		0.975849,
		0.060555,
		0,
		0.603157,
		0.080485,
		0.793551,
		0,
		0.286858,
		1.403209,
		0.285689,
		1
	},
	[0.266666666667] = {
		0.848165,
		0.042894,
		-0.527993,
		0,
		-0.388189,
		0.728535,
		-0.564399,
		0,
		0.360452,
		0.683664,
		0.634569,
		0,
		-0.121097,
		1.436981,
		-0.262062,
		1
	},
	[0.2] = {
		0.818694,
		0.324621,
		-0.473669,
		0,
		-0.076568,
		0.879222,
		0.470219,
		0,
		0.569103,
		-0.348698,
		0.744669,
		0,
		0.587649,
		1.071076,
		0.683687,
		1
	},
	[0.333333333333] = {
		0.651026,
		0.307492,
		-0.693984,
		0,
		-0.505447,
		-0.506479,
		-0.698572,
		0,
		-0.566293,
		0.805561,
		-0.17431,
		0,
		-0.372282,
		0.195555,
		-1.232966,
		1
	},
	[0.366666666667] = {
		0.511609,
		0.406606,
		-0.75692,
		0,
		-0.330912,
		-0.719743,
		-0.610301,
		0,
		-0.79294,
		0.56271,
		-0.233676,
		0,
		-0.174053,
		-0.15407,
		-1.407296,
		1
	},
	[0.3] = {
		0.805622,
		0.092476,
		-0.585168,
		0,
		-0.590264,
		0.040904,
		-0.806173,
		0,
		-0.050616,
		0.994874,
		0.087539,
		0,
		-0.47421,
		0.942533,
		-0.824571,
		1
	},
	[0.433333333333] = {
		0.992017,
		-0.116042,
		-0.049362,
		0,
		-0.047401,
		0.019594,
		-0.998684,
		0,
		0.116857,
		0.993051,
		0.013937,
		0,
		0.235562,
		-0.33681,
		-1.176251,
		1
	},
	[0.466666666667] = {
		0.936996,
		-0.337291,
		0.090952,
		0,
		0.163651,
		0.193786,
		-0.967298,
		0,
		0.308636,
		0.921239,
		0.236775,
		0,
		0.321606,
		-0.322309,
		-1.121676,
		1
	},
	[0.4] = {
		0.832883,
		0.305879,
		-0.461241,
		0,
		-0.334211,
		-0.386314,
		-0.859689,
		0,
		-0.441145,
		0.870172,
		-0.219527,
		0,
		0.011302,
		-0.317681,
		-1.319013,
		1
	},
	[0.533333333333] = {
		0.900492,
		-0.422874,
		0.101446,
		0,
		0.20586,
		0.20903,
		-0.955996,
		0,
		0.383061,
		0.881751,
		0.275282,
		0,
		0.335033,
		-0.316765,
		-1.116031,
		1
	},
	[0.566666666667] = {
		0.912607,
		-0.398908,
		0.089553,
		0,
		0.181224,
		0.198359,
		-0.96323,
		0,
		0.366477,
		0.89528,
		0.253316,
		0,
		0.331506,
		-0.320759,
		-1.115966,
		1
	},
	[0.5] = {
		0.900598,
		-0.419907,
		0.112254,
		0,
		0.21718,
		0.211018,
		-0.95305,
		0,
		0.376505,
		0.882694,
		0.281238,
		0,
		0.338615,
		-0.319019,
		-1.117517,
		1
	},
	[0.633333333333] = {
		0.948142,
		-0.31238,
		0.058698,
		0,
		0.113302,
		0.159625,
		-0.980654,
		0,
		0.296967,
		0.93645,
		0.186741,
		0,
		0.315842,
		-0.333769,
		-1.117955,
		1
	},
	[0.666666666667] = {
		0.962714,
		-0.267508,
		0.040266,
		0,
		0.079368,
		0.137007,
		-0.987385,
		0,
		0.258616,
		0.953766,
		0.15313,
		0,
		0.307253,
		-0.34099,
		-1.118744,
		1
	},
	[0.6] = {
		0.930419,
		-0.358641,
		0.075478,
		0,
		0.14864,
		0.181013,
		-0.972183,
		0,
		0.335002,
		0.915757,
		0.221726,
		0,
		0.324684,
		-0.326754,
		-1.116775,
		1
	},
	[0.733333333333] = {
		0.972015,
		-0.233887,
		0.021986,
		0,
		0.050738,
		0.117633,
		-0.99176,
		0,
		0.229374,
		0.965121,
		0.126208,
		0,
		0.300182,
		-0.346942,
		-1.11897,
		1
	},
	[0.766666666667] = {
		0.972015,
		-0.233887,
		0.021986,
		0,
		0.050738,
		0.117633,
		-0.99176,
		0,
		0.229374,
		0.965121,
		0.126208,
		0,
		0.300182,
		-0.346942,
		-1.11897,
		1
	},
	[0.7] = {
		0.972015,
		-0.233887,
		0.02199,
		0,
		0.050738,
		0.11762,
		-0.991762,
		0,
		0.229374,
		0.965123,
		0.126195,
		0,
		0.300182,
		-0.346958,
		-1.118965,
		1
	}
}

return spline_matrices
