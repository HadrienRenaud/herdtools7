// RUN: interp %s | FileCheck %s
// CHECK: 1
// CHECK-NEXT: 2
// CHECK-NEXT: 3

func test() => integer
begin
    println("" ++ 2);
    return 3;
end

func main() => integer
begin
    println("" ++ 1);
    var a = test();
    println("" ++ a);
    return 0;
end
