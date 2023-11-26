-- chunkname: @scripts/extension_systems/ability/utilities/equipped_ability_effect_scripts.lua

require("scripts/extension_systems/ability/equipped_ability_effect_scripts/lunge_effects")
require("scripts/extension_systems/ability/equipped_ability_effect_scripts/shout_effects")
require("scripts/extension_systems/ability/equipped_ability_effect_scripts/stealth_effects")
require("scripts/extension_systems/ability/equipped_ability_effect_scripts/targeted_dash_effects")

local EquippedAbilityEffectScripts = {}

EquippedAbilityEffectScripts.create = function (equipped_ability_effect_scripts_context, equipped_ability_effect_scripts, ability_template, ability_type)
	local ability_effect_scripts = ability_template.equipped_ability_effect_scripts

	if not ability_effect_scripts then
		return
	end

	local num_scripts = #ability_effect_scripts

	for i = 1, num_scripts do
		local script_name = ability_effect_scripts[i]
		local script_class = CLASSES[script_name]

		if script_class then
			local script = script_class:new(equipped_ability_effect_scripts_context, ability_template)

			equipped_ability_effect_scripts[i] = script
		end
	end
end

EquippedAbilityEffectScripts.extensions_ready = function (equipped_ability_effect_scripts, world, unit)
	local num_scripts = #equipped_ability_effect_scripts

	for i = 1, num_scripts do
		local equipped_ability_effect_script = equipped_ability_effect_scripts[i]

		if equipped_ability_effect_script.extensions_ready then
			equipped_ability_effect_script:extensions_ready(world, unit)
		end
	end
end

EquippedAbilityEffectScripts.destroy = function (equipped_ability_effect_scripts)
	local num_scripts = #equipped_ability_effect_scripts

	for i = 1, num_scripts do
		local equipped_ability_effect_script = equipped_ability_effect_scripts[i]

		equipped_ability_effect_script:destroy()
	end
end

EquippedAbilityEffectScripts.update = function (equipped_ability_effect_scripts, unit, dt, t)
	local num_scripts = #equipped_ability_effect_scripts

	for i = 1, num_scripts do
		local equipped_ability_effect_script = equipped_ability_effect_scripts[i]

		if equipped_ability_effect_script.update then
			equipped_ability_effect_script:update(unit, dt, t)
		end
	end
end

EquippedAbilityEffectScripts.fixed_update = function (equipped_ability_effect_scripts, unit, dt, t)
	local num_scripts = #equipped_ability_effect_scripts

	for i = 1, num_scripts do
		local equipped_ability_effect_script = equipped_ability_effect_scripts[i]

		if equipped_ability_effect_script.fixed_update then
			equipped_ability_effect_script:fixed_update(unit, dt, t)
		end
	end
end

EquippedAbilityEffectScripts.post_update = function (equipped_ability_effect_scripts, unit, dt, t)
	local num_scripts = #equipped_ability_effect_scripts

	for i = 1, num_scripts do
		local equipped_ability_effect_script = equipped_ability_effect_scripts[i]

		if equipped_ability_effect_script.post_update then
			equipped_ability_effect_script:post_update(unit, dt, t)
		end
	end
end

return EquippedAbilityEffectScripts
