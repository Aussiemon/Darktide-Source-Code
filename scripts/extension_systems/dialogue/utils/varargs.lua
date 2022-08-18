unpack_index = {
	[0] = function ()
		return
	end,
	function (array, index)
		return array[index]
	end,
	function (array, index)
		return array[index], array[index + 1]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17], array[index + 18]
	end,
	function (array, index)
		return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17], array[index + 18], array[index + 19]
	end
}
pack_index = {
	[0] = function ()
		return
	end,
	function (array, index, a1)
		array[index] = a1
	end,
	function (array, index, a1, a2)
		array[index] = a1
		array[index + 1] = a2
	end,
	function (array, index, a1, a2, a3)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
	end,
	function (array, index, a1, a2, a3, a4)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
	end,
	function (array, index, a1, a2, a3, a4, a5)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
	end,
	function (array, index, a1, a2, a3, a4, a5, a6)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
		array[index + 15] = a16
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
		array[index + 15] = a16
		array[index + 16] = a17
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
		array[index + 15] = a16
		array[index + 16] = a17
		array[index + 17] = a18
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
		array[index + 15] = a16
		array[index + 16] = a17
		array[index + 17] = a18
		array[index + 18] = a19
	end,
	function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
		array[index] = a1
		array[index + 1] = a2
		array[index + 2] = a3
		array[index + 3] = a4
		array[index + 4] = a5
		array[index + 5] = a6
		array[index + 6] = a7
		array[index + 7] = a8
		array[index + 8] = a9
		array[index + 9] = a10
		array[index + 10] = a11
		array[index + 11] = a12
		array[index + 12] = a13
		array[index + 13] = a14
		array[index + 14] = a15
		array[index + 15] = a16
		array[index + 16] = a17
		array[index + 17] = a18
		array[index + 18] = a19
		array[index + 19] = a20
	end
}

return
