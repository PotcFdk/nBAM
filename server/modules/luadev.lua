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

local easylua = require 'easylua'
local hook = require 'nbamHook'

hook.Add('preinit', Tag, function ()
	function nBAM:RunLua_SV (data, pl)
		local player = pl or data.player
		local script = data.script
		if not self:HasPermission(player, Tag) then return end
		
		self:Log(Tag, string.format("(SV) Running script by '%s'...", tostring(player)))
		
		script = load(script)
		
		easylua.Start(player)
		local ok, err = pcall(script)
		easylua.End()
		
		if not ok then
			cprint(self.Color.lred, err)
		end
	end
	
	function nBAM:RunLua_CL (data, pl)
		local player = pl or data.player
		local script = data.script
		if not self:HasPermission(player, Tag) then return end
		
		self:Log(Tag, string.format("(CL) Running script by '%s'...", tostring(player)))
		Network:Broadcast("nBAM_runlua", script)
	end
	
	function nBAM:RunLua_SELF (data, pl)
		local player = pl or data.player
		local script = data.script
		if not self:HasPermission(player, Tag) then return end
		
		Network:Send(player, "nBAM_runlua", script)
	end
end)

hook.Add('postinit', Tag, function ()
	Events:Subscribe(NBAM_RUNLUA_SV, nBAM, nBAM.RunLua_SV)
	Events:Subscribe(NBAM_RUNLUA_CL, nBAM, nBAM.RunLua_CL)
	Events:Subscribe(NBAM_RUNLUA_SELF, nBAM, nBAM.RunLua_SELF)
	Network:Subscribe(NBAM_RUNLUA_SV, nBAM, nBAM.RunLua_SV)
	Network:Subscribe(NBAM_RUNLUA_CL, nBAM, nBAM.RunLua_CL)
	Network:Subscribe(NBAM_RUNLUA_SELF, nBAM, nBAM.RunLua_SELF)
end)