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

local function chatCMD (data)
	local text   = data.text
	local player = data.player
	
	local cmd = string.match(text, "^[!/.~]([^%s]+)")
	if cmd then
		local params_str = string.sub(text, string.len(cmd)+3)
		local params = {}
		for param in string.gmatch(params_str, "[^,]+") do
			table.insert(params, param)
		end
		return hook.Call('chat_command', player, cmd, unpack(params))
	end
end

Events:Subscribe("PlayerChat", chatCMD)