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

local function sendContent(player)
	local list = ""
	
	for k, v in next, nBAM:GetCMDs() do
		if nBAM:HasPermission(player, k) then
			list = list .. '\n\n'
				.. '!' .. k .. '  -  ' .. v.usage .. '\n  '
				.. v.description
		end
	end
	
	Network:Send(player, "nBAM_helpEntry", list)
end

local function onJoin(args)
	sendContent(args.player)
end

Events:Subscribe("PlayerJoin", onJoin)