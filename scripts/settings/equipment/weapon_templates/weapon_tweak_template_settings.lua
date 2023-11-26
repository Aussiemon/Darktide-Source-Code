-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings.lua

local WeaponTweakTemplateSettings = {}

WeaponTweakTemplateSettings.template_types = table.enum("recoil", "sway", "spread", "suppression", "dodge", "sprint", "stamina", "toughness", "damage", "weapon_handling", "explosion", "ammo", "burninating", "size_of_flame", "movement_curve_modifier", "charge", "warp_charge")
WeaponTweakTemplateSettings.ALL_WEAPON_MOVEMENT_STATES = {}
WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE = {}
WeaponTweakTemplateSettings.DEFAULT_STAT_TRAIT_VALUE = 0.5
WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE = 0.5

local buff_targets = table.enum("on_equip", "on_wield", "on_unwield")

WeaponTweakTemplateSettings.buff_targets = buff_targets

local num_buffs_per_target = 3
local buff_target_component_lookups = {}

for buff_target, _ in pairs(buff_targets) do
	local lookup = {}

	buff_target_component_lookups[buff_target] = lookup

	for i = 1, num_buffs_per_target do
		lookup[i] = string.format("%s_%i", buff_target, i)
	end
end

WeaponTweakTemplateSettings.buff_target_component_lookups = buff_target_component_lookups

return settings("WeaponTweakTemplateSettings", WeaponTweakTemplateSettings)
