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

hook.Add('preinit', 'IsType', function()
	function nBAM:IsFunction (func)
		return type(func) == 'function'
	end

	function nBAM:IsPlayer (ply)
		return type(ply) == "userdata" and type(ply.GetSteamId) == "function"
	end
	
	function nBAM:IsSteamId (sid)
		return type(sid) == "userdata" and type(sid.string) == "string" and type(sid.id) == "string"
	end
	
	function nBAM:IsString (str)
		return type(str) == 'string'
	end

	function nBAM:IsTable (tab)
		return type(tab) == 'table'
	end
end)