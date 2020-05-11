module dutils.random;

import std.file : read;
import std.uuid : UUID;

ubyte[] randomBytes(size_t size = size_t.max) {
  return cast(ubyte[]) read("/dev/urandom", size);
}

unittest {
  auto result = randomBytes(10);
  assert(result.length == 10, "Length of ubyte[] should be 10");
}

char[] randomHex(size_t size = size_t.max) {
  return hexString(randomBytes(size / 2));
}

unittest {
  auto result = randomHex(20);
  assert(result.length == 20, "Length of hex string should be 20");
}

UUID randomUUID() {
  const uuidData = cast(string) read("/proc/sys/kernel/random/uuid", 36);
  return UUID(uuidData);
}

unittest {
  auto result = randomUUID();
  assert(result.empty() == false, "UUID should not be empty");
}

//
// Including simple+efficient ubyte2hex converter
// from https://forum.dlang.org/post/opsfp9hj065a2sq9@digitalmars.com
//
private const char[16] hexdigits = "0123456789abcdef";

private char[] hexString(ubyte[] d) {
  char[] result;

  /* No point converting an empty array now is there? */
  if (d.length != 0) {
    ubyte u;
    uint sz = u.sizeof * 2; /* number of chars required to represent one 'u' */
    uint ndigits = 0;

    /* pre-allocate space required. */
    result = new char[sz * d.length];

    /* start at end of resulting string, loop back to start. */
    for (int i = cast(int) d.length - 1; i >= 0; i--) {
      /*this loop takes the remainder of u/16, uses it as an index
            into the hexdigits array, then does u/16, repeating
            till u == 0
            */
      u = d[i];
      for (; u; u /= 16) {
        /* you can use u & 15 or u % 16 below
                both give you the remainder of u/16
                */
        result[result.length - 1 - ndigits] = hexdigits[u & 15];
        ndigits++;
      }

      /* Pad each value with 0's */
      for (; ndigits < (d.length - i) * sz; ndigits++) {
        result[result.length - 1 - ndigits] = '0';
      }
    }
  }

  return result;
}

unittest {
  import std.conv : parse;

  auto bytes = cast(ubyte[]) "12345678901234567890123456789012";
  auto result = hexString(bytes);

  assert(result.length == bytes.length * 2, "Length of hex should be twice of the original ubyte[]");
}
