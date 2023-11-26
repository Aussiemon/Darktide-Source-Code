-- chunkname: @scripts/extension_systems/dialogue/utils/varargs.lua

unpack_index = {}
unpack_index[0] = function ()
	return
end
unpack_index[1] = function (array, index)
	return array[index]
end
unpack_index[2] = function (array, index)
	return array[index], array[index + 1]
end
unpack_index[3] = function (array, index)
	return array[index], array[index + 1], array[index + 2]
end
unpack_index[4] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3]
end
unpack_index[5] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4]
end
unpack_index[6] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5]
end
unpack_index[7] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6]
end
unpack_index[8] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7]
end
unpack_index[9] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8]
end
unpack_index[10] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9]
end
unpack_index[11] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10]
end
unpack_index[12] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11]
end
unpack_index[13] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12]
end
unpack_index[14] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13]
end
unpack_index[15] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14]
end
unpack_index[16] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15]
end
unpack_index[17] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16]
end
unpack_index[18] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17]
end
unpack_index[19] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17], array[index + 18]
end
unpack_index[20] = function (array, index)
	return array[index], array[index + 1], array[index + 2], array[index + 3], array[index + 4], array[index + 5], array[index + 6], array[index + 7], array[index + 8], array[index + 9], array[index + 10], array[index + 11], array[index + 12], array[index + 13], array[index + 14], array[index + 15], array[index + 16], array[index + 17], array[index + 18], array[index + 19]
end
pack_index = {}
pack_index[0] = function ()
	return
end
pack_index[1] = function (array, index, a1)
	array[index] = a1
end
pack_index[2] = function (array, index, a1, a2)
	array[index] = a1
	array[index + 1] = a2
end
pack_index[3] = function (array, index, a1, a2, a3)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
end
pack_index[4] = function (array, index, a1, a2, a3, a4)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
end
pack_index[5] = function (array, index, a1, a2, a3, a4, a5)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
	array[index + 4] = a5
end
pack_index[6] = function (array, index, a1, a2, a3, a4, a5, a6)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
	array[index + 4] = a5
	array[index + 5] = a6
end
pack_index[7] = function (array, index, a1, a2, a3, a4, a5, a6, a7)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
	array[index + 4] = a5
	array[index + 5] = a6
	array[index + 6] = a7
end
pack_index[8] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
	array[index + 4] = a5
	array[index + 5] = a6
	array[index + 6] = a7
	array[index + 7] = a8
end
pack_index[9] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	array[index] = a1
	array[index + 1] = a2
	array[index + 2] = a3
	array[index + 3] = a4
	array[index + 4] = a5
	array[index + 5] = a6
	array[index + 6] = a7
	array[index + 7] = a8
	array[index + 8] = a9
end
pack_index[10] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
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
end
pack_index[11] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
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
end
pack_index[12] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
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
end
pack_index[13] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
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
end
pack_index[14] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
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
end
pack_index[15] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
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
end
pack_index[16] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
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
end
pack_index[17] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
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
end
pack_index[18] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)
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
end
pack_index[19] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19)
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
end
pack_index[20] = function (array, index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
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
