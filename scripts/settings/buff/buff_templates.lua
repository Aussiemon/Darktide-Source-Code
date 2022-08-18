local templates = {}

local function _create_entry(path)
	local entry_templates = require(path)

	for name, template in pairs(entry_templates) do
		fassert(not templates[name], "Duplicate buff_template found with id: %q", name)

		templates[name] = template
	end
end

_create_entry("scripts/settings/buff/boon_buff_templates")
_create_entry("scripts/settings/buff/common_buff_templates")
_create_entry("scripts/settings/buff/gadget_buff_templates")
_create_entry("scripts/settings/buff/item_buff_templates")
_create_entry("scripts/settings/buff/liquid_area_buff_templates")
_create_entry("scripts/settings/buff/minion_buff_templates")
_create_entry("scripts/settings/buff/mission_objective_buff_templates")
_create_entry("scripts/settings/buff/mutator_buff_templates")
_create_entry("scripts/settings/buff/player_buff_templates")
_create_entry("scripts/settings/buff/weapon_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_trait_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_buff_examples")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_melee_common_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_melee_activated_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_common_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_aimed_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_warp_charge_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_overheat_buff_templates")
_create_entry("scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_ranged_explosive_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/common_player_specialization_buffs")
_create_entry("scripts/settings/buff/player_archetype_specialization/ogryn_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/ogryn_bonebreaker_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/ogryn_gun_lugger_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/psyker_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/psyker_biomancer_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/psyker_protectorate_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/veteran_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/veteran_ranger_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/veteran_squad_leader_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/zealot_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/zealot_maniac_buff_templates")
_create_entry("scripts/settings/buff/player_archetype_specialization/zealot_preacher_buff_templates")

local default_buff_icon = "content/ui/materials/icons/abilities/default"

for buff_name, template in pairs(templates) do
	template.name = buff_name
	template.predicted = template.predicted == nil and true or template.predicted

	if not template.icon then
		template.icon = default_buff_icon
	end
end

return settings("BuffTemplates", templates)
