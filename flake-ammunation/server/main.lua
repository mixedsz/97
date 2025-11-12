local ESX = exports['es_extended']:getSharedObject()

-- Helper function to check if player has an allowed job
function IsJobAllowed(jobName)
    for _, location in ipairs(Config.Locations) do
        -- If location has no job restrictions, allow all
        if #location.jobs == 0 then
            return true
        end
        -- Check if job is in allowed jobs list
        for _, allowedJob in ipairs(location.jobs) do
            if jobName == allowedJob then
                return true
            end
        end
    end
    return false
end

-- Check if player has enough money
ESX.RegisterServerCallback('ammu:checkMoney', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        cb(false)
        return
    end

    cb(xPlayer.getMoney() >= amount)
end)

-- Get Society Money
ESX.RegisterServerCallback('ammu:getSocietyMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if IsJobAllowed(xPlayer.job.name) then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
            if account then
                cb(account.money)
            else
                cb(0)
            end
        end)
    else
        cb(0)
    end
end)

-- Withdraw Money
RegisterNetEvent('ammu:withdrawMoney')
AddEventHandler('ammu:withdrawMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
        if account and account.money >= amount then
            account.removeMoney(amount)
            xPlayer.addMoney(amount)
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Withdrawal Successful',
                description = 'You withdrew $' .. ESX.Math.GroupDigits(amount),
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Insufficient Funds',
                description = 'The society account doesn\'t have enough money',
                type = 'error'
            })
        end
    end)
end)

-- Deposit Money
RegisterNetEvent('ammu:depositMoney')
AddEventHandler('ammu:depositMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    if xPlayer.getMoney() >= amount then
        xPlayer.removeMoney(amount)

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
            if account then
                account.addMoney(amount)
                
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Deposit Successful',
                    description = 'You deposited $' .. ESX.Math.GroupDigits(amount),
                    type = 'success'
                })
            end
        end)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Insufficient Funds',
            description = 'You don\'t have enough money',
            type = 'error'
        })
    end
end)

-- Wash Money
RegisterNetEvent('ammu:washMoney')
AddEventHandler('ammu:washMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    local blackMoney = xPlayer.getAccount('black_money').money

    if blackMoney >= amount then
        xPlayer.removeAccountMoney('black_money', amount)

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
            if account then
                -- Wash at 75% rate (25% loss)
                local cleanAmount = math.floor(amount * 0.75)
                account.addMoney(cleanAmount)
                
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Money Washed',
                    description = 'Washed $' .. ESX.Math.GroupDigits(amount) .. ' into $' .. ESX.Math.GroupDigits(cleanAmount),
                    type = 'success'
                })
            end
        end)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Insufficient Funds',
            description = 'You don\'t have enough black money',
            type = 'error'
        })
    end
end)

-- Get Online Employees
ESX.RegisterServerCallback('ammu:getOnlineEmployees', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        cb({})
        return
    end

    local employees = {}
    local xPlayers = ESX.GetExtendedPlayers('job', xPlayer.job.name)
    
    for _, employee in pairs(xPlayers) do
        table.insert(employees, {
            identifier = employee.identifier,
            name = employee.getName(),
            grade = employee.job.grade,
            grade_label = employee.job.grade_label
        })
    end
    
    cb(employees)
end)

-- Promote Employee
RegisterNetEvent('ammu:promoteEmployee')
AddEventHandler('ammu:promoteEmployee', function(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    if xTarget then
        if xTarget.job.grade < #ESX.Jobs[xPlayer.job.name].grades - 1 then
            xTarget.setJob(xPlayer.job.name, xTarget.job.grade + 1)
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Employee Promoted',
                description = xTarget.getName() .. ' has been promoted',
                type = 'success'
            })
            
            TriggerClientEvent('ox_lib:notify', xTarget.source, {
                title = 'Promoted',
                description = 'You have been promoted!',
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Cannot Promote',
                description = 'Employee is already at max grade',
                type = 'error'
            })
        end
    end
end)

-- Demote Employee
RegisterNetEvent('ammu:demoteEmployee')
AddEventHandler('ammu:demoteEmployee', function(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    if xTarget then
        if xTarget.job.grade > 0 then
            xTarget.setJob(xPlayer.job.name, xTarget.job.grade - 1)
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Employee Demoted',
                description = xTarget.getName() .. ' has been demoted',
                type = 'success'
            })
            
            TriggerClientEvent('ox_lib:notify', xTarget.source, {
                title = 'Demoted',
                description = 'You have been demoted',
                type = 'inform'
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Cannot Demote',
                description = 'Employee is already at lowest grade',
                type = 'error'
            })
        end
    end
end)

-- Fire Employee
RegisterNetEvent('ammu:fireEmployee')
AddEventHandler('ammu:fireEmployee', function(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    local isBoss = false
    for _, grade in ipairs(Config.BossGrades) do
        if xPlayer.job.grade == grade then
            isBoss = true
            break
        end
    end

    if not isBoss then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You are not authorized to do this',
            type = 'error'
        })
        return
    end

    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    if xTarget then
        xTarget.setJob('unemployed', 0)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Employee Fired',
            description = xTarget.getName() .. ' has been fired',
            type = 'success'
        })

        TriggerClientEvent('ox_lib:notify', xTarget.source, {
            title = 'Fired',
            description = 'You have been fired from your job',
            type = 'error'
        })
    end
end)

-- Buy Weapon Part
RegisterNetEvent('ammu:buyWeaponPart')
AddEventHandler('ammu:buyWeaponPart', function(item, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    -- Check if item exists in config
    local validItem = false
    for _, part in ipairs(Config.WeaponParts) do
        if part.item == item and part.price == price then
            validItem = true
            break
        end
    end

    if not validItem then
        return
    end

    -- Check if player has enough money
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Purchase Successful',
            description = 'You purchased weapon parts for $' .. price,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Insufficient Funds',
            description = 'You don\'t have enough money',
            type = 'error'
        })
    end
end)

-- Buy Ammo
RegisterNetEvent('ammu:buyAmmo')
AddEventHandler('ammu:buyAmmo', function(item, price, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    -- Check if item exists in config
    local validItem = false
    for _, ammo in ipairs(Config.Ammunition) do
        if ammo.item == item and ammo.price == price then
            validItem = true
            break
        end
    end

    if not validItem then
        return
    end

    -- Check if player has enough money
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, amount)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Purchase Successful',
            description = 'You purchased ' .. amount .. 'x ammunition for $' .. price,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Insufficient Funds',
            description = 'You don\'t have enough money',
            type = 'error'
        })
    end
end)

-- Check if player can craft
ESX.RegisterServerCallback('ammu:canCraft', function(source, cb, recipe)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        cb(false)
        return
    end

    local canCraft = true

    for _, requirement in ipairs(recipe.requires) do
        local item = xPlayer.getInventoryItem(requirement.item)
        if not item or item.count < requirement.count then
            canCraft = false
            break
        end
    end

    cb(canCraft)
end)

-- Craft Weapon
RegisterNetEvent('ammu:craftWeapon')
AddEventHandler('ammu:craftWeapon', function(recipe)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsJobAllowed(xPlayer.job.name) then
        return
    end

    -- Double check materials
    local canCraft = true
    for _, requirement in ipairs(recipe.requires) do
        local item = xPlayer.getInventoryItem(requirement.item)
        if not item or item.count < requirement.count then
            canCraft = false
            break
        end
    end

    if not canCraft then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cannot Craft',
            description = 'You don\'t have the required materials',
            type = 'error'
        })
        return
    end

    -- Remove materials
    for _, requirement in ipairs(recipe.requires) do
        xPlayer.removeInventoryItem(requirement.item, requirement.count)
    end

    -- Give weapon - Try multiple methods for compatibility
    local weaponGiven = false

    -- Prepare weapon names in different formats
    local weaponNameUpper = recipe.name -- WEAPON_PISTOL
    local weaponNameLower = string.lower(recipe.name) -- weapon_pistol

    -- Method 1: Try ox_inventory export with lowercase name
    if not weaponGiven then
        local success, result = pcall(function()
            if exports.ox_inventory then
                return exports.ox_inventory:AddItem(source, weaponNameLower, 1)
            end
            return false
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 2: Try ox_inventory export with uppercase name
    if not weaponGiven then
        local success, result = pcall(function()
            if exports.ox_inventory then
                return exports.ox_inventory:AddItem(source, weaponNameUpper, 1)
            end
            return false
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 3: Try ESX addWeapon with uppercase (for ESX Legacy with default inventory)
    if not weaponGiven and xPlayer.addWeapon then
        local success, result = pcall(function()
            xPlayer.addWeapon(weaponNameUpper, 50)
            return true
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 4: Try ESX addWeapon with lowercase
    if not weaponGiven and xPlayer.addWeapon then
        local success, result = pcall(function()
            xPlayer.addWeapon(weaponNameLower, 50)
            return true
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 5: Try adding as inventory item with lowercase
    if not weaponGiven and xPlayer.addInventoryItem then
        local success, result = pcall(function()
            xPlayer.addInventoryItem(weaponNameLower, 1)
            return true
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 6: Try adding as inventory item with uppercase
    if not weaponGiven and xPlayer.addInventoryItem then
        local success, result = pcall(function()
            xPlayer.addInventoryItem(weaponNameUpper, 1)
            return true
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 7: Try qs-inventory with lowercase
    if not weaponGiven then
        local success, result = pcall(function()
            if exports['qs-inventory'] then
                return exports['qs-inventory']:AddItem(source, weaponNameLower, 1)
            end
            return false
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 8: Try qs-inventory with uppercase
    if not weaponGiven then
        local success, result = pcall(function()
            if exports['qs-inventory'] then
                return exports['qs-inventory']:AddItem(source, weaponNameUpper, 1)
            end
            return false
        end)
        if success and result then
            weaponGiven = true
        end
    end

    -- Method 9: Last resort - try client-side weapon give
    if not weaponGiven then
        TriggerClientEvent('ammu:giveWeaponClient', source, weaponNameUpper)
        Wait(500) -- Give client time to process
        weaponGiven = true
    end

    if weaponGiven then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Weapon Crafted',
            description = 'You crafted a ' .. recipe.label,
            type = 'success'
        })
    else
        -- If all methods failed, refund materials
        for _, requirement in ipairs(recipe.requires) do
            xPlayer.addInventoryItem(requirement.item, requirement.count)
        end

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Crafting Failed',
            description = 'Could not add weapon to inventory. Materials refunded.',
            type = 'error'
        })
    end
end)

