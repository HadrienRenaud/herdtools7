// RUN: interp %s | FileCheck %s
// CHECK: 0

func main() => integer
begin
    var a: integer;
    println("" ++ a);
    return 0;
end
