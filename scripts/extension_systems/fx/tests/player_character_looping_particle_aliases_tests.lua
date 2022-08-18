local PlayerCharacterLoopingParticleAliases = require("scripts/settings/particles/player_character_looping_particle_aliases")
local PlayerCharacterParticles = require("scripts/settings/particles/player_character_particles")
local known_variable_types = {
	material_scalar = true,
	particle_variable = true,
	emit_rate_multiplier = true
}

local function tests()
	for name, config in pairs(PlayerCharacterLoopingParticleAliases) do
		local particle_alias = config.particle_alias

		fassert(PlayerCharacterParticles, "PlayerCharacterLoopingParticleAliases[%q] particle_alias %q does not exist in PlayerCharacterLoopingParticleAliases.", name, particle_alias)

		local variables = config.variables

		if variables then
			local num_variables = #variables

			for i = 1, num_variables do
				local variable_config = variables[i]
				local variable_name = variable_config.variable_name

				fassert(variable_name, "PlayerCharacterLoopingParticleAliases[%q] variables[%i] missing variable_name.", name, i)

				local variable_type = variable_config.variable_type

				fassert(known_variable_types[variable_type], "PlayerCharacterLoopingParticleAliases[%q] variables[%i] unknown variable_type %q", name, i, variable_type)

				local func = variable_config.func

				fassert(func, "PlayerCharacterLoopingParticleAliases[%q] variables[%i] missing func.", name, i)

				if variable_type == "material_scalar" then
					local cloud_name = variable_config.cloud_name

					fassert(cloud_name, "PlayerCharacterLoopingParticleAliases[%q] variables[%i] missing cloud_name.", name, i)
				end
			end
		end
	end
end

return tests
