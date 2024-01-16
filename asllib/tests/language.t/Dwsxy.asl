// RUN: interp %s | FileCheck %s
// CHECK: 1
// CHECK-NEXT: 2

func main() => integer
begin
    var (a, b) = (1, 2);

    println("" ++ a);
    println("" ++ b);

    return 0;
end
