cfg = require 'cfg'

local M = {}

function getSubstructureOrder(personality)
    return cfg.substructureOrders[personality%24]
end

M.getSubstructureOrder = getSubstructureOrder
return M