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

local function existsChild (obj, child)
	local ok, typ = pcall(function() return type(obj[child]) end)
	if not ok then return false end
	if typ == 'nil' then return false end
	return typ
end

hook.Add('preinit', 'IsType', function()
	function nBAM:IsColor (col)
		return type(col) == 'userdata'
			and existsChild(col, 'r') == 'number'
			and existsChild(col, 'g') == 'number'
			and existsChild(col, 'b') == 'number'
			and existsChild(col, 'a') == 'number'
	end
	
	function nBAM:IsFunction (func)
		return type(func) == 'function'
	end

	function nBAM:IsPlayer (ply)
		return type(ply) == 'userdata'
			and existsChild(ply, 'GetSteamId') == 'function'
	end
	
	function nBAM:IsSteamId (sid)
		return type(sid) == 'userdata'
			and existsChild(sid, 'string') == 'string'
			and existsChild(sid, 'id') == 'string'
	end
	
	function nBAM:IsString (str)
		return type(str) == 'string'
	end

	function nBAM:IsTable (tab)
		return type(tab) == 'table'
	end
end)