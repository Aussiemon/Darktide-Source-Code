local HoloSightTemplates = require("scripts/settings/equipment/holo_sight_templates")
local HoloSight = class("HoloSight")

HoloSight.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._alternate_fire_component = alternate_fire_component
	self._equipment_component = context.equipment_component
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._was_aiming_down_sights = false
	self._slot = slot
	self._hip_at_t = nil
	self._alternate_fire_at_t = nil
	local holo_sight_template = weapon_template.holo_sight_template
	self._holo_sight_template = holo_sight_template or HoloSightTemplates.default
end

HoloSight.update = function (self, unit, dt, t)
	local is_aiming_down_sights = self._alternate_fire_component.is_active
	local first_person_extension = self._first_person_extension

	if first_person_extension:is_in_first_person_mode() then
		local unit_1p = self._slot.parent_unit_1p
		local holo_sight_template = self._holo_sight_template
		local show_delay = holo_sight_template.show_delay
		local hide_delay = holo_sight_template.hide_delay
		local ads_ring = holo_sight_template.ads_ring
		local ads_dot = holo_sight_template.ads_dot
		local hip_ring = holo_sight_template.hip_ring
		local hip_dot = holo_sight_template.hip_dot
		local diff_ring = holo_sight_template.diff_ring
		local diff_dot = holo_sight_template.diff_dot
		local hip_at_t = self._hip_at_t
		local alternate_fire_at_t = self._alternate_fire_at_t
		local was_in_third_person = self._was_in_third_person
		local was_aiming_down_sights = self._was_aiming_down_sights

		if (was_aiming_down_sights or was_in_third_person) and not is_aiming_down_sights and not hip_at_t then
			hip_at_t = t + show_delay
		elseif (not was_aiming_down_sights or was_in_third_person) and is_aiming_down_sights then
			alternate_fire_at_t = alternate_fire_at_t or t + hide_delay
		end

		if was_in_third_person then
			hip_at_t = 0
			self._was_in_third_person = false
		end

		if hip_at_t then
			local progress = math.ease_exp(1 - math.clamp((hip_at_t - t) / show_delay, 0, 1))
			local ring = ads_ring - diff_ring * progress
			local dot = ads_dot - diff_dot * progress

			Unit.set_vector2_for_materials(unit_1p, "optic_layers", Vector2(ring, dot), true)

			if hip_at_t <= t then
				hip_at_t = nil
			end
		elseif alternate_fire_at_t then
			local progress = math.easeInCubic(1 - math.clamp((alternate_fire_at_t - t) / hide_delay, 0, 1))
			local ring = hip_ring + diff_ring * progress
			local dot = hip_dot + diff_dot * progress

			Unit.set_vector2_for_materials(unit_1p, "optic_layers", Vector2(ring, dot), true)

			if alternate_fire_at_t <= t then
				alternate_fire_at_t = nil
			end
		end

		self._hip_at_t = hip_at_t
		self._alternate_fire_at_t = alternate_fire_at_t
	end

	self._was_aiming_down_sights = is_aiming_down_sights
end

HoloSight.update_first_person_mode = function (self, first_person_mode)
	return
end

HoloSight.wield = function (self)
	self._was_aiming_down_sights = true
end

HoloSight.unwield = function (self)
	return
end

HoloSight.destroy = function (self)
	return
end

return HoloSight
