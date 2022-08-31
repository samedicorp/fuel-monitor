-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--  Created by Samedi on 31/08/2022.
--  All code (c) 2022, The Samedi Corporation.
-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

-- Add the following handler to the screen:
--     local failure = modula:call("onScreenReply", output)
--     if failure then
--         error(failure)
--     end



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
        printf("blah")
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

local toolkit = require('samedicorp.toolkit.toolkit')
local Layer = require('samedicorp.toolkit.layer')
local Chart = require('samedicorp.toolkit.chart')
local layer = Layer.new()

local rect = layer.rect:inset(10)
local chart = Chart.new(rect, containers, "Play")
layer:addWidget(chart)

layer:render()

rate = layer:scheduleRefresh()
]]

return Module