// RUN: interp %s | FileCheck %s
// CHECK: 4
// CHECK-NEXT: -4
// CHECK-NEXT: 4

func main() => integer
begin
    var a: integer{4..10};
    var b: integer{-10..-4};
    var c: integer{-10..-4, 4..10};

    println("" ++ a);
    println("" ++ b);
    println("" ++ c);

    return 0;
end
