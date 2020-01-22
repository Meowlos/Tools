require "Utils"
require "SimpleMessageDispatcher.SimpleMsgDispatcher"

RedDotController = {}
local this = RedDotController
--[[
    叶子节点集合
    从叶子节点往上冒泡至根节点
    leafCollection = {
        ["redDotType"] = {
            [1] = RedDotNode
        }
    }
--]]
local leafCollection = {}
-- 根节点
local Root = nil

function RedDotController.Init()
    -- TODO 配置文件读取
end


