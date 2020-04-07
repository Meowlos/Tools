--region Table 扩展
function table.ToString(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. table.ToString(k) .. "]=" .. table.ToString(v) .. ","
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. table.ToString(k) .. "]=" .. table.ToString(v) .. ","
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

function table.GetKeys_byAscending(t)
    local result = {}
    if type(t) ~= "table" then
        return result
    end
    for k, v in pairs(t) do
        table.insert(result, k)
    end
    table.sort(result)
    return result
end

function table.ContainValue(t, value)
    for i = 1, #t do
        if t[i] == value then
            return true
        end
    end
    return false
end

function table.ContainKey(t, key)
    for i, v in pairs(t) do
        if i == key then
            return true
        end
    end
    return false
end

function table.Count(t)
    local count = 0
    for i, v in pairs(t) do
        count = count + 1
    end
    return count
end

--endregion

--region string 扩展
--- 字符串是否为空
function string.IsNullOrEmpty(str)
    if str == nil or (type(str) == "string" and #str == 0) then
        return true
    end
    return false
end

--- 字符串分割
function string:Split(separator)
    if string.IsNullOrEmpty(separator) then
        error(string.format("传入的分隔符不正确: %s", separator))
        return {}
    end
    local result = {}
    string.gsub(
            self,
            string.format("[^%s]+", separator),
            function(match)
                table.insert(result, match)
            end
    )
    return result
end

--- 将字节序列转换为字符串, 不适用于 UTF8 环境
function string.Bytes2String(bytes)
    local chars = {}

    local index = 1
    repeat
        if bytes[index] <= 128 then
            -- ASCII 字符
            table.insert(chars, string.char(bytes[index]))
            index = index + 1
        elseif bytes[index] >= 194 and bytes[index] <= 223 then
            table.insert(chars, string.char(bytes[index], bytes[index + 1]))
            index = index + 2
        elseif bytes[index] >= 224 and bytes[index] <= 239 then
            table.insert(chars, string.char(bytes[index], bytes[index + 1], bytes[index + 2]))
            index = index + 3
        elseif bytes[index] >= 240 and bytes[index] <= 244 then
            table.insert(chars, string.char(bytes[index], bytes[index + 1], bytes[index + 2], bytes[index + 3]))
            index = index + 4
        else
            print("Unknown: " .. bytes[index])
            index = index + 1
        end
    until index > #bytes

    return table.concat(chars)
end

function string.Trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

--endregion

--region GUID
local guidSeed = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" }
function GetGUID()
    local t = {}
    for i = 1, 32 do
        table.insert(t, guidSeed[math.random(1, 16)])
    end
    local tc = table.concat(t)
    return string.format(
            "%s-%s-%s-%s-%s",
            string.sub(tc, 1, 8),
            string.sub(tc, 9, 12),
            string.sub(tc, 13, 16),
            string.sub(tc, 17, 20),
            string.sub(tc, 21, 32)
    )
end

--endregion

--region Debug

function LogWithStackInfo(msg)
    print(string.format("%s\n%s", msg, debug.traceback()))
end

--endregion