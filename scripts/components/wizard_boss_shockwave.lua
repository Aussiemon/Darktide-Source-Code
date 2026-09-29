-- chunkname: @scripts/components/wizard_boss_shockwave.lua

local WizardBossShockwave = component("WizardBossShockwave")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local LevelProps = require("scripts/settings/level_prop/level_props")
local WizardShockwaveStageHazard = require("scripts/utilities/stage_hazards/wizard_shockwave_stage_hazard")
local Component = require("scripts/utilities/component")
local Breed = require("scripts/utilities/breed")

local function _is_tooth_raised(tooth_unit)
	if not ALIVE[tooth_unit] then
		return false
	end

	local components = Component.get_components_by_name(tooth_unit, "SpillwayBossTooth")
	local tooth = components and components[1]

	if tooth and tooth.is_raised then
		return tooth:is_raised()
	end

	return true
end

local CLIENT_RPCS = {}
local SERVER_RPCS = {}
local UI_WORLD_NAME = "shockwave_ui_world"
local DECAL_SIZE_DURATION = 3
local DECAL_OPACITY_DURATION = 1
local ANTICIPATION_CHARGE_DURATION = 5
local DECAL_START_DELAY = 3.5
local START_SHOCKWAVE_FIELD = "shockwave_started"
local BOSS_BREED_NAME = "renegade_wizard"

WizardBossShockwave.init = function (self, unit)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self._network_event_delegate = network_event_delegate

	if not DEDICATED_SERVER then
		self:_create_render_target(unit)
	end

	return true
end

WizardBossShockwave.hot_join_sync = function (self, joining_client, joining_channel)
	return
end

WizardBossShockwave.editor_init = function (self, unit)
	self:enable(unit)

	self._should_debug_draw = false
end

WizardBossShockwave.enable = function (self, unit)
	if not self.is_server then
		return
	end
end

WizardBossShockwave.disable = function (self, unit)
	if not self.is_server then
		return
	end
end

WizardBossShockwave.destroy = function (self, unit)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	if not DEDICATED_SERVER then
		self:_destroy_render_target()
	end
end

WizardBossShockwave.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

WizardBossShockwave.update = function (self, unit, dt, t)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	if self._render_target and self._effect_id and not self._render_init then
		local world = Unit.world(unit)
		local particle_mesh = World.get_particles_mesh(world, self._effect_id, "decal_anticipation")
		local material_instance = particle_mesh and Mesh.material(particle_mesh, "decal")

		if material_instance then
			local center_position = POSITION_LOOKUP[unit]

			Material.set_vector3(material_instance, "position", center_position)
			Material.set_resource(material_instance, "source", self._render_target)
			Material.set_scalar(material_instance, "decal_size", 0)
			Material.set_scalar(material_instance, "decal_opacity", 1)
			Material.set_scalar(material_instance, "anticipation_charge", 0)

			self._material_instance = material_instance
			self._decal_size_start_t = t
			self._render_init = true
		end
	end

	self:_update_decal_animation(t)

	if self.is_server then
		self:_server_update(unit, dt, t)
	elseif not self.is_server then
		self:_client_update(unit, dt, t)
	end

	return true
end

WizardBossShockwave._update_decal_animation = function (self, t)
	local material_instance = self._material_instance

	if not material_instance then
		return
	end

	local linear_progress = math.min((t - self._decal_size_start_t) / DECAL_SIZE_DURATION, 1)
	local size_progress = math.easeInCubic(linear_progress)

	Material.set_scalar(material_instance, "decal_size", size_progress)

	local charge_elapsed = t - self._decal_size_start_t - DECAL_START_DELAY
	local charge_progress = math.clamp(charge_elapsed / ANTICIPATION_CHARGE_DURATION, 0, 1)

	Material.set_scalar(material_instance, "anticipation_charge", charge_progress)

	if not self._push_triggered and self:_is_push_triggered() then
		self._push_triggered = true
		self._decal_opacity_start_t = t
	end

	if self._push_triggered then
		local opacity_progress = math.min((t - self._decal_opacity_start_t) / DECAL_OPACITY_DURATION, 1)

		Material.set_scalar(material_instance, "decal_opacity", 1 - opacity_progress)
	end
end

WizardBossShockwave._is_push_triggered = function (self)
	local boss_unit = self:_get_boss_unit()

	if not boss_unit then
		return false
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(boss_unit)

	if not game_object_id or not GameSession.game_object_exists(game_session, game_object_id) then
		return false
	end

	return GameSession.game_object_field(game_session, game_object_id, START_SHOCKWAVE_FIELD)
end

WizardBossShockwave._get_boss_unit = function (self)
	local boss_unit = self._boss_unit

	if boss_unit and ALIVE[boss_unit] then
		return boss_unit
	end

	self._boss_unit = nil

	local extension_manager = Managers.state.extension
	local boss_system = extension_manager and extension_manager:system("boss_system")

	if not boss_system then
		return nil
	end

	for unit in pairs(boss_system:unit_to_extension_map()) do
		local breed = Breed.unit_breed_or_nil(unit)

		if breed and breed.name == BOSS_BREED_NAME then
			self._boss_unit = unit

			return unit
		end
	end

	return nil
end

WizardBossShockwave._server_update = function (self, unit, dt, t)
	return
end

WizardBossShockwave._client_update = function (self, unit, dt, t)
	return
end

local effect_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_warp_forcepush_anticipation"

WizardBossShockwave._create_render_target = function (self, unit)
	local instance_id = string.gsub(tostring(self), "table: ", "")

	self._instance_id = instance_id

	local world = self:_get_ui_world()

	self._ui_world = world

	local resolution = 2048
	local gui = World.create_gui(world, {
		immediate = false,
		use_custom_dimension = true,
		width = resolution,
		height = resolution,
	})

	self._gui = gui

	local ignore_back_buffer = true
	local width = resolution
	local height = resolution
	local render_target_name = "shockwave_render_target_" .. instance_id
	local render_target = Renderer.create_resource("render_target", "R8G8B8A8", not ignore_back_buffer and "back_buffer" or nil, width, height, render_target_name)

	self._render_target = render_target
	self._render_target_name = render_target_name

	local viewport_type = "overlay"
	local viewport_layer = 1
	local viewport_name = "shockwave_viewport_" .. instance_id

	self._viewport_name = viewport_name

	local shading_environment_name = GameParameters.default_ui_shading_environment

	ScriptWorld.create_viewport(world, viewport_name, viewport_type, viewport_layer, nil, nil, nil, nil, shading_environment_name, nil, nil, render_target)

	local center_position = POSITION_LOOKUP[unit]

	Gui.render_pass(gui, 0, render_target_name, true, render_target)

	local plane_size = 100
	local plane_half_size = plane_size * 0.5
	local pixels_per_meter = resolution / plane_size
	local unit_world = Unit.world(unit)
	local effect_id = World.create_particles(unit_world, effect_name, center_position, Quaternion.identity(), nil, nil)

	self._effect_id = effect_id
	self._effect_world = unit_world

	local tooth_cover = WizardShockwaveStageHazard.tooth_cover_settings
	local cone_width = tooth_cover.half_width_far * 2 * pixels_per_meter
	local cone_length = tooth_cover.length * pixels_per_meter
	local cone_material = "content/fx/materials/enemies/renegade_wizard/cone"
	local options = {
		snap_pixel_positions = true,
		render_pass = render_target_name,
		color = Color(255, 0, 255, 76.5),
		size = Vector2(cone_width, cone_length),
		position_offset = Vector3(-cone_width * 0.5, 0, 0),
	}
	local pose = Matrix4x4.from_quaternion_position(Quaternion.identity(), center_position)
	local top_left_corner = Matrix4x4.translation(pose) + Matrix4x4.forward(pose) * plane_half_size - Matrix4x4.right(pose) * plane_half_size
	local unit_tm = Matrix4x4.from_quaternion_position(Matrix4x4.rotation(pose), top_left_corner)
	local inverse_unit_tm = Matrix4x4.inverse(unit_tm)
	local prop_settings = LevelProps.spillway_boss_tooth
	local teeth_units = World.units_by_resource(unit_world, prop_settings.unit_name)

	for _, tooth_unit in pairs(teeth_units) do
		if _is_tooth_raised(tooth_unit) then
			local unit_position = Unit.world_position(tooth_unit, 1)
			local local_position = Matrix4x4.transform(inverse_unit_tm, unit_position)
			local test_pos = Vector3(math.abs(local_position.x / 100), math.abs(local_position.y / 100), 1)
			local new_pos = Vector3(resolution * test_pos.x, 1, resolution * test_pos.y)
			local forward = Matrix4x4.forward(pose)
			local direction = Vector3.normalize(center_position - unit_position)
			local dot = forward.x * direction.x + forward.y * direction.y
			local det = forward.x * direction.y - forward.y * direction.x
			local angle_rad = math.atan2(det, dot)
			local angle = math.radians_to_degrees(angle_rad)
			local tm = Matrix4x4.from_quaternion_position(Quaternion.from_euler_angles_xyz(0, angle, 0), new_pos)

			Gui2.bitmap_3d(gui, cone_material, GuiMaterialFlag.GUI_RENDER_PASS_LAYER, tm, 1, options)
		end
	end
end

WizardBossShockwave._get_ui_world = function (self)
	local world_manager = Managers.world
	local world_name = UI_WORLD_NAME .. "_" .. self._instance_id

	self._ui_world_name = world_name

	if world_manager:has_world(world_name) then
		return world_manager:world(world_name)
	end

	local parameters = {
		layer = 20,
		timer_name = "ui",
	}
	local flags = {
		Application.DISABLE_PHYSICS,
	}

	return world_manager:create_world(world_name, parameters, unpack(flags))
end

WizardBossShockwave.render_target = function (self)
	return self._render_target
end

WizardBossShockwave._destroy_render_target = function (self)
	if self._effect_id and self._effect_world then
		World.destroy_particles(self._effect_world, self._effect_id)

		self._effect_id = nil
		self._effect_world = nil
	end

	if self._render_target then
		Renderer.destroy_resource(self._render_target)

		self._render_target = nil
	end

	if self._ui_world then
		if self._gui then
			World.destroy_gui(self._ui_world, self._gui)

			self._gui = nil
		end

		if self._viewport_name then
			ScriptWorld.destroy_viewport(self._ui_world, self._viewport_name)
		end

		Managers.world:destroy_world(self._ui_world)

		self._ui_world = nil
	end
end

WizardBossShockwave.component_data = {
	inputs = {},
}

return WizardBossShockwave
