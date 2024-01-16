// RUN: interp %s | FileCheck %s
// CHECK: 0
// CHECK-NEXT: FALSE

func main() => integer
begin
    var a: (integer, boolean);
    var (b, c) = a;
    println("" ++ b);
    println("" ++ c);
    return 0;
end
