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

easylua   = {}
easylua.o = {}

local caller

local shortcuts = {
	me = function(ply) return ply end,
	there = function(ply) return ply:GetAimTarget().position end,
	this = function(ply) return ply:GetAimTarget().player or ply:GetAimTarget().vehicle end
}

local META = {
	__index = function (t, key)
		if shortcuts[key] then
			return shortcuts[key](caller)
		elseif rawget(t, key) ~= nil then
			return t[key]
		else
			local matches = Player.Match(key)
			if #matches == 1 then
				return matches[1]
			end
		end
	end,
	__newindex = function (t, key, val)
		if shortcuts[key] then return end
		rawset(t, key, val)
	end
}

function easylua.Start(ply)
	if caller ~= nil then
		print("[easylua] !! RESTARTING INCOMPLETE SESSION FOR ",ply)
		easylua.End()
	end
	
	caller = ply
	easylua.o = _G
	_G = setmetatable(_G, META)
end

function easylua.End()
	_G = easylua.o
	caller = nil
end