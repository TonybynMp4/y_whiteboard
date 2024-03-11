local config = require 'config.shared'
local rooms = {}
local currentRoom

local function createDui(roomId, width, height)
    local url = rooms[roomId].url
    width = width or 512
    height = height or 512

    local duiSize = width .. "x" .. height
    local generatedDictName = duiSize .. "-dict-" .. tostring(roomId)
    local generatedTxtName = duiSize .. "-txt-" .. tostring(roomId)
    rooms[roomId].duiObject = CreateDui(url, width, height)
    local dictObject = CreateRuntimeTxd(generatedDictName)
    local duiHandle = GetDuiHandle(rooms[roomId].duiObject)
    local txdObject = CreateRuntimeTextureFromDuiHandle(dictObject, generatedTxtName, duiHandle)

    rooms[roomId].dui = {
        dictionary = generatedDictName,
        texture = generatedTxtName,
        txdObject = txdObject,
    }
end

local function changeDuiUrl(roomId, url)
    if not rooms[roomId] then
        return
    end
    if not rooms[roomId].duiObject then
        createDui(roomId, 1024, 1024)
        AddReplaceTexture(rooms[roomId].txd, rooms[roomId].txn, rooms[roomId].dui.dictionary, rooms[roomId].dui.texture)
        return
    end

    SetDuiUrl(rooms[roomId].duiObject, url)
end

RegisterNetEvent("qbx_whiteboard:client:changewhiteboard", function(url, roomId, reset)
    rooms[roomId].url = reset and nil or url
    if currentRoom and currentRoom == roomId then
        if reset then
            if rooms[roomId].duiObject then
                RemoveReplaceTexture(rooms[roomId].txd, rooms[roomId].txn)
                DestroyDui(rooms[roomId].duiObject)
                rooms[roomId].duiObject = nil
                rooms[roomId].dui = nil
            end
            return
        end
        changeDuiUrl(roomId, rooms[roomId].url)
    end
end)

CreateThread(function()
    for k, v in pairs(config.rooms) do
        rooms[k] = v
        lib.zones.poly({
            points = v.zone,
            thickness = 3.0,
            onEnter = function()
                currentRoom = k
                if rooms[k].url then
                    createDui(k, 1024, 1024)
                    AddReplaceTexture(v.txd, v.txn, rooms[k].dui.dictionary, rooms[k].dui.texture)
                end
            end,
            onExit = function()
                if rooms[k].duiObject then
                    RemoveReplaceTexture(v.txd, v.txn)
                    DestroyDui(rooms[k].duiObject)
                    rooms[k].duiObject = nil
                    rooms[k].dui = nil
                end
                currentRoom = nil
            end
        })
        exports.ox_target:addBoxZone({
            coords = v.target.coords,
            size = v.target.size,
            rotation = v.target.rotation,
            drawSprite = true,
            options = {
                {
                    label = locale('target.label'),
                    icon = "fa fa-camera",
                    canInteract = function()
                        return rooms[k].jobs[QBX.PlayerData.job.name] and rooms[k].jobTypes[QBX.PlayerData.job.type]
                    end,
                    onSelect = function ()
                        local input = lib.inputDialog(locale('input.title'), {
                            {type = 'input', label = locale('input.url')},
                            {type =  'checkbox', label = locale('input.reset'), description = locale('input.reset_description'), value = false}
                        })

                        if input then
                            TriggerServerEvent("qbx_whiteboard:server:changewhiteboard", input, k)
                        end
                    end,
                },
            },
        })

    end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        for _, v in pairs(rooms) do
            if v.duiObject then
                RemoveReplaceTexture(v.txd, v.txn)
                DestroyDui(v.duiObject)
            end
        end
   end
end)