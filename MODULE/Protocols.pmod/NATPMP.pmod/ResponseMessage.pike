inherit .Message;

int(16bit) result_code;
int(32bit) seconds_since_reboot;

protected void create(int _result_code, int _epoch) {
  result_code = _result_code;
  seconds_since_reboot = _epoch;
}

protected void decode_body(Stdio.Buffer buf) {  
  result_code = buf->read_int(2);
  seconds_since_reboot = buf->read_int(4);
}


protected void encode_body(Stdio.Buffer buf) {
  buf->add_int(result_code, 2);
  buf->add_int(seconds_since_reboot, 4);
}