-- chunkname: @scripts/utilities/mutator/mutator_utility.lua

local MutatorSettings = require("scripts/settings/mutator/mutator_settings")
local MutatorUtility = {}

MutatorUtility.is_current_level_dark = function ()
	local mutator_manager = Managers.state.mutator

	if mutator_manager then
		for i = 1, #MutatorSettings.dark_mutators do
			if mutator_manager:mutator(MutatorSettings.dark_mutators[i]) then
				return true
			end
		end
	end

	local circumstance_manager = Managers.state.circumstance

	if circumstance_manager then
		for i = 1, #MutatorSettings.dark_themes do
			if circumstance_manager:active_theme_tag() == MutatorSettings.dark_themes[i] then
				return true
			end
		end
	end

	return false
end

MutatorUtility.is_current_level_half_dark = function ()
	local circumstance_manager = Managers.state.circumstance

	if circumstance_manager then
		for i = 1, #MutatorSettings.half_dark_themes do
			if circumstance_manager:active_theme_tag() == MutatorSettings.half_dark_themes[i] then
				return true
			end
		end
	end

	return false
end

MutatorUtility.apply_mutator_effects_to_particle = function (world, particle_id, ...)
	local is_dark = MutatorUtility.is_current_level_dark() and 1 or 0
	local is_half_dark = MutatorUtility.is_current_level_half_dark() and 1 or 0

	for i = 1, select("#", ...) do
		local cloud_name = select(i, ...)

		World.set_particles_material_scalar(world, particle_id, cloud_name, "is_night", is_dark)
		World.set_particles_material_scalar(world, particle_id, cloud_name, "is_dawn", is_half_dark)
	end
end

return MutatorUtility
