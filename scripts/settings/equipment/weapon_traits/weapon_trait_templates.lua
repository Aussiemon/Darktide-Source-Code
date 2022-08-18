local templates = {}

local function _create_entry(path)
	local entry_templates = require(path)

	for name, template in pairs(entry_templates) do
		fassert(not templates[name], "Duplicate weapon_trait_template found with id: %q", name)

		templates[name] = template
	end
end

_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_high_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_medium_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_low_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_warp_charge")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_overheat")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_explosive")

return templates
