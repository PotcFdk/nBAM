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

local Tag = 'chat_lua'

local easylua = require 'easylua'
local hook = require 'nbamHook'

local info = {
	l = {u = '!l <code>', d = 'Runs lua code on the server.'},
	lc = {u = '!lc <code>', d = 'Runs lua code on all clients.'},
	lm = {u = '!lm <code>', d = 'Runs lua code on your client.'},
	print = {u = '!print <value>', d = 'Prints a value (like a lua variable, a string, a number, anything really).'},
}

-- execute functions

hook.Add('postinit', Tag, function()
	nBAM:RegisterChatCMD('l', info.l.u, info.l.d, function (player, cmd, script)
		Events:Fire(NBAM_RUNLUA_SV, {player = player, script = script, error_to_chat = true})
	end, Tag)

	nBAM:RegisterChatCMD('lc', info.lc.u, info.lc.d, function (player, cmd, script)
		Events:Fire(NBAM_RUNLUA_CL, {player = player, script = script})
	end, Tag)

	nBAM:RegisterChatCMD('lm', info.lm.u, info.lm.d, function (player, cmd, script)
		Events:Fire(NBAM_RUNLUA_SELF, {player = player, script = script})
	end, Tag)

	-- print functions

	nBAM:RegisterChatCMD('print', info.print.u, info.print.d, function (player, cmd, script)
		script = 'cprint('..script..')'
		Events:Fire(NBAM_RUNLUA_SV, {player = player, script = script})
	end, Tag)
end)