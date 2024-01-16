// RUN: interp %s | FileCheck %s
// CHECK: FALSE
// CHECK-NEXT: TRUE

func main() => integer
begin
    println("" ++ FALSE);
    println("" ++ TRUE);
    return 0;
end
