// RUN: interp %s | FileCheck %s
// CHECK: 10
// CHECK-NEXT: 20

var a = (10, 20);

func main() => integer
begin
    println("" ++ a.item0);
    println("" ++ a.item1);

    return 0;
end
