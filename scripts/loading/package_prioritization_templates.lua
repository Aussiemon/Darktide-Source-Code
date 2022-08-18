local PlayerPackageAliases = require("scripts/settings/player/player_package_aliases")
local package_prioritization_templates = {
	default = {
		required_package_aliases = {
			"base_units",
			"slot_unarmed",
			"sound_dependencies",
			"particle_dependencies",
			"slot_body_face",
			"slot_body_torso",
			"slot_body_legs",
			"slot_body_arms",
			"slot_body_tattoo",
			"slot_body_hair",
			"slot_body_face_tattoo",
			"slot_body_face_scar",
			"slot_body_face_hair",
			"slot_gear_head",
			"slot_gear_upperbody",
			"slot_gear_lowerbody",
			"slot_gear_extra_cosmetic",
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3",
			"slot_body_hair_color",
			"slot_body_skin_color",
			"slot_body_eye_color",
			"slot_primary",
			"slot_secondary",
			"slot_pocketable",
			"slot_luggable",
			"slot_device",
			"slot_unarmed",
			"slot_combat_ability",
			"slot_grenade_ability",
			"slot_net"
		}
	},
	hub = {
		required_package_aliases = {
			"base_units",
			"slot_unarmed",
			"sound_dependencies",
			"particle_dependencies",
			"slot_grenade_ability",
			"slot_combat_ability"
		}
	}
}

for template_name, template in pairs(package_prioritization_templates) do
	template.name = template_name
	template.remaining_package_aliases = {}
	local required_package_aliases = template.required_package_aliases

	for i = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[i]

		if not table.contains(required_package_aliases, alias) then
			template.remaining_package_aliases[#template.remaining_package_aliases + 1] = alias
		end
	end
end

return package_prioritization_templates
