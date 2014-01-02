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

local fn		 = 'admins.txt'
local fn_default = 'admins.default.txt'

hook.Add('preinit', 'admins', function ()
	function nBAM:IsAdmin (player)
		if self:IsPlayer(player) then
			player = player:GetSteamId()
		elseif self:IsString(player) then
			player = SteamId(player)
		end
		assert(self:IsSteamId(player), 'Parameter #1 is not a Player entity or a SteamId!')
		return self.admins[tostring(player)]
	end
end)

hook.Add('postinit', 'admins', function (self)
	self.admins = {}
	
	local fh = io.open(fn, 'r')

	if not fh then
		nBAM:Log('admins', string.format("Could not find '%s', loading default admin file...", fn))
		fh = io.open(fn_default, 'r')
		if not fh then
			nBAM:Log('admins', 'Error: Could not open admin lists!')
			return
		end
	end
	
	for ln in fh:lines() do
		self.admins[ln] = true
		self:Log('admins', 'Added admin: ' .. ln)
	end
	
	fh:close()
end)