// RUN: interp %s | FileCheck %s
// CHECK: 0.0

func main() => integer
begin
    var a: real;
    println("" ++ a);
    return 0;
end
