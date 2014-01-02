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

hook.Add('chat_command', 'bring', function (player, cmd, _, target)
	if cmd ~= "bring" then return end
	if not nBAM:HasPermission(player, 'bring') then return end
	if not nBAM:IsString(target) then return end
	
	local targets = Player.Match(target)
	if #targets <= 0 then
		nBAM:PPrint(player, nBAM.Color.red, "No player found!")
		return
	elseif #targets > 1 then
		nBAM:PPrint(player, nBAM.Color.red, "Multiple players found!")
		return
	end
	
	targets[1]:Teleport(player:GetAimTarget().position, -player:GetAngle())
end)