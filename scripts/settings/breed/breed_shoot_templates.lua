-- chunkname: @scripts/settings/breed/breed_shoot_templates.lua

local breed_shoot_templates = {}

local function _create_breed_shoot_templates(path)
	local shoot_templates = require(path)

	for name, template in pairs(shoot_templates) do
		breed_shoot_templates[name] = template
	end
end

_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/chaos/chaos_ogryn_gunner_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/chaos/chaos_beast_of_nurgle_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_assault_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_captain_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_flamer_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_gunner_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_netgunner_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_plasma_gunner_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_rifleman_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_shocktrooper_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/renegade/renegade_sniper_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/cultist/cultist_assault_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/cultist/cultist_flamer_shoot_templates")
_create_breed_shoot_templates("scripts/settings/breed/breed_shoot_templates/cultist/cultist_gunner_shoot_templates")

return settings("BreedShootTemplates", breed_shoot_templates)
