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

local shortcuts = {
	me = function(ply) return ply end,
	there = function(ply) return ply:GetAimTarget().position end,
	this = function(ply) return ply:GetAimTarget().player or ply:GetAimTarget().vehicle end
}

function easylua.Start(ply)
	for k, v in next, shortcuts do
		easylua.o[k] = _G[k]
		_G[k] = v(ply)
	end
end

function easylua.End()
	for k, v in next, easylua.o do
		_G[k] = v
		easylua.o[k] = nil
	end
end