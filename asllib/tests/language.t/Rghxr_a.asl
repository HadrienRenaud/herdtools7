// RUN: interp %s | FileCheck %s
// CHECK: 0
// CHECK-NEXT: 1

func main() => integer
begin
    println("" ++ frem_int(6, 3));
    println("" ++ frem_int(-5, 3));
    return 0;
end
