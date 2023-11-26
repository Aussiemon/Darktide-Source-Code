-- chunkname: @scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_functions.lua

local true_flight_functions = {}

local function _extract_true_flight_functions(path)
	local extracted_functions = require(path)

	for name, extracted_function in pairs(extracted_functions) do
		true_flight_functions[name] = extracted_function
	end
end

_extract_true_flight_functions("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
_extract_true_flight_functions("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_smite")
_extract_true_flight_functions("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_krak_grenade")
_extract_true_flight_functions("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_throwing_knives")

return settings("TrueFlightFunctions", true_flight_functions)
