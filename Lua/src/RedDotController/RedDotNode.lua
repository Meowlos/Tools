require "Utils"

---@class RedDotNode
RedDotNode = {
    NodeName = nil,
    ShowRedDot = false,
    ChildNode = nil,
    ParentNode = nil,
    CalcMethod = nil,
}

---New
---@param name string
---@param parent RedDotNode
function RedDotNode:New(name, parent)
    local obj = {}
    setmetatable(obj, { __index = self })
    obj:Init(name, parent)
    return obj
end

---@private
function RedDotNode:Init(name, parent)
    self.NodeName = name
    self.ShowRedDot = false
    self.ChildNode = {}
    self:SetParent(parent)
    self.CalcMethod = nil
end

---AddChild
---@param childName string
---@param node RedDotNode
function RedDotNode:AddChild(childName, node)
    if not self.ChildNode then
        self.ChildNode = {}
    end
    if string.IsNullOrEmpty(childName) or node == nil then
        return
    end
    if self.ChildNode[childName] then
        print(string.format("已存在相同名称的子节点: %s", childName))
    end
    self.ChildNode[childName] = node
end

---SetParent
---@param parent RedDotNode
function RedDotNode:SetParent(parent)
    if not parent then
        return
    end
    if self.ParentNode then
        print(string.format("%s 的父节点将会从 %s 替换为 %s", self.NodeName, self.ParentNode.NodeName, parent.NodeName))
    end
    self.ParentNode = parent
end

function RedDotNode:SetCalcMethod(calcMethodName)
    if string.IsNullOrEmpty(calcMethodName) then
        LogWithStackInfo("传入了一个错误的方法名")
        return
    end
    self.CalcMethod = calcMethodName
end
