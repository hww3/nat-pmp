constant version = 0;
constant operation = -1;

inherit ADT.struct;

protected variant void create(void|string(8bit) s) {
  ::create(s);
  decode();
}


protected void decode() {
  decode_body(this);
}

protected void decode_body(Stdio.Buffer buf) {  
}


protected void encode_body(Stdio.Buffer buf) {
}

string encode() {
  clear();

  add_int8(version);
  add_int8(operation);

  encode_body(this);
  return read();
}
