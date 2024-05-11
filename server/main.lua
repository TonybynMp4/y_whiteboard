local config = require 'config.shared'

RegisterNetEvent('y_whiteboard:server:changewhiteboard', function(params, roomId)
    local url = params[1]
    local reset = params[2]
    if not url and not reset then return end
    if not config.rooms[roomId] then return end

    local player = exports.qbx_core:GetPlayer(source)
    if not config.rooms[roomId]?.jobs[player.PlayerData.job.name] and not config.rooms[roomId]?.jobTypes[player.PlayerData.job.type] then return end

    TriggerClientEvent('y_whiteboard:client:changewhiteboard', -1, url, roomId, reset)
end)