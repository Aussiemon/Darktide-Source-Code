local Breed = require("scripts/utilities/breed")
local WoundMaterials = require("scripts/extension_systems/wounds/utilities/wound_materials")
local MinionDissolveUtility = {}
local WOUND_INDEX = 1
local MIN_DISSOLVE_RADIUS = 0.01
local radius_material_keys = {
	"wound_radius_01",
	"wound_radius_02",
	"wound_radius_03"
}
local shape_scale_material_keys = {
	"wound_shape_scaling_01",
	"wound_shape_scaling_02",
	"wound_shape_scaling_03"
}
local hide_on_dissolve_slots = {
	slot_shield = 0.6,
	slot_beard = 0.25,
	slot_gear_attachment = 0.4,
	slot_melee_weapon = 0.6,
	slot_hair = 0.2,
	slot_ranged_weapon = 0.6
}
local breed_hide_on_dissolve_slots = {
	renegade_gunner = {
		slot_head = 0.25
	},
	renegade_shocktrooper = {
		slot_head = 0.25
	},
	renegade_berzerker = {
		slot_head = 0.25
	},
	cultist_assault = {
		slot_head = 0.25
	}
}

local function get_shape_scale(radius)
	return 1 / (0.1 * radius) * 0.99
end

local function toggle_slots(visual_loadout_extension, slots, show_slots)
	for slot_name, _ in pairs(slots) do
		local has_equipped_slot = visual_loadout_extension:can_unequip_slot(slot_name)
		local should_toggle = has_equipped_slot and show_slots ~= visual_loadout_extension:is_slot_visible(slot_name)

		if should_toggle then
			visual_loadout_extension:set_slot_visibility(slot_name, show_slots)
		end
	end
end

MinionDissolveUtility.start_dissolve = function (unit, t, reverted)
	local dissolve_data = {}
	local duration = 1.15
	local wounds_extension = ScriptUnit.extension(unit, "wounds_system")
	local wounds_data = wounds_extension:wounds_data()
	wounds_data.last_write_index = math.max(WOUND_INDEX, wounds_data.last_write_index)
	wounds_data.num_wounds = math.max(WOUND_INDEX, wounds_data.num_wounds)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local dissolve_height = Breed.height(unit, breed) * 1.1
	local max_dissolve_radius = dissolve_height * 10 * 1.125
	local start_radius = reverted and max_dissolve_radius or MIN_DISSOLVE_RADIUS
	local wound = wounds_data[WOUND_INDEX]

	wound.color_brightness_value:store(Vector3(0.6, 1, 0))
	wound.hit_shader_vector:store(Vector3(0, 0, dissolve_height))

	wound.radii[WOUND_INDEX] = start_radius
	wound.radius_index = WOUND_INDEX
	wound.radius_material_key = radius_material_keys[WOUND_INDEX]
	wound.radius_material_key_id = Script.id_string_32(wound.radius_material_key)

	wound.shape_mask_uv_offset:store(Vector2(0.75, 0.75))

	wound.shape_scale_index = WOUND_INDEX
	wound.shape_scale_material_key = shape_scale_material_keys[WOUND_INDEX]
	wound.shape_scale_material_key_id = Script.id_string_32(wound.shape_scale_material_key)
	wound.shape_scales[WOUND_INDEX] = get_shape_scale(start_radius)

	wound.color_time_duration:store(Vector2(World.time(Application.main_world()), math.huge))

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())

	local show_slots = not reverted

	toggle_slots(visual_loadout_extension, hide_on_dissolve_slots, show_slots)

	local breed_hide_slots = breed_hide_on_dissolve_slots[breed.name]

	if breed_hide_slots then
		toggle_slots(visual_loadout_extension, breed_hide_slots, show_slots)
	end

	local inventory = breed.inventory.default[1]
	local inventory_slots = inventory.slots
	local start_t = t
	local done_t = t + duration
	dissolve_data.start_t = start_t
	dissolve_data.duration = duration
	dissolve_data.done_t = done_t
	dissolve_data.inventory_slots = inventory_slots
	dissolve_data.breed = breed
	dissolve_data.visual_loadout_extension = visual_loadout_extension
	dissolve_data.wounds_data = wounds_data
	dissolve_data.wound = wound
	dissolve_data.reverted = reverted
	dissolve_data.max_dissolve_radius = max_dissolve_radius

	return dissolve_data
end

MinionDissolveUtility.update_dissolve = function (unit, dissolve_data, t)
	local reverted = dissolve_data.reverted
	local max_dissolve_radius = dissolve_data.max_dissolve_radius
	local from_radius = reverted and max_dissolve_radius or MIN_DISSOLVE_RADIUS
	local to_radius = reverted and MIN_DISSOLVE_RADIUS or max_dissolve_radius
	local lerp_t = math.clamp01((t - dissolve_data.start_t) / dissolve_data.duration)
	local lerped_radius = math.lerp(from_radius, to_radius, lerp_t)
	local shape_scale = get_shape_scale(lerped_radius)
	dissolve_data.wound.radii[WOUND_INDEX] = lerped_radius
	dissolve_data.wound.shape_scales[WOUND_INDEX] = shape_scale
	local wounds_data = dissolve_data.wounds_data
	local visual_loadout_extension = dissolve_data.visual_loadout_extension

	WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())

	local flesh_is_visible = visual_loadout_extension:is_slot_visible("slot_flesh")
	dissolve_data.show_flesh = reverted and (dissolve_data.show_flesh or flesh_is_visible)

	if flesh_is_visible then
		visual_loadout_extension:set_slot_visibility("slot_flesh", false)
	end

	local breed_hide_slots = breed_hide_on_dissolve_slots[dissolve_data.breed.name]
	local inventory_slots = dissolve_data.inventory_slots
	local show_slots = reverted

	for slot_name, _ in pairs(inventory_slots) do
		local toggle_percentage_t = breed_hide_slots and breed_hide_slots[slot_name]
		toggle_percentage_t = toggle_percentage_t or hide_on_dissolve_slots[slot_name]

		if toggle_percentage_t then
			if reverted then
				toggle_percentage_t = 1 - toggle_percentage_t
			end

			local toggle_t = dissolve_data.start_t + dissolve_data.duration * toggle_percentage_t

			if t > toggle_t then
				local has_equipped_slot = visual_loadout_extension:can_unequip_slot(slot_name)
				local is_not_toggled = has_equipped_slot and show_slots ~= visual_loadout_extension:is_slot_visible(slot_name)

				if is_not_toggled then
					visual_loadout_extension:set_slot_visibility(slot_name, show_slots)
				end
			end
		end
	end

	if dissolve_data.done_t < t then
		if dissolve_data.show_flesh then
			local flesh_is_visible = visual_loadout_extension:is_slot_visible("slot_flesh")

			if not flesh_is_visible then
				visual_loadout_extension:set_slot_visibility("slot_flesh", true)
			end
		end

		return true
	end

	return false
end

MinionDissolveUtility.inherit_progress = function (old_dissolve_data, new_dissolve_data, t)
	local percentage_done = math.clamp01((t - old_dissolve_data.start_t) / old_dissolve_data.duration)
	local new_percentage_done = percentage_done

	if old_dissolve_data.reverted ~= new_dissolve_data.reverted then
		new_percentage_done = 1 - new_percentage_done
	end

	local duration = new_dissolve_data.duration
	new_dissolve_data.start_t = new_dissolve_data.start_t - duration * new_percentage_done
	new_dissolve_data.done_t = new_dissolve_data.done_t - duration * new_percentage_done
end

return MinionDissolveUtility
