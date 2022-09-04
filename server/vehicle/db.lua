local MySQL = MySQL

MySQL.ready(function()
    MySQL.query('UPDATE vehicles SET stored = ? WHERE stored IS NULL', { 'impound' })
end)

local db = {}

local DELETE_VEHICLE = 'DELETE FROM vehicles WHERE id = ?'
---Removes a vehicle from the database with the given id.
---@param id number
function db.deleteVehicle(id)
    MySQL.prepare(DELETE_VEHICLE, { id })
end

local INSERT_VEHICLE = 'INSERT INTO vehicles (plate, owner, model, class, data, stored) VALUES (?, ?, ?, ?, ?, ?)'
---Creates a new database entry and returns the vehicleId.
---@param plate string
---@param owner number | boolean | nil
---@param model string
---@param class number
---@param data table
---@param stored string?
---@return number?
function db.createVehicle(plate, owner, model, class, data, stored)
    return MySQL.prepare.await(INSERT_VEHICLE, { plate, owner, model, class, json.encode(data), stored })
end

local PLATE_EXISTS = 'SELECT 1 FROM vehicles WHERE plate = ?'
---Check if a plate is already in use.
---@param plate string
---@return boolean
function db.isPlateAvailable(plate)
    return not MySQL.scalar.await(PLATE_EXISTS, { plate })
end

local SELECT_VEHICLE = 'SELECT owner, plate, model, data FROM vehicles WHERE id = ? AND stored IS NOT NULL'
---Fetch vehicle data for the given id.
---@param id number
function db.getVehicleFromId(id)
    return MySQL.prepare.await(SELECT_VEHICLE, { id })
end

local UPDATE_STORED = 'UPDATE vehicles SET stored = ? WHERE id = ?'
function db.vehicle.setStored(stored, id)
---@param stored string?
---@param id number
function db.setStored(stored, id)
    MySQL.prepare(UPDATE_STORED, { stored, id })
end

local UPDATE_VEHICLE = 'UPDATE vehicles SET plate = ?, stored = ?, data = ? WHERE id = ?'
---Update vehicle data for one or multiple vehicles.
---@param parameters { [number]: any } | { [number]: any }[]
function db.updateVehicle(parameters)
    MySQL.prepare(UPDATE_VEHICLE, parameters)
end

return db
