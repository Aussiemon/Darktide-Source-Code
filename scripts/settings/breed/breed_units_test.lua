-- chunkname: @scripts/settings/breed/breed_units_test.lua

local Breed = require("scripts/utilities/breed")
local Breeds = require("scripts/settings/breed/breeds")
local MasterItems = require("scripts/backend/master_items")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local animation_system_tests = require("scripts/extension_systems/animation/animation_system_tests")
local character_state_animation_state_machine_tests = require("scripts/extension_systems/character_state_machine/character_state_animation_state_machine_tests")
local hit_zone_tests = require("scripts/utilities/attack/hit_zone_tests")
local item_definitions = MasterItems.get_cached()
local REQUIRED_NODES = {
	"enemy_aim_target_01",
	"enemy_aim_target_02",
	"enemy_aim_target_03"
}
local REQUIRED_MINION_RANGED_NODES = {
	"fx_muzzle_01"
}
local FX_SOURCE_NAME = "muzzle"

local function _init_and_run_tests()
	local world = Application.new_world()
	local trigger_flow = false
	local attach_settings = {
		from_script_component = true,
		is_minion = true,
		world = world,
		item_definitions = item_definitions
	}
	local missing_ranged_nodes_text = ""
	local missing_minion_ranged_nodes = false

	for name, breed in pairs(Breeds) do
		local base_unit = breed.base_unit
		local unit = World.spawn_unit_ex(world, base_unit, nil, Matrix4x4.identity(), trigger_flow)
		local state_machine = breed.state_machine

		if state_machine then
			Unit.set_animation_state_machine(unit, state_machine)
		end

		animation_system_tests(unit, breed)
		hit_zone_tests(unit, breed, world)

		if Breed.is_character(breed) then
			local s = ""
			local missing_nodes = false

			for _, node_name in ipairs(REQUIRED_NODES) do
				if not Unit.has_node(unit, node_name) then
					missing_nodes = true
					s = string.format("%s %q", s, node_name)
				end
			end
		end

		if Breed.is_minion(breed) then
			local inventory = breed.inventory and breed.inventory.default
			local slot_ranged_weapon = inventory and inventory.slot_ranged_weapon

			if slot_ranged_weapon then
				local items = slot_ranged_weapon.items

				for i = 1, #items do
					local item_name = items[i]
					local item = item_definitions[item_name]
					local item_unit, attachment_units = VisualLoadoutCustomization.spawn_item(item, attach_settings, unit, nil, nil, nil)

					for _, node_name in ipairs(REQUIRED_MINION_RANGED_NODES) do
						if not Unit.has_node(item_unit, node_name) then
							missing_minion_ranged_nodes = true
							missing_ranged_nodes_text = missing_ranged_nodes_text .. string.format("\n %q is missing %q", tostring(item_unit), node_name)
						end
					end

					local test_data = {
						unit = item_unit,
						item_data = item,
						attachments = attachment_units
					}
					local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(test_data, FX_SOURCE_NAME)

					if not attachment_unit or not node_index then
						missing_minion_ranged_nodes = true
						missing_ranged_nodes_text = missing_ranged_nodes_text .. string.format("\n item %q is missing %q in fx_sources or is not named fx_muzzle_01", item_name, FX_SOURCE_NAME)
					end

					World.destroy_unit(world, item_unit)
				end
			end
		end

		World.destroy_unit(world, unit)

		if Breed.is_player(breed) then
			local first_person_unit = breed.first_person_unit
			local unit_1p = World.spawn_unit_ex(world, first_person_unit, nil, Matrix4x4.identity(), trigger_flow)

			character_state_animation_state_machine_tests(unit_1p, name, world)
			World.destroy_unit(world, unit_1p)
		end
	end

	Application.release_world(world)
end

local function _resource_dependencies()
	local resource_dependencies = {}

	for breed_name, breed in pairs(Breeds) do
		local base_unit, state_machine = breed.base_unit, breed.state_machine

		resource_dependencies[base_unit] = true

		if state_machine then
			resource_dependencies[state_machine] = true
		end

		if Breed.is_player(breed) then
			local first_person_unit = breed.first_person_unit

			resource_dependencies[first_person_unit] = true

			for item_name, item in pairs(item_definitions) do
				local breeds = item.breeds
				local weapon_template_name = item.weapon_template

				weapon_template_name = type(weapon_template_name) == "string" and weapon_template_name ~= "" and weapon_template_name

				if weapon_template_name and breeds and table.contains(breeds, breed_name) then
					local weapon_template = WeaponTemplates[weapon_template_name]
					local _, state_machine_1p = WeaponTemplate.state_machines(weapon_template, breed_name)

					resource_dependencies[state_machine_1p] = true
				end
			end
		end
	end

	return resource_dependencies
end

return {
	resource_dependencies = _resource_dependencies,
	test_function = _init_and_run_tests
}
