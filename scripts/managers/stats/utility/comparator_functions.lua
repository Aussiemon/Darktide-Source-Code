local ComparatorFunctions = {
	greater_than = function (left_hand, right_hand)
		return right_hand < left_hand
	end,
	equals = function (left_hand, right_hand)
		return left_hand == right_hand
	end
}

return ComparatorFunctions
