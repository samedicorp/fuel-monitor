-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--  Created by Samedi on 31/08/2022.
--  All code (c) 2022, The Samedi Corporation.
-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

-- When setting up from JSON (or manually):
-- Link the screen, core, and fuel tanks to the controller.
-- Add the following handler to the screen onOutputChanged event:
--     local failure = modula:call("onScreenReply", output)
--     if failure then
--         error(failure)
--     end
--
-- Add the following to all fuel tanks onContentChanged event:
--      local failure = modula:call("onContentUpdate")
--      if failure then 
--          error(failure)
--      end


local Module = { }

function Module:register(parameters)
    modula:registerForEvents(self, "onStart", "onStop", "onContainerChanged")
end

-- ---------------------------------------------------------------------
-- Event handlers
-- ---------------------------------------------------------------------

function Module:onStart()
    debugf("Fuel Monitor started.")

    self:attachToScreen()
    local containers = modula:getService("containers")
    if containers then
        containers:findContainers("AtmoFuelContainer", "SpaceFuelContainer")
    end
end

function Module:onStop()
    debugf("Fuel Monitor stopped.")
end

function Module:onContainerChanged(container)
    self.screen:send({ name = container:name(), value = container.percentage })
end

function Module:onScreenReply(reply)
end


-- ---------------------------------------------------------------------
-- Internal
-- ---------------------------------------------------------------------

function Module:attachToScreen()
    -- TODO: send initial container data as part of render script
    local service = modula:getService("screen")
    if service then
        local screen = service:registerScreen(self, false, self.renderScript)
        if screen then
            self.screen = screen
        end
    end
end

Module.renderScript = [[

containers = containers or {}

if payload then
    local name = payload.name
    if name then
        containers[name] = payload
    end
    reply = { name = name, result = "ok" }
end

local screen = toolkit.Screen.new()
local layer = screen:addLayer()
local chart = layer:addChart(layer.rect:inset(10), containers, "Play")

layer:render()
screen:scheduleRefresh()
]]

return Module