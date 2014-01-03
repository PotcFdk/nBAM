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


local loadedHelp = false
local loadedNet = false

local appendix

local function addHelpEntry()
	-- Not sure what arrives first; this will make sure that everything is there when we need it.
	if not loadedHelp or not loadedNet then return end
	
	Events:Fire( "HelpAddItem",
		{
			name = "nBAM",
			text =
			[[nBAM - the 'non-Bullshit-Admin-Mod' is a WIP Adminmod.

			Here is a list of commands:
			(This following list is auto-generated and only shows commands that you have access to!)]]
			.. '\n\n' .. appendix
		} )
end

Events:Subscribe("ModuleLoad", function ()
	loadedHelp = true
	addHelpEntry()
end)

Network:Subscribe("nBAM_helpEntry", function (txt)
	appendix = txt
	loadedNet = true
	addHelpEntry()
end)