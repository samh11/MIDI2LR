--[[----------------------------------------------------------------------------

Database.lua
Source of translations and menu for app and plugin
 
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

--local function LOC(str) return str end--for debugging

local PV2003and2010 =  'PV2003'..LOC("$$$/AgStringUtils/localizedList/finalSeparatorString= and ")..'PV2010'
local basicTone = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/BasicTone=Basic Tone")
local calibration = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/Calibration=Calibration")
local colorAdjustments = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/ColorAdjustments=Color Adjustments")
local crop = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/Crop=Crop")
local detail = LOC("$$$/AgDevelop/Panel/Detail=Detail")
local develop = LOC("$$$/SmartCollection/Criteria/Heading/Develop=Develop")
local developPreset = LOC("$$$/AgLibrary/Filter/BrowserCriteria/DevelopPreset/Single=Develop Preset")
local developPresets = LOC("$$$/AgLibrary/Filter/BrowserCriteria/DevelopPreset/Plural=Develop Presets")
local effects = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/Effects=Effects")
local general = LOC("$$$/WFCatSearch/TermCategories/General=General")
local gotoToolModulePanel = LOC("$$$/AgDialogs/Select=Select").. ' '..LOC("$$$/AgDevelop/Menu/Tools=Tools"):gsub('&','')..LOC("$$$/AgStringUtils/localizedList/separatorString=, ")..LOC("$$$/Application/Menu/Window/Modules=Modules:"):gsub(':','')..LOC("$$$/AgStringUtils/localizedList/finalSeparatorString= and ")..LOC("$$$/AgPreferences/Interface/GroupTitle/Panels=Panels")
local keyshortcuts = LOC("$$$/AgLayoutShortcuts/Header/UISortcuts=Keyboard Shortcuts for User")
local keyword = LOC("$$$/AgLibrary/Filter/BrowserCriteria/Keyword=Keyword")
local keywords = LOC("$$$/AgLibrary/Filter/BrowserCriteria/Keywords=Keywords")
local lensCorrections = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LensCorrections=Lens Corrections")
local library = LOC("$$$/AgLibraryModule/ModuleTitle=Library")
local localizedAdjustments = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")
local miscellaneous = "Miscellaneous"
local photoActions = "Photo Actions"
local primaryDisplay = LOC("$$$/AgPhotoBin/Tooltip/PrimaryViewMode=Primary Display")
local profile = LOC("$$$/AgDevelop/CameraRawPanel/Profile=Profile:")
local profiles = LOC("$$$/CRaw/Style/Profiles=Profiles")
local reset = LOC("$$$/AgDevelop/Panel/ResetButton=Reset")
local resetColorAdjustments = reset..' '..colorAdjustments
local secondaryDisplay = LOC("$$$/AgApplication/Menu/Window/SecondaryDisplay=Secondary Display")
local show = LOC("$$$/AgLibrary/LibraryInfo/Show=Show")
local splitToning = LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/SplitToning=Split Toning")
local toneCurve = LOC("$$$/AgDevelop/CameraRawPanel/TargetName/ToneCurve=Tone Curve")
local transform = LOC("$$$/AgDevelop/CameraRawPanel/Transform=Transform")
local viewModes = LOC("$$$/AgDevelop/Toolbar/ViewModesTool=View Modes")
local whiteBalance = LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/WhiteBalance=White Balance")

local coarse = LOC("$$$/AgPrint/CalibrationDialog/Coarse=Coarse")
local fine = LOC("$$$/AgPrint/CalibrationDialog/Fine=Fine")
local key = LOC("$$$/MIDI2LR/Shortcuts/Key=Key")
local filter= LOC("$$$/Library/Filter/FilterLabel=Library filter")

local brush = LOC("$$$/TouchWorkspace/Adjustments/Local/Brush=Brush")
local feather = LOC("$$$/AgDevelop/Toolbar/Localized/BrushFeather=Feather")
local larger = LOC("$$$/AgEmail/FontSize/larger=larger")
local size = LOC("$$$/AgDevelop/Toolbar/Localized/BrushSize=Size")
local smaller = LOC("$$$/AgEmail/FontSize/smaller=smaller")

--[[----------------------------------------------------------------------------

DataBase structure
1. command
2. include in selective paste menu [exclude localized adj]. if in button group on 
 menu, this will be a string identifying group. Otherwise this is true/false.
3. include in selective paste iteration
4. include in application command list
5. send back values to MIDI controller
6. button or table or text=true, variable number=false
7. experimental (for documentation)
8. user-friendly name or, for 2=false and 3=true, command it maps to
9. menu group for app
10. documentation right column
11. panel for changing profile
12. is keypress boolean
13. keypress pc
14. keypress mac

make sure to add section to cppvectors if new

errors if:
2=not false, 3=false
4=false, 5=true
4=false, 11 not nil
8 nil and ((2 not false and 3 true) or (4 true))
9 nil or "" and 4 true

unicode to UTF8 decimal mapping at http://www.utf8-chartable.de/unicode-utf8-table.pl
local interrobang = '\226\128\189'
local referencemark = '\226\128\187'
local ldquo = '\226\128\156'
local rdquo = '\226\128\157'
local lsquo = '\226\128\152'
local rsquo = '\226\128\153'
local mdash = '\226\128\148'

To do: integrate "straightenAngle", translate RetouchInfo orientation
  TrimEnd TrimStart and translate the local variables above not yet translated.
  ------------------------------------------------------------------------------]]

local DataBase = {
  --Keyboard shortcuts
  {'Key1',false,false,true,false,true,false,key..' 1',keyshortcuts,'Key 1. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key2',false,false,true,false,true,false,key..' 2',keyshortcuts,'Key 2. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key3',false,false,true,false,true,false,key..' 3',keyshortcuts,'Key 3. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key4',false,false,true,false,true,false,key..' 4',keyshortcuts,'Key 4. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key5',false,false,true,false,true,false,key..' 5',keyshortcuts,'Key 5. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key6',false,false,true,false,true,false,key..' 6',keyshortcuts,'Key 6. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key7',false,false,true,false,true,false,key..' 7',keyshortcuts,'Key 7. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key8',false,false,true,false,true,false,key..' 8',keyshortcuts,'Key 8. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key9',false,false,true,false,true,false,key..' 9',keyshortcuts,'Key 9. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key10',false,false,true,false,true,false,key..' 10',keyshortcuts,'Key 10. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key11',false,false,true,false,true,false,key..' 11',keyshortcuts,'Key 11. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key12',false,false,true,false,true,false,key..' 12',keyshortcuts,'Key 12. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key13',false,false,true,false,true,false,key..' 13',keyshortcuts,'Key 13. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key14',false,false,true,false,true,false,key..' 14',keyshortcuts,'Key 14. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key15',false,false,true,false,true,false,key..' 15',keyshortcuts,'Key 15. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key16',false,false,true,false,true,false,key..' 16',keyshortcuts,'Key 16. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key17',false,false,true,false,true,false,key..' 17',keyshortcuts,'Key 17. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key18',false,false,true,false,true,false,key..' 18',keyshortcuts,'Key 18. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key19',false,false,true,false,true,false,key..' 19',keyshortcuts,'Key 19. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key20',false,false,true,false,true,false,key..' 20',keyshortcuts,'Key 20. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key21',false,false,true,false,true,false,key..' 21',keyshortcuts,'Key 21. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key22',false,false,true,false,true,false,key..' 22',keyshortcuts,'Key 22. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key23',false,false,true,false,true,false,key..' 23',keyshortcuts,'Key 23. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key24',false,false,true,false,true,false,key..' 24',keyshortcuts,'Key 24. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key25',false,false,true,false,true,false,key..' 25',keyshortcuts,'Key 25. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key26',false,false,true,false,true,false,key..' 26',keyshortcuts,'Key 26. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key27',false,false,true,false,true,false,key..' 27',keyshortcuts,'Key 27. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key28',false,false,true,false,true,false,key..' 28',keyshortcuts,'Key 28. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key29',false,false,true,false,true,false,key..' 29',keyshortcuts,'Key 29. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key30',false,false,true,false,true,false,key..' 30',keyshortcuts,'Key 30. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key31',false,false,true,false,true,false,key..' 31',keyshortcuts,'Key 31. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key32',false,false,true,false,true,false,key..' 32',keyshortcuts,'Key 32. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key33',false,false,true,false,true,false,key..' 33',keyshortcuts,'Key 33. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key34',false,false,true,false,true,false,key..' 34',keyshortcuts,'Key 34. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key35',false,false,true,false,true,false,key..' 35',keyshortcuts,'Key 35. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key36',false,false,true,false,true,false,key..' 36',keyshortcuts,'Key 36. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key37',false,false,true,false,true,false,key..' 37',keyshortcuts,'Key 37. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key38',false,false,true,false,true,false,key..' 38',keyshortcuts,'Key 38. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key39',false,false,true,false,true,false,key..' 39',keyshortcuts,'Key 39. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key40',false,false,true,false,true,false,key..' 40',keyshortcuts,'Key 40. See [Keyboard Shortcuts](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#keyboard-shortcuts) for more information. *button*'},
  {'Key32Key31',false,false,true,false,true,false,key..' 32 – '..key..' 31',keyshortcuts,'Turning knob clockwise sends Key32 signals to Lightroom, counterclockwise Key31. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},
  {'Key34Key33',false,false,true,false,true,false,key..' 34 – '..key..' 33',keyshortcuts,'Turning knob clockwise sends Key34 signals to Lightroom, counterclockwise Key33. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},
  {'Key36Key35',false,false,true,false,true,false,key..' 36 – '..key..' 35',keyshortcuts,'Turning knob clockwise sends Key36 signals to Lightroom, counterclockwise Key35. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},
  {'Key38Key37',false,false,true,false,true,false,key..' 38 – '..key..' 37',keyshortcuts,'Turning knob clockwise sends Key38 signals to Lightroom, counterclockwise Key37. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},
  {'Key40Key39',false,false,true,false,true,false,key..' 40 – '..key..' 39',keyshortcuts,'Turning knob clockwise sends Key40 signals to Lightroom, counterclockwise Key39. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},
  --library filters
  {'Filter_1',false,false,true,false,true,false,filter..' 1',filter,'Library filter 1. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_2',false,false,true,false,true,false,filter..' 2',filter,'Library filter 2. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_3',false,false,true,false,true,false,filter..' 3',filter,'Library filter 3. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_4',false,false,true,false,true,false,filter..' 4',filter,'Library filter 4. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_5',false,false,true,false,true,false,filter..' 5',filter,'Library filter 5. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_6',false,false,true,false,true,false,filter..' 6',filter,'Library filter 6. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_7',false,false,true,false,true,false,filter..' 7',filter,'Library filter 7. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_8',false,false,true,false,true,false,filter..' 8',filter,'Library filter 8. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_9',false,false,true,false,true,false,filter..' 9',filter,'Library filter 9. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},
  {'Filter_10',false,false,true,false,true,false,filter..' 10',filter,'Library filter 10. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},  
  {'Filter_11',false,false,true,false,true,false,filter..' 11',filter,'Library filter 11. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},  
  {'Filter_12',false,false,true,false,true,false,filter..' 12',filter,'Library filter 12. See [Library Filters](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#library-filter) for more information. *button*'},  

  --General Workspace
  --workspace: grid view options
  {"ShoVwgrid",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Library/Grid=Grid"),general,"Displays photos as thumbnails in cells, which can be viewed in compact and expanded sizes. *button*"},
  --workspace: loupe view
  {"ShoVwloupe",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Library/Loupe=Loupe"),general,"Displays a single photo. Zoom levels up to 11:1 are available. *button*"},  --workspace: compare view
  --workspace: compare view
  {"ShoVwcompare",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Library/Compare=Compare"),general,"Displays photos side by side so that you can evaluate them. *button*"},
  --workspace: survey 
  {"ShoVwsurvey",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Library/Survey=Survey"),general,"Displays the active photo with selected photos so that you can evaluate them. The active photo has the lightest colored cell. *button*"},
  --workspace: zoom
  {"ToggleZoomOffOn",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/View/ToggleZoomView=Enable/Disable Zoom"):gsub("&",""),general,"*button*"},
  {'ZoomInOut',false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomInSome=Zoom In Some")..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomOutSome=Zoom Out Some"),general,'Turning knob clockwise zooms in, counterclockwise zooms out. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},    
  {'ZoomOutIn',false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomOutSome=Zoom Out Some")..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomInSome=Zoom In Some"),general,'Turning knob clockwise zooms out, counterclockwise zooms in. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands).'},    
  {"ZoomInLargeStep",false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomIn=Zoom In"),general,"*button*"},
  {"ZoomInSmallStep",false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomInSome=Zoom In Some"),general,"*button*"},
  {"ZoomOutSmallStep",false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomOutSome=Zoom Out Some"),general,"*button*"},
  {"ZoomOutLargeStep",false,false,true,false,true,false,LOC("$$$/AgApplication/Menu/Window/SecondMonitor/ZoomOut=Zoom Out"),general,"*button*"},

  --workspace: view options
  --workspace: panels
  --workspace: Selections
  {"SelectRightLeft",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Edit/AddToSelection=Add to Selection")..' '..LOC("$$$/AgWatermarking/Alignment/Left=Left")..' '..LOC("$$$/AgWatermarking/Alignment/Right=Right"),general,"Extend selection to right or left. Turning knob clockwise sends select Right signals to Lightroom, counterclockwise select Left. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},   
  {"Select1Left",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Edit/AddToSelection=Add to Selection")..' '..LOC("$$$/AgWatermarking/Alignment/Left=Left"),general,"Extend selection one picture to the left. *button*"},
  {"Select1Right",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Edit/AddToSelection=Add to Selection")..' '..LOC("$$$/AgWatermarking/Alignment/Right=Right"),general,"Extend selection one picture to the right. *button*"},
  {"NextPrev",false,false,true,false,true,false,LOC("$$$/AgDevelopShortcuts/Next_Photo=Next Photo").." — "..LOC("$$$/AgDevelopShortcuts/Previous_Photo=Previous Photo"),general,"Move to next or previous photo. Turning knob clockwise sends Next signals to Lightroom, counterclockwise Previous. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"Next",false,false,true,false,true,false,LOC("$$$/AgDevelopShortcuts/Next_Photo=Next Photo"),general,"*button*"},
  {"Prev",false,false,true,false,true,false,LOC("$$$/AgDevelopShortcuts/Previous_Photo=Previous Photo"),general,"*button*"},

  {"ActionSeries1",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 1',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries2",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 2',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries3",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 3',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries4",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 4',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries5",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 5',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries6",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 6',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries7",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 7',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries8",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 8',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"ActionSeries9",false,false,true,false,true,false,LOC("$$$/MIDI2LR/Shortcuts/SeriesofCommands=Series of commands") .. ' 9',general, "Sends a series of button commands. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information. *button*"},
  {"Pause",false,false,false,false,true,false,LOC("$$$/MIDI2LR/Client/Pause=Briefly pause in series of commands"),general, "This should only be used when a series of commands does not provide the intended results. Test first before using. Pause inserts a pause into a command series to allow synchronization when using a slow command followed by a fast command: the pause should be inserted in between. Note that pauses are already automatically introduced for keystrokes. This command is not available in the application as it is only useful in a command series. See [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands) for more information."},

  --workspace: screen mode
  --workspace: Lights Out
  --photomerge
  --edit in
  --Library
  {"SwToMlibrary",false,false,true,false,true,false,show..' '..LOC("$$$/AgLibraryModule/ModuleTitle=Library"),library,"Switch to Library module. *button*"},
  --library: quick collection
  --library: stacking
  --library: flags
  {"Pick",false,false,true,false,true,false,LOC("$$$/AgLibrary/Help/Shortcuts/SetPick=Set Pick Flag"),library,"*button*"},
  {"Reject",false,false,true,false,true,false,LOC("$$$/AgLibrary/Help/Shortcuts/SetReject=Set Rejected Flag"),library,"*button*"},
  {"RemoveFlag",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetPick/Unflagged=Unflagged"):gsub('&',''),library,"*button*"},
  --library: ratings
  {"SetRating0",false,false,true,false,true,false,LOC("$$$/AgLibrary/Filter/Stars=^1 Stars",'0'),library,"*button*"},
  {"SetRating1",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetRating/Win/Rating1=1 Star"):gsub('&',''),library,"*button*"},
  {"SetRating2",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetRating/Win/Rating2=&2 Stars"):gsub('&',''),library,"*button*"},
  {"SetRating3",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetRating/Win/Rating3=&3 Stars"):gsub('&',''),library,"*button*"},
  {"SetRating4",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetRating/Win/Rating4=&4 Stars"):gsub('&',''),library,"*button*"},
  {"SetRating5",false,false,true,false,true,false,LOC("$$$/AgLibrary/Menu/Photo/SetRating/Win/Rating5=&5 Stars"):gsub('&',''),library,"*button*"},
  {"IncreaseRating",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/IncreaseRating=Increase Rating"),library,"*button*"},
  {"DecreaseRating",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/DecreaseRating=Decrease Rating"),library,"*button*"},
  --library: color flags
  {"ToggleBlue",false,false,true,false,true,false,LOC("$$$/AgLibrary/Undo/ToggleColorLabel=Label ^1 Enable/Disable",LOC("$$$/LibraryImporter/ColorLabelBlue=Blue")),library,"*button*"},
  {"ToggleGreen",false,false,true,false,true,false,LOC("$$$/AgLibrary/Undo/ToggleColorLabel=Label ^1 Enable/Disable",LOC("$$$/LibraryImporter/ColorLabelGreen=Green")),library,"*button*"},
  {"ToggleRed",false,false,true,false,true,false,LOC("$$$/AgLibrary/Undo/ToggleColorLabel=Label ^1 Enable/Disable",LOC("$$$/LibraryImporter/ColorLabelRed=Red")),library,"*button*"},
  {"TogglePurple",false,false,true,false,true,false,LOC("$$$/AgLibrary/Undo/ToggleColorLabel=Label ^1 Enable/Disable",LOC("$$$/LibraryImporter/ColorLabelPurple=Purple")),library,"*button*"},
  {"ToggleYellow",false,false,true,false,true,false,LOC("$$$/AgLibrary/Undo/ToggleColorLabel=Label ^1 Enable/Disable",LOC("$$$/LibraryImporter/ColorLabelYellow=Yellow")),library,"*button*"},
  --library: rotation
  --library: delete
  --library: face recognition
  {"ShoVwpeople",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Library/People=People"),library,"In the People view, the different faces are organized by people stacks. *button*"},
  --Develop
  {"SwToMdevelop",false,false,true,false,true,false,show..' '..LOC("$$$/SmartCollection/Criteria/Heading/Develop=Develop"),develop,"Switch to Develop module. *button*"},
  --develop: copy paste sync
  {"LRCopy",false,false,true,false,true,false,"Lightroom "..LOC("$$$/AgLibrary/Menu/Develop/CopySettings=Copy Settings"):gsub("&",""),develop,"Lightroom Copy (open the selection box). *button*"},
  {"LRPaste",false,false,true,false,true,false,"Lightroom "..LOC("$$$/AgCameraRawNamedSettings/Ops/PasteSettings=Paste Settings"),develop,"Lightroom Paste. *button*"},
  {"VirtualCopy",false,false,true,false,true,false,LOC("$$$/AgLibrary/Bezel/CreateVirtualCopy=Create Virtual Copy"):gsub('&',''),develop,"Creates a virtual copy for each of the currently selected photos and videos. The new virtual copies will be selected. *button*"},
  {"ResetAll",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/Ops/ResetSettings=Reset Settings"),develop,"Reset to defaults. *button*"},
  {"ResetLast",false,false,true,false,true,false,reset..' '..LOC("$$$/LibraryUpgradeCatalogUtils/CatalogInfo/LastModified/Label=Last Modified"):gsub(':',''),develop,"Resets the last parameter that was adjusted by an encoder or fader to default. *button*"},
  {"ChangeLastDevelopParameter",false,false,true,false,true,false,LOC("$$$/ImportView/More=More").." – "..LOC("$$$/ImportView/Less=Less").." "..LOC("$$$/LibraryUpgradeCatalogUtils/CatalogInfo/LastModified/Label=Last Modified"),develop,"Increments or decrements the last parameter that was adjusted by an encoder or fader. Turning knob clockwise sends Increment signals to Lightroom, counterclockwise Decrement. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"IncrementLastDevelopParameter",false,false,true,false,true,false,LOC("$$$/AgCameraRawController/TargetAdjustment/Increase=^1 Increase: ^2",'',LOC("$$$/LibraryUpgradeCatalogUtils/CatalogInfo/LastModified/Label=Last Modified")):gsub(':',''):gsub("^%s*(.-)%s*$", "%1"),develop,"Increments the last parameter that was adjusted by an encoder or fader. *button*"},
  {"DecrementLastDevelopParameter",false,false,true,false,true,false,LOC("$$$/AgCameraRawController/TargetAdjustment/Decrease=^1 Decrease: ^2",'',LOC("$$$/LibraryUpgradeCatalogUtils/CatalogInfo/LastModified/Label=Last Modified")):gsub(':',''):gsub("^%s*(.-)%s*$", "%1"),develop,"Decrements the last parameter that was adjusted by an encoder or fader. *button*"},
  {"ChangeCurrentSlider",false,false,true,false,true,false,LOC("$$$/ImportView/More=More").." – "..LOC("$$$/ImportView/Less=Less"),develop,"Adjusts selected develop slider up or down. Turning knob clockwise sends Increment signals to Lightroom, counterclockwise Decrement. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"SliderIncrease",false,false,true,false,true,false,LOC("$$$/ImportView/More=More"),develop,"Increases the selected develop slider. *button*"},
  {"SliderDecrease",false,false,true,false,true,false,LOC("$$$/ImportView/Less=Less"),develop,"Decreases the selected develop slider. *button*"},
  {"RedoUndo",false,false,true,false,true,false,LOC("$$$/Bezel/RedoTitle=Redo").." – "..LOC("$$$/AgCameraRawController/SoftProofingVirtualCopyPrompt/Undo=Undo"),develop,"Turning knob clockwise sends Redo signals to Lightroom, counterclockwise Undo. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"Undo",false,false,true,false,true,false,LOC("$$$/AgCameraRawController/SoftProofingVirtualCopyPrompt/Undo=Undo"),develop,"*button*"},
  {"Redo",false,false,true,false,true,false,LOC("$$$/Bezel/RedoTitle=Redo"),develop,"*button*"},
  --develop: before/after previews
  {"ShoVwdevelop_before_after_horiz",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Develop/BeforeAfterLR=Before/After Left/Right"),develop,"*button*"},
  {"ShoVwdevelop_before_after_vert",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Develop/BeforeAfterTB=Before/After Top/Bottom"),develop,"*button*"},
  {"ShoVwdevelop_before",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Develop/Before=Before"),develop,"*button*"},
  {"ShoVwRefHoriz",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgDevelop/Menu/View/ReferenceActiveLeftRight=Reference View — Left/Right"),develop,"*button*"},
  {"ShoVwRefVert",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgDevelop/Menu/View/ReferenceActiveTopBottom=Reference View — Top/Bottom"),develop,"*button*"},

  --develop: auto
  --develop: clipping indicators
  --develop: views
  {"ShoVwdevelop_loupe",false,false,true,false,true,false,primaryDisplay..' '..LOC("$$$/AgPhotoBin/ViewMode/Develop/Loupe=Loupe"),develop,"*button*"},
  {"ProcessVersion",'basicTone',true,false,false,true,false,LOC("$$$/AgDevelop/Menu/ProcessVersion=Process Version")},
  --
  --develop: basic tone panel
  --
  {"WhiteBalance",'basicTone',true,false,false,true,false,whiteBalance},
  {"RevealPanelAdjust",false,false,true,false,true,false,show..' '..basicTone,basicTone,"Open Basic Adjustments Panel in Develop Module. *button*"},
  {"WhiteBalanceAs_Shot",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/AsShot=As Shot"),basicTone,"Use Temperature and Tint as determined by camera. *button*",'adjustPanel'},
  {"WhiteBalanceAuto",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Auto=Auto"),basicTone,"Have Lightroom determine Temperature and Tint. *button*",'adjustPanel'},
  {"WhiteBalanceCloudy",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Cloudy=Cloudy"),basicTone,"Use cloudy white balance. *button*",'adjustPanel'},
  {"WhiteBalanceDaylight",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Daylight=Daylight"),basicTone,"Use daylight white balance. *button*",'adjustPanel'},
  {"WhiteBalanceFlash",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Flash=Flash"),basicTone,"Use flash white balance. *button*",'adjustPanel'},
  {"WhiteBalanceFluorescent",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Fluorescent=Fluorescent"),basicTone,"Use fluorescent white balance. *button*",'adjustPanel'},
  {"WhiteBalanceShade",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Shade=Shade"),basicTone,"Use shade white balance. *button*",'adjustPanel'},
  {"WhiteBalanceTungsten",false,false,true,false,true,true,whiteBalance..' '..LOC("$$$/AgCameraRawUI/WhiteBalance/Tungsten=Tungsten"),basicTone,"Use tungsten white balance. *button*",'adjustPanel'},
  {"AutoTone",false,false,true,false,true,true,basicTone..' '..LOC("$$$/AgCameraRawNamedSettings/Ops/AutoTone=Auto Tone"),basicTone,"Auto Tone. *button*",'adjustPanel'},
  {"AutoBrightness",'basicTone',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/AutoBrightness=Automatic Brightness")},
  {"AutoContrast",'basicTone',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/AutoContrast=Automatic Contrast")},
  {"AutoExposure",'basicTone',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/AutoExposure=Automatic Exposure")},
  {"AutoShadows",'basicTone',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/AutoShadows=Automatic Shadows")},
  {"Temperature",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Temperature=Temperature"),basicTone,"Fine-tunes the white balance using the Kelvin color temperature scale. Move the slider to the left to make the photo appear cooler, and right to warm the photo colors.",'adjustPanel'},
  {"Tint",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Tint=Tint"),basicTone,"Fine-tunes the white balance to compensate for a green or magenta tint. Move the slider to the left (negative values) to add green to the photo; move it to the right (positive values) to add magenta.",'adjustPanel'},
  {"Exposure",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawUI/Exposure=Exposure"),basicTone,"Sets the overall image brightness. Adjust the slider until the photo looks good and the image is the desired brightness.",'adjustPanel'},
  {"Exposure2012",false,true,false,false,false,false,"Exposure"},
  {"Contrast",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawUI/Contrast=Contrast"),basicTone,"Increases or decreases image contrast, mainly affecting midtones. When you increase contrast, the middle-to-dark image areas become darker, and the middle-to-light image areas become lighter. The image tones are inversely affected as you decrease contrast.",'adjustPanel'},
  {"Contrast2012",false,true,false,false,false,false,"Contrast"},
  {"Highlights2012",false,true,false,false,false,false,"Highlights"},
  {"Highlights",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Highlights=Highlights")..' ('..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HighlightRecovery=Highlight Recovery")..' in '..PV2003and2010..')',basicTone,'Adjusts bright image areas. Drag to the left to darken highlights and recover \226\128\156blown out\226\128\157 highlight details. Drag to the right to brighten highlights while minimizing clipping.<br /><br />In '..PV2003and2010..', controls recovery and reduces the tones of extreme highlights and attempts to recover highlight detail lost because of camera overexposure. Lightroom can recover detail in raw image files if one or two channels are clipped.','adjustPanel'},
  {"Brightness",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawUI/Brightness=Brightness"),basicTone,"Adjusts image brightness, mainly affecting midtones. Adjust Brightness after setting Exposure, Recovery, and Blacks sliders. Large brightness adjustments can affect shadow or highlight clipping, so you may want to readjust the Exposure, Recovery, or Blacks slider after adjusting brightness. No effect unless in PV2003 or PV2010)",'adjustPanel'},
  {"HighlightRecovery",'basicTone',true,false,false,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HighlightRecovery=Highlight Recovery")..' ('..PV2003and2010..')'},
  {"Shadows",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Shadows=Shadows")..' ('..LOC("$$$/AgCameraRawUI/FillLight=Fill Light")..' in '..PV2003and2010..')',basicTone,'Adjusts dark image areas. Drag to the left to darken shadows while minimizing clipping. Drag to the right to brighten shadows and recover shadow details.<br /><br />In '..PV2003and2010..', controls Fill Light, and lightens shadow to reveal more detail while maintaining blacks. Take care not to over apply the setting and reveal image noise.','adjustPanel'},
  {"Shadows2012",'basicTone',true,false,false,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Shadows=Shadows")},--NOT fill light in 2003 and 2010
  {"FillLight",'basicTone',true,false,false,false,false,LOC("$$$/AgCameraRawUI/FillLight=Fill Light")..' ('..PV2003and2010..')'},
  {"Whites",false,false,true,true,false,false,LOC("$$$/AgCameraRawUI/Whites=Whites")..' (no effect in '..PV2003and2010..')',basicTone,"Adjusts white clipping. Drag to the left to reduce clipping in highlights. Drag to the right to increase highlight clipping.",'adjustPanel'},
  {"Whites2012",'basicTone',true,false,false,false,false,LOC("$$$/AgCameraRawUI/Whites=Whites")..' (no effect in '..PV2003and2010..')'},
  {"Blacks",false,false,true,true,false,false,LOC("$$$/AgCameraRawUI/Blacks=Blacks"),basicTone,"Specifies which image values map to black. Moving the slider to the right increases the areas that become black, sometimes creating the impression of increased image contrast. The greatest effect is in the shadows, with much less change in the midtones and highlights.",'adjustPanel'},
  {"Blacks2012",'basicTone',true,false,false,false,false,LOC("$$$/AgCameraRawUI/Blacks=Blacks")},
  {"Clarity",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Clarity=Clarity"),basicTone,"Adds depth to an image by increasing local contrast. When using this setting, it is best to zoom in to 100% or greater.",'adjustPanel'},
  {"Clarity2012",false,true,false,false,false,false,"Clarity"},
  {"Vibrance",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawUI/Vibrance=Vibrance"),basicTone,"Adjusts the saturation so that clipping is minimized as colors approach full saturation, changing the saturation of all lower-saturated colors with less effect on the higher-saturated colors. Vibrance also prevents skin tones from becoming over saturated.",'adjustPanel'},
  {"Saturation",'basicTone',true,true,true,false,false,LOC("$$$/AgCameraRawUI/Saturation=Saturation"),basicTone,"Adjusts the saturation of all image colors equally from -100 (monochrome) to +100 (double the saturation).",'adjustPanel'},
  {"ResetTemperature",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Temperature=Temperature"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetTint",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Tint=Tint"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetExposure",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Exposure=Exposure"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetContrast",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Contrast=Contrast"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetHighlights",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Highlights=Highlights"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetShadows",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Shadows=Shadows"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetWhites",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Whites=Whites"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetBlacks",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Blacks=Blacks"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetClarity",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Clarity=Clarity"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetVibrance",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Vibrance=Vibrance"),basicTone,"Reset to default. *button*",'adjustPanel'},
  {"ResetSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawUI/Saturation=Saturation"),basicTone,"Reset to default. *button*",'adjustPanel'},
--
--develop: tone curve panel
--
  {"RevealPanelTone",false,false,true,false,true,false,show..' '..toneCurve,toneCurve,"Open Tone Curve Panel in Develop Module. *button*"},
--  {"EnableToneCurve",'toneCurve',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableToneCurve=Enable Tone Curve"),toneCurve,"Enable or disable tone curve. *button*",'tonePanel'}, --can't read EnableToneCurve, only write--can't synchronize with LR
  {"ToneCurve",'toneCurve',true,false,false,true,false,toneCurve},
  {"ToneCurveName",false,true,false,false,true,false,"ToneCurve"},
  {"ToneCurveName2012",false,true,false,false,true,false,"ToneCurve"},
  {"ToneCurvePV2012",false,true,false,false,true,false,"ToneCurve"},
  {"ToneCurvePV2012Blue",false,true,false,false,true,false,"ToneCurve"},
  {"ToneCurvePV2012Green",false,true,false,false,true,false,"ToneCurve"},
  {"ToneCurvePV2012Red",false,true,false,false,true,false,"ToneCurve"},
  {"ParametricDarks",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneDarks=Dark Tones"),toneCurve,"Adjust darks.",'tonePanel'},
  {"ParametricLights",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneLights=Light Tones"),toneCurve,"Adjust lights.",'tonePanel'},
  {"ParametricShadows",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneShadows=Shadow Tones"),toneCurve,"Adjust shadows.",'tonePanel'},
  {"ParametricHighlights",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneHighlights=Highlight Tones"),toneCurve,"Adjust highlights.",'tonePanel'},
  {"ParametricShadowSplit",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneShadowSplit=Shadow Split"),toneCurve,"Move division between shadows and darks.",'tonePanel'},
  {"ParametricMidtoneSplit",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneMidtoneSplit=Midtone Split"),toneCurve,"Move division between darks and lights.",'tonePanel'},
  {"ParametricHighlightSplit",'toneCurve',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneHighlightSplit=Highlight Split"),toneCurve,"Move division between lights and highlights.",'tonePanel'},
  {"ResetParametricDarks",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneDarks=Dark Tones"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricLights",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneLights=Light Tones"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricShadows",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneShadows=Shadow Tones"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricHighlights",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneHighlights=Highlight Tones"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricShadowSplit",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneShadowSplit=Shadow Split"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricMidtoneSplit",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneMidtoneSplit=Midtone Split"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"ResetParametricHighlightSplit",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ToneHighlightSplit=Highlight Split"),toneCurve,"Reset to default. *button*",'tonePanel'},
  {"PointCurveLinear",false,false,true,false,true,false,toneCurve..' '..LOC("$$$/CRaw/ToneCurvePreset/Linear=Linear"),toneCurve,"Linear Point Curve. *button*",'tonePanel'},
  {"PointCurveMediumContrast",false,false,true,false,true,false,toneCurve..' '..LOC("$$$/CRaw/ToneCurvePreset/MediumContrast=Medium Contrast"),toneCurve,"Medium Contrast Point Curve. *button*",'tonePanel'},
  {"PointCurveStrongContrast",false,false,true,false,true,false,toneCurve..' '..LOC("$$$/CRaw/ToneCurvePreset/StrongContrast=Strong Contrast"),toneCurve,"Strong Contrast Point Curve. *button*",'tonePanel'},
--
--develop: mixer panel
--
  {"RevealPanelMixer",false,false,true,false,true,false,show..' '..colorAdjustments,colorAdjustments,"Open Mixer Panel in Develop Module. *button*"},
  {"EnableColorAdjustments",'colorAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableColorAdjustments=Enable Color Adjustments"),colorAdjustments,"Enable or disable color adjustments. *button*",'mixerPanel'},
  {"SaturationAdjustmentRed",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentRed=Saturation Adjustment Red"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentOrange",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentOrange=Saturation Adjustment Orange"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentYellow",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentYellow=Saturation Adjustment Yellow"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentGreen",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentGreen=Saturation Adjustment Green"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentAqua",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentAqua=Saturation Adjustment Aqua"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentBlue",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentBlue=Saturation Adjustment Blue"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentPurple",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentPurple=Saturation Adjustment Purple"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"SaturationAdjustmentMagenta",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentMagenta=Saturation Adjustment Magenta"),colorAdjustments,"Changes the color vividness or purity of the color.",'mixerPanel'},
  {"AllSaturationAdjustment",false,false,true,false,false,false,"All Saturation Adjustment",colorAdjustments,"Changes all color vividness or purity of all colors.",'mixerPanel'},
  {"HueAdjustmentRed",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentRed=Hue Adjustment Red"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentOrange",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentOrange=Hue Adjustment Orange"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentYellow",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentYellow=Hue Adjustment Yellow"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentGreen",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentGreen=Hue Adjustment Green"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentAqua",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentAqua=Hue Adjustment Aqua"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentBlue",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentBlue=Hue Adjustment Blue"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentPurple",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentPurple=Hue Adjustment Purple"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"HueAdjustmentMagenta",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentMagenta=Hue Adjustment Magenta"),colorAdjustments,"Changes the color.",'mixerPanel'},
  {"LuminanceAdjustmentRed",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentRed=Luminance Adjustment Red"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentOrange",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentOrange=Luminance Adjustment Orange"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentYellow",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentYellow=Luminance Adjustment Yellow"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentGreen",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentGreen=Luminance Adjustment Green"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentAqua",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentAqua=Luminance Adjustment Aqua"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentBlue",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentBlue=Luminance Adjustment Blue"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentPurple",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentPurple=Luminance Adjustment Purple"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"LuminanceAdjustmentMagenta",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentMagenta=Luminance Adjustment Magenta"),colorAdjustments,"Changes the brightness of the color range.",'mixerPanel'},
  {"ConvertToGrayscale",'colorAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ConvertToGrayscale=Convert to Grayscale"),colorAdjustments,"Enable/disable gray scale conversion. *button*",'mixerPanel'},
  {"EnableGrayscaleMix",'colorAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableGrayscaleMix=Enable Grayscale Mix"),colorAdjustments,"Enable or disable black and white mix. *button*",'mixerPanel'},
  {"GrayMixerRed",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerRed=Gray Mixer Red"),colorAdjustments,"Red contribution to luminance.",'mixerPanel'},
  {"GrayMixerOrange",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerOrange=Gray Mixer Orange"),colorAdjustments,"Orange contribution to luminance.",'mixerPanel'},
  {"GrayMixerYellow",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerYellow=Gray Mixer Yellow"),colorAdjustments,"Yellow contribution to luminance.",'mixerPanel'},
  {"GrayMixerGreen",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerGreen=Gray Mixer Green"),colorAdjustments,"Green contribution to luminance.",'mixerPanel'},
  {"GrayMixerAqua",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerAqua=Gray Mixer Aqua"),colorAdjustments,"Aqua contribution to luminance.",'mixerPanel'},
  {"GrayMixerBlue",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerBlue=Gray Mixer Blue"),colorAdjustments,"Blue contribution to luminance.",'mixerPanel'},
  {"GrayMixerPurple",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerPurple=Gray Mixer Purple"),colorAdjustments,"Purple contribution to luminance.",'mixerPanel'},
  {"GrayMixerMagenta",'colorAdjustments',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerMagenta=Gray Mixer Magenta"),colorAdjustments,"Magenta contribution to luminance.",'mixerPanel'},
  {"ResetSaturationAdjustmentRed",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentRed=Saturation Adjustment Red"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentOrange",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentOrange=Saturation Adjustment Orange"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentYellow",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentYellow=Saturation Adjustment Yellow"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentGreen",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentGreen=Saturation Adjustment Green"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentAqua",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentAqua=Saturation Adjustment Aqua"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentBlue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentBlue=Saturation Adjustment Blue"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentPurple",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentPurple=Saturation Adjustment Purple"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetSaturationAdjustmentMagenta",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustmentMagenta=Saturation Adjustment Magenta"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetAllSaturationAdjustment",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SaturationAdjustment=All Saturation Adjustment"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentRed",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentRed=Hue Adjustment Red"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentOrange",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentOrange=Hue Adjustment Orange"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentYellow",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentYellow=Hue Adjustment Yellow"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentGreen",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentGreen=Hue Adjustment Green"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentAqua",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentAqua=Hue Adjustment Aqua"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentBlue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentBlue=Hue Adjustment Blue"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentPurple",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentPurple=Hue Adjustment Purple"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetHueAdjustmentMagenta",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/HueAdjustmentMagenta=Hue Adjustment Magenta"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentRed",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentRed=Luminance Adjustment Red"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentOrange",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentOrange=Luminance Adjustment Orange"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentYellow",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentYellow=Luminance Adjustment Yellow"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentGreen",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentGreen=Luminance Adjustment Green"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentAqua",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentAqua=Luminance Adjustment Aqua"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentBlue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentBlue=Luminance Adjustment Blue"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentPurple",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentPurple=Luminance Adjustment Purple"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetLuminanceAdjustmentMagenta",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceAdjustmentMagenta=Luminance Adjustment Magenta"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerRed",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerRed=Gray Mixer Red"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerOrange",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerOrange=Gray Mixer Orange"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerYellow",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerYellow=Gray Mixer Yellow"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerGreen",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerGreen=Gray Mixer Green"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerAqua",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerAqua=Gray Mixer Aqua"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerBlue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerBlue=Gray Mixer Blue"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerPurple",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerPurple=Gray Mixer Purple"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
  {"ResetGrayMixerMagenta",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrayMixerMagenta=Gray Mixer Magenta"),resetColorAdjustments,"Reset to default. *button*",'mixerPanel'},
--
--develop: split toning panel
--
  {"RevealPanelSplit",false,false,true,false,true,false,show..' '..splitToning,splitToning,"Open Split Toning Panel in Develop Module. *button*"},
  {"EnableSplitToning",'splitToningPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableSplitToning=Enable Split Toning"),splitToning,"Enable or disable split toning effects. *button*",'splitToningPanel'},
  {"SplitToningShadowHue",'splitToningPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningShadowHue=Shadow Hue"),splitToning,"Color of the tone for shadows.",'splitToningPanel'},
  {"SplitToningShadowSaturation",'splitToningPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningShadowSaturation=Shadow Saturation"),splitToning,"Strength of the effect.",'splitToningPanel'},
  {"SplitToningHighlightHue",'splitToningPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningHighlightHue=Highlight Hue"),splitToning,"Color of the tone for highlights.",'splitToningPanel'},
  {"SplitToningHighlightSaturation",'splitToningPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningHighlightSaturation=Highlight Saturation"),splitToning,"Strength of the effect.",'splitToningPanel'},
  {"SplitToningBalance",'splitToningPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningBalance=Split Toning Balance"),splitToning,"Set the Balance slider to balance the effect between the Highlight and Shadow sliders. Positive values increase the effect of the Highlight sliders; negative values increase the effect of the Shadow sliders.",'splitToningPanel'},
  {"ResetSplitToningShadowHue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningShadowHue=Shadow Hue"),splitToning,"Reset to default. *button*",'splitToningPanel'},
  {"ResetSplitToningShadowSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningShadowSaturation=Shadow Saturation"),splitToning,"Reset to default. *button*",'splitToningPanel'},
  {"ResetSplitToningHighlightHue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningHighlightHue=Highlight Hue"),splitToning,"Reset to default. *button*",'splitToningPanel'},
  {"ResetSplitToningHighlightSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningHighlightSaturation=Highlight Saturation"),splitToning,"Reset to default. *button*",'splitToningPanel'},
  {"ResetSplitToningBalance",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SplitToningBalance=Split Toning Balance"),splitToning,"Reset to default. *button*",'splitToningPanel'},
--
--develop: detail panel
--
  {"RevealPanelDetail",false,false,true,false,true,false,show..' '..detail,detail,"Open Detail Panel in Develop Module. *button*"},
  {"EnableDetail",'detailPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableDetail=Enable Detail"),detail,"Enable or disable noise reduction and sharpening. *button*",'detailPanel'},
  {"Sharpness",'detailPanel',true,true,true,false,false,LOC("$$$/AgDevelop/Localized/Sharpness=Sharpness"),detail,"Adjusts edge definition. Increase the Amount value to increase sharpening. A value of zero (0) turns off sharpening. In general, set Amount to a lower value for cleaner images. The adjustment locates pixels that differ from surrounding pixels based on the threshold you specify and increases the pixelsâ€™ contrast by the amount you specify.",'detailPanel'},
  {"SharpenRadius",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenRadius=Sharpen Radius"),detail,"Adjusts the size of the details that sharpening is applied to. Photos with very fine details may need a lower radius setting. Photos with larger details may be able to use a larger radius. Using too large a radius generally results in unnatural-looking results.",'detailPanel'},
  {"SharpenDetail",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenDetail=Sharpen Detail"),detail,"Adjusts how much high-frequency information is sharpened in the image and how much the sharpening process emphasizes edges. Lower settings primarily sharpen edges to remove blurring. Higher values are useful for making the textures in the image more pronounced.",'detailPanel'},
  {"SharpenEdgeMasking",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenEdgeMasking=Sharpen Edge Masking"),detail,"Controls an edge mask. With a setting of zero (0), everything in the image receives the same amount of sharpening. With a setting of 100, sharpening is mostly restricted to those areas near the strongest edges.",'detailPanel'},
  {"LuminanceSmoothing",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceSmoothing=Luminance Smoothing"),detail,"Reduces luminance noise.",'detailPanel'},
  {"LuminanceNoiseReductionDetail",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceNoiseReductionDetail=Luminance Detail"),detail,"Controls the luminance noise threshold. Useful for very noisy photos. Higher values preserve more detail but may produce noisier results. Lower values produce cleaner results but may also remove some detail.",'detailPanel'},
  {"LuminanceNoiseReductionContrast",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceNoiseReductionContrast=Luminance Contrast"),detail,"Controls luminance contrast. Useful for very noisy photos. Higher values preserve contrast but may produce noisy blotches or mottling. Lower values produce smoother results but may also have less contrast.",'detailPanel'},
  {"ColorNoiseReduction",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReduction=Color Noise Reduction"),detail,"Reduces color noise.",'detailPanel'},
  {"ColorNoiseReductionDetail",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReductionDetail=Color Noise Reduction Detail"),detail,"Controls the color noise threshold. Higher values protect thin, detailed color edges but may result in color speckling. Lower values remove color speckles but may result in color bleeding.",'detailPanel'},
  {"ColorNoiseReductionSmoothness",'detailPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReductionSmoothness=Color Noise Reduction Smoothness"),detail,"Increasing this can prevent artifacts especially in the lower frequencies.",'detailPanel'},
  {"ResetSharpness",false,false,true,false,true,false,reset..' '..LOC("$$$/AgDevelop/Localized/Sharpness=Sharpness"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetSharpenRadius",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenRadius=Sharpen Radius"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetSharpenDetail",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenDetail=Sharpen Detail"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetSharpenEdgeMasking",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/SharpenEdgeMasking=Sharpen Edge Masking"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetLuminanceSmoothing",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceSmoothing=Luminance Smoothing"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetLuminanceNoiseReductionDetail",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceNoiseReductionDetail=Luminance Detail"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetLuminanceNoiseReductionContrast",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LuminanceNoiseReductionContrast=Luminance Contrast"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetColorNoiseReduction",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReduction=Color Noise Reduction"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetColorNoiseReductionDetail",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReductionDetail=Color Noise Reduction Detail"),detail,"Reset to default. *button*",'detailPanel'},
  {"ResetColorNoiseReductionSmoothness",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ColorNoiseReductionSmoothness=Color Noise Reduction Smoothness"),detail,"Reset to default. *button*",'detailPanel'},
--
--develop: lens corrections panel
--
  {"RevealPanelLens",false,false,true,false,true,false,show..' '..lensCorrections,lensCorrections,"Open Lens Corrections Panel in Develop Module. *button*"},
  {"EnableLensCorrections",'lensCorrectionsPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableLensCorrections=Enable Lens Corrections"),lensCorrections,"Enable or disable all lens corrections. *button*",'lensCorrectionsPanel'},
  {"LensProfileEnable",'lensCorrectionsPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileEnable=Toggle Profile Corrections"),lensCorrections,"Enable or disable lens profile correction. *button*",'lensCorrectionsPanel'},
  {"LensProfileSetup",'lensCorrectionsPanel',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileSetup=Lens Profile Setup")},
  {"AutoLateralCA",'lensCorrectionsPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/RemoveChromaticAberration=Remove Chromatic Aberration"),lensCorrections,"Toggle Remove Chromatic Aberration. *button*",'lensCorrectionsPanel'},
  {"ChromaticAberrationB",'lensCorrectionsPanel',true,false,false,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ChromaticAberrationB=Blue Chromatic Aberration")},
  {"ChromaticAberrationR",'lensCorrectionsPanel',true,false,false,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ChromaticAberrationR=Red Chromatic Aberration")},
  {"LensProfileDistortionScale",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileDistortionScale=Lens Profile Distortion Scale"),lensCorrections,"The default value 100 applies 100% of the distortion correction in the profile. Values over 100 apply greater correction to the distortion; values under 100 apply less correction to the distortion.",'lensCorrectionsPanel'},
  {"LensProfileChromaticAberrationScale",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileChromaticAberrationScale=Lens Profile Chromatic Aberration Scale"),lensCorrections,"The default value 100 applies 100% of the chromatic aberration correction in the profile. Values over 100 apply greater correction to color fringing; values under 100 apply less correction to color fringing.",'lensCorrectionsPanel'},
  {"LensProfileVignettingScale",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileVignettingScale=Lens Profile Vignetting Scale"),lensCorrections,"The default value 100 applies 100% of the vignetting correction in the profile. Values over 100 apply greater correction to vignetting; values under 100 apply less correction to vignetting.",'lensCorrectionsPanel'},
  {"CropConstrainToWarp",'lensCorrectionsPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/CropConstrainToWarp=Constrain to Warp"),lensCorrections,"Enable or disable Constrain Crop. *button*",'lensCorrectionsPanel'},
  {"ResetLensProfileDistortionScale",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileDistortionScale=Lens Profile Distortion Scale"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetLensProfileChromaticAberrationScale",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileChromaticAberrationScale=Lens Profile Chromatic Aberration Scale"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetLensProfileVignettingScale",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensProfileVignettingScale=Lens Profile Vignetting Scale"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"DefringePurpleAmount",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeAmount=Defringe Purple Amount"),lensCorrections,"You can adjust the affected purple or green hue range using the Purple Hue and the Green Hue sliders. Drag either end-point control to expand or decrease the range of affected colors. Drag between the end point controls to move the hue range. The minimum space between end points is ten units.",'lensCorrectionsPanel'},
  {"DefringePurpleHueLo",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeHueLo=Defringe Purple Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/Low=Low"),lensCorrections,"See 'Defringe Purple Amount' description for details.",'lensCorrectionsPanel'},
  {"DefringePurpleHueHi",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeHueLo=Defringe Purple Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/High=High"),lensCorrections,"See 'Defringe Purple Amount' description for details.",'lensCorrectionsPanel'},
  {"DefringeGreenAmount",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeAmount=Defringe Green Amount"),lensCorrections,"You can adjust the affected purple or green hue range using the Purple Hue and the Green Hue sliders. Drag either end-point control to expand or decrease the range of affected colors. Drag between the end point controls to move the hue range. The minimum space between end points is ten units. The default spacing for the green sliders is narrow to protect green/yellow image colors, like foliage.",'lensCorrectionsPanel'},
  {"DefringeGreenHueLo",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeHueLo=Defringe Green Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/Low=Low"),lensCorrections,"See 'Defringe Green Amount' description for details.",'lensCorrectionsPanel'},
  {"DefringeGreenHueHi",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeHueLo=Defringe Green Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/High=High"),lensCorrections,"See 'Defringe Green Amount' description for details.",'lensCorrectionsPanel'},
  {"ResetDefringePurpleAmount",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeAmount=Defringe Purple Amount"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetDefringePurpleHueLo",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeHueLo=Defringe Purple Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/Low=Low"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetDefringePurpleHueHi",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PurpleDefringeHueLo=Defringe Purple Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/High=High"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetDefringeGreenAmount",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeAmount=Defringe Green Amount"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetDefringeGreenHueLo",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeHueLo=Defringe Green Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/Low=Low"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetDefringeGreenHueHi",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenDefringeHueLo=Defringe Green Hue")..' - '..LOC("$$$/Slideshow/Panels/PanAndZoom/High=High"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"LensManualDistortionAmount",'lensCorrectionsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensManualDistortionAmount=Lens Manual Distortion Amount"),lensCorrections,"Drag to the right to correct barrel distortion and straighten lines that bend away from the center. Drag to the left to correct pincushion distortion and straighten lines that bend toward the center.",'lensCorrectionsPanel'},
  {"VignetteAmount",'lensCorrectionsPanel',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/VignetteAmount=Vignette Amount"),lensCorrections,"Sets the amount of lightening or darkening along the edges of an image. Corrects images that have darkened corners caused by lens faults or improper lens shading.",'lensCorrectionsPanel'},
  {"VignetteMidpoint",'lensCorrectionsPanel',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/VignetteMidpoint=Vignette Midpoint"),lensCorrections,"Specifies the width of area affected by the Amount slider. Specify a lower number to affect more of the image. Specify a higher number to restrict the effect to the edges of the image.",'lensCorrectionsPanel'},
  {"ResetLensManualDistortionAmount",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/LensManualDistortionAmount=Lens Manual Distortion Amount"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetVignetteAmount",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/VignetteAmount=Vignette Amount"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
  {"ResetVignetteMidpoint",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/VignetteMidpoint=Vignette Midpoint"),lensCorrections,"Reset to default. *button*",'lensCorrectionsPanel'},
--
--develop: transform panel menu
--
  {"RevealPanelTransform",false,false,true,false,true,false,show..' '..transform,transform,"Open Transform Panel in Develop Module. *button*"},
  {"EnableTransform",'transformPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableTransform=Enable Transform"),transform,"Enable or disable all tranforms. *button*",'transformPanel'},
  {"PerspectiveUpright",'transformPanel',true,false,false,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveUpright=Perspective Upright")},
  {"UprightOff",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueOff=Off"),transform,"Upright mode off. *button*",'transformPanel'},
  {"UprightAuto",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueAuto=Auto"),transform,"Balanced level, aspect ratio, and perspective corrections. *button*",'transformPanel'},
  {"UprightLevel",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueLevel=Level"),transform,"Perspective corrections are weighted toward horizontal details. *button*",'transformPanel'},
  {"UprightVertical",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueLevelVertical=Vertical"),transform,"Perspective corrections are weighted toward vertical details. *button*",'transformPanel'},
  {"UprightGuided",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueLevelGuided=Guided"),transform,"Perspective corrections guide by drawing lines. *button*",'transformPanel'},
  {"UprightFull",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/UprightPerspectiveCorrection=Perspective Correction")..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ValueFull=Full"),transform,"Combination of full Level, Vertical, and Auto perspective corrections. *button*",'transformPanel'},
  {"ResetPerspectiveUpright",false,false,true,false,true,false,LOC("$$$/AgCameraRawNamedSettings/Ops/ResetUprightSettings=Reset Upright Settings"),transform,"Reset to default. *button*",'transformPanel'},
  {"PerspectiveVertical",'transformPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveVertical=Perspective Vertical"),transform,"Corrects perspective caused by tilting the camera up or down. Makes vertical lines appear parallel.",'transformPanel'},
  {"PerspectiveHorizontal",'transformPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveHorizontal=Perspective Horizontal"),transform,"Corrects perspective caused by angling the camera left or right. Makes horizontal lines parallel.",'transformPanel'},
  {"PerspectiveRotate",'transformPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveRotate=Perspective Rotate"),transform,"Corrects for camera tilt. Uses the center of the original, uncropped photo as the axis of rotation.",'transformPanel'},
  {"PerspectiveScale",'transformPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveScale=Perspective Scale"),transform,"Adjusts the image scale up or down. Helps to remove empty areas caused by perspective corrections and distortions. Displays areas of the image that extend beyond the crop boundary.",'transformPanel'},
  {"PerspectiveAspect",'transformPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveAspect=Perspective Aspect"),transform,"Adjusts the amount the image is stretched horizontally or vertically.",'transformPanel'},
  {"PerspectiveX",'transformPanel',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveX=Perspective X"),transform,"Moves the center of the image laterally.",'transformPanel'},
  {"PerspectiveY",'transformPanel',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveY=Perspective Y"),transform,"Moves the center of the image vertically.",'transformPanel'},
  {"ResetPerspectiveVertical",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveVertical=Perspective Vertical"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveHorizontal",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveHorizontal=Perspective Horizontal"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveRotate",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveRotate=Perspective Rotate"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveScale",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveScale=Perspective Scale"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveAspect",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveAspect=Perspective Aspect"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveX",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveX=Perspective X"),transform,"Reset to default. *button*",'transformPanel'},
  {"ResetPerspectiveY",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PerspectiveY=Perspective Y"),transform,"Reset to default. *button*",'transformPanel'},
--
--develop: effects panel
--
  {"RevealPanelEffects",false,false,true,false,true,false,show..' '..effects,effects,"Open Effects Panel in Develop Module. *button*"},
  {"EnableEffects",'effectsPanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableEffects=Enable Effects"),effects,"Enable or disable effects. *button*",'effectsPanel'},
  {"Dehaze",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/DehazeAmount=Dehaze Amount"),effects,"Controls the amount of haze in a photograph. Drag to the right to remove haze; drag to the left to add haze.",'effectsPanel'},
  {"PostCropVignetteAmount",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteAmount=Post Crop Vignette Amount"),effects,"Negative values darken the corners of the photo. Positive values lighten the corners.",'effectsPanel'},
  {"PostCropVignetteMidpoint",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteMidpoint=Post Crop Vignette Midpoint"),effects,"Lower values apply the Amount adjustment to a larger area away from the corners. Higher values restrict the adjustment to an area closer to the corners.",'effectsPanel'},
  {"PostCropVignetteFeather",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteFeather=Post Crop Vignette Feather"),effects,"Lower values reduce softening between the vignette and the vignetteâ€™s surrounding pixels. Higher values increase the softening.",'effectsPanel'},
  {"PostCropVignetteRoundness",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteRoundness=Post Crop Vignette Roundness"),effects,"Lower values make the vignette effect more oval. Higher values make the vignette effect more circular.",'effectsPanel'},
  {"PostCropVignetteStyle",'effectsPanel',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteStyle=Post Crop Vignette Style"),effects,"Cycles through: **Highlight Priority** Enables highlight recovery but can lead to color shifts in darkened areas of a photo. Suitable for photos with bright image areas such as clipped specular highlights. **Color Priority** Minimizes color shifts in darkened areas of a photo but cannot perform highlight recovery. **Paint Overlay** Mixes the cropped image values with black or white pixels. Can result in a flat appearance.",'effectsPanel'},
  {"PostCropVignetteStyleHighlightPriority",false,false,true,false,true,false,LOC("$$$/AgCameraRawController/PostCropVignetteStyle/Exposure1=Highlight Priority"),effects,"Post Crop Vignette Style: Highlight Priority. *button*",'effectsPanel'},
  {"PostCropVignetteStyleColorPriority",false,false,true,false,true,true,LOC("$$$/AgCameraRawController/PostCropVignetteStyle/Exposure2=Color Priority"),effects,"Post Crop Vignette Style: Color Priority. *button*",'effectsPanel'},
  {"PostCropVignetteStylePaintOverlay",false,false,true,false,true,true,LOC("$$$/AgCameraRawController/PostCropVignetteStyle/PaintOverlay=Paint Overlay"),effects,"Post Crop Vignette Style: Paint Overlay. *button*",'effectsPanel'},
  {"PostCropVignetteHighlightContrast",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteHighlightContrast=Post Crop Vignette Highlight Contrast"),effects,"(Highlight Priority and Color Priority only) Controls the degree of highlight contrast preserved when Amount is negative. Suitable for photos with small highlights, such as candles and lamps.",'effectsPanel'},
  {"GrainAmount",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainAmount=Grain Amount"),effects,"Controls the amount of grain applied to the image. Drag to the right to increase the amount. Set to zero to disable grain.",'effectsPanel'},
  {"GrainSize",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainSize=Grain Size"),effects,"Controls grain particle size. At sizes of 25 or greater, blue is added to make the effect look better with noise reduction.",'effectsPanel'},
  {"GrainFrequency",'effectsPanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainRoughness=Grain Roughness"),effects," Controls the regularity of the grain. Drag to the left to make the grain more uniform; drag to the right to make the grain more uneven.",'effectsPanel'},
  {"ResetDehaze",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/DehazeAmount=Dehaze Amount"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteAmount",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteAmount=Post Crop Vignette Amount"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteMidpoint",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteMidpoint=Post Crop Vignette Midpoint"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteFeather",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteFeather=Post Crop Vignette Feather"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteRoundness",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteRoundness=Post Crop Vignette Roundness"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteStyle",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteStyle=Post Crop Vignette Style"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetPostCropVignetteHighlightContrast",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/PostCropVignetteHighlightContrast=Post Crop Vignette Highlight Contrast"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetGrainAmount",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainAmount=Grain Amount"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetGrainSize",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainSize=Grain Size"),effects,"Reset to default. *button*",'effectsPanel'},
  {"ResetGrainFrequency",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GrainRoughness=Grain Roughness"),effects,"Reset to default. *button*",'effectsPanel'},
--
--develop: calibration panel
--
  {"RevealPanelCalibrate",false,false,true,false,true,false,show..' '..calibration,calibration,"Open Camera Calibration Panel in Develop Module. *button*"},
  {"EnableCalibration",'calibratePanel',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableCalibration=Enable Calibration"),calibration,"Enable or disable custom camera calibration. *button*",'calibratePanel'},
  {"CameraProfile",'calibratePanel',true,false,false,true,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/CameraProfile=Camera Profile")},
  {"Profile_Adobe_Standard",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/AdobeStandard=Adobe Standard"),calibration,"Applies the Adobe Standard profile. *button*",'calibratePanel'},
  {"Profile_Camera_Clear",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraClear=Camera Clear"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Darker_Skin_Tone",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraDarkerSkinTone=Camera Darker Skin Tone"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Deep",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraDeep=Camera Deep"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Faithful",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraFaithful=Camera Faithful"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Flat",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraFlat=Camera Flat"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Landscape",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraLandscape=Camera Landscape"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Light",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraLight=Camera Light"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Lighter_Skin_Tone",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraLighterSkinTone=Camera Lighter Skin Tone"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Monochrome",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraMonochrome=Camera Monochrome"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Monotone",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraMonotone=Camera Monotone"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Muted",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraMuted=Camera Muted"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Natural",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraNatural=Camera Natural"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set *for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. button*", 'calibratePanel'},
  {"Profile_Camera_Neutral",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraNeutral=Camera Neutral"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Portrait",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraPortrait=Camera Portrait"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Positive_Film",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraPositiveFilm=Camera Positive Film"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Standard",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraStandard=Camera Standard"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Vivid",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraVivid=Camera Vivid"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. *button*",'calibratePanel'},
  {"Profile_Camera_Vivid_Blue",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraVividBlue=Camera Vivid Blue"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Vivid_Green",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraVividGreen=Camera Vivid Green"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},
  {"Profile_Camera_Vivid_Red",false,false,true,false,true,true,LOC("$$$/CRaw/Style/Profile/CameraVividRed=Camera Vivid Red"),calibration,"These profiles attempt to match the camera manufacturer\226\128\153s color appearance under specific settings. If Adobe doesn\226\128\153t have this profile set up for your camera, using it may have unexpected results. Additionallly, the code for this particular setting has not been fully tested, so even if Adobe has this profile set for your camera, it may not work. Please [post an issue](https://groups.google.com/forum/#!forum/midi2lr) if this happens. *button*", 'calibratePanel'},  
  {"ShadowTint",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ShadowTintCalibration=Shadow Tint Calibration"),calibration,"Corrects for any green or magenta tint in the shadow areas of the photo.",'calibratePanel'},
  {"RedHue",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/RedHueCalibration=Red Hue Calibration"),calibration,"For the red primary. Moving the Hue slider to the left (negative value) is similar to a counterclockwise move on the color wheel; moving it to the right (positive value) is similar to a clockwise move.",'calibratePanel'},
  {"RedSaturation",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/RedSaturationCalibration=Red Saturation Calibration"),calibration,"For the red primary. Moving the Saturation slider to the left (negative value) desaturates the color; moving it to the right (positive value) increases saturation.",'calibratePanel'},
  {"GreenHue",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenHueCalibration=Green Hue Calibration"),calibration,"For the green primary. Moving the Hue slider to the left (negative value) is similar to a counterclockwise move on the color wheel; moving it to the right (positive value) is similar to a clockwise move.",'calibratePanel'},
  {"GreenSaturation",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenSaturationCalibration=Green Saturation Calibration"),calibration,"For the green primary. Moving the Saturation slider to the left (negative value) desaturates the color; moving it to the right (positive value) increases saturation.",'calibratePanel'},
  {"BlueHue",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/BlueHueCalibration=Blue Hue Calibration"),calibration,"For the blue primary. Moving the Hue slider to the left (negative value) is similar to a counterclockwise move on the color wheel; moving it to the right (positive value) is similar to a clockwise move.",'calibratePanel'},
  {"BlueSaturation",'calibratePanel',true,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/BlueSaturationCalibration=Blue Saturation Calibration"),calibration,"For the blue primary. Moving the Saturation slider to the left (negative value) desaturates the color; moving it to the right (positive value) increases saturation.",'calibratePanel'},
  {"ResetShadowTint",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/ShadowTintCalibration=Shadow Tint Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetRedHue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/RedHueCalibration=Red Hue Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetRedSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/RedSaturationCalibration=Red Saturation Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetGreenHue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenHueCalibration=Green Hue Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetGreenSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/GreenSaturationCalibration=Green Saturation Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetBlueHue",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/BlueHueCalibration=Blue Hue Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
  {"ResetBlueSaturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/BlueSaturationCalibration=Blue Saturation Calibration"),calibration,"Reset to default. *button*",'calibratePanel'},
--
--develop: develop presets
--
  {"Preset_1",false,false,true,false,true,false,developPreset.." 1",developPresets,"Apply preset 1 to active photo only. *button*"},
  {"Preset_2",false,false,true,false,true,false,developPreset.." 2",developPresets,"Apply preset 2 to active photo only. *button*"},
  {"Preset_3",false,false,true,false,true,false,developPreset.." 3",developPresets,"Apply preset 3 to active photo only. *button*"},
  {"Preset_4",false,false,true,false,true,false,developPreset.." 4",developPresets,"Apply preset 4 to active photo only. *button*"},
  {"Preset_5",false,false,true,false,true,false,developPreset.." 5",developPresets,"Apply preset 5 to active photo only. *button*"},
  {"Preset_6",false,false,true,false,true,false,developPreset.." 6",developPresets,"Apply preset 6 to active photo only. *button*"},
  {"Preset_7",false,false,true,false,true,false,developPreset.." 7",developPresets,"Apply preset 7 to active photo only. *button*"},
  {"Preset_8",false,false,true,false,true,false,developPreset.." 8",developPresets,"Apply preset 8 to active photo only. *button*"},
  {"Preset_9",false,false,true,false,true,false,developPreset.." 9",developPresets,"Apply preset 9 to active photo only. *button*"},
  {"Preset_10",false,false,true,false,true,false,developPreset.." 10",developPresets,"Apply preset 10 to active photo only. *button*"},
  {"Preset_11",false,false,true,false,true,false,developPreset.." 11",developPresets,"Apply preset 11 to active photo only. *button*"},
  {"Preset_12",false,false,true,false,true,false,developPreset.." 12",developPresets,"Apply preset 12 to active photo only. *button*"},
  {"Preset_13",false,false,true,false,true,false,developPreset.." 13",developPresets,"Apply preset 13 to active photo only. *button*"},
  {"Preset_14",false,false,true,false,true,false,developPreset.." 14",developPresets,"Apply preset 14 to active photo only. *button*"},
  {"Preset_15",false,false,true,false,true,false,developPreset.." 15",developPresets,"Apply preset 15 to active photo only. *button*"},
  {"Preset_16",false,false,true,false,true,false,developPreset.." 16",developPresets,"Apply preset 16 to active photo only. *button*"},
  {"Preset_17",false,false,true,false,true,false,developPreset.." 17",developPresets,"Apply preset 17 to active photo only. *button*"},
  {"Preset_18",false,false,true,false,true,false,developPreset.." 18",developPresets,"Apply preset 18 to active photo only. *button*"},
  {"Preset_19",false,false,true,false,true,false,developPreset.." 19",developPresets,"Apply preset 19 to active photo only. *button*"},
  {"Preset_20",false,false,true,false,true,false,developPreset.." 20",developPresets,"Apply preset 20 to active photo only. *button*"},
  {"Preset_21",false,false,true,false,true,false,developPreset.." 21",developPresets,"Apply preset 21 to active photo only. *button*"},
  {"Preset_22",false,false,true,false,true,false,developPreset.." 22",developPresets,"Apply preset 22 to active photo only. *button*"},
  {"Preset_23",false,false,true,false,true,false,developPreset.." 23",developPresets,"Apply preset 23 to active photo only. *button*"},
  {"Preset_24",false,false,true,false,true,false,developPreset.." 24",developPresets,"Apply preset 24 to active photo only. *button*"},
  {"Preset_25",false,false,true,false,true,false,developPreset.." 25",developPresets,"Apply preset 25 to active photo only. *button*"},
  {"Preset_26",false,false,true,false,true,false,developPreset.." 26",developPresets,"Apply preset 26 to active photo only. *button*"},
  {"Preset_27",false,false,true,false,true,false,developPreset.." 27",developPresets,"Apply preset 27 to active photo only. *button*"},
  {"Preset_28",false,false,true,false,true,false,developPreset.." 28",developPresets,"Apply preset 28 to active photo only. *button*"},
  {"Preset_29",false,false,true,false,true,false,developPreset.." 29",developPresets,"Apply preset 29 to active photo only. *button*"},
  {"Preset_30",false,false,true,false,true,false,developPreset.." 30",developPresets,"Apply preset 30 to active photo only. *button*"},
  {"Preset_31",false,false,true,false,true,false,developPreset.." 31",developPresets,"Apply preset 31 to active photo only. *button*"},
  {"Preset_32",false,false,true,false,true,false,developPreset.." 32",developPresets,"Apply preset 32 to active photo only. *button*"},
  {"Preset_33",false,false,true,false,true,false,developPreset.." 33",developPresets,"Apply preset 33 to active photo only. *button*"},
  {"Preset_34",false,false,true,false,true,false,developPreset.." 34",developPresets,"Apply preset 34 to active photo only. *button*"},
  {"Preset_35",false,false,true,false,true,false,developPreset.." 35",developPresets,"Apply preset 35 to active photo only. *button*"},
  {"Preset_36",false,false,true,false,true,false,developPreset.." 36",developPresets,"Apply preset 36 to active photo only. *button*"},
  {"Preset_37",false,false,true,false,true,false,developPreset.." 37",developPresets,"Apply preset 37 to active photo only. *button*"},
  {"Preset_38",false,false,true,false,true,false,developPreset.." 38",developPresets,"Apply preset 38 to active photo only. *button*"},
  {"Preset_39",false,false,true,false,true,false,developPreset.." 39",developPresets,"Apply preset 39 to active photo only. *button*"},
  {"Preset_40",false,false,true,false,true,false,developPreset.." 40",developPresets,"Apply preset 40 to active photo only. *button*"},
  {"Preset_41",false,false,true,false,true,false,developPreset.." 41",developPresets,"Apply preset 41 to active photo only. *button*"},
  {"Preset_42",false,false,true,false,true,false,developPreset.." 42",developPresets,"Apply preset 42 to active photo only. *button*"},
  {"Preset_43",false,false,true,false,true,false,developPreset.." 43",developPresets,"Apply preset 43 to active photo only. *button*"},
  {"Preset_44",false,false,true,false,true,false,developPreset.." 44",developPresets,"Apply preset 44 to active photo only. *button*"},
  {"Preset_45",false,false,true,false,true,false,developPreset.." 45",developPresets,"Apply preset 45 to active photo only. *button*"},
  {"Preset_46",false,false,true,false,true,false,developPreset.." 46",developPresets,"Apply preset 46 to active photo only. *button*"},
  {"Preset_47",false,false,true,false,true,false,developPreset.." 47",developPresets,"Apply preset 47 to active photo only. *button*"},
  {"Preset_48",false,false,true,false,true,false,developPreset.." 48",developPresets,"Apply preset 48 to active photo only. *button*"},
  {"Preset_49",false,false,true,false,true,false,developPreset.." 49",developPresets,"Apply preset 49 to active photo only. *button*"},
  {"Preset_50",false,false,true,false,true,false,developPreset.." 50",developPresets,"Apply preset 50 to active photo only. *button*"},
  {"Preset_51",false,false,true,false,true,false,developPreset.." 51",developPresets,"Apply preset 51 to active photo only. *button*"},
  {"Preset_52",false,false,true,false,true,false,developPreset.." 52",developPresets,"Apply preset 52 to active photo only. *button*"},
  {"Preset_53",false,false,true,false,true,false,developPreset.." 53",developPresets,"Apply preset 53 to active photo only. *button*"},
  {"Preset_54",false,false,true,false,true,false,developPreset.." 54",developPresets,"Apply preset 54 to active photo only. *button*"},
  {"Preset_55",false,false,true,false,true,false,developPreset.." 55",developPresets,"Apply preset 55 to active photo only. *button*"},
  {"Preset_56",false,false,true,false,true,false,developPreset.." 56",developPresets,"Apply preset 56 to active photo only. *button*"},
  {"Preset_57",false,false,true,false,true,false,developPreset.." 57",developPresets,"Apply preset 57 to active photo only. *button*"},
  {"Preset_58",false,false,true,false,true,false,developPreset.." 58",developPresets,"Apply preset 58 to active photo only. *button*"},
  {"Preset_59",false,false,true,false,true,false,developPreset.." 59",developPresets,"Apply preset 59 to active photo only. *button*"},
  {"Preset_60",false,false,true,false,true,false,developPreset.." 60",developPresets,"Apply preset 60 to active photo only. *button*"},
  {"Preset_61",false,false,true,false,true,false,developPreset.." 61",developPresets,"Apply preset 61 to active photo only. *button*"},
  {"Preset_62",false,false,true,false,true,false,developPreset.." 62",developPresets,"Apply preset 62 to active photo only. *button*"},
  {"Preset_63",false,false,true,false,true,false,developPreset.." 63",developPresets,"Apply preset 63 to active photo only. *button*"},
  {"Preset_64",false,false,true,false,true,false,developPreset.." 64",developPresets,"Apply preset 64 to active photo only. *button*"},
  {"Preset_65",false,false,true,false,true,false,developPreset.." 65",developPresets,"Apply preset 65 to active photo only. *button*"},
  {"Preset_66",false,false,true,false,true,false,developPreset.." 66",developPresets,"Apply preset 66 to active photo only. *button*"},
  {"Preset_67",false,false,true,false,true,false,developPreset.." 67",developPresets,"Apply preset 67 to active photo only. *button*"},
  {"Preset_68",false,false,true,false,true,false,developPreset.." 68",developPresets,"Apply preset 68 to active photo only. *button*"},
  {"Preset_69",false,false,true,false,true,false,developPreset.." 69",developPresets,"Apply preset 69 to active photo only. *button*"},
  {"Preset_70",false,false,true,false,true,false,developPreset.." 70",developPresets,"Apply preset 70 to active photo only. *button*"},
  {"Preset_71",false,false,true,false,true,false,developPreset.." 71",developPresets,"Apply preset 71 to active photo only. *button*"},
  {"Preset_72",false,false,true,false,true,false,developPreset.." 72",developPresets,"Apply preset 72 to active photo only. *button*"},
  {"Preset_73",false,false,true,false,true,false,developPreset.." 73",developPresets,"Apply preset 73 to active photo only. *button*"},
  {"Preset_74",false,false,true,false,true,false,developPreset.." 74",developPresets,"Apply preset 74 to active photo only. *button*"},
  {"Preset_75",false,false,true,false,true,false,developPreset.." 75",developPresets,"Apply preset 75 to active photo only. *button*"},
  {"Preset_76",false,false,true,false,true,false,developPreset.." 76",developPresets,"Apply preset 76 to active photo only. *button*"},
  {"Preset_77",false,false,true,false,true,false,developPreset.." 77",developPresets,"Apply preset 77 to active photo only. *button*"},
  {"Preset_78",false,false,true,false,true,false,developPreset.." 78",developPresets,"Apply preset 78 to active photo only. *button*"},
  {"Preset_79",false,false,true,false,true,false,developPreset.." 79",developPresets,"Apply preset 79 to active photo only. *button*"},
  {"Preset_80",false,false,true,false,true,false,developPreset.." 80",developPresets,"Apply preset 80 to active photo only. *button*"},

--
--keywords
--

  {"Keyword1",false,false,true,false,true,false,keyword.." 1",keywords,"Apply keyword 1 to active photo only. *button*"},
  {"Keyword2",false,false,true,false,true,false,keyword.." 2",keywords,"Apply keyword 2 to active photo only. *button*"},
  {"Keyword3",false,false,true,false,true,false,keyword.." 3",keywords,"Apply keyword 3 to active photo only. *button*"},
  {"Keyword4",false,false,true,false,true,false,keyword.." 4",keywords,"Apply keyword 4 to active photo only. *button*"},
  {"Keyword5",false,false,true,false,true,false,keyword.." 5",keywords,"Apply keyword 5 to active photo only. *button*"},
  {"Keyword6",false,false,true,false,true,false,keyword.." 6",keywords,"Apply keyword 6 to active photo only. *button*"},
  {"Keyword7",false,false,true,false,true,false,keyword.." 7",keywords,"Apply keyword 7 to active photo only. *button*"},
  {"Keyword8",false,false,true,false,true,false,keyword.." 8",keywords,"Apply keyword 8 to active photo only. *button*"},
  {"Keyword9",false,false,true,false,true,false,keyword.." 9",keywords,"Apply keyword 9 to active photo only. *button*"},
  {"Keyword10",false,false,true,false,true,false,keyword.." 10",keywords,"Apply keyword 10 to active photo only. *button*"},
  {"Keyword11",false,false,true,false,true,false,keyword.." 11",keywords,"Apply keyword 11 to active photo only. *button*"},
  {"Keyword12",false,false,true,false,true,false,keyword.." 12",keywords,"Apply keyword 12 to active photo only. *button*"},
  {"Keyword13",false,false,true,false,true,false,keyword.." 13",keywords,"Apply keyword 13 to active photo only. *button*"},
  {"Keyword14",false,false,true,false,true,false,keyword.." 14",keywords,"Apply keyword 14 to active photo only. *button*"},
  {"Keyword15",false,false,true,false,true,false,keyword.." 15",keywords,"Apply keyword 15 to active photo only. *button*"},
  {"Keyword16",false,false,true,false,true,false,keyword.." 16",keywords,"Apply keyword 16 to active photo only. *button*"},

--
--develop: localized adjustments
--
  {"GraduatedFilter",false,false,true,false,true,false,show..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/GraduatedFilters=Graduated Filters"),localizedAdjustments,"Select Graduated Filter mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"RadialFilter",false,false,true,false,true,false,show..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/RadialFilters=Radial Filters"),localizedAdjustments,"Select Radial Filter View mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"RedEyeInfo",'localizedAdjustments',true,false,false,true,false,LOC("$$$/MIDI2LR/Parameters/RedEyeInfo=Red-Eye Information")},
  {"RedEye",false,false,true,false,true,false,show..' '..LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/Redeye=Red-Eye Correction"),localizedAdjustments,"Select Red Eye mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"SpotRemoval",false,false,true,false,true,false,show..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/SpotRemoval=Spot Removal"),localizedAdjustments,"Select Spot Removal mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"AdjustmentBrush",false,false,true,false,true,false,show..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/BrushAdjustments=Brush Adjustments"),localizedAdjustments,"Select Adjustment Brush mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"ChangeBrushSize",false,false,true,false,true,false,brush..' — '..size,localizedAdjustments,"Change adjustment brush size. This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command. Turning knob clockwise sends Increase Size signals to Lightroom, counterclockwise Decrease Size. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"BrushSizeSmaller",false,false,true,false,true,false,brush..' — '..size..' — '..smaller,localizedAdjustments,"Reduce adjustment brush size.  This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command. *button*"},
  {"BrushSizeLarger",false,false,true,false,true,false,brush..' — '..size..' — '..larger,localizedAdjustments,"Increase adjustment brush size.  This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command. *button*"},
  {"ChangeFeatherSize",false,false,true,false,true,false,brush..' — '..feather,localizedAdjustments,"Change adjustment brush feather size.  This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command. Turning knob clockwise sends Increase Size signals to Lightroom, counterclockwise Decrease Size. Not suitable for controls with hard stops like faders. This command not usable in [Series of Commands](https://github.com/rsjaffe/MIDI2LR/wiki/Plugin-Options-Dialog#series-of-commands)."},
  {"BrushFeatherSmaller",false,false,true,false,true,false,brush..' — '..feather..' — '..smaller,localizedAdjustments,"Reduce adjustment brush feather. This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command.  *button*"},
  {"BrushFeatherLarger",false,false,true,false,true,false,brush..' — '..feather..' — '..larger,localizedAdjustments,"Increase adjustment brush feather. This works with spot, gradient, radial filter and localized adjustment tools. Caution, with gradient and radial filter, make sure *brush* is selected when using this command.  *button*"},
  {"local_Temperature",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Temperature=Temp.").." (PV2012)",localizedAdjustments,"Adjust Temperature for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Tint",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Tint=Tint").." (PV2012)",localizedAdjustments,"Adjust Tint for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Exposure",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Exposure=Exposure").." (PV2010 and PV2012)",localizedAdjustments,"Adjust Exposure for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Contrast",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Contrast=Contrast").." (PV2010 and PV2012)",localizedAdjustments,"Adjust Contrast for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Highlights",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Highlights=Highlights").." (PV2012)",localizedAdjustments,"Adjust Highlights for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Shadows",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Shadows=Shadows").." (PV2012)",localizedAdjustments,"Adjust Shadows for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Whites2012",false,false,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Whites=Whites").." (PV2012)",localizedAdjustments,"Adjust Whites for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Blacks2012",false,false,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Blacks=Blacks").." (PV2012)",localizedAdjustments,"Adjust Blacks for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Clarity",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Clarity=Clarity").." (PV2010 and PV2012)",localizedAdjustments,"Adjust Clarity for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Dehaze",false,false,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Dehaze=Dehaze").." (PV2012)",localizedAdjustments,"Adjust Dehaze for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Saturation",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Saturation=Saturation").." (PV2010 and PV2012)",localizedAdjustments,"Adjust Saturation for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Sharpness",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Sharpness=Sharpness").." (PV2010 and PV2012)",localizedAdjustments,"Adjust Sharpness for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_LuminanceNoise",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/LuminanceNoiseReduction=Luminence Noise Reduction").." (PV2012)",localizedAdjustments,"Adjust Luminance Noise for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Moire",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/MoireReduction=Moire").." (PV2012)",localizedAdjustments,"Adjust Moire for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_Defringe",false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Defringe=Defringe").." (PV2012)",localizedAdjustments,"Adjust Defringe for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"local_ToningLuminance",false,false,true,true,false,false,"Local Toning Luminance (PV2010)",localizedAdjustments,"Adjust Toning Luminance for the currently active tool: Brush, Radial Filter, or Graduated Filter."},
  {"Resetlocal_Temperature",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Temperature=Temp.").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Tint",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Tint=Tint").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Exposure",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Exposure=Exposure").." (PV2010 and PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Contrast",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Contrast=Contrast").." (PV2010 and PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Highlights",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Highlights=Highlights").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Shadows",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Shadows=Shadows").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Whites2012",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Whites=Whites").." (PV2012)",localizedAdjustments,"Reset to default. *button*"}, 
  {"Resetlocal_Blacks2012",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Blacks=Blacks").." (PV2012)",localizedAdjustments,"Reset to default. *button*"}, 
  {"Resetlocal_Clarity",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Clarity=Clarity").." (PV2010 and PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Dehaze",false,false,true,false,true,true,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Dehaze=Dehaze").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Saturation",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Saturation=Saturation").." (PV2010 and PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Sharpness",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Sharpness=Sharpness").." (PV2010 and PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_LuminanceNoise",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/LuminanceNoiseReduction=Luminence Noise Reduction").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Moire",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/MoireReduction=Moire").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_Defringe",false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/LocalAdjustments=Local Adjustments")..' '..LOC("$$$/AgDevelop/Localized/Defringe=Defringe").." (PV2012)",localizedAdjustments,"Reset to default. *button*"},
  {"Resetlocal_ToningLuminance",false,false,true,false,true,false,"Reset Local Toning Luminance (PV2010)",localizedAdjustments,"Reset to default. *button*"},
  {"EnableCircularGradientBasedCorrections",'localizedAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableRadialFilter=Enable Radial Filter"),localizedAdjustments,"Enable or disable radial filter. *button*"},
  {"EnableGradientBasedCorrections",'localizedAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableGraduatedFilter=Enable Graduated Filter"),localizedAdjustments,"Enable or disable graduated filter. *button*"},
  {"EnablePaintBasedCorrections",'localizedAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableBrushAdjustments=Enable Brush Adjustments"),localizedAdjustments,"Enable or disable brush adjustments. *button*"},
  {"EnableRedEye",'localizedAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableRedEye=Enable Red-Eye"),localizedAdjustments,"Enable or disable red eye correction. *button*"},
  {"EnableRetouch",'localizedAdjustments',true,true,false,true,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/EnableSpotRemoval=Enable Spot Removal"),localizedAdjustments,"Enable or disable spot removal. *button*"},
  {"RetouchInfo",'localizedAdjustments',true,false,false,true,false,"RetouchInfo"},
  {"ResetCircGrad",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetRadialFilters=Reset Radial Filters"),localizedAdjustments,"Delete radial filter. *button*"},
  {"ResetGradient",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetGraduatedFilters=Reset Graduated Filters"),localizedAdjustments,"Delete graduated filter. *button*"},
  {"ResetBrushing",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetBrushing=Reset Brush Corrections"),localizedAdjustments,"Delete brush adjustments. *button*"},
  {"ResetRedeye",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetRedeye=Reset Red-Eye"),localizedAdjustments,"Delete red eye correction. *button*"},
  {"ResetSpotRem",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetSpotRemoval=Reset Spot Removal"),localizedAdjustments,"Delete spot removal. *button*"},
  {"ShowMaskOverlay",false,false,true,false,true,false,LOC("$$$/AgDevelop/LocalizedToolbar/ShowMaskOverlay=Show Mask Overlay"),localizedAdjustments,"Show or hide the mask overlay. *button*"},
  {"CycleMaskOverlayColor",false,false,true,false,true,false,LOC("$$$/AgDevelop/Menu/View/AdjustmentBrushOverlay/CycleOverlay=Overlay Color"):gsub("&",""),localizedAdjustments,"Change Mask Overlay Color. *button*"},
  {"LocalPreset1",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 1",localizedAdjustments,"Use preset 1 for localized adjustments. *button*"},
  {"LocalPreset2",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 2",localizedAdjustments,"Use preset 2 for localized adjustments. *button*"},
  {"LocalPreset3",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 3",localizedAdjustments,"Use preset 3 for localized adjustments. *button*"},
  {"LocalPreset4",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 4",localizedAdjustments,"Use preset 4 for localized adjustments. *button*"},
  {"LocalPreset5",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 5",localizedAdjustments,"Use preset 5 for localized adjustments. *button*"},
  {"LocalPreset6",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 6",localizedAdjustments,"Use preset 6 for localized adjustments. *button*"},
  {"LocalPreset7",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 7",localizedAdjustments,"Use preset 7 for localized adjustments. *button*"},
  {"LocalPreset8",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 8",localizedAdjustments,"Use preset 8 for localized adjustments. *button*"},
  {"LocalPreset9",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 9",localizedAdjustments,"Use preset 9 for localized adjustments. *button*"},  
  {"LocalPreset10",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 10",localizedAdjustments,"Use preset 10 for localized adjustments. *button*"},  
  {"LocalPreset11",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 11",localizedAdjustments,"Use preset 11 for localized adjustments. *button*"},  
  {"LocalPreset12",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 12",localizedAdjustments,"Use preset 12 for localized adjustments. *button*"},  
  {"LocalPreset13",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 13",localizedAdjustments,"Use preset 13 for localized adjustments. *button*"},  
  {"LocalPreset14",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 14",localizedAdjustments,"Use preset 14 for localized adjustments. *button*"},  
  {"LocalPreset15",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 15",localizedAdjustments,"Use preset 15 for localized adjustments. *button*"}, 
  {"LocalPreset16",false,false,true,false,true,false,LOC("$$$/MIDI2LR/LocalPresets/Presets=Local adjustments presets").." 16",localizedAdjustments,"Use preset 16 for localized adjustments. *button*"},  
--
-- Misc
--
  {"orientation",'miscellaneous',true,false,false,true,false,"orientation"},
  {'straightenAngle',false,false,true,true,false,false,LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/StraightenAngle=Straighten Angle"),crop,"Rotate crop angle. Moves angle in crop tool panel from -45 to 45."},
  {"CropAngle",'miscellaneous',true,true,true,false,true,LOC("$$$/AgCameraRawNamedSettings/CameraRawSettingMapping/CropAngle=Crop Angle"),crop,"Use *Straighten Angle* (above) instead. This control remains listed as a legacy item. Rotate crop rectangle. This control is constrained to picture boundaries even when \226\128\156constrain to image\226\128\157 is not selected. It also causes the aspect ratio of the crop to change.",'crop'},
  {"CropBottom",'miscellaneous',true,true,true,false,true,crop..' - '.. LOC("$$$/Layout/Panel/Panel/OutputFormat/PageNumber/Bottom=Bottom"),crop,"Adjust bottom of crop rectangle.",'crop'},
  {"CropLeft",'miscellaneous',true,true,true,false,true,crop..' - '..LOC("$$$/AgWatermarking/Alignment/Left=Left"),crop,"Adjust left side of crop rectangle.",'crop'},
  {"CropRight",'miscellaneous',true,true,true,false,true,crop..' - '..LOC("$$$/AgWatermarking/Alignment/Right=Right"),crop,"Adjust right side of crop rectangle.",'crop'},
  {"CropTop",'miscellaneous',true,true,true,false,true,crop..' - '..LOC("$$$/Layout/Panel/Panel/OutputFormat/PageNumber/Top=Top"),crop,"Adjust top of crop rectangle.",'crop'},
  {"ResetCrop",false,false,true,false,true,false,LOC("$$$/AgLibrary/Ops/ResetCrop=Reset Crop"),crop,"Reset the crop angle and frame for the current photo. *button*",'crop'},
  {'ResetstraightenAngle',false,false,true,false,true,false,reset..' '..LOC("$$$/AgCameraRawNamedSettings/SaveNamedDialog/StraightenAngle=Straighten Angle"),crop,"Reset crop angle. *button*"},
  {"CropOverlay",false,false,true,false,true,false,show..' '..crop,crop,"Select Crop Overlay mode in Develop Module. Repeated press toggles Loupe View. *button*"},
  {"Loupe",false,false,true,false,true,false,show..' '..LOC("$$$/AgPhotoBin/ViewMode/Develop/Loupe=Loupe"),gotoToolModulePanel,"Select Loupe View mode in Develop Module. Repeated press toggles in and out of Loupe View. *button*",'loupe'},
  {"SwToMmap",false,false,true,false,true,false,show..' '..LOC("$$$/AgLocation/ModuleTitle=Map"),gotoToolModulePanel,"Switch to Map module. *button*"},
  {"SwToMbook",false,false,true,false,true,false,show..' '..LOC("$$$/Ag/Layout/Book/ModuleTitle=Book"),gotoToolModulePanel,"Switch to Book module. *button*"},
  {"SwToMslideshow",false,false,true,false,true,false,show..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Slideshow=Slideshow"),gotoToolModulePanel,"Switch to Slideshow module. *button*"},
  {"SwToMprint",false,false,true,false,true,false,show..' '..LOC("$$$/AgPrint/Menu/File/Print=Print"),gotoToolModulePanel,"Switch to Print module. *button*"},
  {"SwToMweb",false,false,true,false,true,false,show..' '..LOC("$$$/WPG/Help/Shortcuts/WebHeader=Web"),gotoToolModulePanel,"Switch to Web module. *button*"},
  {"ShoScndVwloupe",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Loupe=Loupe"),secondaryDisplay,"Shows Loupe view on the secondary screen, or hides the secondary screen if Loupe view was previously being shown. *button*"},
  {"ShoScndVwlive_loupe",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/LiveLoupe=Live Loupe"),secondaryDisplay,"Shows Live Loupe view on the secondary screen, or hides the secondary screen if Live Loupe view was previously being shown. *button*"},
  {"ShoScndVwlocked_loupe",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/LockedLoupe=Locked Loupe"),secondaryDisplay,"Shows Locked Loupe view on the secondary screen, or hides the secondary screen if Locked Loupe view was previously being shown. *button*"},
  {"ShoScndVwgrid",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Grid=Grid"),secondaryDisplay,"Shows Grid view on the secondary screen, or hides the secondary screen if Grid view was previously being shown. *button*"},
  {"ShoScndVwcompare",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Compare=Compare"),secondaryDisplay,"Shows Compare view on the secondary screen, or hides the secondary screen if Compare view was previously being shown. *button*"},
  {"ShoScndVwsurvey",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Survey=Survey"),secondaryDisplay,"Shows Survey view on the secondary screen, or hides the secondary screen if Survey view was previously being shown. *button*"},
  {"ShoScndVwslideshow",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Slideshow=Slideshow"),secondaryDisplay,"Shows Slideshow view on the secondary screen, or hides the secondary screen if Slideshow view was previously being shown. *button*"},
  {"ToggleScreenTwo",false,false,true,false,true,false,secondaryDisplay..' '..LOC("$$$/AgApplication/Menu/Window/SecondMonitor/Show=Show"),secondaryDisplay,"Toggles the the secondary window on/off. *button*"},
  {"profile1",false,false,true,false,true,false,profile.." 1",profiles,"Change to MIDI mapping profile 1. *button*"},
  {"profile2",false,false,true,false,true,false,profile.." 2",profiles,"Change to MIDI mapping profile 2. *button*"},
  {"profile3",false,false,true,false,true,false,profile.." 3",profiles,"Change to MIDI mapping profile 3. *button*"},
  {"profile4",false,false,true,false,true,false,profile.." 4",profiles,"Change to MIDI mapping profile 4. *button*"},
  {"profile5",false,false,true,false,true,false,profile.." 5",profiles,"Change to MIDI mapping profile 5. *button*"},
  {"profile6",false,false,true,false,true,false,profile.." 6",profiles,"Change to MIDI mapping profile 6. *button*"},
  {"profile7",false,false,true,false,true,false,profile.." 7",profiles,"Change to MIDI mapping profile 7. *button*"},
  {"profile8",false,false,true,false,true,false,profile.." 8",profiles,"Change to MIDI mapping profile 8. *button*"},
  {"profile9",false,false,true,false,true,false,profile.." 9",profiles,"Change to MIDI mapping profile 9. *button*"},
  {"profile10",false,false,true,false,true,false,profile.." 10",profiles,"Change to MIDI mapping profile 10. *button*"},
  {"FullRefresh",false,false,true,false,true,false,LOC("$$$/AgLibrary/ViewBar/Sort/RefreshMode/Manual=Manual Update"),profiles,"Force an update of all develop settings in MIDI controller, even if MIDI2LR believes MIDI controller is up-to-date. Useful if controller out of sync with Lightroom (e.g., with layer changes). *button*"},
  {"TrimEnd",true,true,false,false,true,false,LOC("$$$/AgLibrary/Ops/setTrimEnd=Set Trim End")},
  {"TrimStart",true,true,false,false,true,false,LOC("$$$/AgLibrary/Ops/setTrimStart=Set Trim Start")},
}

local MenuList = {}
local SelectivePasteMenu = {}
local SelectivePasteHidden = {}
local SelectivePasteIteration = {}
local SelectivePasteGroups = {}
local LimitEligible = {}
local SendToMidi = {}
local ProfileMap = {}
for i,v in ipairs(DataBase) do
  if v[4] then
    table.insert(MenuList,{v[1],v[8],v[9],v[6]})
    if v[5] then
      table.insert(SendToMidi,v[1])
      if v[6]==false then
        LimitEligible[v[1]] = {v[8],i}
      end
    end
  end
  if v[3] then
    table.insert(SelectivePasteIteration,v[1])
    if v[2] then
      table.insert(SelectivePasteMenu,{v[1],v[8]})
      if type(v[2]) == 'string' then
        if SelectivePasteGroups[v[2]] == nil then
          SelectivePasteGroups[v[2]] = {}
        end
        table.insert(SelectivePasteGroups[v[2]],v[1])
    end
  else
    SelectivePasteHidden[v[1]] = v[8]
  end
end
if v[11] then
  ProfileMap[v[1]] = v[11]
end
end

local paramdisp = {}
for i,v in pairs(LimitEligible) do
  local found = v[1]:find(' %(')
  if found then
    paramdisp[i] = v[1]:sub(1,found-1)
  else
    paramdisp[i] = v[1]
  end
end

local serpent = require 'serpent'
local LrPathUtils = import 'LrPathUtils'       
local datafile = LrPathUtils.child(_PLUGIN.path, 'MenuList.lua')
local file = assert(io.open(datafile,'w'),'Unable to write to plugin directory. Please reinstall plugin in a location where you have write privileges.')
file:write([=[
  --[[----------------------------------------------------------------------------

  MenuList.lua

  This file was auto-generated by MIDI2LR and contains the translated menus used
  by the app and the plugin. Edits to this file will be lost any time MIDI2LR
  is updated or the language used by Lightroom changes. Edit Database.lua
  if you want to have persistent changes to the translations or menu structure.

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
  local MenuList = ]=],serpent.block(MenuList, {comment = false}))
file:write([=[


return MenuList

]=])
file:close()

datafile = LrPathUtils.child(_PLUGIN.path, 'ParamList.lua')

file = assert(io.open(datafile,'w'),'Error writing to ParamList.lua')
file:write([=[
  --[[----------------------------------------------------------------------------

  ParamList.lua

  This file was auto-generated by MIDI2LR and contains the parameters used by the
  plugin. Edits to this file will be lost any time MIDI2LR is updated or the
  language used by Lightroom changes. Edit Database.lua if you want to have
  persistent changes to the translations or menu structure.

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
  local SelectivePasteMenu = ]=],serpent.block(SelectivePasteMenu, {comment = false}), [==[

  local SelectivePasteHidden = ]==],serpent.block(SelectivePasteHidden, {comment = false}), [==[

  local SelectivePasteIteration = ]==],serpent.block(SelectivePasteIteration, {comment = false}), [==[

  local SelectivePasteGroups = ]==],serpent.block(SelectivePasteGroups, {comment = false}), [==[

  local LimitEligible = ]==],serpent.block(LimitEligible, {comment = false}), [==[

  local SendToMidi = ]==],serpent.block(SendToMidi, {comment = false}), [==[

  local ProfileMap = ]==],serpent.block(ProfileMap, {comment = false}), [==[
  
  local ParamDisplay = ]==],serpent.block(paramdisp, {comment = false}), [==[
  
return {
    SelectivePasteMenu = SelectivePasteMenu,
    SelectivePasteHidden = SelectivePasteHidden,
    SelectivePasteIteration = SelectivePasteIteration,
    SelectivePasteGroups = SelectivePasteGroups,
    LimitEligible = LimitEligible,
    SendToMidi = SendToMidi,
    ProfileMap = ProfileMap,
    ParamDisplay = ParamDisplay,
    }]==])
file:close()

local function RunTests()
  --[[DataBase structure
  1. command
  2. include in selective paste menu [exclude localized adj]. if in button group on 
  menu, this will be a string identifying group. Otherwise this is true/false.
  3. include in selective paste iteration
  4. include in application command list
  5. send back values to MIDI controller
  6. button or table or text=true, variable number=false
  7. experimental (for documentation)
  8. user-friendly name or, for 2=false and 3=true, command it maps to
  9. menu group for app
  10. documentation right column
  11. panel for changing profile

  errors if:
  2=not false, 3=false
  4=false, 5=true
  4=false, 11 not nil
  8 nil and ((2 not false and 3 true) or (4 true))
  9 nil or "" and 4 true
  --]]
  local retval = ""
  for _,v in ipairs(DataBase) do
    local correcttypes = type(v[1])=='string' and (type(v[2])=='string' or type(v[2])=='boolean') and
    type(v[3])=='boolean' and type(v[4])=='boolean' and type(v[5])=='boolean' and type(v[6])=='boolean' 
    and type(v[7])=='boolean' and type(v[8])=='string' and (v[9]==nil or type(v[9])=='string')
    and (v[10]==nil or type(v[10])=='string') and (v[11]==nil or type(v[11])=='string')
    if correcttypes==false then
      retval = retval .. v[1].. " includes incorrect types in its data.\n"
    end
    if (v[2] and v[3]==false)then
      retval = retval .. v[1].." included in selective paste menu but not in selective paste iteration.\n"
    end
    if (v[4]==false and v[5]==true) then
      retval = retval .. v[1].." included in send back values to MIDI controller but not command list.\n"
    end
    if (v[4]==false and v[11]~=nil) then
      retval = retval .. v[1].." not in command list but assigned a panel for changing profile.\n"
    end
    if (v[8]==nil and ((v[2]~=false and v[3]==true) or (v[4]==true))) then
      retval = retval .. v[1].." missing a user-friendly name.\n"
    end
    if (v[4]==true and (v[9]==nil or v[9]=="")) then
      retval = retval .. v[1].." needs a menu group for app.\n"
    end
    if (v[12]==true and (type(v[13])~='string' or type(v[14])~='string')) then
      retval = retval .. v[1] .. " is marked as a key but is missing 1 or 2 keycodes.\n"
    end
    if (v[15]~= nil) then
      retval = retval .. v[1] .. " has too many parameters.\n"
    end


  end
  return retval
end

local cppvectors ={
  [basicTone]={'BasicAdjustments','Basic'},
  [calibration]={'Calibration','Camera Calibration'},
  [colorAdjustments]={'Mixer','HSL / Color / B&W'},
  [crop]={'Crop',crop},
  [detail]={'Detail','Detail'},
  [developPresets]={'DevelopPresets','Develop Presets'},
  [develop]={'Develop',develop},
  [effects]={'Effects','Effects'},
  [filter]={'Filters',filter},
  [general]={'General',general},
  [gotoToolModulePanel]={'ToolModulePanel','Go to Tool, Module, or Panel'},
  [keyshortcuts]={'KeyShortcuts',keyshortcuts},
  [keywords]={'Keywords',keywords},
  [lensCorrections]={'LensCorrections','Lens Corrections'},
  [library]={'Library',library},
  [localizedAdjustments]={'LocalAdjustments','Local Adjustments'},
  [miscellaneous]={'Misc','Miscellaneous'},
  [photoActions]={'SelectionList','Photo Actions'},
  [profiles]={'ProgramProfiles','Profiles'},
  [resetColorAdjustments]={'ResetMixer','Reset HSL / Color / B&W'},
  [secondaryDisplay]={'SecondaryDisplay',secondaryDisplay},
  [splitToning]={'SplitToning','Split Toning'},
  [toneCurve]={'ToneCurve','Tone Curve'},
  [transform]={'Transform',transform},
}


return { --used in documentation module
  DataBase = DataBase,
  RunTests = RunTests,
  cppvectors = cppvectors,
}

