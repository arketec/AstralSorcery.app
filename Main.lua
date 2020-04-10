
-- Import libraries
local GUI = require("GUI")
local system = require("System")

------------------------------ Code ---------------------------------------------

local Altar = {}
Altar.__index = Altar

function Altar:new()
  local self = {
    state = -1,
    crafting = false,
    available = true,
    transitioning = false,
    clear = true    
  }
  return setmetatable(self, Altar)
end

function Altar:up()
  self.transitioning = true
  GUI.alert('Altar Up!')
  self.transitioning = false
  self.state = 1
end

function Altar:down()
  self.transitioning = true
  GUI.alert('Altar Down!')
  self.transitioning = false
  self.state = 0  
end

function Altar:getState()
  if (self.transitioning) then
    return 'transitioning'
  elseif (self.crafting) then
    return 'crafting'
  end
  if (self.state == 0) then
    return 'up'
  elseif (self.state == 1) then
    return 'down'
  end
  return 'unknown'
end

function Altar:isCrafting()
  return self.crafting
end

function Altar:isAvailable()
  return self.available
end

function Altar:isClear()
  return self.clear
end

function Altar:isTransitioning()
  return self.transitioning
end

---------------------------- Initialization ------------------------------------
local altar = Altar:new()


------------------------------ GUI ----------------------------------------------
-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 20, 0xE1E1E1))

-- Get localization table dependent of current system language
local localization = system.getCurrentScriptLocalization()

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 2, 2))

-- Add Altar functions to window
local button_up = layout:addChild(GUI.button(1,1, 8, 3, 0x4B4B4B, 0xE1E1E1, 0xE1E1E1, 0x4B4B4B, 'Up'))
button_up.onTouch = function()
  altar:up()
end

local button_down = layout:addChild(GUI.button(1,1, 8, 3, 0x4B4B4B, 0xE1E1E1, 0xE1E1E1, 0x4B4B4B, 'Down'))
button_down.onTouch = function()
  altar:down()
end
-- Add nice gray text object to layout
--layout:addChild(GUI.text(1, 1, 0x4B4B4B, localization.greeting .. system.getUser()))
layout:setPosition(1,2, layout:addChild(GUI.text(1,1, 0x4B4B4B, 'another line')))
layout:setPosition(2,1, button_up)
layout:setPosition(2,2, button_down)
--layout:setPosition(2,2, layout:addChild(GUI.text(1,1, 0x4B4B4B, 'another line 3')))
-- Customize MineOS menu for this application by your will
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("New")
contextMenu:addSeparator()
contextMenu:addItem("Open")
contextMenu:addItem("Save", true)
contextMenu:addItem("Save as")
contextMenu:addSeparator()
contextMenu:addItem("Close").onTouch = function()
  window:remove()
end

-- You can also add items without context menu
menu:addItem("Example item").onTouch = function()
  GUI.alert("It works!")
end

-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
