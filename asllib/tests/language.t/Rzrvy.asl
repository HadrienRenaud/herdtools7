// RUN: interp %s | FileCheck %s
// CHECK: hello
// CHECK-NEXT: wor"ld
// CHECK-NEXT: te\st
// CHECK-NEXT: bre
// CHECK-NEXT: ak

func main() => integer
begin
    println("hello");
    println("wor\"ld");
    println("te\\st");
    println("bre\nak");
    return 0;
end
