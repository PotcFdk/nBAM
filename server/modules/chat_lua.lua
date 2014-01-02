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

hook.Add('chat_command', 'lua_sv', function (player, cmd, script)
	if cmd ~= "l" then return end
	if not nBAM:HasPermission(player, 'lua') then return end

	script = load(script)
	local ok, err = pcall(script)
	if not ok then
		cprint(err)
	end
end)

hook.Add('chat_command', 'lua_cl', function (player, cmd, script)
	if cmd ~= "lc" then return end
	if not nBAM:HasPermission(player, 'lua') then return end

	Network:Broadcast("nBAM_runlua", script)
end)