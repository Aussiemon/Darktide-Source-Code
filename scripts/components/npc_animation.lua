-- chunkname: @scripts/components/npc_animation.lua

local NpcAnimation = component("NpcAnimation")

NpcAnimation.init = function (self, unit)
	self._bone_lod_id = nil

	if self:get_data(unit, "editor_only") then
		return
	end

	self:enable(unit)

	if DEDICATED_SERVER then
		Unit.disable_animation_state_machine(unit)
	elseif not rawget(_G, "AnimationEditor") and not rawget(_G, "UnitEditor") then
		self:_override_animation(unit)

		if not rawget(_G, "LevelEditor") or not not rawget(_G, "UnitEditor") then
			local use_bone_lod = self:get_data(unit, "use_bone_lod")
			local has_bone_lod_manager = Managers and Managers.state and Managers.state.bone_lod
			local unit_world = Unit.world(unit)
			local is_in_ui_world = World.get_data(unit_world, "__is_ui_world")

			if has_bone_lod_manager and use_bone_lod and not is_in_ui_world then
				local bone_lod_radius = self:get_data(unit, "bone_lod_radius")

				self._bone_lod_id = Managers.state.bone_lod:register_unit(unit, bone_lod_radius, true)
			end
		end
	end
end

NpcAnimation.editor_validate = function (self, unit)
	return true, ""
end

NpcAnimation.enable = function (self, unit)
	return
end

NpcAnimation.disable = function (self, unit)
	return
end

NpcAnimation.destroy = function (self, unit)
	if self._bone_lod_id ~= nil then
		Managers.state.bone_lod:unregister_unit(self._bone_lod_id)

		self._bone_lod_id = nil
	end
end

NpcAnimation._override_animation = function (self, unit)
	local state_machine_resource = self:get_data(unit, "state_machine_override")

	if state_machine_resource ~= nil and state_machine_resource ~= "" then
		Unit.set_animation_state_machine(unit, state_machine_resource)
		Unit.enable_animation_state_machine(unit)

		local init_event = self:get_data(unit, "state_machine_init_event")

		if Unit.has_animation_event(unit, init_event) then
			Unit.animation_event(unit, init_event)
		end
	end

	local bone_mode = self:get_data(unit, "anim_bone_mode")

	if bone_mode ~= "default" then
		Unit.set_animation_bone_mode(unit, bone_mode)
	end
end

NpcAnimation.component_data = {
	editor_only = {
		category = "Settings",
		ui_name = "Editor Only",
		ui_type = "check_box",
		value = false,
	},
	state_machine_override = {
		category = "Animation",
		filter = "state_machine",
		ui_name = "State Machine Override",
		ui_type = "resource",
		value = "",
	},
	state_machine_init_event = {
		category = "Animation",
		ui_name = "State Machine Init Event",
		ui_type = "text_box",
		value = "",
	},
	anim_bone_mode = {
		category = "Animation",
		ui_name = "Bone Mode",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"Default",
			"Position and Rotation",
			"Ignore",
			"Transform",
			"Position",
			"Rotation",
			"Scale",
			"Position and Scale",
			"Rotation and Scale",
		},
		options_values = {
			"default",
			"position_and_rotation",
			"ignore",
			"transform",
			"position",
			"rotation",
			"scale",
			"position_and_scale",
			"rotation_and_scale",
		},
	},
	use_bone_lod = {
		category = "Bone LOD",
		ui_name = "Use Bone LOD (not visible in editor)",
		ui_type = "check_box",
		value = false,
	},
	bone_lod_radius = {
		category = "Bone LOD",
		decimals = 2,
		step = 0.01,
		ui_name = "Bone LOD Radius",
		ui_type = "number",
		value = 0.88,
	},
}

return NpcAnimation
