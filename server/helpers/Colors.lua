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

hook.Add('preinit', 'Color', function ()
	nBAM.Color = {}
	nBAM.Colors = nBAM.Color
	
	local col = nBAM.Color
	
	col.red       = Color(255,   0,   0)
	col.green     = Color(  0, 255,   0)
	col.blue      = Color(  0,   0, 255)
	col.yellow    = Color(255, 255,   0)
	
	col.lred      = Color(255, 190, 190)
	col.lgreen    = Color(190, 255, 190)
	col.lblue     = Color(190, 190, 255)
end)