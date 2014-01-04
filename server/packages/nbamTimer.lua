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
local isnumber = function (num) return type(num) == 'number' end
local istable = function (tab) return type(tab) == 'table' end

local function errmsg (paramNum, expectedType)
	return string.format('Parameter #%d expected to be %s!', paramNum, expectedType)
end

package.loaded.nbamTimer = {}
local timer = package.loaded.nbamTimer

local timers = {}

local tim = Timer()
local function time ()
	return tim:GetSeconds()
end

function timer.Create (id, delay, count, callback)
	assert(isstring(id), errmsg(1, 'string'))
	assert(isnumber(delay), errmsg(2, 'number'))
	assert(isnumber(count), errmsg(3, 'number'))
	assert(isfunction(callback), errmsg(4, 'function'))
	timers[id] = { delay = delay, last = time(), count = count, callback = callback }
end

function timer.Simple (delay, callback)
	assert(isnumber(delay), errmsg(1, 'number'))
	assert(isfunction(callback), errmsg(2, 'function'))
	table.insert(timers, { delay = delay, last = time(), count = 1, callback = callback })
end

function timer.Think ()
	local t = time()
	
	for k, v in next, timers do
		if t >= v.last + v.delay then
			local ok, err = pcall(v.callback)
			if not ok then
				timers[k] = nil
				print(string.format("[timer] Timer '%s' errored: %s\nRemoved timer '%s'!", k, err, k))
			else
				if err ~= nil then return err end
			end
			
			v.count = v.count - 1
			if v.count == 0 then
				timers[k] = nil
			else
				v.last = t
			end
		end
	end
end

Events:Subscribe("PreTick", timer.Think)