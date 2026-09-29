-- chunkname: @scripts/loading/package_prioritization_templates.lua

local PlayerPackageAliases = require("scripts/settings/player/player_package_aliases")
local package_prioritization_templates = {}

package_prioritization_templates.default = {
	required_package_aliases = {
		"base_unit_dependencies",
		"decal_dependencies",
		"particle_dependencies",
		"sound_dependencies",
		"slot_body_arms",
		"slot_body_eye_color_secondary",
		"slot_body_eye_color",
		"slot_body_face_hair_color",
		"slot_body_face_hair",
		"slot_body_face_makeup",
		"slot_body_face_scar",
		"slot_body_face_tattoo",
		"slot_body_face",
		"slot_body_hair_color",
		"slot_body_hair",
		"slot_body_legs",
		"slot_body_skin_color_secondary",
		"slot_body_skin_color",
		"slot_body_skin_discoloration",
		"slot_body_tattoo",
		"slot_body_torso",
		"slot_gear_extra_cosmetic",
		"slot_gear_head",
		"slot_gear_lowerbody",
		"slot_gear_material_override_decal",
		"slot_gear_upperbody",
		"slot_companion_body_coat_pattern",
		"slot_companion_body_fur_color",
		"slot_companion_body_skin_color",
		"slot_companion_gear_full",
		"slot_primary",
		"slot_secondary",
		"slot_unarmed",
		"slot_combat_ability",
		"slot_grenade_ability",
		"slot_attachment_1",
		"slot_attachment_2",
		"slot_attachment_3",
		"slot_device",
		"slot_luggable",
		"slot_net",
		"slot_pocketable_small",
		"slot_pocketable",
		"slot_timed",
	},
}
package_prioritization_templates.hub = {
	required_package_aliases = {
		"base_unit_dependencies",
		"decal_dependencies",
		"particle_dependencies",
		"sound_dependencies",
		"slot_unarmed",
	},
}

local template_names = table.keys(package_prioritization_templates)

table.sort(template_names)

for template_name_index = 1, #template_names do
	local template_name = template_names[template_name_index]
	local template = package_prioritization_templates[template_name]

	template.name = template_name
	template.remaining_package_aliases = {}

	local required_package_aliases = template.required_package_aliases

	for ii = 1, #PlayerPackageAliases do
		local alias = PlayerPackageAliases[ii]

		if not table.contains(required_package_aliases, alias) then
			template.remaining_package_aliases[#template.remaining_package_aliases + 1] = alias
		end
	end
end

return package_prioritization_templates
