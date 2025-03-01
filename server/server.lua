local function GetPlayerCid(src)
  local cid = nil

  if Config.Framework == 'qbx' then
    local player = exports.qbx_core:GetPlayer(src)
    cid = player.PlayerData.citizenid
  elseif Config.Framework == 'qb' then
    local qb = exports['qb-core']:GetCoreObject()
    local player = qb.Functions.GetPlayer(src)
    cid = player.PlayerData.citizenid
  elseif Config.Framework == 'esx' then
    local xPlayer = ESX.GetPlayerFromId(src)
    cid = xPlayer.id
  end
  return cid
end

lib.callback.register('tw-rep:server:getRep', function (source)
  local src = source

  local repRow = MySQL.single.await('SELECT `rep` FROM `tw_rep` WHERE `citizen_id` = ?', { GetPlayerCid(src) })

  if repRow then
    return repRow.rep
  else
    TriggerEvent('tw-rep:server:createRepEntry', src)
    return 0
  end

end)

RegisterNetEvent('tw-rep:server:setRep', function(rep)
  local src = source

  local repRow = MySQL.single.await('SELECT `rep` FROM `tw_rep` WHERE `citizen_id` = ?', { GetPlayerCid(src) })

  if repRow then
    MySQL.update.await('UPDATE `tw_rep` SET `rep` = ? WHERE `citizen_id` = ?', { rep, GetPlayerCid(src) })
  else
    TriggerEvent('tw-rep:server:createRepEntry', src)
  end

end)

RegisterNetEvent('tw-rep:server:createRepEntry', function(src)
  MySQL.insert.await('INSERT INTO `tw_rep` (citizen_id) VALUES (?)', {GetPlayerCid(src) })
end)