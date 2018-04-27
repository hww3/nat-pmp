inherit .ResponseMessage;

constant operation = 128;

protected variant void create(int _result_code, int _epoch, string _address) {
   ::create(_result_code, _epoch);
   
   address = _address;
}

protected void decode_body(Stdio.Buffer buf) {  
  ::decode_body(buf);

  address = NetUtils.ip_to_string(buff->read_int(4)));
}

protected void encode_body(Stdio.Buffer buf) {
  ::encode_body(buf);
  buff->add_int(NetUtils.string_to_ip(address), 4);
}