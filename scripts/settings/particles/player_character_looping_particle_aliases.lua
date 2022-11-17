local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local armor_types = ArmorSettings.types
local armor_types_array = {}

for armor_type, _ in pairs(armor_types) do
	armor_types_array[#armor_types_array + 1] = armor_type
end

local PlayerCharacterLoopingParticleAliases = {
	melee_sticky_loop = {
		exclude_from_unit_data_components = true,
		particle_alias = "melee_sticky_loop",
		external_properties = {
			armor_type = armor_types_array
		}
	},
	ranged_charging = {
		particle_alias = "ranged_charging",
		external_properties = {},
		variables = {
			{
				variable_name = "charge_level",
				variable_type = "particle_variable",
				func = function (context)
					local action_module_charge_component = context.action_module_charge_component
					local charge_level = action_module_charge_component.charge_level

					return charge_level, charge_level, charge_level
				end
			}
		}
	},
	weapon_overload_loop = {
		exclude_from_unit_data_components = true,
		particle_alias = "weapon_overload_loop",
		external_properties = {}
	},
	plasma_venting = {
		particle_alias = "plasma_venting",
		external_properties = {}
	},
	psyker_smite_buildup = {
		particle_alias = "psyker_smite_buildup",
		external_properties = {}
	},
	psyker_biomancer_soul = {
		particle_alias = "psyker_biomancer_soul",
		external_properties = {},
		variables = {
			{
				variable_name = "intensity",
				variable_type = "emit_rate_multiplier",
				func = function (context)
					local specialization_resource_component = context.specialization_resource_component
					local max_souls = specialization_resource_component.max_resource

					if max_souls > 0 then
						local current_souls = specialization_resource_component.current_resource
						local value = current_souls / max_souls
						local multiplier = current_souls > 1 and 1 or 1.5

						return value * multiplier
					end

					return 0
				end
			}
		}
	},
	preacher_shield = {
		particle_alias = "preacher_shield",
		external_properties = {}
	},
	weapon_special_loop = {
		exclude_from_unit_data_components = true,
		particle_alias = "weapon_special_loop",
		external_properties = {}
	},
	critical_health_loop = {
		particle_alias = "critical_health",
		screen_space = true,
		external_properties = {},
		variables = {
			{
				variable_name = "material_variable_d4e3dd67",
				cloud_name = "cloud_2",
				variable_type = "material_scalar",
				func = function (context)
					local health_extension = context.health_extension
					local toughness_extension = context.toughness_extension
					local _, critical_health_status = PlayerUnitStatus.is_in_critical_health(health_extension, toughness_extension)
					local scalar = math.ease_exp(critical_health_status)

					return scalar
				end
			}
		}
	},
	equipped_item_passive_loop = {
		exclude_from_unit_data_components = true,
		particle_alias = "equipped_item_passive",
		external_properties = {}
	}
}

return PlayerCharacterLoopingParticleAliases
