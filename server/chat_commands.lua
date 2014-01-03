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
	function nBAM:RegisterChatCMDInfo (command, usage, description)
		assert(self:IsString(command), errmsg(1, 'string'))
		assert(self:IsString(usage), errmsg(2, 'string'))
		assert(self:IsString(description), errmsg(3, 'string'))
		self.commandInfo[command] = {usage = usage, description = description}
	end
	
	function nBAM:GetCMDs ()
		return self.commandInfo
	end
	
	function nBAM:GetCMDInfo (command)
		assert(self:IsString(command), errmsg(1, 'string'))
		if not self.commandInfo[command] then return end
		return self.commandInfo[command].usage, self.commandInfo[command].description
	end
	
	function nBAM:chatCMD (data)
		local text   = data.text
		local player = data.player
		
		local cmd = string.match(text, "^[!/.~]([^%s]+)")
		if cmd then
			local params_str = string.sub(text, string.len(cmd)+3)
			local params = {}
			for param in string.gmatch(params_str, "[^,]+") do
				table.insert(params, param)
			end
			return hook.Call('chat_command', player, cmd, params_str, unpack(params))
		end
	end
end)

hook.Add('postinit', 'chat_commands', function(self)
	nBAM.commandInfo = {}
	Events:Subscribe("PlayerChat", self, self.chatCMD)
end)