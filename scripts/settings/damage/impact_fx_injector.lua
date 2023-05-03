local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_hit_types = ArmorSettings.hit_types
local armor_types = ArmorSettings.types
local _inject_armor_impact_fx, _inject_surface_impact_fx, _inject_surface_decal_fx = nil
local ImpactFxInjector = {
	inject = function (damage_type, fx_config)
		local armor_config = fx_config.armor

		if armor_config then
			_inject_armor_impact_fx(damage_type, armor_config)
		end

		local surface_config = fx_config.surface

		if surface_config then
			_inject_surface_impact_fx(damage_type, surface_config)
		end

		local surface_decal_config = fx_config.surface_decal

		if surface_decal_config then
			_inject_surface_decal_fx(damage_type, fx_config)
		end
	end
}

function _inject_armor_impact_fx(damage_type, armor_config)
	local prop_armor = armor_config[armor_types.prop_armor]

	if prop_armor then
		if prop_armor.vfx then
			for _, effects in pairs(prop_armor.vfx) do
				for i = #effects, 1, -1 do
					local empty_array = effects[i]

					for j = #empty_array, 1, -1 do
						if string.find(empty_array[j].effect, "blood") then
							table.remove(empty_array, j)
						end
					end

					if #empty_array == 0 then
						table.remove(effects, i)
					end
				end
			end
		end

		prop_armor.blood_ball = nil
		prop_armor.linked_decal = nil
	end

	local has_void_shield_overrides = armor_config[armor_types.void_shield] ~= nil

	if not has_void_shield_overrides then
		armor_config[armor_types.void_shield] = {
			sfx = {
				[armor_hit_types.damage] = {
					{
						event = "wwise/events/minions/play_traitor_captain_shield_bullet_hits",
						append_husk_to_event_name = true
					}
				},
				[armor_hit_types.damage_negated] = {
					{
						event = "wwise/events/minions/play_traitor_captain_shield_bullet_hits",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				[armor_hit_types.damage] = {
					{
						normal_rotation = true,
						effects = {
							"content/fx/particles/impacts/enemies/renegade_captain/renegade_captain_shield_impact"
						}
					}
				},
				[armor_hit_types.damage_negated] = {
					{
						normal_rotation = true,
						effects = {
							"content/fx/particles/impacts/enemies/renegade_captain/renegade_captain_shield_impact"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"void_shield\" impact fx on damage_type: %s", damage_type)
	end
end

function _inject_surface_impact_fx(damage_type, surface_config)
	return
end

function _inject_surface_decal_fx(damage_type, surface_decal_config)
	return
end

return ImpactFxInjector
