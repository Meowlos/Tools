require("Utils")

SimpleMsgDispatcher = {}
local this = SimpleMsgDispatcher

--[=[
    msgPool = {
        ["MessageName"] = {
            Count = 0,
            [guid] = function() end,
            [guid] = function() end,
        }
    }
--]=]
local msgPool = {}
--[=[
    remappingTable = {
        [guid] = "msgName"
    }
--]=]
local remappingTable = {}
local enableGC = true
local gcCoroutine = nil
local isInit = false

--region init

---初始化
---@param gc boolean
function SimpleMsgDispatcher.Init(gc)
    if isInit then
        error("尝试多次初始化 SimpleMsgDispatcher")
        return
    end
    isInit = true
    if type(gc) ~= "boolean" then
        gc = true
    end
    msgPool = {}
    remappingTable = {}
    enableGC = gc
    if enableGC then
        gcCoroutine = coroutine.create(SimpleMsgDispatcher.GC)
    end
end

function SimpleMsgDispatcher.Dispose()
    if not isInit then
        return
    end
    isInit = false
    enableGC = false
    if gcCoroutine then
        gcCoroutine = nil
    end
    msgPool = {}
    remappingTable = {}
end

--endregion

--region 消息注册与取消

---注册消息监听
---@param msgName string 消息名
---@param callBack function 回调函数
function SimpleMsgDispatcher.RegisterMsg(msgName, callBack)
    if string.IsNullOrEmpty(msgName) then
        error("无法注册一个消息名为空的消息")
        return
    end
    if type(callBack) ~= "function" then
        error("第二个参数不为 function ")
        return
    end

    if not msgPool[msgName] then
        msgPool[msgName] = {
            Count = 0,
        }
    end

    local guid = GetGUID()
    remappingTable[guid] = msgName
    msgPool[msgName][guid] = callBack
    msgPool[msgName].Count = msgPool[msgName].Count + 1
    return guid
end

---取消消息监听
---@param guidArray table 消息guid
function SimpleMsgDispatcher.UnRegisterMsg(guidArray)
    if type(guidArray) ~= "table" then
        guidArray = { guidArray }
    end
    local guid
    for i = 1, #guidArray do
        guid = guidArray[i]
        if not remappingTable[guid] then
            return
        end
        this._UnRegisterMsg(remappingTable[guid], guid)
        remappingTable[guid] = nil
    end
    if enableGC then
        coroutine.resume(gcCoroutine)
    end
end

---@private
---@param msgName string 消息名字
---@param ID string 唯一标识符
function SimpleMsgDispatcher._UnRegisterMsg(msgName, ID)
    if string.IsNullOrEmpty(msgName) or string.IsNullOrEmpty(ID) then
        return
    end
    if not msgPool[msgName] then
        return
    end
    msgPool[msgName][ID] = nil
    msgPool[msgName].Count = msgPool[msgName].Count - 1
end
--endregion

--region Message Dispatch

---调度
---@param msgName string 消息名
function SimpleMsgDispatcher.Dispatch(msgName, ...)
    if string.IsNullOrEmpty(msgName) then
        return
    elseif (enableGC and not msgPool[msgName]) or (not enableGC and msgPool[msgName].Count == 0) then
        return
    end

    local args = { ... }
    for k, v in pairs(msgPool[msgName]) do
        if k ~= "Count" then
            v(args)
        end
    end
end

--endregion

--region GC

---@private
function SimpleMsgDispatcher.GC()
    if not enableGC then
        return
    end
    while true do
        local removeMsg = {}
        for i, v in pairs(msgPool) do
            if not v.Count or (v.Count and v.Count == 0) then
                table.insert(removeMsg, i)
            end
        end
        for i = 1, #removeMsg do
            msgPool[removeMsg[i]] = nil
        end
        coroutine.yield()
    end
end
--endregion