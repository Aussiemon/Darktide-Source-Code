local ArchetypeResourceDependencies = {}
local _resolve_data_recursive, _is_valid_wwise_resource_name, _is_valid_fx_resource_name = nil
local TEMP_SOUND_RESOURCE_PACKAGES = {}
local TEMP_PARTICLE_RESOURCE_PACKAGES = {}

ArchetypeResourceDependencies.generate = function (archetype)
	local sound_resource_packages = {}
	local particle_resource_packages = {}

	_resolve_data_recursive(archetype, TEMP_SOUND_RESOURCE_PACKAGES, _is_valid_wwise_resource_name)
	_resolve_data_recursive(archetype, TEMP_PARTICLE_RESOURCE_PACKAGES, _is_valid_fx_resource_name)

	for resource_name, _ in pairs(TEMP_SOUND_RESOURCE_PACKAGES) do
		TEMP_SOUND_RESOURCE_PACKAGES[resource_name] = nil
		sound_resource_packages[#sound_resource_packages + 1] = resource_name
	end

	for resource_name, _ in pairs(TEMP_PARTICLE_RESOURCE_PACKAGES) do
		TEMP_PARTICLE_RESOURCE_PACKAGES[resource_name] = nil
		particle_resource_packages[#particle_resource_packages + 1] = resource_name
	end

	return sound_resource_packages, particle_resource_packages
end

local WWISE_START_STRING_PLAYER = "wwise/events/player/"

function _is_valid_wwise_resource_name(value)
	return string.starts_with(value, WWISE_START_STRING_PLAYER)
end

local CONTENT_FX = "content/fx/particles/screenspace"

function _is_valid_fx_resource_name(value)
	return string.starts_with(value, CONTENT_FX)
end

local WWISE_START_STRING = "wwise/"

function _resolve_data_recursive(data, resource_packages, validation_func)
	for _, value in pairs(data) do
		local value_type = type(value)

		if value_type == "string" then
			if validation_func(value) then
				resource_packages[value] = true

				if string.starts_with(value, WWISE_START_STRING) then
					local husk_event = string.format("%s_husk", value)

					if Application.can_get_resource("package", husk_event) then
						resource_packages[husk_event] = true
					end
				end
			end
		elseif value_type == "table" then
			local is_class = rawget(value, "__class_name") ~= nil

			if not is_class then
				_resolve_data_recursive(value, resource_packages, validation_func)
			end
		end
	end
end

return ArchetypeResourceDependencies
