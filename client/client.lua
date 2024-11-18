local playerPed = PlayerPedId()
local MinigameActive = false
local Reload = false

local function Minigame()
    MinigameActive = true

    Wait(100)
    local minigame = exports["syn_minigame"]:taskBar(3000, 7) -- You can add your minigame export
    if Config.Debug then
    print("Minigame Result:" .. minigame)
    end

    if minigame == 100 then
        Reload = true
        if Config.Debug then
        print("Reload Successful")
        end
    else
        Reload = false
        if Config.Debug then
        print("Reload Failed")
        end
    end

    MinigameActive = false
end

CreateThread(function()
    while true do
        Wait(0)

        local _, currentWeapon = GetCurrentPedWeapon(playerPed, true)
        local WhitelistWeapon = false

        for _, weapon in ipairs(Config.WhitelistWeapon) do
            if currentWeapon == GetHashKey(weapon) then
                WhitelistWeapon = true
                if Config.Debug then
                    print("Whitelist Weapon:" .. currentWeapon)
                end
                break
            end
        end

        if IsPedReloading(playerPed) and not MinigameActive and not WhitelistWeapon then
            ClearPedTasks(playerPed)
            Minigame()
        end

        if Reload then
            Reload = false
            MakePedReload(playerPed)
        end
    end
end)