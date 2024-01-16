// RUN: interp %s | FileCheck %s
// CHECK: 0xFFFF
// CHECK-NEXT: 0xFFFF

func main() => integer
begin
    println("" ++ '1111 1111 1111 1111');
    println("" ++ '1111111111111111');
    return 0;
end
