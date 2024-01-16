// RUN: interp %s | FileCheck %s
// CHECK-NOT: 10

// This is a comment and should not be passed

// var a: integer = 10;

func main() => integer
begin
    // println("" ++ a);
    return 0;
end
