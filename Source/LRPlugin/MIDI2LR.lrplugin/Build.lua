--[[----------------------------------------------------------------------------

Build.lua

Takes Database.lua and produces text lists and other tools for documentation
and updating. Has to be run under Lightroom to be properly translated,
but is not used by users of the plugin. Running this also forces a refresh
of the ParamList and MenuList files.
 
This file is part of MIDI2LR. Copyright 2015 by Rory Jaffe.

MIDI2LR is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.

MIDI2LR is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
MIDI2LR.  If not, see <http://www.gnu.org/licenses/>. 
------------------------------------------------------------------------------]]

local Database     = require 'Database'
local LrPathUtils  = import 'LrPathUtils'       

local menulocation = ""
local menus_ = 'menus_({ '
local menu_entries_ = 'menu_entries_({ '
local lrcommandsh = ''


local datafile = LrPathUtils.child(_PLUGIN.path, 'Commands.md')
local file = assert(io.open(datafile,'w'),'Error writing to ' .. datafile)
file:write([=[<!---
  This file automatically generated by Build.lua. To make persistent
  changes, edit Database.lua, not this file
-->
The tables below list all commands currently available in MIDI2LR for all submenus. The title row in each table corresponds with the name of the menu in the app. Controls marked *button* are intended to be used with a button or key, and unmarked controls are for faders or encoders.

*Note*: ※ symbol indicates that the command is undocumented and may not always behave as expected. Use cautiously.
]=])
for _,v in ipairs(Database.DataBase) do
  if v[4] then
    if v[9] ~= menulocation then
      menulocation = v[9]
      file:write("\n| "..menulocation.." |  |\n| ---- | ---- |\n")
    end
    local experimental = ""
    if v[7]  then 
      experimental = "\226\128\187"
    end
    file:write("| "..v[8]..experimental.." | "..v[10].." Abbreviation: "..v[1]..". |\n" )
  end
end
file:close()

datafile = LrPathUtils.child(_PLUGIN.path, 'LRCommands.cpp')
file = assert(io.open(datafile,'w'),'Error writing to ' .. datafile)
menulocation = ""
file:write([=[// This is an open source non-commercial project. Dear PVS-Studio, please check it.
// PVS-Studio Static Code Analyzer for C, C++ and C#: http://www.viva64.com
  /*
  ==============================================================================

    LRCommands.cpp is generated by Build.lua. To make persistent changes
    to this file, edit Database.lua instead.

This file is part of MIDI2LR. Copyright 2015 by Rory Jaffe.

MIDI2LR is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

MIDI2LR is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
MIDI2LR.  If not, see <http://www.gnu.org/licenses/>.
  ==============================================================================
*/
#include "LRCommands.h"
#include "CommandMap.h"
  
]=])
for _,v in ipairs(Database.DataBase) do
  if v[4] then
    if v[9] ~= menulocation then
      if menulocation~="" then
        file:write("};\n\n")
      end
      file:write("const std::vector<std::string> LrCommandList::"..Database.cppvectors[v[9]][1].." = {\n")
      menulocation = v[9]
      menus_ = menus_ .. '"' .. Database.cppvectors[v[9]][2] .. '", '
      menu_entries_ = menu_entries_ .. 'LrCommandList::' .. Database.cppvectors[v[9]][1] .. ', '
      lrcommandsh = lrcommandsh .. '\nstatic const std::vector<std::string> ' .. Database.cppvectors[v[9]][1] ..';'
    end
    file:write('"'..v[8]..'",\n')
  end
end
menus_ = menus_ .. '"Next/Prev Profile" })'
menu_entries_ = menu_entries_ .. 'LrCommandList::NextPrevProfile })'
lrcommandsh = lrcommandsh .. '\n'

file:write("};\n\nconst std::vector<std::string> LrCommandList::LrStringList = {\n\"Unmapped\",\n")
menulocation = ""
for _,v in ipairs(Database.DataBase) do
  if v[4] then
    if v[9] ~= menulocation then
      menulocation = v[9]
      file:write("/* "..menulocation.." */\n")
    end
    file:write('"'..v[1]..'",\n')
  end
end
file:write([=[};

const std::vector <std::string> LrCommandList::NextPrevProfile = {
  "Previous Profile",
  "Next Profile",
};

size_t LrCommandList::GetIndexOfCommand(const std::string& command) {
  static std::unordered_map<std::string, size_t> indexMap;

  // better to check for empty then length, as empty has a constant run time behavior.
  if (indexMap.empty()) {
    size_t idx = 0;
    for (const auto& str : LrStringList)
      indexMap[str] = idx++;

    for (const auto& str : NextPrevProfile)
      indexMap[str] = idx++;
  }

  return indexMap[command];
}]=])
file:close()

datafile = LrPathUtils.child(_PLUGIN.path, 'GeneratedFromDatabase-ReadMe.txt')
file = assert(io.open(datafile,'w'),'Error writing to ' .. datafile)

file:write ([=[Running Build.lua generates several files that need to be
  moved to their proper positions in the build, including LRCommands.cpp and
  LRCommands.h. Build.lua also generates files for the wiki:
  Limits-Available-Parameters.md and Commands.md. These files need to replace the
  current files in the wiki. And ParamList.lua and MenuList.lua need to be copied
  back to the repository so that the correct translations are available when starting
  up the new release for the first time.
  
  Following are two items, first some code that may need to be pasted into
  CommandMenu.cpp, and then test results for the database.
  
  CommandMenu.cpp initializers. If the number of command menu submenus
  have changed, the following 'menus_' and 'menu_entries_' statements should replace
  the ones in CommandMenu.cpp. Because CommandMenu.cpp has so much other code,
  Build.lua does not automatically generate CommandMenu.cpp, so the person
  building the application needs to update CommandMenu.cpp as needed.
  
  ]=],menus_,',\n\n',menu_entries_)
file:write("\n\nRunning Tests\n\n",Database.RunTests(),"\nTests Completed")
file:close()

datafile = LrPathUtils.child(_PLUGIN.path, 'LRCommands.h')
file = assert(io.open(datafile,'w'),'Error writing to ' .. datafile)
file:write([=[#pragma once
/*
  ==============================================================================

    LRCommands.h is generated by Build.lua. To make persistent changes
    to this file, edit Database.lua instead.

This file is part of MIDI2LR. Copyright 2015 by Rory Jaffe.

MIDI2LR is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

MIDI2LR is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
MIDI2LR.  If not, see <http://www.gnu.org/licenses/>.
  ==============================================================================
*/
#ifndef MIDI2LR_LRCOMMANDS_H_INCLUDED
#define MIDI2LR_LRCOMMANDS_H_INCLUDED

#include <string>
#include <vector>
#include "../JuceLibraryCode/JuceHeader.h"

class LrCommandList {
public:
    // Strings that LR uses
  static const std::vector<std::string> LrStringList;

  // Sectioned and readable develop param strings]=],lrcommandsh,[=[
  // MIDI2LR commands
  static const std::vector<std::string> NextPrevProfile;

  // Map of command strings to indices
  static size_t GetIndexOfCommand(const std::string& command);

  LrCommandList() = delete;
};

#endif  // LRCOMMANDS_H_INCLUDED]=])

file:close()

datafile = LrPathUtils.child(_PLUGIN.path, 'Limits-Available-Parameters.md')
file = assert(io.open(datafile,'w'),'Error writing to ' .. datafile)
file:write([=[<!---
  This file automatically generated by Build.lua. To make persistent
  changes, edit Database.lua, not this file
-->
You can add other parameters to the Limits dialog if you wish. [The limits section of the Plugin Options Dialog wiki page has details](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#limits).

Following is a list of all commands that can be added to the Limits dialog following the instructions on that page. Please use this sparingly, as adding many limits might slow down the application. If you find some parameters for which limits are particularly useful, please [post a message](https://groups.google.com/forum/#!forum/midi2lr) so I can set it up for inclusion in the baseline application.

| Command Identifier To Use | Full Name of the Command |
| ------ | -------- |
]=])
for _,v in ipairs(Database.DataBase) do
  if v[4] and v[5] and v[6]==false then
    file:write("| "..v[1].." | "..v[8].." |\n")
  end
end
file:close()



