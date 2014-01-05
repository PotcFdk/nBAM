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

NBAM_UPDATEGROUP = "nBAM_UpdateGroup"
NBAM_REQ_UPDATEGROUP = "nBAM_RequestUpdateGroup"

local hook = require 'nbamHook'

local default_group = 'player'

local fn		 = 'groups.txt'
local fn_default = 'groups.default.txt'

hook.Add('preinit', 'groups', function ()
	function nBAM:LoadGroups ()
		self.groups = {}
		
		local fh = io.open(fn, 'r')

		if not fh then
			self:Log('groups', string.format("Could not find '%s', loading default group file...", fn))
			fh = io.open(fn_default, 'r')
			if not fh then
				self:Log('groups', 'Error: Could not open group lists!')
				return
			end
		end
		
		for ln in fh:lines() do
			steam_id, group = string.match(ln, "^(STEAM_%d:%d:%d+)%s*|%s*([^ ]+)")
			if steam_id and group then
				self:SetGroup(steam_id, group)
			end
		end
		
		fh:close()
	end
	
	function nBAM:GetGroup (player)
		if self:IsPlayer(player) then
			player = player:GetSteamId()
		elseif self:IsString(player) then
			player = SteamId(player)
		end
		assert(self:IsSteamId(player), 'Parameter #1 is not a Player entity or a SteamId!')
		return self.groups[tostring(player)] or default_group
	end
	
	function nBAM:SetGroup (player, group)
		if self:IsPlayer(player) then
			player = player:GetSteamId()
		elseif self:IsString(player) then
			player = SteamId(player)
		end
		assert(self:IsSteamId(player), 'Parameter #1 is not a Player entity or a SteamId!')
		assert(self:IsString(group), 'Parameter #2 is not a valid groupname!')
		self.groups[tostring(player)] = group
		self:Log('groups', string.format("Added user '%s' to group '%s'.", tostring(player), group))
		Events:Fire(NBAM_UPDATEGROUP, {
			player = tostring(player),
			group = group
		})
	end
	
	function nBAM:FireUpdateGroup (player)
		if self:IsPlayer(player) then
			player = player:GetSteamId()
		elseif self:IsString(player) then
			player = SteamId(player)
		end
		assert(self:IsSteamId(player), 'Parameter #1 is not a Player entity or a SteamId!')
		Events:Fire(NBAM_UPDATEGROUP, {
			player = tostring(player),
			group = self:GetGroup(player)
		})
	end
end)

hook.Add('postinit', 'groups', function ()
	-- Init
	
	nBAM:LoadGroups()
	
	-- Hook Events
	
	Events:Subscribe(NBAM_REQ_UPDATEGROUP, nBAM, nBAM.FireUpdateGroup)
	
	-- Interface
	
	function _G.Player:GetGroup ()
		return nBAM:GetGroup(self)
	end
	
	function _G.Player:SetGroup (group)
		return nBAM:GetGroup(self, group)
	end
end)