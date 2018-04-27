import Protocols.NATPMP;

object config = Config();
object system_module = SystemTypes.SmartOS(config);
string addr;
int keep_trying;
int shutting_down;

Stdio.UDP port;

class Config {
  string upstream_interface = "net0";
  string downstream_interface = "eth0";
}

int main(int argc, array(string) argv) {
  werror("NAT-PMP server starting.\n");
  
  addr = get_if_address(config->downstream_interface);
  if(!addr) {
    fatal("Unable to determine IPv4 address for " + config->downstream_interface + ".");
  }

  port = Stdio.UDP();
  port->bind(NATPMP_SERVER_PORT, addr);
  port->enable_broadcast();
  port->set_nonblocking();
  port->set_read_callback(got_packet);

  signal(signum("INT"), do_shutdown);
  signal(signum("QUIT"), do_shutdown);
  return -1;
}

void do_shutdown() {
  werror("Shut down in progress.\n");
  keep_trying = 0;
  shutting_down = 1;
//  call_out(begin_release, 0, 0);
  call_out(exit, 5, 0);
}

void fatal(string message, int|void retcode) {
  werror("FATAL: %s\n", message);
  exit(retcode||1);
}


string get_if_address(string v4if) {

  mapping ifs = NetUtils.local_interfaces();

  foreach(ifs; string iface; array addrs) {
    if(iface == v4if || has_prefix(iface, v4if + ":")) {
      foreach(addrs;; string addr) {
      addr = (addr/"/")[0];
       if(NetUtils.get_network_type(addr, 1) == "localhost") return addr;
      }
    }
  }
 
  return 0;
}

void got_packet(mapping data, mixed ... args) {
  werror("got_packet(%O, %O)\n", data, args);
  object x = decode_message(data->data);
}

void send(Message message, string dest, int port) {
  string m = message->encode();
  werror("sending message: %O -> %O to %O on port %d\n", message, m, dest, port);
//  last_message_type = message->message_type;
  port->send(dest, port, m);
}
