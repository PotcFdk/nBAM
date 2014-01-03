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

hook.Add('preinit', 'PPrint', function ()
	function nBAM:PPrint (ply, c, ...)
		if not self:IsPlayer(ply) then return end
		
		local color
		if nBAM:IsColor(c) then
			color = c
			c = nil
		else
			color = Color(0xFF, 0xFF, 0xFF, 0xFF)
		end
		
		local print_string
		for _, v in next, {c, ...} do
			print_string = (print_string or "") .. tostring(v)
		end
		
		if not print_string then print_string = "<Empty Value>" end
		
		local first = true
		for ln in string.gmatch(print_string, "[^\n]+") do
			if first then
				Chat:Send(ply, print_string, color)
				first = false
			else
				self:PPrint(ply, color, ln)
			end
		end
	end
end)

hook.Add('postinit', 'PPrint', function()
	pprint = function (...) return nBAM:PPrint(...) end
end)