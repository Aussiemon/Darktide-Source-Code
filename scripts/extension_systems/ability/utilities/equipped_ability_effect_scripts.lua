require("scripts/extension_systems/ability/utilities/targeted_dash_effects")
require("scripts/extension_systems/ability/utilities/shout_effects")

local EquippedAbilityEffectScripts = {
	create = function (equiped_ability_effect_scripts_context, equiped_ability_effect_scripts, ability_template, ability_type)
		local ability_effect_scripts = ability_template.equiped_ability_effect_scripts

		if not ability_effect_scripts then
			return
		end

		local num_scripts = #ability_effect_scripts

		for i = 1, num_scripts, 1 do
			local script_name = ability_effect_scripts[i]
			local script_class = CLASSES[script_name]

			if script_class then
				local script = script_class:new(equiped_ability_effect_scripts_context, ability_template)

				fassert(equiped_ability_effect_scripts[i] == nil, "Trying to overwrite already create equiped ability effect script on index %d with %q on %q", i, script_name, ability_template.name)

				equiped_ability_effect_scripts[i] = script
			end
		end
	end,
	destroy = function (equiped_ability_effect_scripts)
		local num_scripts = #equiped_ability_effect_scripts

		for i = 1, num_scripts, 1 do
			local equiped_ability_effect_script = equiped_ability_effect_scripts[i]

			equiped_ability_effect_script:destroy()
		end
	end,
	update = function (equiped_ability_effect_scripts, unit, dt, t)
		local num_scripts = #equiped_ability_effect_scripts

		for i = 1, num_scripts, 1 do
			local equiped_ability_effect_script = equiped_ability_effect_scripts[i]

			if equiped_ability_effect_script.update then
				equiped_ability_effect_script:update(unit, dt, t)
			end
		end
	end,
	fixed_update = function (equiped_ability_effect_scripts, unit, dt, t)
		local num_scripts = #equiped_ability_effect_scripts

		for i = 1, num_scripts, 1 do
			local equiped_ability_effect_script = equiped_ability_effect_scripts[i]

			if equiped_ability_effect_script.fixed_update then
				equiped_ability_effect_script:fixed_update(unit, dt, t)
			end
		end
	end,
	post_update = function (equiped_ability_effect_scripts, unit, dt, t)
		local num_scripts = #equiped_ability_effect_scripts

		for i = 1, num_scripts, 1 do
			local equiped_ability_effect_script = equiped_ability_effect_scripts[i]

			if equiped_ability_effect_script.post_update then
				equiped_ability_effect_script:post_update(unit, dt, t)
			end
		end
	end
}

return EquippedAbilityEffectScripts
