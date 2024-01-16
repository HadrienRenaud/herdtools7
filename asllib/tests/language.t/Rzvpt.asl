// RUN: interp %s | FileCheck %s
// CHECK: 0x0

func main() => integer
begin
    var a: bits(32);
    println("" ++ a);
    return 0;
end
