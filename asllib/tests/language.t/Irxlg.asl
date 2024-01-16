// RUN: interp %s | FileCheck %s
// CHECK: FALSE
// CHECK-NEXT: TRUE
// CHECK-NEXT: 0x5
// CHECK-NEXT: 0x4
// CHECK-NEXT: 0x2
// CHECK-NEXT: 0x1
// CHECK-NEXT: 0x1


func main() => integer
begin
    var a : bits(3) = '101';
    var b : bits(3) = '100';

    println("" ++ (a == b)); // Legal
    println("" ++ (a != b)); // Legal
    println("" ++ (a OR b)); // Legal
    println("" ++ (a AND b)); // Legal
    println("" ++ (NOT a)); // Legal
    println("" ++ (a EOR b)); // Legal
    println("" ++ (a + b)); // Legal
    println("" ++ (a - b)); // Legal

    return 0;
end
