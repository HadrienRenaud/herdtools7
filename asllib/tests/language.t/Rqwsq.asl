// RUN: interp %s | FileCheck %s
// CHECK: 0
// CHECK-NEXT: 0
func main() => integer
begin
    var a: (integer, integer);
    var (b, c) = a;
    println("" ++ b);
    println("" ++ c);
    return 0;
end
