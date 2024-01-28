local Queue
do
  local _class_0
  local _base_0 = {
    push = function(self, ...)
      local _list_0 = {
        ...
      }
      for _index_0 = 1, #_list_0 do
        local V = _list_0[_index_0]
        table.insert(self.List, V)
      end
    end,
    next = function(self)
      return table.remove(self.List, 1)
    end,
    hasNext = function(self)
      return #self.List > 0
    end,
    unshift = function(self, V)
      return table.insert(V, 1)
    end,
    isEmpty = function(self)
      return not self:hasNext()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.List = { }
    end,
    __base = _base_0,
    __name = "Queue"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Queue = _class_0
  return _class_0
end