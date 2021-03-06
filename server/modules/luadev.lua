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

local Tag = 'lua'

NBAM_RUNLUA_SV   = "nBAM_RunLua_SV"
NBAM_RUNLUA_CL   = "nBAM_RunLua_CL"
NBAM_RUNLUA_SELF = "nBAM_RunLua_SELF"

NBAM_LUA_ERROR_SV = "nBAM_LuaError_SV"
NBAM_LUA_ERROR_CL = "nBAM_LuaError_CL"

local easylua = require 'easylua'
local hook = require 'nbamHook'

hook.Add('preinit', Tag, function ()
	-- RunLua
	
	function nBAM:RunLua_SV (data, pl)
		local player = pl or data.player
		local script = data.script
		local source = tostring(player)
		
		if not self:HasPermission(player, Tag) then return end
		
		self:Log(Tag, string.format("(SV) Running script by '%s'...", tostring(player)))
		
		local _ENV = easylua.GetEnv(player)
		script = load(script, source, nil, _ENV)
		local ok, err = pcall(script)
		
		if not ok then
			self:OnLuaError_SV (player, err, data.error_to_chat)
		end
	end
	
	function nBAM:RunLua_CL (data, pl)
		local player = pl or data.player
		local script = data.script
		if not self:HasPermission(player, Tag) then return end
		
		self:Log(Tag, string.format("(CL) Running script by '%s'...", tostring(player)))
		Network:Broadcast("nBAM_runlua", {player = player, script = script})
	end
	
	function nBAM:RunLua_SELF (data, pl)
		local player = pl or data.player
		local script = data.script
		if not self:HasPermission(player, Tag) then return end
		
		Network:Send(player, "nBAM_runlua", {player = player, script = script})
	end
	
	-- OnLuaError
	
	function nBAM:OnLuaError_SV (player, err, error_to_chat)
		if error_to_chat then
			cprint(nBAM.Color.lred, err)
		end
		hook.Run(NBAM_LUA_ERROR_SV, player, err)
	end
	
	function nBAM:OnLuaError_CL (data, player)
		local source_player = data.source_player
		local err = data.error
		hook.Run(NBAM_LUA_ERROR_CL, player, err, source_player)
	end
end)

hook.Add('postinit', Tag, function ()
	Events:Subscribe(NBAM_RUNLUA_SV, nBAM, nBAM.RunLua_SV)
	Events:Subscribe(NBAM_RUNLUA_CL, nBAM, nBAM.RunLua_CL)
	Events:Subscribe(NBAM_RUNLUA_SELF, nBAM, nBAM.RunLua_SELF)
	Network:Subscribe(NBAM_RUNLUA_SV, nBAM, nBAM.RunLua_SV)
	Network:Subscribe(NBAM_RUNLUA_CL, nBAM, nBAM.RunLua_CL)
	Network:Subscribe(NBAM_RUNLUA_SELF, nBAM, nBAM.RunLua_SELF)
	Network:Subscribe(NBAM_LUA_ERROR_CL, nBAM, nBAM.OnLuaError_CL)
end)

hook.Add(NBAM_LUA_ERROR_SV, Tag, function (player, err)
	Events:Fire(NBAM_LUA_ERROR_SV, {player = player, error = err})
end)

hook.Add(NBAM_LUA_ERROR_CL, Tag, function (player, err, source_player)
	Events:Fire(NBAM_LUA_ERROR_CL, {player = player, error = err, source_player = source_player})
end)