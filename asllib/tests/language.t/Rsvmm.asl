// RUN: interp %s | FileCheck %s
// CHECK: 2
// CHECK-NEXT: -2

func main() => integer
begin
    println("" ++ fdiv_int(6, 3));
    println("" ++ fdiv_int(-5, 3));
    return 0;
end
