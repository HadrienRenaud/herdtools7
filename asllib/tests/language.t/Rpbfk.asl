// RUN: interp %s | FileCheck %s
// CHECK: 0x0
// CHECK-NEXT: 0xF
// CHECK-NEXT: 0x0

func main() => integer
begin
    println("" ++ '0000');
    println("" ++ '1111');
    println("" ++ '0 0 0 0');
    return 0;
end
