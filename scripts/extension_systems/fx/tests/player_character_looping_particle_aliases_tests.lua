-- chunkname: @scripts/extension_systems/fx/tests/player_character_looping_particle_aliases_tests.lua

local PlayerCharacterLoopingParticleAliases = require("scripts/settings/particles/player_character_looping_particle_aliases")
local PlayerCharacterParticles = require("scripts/settings/particles/player_character_particles")
local known_variable_types = {
	emit_rate_multiplier = true,
	material_scalar = true,
	particle_variable = true,
}

local function tests()
	for name, config in pairs(PlayerCharacterLoopingParticleAliases) do
		local particle_alias = config.particle_alias
		local variables = config.variables

		if variables then
			local num_variables = #variables

			for i = 1, num_variables do
				local variable_config = variables[i]
				local variable_name = variable_config.variable_name
				local variable_type = variable_config.variable_type
				local func = variable_config.func

				if variable_type == "material_scalar" then
					local cloud_name = variable_config.cloud_name
				end
			end
		end
	end
end

return tests
