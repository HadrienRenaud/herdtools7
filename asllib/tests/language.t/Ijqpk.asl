// RUN: interp %s | FileCheck %s
// CHECK: 10

func main() => integer
begin
    var a: integer = 10;
    var b: real = Real(a);

    println("" ++ b);
    return 0;
end
