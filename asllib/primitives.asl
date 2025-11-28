pure func UInt{N}(x: bits(N)) => integer {0..(2^N)-1}
begin return 0; end;

pure func SInt{N} (x: bits(N))
  => integer{(if N == 0 then 0 else -(2^(N-1))) .. (if N == 0 then 0 else (2^(N-1))-1)}
begin return 0; end;

pure func DecStr(x: integer) => string
begin return ""; end;

pure func HexStr(x: integer) => string
begin return ""; end;

pure func AsciiStr(x: integer) => string
begin return ""; end;

pure func FloorLog2(x: integer) => integer
begin return 0; end;

pure func RoundDown(x: real) => integer
begin return 0; end;

pure func RoundUp(x: real) => integer
begin return 0; end;

pure func RoundTowardsZero(x: real) => integer
begin return 0; end;

