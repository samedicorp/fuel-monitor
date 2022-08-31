-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--  Created by Samedi on 31/08/2022.
--  All code (c) 2022, The Samedi Corporation.
-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

local useLocal = true --export: Use require() to load local scripts if present. Useful during development.
local logging = true --export: Enable controller debug output.

modulaSettings = { 
    name = "Fuel Monitor",
    version = "1.0",
    logging = logging, 
    useLocal = useLocal,
    logElements = true,
    modules = {
        ["samedicorp.fuel-monitor.main"] = { },
        ["samedicorp.modula.modules.screen"] = { },
        ["samedicorp.modula.modules.containers"] = { }
    }, 
    templates = "samedicorp/fuel-monitor/templates"
}


