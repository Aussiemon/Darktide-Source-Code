local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTemplate = {
	current_weapon_template = function (weapon_action_component)
		local weapon_template_name = weapon_action_component.template_name
		local weapon_template = WeaponTemplate.weapon_template(weapon_template_name)

		return weapon_template
	end,
	is_ranged = function (weapon_template)
		return WeaponTemplate.has_keyword(weapon_template, "ranged")
	end,
	is_melee = function (weapon_template)
		return WeaponTemplate.has_keyword(weapon_template, "melee")
	end,
	is_grenade = function (weapon_template)
		return WeaponTemplate.has_keyword(weapon_template, "grenade")
	end,
	has_keyword = function (weapon_template, keyword)
		local keywords = weapon_template.keywords
		local has_keyword = nil

		if keywords then
			has_keyword = table.array_contains(keywords, keyword)
		end

		return not not has_keyword
	end,
	weapon_template_from_item = function (weapon_item)
		if not weapon_item then
			return nil
		end

		local weapon_template_name = weapon_item.weapon_template
		local weapon_progression_template_name = weapon_item.weapon_progression_template

		if weapon_progression_template_name then
			return WeaponTemplate.weapon_template(weapon_progression_template_name)
		end

		return WeaponTemplate.weapon_template(weapon_template_name)
	end,
	weapon_template = function (template_name)
		return WeaponTemplates[template_name]
	end,
	state_machines = function (weapon_template, breed_name)
		local anim_state_machine_3p = nil
		local breed_anim_state_machine_3p = weapon_template.breed_anim_state_machine_3p

		if breed_anim_state_machine_3p then
			anim_state_machine_3p = breed_anim_state_machine_3p[breed_name]
		else
			anim_state_machine_3p = weapon_template.anim_state_machine_3p
		end

		local anim_state_machine_1p = nil
		local breed_anim_state_machine_1p = weapon_template.breed_anim_state_machine_1p

		if breed_anim_state_machine_1p then
			anim_state_machine_1p = breed_anim_state_machine_1p[breed_name]
		else
			anim_state_machine_1p = weapon_template.anim_state_machine_1p
		end

		return anim_state_machine_3p, anim_state_machine_1p
	end
}

return WeaponTemplate
