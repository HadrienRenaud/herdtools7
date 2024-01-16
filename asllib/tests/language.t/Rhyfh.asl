// RUN: interp %s | FileCheck %s
// CHECK: 10
// CHECK-NEXT: 10
// CHECK-NEXT: 10
// CHECK-NEXT: 10
// CHECK-NEXT: 10
// CHECK-NEXT: 10

func main() => integer
begin
    println("" ++ 10);
    println("" ++ 1_0);
    println("" ++ 0xa);
    println("" ++ 0xA);
    println("" ++ 0xA_);
    println("" ++ 0x0a);

    return 0;
end
