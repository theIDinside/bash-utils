import gdb

class Residence(gdb.Command):
    def __init__(self):
        super(Residence, self).__init__("residence", gdb.COMMAND_USER)

    def invoke(self, args, from_tty):
        args = gdb.string_to_argv(args)
        print(f"args was: {args[0]}")
        try:
            addr = int(args[0], 10)
        except Exception as e:
            try:
                addr = int(args[0], 16)
            except:
                raise gdb.GdbError(f"You must pass an address either in decimal or hexadecimal format. You passed {args[0]}")
        try:
            cmd_output = gdb.execute("info proc mappings", to_string=True)
            output = cmd_output.split("\n")[3:]
            start_parsed = False
            if "Start Addr" not in output[0]:
                raise gdb.GdbError("Info proc mappings returned erroneous output for us to parse")
            for line in output[1:]:
                parts = line.strip().split()
                if len(parts) > 4:
                    start = int(parts[0], 16)
                    end = int(parts[1], 16)
                    if addr >= start and addr <= end:
                        print(line)
                        return line
            print(f"Could not find address {addr}")
        except Exception as e:
            print(f"Exception caught {e}. rethrowing")
            raise gdb.GdbError("Command failed")

Residence()
