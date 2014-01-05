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

NBAM_UPDATEPERMISSION = "nBAM_UpdatePermission"
NBAM_REQ_UPDATEPERMISSION = "nBAM_RequestUpdatePermission"

local hook = require 'nbamHook'
local json = require 'dkjson'

local fn		 = 'permissions.txt'
local fn_default = 'permissions.default.txt'


local function errmsg (paramNum, expectedType)
	return string.format('Parameter #%d expected to be %s!', paramNum, expectedType)
end

hook.Add('preinit', 'permissions', function ()
	function nBAM:LoadPermissions ()
		local fh = io.open(fn, 'r')

		if not fh then
			self:Log('permissions', string.format("Could not find '%s', loading default permissions file...", fn))
			fh = io.open(fn_default, 'r')
			if not fh then
				self:Log('permissions', 'Error: Could not open admin lists!')
				return
			end
		end
		
		local data = fh:read("*all")
		fh:close()
		
		data = json.decode(data)
		
		if not self:IsTable(data) then
			self:Log('permissions', 'Error in json file!')
			return
		end
		
		self.permissions = data.permissions or {}
	end
	
	function nBAM:HasPermission (what, module)
		assert(self:IsString(what) or self:IsPlayer(what) or self:IsSteamId(), errmsg(1, 'string, player or steamid'))
		assert(self:IsString(module), errmsg(2, 'string'))
		
		local group
		
		if self:IsString(what) then
			group = what
		else
			group = self:GetGroup(what)
		end
		
		if not self:IsTable(self.permissions) or not self:IsTable(self.permissions[group]) then return end
		
		for _, permission in next, self.permissions[group] do
			if permission == module then return true end
		end
		
		return false
	end
	
	function nBAM:FireUpdatePermission (data)
		local player, permission = data.player, data.permission
		if self:IsPlayer(player) then
			player = player:GetSteamId()
		elseif self:IsString(player) then
			player = SteamId(player)
		end
		assert(self:IsSteamId(player), "Parameter 'player' is not a Player entity or a SteamId!")
		assert(self:IsString(permission), "Parameter 'permission' is not a string!")
		Events:Fire(NBAM_UPDATEPERMISSION, {
			player = tostring(player),
			permission = permission, 
			has_permission = nBAM:HasPermission(player, permission)
		})
	end
end)

hook.Add('postinit', 'permissions', function ()
	-- Init
	
	nBAM:LoadPermissions()
	
	-- Hook Events
	
	Events:Subscribe(NBAM_REQ_UPDATEPERMISSION, nBAM, nBAM.FireUpdatePermission)
	
	-- Interface
	
	function _G.Player:HasPermission (permission)
		return nBAM:HasPermission(self, permission)
	end
end)