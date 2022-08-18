local LoadedDice = {}
local temp_small_probabilities = {}
local temp_large_probabilities = {}

local function create_normalized_probabilities(probabilities, num_probabilities)
	local normalized_probabilities = Script.new_array(num_probabilities)
	local sum = 0

	for i = 1, num_probabilities, 1 do
		sum = sum + probabilities[i]
	end

	for i = 1, num_probabilities, 1 do
		normalized_probabilities[i] = probabilities[i] / sum
	end

	return normalized_probabilities
end

LoadedDice.create = function (probabilities, normalized)
	local result_probabilities = nil
	local num_probabilities = #probabilities

	if normalized then
		result_probabilities = table.clone(probabilities)
	else
		result_probabilities = create_normalized_probabilities(probabilities, num_probabilities)
	end

	local small = temp_small_probabilities
	local large = temp_large_probabilities

	table.clear(small)
	table.clear(large)

	local average = 1 / num_probabilities

	for i = 1, num_probabilities, 1 do
		if average <= result_probabilities[i] then
			large[#large + 1] = i
		else
			small[#small + 1] = i
		end
	end

	local alias = {}

	while next(small) ~= nil and next(large) ~= nil do
		local less = small[#small]
		small[#small] = nil
		local more = large[#large]
		large[#large] = nil
		alias[less] = more
		result_probabilities[more] = (result_probabilities[more] + result_probabilities[less]) - average

		if average <= result_probabilities[more] then
			large[#large + 1] = more
		else
			small[#small + 1] = more
		end
	end

	while next(small) ~= nil do
		result_probabilities[small[#small]] = average
		small[#small] = nil
	end

	while next(large) ~= nil do
		result_probabilities[large[#large]] = average
		large[#large] = nil
	end

	for i = 1, num_probabilities, 1 do
		result_probabilities[i] = result_probabilities[i] * num_probabilities
	end

	return result_probabilities, alias
end

LoadedDice.roll = function (probabilities, alias)
	local column = math.random(1, #probabilities)
	local biased_coin_toss = math.random() < probabilities[column]

	return (biased_coin_toss and column) or alias[column]
end

LoadedDice.roll_seeded = function (probabilities, alias, seed)
	local seed, column = math.next_random(seed, 1, #probabilities)
	local seed, random_value = math.next_random(seed)
	local biased_coin_toss = random_value < probabilities[column]

	return seed, (biased_coin_toss and column) or alias[column]
end

return LoadedDice
