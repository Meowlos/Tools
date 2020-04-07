--region Base Require
require("Enumerators")
require("Utils")
--endregion

--region MsgDispatcher 测试
--require "SimpleMessageDispatcher.SimpleMsgDispatcher"
--
---- 初始化随机数种子
--math.randomseed(os.time())
--
--local msgName = { "Msg_1" }
--local guidList = {}
--
----region 生成测试数据
--
-----GenerateMsg
-----@param subscriptCount number 订阅数量
--local function GenerateMsg(subscriptCount)
--    if type(subscriptCount) ~= "number" then
--        subscriptCount = 1
--    end
--
--    for i = 1, #msgName do
--        for j = 1, subscriptCount do
--            local guid = SimpleMsgDispatcher.RegisterMsg(
--                    msgName[i],
--                    function(param)
--                        print("接收到 " .. param[1])
--                    end
--            )
--            table.insert(guidList, guid)
--        end
--    end
--end
--
----endregion
--
----region 测试, 不带GC
--print("-------------- disable GC --------------")
--SimpleMsgDispatcher.Init(false)
--GenerateMsg(1)
--
--for i = 1, 10 do
--    local status = math.random(1, 10)
--    if status == 1 then
--        -- 调度消息
--        local name = msgName[math.random(1, #msgName)]
--        SimpleMsgDispatcher.Dispatch(name, name)
--    elseif #guidList > 0 then
--        -- 注销消息
--        local index = math.random(1, #guidList)
--        local guid = guidList[index]
--        table.remove(guidList, index)
--        print("注销: " .. guid)
--        SimpleMsgDispatcher.UnRegisterMsg(guid)
--    end
--end
----endregion
--SimpleMsgDispatcher.Dispatch(msgName[1], msgName[1])
--SimpleMsgDispatcher.Dispose()
--
----region 测试, 带GC
--print("-------------- enable GC --------------")
--SimpleMsgDispatcher.Init(true)
--GenerateMsg(5)
--for i = 1, 10 do
--    local status = math.random(1, 10)
--    if status == 1 then
--        -- 调度消息
--        local name = msgName[math.random(1, #msgName)]
--        SimpleMsgDispatcher.Dispatch(name, name)
--    elseif #guidList > 0 then
--        -- 注销消息
--        local index = math.random(1, #guidList)
--        local guid = guidList[index]
--        table.remove(guidList, index)
--        print("注销: " .. guid)
--        SimpleMsgDispatcher.UnRegisterMsg(guid)
--    end
--end
--SimpleMsgDispatcher.Dispatch(msgName[1], msgName[1])
----endregion
--
--SimpleMsgDispatcher.Dispose(
--endregion

--region string extension
--local str = "asdfas,asdfas,adffasdfsafdasfd3,123,12311,!@#$!%!#$!@#$!@"
--local result = str:Split()
--for i, v in pairs(result) do
--    print(v)
--end

print(string.IsNullOrEmpty(nil))
print(string.IsNullOrEmpty(""))
print(string.IsNullOrEmpty(true))
print(string.IsNullOrEmpty(1))
print(string.IsNullOrEmpty("1"))
print(string.IsNullOrEmpty(" "))
--endregion

--region RedDotController Test
require "RedDotController.RedDotController"

--local redDotData = {
--    [1] = {
--        RedDotType = ERedDotType.Normal,
--        Node = {
--            [1] = {
--                Path = "MainRoot/Root_1",
--                CalcMethod = "M_1",
--            }
--        }
--    }
--}
--
--RedDotController.Init(redDotData)
--local root, leaf = RedDotController.GetTree()
--print("Done")

--endregion