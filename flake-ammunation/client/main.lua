local ESX = exports['es_extended']:getSharedObject()
local PlayerData = {}
local isClockedIn = false
local currentJob = nil
local blips = {}

-- Get player data
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    currentJob = PlayerData.job.name
    CreateBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    currentJob = job.name

    -- Auto clock out if job changes and not in allowed jobs
    if isClockedIn and not IsJobAllowedAtAnyLocation(currentJob) then
        isClockedIn = false
        lib.notify({
            title = 'Job System',
            description = 'You have been automatically clocked out',
            type = 'inform'
        })
    end

    -- Refresh blips when job changes
    CreateBlips()
end)

-- Check if player's job is allowed at a specific location
function IsJobAllowedAtLocation(location)
    if not currentJob then return false end

    -- If location has no job restrictions (empty table), allow all
    if #location.jobs == 0 then
        return true
    end

    -- Check if current job is in the allowed jobs list
    for _, allowedJob in ipairs(location.jobs) do
        if currentJob == allowedJob then
            return true
        end
    end

    return false
end

-- Check if player's job is allowed at any location
function IsJobAllowedAtAnyLocation(jobName)
    for _, location in ipairs(Config.Locations) do
        if #location.jobs == 0 then
            return true
        end
        for _, allowedJob in ipairs(location.jobs) do
            if jobName == allowedJob then
                return true
            end
        end
    end
    return false
end

-- Check if player is boss
function IsBoss()
    if not currentJob then return false end
    for _, grade in ipairs(Config.BossGrades) do
        if PlayerData.job.grade == grade then
            return true
        end
    end
    return false
end

-- Create blips for locations
function CreateBlips()
    -- Remove existing blips
    for _, blip in ipairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}

    -- Create new blips for all locations (visible to everyone)
    for _, location in ipairs(Config.Locations) do
        if location.blip and location.blip.enabled then
            local blip = AddBlipForCoord(location.clockPoints[1].coords.x, location.clockPoints[1].coords.y, location.clockPoints[1].coords.z)
            SetBlipSprite(blip, location.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, location.blip.scale)
            SetBlipColour(blip, location.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(location.blip.label)
            EndTextCommandSetBlipName(blip)
            table.insert(blips, blip)
        end
    end
end

-- Draw Markers
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Loop through all locations
        for _, location in ipairs(Config.Locations) do
            -- Only show markers if player has access to this location
            if IsJobAllowedAtLocation(location) then

                -- Clock In/Out Markers (always visible if job is allowed)
                for _, point in ipairs(location.clockPoints) do
                    local distance = #(playerCoords - point.coords)
                    if distance < Config.DrawDistance then
                        sleep = 0
                        DrawMarker(
                            Config.MarkerType,
                            point.coords.x, point.coords.y, point.coords.z,
                            0.0, 0.0, 0.0,
                            0.0, 0.0, 0.0,
                            Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                            Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                            false, true, 2, false, nil, nil, false
                        )
                    end
                end

                -- Only show other markers if clocked in
                if isClockedIn then
                    -- Boss Menu Markers
                    if IsBoss() then
                        for _, point in ipairs(location.bossMenuPoints) do
                            local distance = #(playerCoords - point.coords)
                            if distance < Config.DrawDistance then
                                sleep = 0
                                DrawMarker(
                                    Config.MarkerType,
                                    point.coords.x, point.coords.y, point.coords.z,
                                    0.0, 0.0, 0.0,
                                    0.0, 0.0, 0.0,
                                    Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                                    Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                                    false, true, 2, false, nil, nil, false
                                )
                            end
                        end
                    end

                    -- Wardrobe Markers
                    for _, point in ipairs(location.wardrobePoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.DrawDistance then
                            sleep = 0
                            DrawMarker(
                                Config.MarkerType,
                                point.coords.x, point.coords.y, point.coords.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                                Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                                false, true, 2, false, nil, nil, false
                            )
                        end
                    end

                    -- Weapon Parts Store Markers
                    for _, point in ipairs(location.weaponPartsPoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.DrawDistance then
                            sleep = 0
                            DrawMarker(
                                Config.MarkerType,
                                point.coords.x, point.coords.y, point.coords.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                                Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                                false, true, 2, false, nil, nil, false
                            )
                        end
                    end

                    -- Ammo Store Markers
                    for _, point in ipairs(location.ammoStorePoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.DrawDistance then
                            sleep = 0
                            DrawMarker(
                                Config.MarkerType,
                                point.coords.x, point.coords.y, point.coords.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                                Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                                false, true, 2, false, nil, nil, false
                            )
                        end
                    end

                    -- Crafting Markers
                    for _, point in ipairs(location.craftingPoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.DrawDistance then
                            sleep = 0
                            DrawMarker(
                                Config.MarkerType,
                                point.coords.x, point.coords.y, point.coords.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
                                Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a,
                                false, true, 2, false, nil, nil, false
                            )
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Interaction Handler
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Loop through all locations
        for _, location in ipairs(Config.Locations) do
            -- Only check interactions if player has access to this location
            if IsJobAllowedAtLocation(location) then

                -- Clock In/Out Points
                for _, point in ipairs(location.clockPoints) do
                    local distance = #(playerCoords - point.coords)
                    if distance < Config.InteractDistance then
                        sleep = 0
                        lib.showTextUI('[E] Clock ' .. (isClockedIn and 'Out' or 'In'))

                        if IsControlJustReleased(0, 38) then -- E key
                            lib.hideTextUI()
                            OpenClockMenu()
                        end
                    elseif distance < Config.InteractDistance + 0.5 then
                        lib.hideTextUI()
                    end
                end

                -- Only allow other interactions if clocked in
                if isClockedIn then
                    -- Boss Menu Points
                    if IsBoss() then
                        for _, point in ipairs(location.bossMenuPoints) do
                            local distance = #(playerCoords - point.coords)
                            if distance < Config.InteractDistance then
                                sleep = 0
                                lib.showTextUI('[E] Boss Menu')

                                if IsControlJustReleased(0, 38) then
                                    lib.hideTextUI()
                                    OpenBossMenu()
                                end
                            elseif distance < Config.InteractDistance + 0.5 then
                                lib.hideTextUI()
                            end
                        end
                    end

                    -- Wardrobe Points
                    for _, point in ipairs(location.wardrobePoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.InteractDistance then
                            sleep = 0
                            lib.showTextUI('[E] Wardrobe')

                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                OpenWardrobeMenu()
                            end
                        elseif distance < Config.InteractDistance + 0.5 then
                            lib.hideTextUI()
                        end
                    end

                    -- Weapon Parts Store Points
                    for _, point in ipairs(location.weaponPartsPoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.InteractDistance then
                            sleep = 0
                            lib.showTextUI('[E] Weapon Parts Store')

                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                OpenWeaponPartsMenu(location)
                            end
                        elseif distance < Config.InteractDistance + 0.5 then
                            lib.hideTextUI()
                        end
                    end

                    -- Ammo Store Points
                    for _, point in ipairs(location.ammoStorePoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.InteractDistance then
                            sleep = 0
                            lib.showTextUI('[E] Ammo Store')

                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                OpenAmmoMenu(location)
                            end
                        elseif distance < Config.InteractDistance + 0.5 then
                            lib.hideTextUI()
                        end
                    end

                    -- Crafting Points
                    for _, point in ipairs(location.craftingPoints) do
                        local distance = #(playerCoords - point.coords)
                        if distance < Config.InteractDistance then
                            sleep = 0
                            lib.showTextUI('[E] Craft Weapons')

                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                OpenCraftingMenu(location)
                            end
                        elseif distance < Config.InteractDistance + 0.5 then
                            lib.hideTextUI()
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

-- Clock In/Out Menu
function OpenClockMenu()
    lib.registerContext({
        id = 'ammu_clock_menu',
        title = 'Ammunation - Time Clock',
        options = {
            {
                title = isClockedIn and 'Clock Out' or 'Clock In',
                description = isClockedIn and 'End your shift' or 'Start your shift',
                onSelect = function()
                    isClockedIn = not isClockedIn
                    lib.notify({
                        title = 'Ammunation',
                        description = isClockedIn and 'You are now clocked in!' or 'You are now clocked out!',
                        type = 'success'
                    })
                end
            }
        }
    })
    lib.showContext('ammu_clock_menu')
end

-- Boss Menu
function OpenBossMenu()
    lib.registerContext({
        id = 'ammu_boss_menu',
        title = 'Boss Menu',
        options = {
            {
                title = 'Check Society Balance',
                description = 'View the company account balance',
                onSelect = function()
                    ESX.TriggerServerCallback('ammu:getSocietyMoney', function(money)
                        lib.notify({
                            title = 'Society Balance',
                            description = 'Balance: $' .. ESX.Math.GroupDigits(money),
                            type = 'info'
                        })
                    end)
                end
            },
            {
                title = 'Withdraw Society Money',
                description = 'Withdraw money from company account',
                onSelect = function()
                    local input = lib.inputDialog('Withdraw Money', {
                        {type = 'number', label = 'Amount', description = 'Amount to withdraw', required = true, min = 1}
                    })

                    if input then
                        TriggerServerEvent('ammu:withdrawMoney', input[1])
                    end
                end
            },
            {
                title = 'Deposit Society Money',
                description = 'Deposit money into company account',
                onSelect = function()
                    local input = lib.inputDialog('Deposit Money', {
                        {type = 'number', label = 'Amount', description = 'Amount to deposit', required = true, min = 1}
                    })

                    if input then
                        TriggerServerEvent('ammu:depositMoney', input[1])
                    end
                end
            },
            {
                title = 'Wash Money',
                description = 'Launder dirty money',
                onSelect = function()
                    local input = lib.inputDialog('Wash Money', {
                        {type = 'number', label = 'Amount', description = 'Amount of black money to wash', required = true, min = 1}
                    })

                    if input then
                        TriggerServerEvent('ammu:washMoney', input[1])
                    end
                end
            },
            {
                title = 'Employee Management',
                description = 'Hire, fire, and promote employees',
                onSelect = function()
                    OpenEmployeeManagement()
                end
            },
            {
                title = 'Salary Management',
                description = 'Manage employee salaries',
                onSelect = function()
                    lib.notify({
                        title = 'Salary Management',
                        description = 'Configure salaries in your ESX config',
                        type = 'info'
                    })
                end
            },
            {
                title = '🏷️ Grade Label Management',
                description = 'View grade information',
                icon = 'star',
                onSelect = function()
                    lib.notify({
                        title = 'Grade Management',
                        description = 'Configure grades in your ESX config',
                        type = 'info'
                    })
                end
            }
        }
    })
    lib.showContext('ammu_boss_menu')
end

-- Employee Management
function OpenEmployeeManagement()
    ESX.TriggerServerCallback('ammu:getOnlineEmployees', function(employees)
        local options = {}

        for _, employee in ipairs(employees) do
            table.insert(options, {
                title = employee.name,
                description = 'Grade: ' .. employee.grade_label .. ' | ID: ' .. employee.identifier,
                icon = 'user',
                onSelect = function()
                    OpenEmployeeActions(employee)
                end
            })
        end

        if #options == 0 then
            table.insert(options, {
                title = 'No employees online',
                description = 'No employees are currently online',
                icon = 'circle-info',
                disabled = true
            })
        end

        lib.registerContext({
            id = 'ammu_employee_list',
            title = '👥 Employee Management',
            menu = 'ammu_boss_menu',
            options = options
        })
        lib.showContext('ammu_employee_list')
    end)
end

-- Employee Actions
function OpenEmployeeActions(employee)
    lib.registerContext({
        id = 'ammu_employee_actions',
        title = employee.name,
        menu = 'ammu_employee_list',
        options = {
            {
                title = '⬆️ Promote',
                description = 'Promote this employee',
                icon = 'circle-up',
                onSelect = function()
                    TriggerServerEvent('ammu:promoteEmployee', employee.identifier)
                end
            },
            {
                title = '⬇️ Demote',
                description = 'Demote this employee',
                icon = 'circle-down',
                onSelect = function()
                    TriggerServerEvent('ammu:demoteEmployee', employee.identifier)
                end
            },
            {
                title = '🔥 Fire',
                description = 'Fire this employee',
                icon = 'user-xmark',
                onSelect = function()
                    TriggerServerEvent('ammu:fireEmployee', employee.identifier)
                end
            }
        }
    })
    lib.showContext('ammu_employee_actions')
end

-- Wardrobe Menu
function OpenWardrobeMenu()
    -- Get the uniform for the current job
    local jobUniforms = Config.Uniforms[currentJob]

    if not jobUniforms then
        lib.notify({
            title = 'Wardrobe',
            description = 'No uniform configured for your job',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'ammu_wardrobe',
        title = '👔 Wardrobe',
        options = {
            {
                title = '👕 Work Uniform',
                description = 'Put on your work uniform',
                icon = 'shirt',
                onSelect = function()
                    local playerPed = PlayerPedId()
                    local model = GetEntityModel(playerPed)

                    if model == GetHashKey('mp_m_freemode_01') then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerEvent('skinchanger:loadClothes', skin, jobUniforms.male)
                        end)
                    elseif model == GetHashKey('mp_f_freemode_01') then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerEvent('skinchanger:loadClothes', skin, jobUniforms.female)
                        end)
                    end

                    lib.notify({
                        title = 'Wardrobe',
                        description = 'You put on your work uniform',
                        type = 'success'
                    })
                end
            },
            {
                title = '👔 Civilian Clothes',
                description = 'Change back to your civilian clothes',
                icon = 'user',
                onSelect = function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)

                    lib.notify({
                        title = 'Wardrobe',
                        description = 'You changed into your civilian clothes',
                        type = 'success'
                    })
                end
            }
        }
    })
    lib.showContext('ammu_wardrobe')
end

-- Weapon Parts Store Menu
function OpenWeaponPartsMenu(location)
    local options = {}
    local availableParts = location.availableParts or {}

    for _, part in ipairs(Config.WeaponParts) do
        -- Check if this part is available at this location
        local isAvailable = false
        for _, availableItem in ipairs(availableParts) do
            if availableItem == part.item then
                isAvailable = true
                break
            end
        end

        if isAvailable then
            table.insert(options, {
                title = part.label,
                description = 'Price: $' .. part.price,
                icon = 'screwdriver-wrench',
                onSelect = function()
                    BuyWeaponPart(part)
                end
            })
        end
    end

    if #options == 0 then
        lib.notify({
            title = 'No Parts Available',
            description = 'This location has no weapon parts in stock',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'ammu_weapon_parts_store',
        title = '🔧 Weapon Parts Store - ' .. location.name,
        options = options
    })
    lib.showContext('ammu_weapon_parts_store')
end

-- Buy Weapon Part Function
function BuyWeaponPart(part)
    ESX.TriggerServerCallback('ammu:checkMoney', function(hasMoney)
        if not hasMoney then
            lib.notify({
                title = 'Insufficient Funds',
                description = 'You need $' .. part.price .. ' to purchase this',
                type = 'error'
            })
            return
        end

        local playerPed = PlayerPedId()

        if lib.progressCircle({
            duration = part.time,
            position = 'bottom',
            label = 'Gathering ' .. part.label .. '...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_player'
            }
        }) then
            TriggerServerEvent('ammu:buyWeaponPart', part.item, part.price)
        else
            lib.notify({
                title = 'Cancelled',
                description = 'You cancelled the purchase',
                type = 'error'
            })
        end
    end, part.price)
end

-- Ammo Store Menu
function OpenAmmoMenu(location)
    local options = {}
    local availableAmmo = location.availableAmmo or {}

    for _, ammo in ipairs(Config.Ammunition) do
        -- Check if this ammo is available at this location
        local isAvailable = false
        for _, availableItem in ipairs(availableAmmo) do
            if availableItem == ammo.item then
                isAvailable = true
                break
            end
        end

        if isAvailable then
            table.insert(options, {
                title = ammo.label,
                description = 'Price: $' .. ammo.price .. ' | Amount: ' .. ammo.amount,
                icon = 'circle',
                onSelect = function()
                    BuyAmmo(ammo)
                end
            })
        end
    end

    if #options == 0 then
        lib.notify({
            title = 'No Ammo Available',
            description = 'This location has no ammunition in stock',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'ammu_ammo_store',
        title = '💥 Ammunition Store - ' .. location.name,
        options = options
    })
    lib.showContext('ammu_ammo_store')
end

-- Buy Ammo Function
function BuyAmmo(ammo)
    ESX.TriggerServerCallback('ammu:checkMoney', function(hasMoney)
        if not hasMoney then
            lib.notify({
                title = 'Insufficient Funds',
                description = 'You need $' .. ammo.price .. ' to purchase this',
                type = 'error'
            })
            return
        end

        local playerPed = PlayerPedId()

        if lib.progressCircle({
            duration = ammo.time,
            position = 'bottom',
            label = 'Packing ' .. ammo.label .. '...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
                clip = 'weed_inspecting_high_base_inspector'
            }
        }) then
            TriggerServerEvent('ammu:buyAmmo', ammo.item, ammo.price, ammo.amount)
        else
            lib.notify({
                title = 'Cancelled',
                description = 'You cancelled the purchase',
                type = 'error'
            })
        end
    end, ammo.price)
end

-- Crafting Menu
function OpenCraftingMenu(location)
    local options = {}
    local availableRecipes = location.availableRecipes or {}

    for _, recipe in ipairs(Config.CraftingRecipes) do
        -- Check if this recipe is available at this location
        local isAvailable = false
        for _, availableWeapon in ipairs(availableRecipes) do
            if availableWeapon == recipe.name then
                isAvailable = true
                break
            end
        end

        if isAvailable then
            local requirementsText = 'Required:\n'
            for i, req in ipairs(recipe.requires) do
                requirementsText = requirementsText .. '• ' .. req.count .. 'x ' .. req.item
                if i < #recipe.requires then
                    requirementsText = requirementsText .. '\n'
                end
            end

            table.insert(options, {
                title = recipe.label,
                description = requirementsText,
                icon = 'hammer',
                onSelect = function()
                    CraftWeapon(recipe)
                end
            })
        end
    end

    if #options == 0 then
        lib.notify({
            title = 'No Recipes Available',
            description = 'This location cannot craft any weapons',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'ammu_crafting',
        title = '🔧 Craft Weapons - ' .. location.name,
        options = options
    })
    lib.showContext('ammu_crafting')
end

-- Craft Weapon Function
function CraftWeapon(recipe)
    ESX.TriggerServerCallback('ammu:canCraft', function(canCraft)
        if canCraft then
            local playerPed = PlayerPedId()

            if lib.progressCircle({
                duration = recipe.time,
                position = 'bottom',
                label = 'Crafting ' .. recipe.label .. '...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                    clip = 'machinic_loop_mechandplayer'
                },
                prop = {
                    model = 'prop_tool_screwdvr01',
                    bone = 57005,
                    pos = vec3(0.12, 0.04, 0.01),
                    rot = vec3(90.0, 0.0, 90.0)
                }
            }) then
                TriggerServerEvent('ammu:craftWeapon', recipe)
            else
                lib.notify({
                    title = 'Cancelled',
                    description = 'You stopped crafting',
                    type = 'error'
                })
            end
        else
            lib.notify({
                title = 'Cannot Craft',
                description = 'You don\'t have the required materials',
                type = 'error'
            })
        end
    end, recipe)
end

-- Load animation dictionary
function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Client-side weapon give (fallback method)
RegisterNetEvent('ammu:giveWeaponClient')
AddEventHandler('ammu:giveWeaponClient', function(weaponHash)
    local playerPed = PlayerPedId()
    local weaponHashNum = GetHashKey(weaponHash)

    -- Give weapon directly to ped
    GiveWeaponToPed(playerPed, weaponHashNum, 50, false, true)

    -- Set as current weapon
    SetCurrentPedWeapon(playerPed, weaponHashNum, true)
end)

