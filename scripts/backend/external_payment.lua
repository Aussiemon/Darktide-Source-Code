-- chunkname: @scripts/backend/external_payment.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local ExternalPaymentPlatformBase = require("scripts/backend/platform/external_payment_platform_base")
local ExternalPaymentPlatformSteam = require("scripts/backend/platform/external_payment_platform_steam")
local ExternalPaymentPlatformXbox = require("scripts/backend/platform/external_payment_platform_xbox")
local ExternalPaymentPlatformPlaystation = require("scripts/backend/platform/external_payment_platform_playstation")
local ExternalPaymentPlatform = {}

ExternalPaymentPlatform[Backend.AUTH_METHOD_NONE] = ExternalPaymentPlatformBase
ExternalPaymentPlatform[Backend.AUTH_METHOD_STEAM] = ExternalPaymentPlatformSteam
ExternalPaymentPlatform[Backend.AUTH_METHOD_XBOXLIVE] = ExternalPaymentPlatformXbox
ExternalPaymentPlatform[Backend.AUTH_METHOD_PSN] = ExternalPaymentPlatformPlaystation
ExternalPaymentPlatform[Backend.AUTH_METHOD_DEV_USER] = ExternalPaymentPlatformBase
ExternalPaymentPlatform[Backend.AUTH_METHOD_AWS] = ExternalPaymentPlatformBase

local ExternalPayment = {}

ExternalPayment.new = function (self)
	local authenticate_method = Backend:get_auth_method()
	local instance = ExternalPaymentPlatform[authenticate_method]:new()

	return instance
end

return ExternalPayment
