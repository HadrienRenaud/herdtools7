// RUN: interp %s | FileCheck %s
// CHECK: 0
// CHECK-NEXT: 0

func main() => integer
begin
    var a: array[2] of integer;
    println("" ++ a[0]);
    println("" ++ a[1]);
    return 0;
end
