--[[
  Copyright 2014 - The nBAM Team
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
  http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
]]--

local Tag = 'kick'
local usage = '!kick <player>[,reason]'
local description = 'Kicks a player. If a reason is provided, it is used as the kick message.'

local hook = require 'nbamHook'

hook.Add('postinit', Tag, function()
	nBAM:RegisterChatCMD(Tag, usage, description, function (player, cmd, _, target, kick_msg)
		if not nBAM:HasPermission(player, Tag) then return end
		if not nBAM:IsString(target) then return end
		
		local targets = Player.Match(target)
		if #targets <= 0 then
			nBAM:PPrint(player, nBAM.Color.red, "No player found!")
			return
		elseif #targets > 1 then
			nBAM:PPrint(player, nBAM.Color.red, "Multiple players found:")
			for _, ply in next, targets do
				nBAM:PPrint(player, nBAM.Color.lred, " - " .. ply:GetName())
			end
			return
		end
		
		if not nBAM:IsString(kick_msg) or string.len(kick_msg) < 3 then
			kick_msg = 'Kicked by Admin'
		end
		
		kick_msg = kick_msg .. string.format('\n\n(Kicked by %s | %s)', player:GetName(), player:GetSteamId())
		
		targets[1]:Kick(kick_msg)
	end)
end)