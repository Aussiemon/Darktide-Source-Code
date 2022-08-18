require("scripts/extension_systems/weapon/special_classes/weapon_special_activated_cooldown")
require("scripts/extension_systems/weapon/special_classes/weapon_special_deactivate_after_duration")
require("scripts/extension_systems/weapon/special_classes/weapon_special_deactivate_after_hit")
require("scripts/extension_systems/weapon/special_classes/weapon_special_deactivate_after_num_activations")
require("scripts/extension_systems/weapon/special_classes/weapon_special_explode_on_impact")
require("scripts/extension_systems/weapon/special_classes/weapon_special_deactivate_after_num_hits")
require("scripts/extension_systems/weapon/special_classes/weapon_special_hold_activated")
require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
require("scripts/extension_systems/weapon/special_classes/weapon_special_self_disorientation")
require("scripts/extension_systems/weapon/special_classes/weapon_special_warp_charged_attacks")

local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponTweakTemplates = require("scripts/extension_systems/weapon/utilities/weapon_tweak_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local EMPTY_TABLE = {}
local Weapon = class("Weapon")

Weapon.init = function (self, init_data)
	self.fx_sources = init_data.fx_sources
	self.weapon_template = init_data.weapon_template
	self.weapon_unit = init_data.optional_weapon_unit
	self.item = init_data.item
	self.inventory_slot_component = init_data.inventory_slot_component
	self.special_implementation = self:_init_weapon_special_implementation(self.weapon_template, init_data.weapon_special_context)
	local optional_trait_lerp_value_override = init_data.optional_trait_lerp_value_override
	local optional_tweak_template_lerp_value_override = init_data.optional_tweak_template_lerp_value_override
	local optional_weapon_trait_overrides = init_data.weapon_trait_overrides or {}
	local weapon_tweak_templates, damage_profile_lerp_values, explosion_template_lerp_values, buffs = self:_init_traits(self.weapon_template, self.item, optional_trait_lerp_value_override, optional_tweak_template_lerp_value_override, optional_weapon_trait_overrides)
	self.weapon_tweak_templates = weapon_tweak_templates
	self.damage_profile_lerp_values = damage_profile_lerp_values
	self.explosion_template_lerp_values = explosion_template_lerp_values
	self.buffs = buffs
	self.actions = {}
end

Weapon.destroy = function (self)
	return
end

Weapon._init_weapon_special_implementation = function (self, weapon_template, weapon_special_context)
	local weapon_special_class = weapon_template.weapon_special_class

	if not weapon_special_class then
		return nil
	end

	local weapon_special_init_data = {
		inventory_slot_component = self.inventory_slot_component,
		tweak_data = weapon_template.weapon_special_tweak_data or EMPTY_TABLE,
		weapon_template = weapon_template
	}
	local special_implementation = CLASSES[weapon_special_class]:new(weapon_special_context, weapon_special_init_data)

	return special_implementation
end

Weapon._init_traits = function (self, weapon_template, item, override_trait_lerp_value_or_nil, override_tweak_template_lerp_value_or_nil, weapon_progression_debug)
	local base_stats = (weapon_progression_debug and weapon_progression_debug.base_stats) or item.base_stats or EMPTY_TABLE
	local overclocks = (weapon_progression_debug and weapon_progression_debug.overclocks) or item.overclocks or EMPTY_TABLE
	local perks = item.perks or EMPTY_TABLE
	local traits = item.traits or EMPTY_TABLE
	local debug_perks = (weapon_progression_debug and weapon_progression_debug.perks) or EMPTY_TABLE
	local debug_traits = weapon_progression_debug and weapon_progression_debug.traits
	local lerp_values = WeaponTweakTemplates.calculate_lerp_values(weapon_template, base_stats, overclocks, perks, EMPTY_TABLE, override_trait_lerp_value_or_nil)
	local weapon_tweak_templates = WeaponTweakTemplates.create(lerp_values, weapon_template, override_tweak_template_lerp_value_or_nil)
	local damage_profile_lerp_values = lerp_values[template_types.damage]
	local explosion_template_lerp_values = lerp_values[template_types.explosion]
	local buffs = WeaponTweakTemplates.extract_buffs(weapon_template)

	WeaponTweakTemplates.extract_trait_buffs(weapon_template, buffs, traits, debug_traits)

	return weapon_tweak_templates, damage_profile_lerp_values, explosion_template_lerp_values, buffs
end

return Weapon
