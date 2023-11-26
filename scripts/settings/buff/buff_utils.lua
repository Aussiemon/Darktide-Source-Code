-- chunkname: @scripts/settings/buff/buff_utils.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local BuffUtils = {}

BuffUtils.instakill_with_buff = function (attacked_unit, attacking_unit, damage_type)
	if not HEALTH_ALIVE[attacked_unit] then
		return true
	end

	local unit_data = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local target_breed = unit_data and unit_data:breed()

	if target_breed then
		local is_boss = target_breed.is_boss
		local is_super_armored = target_breed.armor_type == armor_types.super_armor
		local is_resistant = target_breed.armor_type == armor_types.resistant
		local ignore_instakill = target_breed.ignore_instakill

		if is_boss or is_super_armored or is_resistant or ignore_instakill then
			return false
		end
	end

	Attack.execute(attacked_unit, DamageProfileTemplates.buff_instakill, "attacking_unit", attacking_unit, "damage_type", damage_type, "instakill", true)

	return true
end

return BuffUtils
