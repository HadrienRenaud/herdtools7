// RUN: interp %s | FileCheck %s
// CHECK: 5
// CHECK-NEXT: 5
// CHECK-NEXT: 5

func a(aa: integer)
begin
    println("" ++ aa);
end

func main() => integer
begin
    var bb = 5;
    println("" ++ bb);
    a(bb);
    println("" ++ bb);
    return 0;
end
