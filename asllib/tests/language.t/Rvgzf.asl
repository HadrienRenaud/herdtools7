// RUN: interp %s | FileCheck %s
// CHECK: 80
// CHECK-NEXT: 96
// CHECK-NEXT: 3
// CHECK-NEXT: 6

func main() => integer
begin
    println("" + shiftleft_int(10, 3));
    println("" + shiftleft_int(3, 5));
    println("" + shiftright_int(100, 5));
    println("" + shiftright_int(50, 3));
    return 0;
end
