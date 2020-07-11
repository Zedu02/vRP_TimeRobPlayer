local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")
vRPmisiuni = Proxy.getInterface("vRP_misiuni")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_alogin")
menu = {name="Rob Menu",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
menugigi = {name="Taskuri Menu",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
local robbed = {}
function wasRobbed(targetid)
	for i , v in pairs(robbed) do
		if(robbed[i] == targetid) then
			return true
		end
	end
	return false
end

menu["Rob Player"] = {function(player , choice)
	local user_id = vRP.getUserId({player})
		vRPclient.getNearestPlayer(player,{10},function(nplayer)
		  local nuser_id = vRP.getUserId({nplayer})
		  if nuser_id ~= nil then
			if(not wasRobbed(nuser_id)) then
			vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
				if handcuffed then
					local suma = vRP.getMoney({nuser_id, math.random(1500,2000)}) 
					if(2001 > suma > 0) then
						local jaf = math.random(1 , suma)
						vRP.giveMoney({user_id , jaf})
						vRP.giveMoney({nuser_id , jaf * -1})
						robbed[user_id] = nuser_id
						vRPclient.notify(player , {"[~r~Rob~w~] ~b~Jucatorul a fost jefuit cu succes !\n~g~Ai primit ~w~"..jaf.."$"})
						vRPclient.notify(nplayer , {"[~r~Rob~w~] ~r~Ai fost jefit de ~w~"..jaf.."$"})
						if vRPmisiuni.hasMission({user_id , 3}) then
							vRP.giveMoney({user_id , 1500})
							vRPclient.notify(playerx , {"[~b~Misiuni~w~] ~g~Misiune completata !\n~b~Ai primit~w~ 450$"})
							vRPmisiuni.eraseMission({user_id , 3})
						end

						MySQL.query("vRP/getClan" , {user = user_id} , function(rows , affected)
							if #rows > 0 then
							MySQL.query("vRP/getClan2" , {nume = tostring(rows[1].clan)} , function(rows2 , affected2)
								if(#rows2 > 0) then
									MySql.query("vRP/addpoints" , {suma = 50 , id = rows2[1].id})
									MySql.query("vRP/addcpoints" , {suma = 50 , id = rows2[1].id})
									vRPclient.notify(player , {"[~b~Clanuri~w~] ~g~Clanul tau a fost recompensat cu ~w~50 ~g~clanpoints"})
								end
							end)
						end
					end)
						vRP.closeMenu({player , menu})
						SetTimeout(3600000/2, function()
							TriggerClientEvent('chatMessage', nplayer , "[^7Rob^0] ^4Acum poti fi jefuit din nou !") 
							if(robbed[user_id] ~= nil)then
								robbed[user_id] = nil	
							end
						end)
					else
						vRPclient.notify(player , {"[~r~Rob~w~] ~b~Jucatorul nu are bani !"})
						vRP.closeMenu({player , menu})
					end
				end
			end)
		else
			vRPclient.notify(player , {"[~r~Rob~w~] ~b~Jucatorul a fost jefuit recent !"})
			vRP.closeMenu({player , menu})
		end
		else
			vRPclient.notify(player , {"[~r~Rob~w~] ~b~Niciun jucator in apropiere !"})
			vRP.closeMenu({player , menu})
		end
	end)
end}
menu["Check Robbed"] = {function(player , choice)
vRP.prompt({player, "User Id ?", "", function(player,id)
	local targetid = parseInt(id)
	local targetsource = vRP.getUserSource({targetid})
	if(targetsource) then
		vRPclient.notify(targetsource , {"[~r~Rob~w~] ~r~Jucatorul ~w~"..GetPlayerName(player).." ~r~a dat check sa vada daca ai fost jefuit"})
		local sall = wasRobbed(targetid)
		if(sall) then
		vRPclient.notify(player , {"[~r~Rob~w~] ~r~Jucatorul ~w~"..GetPlayerName(targetsource).." ~r~a fost jefuit recent"})
		else
			vRPclient.notify(player , {"[~r~Rob~w~] ~g~Jucatorul ~w~"..GetPlayerName(targetsource).." ~g~NU a fost jefuit recent"})
		end
	else
	end
end})
end}

menugigi["Jefuieste Jucator"] = {function(player , choice)
	vRP.openMenu({player , menu})
end}
vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		add(menugigi)
	end
end})