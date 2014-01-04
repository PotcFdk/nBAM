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

local hook = require 'nbamHook'

local function unpack (tab, index)
	index = index or 1
	if tab[index] ~= nil then
		return tab[index], unpack(tab, index + 1)
	end
end

local function errmsg (paramNum, expectedType)
	return string.format('Parameter #%d expected to be %s!', paramNum, expectedType)
end

hook.Add('preinit', 'chat_commands', function()
	function nBAM:RegisterChatCMD (command, usage, description, callback, permission_id)
		assert(self:IsString(command), errmsg(1, 'string'))
		assert(self:IsString(usage), errmsg(2, 'string'))
		assert(self:IsString(description), errmsg(3, 'string'))
		assert(self:IsFunction(callback), errmsg(4, 'function'))
		if not self:IsString(permission_id) then permission_id = command end -- default
		
		nBAM.commands = nBAM.commands or {}
		self.commands[command] = {
			usage = usage,
			description = description,
			callback = callback,
			permission_id = permission_id
		}
	end
	
	function nBAM:ExistsChatCMD(command)
		return self:IsTable(self.commands[command]) and self:IsFunction(self.commands[command].callback)
	end
	
	function nBAM:GetChatCMDs ()
		return self.commands
	end
	
	function nBAM:GetChatCMDInfo (command)
		assert(self:IsString(command), errmsg(1, 'string'))
		if not self.commands[command] then return end
		return self.commands[command].usage, self.commands[command].description
	end
	
	function nBAM:callChatCMD (data)
		local text   = data.text
		local player = data.player
		
		local cmd = string.match(text, "^[!/.~]([^%s]+)")
		if cmd and nBAM:ExistsChatCMD(cmd) then
			local params_str = string.sub(text, string.len(cmd)+3)
			local params = {}
			for param in string.gmatch(params_str, "[^,]+") do
				table.insert(params, param)
			end
			
			local ok, err = pcall(self.commands[cmd].callback, player, cmd, params_str, unpack(params))
			if not ok then
				nBAM:PPrint(player, nBAM.Color.red, "There was an error!")
				nBAM:Log('chat_commands', string.format("Chat command '%s' errored: %s", cmd, err))
				return
			end
		end
	end
end)

hook.Add('postinit', 'chat_commands', function ()
	Events:Subscribe("PlayerChat", nBAM, nBAM.callChatCMD)
end)