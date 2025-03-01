RegisterCommand('getrep', function()
  local rep = lib.callback.await('tw-rep:server:getRep')

  print('Your Rep Is... ' .. rep)

end, false)

RegisterCommand('setrep', function(_, args)
  local newRep = tonumber(args[1])

  if newRep then
    TriggerServerEvent('tw-rep:server:setRep', newRep)
  else
    print('Input invalid...')
  end

end, false)