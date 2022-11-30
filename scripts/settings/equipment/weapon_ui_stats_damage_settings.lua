local bit = require("bit")
local WeaponUIStatsDamageOptions = {
	DAMAGE_FINESSE = 2,
	DAMAGE_NONE = 0,
	DAMAGE_BODY = 1
}
WeaponUIStatsDamageOptions.DAMAGE_ALL = bit.bor(WeaponUIStatsDamageOptions.DAMAGE_BODY, WeaponUIStatsDamageOptions.DAMAGE_FINESSE)

return WeaponUIStatsDamageOptions
