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
-- 更新缓存
local UpdateCache = nil
-- 计时器
local UpdateTimer = nil
-- 时间间隔
local TimeInterval = nil
local NowTime = nil
local useCache = false

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

function RedDotController.Init(nodeConfig, useCache)
    this.useCache = useCache
    UpdateCache = useCache and {} or nil
    UpdateTimer = useCache and this.StartTimer() or nil
    TimeInterval = useCache and 1 or nil
    NowTime = useCache and 0 or nil

    -- 配置文件读取
    coroutine.resume(
            coroutine.create(
                    function()
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
            )
    )
end

function RedDotController.UpdateRedDot(redDotType)
    if this.useCache and not table.ContainValue(UpdateCache, redDotType) then
        table.insert(UpdateCache, redDotType)
    else
        this._UpdateRedDot({ redDotType })
    end
end

---@private
function RedDotController._UpdateRedDot(cache)
    if type(cache) ~= "table" or (type(cache) == "table" and #cache == 0) then
        return
    end
    coroutine.resume(
            coroutine.create(
                    function()
                        for i = 1, #cache do
                            repeat
                                -- 没有则进行下一个
                                local leafs = leafCollection[cache[i]]
                                if not leafs or (leafs and #leafs == 0) then
                                    break
                                end

                                for j = 1, #leafs do
                                    local calc = RedDotController[leafs[j].CalcMethod]
                                    if calc and type(calc) == "function" then
                                        leafs[j].ShowRedDot = calc()
                                    end

                                    if leafs[j].ShowRedDot then
                                        -- 向上冒泡至根节点
                                        local parentNode = leafs[j].ParentNode
                                        while parentNode and not parentNode.ShowRedDot do
                                            parentNode.ShowRedDot = true
                                            parentNode = parentNode.ParentNode
                                        end
                                    end
                                end
                            until true
                        end
                    end
            )
    )
end

function RedDotController.ResolveRedDot(redDotType, NodeName)
    if not leafCollection[redDotType] or string.IsNullOrEmpty(NodeName) then
        return
    end
    for i = 1, #leafCollection[redDotType] do
        if leafCollection[redDotType][i].NodeName == NodeName then
            local node = leafCollection[redDotType][i]
            node.ShowRedDot = false

            local parentNode = node.ParentNode
            local showRed = false
            while parentNode do
                showRed = false
                for j = 1, #parentNode.ChildNode do
                    if parentNode.ChildNode[j] then
                        showRed = parentNode.ChildNode[j].ShowRedDot
                    end
                end
                parentNode.ShowRedDot = showRed
                if parentNode.ShowRedDot then
                    return
                end
                parentNode = parentNode.ParentNode
            end
        end
    end
end

--region Timer

function RedDotController.StartTimer()
    if this.UpdateTimer then
        return
    end
    -- TODO 根据不同的热更新框架来开启计时器
end

function RedDotController.StopTimer()
    if not this.UpdateTimer then
        return
    end
    -- TODO 根据不同的热更新框架来停止计时器
end

function RedDotController.TimerFunction()
    -- TODO 计时相关逻辑
    if #UpdateCache == 0 then
        return
    end
    this._UpdateRedDot(UpdateCache)
    UpdateCache = {}
    NowTime = 0
end

--endregion

--region 红点检测相关方法

--function RedDotController.Example()
--    return true and false
--end

--endregion

--region Test
function RedDotController.GetTree()
    return Root, leafCollection
end
--endregion