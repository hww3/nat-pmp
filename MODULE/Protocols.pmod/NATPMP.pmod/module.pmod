constant NATPMP_SERVER_PORT = 5351;
constant NATPMP_CLIENT_PORT = 5350;

mapping(int:program) operation_type_mapping = ([]);

protected void create() {
  foreach(values(Protocols.NATPMP);; mixed p) {
    if(!programp(p)) continue;
    if(Program.inherits(p, .Message) && p->operation)
      operation_type_mapping[p->operation] = p;
  }
}

.Message decode_message(string(8bit) s) {
  if(sizeof(s) < 2) { 
    throw(Error.Generic("Invalid NAT-PMP message. Must be at least 2 bytes in length.\n"));
  }
  int version = s[0];
  if(version != 0) throw(Error.Generic("Invalid NAT-PMP message version: " + version + ".\n"));
  int operation = s[1];
  program p = get_message_for_operation(operation);
  if(!p) throw(Error.Generic("Unable to find a registered operation for " + operation + ".\n"));

  return p(s[1..]);
}

program get_message_for_operation(int operation) {
  return operation_type_mapping[operation];
}
