// RUN: interp %s | FileCheck %s
// CHECK: TRUE
// CHECK-NEXT: FALSE
// CHECK-NEXT: FALSE
// CHECK-NEXT: TRUE


func main() => integer
begin
    println("" ++ FALSE <-> FALSE);
    println("" ++ FALSE <-> TRUE);
    println("" ++ TRUE <-> FALSE);
    println("" ++ TRUE <-> TRUE);

    return 0;
end
