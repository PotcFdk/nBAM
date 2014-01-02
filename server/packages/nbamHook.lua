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

local isfunction = function (func) return type(func) == 'function' end
local isstring = function (str) return type(str) == 'string' end
local istable = function (tab) return type(tab) == 'table' end

local function errmsg (paramNum, expectedType)
	return string.format('Parameter #%d expected to be %s!', paramNum, expectedType)
end

package.loaded.nbamHook = {}
local hook = package.loaded.nbamHook

local hooks = {}

function hook.Add (hookname, id, callback)
	assert(isstring(hookname), errmsg(1, 'string'))
	assert(isstring(id), errmsg(2, 'string'))
	assert(isfunction(callback), errmsg(3, 'function'))
	hooks[hookname] = hooks[hookname] or {}
	hooks[hookname][id] = callback
end

function hook.Call (hookname, ...)
	assert(isstring(hookname), errmsg(1, 'string'))
	if not istable(hooks[hookname]) then return end
	for k, v in next, hooks[hookname] do
		local ok, err = pcall(v, ...)
		if not ok then
			hooks[hookname][k] = nil
			print(string.format("[hook] Module '%s' errored: %s\nUnloaded module '%s'!", hookname, err, hookname))
		else
			if err ~= nil then return err end
		end
	end
end

hook.Run = hook.Call