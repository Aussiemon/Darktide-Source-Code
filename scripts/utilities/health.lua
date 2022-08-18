local Breed = require("scripts/utilities/breed")
local Health = {}

Health.is_ragdolled = function (unit)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension and unit_data_extension:is_owned_by_death_manager() then
		return true
	end

	return false
end

Health.add = function (unit, amount_to_add, heal_type)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return 0
	end

	local actual_health_added = health_extension:add_heal(amount_to_add, heal_type)

	fassert(actual_health_added, "Did not receive how much health was actually added.")

	return actual_health_added
end

Health.play_fx = function (unit)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension then
		local breed = unit_data_extension:breed()

		if Breed.is_player(breed) then
			local fx_extension = ScriptUnit.extension(unit, "fx_system")

			fx_extension:spawn_exclusive_particle("content/fx/particles/screenspace/player_heal_tick", Vector3(0, 0, 1))
			fx_extension:trigger_exclusive_wwise_event("wwise/events/ui/play_hud_heal_2d")
		end
	end
end

Health.current_health_percent = function (unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return 0
	end

	local current_health_percent = health_extension:current_health_percent()

	return current_health_percent
end

Health.damage_taken = function (unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return 0
	end

	local damage_taken = health_extension:damage_taken()

	return damage_taken
end

Health.permanent_damage_taken_percent = function (unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return 0
	end

	local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()

	return permanent_damage_taken_percent
end

Health.is_damagable = function (unit)
	return not not ScriptUnit.has_extension(unit, "health_system")
end

return Health
