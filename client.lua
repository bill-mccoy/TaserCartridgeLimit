-----------------------------
--- Taser Cartridge Limit ---
-----------------------------

--- Config ---

maxTaserCarts = 2 -- The amount of taser cartridges a person can have.
refillCommand = "cargartaser" -- The command to refill taser cartridges
longerTazeTime = true -- Want longer taze times? true/false
longerTazeSecTime = 8 -- Time in SECONDS to extend the longer taze time.

--- Code ---

local taserCartsLeft = maxTaserCarts

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

-- Reload weapon and do animation ---

---RegisterCommand('cargador', function()
---  local ped = GetPlayerPed(-1)
--  local hash = GetSelectedPedWeapon(ped)
--  AddAmmoToPed(GetPlayerPed(-1), hash,300)
--  print('Se te ha llenado el cargador del arma en la mano')
--end)

RegisterCommand(refillCommand, function(source, args, rawCommand)
    taserCartsLeft = maxTaserCarts
    RequestAnimDict("weapons@pistol@pistol_str")
    while (not HasAnimDictLoaded("weapons@pistol@pistol_str")) do Citizen.Wait(200) end 
    TaskPlayAnim(ped, "weapons@pistol@pistol_str", "reload_aim", 1.0, 1.0, 3000, 0, 1, false, false, false);
    print("Cantidad de cartuchos restantes = " .. taserCartsLeft);
    ShowNotification("~g~Taser cargado y listo!.")
end)

--- Get stungun hash and lower ammo counter ---

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local taserModel = GetHashKey("WEAPON_STUNGUN")

        if GetSelectedPedWeapon(ped) == taserModel then
            if IsPedShooting(ped) then
                taserCartsLeft = taserCartsLeft - 1
                print("Cartuchos Restantes = " .. taserCartsLeft);
            end
        end

        if taserCartsLeft <= 0 then
            if GetSelectedPedWeapon(ped) == taserModel then
				DisableControlAction(0, 24,  true) -- Shoot 
				DisableControlAction(0, 92,  true) -- Shoot in car
				ShowNotification("~y~Ya no tienes mas cartuchos!. Recarga con /" .. refillCommand) else
                end
            else
            end
        end
        if longerTazeTime then
            SetPedMinGroundTimeForStungun(ped, longerTazeSecTime * 1000)
        end
    end
end)

