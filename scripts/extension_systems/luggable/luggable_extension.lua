local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local LuggableExtension = class("LuggableExtension")

LuggableExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	fassert(Unit.find_actor(unit, "interaction"), "[LuggableExtension][init] Missing actor 'interaction' for Unit(%s)", tostring(unit))

	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._destroyed = false

	if is_server then
		self._carrier_player_unit = nil
		self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	end
end

LuggableExtension.extensions_ready = function (self, world, unit)
	self._mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
	self._interactee_extension = ScriptUnit.extension(unit, "interactee_system")
end

LuggableExtension.destroy = function (self)
	self._destroyed = true
	local player_unit = self._carrier_player_unit

	if player_unit then
		local fixed_t = FixedFrame.get_latest_fixed_time()

		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, "slot_luggable", fixed_t)
	end
end

LuggableExtension.set_carried_by = function (self, player_unit_or_nil)
	if player_unit_or_nil then
		fassert(self._carrier_player_unit == nil, "luggable already carried by %s", self._carrier_player_unit)
		self:_on_carried()
	else
		fassert(self._carrier_player_unit, "trying to set carried to nil while not being carried.")
		self:_on_dropped()
	end

	self._carrier_player_unit = player_unit_or_nil
end

LuggableExtension._on_carried = function (self)
	if self._is_server then
		self._interactee_extension:set_active(false)
		self._mission_objective_target_extension:remove_unit_marker()
	end
end

LuggableExtension._on_dropped = function (self)
	if self._is_server and not self._destroyed then
		self._interactee_extension:set_active(true)
		self._mission_objective_target_extension:add_unit_marker()
	end
end

return LuggableExtension
