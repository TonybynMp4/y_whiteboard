---@class target
---@field coords vector3
---@field rotation number
---@field size vector3

---@class whiteboard
---@field jobs table<string, boolean>
---@field jobTypes table<string, boolean>
---@field coords vector3
---@field zone vector3[]
---@field target table<string, target>
---@field txd string
---@field txn string
---@field url string | nil nil to reset the whiteboard

return {
    ---@type table<string, whiteboard>
    rooms = {
        -- Example room in the default mission row mapping
        {
            jobs = {
                police = true,
                sheriff = true
            },
            jobTypes = {
                leo = true
            },
            coords = vec3(439.44, -985.89, 35.17),
            zone = {
                vec3(436.25, -996.21, 31.0),
                vec3(436.33, -990.03, 31.0),
                vec3(443.5, -989.99, 31.0),
                vec3(444.15, -996.57, 31.0)
            },
            target = {
                coords = vec3(436, -993.5, 31.25),
                rotation = 90,
                size = vec3(2.5, 0.25, 2)
            },
            txd = "hei_prop_hei_muster_01",
            txn = "script_rt_planning",
            url = nil
        },
    }
}