// RUN: interp %s | FileCheck %s
// CHECK: 10.0
// CHECK-NEXT: 10.0
// CHECK-NEXT: 10.0
// CHECK-NEXT: 10.0
// CHECK-NEXT: 10.0
// CHECK-NEXT: 10.0

func main() => integer
begin
    println("" ++ 10.0);
    println("" ++ 1_0.0);
    println("" ++ 10.0_);
    println("" ++ 10.00);
    println("" ++ 10_.0);
    println("" ++ 10.0_0);

    return 0;
end
