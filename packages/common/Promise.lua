local isCallable
isCallable = function(O)
  if 'function' == type(O) then
    return true
  end
  local MT = getmetatable(O)
  if 'table' == type(MT) then
    return 'function' == type(MT.__call)
  end
end
local Promise
do
  local _class_0
  local _base_0 = {
    Transition = function(self, State, Value)
      if self.State == State or self.State ~= self.__class.State.PENDING or Value == nil or (State ~= self.__class.State.FULFILLED and State ~= self.__class.State.REJECTED) then
        return 
      end
      self.State = State
      self.Value = Value
      return self:Update()
    end,
    Reject = function(self, Reason)
      return self:Transition(self.__class.State.REJECTED, Reason)
    end,
    Fulfill = function(self, Value)
      return self:Transition(self.__class.State.FULFILLED, Value)
    end,
    Update = function(self)
      if self.State == self.__class.State.PENDING then
        return 
      end
      local F = self.__class.Async or function(V)
        return table.insert(self.__class.Queue, V)
      end
      return F(function()
        local I = 0
        while I < #self.Queue do
          I = I + 1
          local Operation = self.Queue[I]
          local Success, Result = pcall(function()
            Success = Operation.Resolved or function(x)
              return x
            end
            local Failure = Operation.Rejected or function(x)
              return error(x)
            end
            local Callback = self.State == self.__class.State.FULFILLED and Success or Failure
            return Callback(self.Value)
          end)
          if Success then
            self:Resolve(Result)
          else
            self:Reject(Result)
          end
        end
        for J = 1, I do
          self.Queue[J] = nil
        end
      end)
    end,
    Process = function()
      while true do
        local Operation = table.remove(Promise.Queue, 1)
        if not Operation then
          break
        end
        Operation()
      end
    end,
    Resolve = function(self, Value)
      if self == Value then
        return self:Reject('TypeError: Cannot resolve a promise with itself')
      end
      if 'table' ~= type(Value) then
        return self:Fulfill(Value)
      end
      if Value.IsPromise then
        if Value.State == self.__class.State.PENDING then
          return Value:next((function()
            local _base_1 = self
            local _fn_0 = _base_1.Resolve
            return function(...)
              return _fn_0(_base_1, ...)
            end
          end)(), (function()
            local _base_1 = self
            local _fn_0 = _base_1.Reject
            return function(...)
              return _fn_0(_base_1, ...)
            end
          end)())
        end
        return self:Transitition(Value.State, Value.Value)
      end
      return self:Fulfill(Value)
    end,
    next = function(self, Resolved, Rejected)
      local Next = self.__class()
      table.insert(self.Queue, (function()
        do
          local _with_0 = { }
          if isCallable(Resolved) then
            _with_0.Resolved = Resolved
          end
          if isCallable(Rejected) then
            _with_0.Rejected = Rejected
          end
          _with_0.Promise = Next
          return _with_0
        end
      end)())
      self:Update()
      return Next
    end,
    catch = function(self, Callback)
      return self:next(nil, Callback)
    end,
    all = function(...)
      local Promises = {
        ...
      }
      local Results = { }
      local State = Promise.State.FULFILLED
      local Remaining = #Promises
      local Next = Promise()
      local Check
      Check = function()
        if Remaining > 0 then
          return 
        end
        return Promise.Transition(Next, State, Results)
      end
      for I, P in pairs(Promises) do
        local Resolved
        Resolved = function(Value)
          Results[I] = Value
          Remaining = Remaining - 1
          return Check()
        end
        local Rejected
        Rejected = function(Reason)
          Results[I] = Value
          Remaining = Remaining - 1
          State = Promise.State.REJECTED
          return Check()
        end
        P:next(Resolved, Rejected)
      end
      Check()
      return Next
    end,
    race = function(...)
      local Promises = {
        ...
      }
      local Next = Promise()
      Promise.all(...):next(nil, function(V)
        return Promise.Reject(Next, V)
      end)
      local Success
      Success = function(V)
        return Promise.Fulfill(Next, V)
      end
      for _index_0 = 1, #Promises do
        local P = Promises[_index_0]
        P:next(Success)
      end
      return Next
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, Callback)
      self.State = self.__class.State.PENDING
      self.Queue = { }
      self.IsPromise = true
      if Callback then
        return Callback((function()
          local _base_1 = self
          local _fn_0 = _base_1.Resolve
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(), (function()
          local _base_1 = self
          local _fn_0 = _base_1.Reject
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
      end
    end,
    __base = _base_0,
    __name = "Promise"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.State = {
    PENDING = 0,
    FULFILLED = 1,
    REJECTED = 2
  }
  self.Async = function(F)
    return coroutine.wrap(F)()
  end
  self.Queue = { }
  Promise = _class_0
  return _class_0
end