local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local BreedUnitTester = class("BreedUnitTester")
local REFERENCE_NAME = "BreedUnitTester"

BreedUnitTester.init = function (self, package_manager, use_time_slice)
	Log.info("BreedUnitTester", "INITIALIZATING UNIT BREED TESTER!")

	local breed_units_test = require("scripts/settings/breed/breed_units_test")
	local resource_dependencies = breed_units_test.resource_dependencies()
	self._load_ids = {}
	self._resource_dependencies = resource_dependencies
	self._test_function = breed_units_test.test_function
	self._package_manager = package_manager
	self._finished = false

	if use_time_slice then
		local resource_list = {}

		for package_name, _ in pairs(resource_dependencies) do
			resource_list[#resource_list + 1] = package_name
		end

		local init_data = {
			last_index = 0,
			ready = false,
			parameters = {}
		}
		init_data.parameters.resource_list = resource_list
		self._init_data = init_data
	else
		local callback = nil

		for package_name, _ in pairs(resource_dependencies) do
			local id = package_manager:load(package_name, REFERENCE_NAME, callback)

			table.insert(self._load_ids, id)
		end
	end
end

BreedUnitTester.destroy = function (self)
	local package_manager = self._package_manager

	for i = 1, #self._load_ids do
		package_manager:release(self._load_ids[i])
	end

	self._package_manager = nil
	self._test_function = nil
	self._resource_dependencies = nil
end

BreedUnitTester.update_time_slice_package_load = function (self)
	local init_data = self._init_data

	if init_data.ready then
		return init_data.ready
	end

	local last_index = init_data.last_index
	local resource_list = init_data.parameters.resource_list
	local num_resources = #resource_list
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()
	local callback = nil
	local package_manager = self._package_manager

	for index = last_index + 1, num_resources do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local package_name = resource_list[index]
		local id = package_manager:load(package_name, REFERENCE_NAME, callback)

		table.insert(self._load_ids, id)

		init_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if init_data.last_index == num_resources then
		GameplayInitTimeSlice.set_finished(init_data)
	end

	return init_data.ready
end

BreedUnitTester.update = function (self)
	if self._finished then
		return true
	end

	local package_manager = self._package_manager
	local all_packages_loaded = true

	for i = 1, #self._load_ids do
		if not package_manager:has_loaded_id(self._load_ids[i]) then
			all_packages_loaded = false

			break
		end
	end

	if not all_packages_loaded then
		return false
	end

	self._test_function()

	self._finished = true

	return true
end

return BreedUnitTester
