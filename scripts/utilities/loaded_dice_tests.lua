local LoadedDice = nil

local function _test_roll()
	local weights = {
		10,
		5,
		3,
		2
	}
	local weight_sum = 0

	for i = 1, #weights do
		weight_sum = weight_sum + weights[i]
	end

	local p, a = LoadedDice.create(weights, false)
	local tries = 100000
	local count = {
		0,
		0,
		0,
		0
	}

	for i = 1, tries do
		local column = LoadedDice.roll(p, a)
		count[column] = count[column] + 1
	end

	Log.debug("LoadedDice", "| Loaded Dice - Roll Test (%d rolls) |", tries)

	for i = 1, #weights do
		local weight = weights[i]

		Log.debug("LoadedDice", "Weight %d\t: Rolls %d\t(%05.2f%%) : [Wanted: %05.2f%%)]", weight, count[i], count[i] / tries * 100, weight / weight_sum * 100)
	end

	Log.debug("LoadedDice", "|----------------------------------------|")
end

local TEST_FAILED_STRING = "[LoadedDice] Test Failed, %s!"

local function _test_roll_seeded()
	local start_seed = 29291
	local weights = {
		15,
		25,
		5,
		15,
		40
	}
	local num_weights = #weights
	local normalized_weights = Script.new_array(num_weights)
	local weight_sum = 0

	for i = 1, num_weights do
		weight_sum = weight_sum + weights[i]
	end

	for i = 1, num_weights do
		normalized_weights[i] = weights[i] / weight_sum
	end

	local tries = 10
	local result = {
		3,
		5,
		2,
		5,
		2,
		5,
		5,
		2,
		4,
		2
	}
	local column = nil
	local probabilities, alias = LoadedDice.create(weights, false)
	local seed = start_seed

	for i = 1, tries do
		seed, column = LoadedDice.roll_seeded(probabilities, alias, seed)
	end

	probabilities, alias = LoadedDice.create(normalized_weights, true)
	seed = start_seed

	for i = 1, tries do
		seed, column = LoadedDice.roll_seeded(probabilities, alias, seed)
	end
end

local function _init_and_run_tests(dice_object)
	LoadedDice = dice_object
	LoadedDice.test_roll = _test_roll

	_test_roll_seeded()
end

return _init_and_run_tests
