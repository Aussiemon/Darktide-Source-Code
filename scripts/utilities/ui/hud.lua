local Hud = {
	hud_scale = function ()
		local default_value = 100
		local save_data = Managers.save:account_data()
		local interface_settings = save_data.interface_settings
		local hud_scale = interface_settings.hud_scale or default_value
		local scale = RESOLUTION_LOOKUP.scale

		return scale * hud_scale / 100
	end
}

Hud.inverse_hud_scale = function ()
	return 1 / Hud.hud_scale()
end

return Hud
