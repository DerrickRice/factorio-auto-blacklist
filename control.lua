function dbg_print(msg)
  -- game.players[1].print(msg)
end

function is_filter_inserter(entity)
  return entity ~= nil and entity.type == "inserter" and entity.inserter_filter_mode ~= nil
end

function should_blacklist(inserter)
  -- already blacklisted
  if inserter.inserter_filter_mode == "blacklist" then
    dbg_print('Already blacklisted')
    return false
  end

  -- has a filter of some sort
  for i=1, inserter.filter_slot_count do
    if inserter.get_filter(i) ~= nil then
      dbg_print('Has a filter set')
      return false
    end
  end

  -- uses set-filter logic
  local behavior = inserter.get_control_behavior()
  if behavior ~= nil and behavior.circuit_mode_of_operation == defines.control_behavior.inserter.circuit_mode_of_operation.set_filters then
    dbg_print('Has mode of operation')
    return false
  end

  return true
end

function on_build_event(event)
  local entity = event.created_entity;

  if is_filter_inserter(entity) and should_blacklist(entity) then
    dbg_print('Setting to blacklist')
    entity.inserter_filter_mode = "blacklist"
  end
end

script.on_event(
  {
    defines.events.on_robot_built_entity,
    defines.events.on_built_entity
  },
  on_build_event
)
