local File
do
  local _class_0
  local _base_0 = {
    Load = function(self)
      return error('File.Load: Not implemented')
    end,
    Write = function(self, Content)
      return error('File.Write: Not implemented')
    end,
    Touch = function(self)
      return error('File.Touch: Not implemented')
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, Path)
      self.Path = Path
      self:Load()
      if self.Content == '' or not self.Content then
        return self:Touch()
      end
    end,
    __base = _base_0,
    __name = "File"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  File = _class_0
end
local SerializedFile
do
  local _class_0
  local _parent_0 = File
  local _base_0 = {
    Deserialize = function(self, Content)
      return error('SerializedFile.Deserialize: Not implemented')
    end,
    Serialize = function(self, Content)
      return error('SerializedFile.Serialize: Not implemented')
    end,
    Load = function(self)
      _class_0.__parent.__base.Load(self)
      self.Content = self:Deserialize(self.Content)
    end,
    Write = function(self, Content)
      return _class_0.__parent.__base.Write(self, self:Serialize(Content))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "SerializedFile",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SerializedFile = _class_0
end
local Entry
do
  local _class_0
  local _base_0 = {
    value = function(self)
      return self.Value
    end,
    get = function(self, Key)
      if 'table' ~= type(self.Value) then
        return 
      end
      return self.__class(self.Value[Key], self.Root)
    end,
    unset = function(self, Key)
      return self:set(Key)
    end,
    set = function(self, Key, Value)
      if 'table' ~= type(self.Value) then
        return 
      end
      self.Value[Key] = Value
      return self
    end,
    isArray = function(self)
      if 'table' ~= type(self.Value) then
        return false
      end
      return #(function()
        local _accum_0 = { }
        local _len_0 = 1
        for _, _ in pairs(self.Value) do
          _accum_0[_len_0] = 1
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)() == #self.Value
    end,
    isObject = function(self)
      if 'table' ~= type(self.Value) then
        return false
      end
      return not self:isArray()
    end,
    find = function(self, Props)
      if Props == nil then
        Props = { }
      end
      if 'table' ~= type(self.Value) then
        return 
      end
      local Result = { }
      local Object = self:isObject()
      for K, V in pairs(self.Value) do
        local _continue_0 = false
        repeat
          if 'table' ~= type(V) then
            _continue_0 = true
            break
          end
          if (self.__class(V)):isArray() then
            _continue_0 = true
            break
          end
          local Add = true
          for L, B in pairs(Props) do
            if B ~= V[L] then
              Add = false
              break
            end
          end
          if Add then
            if Object then
              Result[K] = V
            else
              table.insert(Result, V)
            end
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return Result
    end,
    push = function(self, ...)
      if not self:isArray() then
        return 
      end
      local A = {
        ...
      }
      if #A <= 0 then
        return 
      end
      for _index_0 = 1, #A do
        local V = A[_index_0]
        table.insert(self.Value, V)
      end
      return self
    end,
    indexOf = function(self, V)
      if not self:isArray() then
        return 
      end
      if V == nil then
        return 
      end
      for I, O in pairs(self.Value) do
        if O == V then
          return I
        end
      end
    end,
    pluck = function(self, V)
      if not self:isArray() then
        return 
      end
      for I, O in pairs(self.Value) do
        if O == V then
          return table.remove(I)
        end
      end
    end,
    write = function(self)
      return self.Root:write()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, Value, Root)
      self.Value, self.Root = Value, Root
    end,
    __base = _base_0,
    __name = "Entry"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entry = _class_0
end
local Database
do
  local _class_0
  local _parent_0 = Entry
  local _base_0 = {
    write = function(self)
      return self.Adapter:Write(self.Value)
    end,
    default = function(self, T)
      if self.Adapter.Empty then
        self.Value = T
      end
      return self
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, FileAdapter)
      self.FileAdapter = FileAdapter
      self.Root = self
      self.Adapter:Load()
      do
        local _with_0 = self.Adapter
        self.Value = _with_0.Content
        _with_0.Content = nil
        return _with_0
      end
    end,
    __base = _base_0,
    __name = "Database",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Database = _class_0
end
return {
  File = File,
  SerializedFile = SerializedFile,
  Database = Database
}