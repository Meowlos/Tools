require "Utils"
require "SimpleMessageDispatcher.SimpleMsgDispatcher"
require "RedDotController.RedDotNode"

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
-- 根节点名称
local ROOT_NODE_NAME = "MainRoot"
-- 节点分隔符
local SEPARATOR = "/"


--region Local function

local function PathToNode(nodePath)
    if string.IsNullOrEmpty(nodePath) then
        LogWithStackInfo("节点路径错误")
        return
    end
    local paths = nodePath:Split(SEPARATOR)
    if paths[1] ~= ROOT_NODE_NAME then
        LogWithStackInfo(
                string.format(
                        "请确认该节点路径是否填写正确\n%s",
                        nodePath
                )
        )
        return
    end

    ---@type
    local parentNode = Root
    for i = 1, #paths do
        local node = nil
        if i == 1 then
            node = Root
        elseif parentNode then
            node = parentNode.ChildNode[paths[i]]
        end

        if not node then
            -- 创建节点
            ---@type RedDotNode
            node = RedDotNode:New(paths[i])
            if i == 1 and not Root then
                -- 设置根节点
                Root = node
            end
        end
        node:SetParent(parentNode)
        if parentNode then
            parentNode:AddChild(paths[i], node)
        end
        parentNode = node
    end
    return parentNode
end

--endregion

function RedDotController.Init(nodeConfig)
    -- 配置文件读取
    for i = 1, #nodeConfig do
        if not leafCollection[nodeConfig[i].RedDotType] then
            leafCollection[nodeConfig[i].RedDotType] = {}
        end
        for j = 1, #nodeConfig[i].Node do
            local leafNode = PathToNode(nodeConfig[i].Node[j].Path)
            leafNode:SetCalcMethod(nodeConfig[i].Node[j].CalcMethod)
            table.insert(leafCollection[nodeConfig[i].RedDotType], leafNode)
        end
    end
end

--region Test
function RedDotController.GetTree()
    return Root, leafCollection
end
--endregion